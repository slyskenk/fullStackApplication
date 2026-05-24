# RECROOT Core (fullStackApplication)

A robust database application designed to streamline the recruitment and employee onboarding lifecycle. This repository houses the core backend database architecture and middle-tier services.

## 📋 Core Business Rules

The system architecture enforces a specific set of operational workflows to govern the recruitment process:

* **Single Application Policy:** An applicant is restricted to only one Job Vacany application[cite: 2]. [cite_start]Meaning that an applicant can not re-apply for the same Job Vacancy multiple times[cite: 3].
* **Strict Application Deadlines:** A Job Vacancy closes after due date[cite: 4]. [cite_start]Meaning that after the vacancy date passes, applicants will not be able to apply anymore the respective job vacancies[cite: 5].
* **Digital Salary Negotiations:** HR Submits Salary offer and then applicants can counter as well[cite: 6]. [cite_start]This speeds up the process of negotiation by allowing applicants to digitally counter if not satisfied with an offer or reject the offer flat out[cite: 7].
* **Automated Onboarding:** A Successful Applicant becomes Employee automatically[cite: 8]. [cite_start]After job offer is accepted, the applicant gets on board to becoming an employee[cite: 9].

## 📂 Repository Structure

* `/backend` — Core database architecture, T-SQL scripts, schemas, and relational management.
* `/middleTier` — Middle-tier services and Java-based APIs handling business logic and bridging the database with front-end interfaces.
* `Business Rules.pdf` — Source documentation outlining the system's operational constraints[cite: 1].
* `.gitignore` — Standard Git ignore configurations for the development environment.

## 🛠 Tech Stack

* **Database:** Relational database management (T-SQL).
* **Middle Tier:** API and service layer architecture (Java).
* **Version Control:** Git & GitHub.

## 👨‍💻 Developers

Developed and maintained by Tupopila Kadhila & Slysken Kakuva. 

## 📄 License

This project is licensed under the Apache-2.0 License.
