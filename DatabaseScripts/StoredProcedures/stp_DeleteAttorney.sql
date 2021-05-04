if exists (select * from sysobjects where name = 'stp_DeleteAttorney')
	drop procedure stp_DeleteAttorney
go

create procedure stp_DeleteAttorney
(
	@AttorneyID int
)
as
begin

declare @UserID int

select @UserID = UserID from tblAttorney where AttorneyID = @AttorneyID

if (@Userid is not null) begin
	delete from tblUser where UserID = @UserID
end

delete from tblAttorney where AttorneyID = @AttorneyID

end