IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trg_tblAdHocACH_WooleryAdHocACHInsert')
	BEGIN
		DROP  Trigger trg_tblAdHocACH_WooleryAdHocACHInsert
	END
GO

ALTER TABLE DMS.dbo.tblAdHocACH ADD ReferenceAdHocACHID
GO

USE [DMS]
GO
/****** Object:  Trigger [dbo].[trg_tblAdHocACH_WooleryAdHocACHInsert]    Script Date: 11/01/2010 10:46:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_tblAdHocACH_WooleryAdHocACHInsert] ON [dbo].[tblAdHocACH]
   AFTER INSERT
AS 

-- =============================================
-- Author:		Jim Hope
-- Create date: Nov-2010
-- Description:	If Woolery client AdHocACH 
-- is Inserted then insert it to Woolery database
-- =============================================

BEGIN

SET NOCOUNT ON;

IF EXISTS (
	SELECT a.* 
	FROM INSERTED a
	INNER JOIN DMS..tblClient b
	on a.ClientID = b.ClientID
	Where b.RemittName='Woolery Accountancy'
	)

BEGIN

	declare @ReferenceClientID int

	SELECT @ClientID = b.ReferenceClientID 
	FROM INSERTED a
	INNER JOIN DMS..tblclient b
	on a.ClientId = b.ClientId
	Where b.RemittName='Woolery Accountancy'	

INSERT INTO [WOOLERY].[dbo].[tblAdHocACH]
           ([ClientID]
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
           ,[BankAccountID]
		   ,[ReferenceAdHocACHID]
           )
	SELECT @ReferenceClientID
		  ,[RegisterID]
		  ,[DepositDate]
		  ,[DepositAmount]
		  ,[DepositMethod]
		  ,[DepositDay]
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
          ,[BankAccountID]
          ,[AdHocACHID]
	FROM Inserted

	-- Update ReferenceAdHocACHID from other table
	declare @Field_Source int
	declare @Field_Target int

	SELECT @Field_Target = SCOPE_IDENTITY()
	SELECT @Field_Source = AdHocACHID From Inserted

	update DMS..[tblAdHocACH] 
	set ReferenceAdHocACHID =@Field_Target
	where AdHocACHID = @Field_Source

	END
END
GO

/****** Object:  Trigger [dbo].[trg_tblAdHocACH_WooleryAdHocACHUpdate]    Script Date: 11/01/2010 11:25:24 ******/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'trg_tblAdHocACH_WooleryAdHocACHUpdate')
	BEGIN
		DROP  Trigger trg_tblAdHocACH_WooleryAdHocACHUpdate
	END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblAdHocACH_WooleryAdHocACHUpdate] ON [dbo].[tblAdHocACH]
   AFTER UPDATE
AS 

-- =============================================
-- Author:		Jim Hope
-- Create date: Nov-2010
-- Description:	If Woolery client AdHocACH is Updated 
-- then update data to Woolery database
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

	UPDATE [WOOLERY].[dbo].[tblAdHocACH] 
	SET      [ClientID]	=					@ReferenceClientID
			   ,[RegisterID]	=				I.[RegisterID]
			   ,[DepositDate]	=				I.[DepositDate]
			   ,[DepositAmount]	=		I.[DepositAmount]
			   ,[BankName]	=				I.[BankName]
			   ,[BankRoutingNumber]	=	I.[BankRoutingNumber]
			   ,[BankAccountNumber]	=	I.[BankAccountNumber]
			   ,[Created]	=					I.[Created]
			   ,[CreatedBy]	=			    I.[CreatedBy]
			   ,[LastModified]	=		    I.[LastModified]
			   ,[LastModifiedBy] =			I.[LastModifiedBy]
			   ,[BankType]	=				I.[BankType]
			   ,[InitialDraftYN] =				I.[InitialDraftYN]
			   ,[BankAccountId]	=		I.[BankAccountId]
	FROM [WOOLERY].[dbo].[tblAdHocACH] A
	INNER JOIN INSERTED I
	on A.AdHocACHID = I.[ReferenceAdHocACHID]

	END
END

GO

