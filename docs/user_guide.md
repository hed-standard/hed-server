# HED online tools user guide

This guide provides comprehensive instructions for using the HED web-based tools and REST API services for validation, transformation, and analysis of HED annotations.

## Brief HED introduction

HED (Hierarchical Event Descriptors) is a standardized vocabulary and annotation framework designed to systematically describe events in experimental data, particularly neuroimaging and behavioral data. HED tags are comma-separated path strings that describe what happened, when it happened, and other relevant properties of experimental events as well as other experimental metadata.

For example, a HED annotation describing the display of a face image might look like:

```hed
Sensory-event, Visual-presentation, (Image, Face)
```

HED is integrated into major neuroimaging standards:

- [BIDS](https://bids.neuroimaging.io/) (Brain Imaging Data Structure)
- [NWB](https://www.nwb.org/) (Neurodata Without Borders)

### What are HED online tools?

HED online tools provide both a web-based interface and REST API services for working with HED annotations and schemas. The application is built using Flask and offers easy access to HED operations without requiring programming knowledge. The application is deployed via a Docker container.

#### Web interface

The browser-based interface provides:

- **Form-based operations**: Easy-to-use forms for common HED tasks
- **File upload support**: Handle various file formats (TSV, CSV, Excel, JSON)
- **Real-time validation**: Immediate feedback on HED annotation validity
- **Download results**: Get processed files and validation reports
- **No login required**: Free to use for everyone

Two deployments are available:

- **Production** ([hedtools.org/hed](https://hedtools.org/hed)): Stable release based on PyPI packages
- **Development** ([hedtools.org/hed_dev](https://hedtools.org/hed_dev)): Latest features from GitHub

#### REST API

The REST API provides programmatic access to the operations:

- **Service endpoints**: Full access to HED operations
- **JSON communication**: Standard REST API with JSON request/response format
- **Batch processing**: Handle multiple files and operations efficiently
- **Integration ready**: Easy to integrate with other tools and workflows

Example implementations are available in the [hed-matlab](https://github.com/hed-standard/hed-matlab) repository.

### Key features

#### Processing tabular files (TSV)

- **Validation**: Validate HED annotations in tabular files, with and without JSON metadata
- **Assembly**: Combine JSON sidecar and tabular data into complete annotations
- **Search**: Find rows matching specific HED criteria
- **Template generation**: Create JSON sidecar templates from tabular files
- **Remodeling**: Transform or summarize tabular data using remodeling operations

#### Sidecar operations (JSON)

- **Validation**: Ensure sidecar files meet HED requirements
- **Conversion**: Convert between short and long tag forms
- **Spreadsheet extraction**: Export to 4-column spreadsheet for easier editing
- **Spreadsheet merging**: Import annotations from spreadsheets back to JSON

JSON sidecars contain HED annotations and metadata for BIDS datasets.

#### Spreadsheet processing

- **Column validation**: Validate HED data in specific spreadsheet columns
- **Format conversion**: Convert between short and long tag forms
- **Flexible formats**: Support for both TSV and Excel I/O

Spreadsheets provide a convenient way to develop HED annotations outside of specific datasets.

#### String operations

- **Quick validation**: Validate individual HED strings
- **Format conversion**: Convert between short and long forms
- **Interactive testing**: Test annotations during development

String operations are useful for quick checks and learning HED syntax.

#### Schema operations

- **Schema validation**: Check HED schema files for compliance
- **Format conversion**: Convert between XML, MEDIAWIKI, and TSV formats
- **Schema comparison**: Compare different schema versions
- **Metadata extraction**: Extract information and statistics from schemas

HED schemas define the structure and vocabularies for HED annotations.

### Use cases

#### For researchers

- Validate HED annotations during BIDS or NWB dataset preparation
- Convert between tag formats for better readability
- Generate sidecar templates to streamline annotation
- Test annotations interactively during development

#### For annotators

- Use spreadsheet workflow for easier editing
- Validate annotations frequently to catch errors early
- Use short tag form not full paths
- Access tools without installing software

#### For developers

- Integrate HED validation into data processing pipelines
- Batch process multiple files programmatically
- Validate annotations as part of CI/CD workflows
- Build custom tools on top of HED services

#### For schema developers

- Validate schema syntax and compliance
- Convert between formats for different purposes
- Compare schema versions to track changes
- Test schema modifications before release

## Getting started

### Accessing HED online tools

HED web-based tools are available directly through a browser at [https://hedtools.org/hed](https://hedtools.org/hed). These tools are free to use and don't require a login. Two versions are available:

- **Production**: [https://hedtools.org/hed](https://hedtools.org/hed) - Stable release version
- **Development**: [https://hedtools.org/hed_dev](https://hedtools.org/hed_dev) - Latest development features

### Tool organization

The HED browser-based tools are organized into the following pages:

| Tool             | URL                                           | Description                                                                 |
| ---------------- | --------------------------------------------- | --------------------------------------------------------------------------- |
| **Events**       | [link](https://hedtools.org/hed/events)       | Validation, summary, search, and generation tools for tabular (.tsv) files  |
| **Sidecars**     | [link](https://hedtools.org/hed/sidecars)     | Validation, transformation, extraction, and merging tools for JSON sidecars |
| **Spreadsheets** | [link](https://hedtools.org/hed/spreadsheets) | Validation and transformation tools for spreadsheet files                   |
| **Strings**      | [link](https://hedtools.org/hed/strings)      | Quick validation and transformation of individual HED strings               |
| **Schemas**      | [link](https://hedtools.org/hed/schemas)      | Validation, conversion, and comparison tools for HED schemas                |

### Common features

#### Schema selection

Most tools require you to specify a HED schema version. You can:

- **Select a standard version**: Use the pull-down menu to choose from official HED releases
- **Upload a custom schema**: Select "Other" and upload your own HED schema file

The tool automatically caches standard schemas for faster processing.

#### Tag formats

HED supports three tag formats:

- **Short form**: Only the leaf node (e.g., `Red`)
- **Long form**: Full path from root (e.g., `Property/Sensory-property/.../Red`)
- **Intermediate form**: Partial path (e.g., `Color/Red`)

All HED tools handle any combination of these formats. The short form is recommended for annotation.

#### Definition expansion

Many tools have an `Expand defs` option that replaces `Def/xxx` tags with expanded definitions in the form `(Def-expand/xxx, yyy)` where `yyy` is the actual definition content.

#### Tabular formats

Tabular files are BIDS-style tab-separated value (.tsv) files with a header line giving column names. These columns map to metadata in accompanying JSON sidecars. HED handles two types of tabular files -- files that have an `onset` column (timeline files) and those that don't (descriptive files). The BIDS `_events.tsv` files are the most common timeline files. An example of a descriptive file is the BIDS `participants.tsv` file.

#### Limiting errors

Most of the validation actions have an option to limit the errors. Checking this option results in the error report only reporting two of each type of error. This is useful because often the same error is repeated for each error of the tabular file and fixing it once (usually a sidecar problem), fixes them all. Once you correct all the errors with the limit errors on and the check for warnings off, you should try again with the limit errors off and the check for warnings on to make sure that you have understood and corrected all issues.

## Working with tabular files

Events files are BIDS-style tab-separated value (`.tsv`) files with a header line giving column names. These columns map to metadata in accompanying JSON sidecars.

### Validate an events file

Validates HED annotations in a BIDS events file or other tabular file. An excellent annotation strategy is to focus on debugging a single annotation file supported by a JSON sidecar located at the highest possible level. For `_events.tsv`, a JSON sidecar at the top level of a BIDS dataset applies to all `_events.tsv` files in the dataset -- so debugging one file and its sidecar essentially debugs them all.

**Steps:**

1. Select the `Validate` action
2. Enable `Check for warnings` if you want to include warnings (don't on the first pass)
3. Enable `Limit errors reported` so that at most 2 of each type of error appear in output (only at first)
4. Upload a tabular file (`.tsv`)
5. Optionally upload a JSON sidecar file (`.json`)
6. Select the HED version
7. Click the `Process` button

**Returns:** A downloadable `.txt` file of error messages if errors are found.

**Note:** This tool validates a single tabular file. For full BIDS dataset validation with inherited sidecars and library schemas, use the [JavaScript HEDTools](https://www.hedtags.org/hed-javascript) which has a browser-based validator that works on the entire dataset. However, from a practical viewpoint, it is better to debug a single file first.

### Check HED quality

Evaluates the HED annotations in a BIDS events file or other tabular file for correct semantic usage.

**Steps:**

1. Select the `Check HED quality` action
2. Disable `Show detailed errors` (only at first to get a sense of the quality complaints)
3. Enable `Limit errors reported` so that at most 2 of each type of error appear in output (only at first)
4. Upload a tabular file (`.tsv`)
5. Optionally upload a JSON sidecar file (`.json`)
6. Select the HED version
7. Click the `Process` button

**Returns:** A downloadable `.txt` file of quality messages if errors are found.

### Assemble HED annotations

Produces a file with fully assembled HED annotations for each event, combining sidecar and column values.

**Steps:**

1. Select the `Assemble HED annotations` action
2. Enable `Append assembled` if you want a HEDAssembled column added to the tabular file.
3. Enable `Include context` if you want the \`Event-context group with ongoing events included
4. Enable `Replace defs` if you to replace the definitions with their contents
5. Enable `Remove condition and task` if you want condition variables and task groups removed.
6. Upload a tabular file (`.tsv`)
7. Optionally upload a JSON sidecar file (`.json`)
8. Select the HED version
9. Click the `Process` button

**Returns:** A downloadable `.tsv` file with two columns: onset times and assembled HED strings (unless the `Append assembled` option is selected).

### Search HED

Search for events matching specific HED criteria within an events file.

**Steps:**

01. Select the `Search HED` action
02. Enable `Append assembled` if you want a HEDAssembled column added to the tabular file.
03. Enable `Include context` if you want the \`Event-context group with ongoing events included
04. Enable `Replace defs` if you to replace the definitions with their contents
05. Enable `Remove condition and task` if you want condition variables and task groups removed.
06. Upload a tabular file (`.tsv`)
07. Optionally upload a JSON sidecar file (`.json`)
08. Enter the search query
09. Select the HED version
10. Click the `Process` button

**Returns:** A downloadable `.tsv` file containing only the rows matching your search criteria.

### Generate sidecar template

Creates a JSON sidecar template from tabular file, ready to be filled with HED annotations.

**Steps:**

1. Select the `Generate JSON sidecar template` action
2. Upload a tabular file (`.tsv`)
3. Review the column list that appears
4. In the left checkboxes, select columns to include in the template
5. In the right checkboxes, select columns requiring annotations for each individual unique column value
6. Click the `Process` button

**Returns:** A downloadable `.json` sidecar template file.

**Tip:** This action generates a template for an individual tabular file. This is sufficient for most datasets, provided their tabular files are similarly structured. The Python HEDTools [`hedpy extract-sidecar`](https://www.hedtags.org/hed-python/user_guide.html#available-commands) command line tool and the [`extract_json_template.ipynb`](https://github.com/hed-standard/hed-python/blob/main/examples/extract_json_template.ipynb) Jupyter notebook for generating a consolidated template from all of the tabular files of a particular type.

### Execute remodel script

Apply table remodeling operations to transform or summarize events files without programming.

**Steps:**

1. Select the `Execute remodel script` action
2. Enable `Include summaries` if you want summary output
3. Upload a tabular file (`.tsv`)
4. Optionally upload a JSON sidecar file (`.json`)
5. Upload the remodel instructions file (`.json`)
6. Select the HED version
7. Click the `Process` button

**Returns:** A zip archive containing transformed tabular and summaries.

**Tip:** The remodel instructions file contains a series of commands in JSON format that are designed to be run to transform and summarize every designated tabular file in a dataset (e.g., all of the `_events.tsv` files). The online tools only run the remodeling on a single tabular file. This is very useful for validating the instruction file and assuring the transformations are what is desired.

See the [Table remodeler documentation](https://www.hedtags.org/table-remodeler) for details on creating remodel scripts.

## Working with sidecars

BIDS JSON sidecars (files ending in `xxx.json`) contain metadata and HED annotations for the designated files (ending in `xxx.tsv`). See the BIDS [**Inheritance Principle**](https://bids-specification.readthedocs.io/en/stable/common-principles.html#the-inheritance-principle) for a description of how the association is made. A convenient aspect of BIDS inheritance is that users can annotate all of the files of a single type (say `_events.tsv`) by placing a single (`_events.json`) file with the annotations at the top level of the BIDS dataset directory tree.

### Validate a sidecar

Validates HED annotations in a JSON sidecar file.

**Steps:**

1. Select the `Validate` action
2. Enable `Check for warnings` if you want warnings (don't do it to start -- get the errors out first)
3. Upload a JSON sidecar file (`.json`)
4. Select the HED version
5. Click the `Process` button

**Returns:** A downloadable `.txt` file of error messages if errors are found.

**Note:** For sidecars with external definitions or library schemas, use the Python tools for complete validation.

### Convert sidecar to long

Converts all HED tags in a sidecar to long form (full paths).

**Steps:**

1. Select the `Convert to long` action
2. Enable `Expand defs` if you want expanded definitions
3. Upload a JSON sidecar file (`.json`)
4. Select the HED version
5. Click the `Process` button

**Returns:** A downloadable converted `.json` sidecar file.

### Convert sidecar to short

Converts all HED tags in a sidecar to short form (leaf nodes only).

**Steps:**

1. Select the `Convert to short` action
2. Enable `Expand defs` if you want expanded definitions
3. Upload a JSON sidecar file (`.json`)
4. Select the HED version
5. Click the `Process` button

**Returns:** A downloadable converted `.json` sidecar file.

### Extract spreadsheet from sidecar

Exports sidecar content to a 4-column spreadsheet for easier editing.

**Steps:**

1. Select the `Extract HED spreadsheet` action
2. Upload the JSON sidecar file (`.json`)
3. Click the `Process` button

**Returns:** A downloadable `.tsv` spreadsheet with columns: `column_name`, `column_value`, `description`, `HED`.

See the [BIDS Annotation Quickstart](https://www.hedtags.org/hed-resources/BidsAnnotationQuickstart.html) for a tutorial on using this spreadsheet.

### Merge spreadsheet with sidecar

Imports HED annotations from a 4-column spreadsheet back into a JSON sidecar.

**Steps:**

1. Select the `Merge HED spreadsheet` action
2. Toggle `Include description` to include descriptions as HED tags
3. Upload the target JSON sidecar file (`.json`)
4. Upload the spreadsheet (`.tsv` or `.xlsx`)
5. Click the `Process` button

**Returns:** A downloadable merged `.json` sidecar file.

## Working with spreadsheets

Spreadsheet tools support general-purpose HED annotation in Excel (`.xlsx`) or tab-separated (`.tsv`) format, useful when developing annotations outside of specific datasets.

### Validate a spreadsheet

Validates HED tags in spreadsheet columns.

**Steps:**

1. Select the `Validate` action
2. Enable `Check warnings` if you want warnings (usually not to start)
3. Upload a spreadsheet file (`.tsv` or `.xlsx`) - this will trigger worksheet and column name display
4. Select a worksheet (if Excel file with multiple sheets)
5. Check boxes next to columns containing HED tags
6. Upload external definitions (`.json` file) if needed
7. Select the HED version
8. Click the `Process` button

**Returns:** A downloadable `.txt` file of error messages if errors are found.

### Convert spreadsheet to long

Converts all HED tags in selected columns to long form.

**Steps:**

1. Select the `Convert to long` action
2. Enable `Expand defs` if desired
3. Upload a spreadsheet file (`.tsv` or `.xlsx`) - this will trigger worksheet and column name display
4. Select a worksheet (if Excel file with multiple sheets)
5. Check boxes next to columns containing HED tags
6. Upload external definitions (`.json` file) if needed
7. Select the HED version
8. Click the `Process` button

**Returns:** A downloadable spreadsheet with converted HED tags.

### Convert spreadsheet to short

Converts all HED tags in selected columns to short form.

**Steps:**

1. Select the `Convert to short` action
2. Enable `Expand defs` if desired
3. Upload a spreadsheet file (`.tsv` or `.xlsx`) - this will trigger worksheet and column name display
4. Select a worksheet (if Excel file with multiple sheets)
5. Check boxes next to columns containing HED tags
6. Upload external definitions (`.json` file) if needed
7. Select the HED version
8. Click the `Process` button

**Returns:** A downloadable spreadsheet with converted HED tags.

## Working with HED strings

String tools provide quick validation and conversion for individual HED annotations.

### Validate a HED string

Validates a single HED string containing tags and groups.

**Steps:**

1. Select the `Validate` action
2. Toggle `Check warnings` if you want warnings
3. Type or paste your HED string into the text box
4. Upload external definitions (`.json` file) if needed
5. Select the HED version
6. Click the `Process` button

**Returns:** Error messages displayed in the Results box under the definition upload.

### Convert string to long

Converts a HED string to long form (full paths).

**Steps:**

1. Select the `Convert to long` action
2. Type or paste your HED string into the text box
3. Select the HED version
4. Click the `Process` button

**Returns:** Converted string or error messages in the Results box.

### Convert string to short

Converts a HED string to short form (leaf nodes only).

**Steps:**

1. Select the `Convert to short` action
2. Type or paste your HED string into the text box
3. Select the HED version
4. Click the `Process` button

**Returns:** Converted string or error messages in the Results box.

### Search HED strings

Search a HED string.

**Steps:**

1. Select the `Search a HED string` action
2. Type or paste your HED string into the HED string box
3. Type or paste your query into the HED search query box
4. Select the HED version
5. Click the `Process` button

**Returns:** Converted string or error messages in the Results box.

## Working with HED schemas

Schema tools help HED schema developers validate, convert, and compare schemas.

View standard schemas using the [HED Schema Browser](https://www.hedtags.org/hed-schema-browser/).

### Validate a schema

Checks schema syntax and HED-3G compliance.

**Steps:**

1. Select the `Validate` action
2. Toggle `Check warnings` if you want warnings
3. Enter a source schema URL or upload a schema file (`.xml`, `.mediawiki`, or `.json`) or upload a folder containing the `.tsv` files for a schema
4. Click the `Process` button

**Returns:** A downloadable `.txt` file of error messages if errors are found.

### Convert a schema

Converts between any schema format and all the formats:

**Steps:**

1. Select the `Convert schema` action
2. Enter a source schema URL or upload a schema file (`.xml`, `.mediawiki`, or `.json`) or upload a folder containing the `.tsv` files for a schema
3. Click the `Process` button

**Returns:** A downloadable zip file contained the converted schema file in all 4 formats.

**Note:** The conversion produces new versions of the schema in all 4 formats. This makes sure that the input schema can be converted correctly to all 4 formats.

### Compare schemas

Shows differences between two schema versions.

**Steps:**

1. Select the `Compare schemas` action
2. Enter a source schema URL or upload a schema file (`.xml`, `.mediawiki`, or `.json`) or upload a folder containing the `.tsv` files for a schema
3. Enter a comparison schema URL or upload a schema file (`.xml`, `.mediawiki`, or `.json`) or upload a folder containing the `.tsv` files for a schema
4. Click the `Process` button

**Returns:** A downloadable `.txt` file with schema differences in an organized format.

## Using RESTful services

HED provides REST API services for programmatic access to all tools.

### Service setup

1. Send HTTP `GET` request to obtain CSRF token: `https://hedtools.org/hed/services`
2. Extract CSRF token and cookie from response
3. Send HTTP `POST` requests with token to: `https://hedtools.org/hed/services_submit`

See the [web services demos](https://github.com/hed-standard/hed-matlab/tree/main/hedmat/web_services_demos) in the MATLAB HEDTools for implementation examples.

### Request format

All requests are JSON dictionaries with a `service` parameter and additional parameters.

**Example:** Validating a JSON sidecar:

```json
{
    "service": "sidecar_validate",
    "schema_version": "8.4.0", 
    "json_string": "json file text",
    "check_for_warnings": "on"
}
```

### Available services

| Service                | Description                        |
| ---------------------- | ---------------------------------- |
| `get_services`         | Returns list of available services |
| `events_validate`      | Validate BIDS events file          |
| `events_assemble`      | Assemble HED annotations           |
| `events_extract`       | Extract sidecar template           |
| `sidecar_validate`     | Validate JSON sidecar              |
| `sidecar_to_long`      | Convert sidecar to long form       |
| `sidecar_to_short`     | Convert sidecar to short form      |
| `spreadsheet_validate` | Validate spreadsheet               |
| `spreadsheet_to_long`  | Convert spreadsheet to long form   |
| `spreadsheet_to_short` | Convert spreadsheet to short form  |
| `strings_validate`     | Validate HED strings               |
| `strings_to_long`      | Convert strings to long form       |
| `strings_to_short`     | Convert strings to short form      |

### Service parameters

Common parameters:

- `service` (string): Service name
- `schema_version` (string): HED version (e.g., "8.4.0")
- `schema_string` (string): Custom schema as XML string
- `check_for_warnings` (boolean): Include validation warnings
- `expand_defs` (boolean): Expand definition tags
- `events_string` (string): BIDS events file content
- `json_string` (string): JSON sidecar content
- `spreadsheet_string` (string): Spreadsheet content
- `hed_strings` (list): List of HED strings

### Service responses

All services return JSON with:

```json
{
    "service": "service_name",
    "results": {
        "command": "command_executed",
        "command_target": "data_type",
        "data": "result_or_errors",
        "schema_version": "8.4.0",
        "msg_category": "success|warning|failure",
        "msg": "explanation"
    },
    "error_type": "",
    "error_msg": ""
}
```

- Empty `error_type` and `error_msg`: Operation completed otherwise indication of server failure
- `msg_category`: Indicates validation result (success/warning/failure)
- `data`: Contains processed result or validation errors

## Best practices

### For annotation development

1. **Start with templates**: Generate sidecar templates from events or other tabular files
2. **Use spreadsheet workflow**: Extract to spreadsheet, annotate, merge back
3. **Validate frequently**: Check annotations after each change
4. **Test with warnings**: Enable warning checks to catch potential issues after eliminating errors
5. **Always use short form**: Shorter tags are easier to read and maintain

### For schema development

1. **Validate before converting**: Always validate schemas before format conversion
2. **Use MEDIAWIKI for editing**: Easier to read and modify than other formats
3. **Compare versions**: Use comparison tool to track changes between versions
4. **Check warnings**: Schema warnings can indicate potential issues

### For programmatic access

1. **Cache CSRF tokens**: Reuse tokens across multiple requests in a session
2. **Handle errors gracefully**: Check both service errors and validation results
3. **Use specific versions**: Always specify schema versions (ideally the latest) for reproducibility

## Troubleshooting

### Common validation errors

- **Invalid HED tag**

  - Tag not found in specified schema version
  - Check for typos in tag names
  - Verify you're using the correct schema version

- **Comma and parentheses errors**

  - Missing or extra commas in HED string
  - Tags in a group must be comma-separated
  - Groups must be comma-separated
  - Parentheses must match

- **Placeholder errors**

  - Placeholder can only be used in sidecars and definitions
  - Only one placeholder per string

### File format issues

- **Cannot parse file**

  - Ensure TSV files use tabs, not spaces or commas
  - Check for proper UTF-8 encoding
  - Verify JSON files are valid JSON

- **Column not found**

  - A sidecar can have annotations for columns that are not in the .`tsv`
  - A `.tsv` file that has a column not deliberately skipped and not defined in the sidecar generates a warning
  - Column names are case-sensitive

### Schema loading issues

- Check internet connection for downloading standard schemas
- For custom schemas, verify XML/mediawiki format
- Ensure schema file is complete and well-formed

### Service issues

- **CSRF token error**

  - Obtain fresh token from services endpoint
  - Include token in request headers
  - Check that cookie is preserved across requests

- **Service timeout**

  - Large files may timeout on web interface
  - Use Python HEDTools CLI for large datasets or the JavaScript HEDTools for browser-based validation
  - Break operations into smaller batches

### Getting help

- 📖 [HED specification](https://www.hedtags.org/hed-specification)
- � [HED resources](https://www.hedtags.org/hed-resources)
- 🐛 [Report issues](https://github.com/hed-standard/hed-server/issues)
- 📧 [Contact HED team](mailto:hed.maintainers@gmail.com)
