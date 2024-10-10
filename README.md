# Internal Audit - Data Analytics - Take Home Exam

This repository is to showcase for the Coinbase Data Analyst Take Home Exam:

---

### 1. Draw an entity-relationship diagram for the data. Indicate the cardinality of the relationships.

This section of the repository focuses on automating controls testing in audit projects, specifically for change management processes. The automated scripts help audit teams run full population tests, ensuring that all changes in scope are covered without manual sampling.

### Features:
- Full population testing for change management controls.
- Automated identification of timestamp sequences.
- Flag any outliers for further investigation.
  
### Getting Started:
Clone the repository and navigate to the `control-testing` folder.

---

## Data Pipeline

This module automates the data transfer from Snowflake to Google Sheets. It is designed to handle large datasets, providing a seamless way to move data for reporting and analysis.

### Features:
- Extract data from Snowflake tables using SQL queries.
- Transform data automatically using shell script.
- Load the data into a specified Google Sheet using Google Apps Script.

### Getting Started:
Clone the repository and navigate to the `data-pipeline` folder.

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
