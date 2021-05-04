if exists (select * from sysobjects where name = 'stp_UserCommRecs')
	drop procedure stp_UserCommRecs
go

create procedure stp_UserCommRecs
(
	@UserID int
)
as
begin


if exists (select 1 from tblUser where UserID = @UserID and CommRecID = -99) begin
	select -99, 'ALL', 'ALL'
end
else if exists (select 1 from tblUserCommRecAccess where UserID = @UserID) begin
	select r.CommRecID, r.Abbreviation, r.Display
	from tblUserCommRecAccess u
	join tblCommRec r on r.CommRecID = u.CommRecID
	where u.UserID = @UserID
	order by r.Display
end
else begin
	select '-1', 'None', 'None'
end


end