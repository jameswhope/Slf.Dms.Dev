IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getScheduledDepositsPosted')
	BEGIN
		DROP  Procedure  stp_getScheduledDepositsPosted
	END

GO

CREATE Procedure stp_getScheduledDepositsPosted
(
	@StartDate varchar(10),
	@EndDate varchar(10),
	@ClientID int
)
as
BEGIN
	declare @ssql varchar(max)
	set @ssql = 'SELECT '
	set @ssql = @ssql + 'r.registerid, r.transactiondate, r.amount '
	set @ssql = @ssql + 'FROM tblRegister r '
	set @ssql = @ssql + 'WHERE r.entrytypeid = 3 and r.Clientid = ' + cast(@ClientID as varchar)
	set @ssql = @ssql + ' and convert(varchar(6), convert(datetime, convert(varchar, r.achyear) + ''/'' +  convert(varchar, r.achmonth) + ''/01''), 112) ' 
	set @ssql = @ssql + 'between ''' + @StartDate + ''' and ''' + @EndDate + ''''
	exec(@ssql)

END

GO

