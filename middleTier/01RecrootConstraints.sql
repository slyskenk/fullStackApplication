USE Recroot;
GO

--Rule 1: Applicant can not apply for same vacancy twice 
ALTER TABLE Application
ADD CONSTRAINT UQ_Applicant_Vacancy UNIQUE (applicantID, jobVacancyID);
GO

--Rule 4: Whenever a counter offer takes place the version number will increase to show change in it
--for example: version 1 then after employee sends a counter version 2 etc.

ALTER TABLE Offer
ADD CONSTRAINT UQ_Application_OfferVersion UNIQUE (applicationID, offerVersion);


