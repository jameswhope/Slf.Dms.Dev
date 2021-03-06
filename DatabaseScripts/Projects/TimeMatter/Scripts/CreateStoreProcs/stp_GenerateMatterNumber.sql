set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[stp_GenerateMatterNumber]
(
	@ClientId int,
	@AccountId int
)
AS

--***** AutoGenerate Matter Number****	
--***** Check if the AccountId and ClientId ***** 
--***** has valid records with Creditor Instance  ****


BEGIN

select 

ci.CreditorInstanceId,
ci.AccountNumber,
a.ClientId,
c.AccountNumber,
--ci.AccountNumber,
c.AccountNumber+'-'+RIGHT(ci.AccountNumber,4) as MatterNumber,
CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
--,getdate() as MatterDate 

from dbo.tblCreditorInstance ci 
join dbo.tblAccount a on a.AccountId=ci.AccountId
join dbo.tblClient c on c.ClientId=a.ClientId

where ci.AccountId=@AccountId and c.ClientId = @ClientId

END


