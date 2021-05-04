IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_lexxsign_getSettlementsByBatchID')
	BEGIN
		DROP  Procedure  stp_lexxsign_getSettlementsByBatchID
	END

GO

create procedure stp_lexxsign_getSettlementsByBatchID
(
	@signBatchID varchar(50)
)
as
BEGIN
	declare @clientid int
	select @clientid = clientid from tbllexxsigndocs where signingbatchid = @signBatchID 

	select [CreditorName]=c.name
	,ci.accountnumber
	,ci.referencenumber
	,a.currentamount
	,s.settlementamount
	,s.settlementduedate
	,s.settlementsavings
	from tblsettlements s
	inner join tblaccount a on s.creditoraccountid = a.accountid
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor c on c.creditorid = ci.creditorid
	where s.clientid = @clientid and s.status = 'a' and s.active = 1 and not a.accountstatusid in (54,55)
END	

GRANT EXEC ON stp_lexxsign_getSettlementsByBatchID TO PUBLIC

GO



