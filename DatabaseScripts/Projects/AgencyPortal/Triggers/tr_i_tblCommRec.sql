
if object_id('tr_i_tblCommRec','TR') is not null
	drop trigger tr_i_tblCommRec
go

create trigger tr_i_tblCommRec on tblCommRec after insert
as
begin

declare @CommRecID int
select @CommRecID = CommRecID from INSERTED 

insert tblUserCommRecAccess (UserID, CommRecID)
select UserID, @CommRecID
from tblUser 
where CommRecID = -99 --ALL

end
go  