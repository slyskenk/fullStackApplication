USE Recroot;
GO

--Procedure for an applicant to make a counter-offer
CREATE PROCEDURE sp_Applicant_CounterOffer
    @ApplicationID VARCHAR(15),
    @CounterSalary DECIMAL(12, 2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            --Find the most recent offer from the company
            DECLARE @LastOfferID VARCHAR(15);
            DECLARE @LastVersion INT;

            SELECT TOP 1 @LastOfferID = offerID, @LastVersion = offerVersion
            FROM Offer
            WHERE applicationID = @ApplicationID
            ORDER BY offerVersion DESC;

            --Check if an offer even exists
            IF @LastOfferID IS NULL
                THROW 50005, 'No active offer exists for this application to counter.', 1;

            --Update the status of the last offer to 'Countered'
            UPDATE Offer
            SET offerStatus = 'Countered'
            WHERE offerID = @LastOfferID;

            --Insert the applicant's counter-offer as the next version
            DECLARE @NewOfferID VARCHAR(15);
            SET @NewOfferID = dbo.fn_GenerateNewID('OFF');

            INSERT INTO Offer(offerID, applicationID, offerVersion, offeredBy, salaryOffered, offerStatus)
            VALUES (@NewOfferID, @ApplicationID, @LastVersion + 1, 'Applicant', @CounterSalary, 'Sent');

            SELECT @NewOfferID AS NewCounterOfferID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;