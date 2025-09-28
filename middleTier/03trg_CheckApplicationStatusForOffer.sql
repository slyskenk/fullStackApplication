USE Recroot;
GO
--Rule 2: Job offers are only given to successful applicants
CREATE TRIGGER trg_CheckApplicationStatusForOffer
ON Offer
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        --If applicant is not at offer stage, can not receive a job offer
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN Application a ON i.applicationID = a.applicationID
            WHERE a.applicationStatus <> 'Offer Stage'
        )
        BEGIN
            RAISERROR ('A job offer can only be made to an applicant whose status is ''Offer Stage''. Update application status first.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
