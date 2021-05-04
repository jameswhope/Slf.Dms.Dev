IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetOpenNonDeposits')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetOpenNonDeposits
	END

GO

CREATE Procedure stp_NonDeposit_GetOpenNonDeposits
@LawFirmId int = null,
@MatterSubstatusId int = null,
@NonDepositTypeId int = null,
@InCancellation bit = 0
AS
Begin
Select t.due, 
co.ShortCoName, 
ClientName = isnull(p.FirstName, '') + ' ' + isnull(p.LastName, ''), 
NonDepositType = nt.ShortDescription,
NonDepositDate = case when n.depositid is null then n.misseddate else r.transactiondate end,
NonDepositAmount = case when n.depositid is null then n.depositamount else r.amount end,
BouncedReason = case when n.depositid is null then '' else (select bouncedDescription from tblbouncedreasons where bouncedid = r.bouncedreason) end,
n.CurrentReplacementId,
InCancel = case when pc.clientid is null then 0 else 1 end,
Letter = Case (Select top 1 LetterType from tblNonDepositLetter Where LetterType in ('D5025', 'D5030', 'D5031', 'D5013') and nondepositid = n.nondepositid order by NonDepositLetterId desc) 
				when 'D5030' then 'First' 
				when 'D5031' then 'Second' 
				when 'D5013' Then 'Third' 
				when 'D5025' then 'NSF' 
				else '' end ,
BouncedDepositId = DepositId,
st.MatterSubstatus,
n.clientid, 
n.matterid,
n.nondepositid,
c.accountnumber
from tblnondeposit n
inner join tblnondeposittype nt on nt.nondeposittypeid = n.nondeposittypeId
inner join tblclient c on c.clientid = n.clientid
inner join tblperson p on p.personid = c.primarypersonid
inner join tblcompany co on co.companyid = c.companyid
inner join tblmatter m on n.matterid = m.matterid
inner join tblmattersubstatus st on st.mattersubstatusid = m.mattersubstatusid
inner join 
(select taskid = max(taskid), matterid from tblmattertask group by matterid) mt on mt.matterid = m.matterid
inner join tbltask t on t.taskid = mt.taskid
left join tblNonDepositPendingCancellation pc on pc.clientid = n.clientid and pc.deleted is null
left join tblPlannedDeposit pd on pd.planid = n.planid
left join tblregister r on r.registerid = n.depositid
where (@LawFirmId is null or c.companyid = @LawFirmId)
and m.matterstatusid in (1, 3)
and (@MatterSubstatusId is null or m.mattersubstatusid = @MatterSubstatusId)
and (@NonDepositTypeId is null or n.nonDepositTypeId = @NonDepositTypeId)
and n.deleted is null
and c.currentclientstatusid not in (15, 17, 18, 22)
and (@InCancellation = 0 or pc.clientid is not null)
End


GO


