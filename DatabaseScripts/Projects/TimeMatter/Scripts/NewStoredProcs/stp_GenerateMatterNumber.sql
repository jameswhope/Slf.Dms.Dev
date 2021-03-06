set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
      Revision    : <06 - 22 February 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription : Generate MatterNumber in the format         
				   ClientAccountNumber-last 4 digit of Creditor AccountNumber
*/


CREATE procedure [dbo].[stp_GenerateMatterNumber]
(
	@ClientId int,
	@AccountId int,
	@MatterTypeId int
)
AS

--***** AutoGenerate Matter Number****	
--***** Check if the AccountId and ClientId ***** 
--***** has valid records with Creditor Instance  ****

BEGIN

If @AccountId=0
Begin
	select 
	0 as CreditorInstanceId,
	c.AccountNumber,
	c.ClientId,
	(Select max(isNull(MatterID,0))+1 from tblMatter) as MatterNumber,
	CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
	--,getdate() as MatterDate 

	from dbo.tblClient c 

	where c.ClientId = @ClientId

End
else If @AccountId>0 
Begin
	
select 
	ci.CreditorInstanceId,
	ci.AccountNumber,
	a.ClientId,
	c.AccountNumber,
	--ci.AccountNumber,
	--c.AccountNumber+'-'+RIGHT(ci.AccountNumber,4) as MatterNumber,
	(Select max(isNull(MatterID,0))+1 from tblMatter) as MatterNumber,
	CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
	--,getdate() as MatterDate 

	from dbo.tblCreditorInstance ci 
	join dbo.tblAccount a on a.AccountId=ci.AccountId
	join dbo.tblClient c on c.ClientId=a.ClientId

	where ci.AccountId=@AccountId and c.ClientId = @ClientId

End

--else If @MatterTypeId=2
--Begin
--	select 
--	0 as CreditorInstanceId,
--	c.AccountNumber,
--	c.ClientId,
--	(Select max(isNull(MatterID,0))+1 from tblMatter) as MatterNumber,
--	CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
--	--,getdate() as MatterDate 
--
--	from dbo.tblClient c 
--
--	where c.ClientId = @ClientId
--End
--else If @MatterTypeId=3
--Begin
--	select 
--	0 as CreditorInstanceId,
--	c.AccountNumber,
--	c.ClientId,
--	(Select max(isNull(MatterID,0))+1 from tblMatter) as MatterNumber,
--	CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
--	--,getdate() as MatterDate 
--
--	from dbo.tblClient c 
--
--	where c.ClientId = @ClientId
--End
--
--else If @MatterTypeId=4
--Begin
--	select 
--	0 as CreditorInstanceId,
--	c.AccountNumber,
--	c.ClientId,
--	(Select max(isNull(MatterID,0))+1 from tblMatter) as MatterNumber,
--	CONVERT(VARCHAR(10),getdate(),  101) AS MatterDate
--	--,getdate() as MatterDate 
--
--	from dbo.tblClient c 
--
--	where c.ClientId = @ClientId
--End
END












