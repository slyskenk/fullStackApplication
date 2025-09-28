USE Recroot;
GO

--Procedure for HR to make the initial offer
CREATE PROCEDURE sp_HR_MakeOffer
    @ApplicationID VARCHAR(15),
    @SalaryOffered DECIMAL(12, 2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            --First, ensure the application status is correct
            EXEC sp_HR_UpdateApplicationStatus @ApplicationID, 'Offer Stage';

            DECLARE @NewOfferID VARCHAR(15);
            SET @NewOfferID = dbo.fn_GenerateNewID('OFF');

            IF @NewOfferID IS NULL THROW 50004, 'Failed to generate a new Offer ID.', 1;

            --Insert the initial offer (version 1) from the Company
            INSERT INTO Offer(offerID, applicationID, offerVersion, offeredBy, salaryOffered, offerStatus)
            VALUES (@NewOfferID, @ApplicationID, 1, 'Company', @SalaryOffered, 'Sent');

            SELECT @NewOfferID AS NewOfferID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;