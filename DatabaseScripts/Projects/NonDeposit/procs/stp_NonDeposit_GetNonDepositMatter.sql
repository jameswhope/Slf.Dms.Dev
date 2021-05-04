IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetMatterData')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetMatterData
	END

GO

CREATE Procedure stp_NonDeposit_GetMatterData
@MatterId int
AS
Select 
n.NonDepositId,
n.NonDepositTypeId,
p.ShortDescription as NonDepositType,
[DepositDate] = case n.NonDepositTypeId when 1 then n.MissedDate else (Select r.transactiondate from tblregister r where r.registerid = n.DepositId) end,
[BouncedDate] = (Select r.bounce from tblregister r where r.registerid = n.DepositId),
[BouncedReason] = isnull((Select rs.bounceddescription from tblregister r inner join tblbouncedreasons rs on rs.bouncedid = r.bouncedreason where r.registerid = n.DepositId),''),
[DepositAmount] = case n.NonDepositTypeId when 1 then n.DepositAmount else (Select r.amount from tblregister r where r.registerid = n.DepositId) end,
n.DepositId,
n.Clientid
From tblNonDeposit n
inner join tblNonDepositType p on n.NonDepositTypeId  = p.NonDepositTypeId
Where n.matterid = @matterid

GO

