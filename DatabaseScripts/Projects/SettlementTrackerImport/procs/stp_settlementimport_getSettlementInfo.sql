IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_getSettlementInfo')
	BEGIN
		DROP  Procedure  stp_settlementimport_getSettlementInfo
	END

GO

CREATE procedure [dbo].[stp_settlementimport_getSettlementInfo]
(
	@clientAccountNumber numeric
	, @creditorAcctLastFour varchar(4)
)
as
BEGIN

/* development
	stp_settlementimport_getSettlementInfo 6070327,7061
	declare @clientAccountNumber numeric
	declare @creditorAcctLastFour varchar(4)

	set @clientAccountNumber = 6070327
	set @creditorAcctLastFour =  '7061'

*/
	declare @ssql varchar(max)

	set @ssql = 'select distinct top 1 ' + char(13)
	set @ssql = @ssql + '[Negotiator] = u.username  ' + char(13)
	set @ssql = @ssql + ', [ClientName] = p.firstname + '' '' + p.lastname ' + char(13)
	set @ssql = @ssql + ', [CurrentCreditor] = currcred.name ' + char(13)
	set @ssql = @ssql + ', [OriginalCreditor] = origcred.name ' + char(13)
	set @ssql = @ssql + ', [Code] = ast.Code ' + char(13)	
	set @ssql = @ssql + ', [LastModified] = a.LastModified ' + char(13)
	set @ssql = @ssql + ', [Created] = s.created ' + char(13)
	set @ssql = @ssql + 'from tblsettlements s  ' + char(13)
	set @ssql = @ssql + 'inner join tblaccount a on s.creditoraccountid=a.accountid ' + char(13)
	set @ssql = @ssql + 'left join tblcreditorinstance curr on curr.creditorinstanceid = a.currentcreditorinstanceid ' + char(13)
	set @ssql = @ssql + 'inner join tblcreditor currcred on currcred.creditorid = curr.creditorid ' + char(13)
	set @ssql = @ssql + 'left join tblcreditorinstance orig on orig.creditorinstanceid = a.originalcreditorinstanceid ' + char(13)
	set @ssql = @ssql + 'inner join tblcreditor origcred on origcred.creditorid = orig.creditorid ' + char(13)
	set @ssql = @ssql + 'inner join tbluser u on s.createdby = u.userid ' + char(13)
	set @ssql = @ssql + 'inner join tblclient c on c.clientid = s.clientid  ' + char(13)
	set @ssql = @ssql + 'inner join tblperson p on p.personid = c.primarypersonid ' + char(13)
	set @ssql = @ssql + 'inner join tblAccountStatus ast on ast.AccountStatusID = a.AccountStatusID ' + char(13)
	set @ssql = @ssql + 'where  ' + char(13)
	set @ssql = @ssql + 's.clientid in (select clientid from tblclient where accountnumber = ' + convert(varchar,@clientAccountNumber) + ') ' + char(13)
	set @ssql = @ssql + 'and status = ''a'' ' + char(13)
	set @ssql = @ssql + 'and curr.accountnumber like ''%' + convert(varchar,@creditorAcctLastFour) + char(39) + char(13)
	--set @ssql = @ssql + 'and settlementduedate =  ' + char(39) + @SettlementDueDate + char(39) +  char(13)
	set @ssql = @ssql + 'order by s.created desc ' 

	--print (@ssql)
	exec(@ssql)
END


GRANT EXEC ON stp_settlementimport_getSettlementInfo TO PUBLIC


