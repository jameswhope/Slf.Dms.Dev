IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UploadExistingClient')
	BEGIN
		DROP  Procedure  stp_UploadExistingClient
	END
GO

CREATE PROCEDURE stp_UploadExistingClient 
	@ClientID int 
AS
BEGIN
-- Conversion upload script
ALTER TABLE WOOLERY..tblRegister DISABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNacharegister DISABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNacharegister2 DISABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNachaCabinet DISABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblRegisterPayment DISABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblRegisterPaymentDeposit DISABLE TRIGGER ALL
-----------
ALTER TABLE DMS..tblRegister DISABLE TRIGGER ALL
ALTER TABLE DMS..tblNacharegister DISABLE TRIGGER ALL
ALTER TABLE DMS..tblNacharegister2 DISABLE TRIGGER ALL
ALTER TABLE DMS..tblNachaCabinet DISABLE TRIGGER ALL
ALTER TABLE DMS..tblRegisterPayment DISABLE TRIGGER ALL
ALTER TABLE DMS..tblRegisterPaymentDeposit DISABLE TRIGGER ALL
------------
--Testing**********************************
--DECLARE @ClientID INT
--SET @ClientID = 
--*******************************************
SET IDENTITY_INSERT WOOLERY.dbo.tblClient ON

INSERT INTO [WOOLERY].[dbo].[tblClient]
           ([ClientID]
		   ,[PrimaryPersonID]
           ,[EnrollmentID]
           ,[TrustID]
           ,[AccountNumber]
           ,[DepositMethod]
           ,[DepositDay]
           ,[DepositAmount]
           ,[BankName]
           ,[BankRoutingNumber]
           ,[BankAccountNumber]
           ,[BankType]
           ,[BankCity]
           ,[BankStateID]
           ,[BankFraction]
           ,[UserName]
           ,[Password]
           ,[SetupFee]
           ,[SetupFeePercentage]
           ,[SettlementFeePercentage]
           ,[MonthlyFee]
           ,[MonthlyFeeDay]
           ,[MonthlyFeeStartDate]
           ,[AdditionalAccountFee]
           ,[ReturnedCheckFee]
           ,[OvernightDeliveryFee]
           ,[AgencyID]
           ,[CompanyID]
           ,[AssignedUnderwriter]
           ,[AssignedCSRep]
           ,[AssignedMediator]
           ,[ReceivedLSA]
           ,[ReceivedDeposit]
           ,[VWDESaved]
           ,[VWDESavedBy]
           ,[VWDEResolved]
           ,[VWDEResolvedBy]
           ,[VWUWSaved]
           ,[VWUWSavedBy]
           ,[VWUWResolved]
           ,[VWUWResolvedBy]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[ImportID]
           ,[SentWelcomeCoverLetter]
           ,[SentByWelcomeCoverLetter]
           ,[SentWelcomeCallLetter]
           ,[SentByWelcomeCallLetter]
           ,[SentCreditorLetters]
           ,[SentByCreditorLetters]
           ,[SentWelcomePackage]
           ,[SentByWelcomePackage]
           ,[NoChecks]
           ,[CurrentClientStatusID]
           ,[DepositStartDate]
           ,[OldClientID]
           ,[AutoAssignMediator]
           ,[PFOBalance]
           ,[SDABalance]
           ,[StorageServer]
           ,[StorageRoot]
           ,[InitialAgencyPercent]
           ,[InitialDraftDate]
           ,[InitialDraftAmount]
           ,[AgentName]
           ,[SubsequentMaintFee]
           ,[SubMaintFeeStart]
           ,[ServiceImportId]
           ,[MultiDeposit]
           ,[MaintenanceFeeCap]
           ,[RemittName]
           ,[BofAConversionDate]
           ,[AssignedUnderwriterDate]
           ,[Accept]
           ,[AcceptRejectDate]
           ,[AcceptRejectBy]
           ,[RejectReason]
		   ,[ReferenceClientID])
SELECT [ClientID]
      ,[PrimaryPersonID]
      ,[EnrollmentID]
      ,[TrustID]
      ,[AccountNumber]
      ,[DepositMethod]
      ,[DepositDay]
      ,[DepositAmount]
      ,[BankName]
      ,[BankRoutingNumber]
      ,[BankAccountNumber]
      ,[BankType]
      ,[BankCity]
      ,[BankStateID]
      ,[BankFraction]
      ,[UserName]
      ,[Password]
      ,[SetupFee]
      ,[SetupFeePercentage]
      ,[SettlementFeePercentage]
      ,[MonthlyFee]
      ,[MonthlyFeeDay]
      ,[MonthlyFeeStartDate]
      ,[AdditionalAccountFee]
      ,[ReturnedCheckFee]
      ,[OvernightDeliveryFee]
      ,[AgencyID]
      ,[CompanyID]
      ,[AssignedUnderwriter]
      ,[AssignedCSRep]
      ,[AssignedMediator]
      ,[ReceivedLSA]
      ,[ReceivedDeposit]
      ,[VWDESaved]
      ,[VWDESavedBy]
      ,[VWDEResolved]
      ,[VWDEResolvedBy]
      ,[VWUWSaved]
      ,[VWUWSavedBy]
      ,[VWUWResolved]
      ,[VWUWResolvedBy]
      ,[Created]
      ,[CreatedBy]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[ImportID]
      ,[SentWelcomeCoverLetter]
      ,[SentByWelcomeCoverLetter]
      ,[SentWelcomeCallLetter]
      ,[SentByWelcomeCallLetter]
      ,[SentCreditorLetters]
      ,[SentByCreditorLetters]
      ,[SentWelcomePackage]
      ,[SentByWelcomePackage]
      ,[NoChecks]
      ,[CurrentClientStatusID]
      ,[DepositStartDate]
      ,[OldClientID]
      ,[AutoAssignMediator]
      ,[PFOBalance]
      ,[SDABalance]
      ,[StorageServer]
      ,[StorageRoot]
      ,[InitialAgencyPercent]
      ,[InitialDraftDate]
      ,[InitialDraftAmount]
      ,[AgentName]
      ,[SubsequentMaintFee]
      ,[SubMaintFeeStart]
      ,[ServiceImportId]
      ,[MultiDeposit]
      ,[MaintenanceFeeCap]
      ,[RemittName]
      ,[BofAConversionDate]
      ,[AssignedUnderwriterDate]
      ,[Accept]
      ,[AcceptRejectDate]
      ,[AcceptRejectBy]
      ,[RejectReason]
	  , [ClientID]
FROM DMS.dbo.tblClient
WHERE CurrentClientStatusID NOT IN (15, 17, 18) -- Inactive, Cancelled, Completed, ON Hold - Incorrect SDAA
AND trustid = 24
AND BofAConversionDate IS NULL
AND ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.tblClient OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblClientDepositDay] ON
INSERT INTO WOOLERY.[dbo].[tblClientDepositDay]
           (ClientDepositId
		   ,[ClientId]
           ,[Frequency]
           ,[DepositDay]
           ,[Occurrence]
           ,[DepositAmount]
           ,[DepositMethod]
           ,[BankAccountId]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[DeletedDate]
           ,[DeletedBy]
           ,[ReferenceClientDepositID])
SELECT a.* 
FROM DMS..tblClientDepositDay a
INNER JOIN DMS..tblclient b
ON a.ClientId = b.ClientId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblClientDepositDay] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblClientBankAccount] ON
INSERT INTO WOOLERY.[dbo].[tblClientBankAccount]
           (BankAccountId
			,[ClientId]
           ,[RoutingNumber]
           ,[AccountNumber]
           ,[BankType]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[PrimaryAccount]
           ,[Disabled]
           ,[DisabledBy]
           ,[ReferenceBankAccountID]
           ,[LastModifiedByClient])
SELECT a.*
FROM DMS.dbo.tblClientBankAccount a
INNER JOIN DMS..tblclient b
ON a.ClientId = b.ClientId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblClientBankAccount] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblPerson] ON
INSERT INTO WOOLERY.[dbo].[tblPerson]
           ([PersonID]
			,[ClientID]
           ,[SSN]
           ,[FirstName]
           ,[LastName]
           ,[Gender]
           ,[DateOfBirth]
           ,[LanguageID]
           ,[EmailAddress]
           ,[Street]
           ,[Street2]
           ,[City]
           ,[StateID]
           ,[ZipCode]
           ,[Relationship]
           ,[CanAuthorize]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[WebCity]
           ,[WebStateID]
           ,[WebZipCode]
           ,[WebAreaCode]
           ,[WebTimeZoneID]
           ,[ThirdParty]
           ,[IsDeceased]
           ,[LastModifiedByClient])
SELECT a.* 
FROM DMS..tblPerson a
INNER JOIN DMS..tblclient b
ON a.PersonId = b.PrimaryPersonId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblPerson] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.tblDepositRuleACH ON
INSERT INTO WOOLERY.[dbo].[tblDepositRuleAch]
           (RuleACHId
			,[StartDate]
           ,[EndDate]
           ,[DepositDay]
           ,[DepositAmount]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[ClientDepositId]
           ,[BankAccountId]
           ,[OldRuleId]
           ,[Locked]
           ,[ReferenceRuleACHID]
           ,[LastModifiedByClient])
SELECT dr.*
FROM DMS..tblDepositRuleACH dr
JOIN tblClientDepositDay cd ON cd.clientdepositid = dr.ClientDepositId
WHERE cd.ClientId = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.tblDepositRuleACH OFF
-------- 
SET IDENTITY_INSERT WOOLERY.dbo.tblAccount ON
INSERT INTO WOOLERY.[dbo].[tblAccount]
           (AccountID
			,[ClientID]
           ,[CurrentCreditorInstanceID]
           ,[AccountStatusID]
           ,[OriginalAmount]
           ,[CurrentAmount]
           ,[SetupFeePercentage]
           ,[SettlementFeeCredit]
           ,[OriginalDueDate]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[Settled]
           ,[SettledBy]
           ,[Removed]
           ,[RemovedBy]
           ,[SettledMediationID]
           ,[UnverifiedAmount]
           ,[UnverifiedRetainerFee]
           ,[Verified]
           ,[VerifiedAmount]
           ,[VerifiedBy]
           ,[VerifiedRetainerFee]
           ,[OriginalCreditorInstanceID]
           ,[PreviousStatus]
           ,[LastModifiedByClient])
SELECT a.* 
FROM DMS..tblAccount a
INNER JOIN DMS..tblclient b
ON a.ClientId = b.ClientId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.tblAccount OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.tblAdHocACH ON
INSERT INTO WOOLERY.[dbo].[tblAdHocACH]
           (AdHocAchID
			,[ClientID]
           ,[RegisterID]
           ,[DepositDate]
           ,[DepositAmount]
           ,[BankName]
           ,[BankRoutingNumber]
           ,[BankAccountNumber]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[BankType]
           ,[InitialDraftYN]
           ,[BankAccountId]
           ,[ReferenceAdHocACHID]
           ,[LastModifiedByClient])
SELECT a.* 
FROM DMS..tblAdHocACH a
INNER JOIN DMS..tblclient b
ON a.ClientId = b.ClientId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.tblAdHocACH OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblRuleACH] ON
INSERT INTO WOOLERY.[dbo].[tblRuleACH]
           (RuleACHID
			,[ClientId]
           ,[StartDate]
           ,[EndDate]
           ,[DepositDay]
           ,[DepositAmount]
           ,[BankName]
           ,[BankRoutingNumber]
           ,[BankAccountNumber]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy]
           ,[BankType])
SELECT a.* 
FROM DMS..[tblRuleACH] a
INNER JOIN DMS..tblClient b
ON a.ClientId = b.ClientId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblRuleACH] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblPersonPhone] ON
INSERT INTO WOOLERY.[dbo].[tblPersonPhone]
           ([PersonPhoneID]
			,[PersonID]
           ,[PhoneID]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy])
SELECT distinct [PersonPhoneID]
      ,[PersonID]
      ,[PhoneID]
      ,a.[Created]
      ,a.[CreatedBy]
      ,a.[LastModified]
      ,a.[LastModifiedBy]
  FROM [DMS].[dbo].[tblPersonPhone] a
INNER JOIN DMS..tblclient b
ON a.PersonId = b.PrimaryPersonId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
order by PersonPhoneId
SET IDENTITY_INSERT WOOLERY.dbo.[tblPersonPhone] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblPhone] ON
INSERT INTO [WOOLERY].[dbo].[tblPhone]
           ([PhoneID]
			,[PhoneTypeID]
           ,[AreaCode]
           ,[Number]
           ,[Extension]
           ,[Created]
           ,[CreatedBy]
           ,[LastModified]
           ,[LastModifiedBy])
SELECT [PhoneID]
      ,[PhoneTypeID]
      ,[AreaCode]
      ,[Number]
      ,[Extension]
      ,[Created]
      ,[CreatedBy]
      ,[LastModified]
      ,[LastModifiedBy]
  FROM [DMS].[dbo].[tblPhone]
WHERE PhoneTypeID IN (27, 21, 31) --, 56, 57)
and PhoneId IN
(
SELECT distinct [PhoneID]
  FROM [DMS].[dbo].[tblPersonPhone] a
INNER JOIN DMS..tblclient b
ON a.PersonId = b.PrimaryPersonId
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
)
SET IDENTITY_INSERT WOOLERY.dbo.[tblPhone] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegister] ON
INSERT INTO [WOOLERY].[dbo].[tblRegister]
           ([RegisterId]
			,[ClientId]
           ,[AccountID]
           ,[TransactionDate]
           ,[CheckNumber]
           ,[Description]
           ,[Amount]
           ,[Balance]
           ,[EntryTypeId]
           ,[IsFullyPaid]
           ,[Bounce]
           ,[BounceBy]
           ,[Void]
           ,[VoidBy]
           ,[Hold]
           ,[HoldBy]
           ,[Clear]
           ,[ClearBy]
           ,[ImportID]
           ,[MediatorID]
           ,[OldTable]
           ,[OldID]
           ,[ACHMonth]
           ,[ACHYear]
           ,[FeeMonth]
           ,[FeeYear]
           ,[Created]
           ,[CreatedBy]
           ,[AdjustedRegisterID]
           ,[OriginalAmount]
           ,[PFOBalance]
           ,[SDABalance]
           ,[RegisterSetID]
           ,[InitialDraftYN]
           ,[CompanyID]
           ,[BouncedReason]
           ,[ClientDepositID]
           ,[NotC21]
           ,[ReferenceRegisterID])
SELECT [RegisterId]
      ,a.[ClientId]
      ,[AccountID]
      ,[TransactionDate]
      ,[CheckNumber]
      ,[Description]
      ,[Amount]
      ,[Balance]
      ,[EntryTypeId]
      ,[IsFullyPaid]
      ,[Bounce]
      ,[BounceBy]
      ,[Void]
      ,[VoidBy]
      ,[Hold]
      ,[HoldBy]
      ,[Clear]
      ,[ClearBy]
      ,a.[ImportID]
      ,[MediatorID]
      ,[OldTable]
      ,[OldID]
      ,[ACHMonth]
      ,[ACHYear]
      ,[FeeMonth]
      ,[FeeYear]
      ,a.[Created]
      ,a.[CreatedBy]
      ,[AdjustedRegisterID]
      ,[OriginalAmount]
      ,a.[PFOBalance]
      ,a.[SDABalance]
      ,[RegisterSetID]
      ,[InitialDraftYN]
      ,a.[CompanyID]
      ,[BouncedReason]
      ,[ClientDepositID]
      ,[NotC21]
      ,[RegisterId] --[ReferenceRegisterID]
FROM DMS.[dbo].[tblRegister] a
INNER JOIN WOOLERY.[dbo].[tblclient] b
ON a.clientid=b.clientid
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegister] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblNachaRegister2] ON
INSERT INTO [WOOLERY].[dbo].[tblNachaRegister2]
           ([NachaRegisterId]
			,[NachaFileId]
           ,[Name]
           ,[AccountNumber]
           ,[RoutingNumber]
           ,[Type]
           ,[Amount]
           ,[IsPersonal]
           ,[CommRecId]
           ,[CompanyID]
           ,[ShadowStoreId]
           ,[ClientID]
           ,[TrustId]
           ,[RegisterID]
           ,[RegisterPaymentID]
           ,[Created]
           ,[Status]
           ,[State]
           ,[ReceivedDate]
           ,[ProcessedDate]
           ,[ExceptionCode]
           ,[Notes]
           ,[ExceptionResolved]
           ,[Flow]
           ,[ReferenceNachaRegisterID]
		   ,[PayoutWithheld]
		   ,[AmountWithheld]
		   ,[DateWithheld]
		   ,[WithheldBy]
		   ,[OriginalAmount]
		   ,[WithheldFrom]
		   ,[OriginalNachaRegisterID])
SELECT [NachaRegisterId]
      ,[NachaFileId]
      ,[Name]
      ,a.[AccountNumber]
      ,[RoutingNumber]
      ,[Type]
      ,[Amount]
      ,[IsPersonal]
      ,[CommRecId]
      ,a.[CompanyID]
      ,[ShadowStoreId]
      ,a.[ClientID]
      ,a.[TrustId]
      ,[RegisterID]
      ,[RegisterPaymentID]
      ,a.[Created]
      ,[Status]
      ,[State]
      ,[ReceivedDate]
      ,[ProcessedDate]
      ,[ExceptionCode]
      ,[Notes]
      ,[ExceptionResolved]
      ,[Flow]
      ,[ReferenceNachaRegisterID]
      ,[PayoutWithheld]
      ,[AmountWithheld]
      ,[DateWithheld]
      ,[WithheldBy]
      ,[OriginalAmount]
      ,[WithheldFrom]
      ,[OriginalNachaRegisterID]
  FROM DMS.[dbo].[tblNachaRegister2] a
INNER JOIN WOOLERY.[dbo].[tblclient] b
ON a.clientid=b.clientid
WHERE b.trustid=24
AND b.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblNachaRegister2] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegisterPayment] ON
INSERT INTO [WOOLERY].[dbo].[tblRegisterPayment]
           ([RegisterPaymentId]
			,[PaymentDate]
           ,[FeeRegisterId]
           ,[Amount]
           ,[Voided]
           ,[Bounced]
           ,[PFOBalance]
           ,[SDABalance]
           ,[Clear]
           ,[ClearBy]
           ,[VoidDate]
           ,[BounceDate]
           ,[Created]
           ,[CreatedBy]
           ,[Modified]
           ,[ModifiedBy]
           ,[ReferenceRegisterPaymentID])
SELECT a.[RegisterPaymentId]
		   ,a.[PaymentDate]
           ,a.[FeeRegisterId]
           ,a.[Amount]
           ,a.[Voided]
           ,a.[Bounced]
           ,a.[PFOBalance]
           ,a.[SDABalance]
           ,a.[Clear]
           ,a.[ClearBy]
           ,a.[VoidDate]
           ,a.[BounceDate]
           ,a.[Created]
           ,a.[CreatedBy]
           ,a.[Modified]
           ,a.[ModifiedBy]
           ,a.[RegisterPaymentID]
FROM DMS..tblRegisterPayment a
INNER JOIN DMS..tblRegister b
ON a.FeeRegisterId = b.RegisterID
INNER JOIN WOOLERY.[dbo].[tblclient] c
ON c.clientid=b.clientid
WHERE c.trustid=24
AND c.BofAConversionDate IS NULL
AND b.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegisterPayment] OFF
--------
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegisterPaymentDeposit] ON
INSERT INTO [WOOLERY].[dbo].[tblRegisterPaymentDeposit]
           ([RegisterPaymentDepositID]
			,[RegisterPaymentID]
           ,[DepositRegisterID]
           ,[Amount]
           ,[Voided]
           ,[Bounced]
           ,[ModifiedBy]
           ,[VoidDate]
           ,[BounceDate]
           ,[Created]
           ,[CreatedBy]
           ,[Modified]
           ,[ReferenceRegisterPaymentDepositID])
SELECT a.[RegisterPaymentDepositID]
		   ,a.[RegisterPaymentID]
           ,a.[DepositRegisterID]
           ,a.[Amount]
           ,a.[Voided]
           ,a.[Bounced]
           ,a.[ModifiedBy]
           ,a.[VoidDate]
           ,a.[BounceDate]
           ,a.[Created]
           ,a.[CreatedBy]
           ,a.[Modified] 
		   ,a.[RegisterPaymentDepositID]
FROM DMS..tblRegisterPaymentDeposit a
INNER JOIN DMS..tblRegister b
ON a.DepositRegisterId = b.RegisterID
INNER JOIN WOOLERY.[dbo].[tblclient] c
ON c.clientid=b.clientid
WHERE c.trustid=24
AND c.BofAConversionDate IS NULL
AND c.ClientID = @ClientID
SET IDENTITY_INSERT WOOLERY.dbo.[tblRegisterPaymentDeposit] OFF
--------
ALTER TABLE WOOLERY..tblRegister ENABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNacharegister ENABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNacharegister2 ENABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblNachaCabinet ENABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblRegisterPayment ENABLE TRIGGER ALL
ALTER TABLE WOOLERY..tblRegisterPaymentDeposit ENABLE TRIGGER ALL

ALTER TABLE DMS..tblRegister ENABLE TRIGGER ALL
ALTER TABLE DMS..tblNacharegister ENABLE TRIGGER ALL
ALTER TABLE DMS..tblNacharegister2 ENABLE TRIGGER ALL
ALTER TABLE DMS..tblNachaCabinet ENABLE TRIGGER ALL
ALTER TABLE DMS..tblRegisterPayment ENABLE TRIGGER ALL
ALTER TABLE DMS..tblRegisterPaymentDeposit ENABLE TRIGGER ALL
--**************************************************************************************
END

GO

/*
GRANT EXEC ON stp_UploadExistingClient TO PUBLIC

GO
*/

