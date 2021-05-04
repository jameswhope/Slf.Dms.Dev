/****** Object:  StoredProcedure [dbo].[stp_GetQuerySettings]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetQuerySettings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetQuerySettings]
	(
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

exec
(
	'select
		tblquerysetting.*
	from
		tblquerysetting '
	+ @where + ' ' + @orderby
)
GO
