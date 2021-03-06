/****** Object:  StoredProcedure [dbo].[stp_GetRegisters]    Script Date: 11/19/2007 15:27:15 ******/
DROP PROCEDURE [dbo].[stp_GetRegisters]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRegisters]
	(
		@returntop varchar (8000) ='100 percent',
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as

exec
(
	'select top
		' + @returntop + '
		tblregister.*,
		(case when tblregister.amount < 0 then abs(tblregister.amount) else 0 end) as debit,
		(case when tblregister.amount >= 0 then abs(tblregister.amount) else 0 end) as credit,
		tblentrytype.[name] as entrytypename
	from
		tblregister inner join
		tblentrytype on tblregister.entrytypeid = tblentrytype.entrytypeid '
	+ @where + ' '
	+ @orderby
)
GO
