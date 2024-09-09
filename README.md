# Dental Office Simulation - 2021 Course Project

This repository contains the final project for the *Algorithms and Data Structures* course taken during the second semester of 2021. The project is a dental office simulation for patients with health insurance, developed in FreePascal, and includes management of patient records and consultations using random-access files and binary search trees.

## Structure

- **Patient Records**: Stores patient information, including full name, address, city, DNI, date of birth, phone number, health insurance name, member number, and a logical status for deletion.
- **Consultations Records**: Stores consultations with details such as DNI, date, and treatments (an array containing code and description).

## Features

### Patient Management
- **Add, Remove, Modify, and Query** patient records.
- Use of binary search trees for ordering patients by DNI and by full name.

### Consultation Management
- **Add and Query** consultations.
- List consultations sorted by date.
- List consultations for a specific patient sorted by date.

### Reports and Statistics
- View patient details along with their consultations.
- Print a report for health insurance submission.
- Generate statistics:
  - Number of consultations between two dates.
  - Number of consultations per health insurance.
  - Monthly consultation percentage breakdown.
  - Average daily consultations.
  - Percentage of consultations for patients from another city.

## How to Run the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/juanfra18/pascal_project.git
   ```
2. Compile and run the project in FreePascal.

## Requirements
- FreePascal (Lazarus IDE)
