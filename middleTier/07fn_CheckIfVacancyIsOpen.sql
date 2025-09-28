USE Recroot;
GO

CREATE FUNCTION dbo.fn_CheckIfVacancyIsOpen (@JobVacancyID VARCHAR(15))
RETURNS BIT
AS
BEGIN
    DECLARE @IsOpen BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM JobVacancy
        WHERE jobVacancyID = @JobVacancyID
        AND deadline >= CAST(GETDATE() AS DATE)
        AND vacancyStatus = 'Open'
    )
    BEGIN
        SET @IsOpen = 1;
    END

    RETURN @IsOpen;
END;
GO