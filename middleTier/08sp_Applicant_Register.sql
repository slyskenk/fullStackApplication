USE Recroot;
GO


--Procedure for a new applicant to register
CREATE PROCEDURE sp_Applicant_Register
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(60),
    @PasswordHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @NewApplicantID VARCHAR(15);
            SET @NewApplicantID = dbo.fn_GenerateNewID('APP');

            IF @NewApplicantID IS NULL THROW 50001, 'Failed to generate a new Applicant ID.', 1;

            INSERT INTO Applicant (applicantID, firstName, lastName, email, passwordHash)
            VALUES (@NewApplicantID, @FirstName, @LastName, @Email, @PasswordHash);
        COMMIT TRANSACTION;

        SELECT @NewApplicantID AS NewApplicantID; --Return the new ID
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;