/****** Object:  UserDefinedFunction [dbo].[fitdate]    Script Date: 11/19/2007 14:49:15 ******/
DROP FUNCTION [dbo].[fitdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fitdate]
(
	@year int,
	@month int,
	@day int
)

returns datetime

begin

declare @result datetime
set @result = convert(datetime,
	convert(varchar,@year) + '.' + 
	convert(varchar,@month) + '.01'
)

declare @maxdays int
set @maxdays = 
	datepart(day, 
		dateadd(day, -1, 
			dateadd(month, 
				datediff(month, 0, @result)+1, 0
			)
		)
	)

if @maxdays < @day
	set @day=@maxdays

set @result=convert(datetime,
	convert(varchar,@year) + '.' + 
	convert(varchar,@month) + '.' + 
	convert(varchar,@day)
)

return @result

end
GO
