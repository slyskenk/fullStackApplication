USE Recroot;
GO

-- Procedure for an applicant to apply for a job
CREATE PROCEDURE sp_Applicant_ApplyForJob
    @ApplicantID VARCHAR(15),
    @JobVacancyID VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @NewApplicationID VARCHAR(15);
            SET @NewApplicationID = dbo.fn_GenerateNewID('APL');

            IF @NewApplicationID IS NULL THROW 50002, 'Failed to generate a new Application ID.', 1;

            -- The triggers for deadline and uniqueness checks will fire automatically.
            INSERT INTO Application (applicationID, applicantID, jobVacancyID)
            VALUES (@NewApplicationID, @ApplicantID, @JobVacancyID);
        COMMIT TRANSACTION;

        SELECT @NewApplicationID as NewApplicationID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
