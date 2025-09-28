USE Recroot;
GO



--Function to generate the next available ID for a table based on a prefix.
CREATE FUNCTION dbo.fn_GenerateNewID (@Prefix VARCHAR(3))
RETURNS VARCHAR(15)
AS
BEGIN
    DECLARE @NextID VARCHAR(15);
    DECLARE @LastNumber BIGINT; --Using BIGINT to avoid overflow in the future


    IF @Prefix = 'APP'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(applicantID, 4, 12) AS BIGINT)), 0) FROM Applicant;
    ELSE IF @Prefix = 'JV'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(jobVacancyID, 3, 12) AS BIGINT)), 0) FROM JobVacancy;
    ELSE IF @Prefix = 'HR'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(humanResourceID, 3, 12) AS BIGINT)), 0) FROM HumanResource;
    ELSE IF @Prefix = 'APL'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(applicationID, 4, 12) AS BIGINT)), 0) FROM Application;
    ELSE IF @Prefix = 'INT'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(interviewID, 4, 12) AS BIGINT)), 0) FROM Interview;
    ELSE IF @Prefix = 'DOC'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(documentID, 4, 12) AS BIGINT)), 0) FROM Document;
    ELSE IF @Prefix = 'OFF'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(offerID, 4, 12) AS BIGINT)), 0) FROM Offer;
    ELSE IF @Prefix = 'EMP'
        SELECT @LastNumber = ISNULL(MAX(CAST(SUBSTRING(employeeID, 4, 12) AS BIGINT)), 0) FROM Employee;
    ELSE
        RETURN NULL;

    -- Format the next ID with a 12-digit number
    SET @NextID = @Prefix + FORMAT(@LastNumber + 1, '000000000000');
    RETURN @NextID;
END;
GO