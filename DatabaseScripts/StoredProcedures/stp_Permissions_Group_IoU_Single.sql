/****** Object:  StoredProcedure [dbo].[stp_Permissions_Group_IoU_Single]    Script Date: 11/19/2007 15:27:29 ******/
DROP PROCEDURE [dbo].[stp_Permissions_Group_IoU_Single]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_Group_IoU_Single]
	(
		@functionid int,
		@usergroupid int,
		@permissiontypeid int,
		@value bit,
		@overwriteold bit=1
	)

as

declare @permissionid int
set @permissionid = (
	select top 1 tblpermission.permissionid 
	from tblgrouppermission inner join tblpermission on tblpermission.permissionid=tblgrouppermission.permissionid
	where 
		tblgrouppermission.usergroupid=@usergroupid and 
		tblpermission.functionid=@functionid and 
		tblpermission.permissiontypeid=@permissiontypeid 
	order by
		tblpermission.permissionid desc
)

if @permissionid is not null
begin
	--Delete any duplicates. These should not exist.

	select 
		tblpermission.permissionid 
	into
		#tmp
	from 
		tblgrouppermission inner join
		tblpermission on tblgrouppermission.permissionid=tblpermission.permissionid
	where
		usergroupid = @usergroupid
		and functionid = @functionid
		and permissiontypeid = @permissiontypeid
		and not tblpermission.permissionid = @permissionid

	delete from tblgrouppermission where permissionid in 
		(select permissionid from #tmp)

	delete from tblpermission where permissionid in 
		(select permissionid from #tmp)

	drop table #tmp
end  

if @value is null begin
	if @permissionid is not null
	begin
		--just delete it if it exists. 
		delete from tblpermission where permissionid=@permissionid
		delete from tblgrouppermission where permissionid=@permissionid
	end  
	--otherwise, do nothing
end else begin
	if @permissionid is null
	begin
		insert into tblpermission 
			(functionid, permissiontypeid, value)
		values
			(@functionid, @permissiontypeid, @value)

		insert into tblgrouppermission 
			(usergroupid, permissionid, usertypeid)
		values
			(@usergroupid, scope_identity(), null)
	end
	else if @overwriteold=1
	begin
		update tblpermission set
			value=@value
		where
			permissionid = @permissionid
	end
end
GO
