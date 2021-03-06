/****** Object:  StoredProcedure [dbo].[stp_HomepageChartEnrollmentSummary]    Script Date: 11/19/2007 15:27:22 ******/
DROP PROCEDURE [dbo].[stp_HomepageChartEnrollmentSummary]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_HomepageChartEnrollmentSummary]
	(
		@refwhere varchar (8000) = '',
		@dategrouping int = 0
	)
 
as

declare @datefield varchar (500)
declare @field varchar(50)
set @field='tblenrollment.created'

if @dategrouping = 0 -- daily grouping
	begin
		set @datefield = 'convert(datetime, convert(varchar, ' + @field + ', 101))'
	end
else if @dategrouping = 1 -- weekly grouping
	begin
		set @datefield = 'dateadd(day, 1 - datepart(dw, ( convert(varchar, ' + @field + ', 101) )), ( convert(varchar, ' + @field + ', 101) ))'
	end
else if @dategrouping = 2 -- monthly grouping
	begin
		set @datefield = 'convert(datetime, convert(varchar(2), month(' + @field + ')) + N''/1/'' + convert(varchar(4), year(' + @field + ')))'
	end
else if @dategrouping = 3 -- yearly grouping
	begin
		set @datefield = 'convert(datetime, N''1/1/'' + convert(varchar(12), year(' + @field + ')))'
	end
 
exec
(
	'select
		' + @datefield + ' as [time],
		sum(case committed when 1 then 1 else 0 end) as countenrolled,
		sum(case qualified when 0 then 1 else 0 end) as countdidnotqualify,
		sum(case when qualified = 1 and committed = 0 then 1 else 0 end) as countwouldnotcommit
	from
		tblenrollment inner join
		tblclient on tblenrollment.clientid=tblclient.clientid
	where
		1=1 '
		+ @refwhere + 
	' group by
		' + @datefield + '
	having
		not ' + @datefield + ' is null
	order by
		' + @datefield
)
GO
