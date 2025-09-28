USE Recroot;
GO

--Batch procedure with a cursor
--Procedure to automatically close expired job vacancies.
CREATE PROCEDURE sp_Admin_CloseExpiredVacancies
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @JobID VARCHAR(15);
    DECLARE @Deadline DATE;

    PRINT 'Starting job vacancy cleanup process...';

    --Declare the cursor to select open vacancies that are past their deadline
    DECLARE vacancy_cursor CURSOR FOR
        SELECT jobVacancyID, deadline
        FROM JobVacancy
        WHERE vacancyStatus = 'Open' AND deadline < CAST(GETDATE() AS DATE);

    OPEN vacancy_cursor;

    --Fetch the first row
    FETCH NEXT FROM vacancy_cursor INTO @JobID, @Deadline;

    --Loop through all the expired vacancies
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            PRINT 'Closing vacancy ' + @JobID + ' with deadline ' + CONVERT(VARCHAR, @Deadline, 23);

            --Update the status to 'Closed'
            UPDATE JobVacancy
            SET vacancyStatus = 'Closed'
            WHERE jobVacancyID = @JobID;

        END TRY
        BEGIN CATCH
            PRINT '!!! FAILED to close vacancy ' + @JobID + '. Error: ' + ERROR_MESSAGE();
            --Continue to the next record even if one fails
        END CATCH

        --Fetch the next row
        FETCH NEXT FROM vacancy_cursor INTO @JobID, @Deadline;
    END

    --Close and deallocate the cursor
    CLOSE vacancy_cursor;
    DEALLOCATE vacancy_cursor;

    PRINT 'Job vacancy cleanup process finished.';
END;
GO