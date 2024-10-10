# Internal Audit - Data Analytics - Take Home Exam

This repository is to showcase for the Coinbase Data Analyst Take Home Exam:

The goal of this exercise is to answer a set of questions that are typical of analysts at Coinbase.
Attached is a set of comma-separated files containing data for the following:

Users, including an id, date the user signed up, and their risk score (a number assigned by our internal risk model).
Accounts for those users, including the date the account was created, and currency
Ledger Entries for these accounts; these are single-entry, indicating the date and amount by which the account changed.


---

## Automated Control Testing

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
