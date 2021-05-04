IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCallClientSearches')
	BEGIN
		DROP  Procedure  stp_GetCallClientSearches
	END

GO

CREATE Procedure stp_GetCallClientSearches
@PhoneNumber varchar(15)
AS
Begin
	 select  
		s.*, cs.Name [ClientStatus]
	from
		tblclientsearch s
	join 
		tblclient c on c.clientid = s.clientid
	join
		tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
	where 
		s.contactnumber Like '%' + @PhoneNumber + '%'
	order by s.name asc
end

GO
 
