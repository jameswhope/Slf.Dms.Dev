IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_updateuserextension')
	BEGIN
		DROP  Procedure  stp_updateuserextension
	END

GO

CREATE Procedure stp_updateuserextension
@username varchar(100),
@fullname varchar(100),
@ext varchar(10)
AS
begin

	if exists(select ext from tbluserext where login = @username)
		update tbluserext set ext = @ext, fullname = @fullname where login = @username
	else
		insert into tbluserext(ext, fullname, login) values(@ext, @fullname, @username)
	
end
GO

 