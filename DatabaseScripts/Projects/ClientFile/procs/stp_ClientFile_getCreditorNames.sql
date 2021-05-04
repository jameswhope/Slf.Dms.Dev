IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientFile_getCreditorNames')
	BEGIN
		DROP  Procedure  stp_ClientFile_getCreditorNames
	END

GO

CREATE procedure [dbo].[stp_ClientFile_getCreditorNames]
(
@clientID int
)
as
BEGIN
	/*
	declare @clientID int
	set @clientID = 1671
	*/
	select 
		a.accountid
		,[CreditorName] = cc.name 
		,[AccountStatus] = act.description 
	from tblaccount a 
	inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid
	inner join tblcreditor cc on cc.creditorid = ci.creditorid
	inner join tblaccountstatus act on act.accountstatusid = a.accountstatusid
	where clientid = @clientid
	order by a.created
END




GRANT EXEC ON stp_ClientFile_getCreditorNames TO PUBLIC


