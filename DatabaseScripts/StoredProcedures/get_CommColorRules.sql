/****** Object:  StoredProcedure [dbo].[get_CommColorRules]    Script Date: 11/19/2007 15:26:47 ******/
DROP PROCEDURE [dbo].[get_CommColorRules]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[get_CommColorRules]

AS

SET NOCOUNT ON

select
	rulecommcolorid,
	entitytype,
	entityid,
	color,
	textcolor,
	(case 
		when entitytype='Relation Type' then rt.name
		when entitytype='User Type' then ut.name
		when entitytype='User Group' then ug.name
		when entitytype='User' then u.firstname + ' ' + u.lastname
	end) as entityname
from
	tblrulecommcolor left outer join
	tbluser u on entityid=u.userid left outer join
	tblusergroup ug on entityid=ug.usergroupid left outer join
	tblusertype ut on entityid=ut.usertypeid left outer join
	tblrelationtype rt on entityid=rt.relationtypeid
GO
