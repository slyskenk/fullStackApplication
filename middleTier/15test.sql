USE Recroot;
GO

BEGIN TRANSACTION;
    DELETE FROM Employee;
    DELETE FROM Offer;
    DELETE FROM Document;
    DELETE FROM Interview;
    DELETE FROM Application;
    DELETE FROM JobVacancy;
    DELETE FROM HumanResource;
    DELETE FROM Applicant;
    DELETE FROM Position;
    DELETE FROM Department;
COMMIT;
GO

BEGIN TRANSACTION;
BEGIN TRY

    INSERT INTO Department (departmentID, departmentName) VALUES ('DPT-IT', 'Information Technology'), ('DPT-HR', 'Human Resources');
    INSERT INTO Position (positionID, departmentID, positionTitle) VALUES ('POS-DEV', 'DPT-IT', 'Software Developer'), ('POS-DA', 'DPT-IT', 'Data Analyst');


    EXEC sp_Applicant_Register 'John', 'Smith', 'john.smith@email.com', 'hash1';
    EXEC sp_Applicant_Register 'Jane', 'Doe', 'jane.doe@email.com', 'hash2';
    EXEC sp_Applicant_Register 'Peter', 'Jones', 'peter.jones@email.com', 'hash3';
    EXEC sp_Applicant_Register 'Maria', 'Garcia', 'maria.garcia@email.com', 'hash4';
    EXEC sp_Applicant_Register 'Chen', 'Wang', 'chen.wang@email.com', 'hash5';

  
    INSERT INTO HumanResource (humanResourceID, firstName, lastName, email, role, passwordHash) VALUES ('HR01', 'Emily', 'White', 'emily@recroot.com', 'HR Manager', 'hr_hash1');


 
    EXEC sp_HR_CreateJobVacancy 'POS-DEV', 'Develop web apps.', 'T-SQL, C#', '2025-10-30', 2;


    INSERT INTO JobVacancy (jobVacancyID, positionID, deadline, vacancyStatus) VALUES ('JV02', 'POS-DA', '2025-09-01', 'Open');

    COMMIT TRANSACTION;
    PRINT 'data added';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error populating data.'; THROW;
END CATCH
GO


--RULE 1: An applicant is restricted to only one Job Vacancy application.

EXEC sp_Applicant_ApplyForJob @ApplicantID = 'APP000000000002', @JobVacancyID = 'JV000000000001';

--Applicant tries to apply for the SAME JOB VACANCY again. 
BEGIN TRY
    EXEC sp_Applicant_ApplyForJob @ApplicantID = 'APP000000000002', @JobVacancyID = 'JV000000000001';
END TRY
BEGIN CATCH
    PRINT 'SUCCESS: Business Rule 1 successful.';
    PRINT '-> SQL Error: ' + ERROR_MESSAGE();
END CATCH
GO

--RULE 2 Test: Job Vacancy closes after due date.
EXEC sp_Admin_CloseExpiredVacancies;
--Peter Jones tries to apply for the expired vacancy (JV02). 
BEGIN TRY
    EXEC sp_Applicant_ApplyForJob @ApplicantID = 'APP000000000003', @JobVacancyID = 'JV02';
END TRY
BEGIN CATCH
    PRINT 'SUCCESS:Business Rule 2 Successful.';
    PRINT '-> SQL Error: ' + ERROR_MESSAGE();
END CATCH
GO


--RULES 3 & 4: HR Submits Salary offer [first] and then and only then can an applicant reject, accept or counter it

DECLARE @ChensApplicationID VARCHAR(15), @InitialOfferID VARCHAR(15), @CounterOfferID VARCHAR(15);
DECLARE @AppResultTableForRule4 TABLE (NewApplicationID VARCHAR(15));

--Step 1: Chen Wang applies and gets to the offer stage.
INSERT INTO @AppResultTableForRule4
EXEC sp_Applicant_ApplyForJob @ApplicantID = 'APP000000000005', @JobVacancyID = 'JV000000000001';
SELECT @ChensApplicationID = NewApplicationID FROM @AppResultTableForRule4;

EXEC sp_HR_UpdateApplicationStatus @ApplicationID = @ChensApplicationID, @NewStatus = 'Interview Passed'; 


--Step 2 (Rule 3): HR makes the first offer.
DECLARE @OfferResultTable TABLE (NewOfferID VARCHAR(15));
INSERT INTO @OfferResultTable
EXEC sp_HR_MakeOffer @ApplicationID = @ChensApplicationID, @SalaryOffered = 85000;
SELECT @InitialOfferID = NewOfferID FROM @OfferResultTable;


--Step 3 (Rule 3): Chen is not satisfied and makes a counter-offer.
DECLARE @CounterOfferResultTable TABLE (NewCounterOfferID VARCHAR(15));
INSERT INTO @CounterOfferResultTable
EXEC sp_Applicant_CounterOffer @ApplicationID = @ChensApplicationID, @CounterSalary = 92000;
SELECT @CounterOfferID = NewCounterOfferID FROM @CounterOfferResultTable;


--Verify the old offer is now 'Countered'
SELECT offerID, offerVersion, offeredBy, salaryOffered, offerStatus FROM Offer WHERE applicationID = @ChensApplicationID ORDER BY offerVersion;

--Step 4 (Rule 4): The company accepts Chen's counter by updating the status. This triggers onboarding.
UPDATE Offer SET offerStatus = 'Accepted' WHERE offerID = @CounterOfferID;


--Step 5 (Rule 4): Verify Chen is now an employee.

IF EXISTS (SELECT 1 FROM Employee WHERE applicantID = 'APP000000000005')
    PRINT 'SUCCESS: Business Rule 4 and 5 was successful.';
ELSE
    PRINT 'FAILURE: Rule 5 failed. Chen Wang was not added to the Employee table.';

SELECT e.employeeID, a.firstName, p.positionTitle, o.salaryOffered
FROM Employee e
JOIN Applicant a ON e.applicantID = a.applicantID
JOIN Position p ON e.positionID = p.positionID
JOIN Offer o ON e.offerID = o.offerID
WHERE e.applicantID = 'APP000000000005';
GO


