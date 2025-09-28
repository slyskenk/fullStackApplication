USE Recroot;
GO

--Rule 3: Vacancy close after deadline
CREATE TRIGGER trg_CheckVacancyDeadline
ON Application
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        --if any of the  applications are for an expired vacancy
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN JobVacancy jv ON i.jobVacancyID = jv.jobVacancyID
            WHERE jv.deadline < CAST(GETDATE() AS DATE) OR jv.vacancyStatus <> 'Open'
        )
        BEGIN
            --if so, remove it
            RAISERROR ('Application failed. The job vacancy is past its deadline or is no longer open.', 16, 1);
            RETURN;
        END

        --if successfull, submit it
        INSERT INTO Application (applicationID, applicantID, jobVacancyID, timeStamp, applicationStatus)
        SELECT applicationID, applicantID, jobVacancyID, ISNULL(timeStamp, GETDATE()), ISNULL(applicationStatus, 'Submitted')
        FROM inserted;

    END TRY
    BEGIN CATCH
        
        THROW;
    END CATCH
END;
