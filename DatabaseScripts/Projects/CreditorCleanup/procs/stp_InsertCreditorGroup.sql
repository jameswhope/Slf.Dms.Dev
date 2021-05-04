IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCreditorGroup')
	BEGIN
		DROP  Procedure   stp_InsertCreditorGroup
	END
GO

CREATE procedure stp_InsertCreditorGroup
(
	@Name varchar(250),
	@UserID int,
	@UpdateName bit = 0
)
as
begin

declare @creditorgroupid int, @gname varchar(250)

if exists (select 1 from tblcreditorgroup where [name] = @Name) begin
	select @creditorgroupid=creditorgroupid, @gname=name from tblcreditorgroup where [name] = @Name
	
	-- uncommented 6/2/10 by jh - can't remember why we decided to turn this off at some point
	-- 9/16/10 use optional parameter to allows updates
	if convert(varbinary,@Name) <> convert(varbinary,@gname) and @UpdateName = 1 begin
		update tblcreditorgroup set [name]=@Name, lastmodified=getdate(), lastmodifiedby=@UserID where creditorgroupid = @creditorgroupid
	end
	
	select @creditorgroupid
end
else begin
	insert tblcreditorgroup ([name],created,createdby,lastmodified,lastmodifiedby)
	values (@Name,getdate(),@UserID,getdate(),@UserID)
	
	select scope_identity()
end


end
go 