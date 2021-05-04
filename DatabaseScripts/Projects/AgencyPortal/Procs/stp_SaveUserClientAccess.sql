IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveUserClientAccess')
	BEGIN
		DROP  Procedure  stp_SaveUserClientAccess
	END
GO

create procedure stp_SaveUserClientAccess
(
	@UserID int,
	@CreatedFrom datetime,
	@CreatedTo datetime
)
as
begin

if exists (select 1 from tblUserClientAccess where UserID = @UserID) begin
	update tblUserClientAccess
	set ClientCreatedFrom = @CreatedFrom, ClientCreatedTo = @CreatedTo
	where UserID = @UserID
end
else begin
	insert tblUserClientAccess
	values (@UserID,@CreatedFrom,@CreatedTo)
end

end
go   