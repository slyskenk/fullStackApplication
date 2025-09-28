CREATE DATABASE Recroot;


USE Recroot;



CREATE TABLE Department (
    departmentID VARCHAR(15) PRIMARY KEY,
    departmentName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Position (
    positionID VARCHAR(15) PRIMARY KEY,
    departmentID VARCHAR(15) NOT NULL,
    positionTitle VARCHAR(50) NOT NULL,
    FOREIGN KEY (departmentID) REFERENCES Department(departmentID)
);

CREATE TABLE Applicant (
    applicantID VARCHAR(15) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    passwordHash VARCHAR(255) NOT NULL 
);

CREATE TABLE JobVacancy (
    jobVacancyID VARCHAR(15) PRIMARY KEY,
    positionID VARCHAR(15) NOT NULL,
    jobDescription TEXT,
    qualifications TEXT,
    deadline DATE NOT NULL,
    openings INT,
    vacancyStatus VARCHAR(20) NOT NULL DEFAULT 'Open', 
    FOREIGN KEY (positionID) REFERENCES Position(positionID)
);

CREATE TABLE Application (
    applicationID VARCHAR(15) PRIMARY KEY,
    applicantID VARCHAR(15) NOT NULL,
    jobVacancyID VARCHAR(15) NOT NULL,
    timeStamp DATETIME DEFAULT GETDATE(),
    applicationStatus VARCHAR(20) DEFAULT 'Submitted',
    FOREIGN KEY (applicantID) REFERENCES Applicant(applicantID),
    FOREIGN KEY (jobVacancyID) REFERENCES JobVacancy(jobVacancyID)
);

CREATE TABLE HumanResource (
    humanResourceID VARCHAR(15) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL, --Recruiter, Interviewer, HR Manager
    passwordHash VARCHAR(255) NOT NULL
);

CREATE TABLE Interview (
    interviewID VARCHAR(15) PRIMARY KEY,
    applicationID VARCHAR(15) NOT NULL,
    humanResourceID VARCHAR(15) NOT NULL,
    interviewDateTime DATETIME NOT NULL,
    location VARCHAR(255),
    feedback TEXT,
    interviewStatus VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (applicationID) REFERENCES Application(applicationID),
    FOREIGN KEY (humanResourceID) REFERENCES HumanResource(humanResourceID)
);

CREATE TABLE Document (
    documentID VARCHAR(15) PRIMARY KEY,
    applicationID VARCHAR(15) NOT NULL,
    documentType VARCHAR(30),
    filePath VARCHAR(255) NOT NULL,
    submissionDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (applicationID) REFERENCES Application(applicationID)
);

CREATE TABLE Offer (
    offerID VARCHAR(15) PRIMARY KEY,
    applicationID VARCHAR(15) NOT NULL,
    offerVersion INT NOT NULL,
    offeredBy VARCHAR(10) NOT NULL CHECK (offeredBy IN ('Company', 'Applicant')),
    offerDate DATE DEFAULT GETDATE(),
    offerStatus VARCHAR(20) DEFAULT 'Sent',
    salaryOffered DECIMAL(12, 2),
    FOREIGN KEY (applicationID) REFERENCES Application(applicationID)
);

CREATE TABLE Employee (
    employeeID VARCHAR(15) PRIMARY KEY,
    applicantID VARCHAR(15) NOT NULL UNIQUE,
    positionID VARCHAR(15) NOT NULL,
    offerID VARCHAR(15) NOT NULL UNIQUE,
    hireDate DATE NOT NULL,
    FOREIGN KEY (applicantID) REFERENCES Applicant(applicantID),
    FOREIGN KEY (positionID) REFERENCES Position(positionID),
    FOREIGN KEY (offerID) REFERENCES Offer(offerID)
);
