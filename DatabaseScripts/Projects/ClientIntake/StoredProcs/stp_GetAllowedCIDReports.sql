IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAllowedCIDReports')
	BEGIN
		DROP  Procedure  stp_GetAllowedCIDReports
	END

GO

CREATE Procedure stp_GetAllowedCIDReports
@UserId as Integer
AS
select r.name as reportname from 
	(select f.name
	from tbluserpermission u 
	join tblpermission p on p.permissionid = u.permissionid 
	join tblfunction f on f.functionid = p.functionid and f.fullname like '%Client Intake-Reports%' 
	join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' 
	where u.userid = @userid and p.value = 1
	union  
		(select f.name 
		from tblgrouppermission g 
		join tblpermission p on p.permissionid = g.permissionid 
		join tblfunction f on f.functionid = p.functionid and f.fullname like '%Client Intake-Reports%' 
		join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' 
		join tbluser u on g.usergroupid = u.usergroupid
		where u.userid = @userid and p.value = 1
		except
		select f.name
		from tbluserpermission u 
		join tblpermission p on p.permissionid = u.permissionid 
		join tblfunction f on f.functionid = p.functionid and f.fullname like '%Client Intake-Reports%' 
		join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' 
		where u.userid = @userid and p.value = 0)
	) r
where r.name <> 'reports'
order by r.name

GO

 

