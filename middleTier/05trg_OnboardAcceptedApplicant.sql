USE Recroot;
GO
--Rule 5: Applicant becomes employee when accepted
CREATE TRIGGER trg_OnboardAcceptedApplicant
ON Offer
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    --If offer accepted
    IF UPDATE(offerStatus)
    BEGIN
        BEGIN TRY
            --Insert a new employee record if an offer was just changed to 'Accepted'
            INSERT INTO Employee (employeeID, applicantID, positionID, offerID, hireDate)
            SELECT
                --Generate a new employeeID, e.g.by replacing prefix
                CONCAT('EMP', SUBSTRING(app.applicantID, 4, 12)),
                app.applicantID,
                jv.positionID,
                i.offerID,
                GETDATE() --Hire date is the date the offer was accepted
            FROM inserted i
            JOIN deleted d ON i.offerID = d.offerID
            JOIN Application a ON i.applicationID = a.applicationID
            JOIN Applicant app ON a.applicantID = app.applicantID
            JOIN JobVacancy jv ON a.jobVacancyID = jv.jobVacancyID
            WHERE i.offerStatus = 'Accepted' AND d.offerStatus <> 'Accepted'
            AND NOT EXISTS ( --Ensure they are not already an employee
                SELECT 1 FROM Employee e WHERE e.applicantID = app.applicantID
            );
        END TRY
        BEGIN CATCH
            -- Incase of an error during onboarding, log it but don't stop the offer update.
            PRINT 'ERROR: Failed to automatically onboard applicant after offer acceptance.';
            PRINT ERROR_MESSAGE();
        END CATCH
    END
END;
