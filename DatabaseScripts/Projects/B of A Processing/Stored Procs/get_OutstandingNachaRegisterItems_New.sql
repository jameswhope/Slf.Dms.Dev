IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'get_OutstandingNachaRegisterItems_New')
	BEGIN
		DROP  Procedure  get_OutstandingNachaRegisterItems_New
	END

GO

/****** Object:  StoredProcedure [dbo].[get_OutstandingNachaRegisterItems_New]    Script Date: 01/28/2010 16:20:15 ******/
/****** This proc only gathers data from tblNACHARegister2 because any clients converted will use that register and not the other one.
CCD is a corporate payment and a PPD is an individual *****/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[get_OutstandingNachaRegisterItems_New]
(
	@CommRecID0 int = 0,
	@CommRecID1 int = 0,
	@CommRecID2 int = 0,
	@CommRecID3 int = 0,
	@CompanyID int = 0,
	@PPDorCCD nvarchar(3)
)

AS

BEGIN

--DECLARE	@CommRecID0 int
--DECLARE	@CommRecID1 int
--DECLARE	@CommRecID2 int
--DECLARE	@CommRecID3 int
--DECLARE	@CompanyID int
--DECLARE	@PPDorCCD VARCHAR(3)
--SET	@CommRecID0 = 33
--SET	@CommRecID1 = 34
--SET	@CommRecID2 = 35
--SET	@CommRecID3 = 0
--SET	@CompanyID = 4
--SET @PPDorCCD = 'PPD'

--DECLARE @ClearingAcct nvarchar(50)
--DECLARE @ClearingRout nvarchar(9)
--DECLARE @OperatingAcct nvarchar(50)
--DECLARE @OperatingRout nvarchar(9)
--DECLARE @TrustAcct int
--
--SET @OperatingAcct = (SELECT AccountNumber FROM tblCommRec WHERE Display LIKE '%Operating Account%' AND CompanyID = @CompanyID)
--SET @OperatingRout = (SELECT RoutingNumber FROM tblCommRec WHERE Display LIKE '%Operating Account%' AND CompanyID = @CompanyID)
--SET @ClearingAcct = (SELECT AccountNumber FROM tblCommRec WHERE Display LIKE '%Clearing Account%' AND CompanyID = @CompanyID)
--SET @ClearingRout = (SELECT RoutingNumber FROM tblCommRec WHERE Display LIKE '%Clearing Account%' AND CompanyID = @CompanyID)
--SET @TrustAcct = (SELECT CommRecID FROM tblCommrec WHERE CompanyID = @CompanyID AND IsTrust = 1)
--
--IF @TrustAcct is null
--	BEGIN
--		SET @TrustAcct = 0
--	END

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
NR int,
ClientID int,
DC nvarchar(50),
TrustID int
)

IF @PPDorCCD = 'CCD'
	BEGIN
--From the Clearing to the operating

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
	'1' [NR],
	nr.ClientID,
	nr.Flow,
	nr.trustid
FROM
	tblNachaRegister2 nr
WHERE
	nr.NachaFileId = -1
	AND nr.IsPersonal = 0
	AND nr.RoutingNumber IS NOT NULL
	AND nr.CompanyID = @CompanyID
	--AND nr.TrustID = 22
END

--Client deposits

IF @PPDorCCD = 'PPD'
BEGIN

INSERT INTO @OutStandingRegisterItems

SELECT 
	nr.NachaRegisterId,
	nr.Name,
	nr.AccountNumber,
	nr.RoutingNumber,
	nr.Amount * -1,
	nr.CommRecId,
	nr.IsPersonal,
	nr.[type] as AccountType,
	nr.CompanyID,
	'2' [NR],
	nr.ClientID,
	nr.Flow,
	c.trustid
FROM
	DMS..tblNachaRegister2 nr
	join tblclient c on c.clientid = nr.clientid
WHERE
	nr.nachafileid = -1
	AND nr.CompanyID = @CompanyID
	AND nr.IsPersonal = 1
	--AND c.TrustID = 22
END
SELECT * FROM @OutStandingRegisterItems ORDER BY nr.NachaRegisterID
END


GO

/*
GRANT EXEC ON get_OutstandingNachaRegisterItems_New TO PUBLIC

GO
*/

