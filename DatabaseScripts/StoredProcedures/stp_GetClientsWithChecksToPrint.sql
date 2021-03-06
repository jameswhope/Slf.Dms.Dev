/****** Object:  StoredProcedure [dbo].[stp_GetClientsWithChecksToPrint]    Script Date: 11/19/2007 15:27:06 ******/
DROP PROCEDURE [dbo].[stp_GetClientsWithChecksToPrint]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetClientsWithChecksToPrint]

as

select
	tblclient.*,
	tblperson.firstname as primarypersonfirstname,
	tblperson.lastname as primarypersonlastname
from
	tblclient inner join
	(
		select
			clientid
		from
			tblchecktoprint
		group by
			clientid
	)
	as t on tblclient.clientid = t.clientid inner join
	tblperson on tblclient.primarypersonid = tblperson.personid	
order by
	tblperson.lastname, tblperson.firstname
GO
