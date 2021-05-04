IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_getSettlementsWaitingForManagerApproval')
	BEGIN
		DROP  Procedure  stp_settlements_getSettlementsWaitingForManagerApproval
	END

GO

CREATE Procedure stp_settlements_getSettlementsWaitingForManagerApproval
/*
	(
		@parameter1 int = 5,
		@parameter2 datatype OUTPUT
	)

*/
AS
BEGIN
    select 
    settType,ActionID,clientid,[Client Name],[Creditor Name],CurrentAmount,SettlementAmount,OverAmount,SDABalance,[Created By]
    ,accountnumber,settlementpercent,settlementduedate,accountid,created,isclientstipulation,ispaymentarrangement,settlementid
    from
    (
	    select 
	    [settType] = 'SettlementPercent'
	    ,[ActionID]=so.OverID
	    , c.clientid
	    ,p.FirstName + ' ' + p.LastName AS [Client Name]
	    , cg.Name AS [Creditor Name]
	    , a.CurrentAmount
	    , s.SettlementAmount
	    , so.OverAmount
	    , s.RegisterBalance [SDABalance]
	    , cu.FirstName + ' ' + cu.LastName AS [Created By] 
	    , c.accountnumber
	    , s.settlementpercent
	    , s.settlementduedate
	    , a.accountid
	    , s.created
	    , s.isclientstipulation
	    , s.ispaymentarrangement
	    , s.settlementid
	    from tblSettlements_Overs so with(nolock) 
	    join tblSettlements s with(nolock)  ON s.SettlementID = so.SettlementID and s.Active = 1
	    join tblAccount a with(nolock)  ON a.AccountID = s.CreditorAccountID
	    join tblCreditorInstance ci with(nolock)  on ci.creditorinstanceid = a.currentcreditorinstanceid
	    join tblcreditor cr with(nolock)  on cr.creditorid = ci.creditorid
	    join tblcreditorgroup cg with(nolock)  on cg.creditorgroupid = cr.creditorgroupid
	    join tblclient c with(nolock)  on c.clientid = s.clientid
	    join tblperson p with(nolock)  on p.personid = c.primarypersonid
	    join tblUser cu with(nolock)  ON cu.UserID = so.CreatedBy 
	    where so.ApprovedBy is null and so.RejectedBy is null 
	    ) as mData
END




GRANT EXEC ON stp_settlements_getSettlementsWaitingForManagerApproval TO PUBLIC

GO


