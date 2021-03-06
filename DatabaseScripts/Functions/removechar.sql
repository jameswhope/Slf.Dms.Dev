/****** Object:  UserDefinedFunction [dbo].[removechar]    Script Date: 11/19/2007 14:49:16 ******/
DROP FUNCTION [dbo].[removechar]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[removechar]
(
	@instring varchar(100),
	@char varchar(1)
)

returns varchar(100)

begin

declare @outstr varchar(100);
declare @spos int;

set @outstr=@instring;
set @spos = -1;

while @spos<>0 begin
	set @spos = charindex(@char,@outstr,1)

	if @spos>1 and @spos<len(@outstr)-1 begin
		set @outstr = substring(@outstr,1,@spos-1) + substring(@outstr,@spos+1,len(@outstr)-@spos)
	end else if @spos=len(@outstr) begin
		set @outstr = substring(@outstr,1,@spos-1)
	end else if @spos=1 begin
		set @outstr = substring(@outstr,2,len(@outstr)-1)
	end
end

return @outstr


end
GO
