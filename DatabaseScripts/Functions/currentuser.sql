/****** Object:  UserDefinedFunction [dbo].[currentuser]    Script Date: 11/19/2007 14:49:15 ******/
DROP FUNCTION [dbo].[currentuser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[currentuser]
(
)

returns int

begin

declare @userid int
set @userid = (select userid from tblsysprocessuser where spid=@@spid)
return @userid

end
GO
