# Deployment files

What is in this directory and how the Docker image chooses its hedtools. The full procedure is in [docs/deployment.md](../docs/deployment.md).

- `deploy.sh` - builds the image and runs the container. `deploy.sh <branch> <prod|dev> [bind]` clones hed-server at `<branch>` (or uses the checkout it runs from) and builds with `HED_INSTALL_SOURCE=pypi` for `prod` and `git-main` for `dev`.
- `Dockerfile` - a two-stage build. Stage 1 builds the hedweb wheel from the checkout (it needs `.git` for the version); stage 2 installs the wheel and its dependencies, then hedtools from the chosen source, then copies `base_config.py` to `/root/config.py`.
- `base_config.py` - the configuration the image runs with; environment variables override it.
- `gunicorn-logrotate.conf` - log rotation for the gunicorn access log.

## Where hedtools comes from

`HED_INSTALL_SOURCE` selects the hedtools install in stage 2:

| Value      | Used by          | Installs                                             |
| ---------- | ---------------- | ---------------------------------------------------- |
| `pypi`     | `deploy.sh prod` | `hedtools>=1.2.0` from PyPI (the default)            |
| `git-main` | `deploy.sh dev`  | hed-python main from GitHub, reinstalled every build |

**HED 8.5.0 transition (from 2026-09-28).** `pyproject.toml` depends on hedtools by git URL, so the wheel install in stage 2 already brings in hed-python main before `HED_INSTALL_SOURCE` is consulted. The `pypi` branch then finds `hedtools>=1.2.0` satisfied and installs nothing, so **both images run hed-python main** until the next hedtools release. When that release is out, `pyproject.toml` returns to a version floor and the `pypi` branch installs the released package again; the Dockerfile itself does not change.

During the transition every build, production or dev, clones a fresh hed-python main: `deploy.sh` passes a changing `CACHE_BUST` and the Dockerfile references it in the wheel-install layer (the one that resolves the git dependency) as well as in the hedtools layer, so neither is served from the layer cache.
