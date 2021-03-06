/****** Object:  StoredProcedure [dbo].[_stp_AuditTransactions]    Script Date: 11/19/2007 15:26:46 ******/
DROP PROCEDURE [dbo].[_stp_AuditTransactions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_stp_AuditTransactions]
(
	@dupdb as nvarchar(25),
	@date1 as datetime,
	@date2 as datetime = null,
	@shownotfound as bit = 0,
	@showduplicate as bit = 1
)

AS

if @date2 is null
begin
	set @date2 = @date1
end

declare @acctno as nvarchar(10)
declare @clientid as int
declare @name as nvarchar(50)
declare @amount as money

declare @numdup as int
declare @status26 as nvarchar(25)
declare @status27 as nvarchar(25)
declare @status28 as nvarchar(25)
declare @addentry as bit

declare @cleared as int
declare @paid as int
declare @desc as nvarchar(500)

declare @fileids as nvarchar(500)
declare @tempfileid as int

---------------------------------------------------------------------
declare @tempsql as nvarchar(500)
---------------------------------------------------------------------

create table #return
(
	ret nvarchar(50) null
)

create table #tmpResults
(
	AccountNumber nvarchar(10),
	ClientID int,
	ClientName nvarchar(50),
	Cleared int,
	Paid int,
	Amount money,
	Description nvarchar(250)
)

set @fileids = ''

declare cursor_fileids cursor for
	select
		NachaFileID
	from
		tblNachaFile
	where
		cast(convert(nvarchar(10), Date, 101) as datetime) >= cast(convert(nvarchar(10), @date1, 101) as datetime)
		and cast(convert(nvarchar(10), Date, 101) as datetime) <= cast(convert(nvarchar(10), @date2, 101) as datetime)

open cursor_fileids

fetch next from cursor_fileids into @tempfileid
while @@fetch_status = 0
begin
	set @fileids = @fileids + cast(@tempfileid as nvarchar(10)) + ','

	fetch next from cursor_fileids into @tempfileid
end

close cursor_fileids
deallocate cursor_fileids

set @fileids = substring(@fileids, 0, len(@fileids))

if @fileids = '' or not len(@fileids) > 0
begin
	print 'The dates specified were invalid, using todays date...'

	select top 1
		@tempfileid = cast(NachaFileID as nvarchar(10))
	from
		tblNachaFile
	where
		datediff(d, Date, getdate()) = 0

	set @fileids = cast(@tempfileid as nvarchar(10)) + ',' + cast((@tempfileid + 1) as nvarchar(10))
end

exec('
declare cursor_audittrans cursor for
	select distinct
		[Name],
		Amount,
		(select top 1 ClientID from tblPerson where (firstname + '' '' + lastname) = [Name]) as ClientID,
		(select top 1 AccountNumber from tblClient where ClientID = (select top 1 ClientID from tblPerson where (firstname + '' '' + lastname) = [Name])) as AccountNumber
	from
		tblNachaRegister
	where
		IsPersonal = 1 and
		NachaFileid in (' + @fileids + ')
	order by [Name]
')

open cursor_audittrans

fetch next from cursor_audittrans into @name, @amount, @clientid, @acctno
while @@fetch_status = 0
begin
	set @cleared = 0
	set @paid = 0
	set @desc = ''
	set @status26 = ''
	set @status27 = ''
	set @status28 = ''

	set @addentry = 0

	set @tempsql = '
		select
			count(*)
		from
			' + @dupdb + '
		where
			AccountNumber = ' + @acctno

	print @tempsql

	insert into #return
		exec(@tempsql)

	set @numdup = cast((select top 1 isnull(ret, '0') from #return) as int)
	truncate table #return

	if @shownotfound > 0
	begin
		if @numdup = 0
		begin
			set @desc = @desc + 'Client information not found in ' + @dupdb + '! '
			set @addentry = 1
		end
	end

	if @numdup > 0
	begin
		insert into #return
			exec('
			select
				[26th]
			from
				' + @dupdb + '
			where
				AccountNumber = ' + @acctno
			)

		set @status26 = (select top 1 isnull(ret, '') from #return)
		truncate table #return

		insert into #return
			exec('
			select
				[27th]
			from
				' + @dupdb + '
			where
				AccountNumber = ' + @acctno
			)

		set @status27 = (select top 1 isnull(ret, '') from #return)
		truncate table #return

		insert into #return
			exec('
			select
				[28th]
			from
				' + @dupdb + '
			where
				AccountNumber = ' + @acctno
			)

		set @status28 = (select top 1 isnull(ret, '') from #return)
		truncate table #return

		if lower(@status26) like '%clear%'
		begin
			set @cleared = @cleared + 1
		end

		if lower(@status27) like '%clear%'
		begin
			set @cleared = @cleared + 1
		end

		if lower(@status28) like '%clear%'
		begin
			set @cleared = @cleared + 1
		end

		select
			@paid = count(*)
		from
			tblNachaRegister
		where
			[Name] = @name

		if @paid >= @cleared
		begin
			set @addentry = 1
		end
	end

	if @showduplicate > 0
	begin
		if @numdup > 1
		begin
			set @desc = @desc + cast(@numdup as nvarchar(3)) + ' entries found in ' + @dupdb + '! '
			set @addentry = 1
		end
	end

	if @addentry > 0
	begin
		insert into
			#tmpResults
		values
			(
				@acctno,
				@clientid,
				@name,
				@cleared,
				@paid,
				@amount,
				@desc
			)
	end

	fetch next from cursor_audittrans into @name, @amount, @clientid, @acctno
end

close cursor_audittrans
deallocate cursor_audittrans

select
	*
from
	#tmpResults

drop table #tmpResults
drop table #return
GO
