IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportGetCreditorFirstMatch')
	BEGIN
		DROP  Procedure  stp_ImportGetCreditorFirstMatch
	END

GO

CREATE Procedure stp_ImportGetCreditorFirstMatch
@CreditorId int = null,
@Name varchar(50),
@Street varchar(50) = null,
@Street2 varchar(50) = null,
@City varchar(50) = null,
@StateId int = null,
@ZipCode varchar(50)
AS
BEGIN
-- Get the first exact match by name and address or creditorid. 
Select Top 1 CreditorId, Name, Street, Street2, City, StateId, ZipCode
From tblCreditor
Where (@CreditorId is null or CreditorId = @CreditorId)
And Ltrim(Rtrim(Name)) = @Name
And isnull(@Street, '') = Ltrim(rtrim(isnull(Street, '')))
And isnull(@Street2, '') = Ltrim(rtrim(isnull(Street2, '')))
And isnull(@City, '') = Ltrim(rtrim(isnull(City, '')))
And isnull(@StateId, 0) = Ltrim(rtrim(convert(varchar, isnull(StateId, 0))))
And isnull(@ZipCode, '') =  Ltrim(rtrim(isnull(ZipCode, ''))) 
END
GO

