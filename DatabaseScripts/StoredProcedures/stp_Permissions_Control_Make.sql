/****** Object:  StoredProcedure [dbo].[stp_Permissions_Control_Make]    Script Date: 11/19/2007 15:27:28 ******/
DROP PROCEDURE [dbo].[stp_Permissions_Control_Make]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_Control_Make]
	(
		@PageName varchar(255),
		@FunctionName varchar(255),
		@ControlName varchar(255),
		@PermissionTypeId int,
		@Action bit
	)

as

--get the functionid (create if neccessary)
declare @functionId int
set @functionId=(SELECT FunctionId from tblfunction where [fullname]=@functionname)
if @functionId is null
begin
	INSERT INTO tblFunction ([Name],FullName, IsSystem) values (@FunctionName,@FunctionName, 0)
	set @functionId = SCOPE_IDENTITY()
end

--get the pageid (create if neccessary)
declare @pageId int
set @pageId=(SELECT pageid from tblpage where [servername]=@pagename)
if @pageId is null
begin
	declare @isMasterPage bit
	if @pagename like '%_master' begin set @ismasterpage = 1 end else begin set @ismasterpage=0 end
	INSERT INTO tblpage (servername,[Name], IsMasterPage) values (@pagename,@pagename, @ismasterpage)
	set @pageId = SCOPE_IDENTITY()
end

--create the control for this page if not existant
declare @controlid int
set @controlid = (select controlid from tblcontrol where pageid=@pageid and servername=@controlname)
if @controlid is null
begin
	insert into tblcontrol
		(pageid,servername,permissiontypeid, action) 
	values 
		(@pageid,@controlname,@permissiontypeid,@action)
	set @controlid = scope_identity()
end

--add the control to the function if not existant
declare @controlfunctionid int
set @controlfunctionid=(select controlfunctionid from tblcontrolfunction where controlid=@controlid and functionid=@functionid)
if @controlfunctionid is null
begin
	insert into tblcontrolfunction (controlid,functionid) values (@controlid,@functionid)
end
GO
