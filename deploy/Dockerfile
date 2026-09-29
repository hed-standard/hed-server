# ---------------------------------------------------------------------------
# Stage 1: build the hedweb wheel.
#
# The build context for this Dockerfile is the full hed-server repo checkout,
# including .git (see deploy.sh and .dockerignore). Only this stage ever sees
# .git: it's needed here so setuptools-scm can compute hedweb's real version
# and commit hash from git history, the same way it would for a PyPI release.
# The final runtime stage below only copies the finished wheel out of this
# stage, so .git and the rest of the build context never reach the image
# that actually gets deployed.
#
# Building a wheel here (instead of running "pip install ." in the runtime
# stage) also means the build backend never runs in a git-less context, so
# it can never silently fall back to a placeholder version and overwrite the
# commit hash with None - which is what used to crash gunicorn on startup.
# ---------------------------------------------------------------------------
FROM python:3.12-slim-bookworm AS builder

WORKDIR /build

# setuptools-scm shells out to the `git` binary to read version/commit info,
# so it must be present in this stage.
RUN apt-get update && apt-get install -y git && \
    pip3 install --upgrade pip wheel

COPY . .

RUN python3 -m pip wheel --no-deps -w /build/dist .

# ---------------------------------------------------------------------------
# Stage 2: the runtime image.
# ---------------------------------------------------------------------------
FROM python:3.12-slim-bookworm

# Set the working directory inside the container
WORKDIR /root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    git \
    musl-dev \
    logrotate \
    libxslt-dev \
    libxml2-dev && \
    pip3 install --upgrade pip

# Install the hedweb wheel built in the previous stage. CACHE_BUST is referenced here as well
# because, while pyproject.toml depends on hedtools by git URL (the HED 8.5.0 transition), this is
# the layer that clones hed-python main: without the bust, an unchanged wheel would reuse a cached
# layer holding an old hed-python commit, and the pypi branch below would keep it.
ARG CACHE_BUST
COPY --from=builder /build/dist/hedweb-*.whl ./
RUN echo "Cache bust: ${CACHE_BUST}" && WHEEL_FILE=$(ls hedweb-*.whl) && \
    pip3 install --no-cache-dir "${WHEEL_FILE}[prod]"

# Copy configuration file for the application
COPY deploy/base_config.py ./config.py

# Install HEDTools (hed-python). HED_INSTALL_SOURCE selects where from:
#   git-main -> hed-python's main branch via git (dev; bleeding edge)
#   pypi     -> released package (prod; default)
# While pyproject.toml depends on hedtools by git URL (until the next hedtools release), the wheel
# install above has already brought in a fresh hed-python main, and the pypi branch below finds
# hedtools>=1.2.0 satisfied and changes nothing: both images run hed-python main. Once pyproject
# returns to a version floor, the pypi branch installs the released package again.
ARG HED_INSTALL_SOURCE=pypi
# Referencing CACHE_BUST inside the RUN is what actually invalidates this layer: a changing
# value (deploy.sh passes $(date +%s)) forces a fresh hedtools install instead of reusing a
# cached layer - important for HED_INSTALL_SOURCE=git-main, where each build should pull the
# latest hed-python main.
RUN echo "Cache bust: ${CACHE_BUST}" && \
    if [ "$HED_INSTALL_SOURCE" = "git-main" ]; then \
        echo "Installing hedtools from hed-python's GitHub main branch..."; \
        pip3 install --no-cache-dir git+https://github.com/hed-standard/hed-python.git@main || exit 1; \
    else \
        echo "Installing hedtools from PyPI..."; \
        pip3 install --no-cache-dir "hedtools>=1.2.0" || exit 1; \
    fi

# Create necessary directories and set permissions
RUN mkdir -p /var/log/hedtools && \
    chown -R www-data:www-data /var/log/hedtools && \
    mkdir -p /var/cache/schema_cache && \
    chown -R www-data:www-data /var/cache/schema_cache

# hedweb is installed into site-packages via the wheel. PYTHONPATH=/root is
# only needed so Python can find the top-level config.py module copied in
# above (it isn't part of the hedweb package - it's environment-specific and
# gitignored).
ENV PYTHONPATH="/root"

# Set environment variables for the application
ENV HEDTOOLS_CONFIG_CLASS=config.ProductionConfig

# Copy the logrotate configuration for Gunicorn
COPY deploy/gunicorn-logrotate.conf /etc/logrotate.d/gunicorn

# Expose the Gunicorn port (80 by default)
EXPOSE 80

# Run the Flask application with Gunicorn, binding to port 80.
# hedweb is imported from site-packages (installed from the wheel above).
# Error log goes to stderr ("-") so "docker logs" always captures startup
# failures; access log goes to the persistent file.
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:80", "--forwarded-allow-ips=127.0.0.1", \
     "--access-logfile", "/var/log/hedtools/access.log", \
     "--error-logfile", "-", "--capture-output",\
     "--log-level", "info", "hedweb.runserver:app"]
