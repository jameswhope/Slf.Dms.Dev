 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'get_NachaRegisterItems_New')
	BEGIN
		DROP  Procedure  get_NachaRegisterItems_New
	END

GO
 
 /****** Object:  StoredProcedure [dbo].[get_NachaRegisterItems_New]    Script Date: 12/21/2009 16:51:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[get_NachaRegisterItems_New]
(
	@nachaFileId int,
	@CommRecID0 int,
	@CommRecID1 int,
	@CommRecID2 int,
	@CommRecID3 int,
	@CompanyID int
)

AS

BEGIN

SET NOCOUNT ON

DECLARE @TrustAcct int

SET @TrustAcct = (SELECT CommRecID FROM tblCommrec WHERE CompanyID = @CompanyID AND IsTrust = 1)

IF @TrustAcct is null
	BEGIN
		SET @TrustAcct = 0
	END

DECLARE @NACHARegister TABLE
(
NachaRegisterID int,
[Name] varchar(50),
AccountNumber varchar(50),
RoutingNumber varchar(9),
Amount money,
CommRecID int,
IsPersonal bit,
AccountType varchar(1),
CompanyID int,
NR int
)

INSERT INTO @NACHARegister

SELECT
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID int,
	'1'
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId = @nachaFileId
	and CommRecId in (@CommRecID0, @CommRecID1, @CommRecID2, @CommRecID3)

INSERT INTO @NACHARegister

SELECT
	nr.NachaRegisterId,
	nr.Name,
	case when nr.AccountNumber is null then (select AccountNumber from tblCommrec where display like '%Clearing%' and companyid = @companyid) ELSE nr.accountnumber END [AccountNumber],
	case when nr.RoutingNumber is null then (select RoutingNumber from tblCommrec where display like '%Clearing%' and companyid = @companyid) ELSE nr.routingnumber END [RoutingNumber],
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'2'
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId = @nachaFileId
	and CommRecId in (@CommRecID0, @CommRecID1, @CommRecID2, @CommRecID3)

SELECT * FROM @NACHARegister

END

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'get_NachaRegisterItems_BofA')
	BEGIN
		DROP  Procedure  get_NachaRegisterItems_BofA
	END

GO

GO
/****** Object:  StoredProcedure [dbo].[get_OutstandingNachaRegisterItems_BofA]    Script Date: 12/22/2009 09:37:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[get_OutstandingNachaRegisterItems_BofA]
(
	@CommRecID0 int = 0,
	@CommRecID1 int = 0,
	@CommRecID2 int = 0,
	@CommRecID3 int = 0,
	@CompanyID int = 0
)

AS

BEGIN

--DECLARE	@CommRecID0 int
--DECLARE	@CommRecID1 int
--DECLARE	@CommRecID2 int
--DECLARE	@CommRecID3 int
--DECLARE	@CompanyID int
--SET	@CommRecID0 = 30
--SET	@CommRecID1 = 31
--SET	@CommRecID2 = 32
--SET	@CommRecID3 = 0
--SET	@CompanyID = 3

DECLARE @ClearingAcct nvarchar(50)
DECLARE @ClearingRout nvarchar(9)
DECLARE @OperatingAcct nvarchar(50)
DECLARE @OperatingRout nvarchar(9)
DECLARE @TrustAcct int

SET @OperatingAcct = (SELECT AccountNumber FROM tblCommRec WHERE Display LIKE '%Operating Account%' AND CompanyID = @CompanyID)
SET @OperatingRout = (SELECT RoutingNumber FROM tblCommRec WHERE Display LIKE '%Operating Account%' AND CompanyID = @CompanyID)
SET @ClearingAcct = (SELECT AccountNumber FROM tblCommRec WHERE Display LIKE '%Clearing Account%' AND CompanyID = @CompanyID)
SET @ClearingRout = (SELECT RoutingNumber FROM tblCommRec WHERE Display LIKE '%Clearing Account%' AND CompanyID = @CompanyID)
SET @TrustAcct = (SELECT CommRecID FROM tblCommrec WHERE CompanyID = @CompanyID AND IsTrust = 1)

IF @TrustAcct is null
	BEGIN
		SET @TrustAcct = 0
	END

DECLARE @OutStandingRegisterItems TABLE
(
NachaRegisterID int,
[Name] varchar(50),
AccountNumber varchar(50),
RoutingNumber varchar(9),
Amount money,
CommRecID int,
IsPersonal bit,
AccountType varchar(1),
CompanyID int,
NR int
)

INSERT INTO @OutStandingRegisterItems

--From the trust to the Clearing
SELECT
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'1' [NR]
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId IS NULL
	AND CommRecID = @TrustAcct 
	AND [Name] like '%General Clearing Account%'

INSERT INTO @OutStandingRegisterItems

--Company stuff no trust NR1
SELECT
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'1' [NR]
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId IS NULL
	AND CommRecId IN (@CommrecID0, @CommrecID1, @CommrecID2, @CommrecID3)
	AND CommRecID <> @TrustAcct 

--Personal stuff NR1 to deposits

INSERT INTO @OutStandingRegisterItems

SELECT
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'1' [NR]
FROM
	tblNachaRegister nr
WHERE
	nr.NachaFileId IS NULL
	AND CommRecId IN (@CommrecID0, @CommrecID1, @CommrecID2, @CommrecID3)
	AND CommRecID = @TrustAcct 
	AND IsPersonal = 1

INSERT INTO @OutStandingRegisterItems

SELECT
	nr.NachaRegisterId,
	nr.Name,
	CASE WHEN nr.AccountNumber IS NULL AND nr.name LIKE '%Clearing%' THEN @ClearingAcct 
	WHEN nr.AccountNumber IS NULL AND nr.name LIKE '%Disbursement%' THEN @OperatingAcct ELSE nr.AccountNumber END [AccountNumber],
	CASE WHEN nr.RoutingNumber is null AND nr.name LIKE '%Clearing%' THEN @ClearingRout 
	WHEN nr.RoutingNumber IS NULL AND nr.name LIKE '%Disbursement%' THEN @OperatingRout ELSE nr.RoutingNumber END [RoutingNumber],
	CASE WHEN nr.Flow = 'debit' THEN nr.amount * -1 ELSE nr.Amount END [amount],
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'2' [NR]
FROM
	tblNachaRegister2 nr
WHERE
	nr.NachaFileId = -1
	AND CompanyID = @CompanyID

SELECT * FROM @OutStandingRegisterItems

END

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNewBofAAccounts')
	BEGIN
		DROP  Procedure  stp_GetNewBofAAccounts
	END

GO

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCoAppsForBofA')
	BEGIN
		DROP  Procedure  stp_GetCoAppsForBofA
	END

GO

GO
/****** Object:  StoredProcedure [dbo].[stp_GetCoAppsForBofA]    Script Date: 12/21/2009 16:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/05/2009
-- Description:	Get Co-Apps for B of A
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetCoAppsForBofA] 
	-- Add the parameters for the stored procedure here
	@ClientID int
AS
		BEGIN
	SET NOCOUNT ON;
		SELECT p.FirstName + ' ' + p.LastName 
        from tblperson p 
        join tblClient c on c.clientid = p.clientid 
        where p.ClientID = @ClientID
        and p.personid <> c.primarypersonid 
END

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertBofATrust')
	BEGIN
		DROP  Procedure  stp_InsertBofATrust
	END

GO

GO
/****** Object:  StoredProcedure [dbo].[stp_InsertBofATrust]    Script Date: 12/21/2009 16:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/06/2009
-- Description:	Insert new Trust ID for B of A clients
-- =============================================
CREATE PROCEDURE [dbo].[stp_InsertBofATrust] 
	@ClientID int = 0, 
	@TrustID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE tblClient SET TrustID = @TrustID WHERE ClientID = @ClientID OR TrustID = @TrustID
END

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBankMasterAccount')
	BEGIN
		DROP  Procedure  stp_GetBankMasterAccount
	END

GO

GO
/****** Object:  StoredProcedure [dbo].[stp_GetBankMasterAccount]    Script Date: 12/21/2009 16:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 12/07/2009
-- Description:	Gets the Bank Master Account number
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetBankMasterAccount] 
(	
		@BankID int 
)
AS
BEGIN
	SET NOCOUNT ON;
		SELECT MasterAccountNo FROM tblBank_NACHA WHERE NACHABankID = @BankID
END

