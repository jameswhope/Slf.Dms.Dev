IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveUserCommRecAccess')
	BEGIN
		DROP  Procedure  stp_SaveUserCommRecAccess
	END
GO

create procedure stp_SaveUserCommRecAccess
(
	@UserID int,
	@CommRecIDs varchar(1000)
)
as
begin

if @CommRecIDs = '-99' begin
	select @CommRecIDs = coalesce(@commrecids + ',', '') + cast(CommRecID as varchar(4))
	from tblCommRec
	where IsTrust = 0
end

insert 
	tblUserCommRecAccess (UserID, CommRecID)
select 
	UserID, CommRecID
from 
(
	select @UserID as UserID, r.CommRecID
	from dbo.splitstr(@CommRecIDs,',') s
	join tblCommRec r on r.CommRecID = s.Value
) dev
where not exists (select 1 from tblUserCommRecAccess u where u.UserID = dev.UserID and u.CommRecID = dev.CommRecID)


delete from tblUserCommRecAccess
where UserID = @UserID
and CommRecID not in (select [value] from dbo.splitstr(@CommRecIDs,','))


end
go