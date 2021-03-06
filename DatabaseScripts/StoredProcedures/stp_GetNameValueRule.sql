/****** Object:  StoredProcedure [dbo].[stp_GetNameValueRule]    Script Date: 11/19/2007 15:27:10 ******/
DROP PROCEDURE [dbo].[stp_GetNameValueRule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetNameValueRule]
	(
		@ruletypename varchar(50),
		@rulename varchar(50) = null
	)

as

declare @ruletypeid int
set @ruletypeid=(select ruletypeid from tblruletype where [name]=@ruletypename)

select
	[name],
	[value]
from
	tblrulenamevalue
where
	ruletypeid=@ruletypeid
	and [name]=isnull(@rulename,[name])
GO
