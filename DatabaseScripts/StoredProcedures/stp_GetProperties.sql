/****** Object:  StoredProcedure [dbo].[stp_GetProperties]    Script Date: 11/19/2007 15:27:14 ******/
DROP PROCEDURE [dbo].[stp_GetProperties]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetProperties]

as

select
	tblproperty.*,
	tblpropertycategory.[name] as propertycategoryname,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tblproperty inner join
	tblpropertycategory on tblproperty.propertycategoryid = tblpropertycategory.propertycategoryid left outer join
	tbluser as tblcreatedby on tblproperty.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tblproperty.lastmodifiedby = tbllastmodifiedby.userid
GO
