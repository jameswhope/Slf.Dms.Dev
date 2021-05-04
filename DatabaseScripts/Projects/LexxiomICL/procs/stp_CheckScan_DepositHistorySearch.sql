IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_DepositHistorySearch')
	BEGIN
		DROP  Procedure  stp_CheckScan_DepositHistorySearch
	END

GO

CREATE Procedure [dbo].[stp_CheckScan_DepositHistorySearch]
	(
		@searchTerm varchar(100)
	)

AS
BEGIN
	set @searchTerm = '%' + @searchTerm + '%'

	select 
		Check21ID
		, p.FirstName + ' ' + p.LastName [Client Name]
		, CheckAmount[Check Amt]
		, verified
		, vu.firstname + ' ' + vu.lastname[Verified By]
		, Processed 
		, ProcessedBy[Processed By]
		, nc.saveguid
	from 
		tblICLChecks nc 
		left outer join tblclient c on nc.clientid = c.clientid
		inner join tblperson p on p.personid = c.primarypersonid
		left outer join tbluser vu on vu.userid = nc.verifiedby
	where
		(c.accountnumber like @searchTerm
		or p.FirstName + ' ' + p.LastName like @searchTerm
		or vu.firstname + ' ' + vu.lastname like @searchTerm)
		and DeleteDate IS NULL	

END



GO


GRANT EXEC ON stp_CheckScan_DepositHistorySearch TO PUBLIC

GO


