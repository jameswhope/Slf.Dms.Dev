IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_getNegotiatorTeams')
	BEGIN
		DROP  Procedure  stp_settlementimport_getNegotiatorTeams
	END

GO

CREATE Procedure stp_settlementimport_getNegotiatorTeams
as
BEGIN
	SELECT DISTINCT
	dbo.udf_Negotiators_getGroup(ne.negotiationentityid)[Team]
	,FirstName + ' ' + LastName AS [User]
	, UserName 
	FROM tblUser u left outer join tblnegotiationentity ne on u.userid = ne.userid
	WHERE (UserGroupID = 4) 
	order by [user]
END


GRANT EXEC ON stp_settlementimport_getNegotiatorTeams TO PUBLIC


