# Automated Control Testing, Data Pipeline, and Code Review/Validation

This repository contains tools and scripts for:
1. **Automated Control Testing**: Support audit projects through automated control testing, such as full population testing for change management controls.
2. **Data Pipeline**: Automatically extract data from Snowflake and transfer it to Google Sheets for streamlined reporting and analysis.
3. **Code Review and Validation**: Ensure the quality and accuracy of all scripts through a structured code review process and validation checks.

## Table of Contents
1. [Automated Control Testing](#automated-control-testing)
2. [Data Pipeline](#data-pipeline)
3. [Code Review and Validation](#code-review-and-validation)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Contributing](#contributing)
7. [License](#license)

---

## Automated Control Testing

This section of the repository focuses on automating controls testing in audit projects, specifically for change management processes. The automated scripts help audit teams run full population tests, ensuring that all changes in scope are covered without manual sampling.

### Features:
- Full population testing for change management controls.
- Automated identification of change management records.
- Supports various audit projects with customizable control tests.

### Getting Started:
1. Clone the repository and navigate to the `control-testing` folder.
2. Configure the control tests by updating the `config.yaml` file.
3. Run the automation script using:

    ```bash
    python run_control_tests.py
    ```

4. Review the output for detailed control test results.

---

## Data Pipeline

This module automates the data transfer from Snowflake to Google Sheets. It is designed to handle large datasets, providing a seamless way to move data for reporting and analysis.

### Features:
- Extract data from Snowflake tables using SQL queries.
- Transform and clean data if necessary.
- Load the data into a specified Google Sheet using the Google Sheets API.

### Setup:
1. Ensure you have access to your Snowflake account and Google Sheets API credentials.
2. Install required Python libraries:

    ```bash
    pip install -r requirements.txt
    ```

3. Set up Snowflake and Google Sheets credentials by updating the `config.py` file.
4. Run the pipeline:

    ```bash
    python data_pipeline.py
    ```

---

## Code Review and Validation

All code in this repository undergoes a strict code review and validation process to ensure its accuracy, reliability, and security.

### Review Process:
1. All new features and changes must be reviewed through pull requests.
2. Peer reviewers assess code for:
   - Correctness
   - Efficiency
   - Security risks
   - Adherence to coding standards

### Validation:
- Automated tests validate functionality after code changes.
- Manual reviews ensure code accuracy for audit-sensitive logic.

### Running Code Validation:
1. Install the testing dependencies:

    ```bash
    pip install pytest
    ```

2. Run the test suite to validate code:

    ```bash
    pytest tests/
    ```

---

## Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/yourusername/yourrepo.git
    cd yourrepo
    ```

2. Install the necessary dependencies:
    ```bash
    pip install -r requirements.txt
    ```

3. Update configuration files (`config.yaml`, `config.py`) with relevant credentials and settings.

---

## Usage

To use the repository’s features, refer to the specific sections above. 

For automated control testing:
```bash
python run_control_tests.py
