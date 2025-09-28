USE Recroot;
GO

--Procedure for HR to update an application's status
CREATE PROCEDURE sp_HR_UpdateApplicationStatus
    @ApplicationID VARCHAR(15),
    @NewStatus VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Application
        SET applicationStatus = @NewStatus
        WHERE applicationID = @ApplicationID;

        IF @@ROWCOUNT = 0
            RAISERROR('Application ID not found.', 16, 1);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO