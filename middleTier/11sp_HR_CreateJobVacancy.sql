USE Recroot;
GO

--Procedure for HR to create a new job vacancy
CREATE PROCEDURE sp_HR_CreateJobVacancy
    @PositionID VARCHAR(15),
    @JobDescription TEXT,
    @Qualifications TEXT,
    @Deadline DATE,
    @Openings INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @NewJobVacancyID VARCHAR(15);
        SET @NewJobVacancyID = dbo.fn_GenerateNewID('JV');

        IF @NewJobVacancyID IS NULL THROW 50003, 'Failed to generate a new Job Vacancy ID.', 1;

        INSERT INTO JobVacancy(jobVacancyID, positionID, jobDescription, qualifications, deadline, openings)
        VALUES (@NewJobVacancyID, @PositionID, @JobDescription, @Qualifications, @Deadline, @Openings);

        SELECT @NewJobVacancyID AS NewJobVacancyID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO