/****** Object:  StoredProcedure [dbo].[stp_HomepageChartEnrollmentDidNotQualify]    Script Date: 11/19/2007 15:27:21 ******/
DROP PROCEDURE [dbo].[stp_HomepageChartEnrollmentDidNotQualify]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_HomepageChartEnrollmentDidNotQualify]
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
   count(tblenrollment.enrollmentid) as CountEnrollment
 from
   tblenrollment inner join
		tblclient on tblenrollment.clientid=tblclient.clientid where qualified=0 '
 + @refwhere + ' 
 group by
   ' + @datefield + '
 having
   not ' + @datefield + ' is null
 order by 
   ' + @datefield
)
GO
