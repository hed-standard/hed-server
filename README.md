# HED online tools

![Python3](https://img.shields.io/badge/python-%3E=3.10-blue.svg) [![Documentation](https://img.shields.io/badge/docs-hedtags.org-blue.svg)](https://www.hedtags.org/hed-server) [![Maintainability](https://qlty.sh/gh/hed-standard/projects/hed-server/maintainability.svg)](https://qlty.sh/gh/hed-standard/projects/hed-server) [![Code Coverage](https://qlty.sh/gh/hed-standard/projects/hed-server/coverage.svg)](https://qlty.sh/gh/hed-standard/projects/hed-server)

## What is HED?

HED (Hierarchical Event Descriptors) is a framework for systematically describing both laboratory and real-world events. HED tags are comma-separated path strings. The goal of HED is to describe precisely the nature of the events of interest occurring in an experiment using a common structured vocabulary and standardized tools. The HED framework has been developed for neurological imaging data (e.g., EEG, MEG, iEEG, fMRI), physiological (e.g., ECG, EMG, GSR) as well as multimodal experiment (e.g., mobile brain/body imaging). HED has been adopted as part of the BIDS ([**https://bids.neuroimaging.io**](https://bids.neuroimaging.io)) standard for brain imaging and accepted as a standard by the INCF ([**https://www.incf.org**](https://www.incf.org)).

## HED online tools

The HED online tools are a set of web-based applications for validating and analyzing Hierarchical Event Descriptors (HED) annotations. These tools rely on are designed to be used in a web browser and can be deployed locally or from a Docker container.

| Resource              | URL                                                                                      | Description                            |
| --------------------- | ---------------------------------------------------------------------------------------- | -------------------------------------- |
| **HED Tools (PyPI)**  | [https://hedtools.org/hed](https://hedtools.org/hed)                                     | Production version of HED online tools |
| **HED Tools (main)**  | [https://hedtools.org/hed_dev](https://hedtools.org/hed_dev)                             | Latest features, some experimental     |
| **HED Resources**     | [https://www.hedtags.org/hed-resources](https://www.hedtags.org/hed-resources)           | Documentation and tutorials            |
| **API Documentation** | [https://www.hedtags.org/hed-server](https://www.hedtags.org/hed-server)                 | Technical documentation                |
| **GitHub Repository** | [https://github.com/hed-standard/hed-server](https://github.com/hed-standard/hed-server) | Source code and issues                 |

### User Guide

- Quick start, local run, Docker deployment, and reverse proxy setup: see [docs/user_guide.md](docs/user_guide.md).
- Deployment script now supports an optional third parameter to bind host ports (e.g., `127.0.0.1` for localhost-only): `./deploy.sh [branch] [environment] [bind_address]`.

### HED Assistant Widget

The HED online tools include an AI assistant widget powered by the Open Science Assistant (OSA). The widget script is self-hosted at `hedweb/static/js/osa-chat-widget.js`.

- **Source**: https://osa-demo.pages.dev/osa-chat-widget.js
- **Last updated**: 2026-02-10
- **Maintenance**: Check periodically for updates or contact the OSA team

### HED Tools Online

## 

#### HED online tools summary

The following table summarizes the available online tools. The tools are organized around the types of data that the tools handle. The Actions refer to the types of actions that can be performed on the data through the online tools. Each action is linked to its corresponding documentation to provide additional information.

| Data type        | Action                                                                                                         | Description                                                                                                        |
| ---------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Events**       | [Validate](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)                         | Validate HED in a tabular file and its sidecar.                                                                    |
|                  | [Assemble HED annotations](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)         | Return a list of the assembled HED strings for a tabular file.                                                     |
|                  | [Search HED strings](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)               | Return a vector of 0's and 1's based on a HED search query of HED annotation strings extracted from an event file. |
|                  | [Generate JSON sidecar template](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)   | Create a sidecar template from a tabular file.                                                                     |
|                  | [Execute remodel script](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)           | Execute JSON script of [HED remodeling commands](https://www.hedtags.org/table-remodeler/operations/index.html).   |
| **Sidecars**     | [Validate](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)                         | Validate HED in a BIDS JSON sidecar.                                                                               |
|                  | [Convert to long](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)                  | Convert HED tags in a sidecar to full paths.                                                                       |
|                  | [Convert to short](https://www.hedtags.org/hed-server/user_guide.html#validate-an-events-file)                 | Convert HED tags in a sidecar to single tags.                                                                      |
|                  | [Extract HED spreadsheet](https://www.hedtags.org/hed-server/user_guide.html#extract-spreadsheet-from-sidecar) | Create a 4-column spreadsheet from HED in a sidecar.                                                               |
|                  | [Merge HED spreadsheet](https://www.hedtags.org/hed-server/user_guide.html#merge-spreadsheet-with-sidecar)     | Merge HED from spreadsheet into a JSON sidecar.                                                                    |
| **Spreadsheets** | [Validate](https://www.hedtags.org/hed-server/user_guide.html#validate-a-spreadsheet)                          | Validate HED in a spreadsheet (.xlsx or .tsv).                                                                     |
|                  | [Convert to long](https://www.hedtags.org/hed-server/user_guide.html#convert-spreadsheet-to-long)              | Convert HED tags in a spreadsheet to full paths.                                                                   |
|                  | [Convert to short](https://www.hedtags.org/hed-server/user_guide.html#convert-spreadsheet-to-short)            | Convert HED tags in a spreadsheet to single tags.                                                                  |
| **Strings**      | [Validate](https://www.hedtags.org/hed-server/user_guide.html#working-with-hed-strings)                        | Validate a HED string.                                                                                             |
|                  | [Convert to long](https://www.hedtags.org/hed-server/user_guide.html#validate-a-hed-string)                    | Convert a HED string to full paths.                                                                                |
|                  | [Convert to short](https://www.hedtags.org/hed-server/user_guide.html#convert-string-to-short)                 | Convert a HED string to single tags.                                                                               |
|                  | [Search HED strings](https://www.hedtags.org/hed-server/user_guide.html#search-hed-strings)                    | Search a HED string based on a HED search query.                                                                   |
| **Schemas**      | [Validate](https://www.hedtags.org/hed-server/user_guide.html#validate-a-schema)                               | Validate a HED schema.                                                                                             |
|                  | [Convert schema](https://www.hedtags.org/hed-server/user_guide.html#convert-a-schema)                          | Convert a HED schema to other format.                                                                              |
|                  | [Compare HED schemas](https://www.hedtags.org/hed-server/user_guide.html#compare-schemas)                      | Show differences between two HED schemas.                                                                          |

**Events files** are tabular (tab-separated) files. The first row of an events file contains column names. Each subsequent row corresponds to an event marker at a specified time in the corresponding data file.

**Note:** The operations listed for events file apply to any tabular (tab-separated value) file with column names.

**Sidecars** are JSON text files containing metadata. Sidecars follow the requirements of the [BIDS (Brain Imaging Data Structure)](https://bids-specification.readthedocs.io/en/stable/) standard.

**Spreadsheets** contain tabular data in either as an Excel (`.xlsx`) or as a tab-separated (`.tsv`) text file. They are used for convenience in assigning HED tags to event codes.

**Strings** refer to HED annotations, which are entered as strings for quick checks for validity or conversion.

**Schemas** refer to HED schema vocabularies, which may be either in .mediawiki or .xml format. These tools are used by schema developers creating the HED vocabularies and are not of interest to annotators or analysts.

More detailed help on using these online tools is available in the HED online tools [**User guide**](https://www.hedtags.org/hed-server/user_guide.html#).

#### HED REST services

The HED online tools are also available as callable web services. More detailed help on calling these services is available at: [**HED RESTful services**](https://www.hedtags.org/hed-server/user_guide.html#using-restful-services) Downloadable examples of calling these services from a MATLAB program can be found in the GitHub MATLAB [**Web service demos**](https://github.com/hed-standard/hed-matlab/tree/main/hedmat/web_services_demos).

#### Where to find out more?

- The [**HED home page**](https://www.hedtags.org) has links to all things HED.
- The [**HED GitHub organization**](https://github.com/hed-standard) contains the source for code and docs for HED.
- The [**HED schema viewer**](https://www.hedtags.org/hed-schema-browser) allows you to browse HED vocabularies, both released and under development.
- The [**HED resources**](https://www.hedtags.org/hed-resources) has links to all HED documentation.

### Online deployment

The stable version of the HED online tools is available for your use at: [**https://hedtools.org/hed**](https://hedtools.org/hed). An alternate version [**https://hedtools.org/hed_dev**](https://hedtools.org/hed_dev) has the latest features, some of which are experimental.

## Installation

### Local Development Setup

The project uses `pyproject.toml` for dependency management. Install the package with optional dependency groups based on your needs:

**Basic runtime installation** (Flask app + HED tools):

```powershell
pip install -e .
```

**Development installation** (includes code formatting, linting, and testing tools):

```powershell
pip install -e .[dev]
```

**Documentation building**:

```powershell
pip install -e .[docs]
```

**Production deployment** (adds gunicorn for production server):

```powershell
pip install -e .[prod]
```

**Multiple extras** (combine as needed):

```powershell
pip install -e .[dev,docs]
```

### Dependency Groups

- **Base dependencies**: Flask, hedtools, pandas, openpyxl, etc. (required for all installations)
- **`[dev]`**: ruff, typos, coverage, mdformat (for development only)
- **`[prod]`**: gunicorn (for production deployment, not needed for local development)
- **`[docs]`**: sphinx, furo, myst-parser (for building documentation)

**Note**: For local development, you only need `[dev]`. The Flask development server (`python hedweb/runserver.py`) is used instead of gunicorn.

## Testing

**Note**: The following instructions assume you are running in an activated virtual environment.

### Unit Tests

Run the main test suite without requiring external services:

```powershell
# Run all unit tests
python -m unittest discover -s tests -p "test*.py" -v
```

### Service Tests (Integration Tests)

Service tests validate the REST API endpoints by making HTTP requests to a running HED web server.

**Option 1: Automatic (Recommended)**

Use the provided script that starts the server, runs tests, and cleans up automatically:

```powershell
# Run service tests with automatic server management
python service_tests/run_service_tests.py
```

**Option 2: Manual Server Management**\
Start the server in one terminal and run tests in another:

Terminal 1 - Start server:

```powershell
# Run the server at http://127.0.0.1:5000
python hedweb/runserver.py
```

Terminal 2 - Run tests:

```powershell
# Run the tests exercising the server
python -m unittest discover service_tests
```

For more details, see [.status/running-service-tests-locally.md](.status/running-service-tests-locally.md).
