USE Recroot;
GO
--Rule 4: HR Submits Salary offer first.
CREATE TRIGGER trg_EnforceInitialOfferRule
ON Offer
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE offerVersion = 1 AND offeredBy <> 'Company'
        )
        BEGIN
            RAISERROR ('The first offer (version 1) for any application must be made by the Company.', 16, 1);
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
