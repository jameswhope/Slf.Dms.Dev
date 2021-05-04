USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClient_WooleryClientInsert]    Script Date: 09/10/2010 23:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblClient_WooleryClientInsert] ON [dbo].[tblClient]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	If Woolery client is Inserted then insert it to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (SELECT * FROM inserted WHERE RemittName = 'Woolery Accountancy')
 BEGIN
INSERT INTO [WOOLERY].[dbo].[tblClient]
           ([PrimaryPersonID]
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
		   ,[ReferenceClientID]
			)
	SELECT [PrimaryPersonID]
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
		,[ClientID]
	  FROM Inserted

	-- Update ReferenceClientId from other table
	declare @ClientID_Source int
	declare @ClientID_Target int

	SELECT @ClientID_Target = SCOPE_IDENTITY()
	SELECT @ClientID_Source = ClientID From Inserted

	update DMS..tblClient 
	set ReferenceClientID =@ClientID_Target
	where ClientID = @ClientID_Source

	END
END
GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClient_WooleryClientUpdate]    Script Date: 09/10/2010 23:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblClient_WooleryClientUpdate] ON [dbo].[tblClient]
   AFTER UPDATE
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	If Woolery client is Updated then update data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (SELECT * FROM inserted WHERE RemittName = 'Woolery Accountancy')
 BEGIN

UPDATE [WOOLERY].[dbo].[tblClient] 
SET        [PrimaryPersonID]	=			I.[PrimaryPersonID]
           ,[EnrollmentID]	=				I.[EnrollmentID]
           ,[TrustID]	=					I.[TrustID]
           ,[AccountNumber]	=				I.[AccountNumber]
           ,[DepositMethod]	=				I.[DepositMethod]
           ,[DepositDay]	=				I.[DepositDay]
           ,[DepositAmount]	=				I.[DepositAmount]
           ,[BankName]	=					I.[BankName]
           ,[BankRoutingNumber]	=	        I.[BankRoutingNumber]
           ,[BankAccountNumber]	=	        I.[BankAccountNumber]
           ,[BankType]	=					I.[BankType]
           ,[BankCity]	=					I.[BankCity]
           ,[BankStateID]	=				I.[BankStateID]
           ,[BankFraction]	=				I.[BankFraction]
           ,[UserName]	=					I.[UserName]
           ,[Password]	=					I.[Password]
           ,[SetupFee]	=					I.[SetupFee]
           ,[SetupFeePercentage]	=	    I.[SetupFeePercentage]
           ,[SettlementFeePercentage]	=	I.[SettlementFeePercentage]
           ,[MonthlyFee]	=				I.[MonthlyFee]
           ,[MonthlyFeeDay]	=				I.[MonthlyFeeDay]
           ,[MonthlyFeeStartDate]	=	    I.[MonthlyFeeStartDate]
           ,[AdditionalAccountFee]	=	    I.[AdditionalAccountFee]
           ,[ReturnedCheckFee]	=	        I.[ReturnedCheckFee]
           ,[OvernightDeliveryFee]	=	    I.[OvernightDeliveryFee]
           ,[AgencyID]	=					I.[AgencyID]
           ,[CompanyID]	=					I.[CompanyID]
           ,[AssignedUnderwriter]	=	    I.[AssignedUnderwriter]
           ,[AssignedCSRep]	=				I.[AssignedCSRep]
           ,[AssignedMediator]	=	        I.[AssignedMediator]
           ,[ReceivedLSA]	=				I.[ReceivedLSA]
           ,[ReceivedDeposit]	=	        I.[ReceivedDeposit]
           ,[VWDESaved]	=					I.[VWDESaved]
           ,[VWDESavedBy]	=				I.[VWDESavedBy]
           ,[VWDEResolved]	=				I.[VWDEResolved]
           ,[VWDEResolvedBy]	=	        I.[VWDEResolvedBy]
           ,[VWUWSaved]	=					I.[VWUWSaved]
           ,[VWUWSavedBy]	=				I.[VWUWSavedBy]
           ,[VWUWResolved]	=				I.[VWUWResolved]
           ,[VWUWResolvedBy]	=	        I.[VWUWResolvedBy]
           ,[Created]	=					I.[Created]
           ,[CreatedBy]	=					I.[CreatedBy]
           ,[LastModified]	=				I.[LastModified]
           ,[LastModifiedBy]	=	        I.[LastModifiedBy]
           ,[ImportID]	=					I.[ImportID]
           ,[SentWelcomeCoverLetter]	=	I.[SentWelcomeCoverLetter]
           ,[SentByWelcomeCoverLetter]	=	I.[SentByWelcomeCoverLetter]
           ,[SentWelcomeCallLetter]	=	    I.[SentWelcomeCallLetter]
           ,[SentByWelcomeCallLetter]	=	I.[SentByWelcomeCallLetter]
           ,[SentCreditorLetters]	=	    I.[SentCreditorLetters]
           ,[SentByCreditorLetters]	=	    I.[SentByCreditorLetters]
           ,[SentWelcomePackage]	=	    I.[SentWelcomePackage]
           ,[SentByWelcomePackage]	=	    I.[SentByWelcomePackage]
           ,[NoChecks]	=					I.[NoChecks]
           ,[CurrentClientStatusID]	=	    I.[CurrentClientStatusID]
           ,[DepositStartDate]	=	        I.[DepositStartDate]
           ,[OldClientID]	=				I.[OldClientID]
           ,[AutoAssignMediator]	=	    I.[AutoAssignMediator]
           ,[PFOBalance]	=				I.[PFOBalance]
           ,[SDABalance]	=				I.[SDABalance]
           ,[StorageServer]	=				I.[StorageServer]
           ,[StorageRoot]	=				I.[StorageRoot]
           ,[InitialAgencyPercent]	=	    I.[InitialAgencyPercent]
           ,[InitialDraftDate]	=	        I.[InitialDraftDate]
           ,[InitialDraftAmount]	=	    I.[InitialDraftAmount]
           ,[AgentName]	=					I.[AgentName]
           ,[SubsequentMaintFee]	=	    I.[SubsequentMaintFee]
           ,[SubMaintFeeStart]	=	        I.[SubMaintFeeStart]
           ,[ServiceImportId]	=	        I.[ServiceImportId]
           ,[MultiDeposit]	=				I.[MultiDeposit]
           ,[MaintenanceFeeCap]	=	        I.[MaintenanceFeeCap]
           ,[RemittName]	=				I.[RemittName]
           ,[BofAConversionDate]	=		I.[BofAConversionDate]
           ,[AssignedUnderwriterDate]	=	I.[AssignedUnderwriterDate]
           ,[Accept]	=					I.[Accept]
           ,[AcceptRejectDate]	=	        I.[AcceptRejectDate]
           ,[AcceptRejectBy]	=	        I.[AcceptRejectBy]
           ,[RejectReason]	=				I.[RejectReason]
FROM [WOOLERY].[dbo].[tblClient] A
INNER JOIN INSERTED I
on A.ClientID = I.[ReferenceClientID]

	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClientBankAccount_WooleryClientInsert]    Script Date: 09/10/2010 23:25:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblClientBankAccount_WooleryClientInsert] ON [dbo].[tblClientBankAccount]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)

BEGIN

	declare @ClientID int

	SELECT @ClientID = b.ReferenceClientID 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'


INSERT INTO WOOLERY.[dbo].[tblClientBankAccount]
           ([ClientId]
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
           ,[ReferenceBankAccountID])
SELECT @ClientID --[ClientId]
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
      ,[BankAccountID]
  FROM INSERTED

	-- Update ReferenceClientId from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = [BankAccountID] From Inserted

	update DMS..[tblClientBankAccount] 
	set ReferenceBankAccountID =@Field_Target
	where BankAccountID = @Field_Source

	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClientBankAccount_WooleryClientUpdate]    Script Date: 09/10/2010 23:26:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblClientBankAccount_WooleryClientUpdate] ON [dbo].[tblClientBankAccount]
   AFTER UPDATE
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)

BEGIN

	declare @ReferenceClientID int

	SELECT @ReferenceClientID = b.ReferenceClientID 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'


UPDATE WOOLERY.[dbo].[tblClientBankAccount]
SET        [ClientId] =			@ReferenceClientID	 -- I.[ClientId]
           ,[RoutingNumber] =	I.[RoutingNumber]
           ,[AccountNumber] =	I.[AccountNumber]
           ,[BankType] =		I.[BankType]
           ,[Created]=			I.[Created]
           ,[CreatedBy] =		I.[CreatedBy]
           ,[LastModified] =	I.[LastModified]
           ,[LastModifiedBy] =	I.[LastModifiedBy]
           ,[PrimaryAccount] =	I.[PrimaryAccount]
           ,[Disabled] =		I.[Disabled]
           ,[DisabledBy] =		I.[DisabledBy]
From WOOLERY.[dbo].[tblClientBankAccount] A
Inner Join Inserted I
On A.[ClientId] = I.[ReferenceBankAccountID]

	END
END

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClientDepositDay_WooleryClientInsert]    Script Date: 09/10/2010 23:27:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblClientDepositDay_WooleryClientInsert] ON [dbo].[tblClientDepositDay]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)

BEGIN

	declare @ClientID int

	SELECT @ClientID = b.ReferenceClientID 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	--Where b.RemittName='Woolery'

	declare @BankAccountID int

	SELECT @BankAccountID = b.ReferenceBankAccountID
	FROM INSERTED a
	INNER JOIN DMS..tblClientBankAccount b
	on a.ClientId = b.ClientId
	and a.BankAccountID = b.BankAccountID
	


INSERT INTO WOOLERY.[dbo].[tblClientDepositDay]
           ([ClientId]
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
SELECT @ClientID		-- [ClientId]
      ,[Frequency]
      ,[DepositDay]
      ,[Occurrence]
      ,[DepositAmount]
      ,[DepositMethod]
      ,@BankAccountID	-- [BankAccountId]
      ,[Created]
      ,[CreatedBy]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[ClientDepositID]
  FROM INSERTED

	-- Update ReferenceClientId from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = ClientDepositID From Inserted

	update DMS..tblClientDepositId 
	set ReferenceClientDepositID =@Field_Target
	where ClientDepositID = @Field_Source

	END
END
GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblClientDepositDay_WooleryClientUpdate]    Script Date: 09/10/2010 23:27:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblClientDepositDay_WooleryClientUpdate] ON [dbo].[tblClientDepositDay]
   AFTER UPDATE
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)

BEGIN

	declare @ReferenceClientID int

	SELECT @ReferenceClientID = b.ReferenceClientID 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	--Where b.RemittName='Woolery'

	declare @ReferenceBankAccountID int

	SELECT @ReferenceBankAccountID = b.ReferenceBankAccountID
	FROM INSERTED a
	INNER JOIN DMS..tblClientBankAccount b
	on a.ClientId = b.ClientId
	and a.BankAccountID = b.BankAccountID
	


UPDATE WOOLERY.[dbo].[tblClientDepositDay]
SET
           [ClientId]	=	           @ReferenceClientID  -- I.[ClientId]	
           ,[Frequency]	=	           I.[Frequency]	
           ,[DepositDay]	=	       I.[DepositDay]	
           ,[Occurrence]	=	       I.[Occurrence]	
           ,[DepositAmount]	=	       I.[DepositAmount]	
           ,[DepositMethod]	=	       I.[DepositMethod]	
           ,[BankAccountId]	=	       @ReferenceBankAccountID  -- I.[BankAccountId]	
           ,[Created]	=	           I.[Created]	
           ,[CreatedBy]	=	           I.[CreatedBy]	
           ,[LastModified]	=	       I.[LastModified]	
           ,[LastModifiedBy]	=	   I.[LastModifiedBy]	
           ,[DeletedDate]	=	       I.[DeletedDate]	
           ,[DeletedBy]	=	           I.[DeletedBy]	
FROM WOOLERY.[dbo].[tblClientDepositDay] A
INNER JOIN INSERTED I
ON A.[ClientDepositID] = I.[ReferenceClientDepositID]

	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblDepositRuleACH_WooleryClientInsert]    Script Date: 09/10/2010 23:30:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblDepositRuleACH_WooleryClientInsert] ON [dbo].[tblDepositRuleAch]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblClientDepositDay b1
		on a.ClientDepositId = b1.ClientDepositId
		and a.BankAccountId = b1.BankAccountId
	INNER JOIN DMS..tblclient b
		on b1.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)


BEGIN

	declare @ReferenceClientDepositID int

	SELECT @ReferenceClientDepositID = b.ReferenceClientDepositID 
	FROM INSERTED a
	INNER JOIN DMS..tblClientDepositDay b
		on a.ClientDepositId = b.ClientDepositId
		and a.BankAccountId = b.BankAccountId

	declare @ReferenceBankAccountID int

	SELECT @ReferenceBankAccountID = b.ReferenceBankAccountID
	FROM INSERTED a
	INNER JOIN DMS..tblClientBankAccount b
	on a.BankAccountID = b.BankAccountID
	
INSERT INTO WOOLERY.[dbo].[tblDepositRuleAch]
           ([StartDate]
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
           ,[ReferenceRuleACHID])
SELECT [StartDate]
      ,[EndDate]
      ,[DepositDay]
      ,[DepositAmount]
      ,[Created]
      ,[CreatedBy]
      ,[LastModified]
      ,[LastModifiedBy]
      ,@ReferenceClientDepositID	-- [ClientDepositId]
      ,@ReferenceBankAccountID		-- [BankAccountId]
      ,[OldRuleId]
      ,[Locked]
      ,[RuleACHID]
  FROM INSERTED

	-- Update ReferenceClientId from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = RuleACHId From Inserted

	update DMS..tblDepositRuleAch 
	set ReferenceRuleACHId =@Field_Target
	where RuleACHId = @Field_Source

	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblDepositRuleACH_WooleryClientUpdate]    Script Date: 09/10/2010 23:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblDepositRuleACH_WooleryClientUpdate] ON [dbo].[tblDepositRuleAch]
   AFTER UPDATE
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: Jun-2010
-- Description:	For Woolery client transfer the data to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblClientDepositDay b1
		on a.ClientDepositId = b1.ClientDepositId
		and a.BankAccountId = b1.BankAccountId
	INNER JOIN DMS..tblclient b
		on b1.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'
	)


BEGIN

	declare @ReferenceClientDepositID int

	SELECT @ReferenceClientDepositID = b.ReferenceClientDepositID 
	FROM INSERTED a
	INNER JOIN DMS..tblClientDepositDay b
		on a.ClientDepositId = b.ClientDepositId
		and a.BankAccountId = b.BankAccountId

	declare @ReferenceBankAccountID int

	SELECT @ReferenceBankAccountID = b.ReferenceBankAccountID
	FROM INSERTED a
	INNER JOIN DMS..tblClientBankAccount b
	on a.BankAccountID = b.BankAccountID
	
UPDATE WOOLERY.[dbo].[tblDepositRuleAch]
SET 
           [StartDate] =			I.[StartDate]
           ,[EndDate] =				I.[EndDate]
           ,[DepositDay] =			I.[DepositDay]
           ,[DepositAmount] =		I.[DepositAmount]
           ,[Created] =				I.[Created]
           ,[CreatedBy] =			I.[CreatedBy]
           ,[LastModified] =		I.[LastModified]
           ,[LastModifiedBy] =		I.[LastModifiedBy]
           ,[ClientDepositId] =		@ReferenceClientDepositID	 -- I.[ClientDepositId]
           ,[BankAccountId] =		@ReferenceBankAccountID	 -- I.[BankAccountId]
           ,[OldRuleId] =			I.[OldRuleId]
           ,[Locked] =				I.[Locked]
FROM WOOLERY.[dbo].[tblDepositRuleAch] A
INNER JOIN INSERTED I
On A.RuleACHID = I.[ReferenceRuleACHID]



	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblNachaRegister2_WooleryRecordInsert]    Script Date: 09/10/2010 23:31:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblNachaRegister2_WooleryRecordInsert] ON [dbo].[tblNachaRegister2]
   AFTER INSERT
AS 
-- =============================================
-- Author:		Gary Singh
-- Create date: June-2010
-- Description:	This trigger tansfers the data for Woolery clients to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;


IF EXISTS (
		select a.* from INSERTED a
		inner join DMS..tblClient b 
		on a.clientid=b.clientid
		Where b.RemittName='Woolery Accountancy'
			)

BEGIN

	IF TRIGGER_NESTLEVEL() > 1
		RETURN

INSERT INTO WOOLERY.[dbo].[tblNachaRegister2]
           ([NachaFileId]
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
           ,[ReferenceNachaRegisterID])
SELECT [NachaFileId]
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
      ,[NachaRegisterId]
  FROM INSERTED


	-- Update ReferenceClientId from other table
	declare @NachaRegisterID_Source int
	declare @NachaRegisterID_Target int

	SELECT @NachaRegisterID_Target = SCOPE_IDENTITY()
	SELECT @NachaRegisterID_Source = [NachaRegisterID] From Inserted

	UPDATE DMS..tblNachaRegister2 
	SET [ReferenceNachaRegisterID] = @NachaRegisterID_Target
	WHERE RegisterID = @NachaRegisterID_Source


	END
END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblRegister_WooleryRecordUpdate]    Script Date: 09/10/2010 23:31:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRegister_WooleryRecordUpdate] ON [dbo].[tblRegister]
   AFTER UPDATE
AS 
-- =============================================
-- Author:		Gary Singh
-- Create date: June-2010
-- Description:	This trigger tansfers the data for Woolery clients 
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
		select a.* from INSERTED a
		inner join DMS..tblClient b 
		on a.clientid=b.clientid
		Where b.RemittName='Woolery Accountancy'
			)

BEGIN

	IF TRIGGER_NESTLEVEL() > 1
		RETURN

-- only transfer Monthly Maintenance Fee (EntryTypeID=1)
--		and not for Deposits where EntryTypeID=3
	declare @ReferenceRegisterId int
	SELECT @ReferenceRegisterId = ReferenceRegisterId
	FROM INSERTED


	UPDATE WOOLERY.[dbo].[tblRegister]
	   SET [ClientId] = I.ClientId
      ,[AccountID] = I.AccountID
      ,[TransactionDate] = I.TransactionDate
      ,[CheckNumber] = I.CheckNumber
      ,[Description] = I.Description 
      ,[Amount] = I.Amount 
      ,[Balance] = I.Balance 
      ,[EntryTypeId] = I.EntryTypeId 
      ,[IsFullyPaid] = I.IsFullyPaid 
      ,[Bounce] = I.Bounce 
      ,[BounceBy] = I.BounceBy 
      ,[Void] = I.Void 
      ,[VoidBy] = I.VoidBy 
      ,[Hold] = I.Hold 
      ,[HoldBy] = I.HoldBy
      ,[Clear] = I.Clear
      ,[ClearBy] = I.ClearBy 
      ,[ImportID] = I.ImportID 
      ,[MediatorID] = I.MediatorID 
      ,[OldTable] = I.OldTable 
      ,[OldID] = I.OldID 
      ,[ACHMonth] = I.ACHMonth 
      ,[ACHYear] = I.ACHYear 
      ,[FeeMonth] = I.FeeMonth 
      ,[FeeYear] = I.FeeYear 
      ,[Created] = I.Created 
      ,[CreatedBy] = I.CreatedBy 
      ,[AdjustedRegisterID] = I.AdjustedRegisterID 
      ,[OriginalAmount] = I.OriginalAmount 
      ,[PFOBalance] = I.PFOBalance 
      ,[SDABalance] = I.SDABalance 
      ,[RegisterSetID] = I.RegisterSetID 
      ,[InitialDraftYN] = I.InitialDraftYN 
      ,[CompanyID] = I.CompanyID 
      ,[BouncedReason] = I.BouncedReason 
      ,[ClientDepositID] = I.ClientDepositID 
      ,[NotC21] = I.NotC21
      --,[ReferenceRegisterID] = <ReferenceRegisterID, 
	FROM WOOLERY.[dbo].[tblRegister] A
	INNER JOIN INSERTED I 
	ON A.RegisterId = @ReferenceRegisterId


END



END

GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblRegisterPayment_WooleryRecordInsert]    Script Date: 09/10/2010 23:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRegisterPayment_WooleryRecordInsert] ON [dbo].[tblRegisterPayment]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: June-2010
-- Description:	This trigger tansfers the data for Woolery clients 
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
			
		SELECT a.* From INSERTED a
		Inner Join DMS..tblRegister b
		on a.FeeRegisterId = b.RegisterID
		Inner join DMS..tblClient c
		on b.ClientID = c.ClientID
		Where c.RemittName='Woolery Accountancy'
		
		)

BEGIN


INSERT INTO WOOLERY.[dbo].[tblRegisterPayment]
           ([PaymentDate]
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
SELECT [PaymentDate]
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
      ,[RegisterPaymentId]
  FROM INSERTED

	-- Update ReferenceClientId from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = RegisterPaymentId From Inserted

	UPDATE DMS..tblRegisterPayment 
	SET ReferenceRegisterPaymentId =@Field_Target
	WHERE RegisterPaymentId = @Field_Source


END

END

GO

--**************************************************************
USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblRegisterPaymentDeposit_WooleryRecordInsert]    Script Date: 09/10/2010 23:32:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRegisterPaymentDeposit_WooleryRecordInsert] ON [dbo].[tblRegisterPaymentDeposit]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Gary Singh
-- Create date: June-2010
-- Description:	This trigger tansfers the data for Woolery clients 
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
			
		SELECT a.* From INSERTED a
		Inner Join DMS..tblRegister b
		on a.DepositRegisterID = b.RegisterID
		Inner join DMS..tblClient c
		on b.ClientID = c.ClientID
		Where c.RemittName='Woolery Accountancy'
		
		)

BEGIN

-- RegisterPaymentID should be the one from Woolery db, so find out the ReferenceRegisterPaymentID
declare @ReferenceRegisterPaymentID int

select @ReferenceRegisterPaymentID = ReferenceRegisterPaymentID
from DMS..tblRegisterPayment a
inner join Inserted b
on a.RegisterPaymentID = b.RegisterPaymentID


INSERT INTO WOOLERY.[dbo].[tblRegisterPaymentDeposit]
           ([RegisterPaymentID]
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
SELECT @ReferenceRegisterPaymentID	-- [RegisterPaymentID]
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
      ,[RegisterPaymentDepositID]
  FROM INSERTED

	-- Update ReferenceClientId from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = RegisterPaymentDepositId FROM Inserted

	UPDATE DMS..tblRegisterPaymentDeposit 
	SET ReferenceRegisterPaymentDepositId = @Field_Target
	WHERE RegisterPaymentDepositId = @Field_Source

END
END

USE [WOOLERY]
GO
/****** Object:  Trigger [dbo].[trg_tblNachaRegister2_WooleryRecordUpdate]    Script Date: 10/21/2010 12:39:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblNachaRegister2_WooleryRecordUpdate] ON [dbo].[tblNachaRegister2]
   AFTER UPDATE
AS 
-- =============================================
-- Author:		Jim Hope
-- Create date: October-2010
-- Description:	This trigger tansfers the data from Woolery NachaRegister to DMS
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
		select a.* from UPDATED a
		inner join DMS..tblClient b 
		on a.clientid = b.clientid
		join DMS..tblNACHARegister2 c
		on c.ReferenceNachaRegisterID = a.ReferanceNachaRegisterID
		Where b.RemittName='Woolery Accountancy'
			)
	BEGIN

		IF TRIGGER_NESTLEVEL() > 1
			RETURN
		
		--Only transfer data for this ReferanceNachaRegisterId
		declare @ReferenceNachaRegisterId int
		SELECT @ReferenceNachaRegisterId = ReferenceNachaRegisterId
		FROM UPDATED

		UPDATE DMS.[dbo].[tblNachaRegister2]
			   SET [NachaFileId]	= I.[NachaFileId]
			   ,[Name]			= I.[Name]
			   ,[AccountNumber]	= I.[AccountNumber]
			   ,[RoutingNumber]	= I.[RoutingNumber]
			   ,[Type]			= I.[Type]
			   ,[Amount]		= I.[Amount]
			   ,[IsPersonal]	= I.[IsPersonal]
			   ,[CommRecId]		= I.[CommRecId]
			   ,[CompanyID]		= I.[CompanyID]
			   ,[ShadowStoreId]	= I.[ShadowStoreId]
			   ,[ClientID]		= I.[ClientID]
			   ,[TrustId]		= I.[TrustId]
			   ,[RegisterID]	= I.[RegisterID]
			   ,[RegisterPaymentID]	= I.[RegisterPaymentID]
			   ,[Created]		= I.[Created]
			   ,[Status]		= I.[Status]
			   ,[State]			= I.[State]
			   ,[ReceivedDate]	= I.[ReceivedDate]
			   ,[ProcessedDate]	= I.[ProcessedDate]
			   ,[ExceptionCode]	= I.[ExceptionCode]
			   ,[Notes]			= I.[Notes]
			   ,[ExceptionResolved]	= I.[ExceptionResolved]
			   ,[Flow]			= I.[Flow]
			   ,[ReferenceNachaRegisterID] = I.[ReferenceNachaRegisterID]
		
		FROM [WOOLERY].[dbo].[tblNachaRegister2] A
		INNER JOIN UPDATED I
		on A.[ReferenceNacahRegisterID] = @ReferenceNachaRegisterId

	END
END


