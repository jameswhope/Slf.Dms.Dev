/****** Object:  UserDefinedFunction [dbo].[monthweek]    Script Date: 11/19/2007 14:49:16 ******/
DROP FUNCTION [dbo].[monthweek]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[monthweek] 
(
	@d datetime
) 

returns tinyint as

begin

return 
(
	SELECT 
		datepart(week, dateadd(DAY, @@datefirst , @d)) --week of year
		- datepart(week, dateadd(day, @@datefirst , convert(char(6), @d, 112) + '01'))
		+ 1
)
end
GO
