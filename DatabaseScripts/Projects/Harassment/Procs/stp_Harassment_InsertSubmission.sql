IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Harassment_InsertSubmission')
	BEGIN
		DROP  Procedure  stp_Harassment_InsertSubmission
	END

GO

CREATE procedure [dbo].[stp_Harassment_InsertSubmission]
(
@ClientID int,
@PersonID int,
@ClientAccountNumber  int,
@ClientState  varchar(4),
@OriginalCreditorID int,
@SuedByCreditor  bit,
@CurrentCreditorID int,
@CreatedBy int,
@NoticeOfRepMailDate datetime,
@NoticeOfCeaseAndDesist datetime,
@CreditorUnAuthorizedCharges  bit,
@IndividualCallingName varchar(200),
@IndividualCallingIdentity varchar(500),
@IndividualCallingPhone varchar(50),
@IndividualCallingNumberDialed varchar(50),
@IndividualCallingDateOfCall datetime,
@IndividualCallingNumTimesCalled numeric,
@IndividualCallingTimeOfCall  varchar(50),
@CreditorAcctID int = null,
@AbuseBeginDate datetime = null,
@EstNumberDailyCalls int = 0,
@DocumentID varchar(500)= null
)
as
BEGIN
/*
stp_Harassment_InsertSubmission 778,12345,6005000,'NY',12345,0,12345,750,'2009-06-05 08:12:29.750','2009-06-05 08:12:29.750',0,'IndividualCallingName','IndividualCallingIdentity','5555555555','5555555555','2009-06-05 08:12:29.750',3,'2009-06-05 08:12:29.750',123456,'4/12/2010',3
*/
	INSERT INTO [tblHarassmentClient] 
	([ClientID],[PersonID],[ClientAccountNumber],[ClientState],[OriginalCreditorID],[SuedByCreditor],[CurrentCreditorID],
	[CreatedBy],[Method], NoticeOfRepMailDate, NoticeOfCeaseAndDesist, CreditorUnAuthorizedCharges, [IndividualCallingName],
	[IndividualCallingIdentity],[IndividualCallingPhone],[IndividualCallingDateOfCall],[IndividualCallingNumTimesCalled],
	[IndividualCallingTimeOfCall],[IndividualCallingNumberDialed],CreditorAccountID,AbuseBeginDate,EstNumberDailyCalls, DocumentID) 
	VALUES(@ClientID,@PersonID,@ClientAccountNumber,@ClientState,@OriginalCreditorID,@SuedByCreditor,@CurrentCreditorID,@CreatedBy,
	NULL,@NoticeOfRepMailDate,@NoticeOfCeaseAndDesist,@CreditorUnAuthorizedCharges,@IndividualCallingName,@IndividualCallingIdentity,
	@IndividualCallingPhone,@IndividualCallingDateOfCall,@IndividualCallingNumTimesCalled,@IndividualCallingTimeOfCall,
	@IndividualCallingNumberDialed,@CreditorAcctID,@AbuseBeginDate,@EstNumberDailyCalls,@DocumentID)
	
	SELECT SCOPE_IDENTITY() AS [ClientSubmissionID]


END


GRANT EXEC ON stp_Harassment_InsertSubmission TO PUBLIC


