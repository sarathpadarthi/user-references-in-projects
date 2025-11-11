# 🛠️ Jira Project User Reference Extractor

This project provides a combination of **SQL queries** and a **PowerShell script** designed to extract and collate all user references from a specific Jira project. It is an essential tool for **auditing, migration, or cleanup** efforts by providing a comprehensive list of every user referenced within the project's issues, comments, custom fields, and associations.

-----

## ✨ Features

  * **Comprehensive Extraction:** Extracts user references from all key Jira data sources:
      * `jiraissue` (**reporter, assignee, creator**)
      * `jiraaction` (**author, updateauthor**)
      * `customfieldvalue` (Custom Field User References)
      * `userassociation` (**watchers and voters**)
  * **Unique Collation:** Collates all user keys into a single unique list.
  * **REST API Enrichment:** Fetches complete user details (username, email, display name, active status) using the **Jira REST API**.
  * **Consolidated Output:** Generates a final, easily analyzable file containing all required user information.

-----

## 🚀 Usage

The process involves two main steps: extracting raw user keys via SQL and then collating and enriching the data using the PowerShell script.

### 1\. Extract User References with SQL

You must run the provided SQL queries against your Jira database. **Remember to replace `'pkey here'` with your specific Jira project key.**

| Data Source | Output Filename | Purpose |
| :--- | :--- | :--- |
| `jiraissue` | `JiraIssueUserReferences.csv` | Reporter, Assignee, Creator |
| `jiraaction` | `JiraActionUserReferences.csv` | Comment/Worklog Authors |
| `customfieldvalue` | `CustomfieldUserReferences.csv` | User Picker Custom Fields |
| `userassociation` | `UserActionsUserReferences.csv` | Watchers and Voters |

> **Note:** Each query is structured to ensure you only extract user keys relevant to the specified project.

### 2\. Collate and Fetch User Details with PowerShell

1.  Place all four generated CSV files (`*.csv`) in the **same directory** as the PowerShell script (`Extract-JiraUserReferences.ps1`).

2.  Run the script from that folder:

    ```powershell
    # Run from the folder containing all CSV files
    .\Extract-JiraUserReferences.ps1
    ```

3.  The script will perform the following steps:

      * Validate the presence of all required CSV files.
      * Collate all unique user references.
      * Prompt you for your **Jira server URL** and a **Personal Access Token (PAT)**.
      * Fetch detailed user information for each unique user via the Jira REST API.
      * Output the final results.

-----

## 📄 Output

  * **`UserInfo.txt`**: The final, consolidated list of users, including their **user keys, usernames, emails, display names, and active status**.
  * **`UserReferences.log`**: A log file tracking the script's actions and recording any errors encountered during the API calls.

-----

## ⚙️ Requirements

  * **Jira Database Access:** Required for running the initial SQL queries.
  * **PowerShell Environment:** Required to run the collation script.
  * **Jira REST API Access & PAT:** A **Personal Access Token** is necessary for the script to securely authenticate and fetch user details from the Jira REST API.
