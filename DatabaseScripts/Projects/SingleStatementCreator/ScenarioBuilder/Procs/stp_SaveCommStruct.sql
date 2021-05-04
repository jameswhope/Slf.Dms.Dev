if exists (select * from sysobjects where name = 'stp_SaveCommStruct')
	drop procedure stp_SaveCommStruct
go

create procedure stp_SaveCommStruct
(
	@CommScenID int,
	@CommRecID int,
	@ParentCommRecID int,
	@Order int,
	@UserID int,
	@CompanyID int,
	@ParentCommStructID int = null
)
as 
begin
-- Returns CommStructID

declare @CommStructID int
set @CommStructID = null

select @CommStructID = CommStructID
from tblCommStruct
where CommScenID = @CommScenID
	and CommRecID = @CommRecID
	and ParentCommRecID = @ParentCommRecID
	and CompanyID = @CompanyID

if (@CommStructID is null) begin
	declare @max int
	
	select @max = max([order])
	from tblCommStruct
	where CommScenID = @CommScenID
		and ParentCommRecID = @ParentCommRecID
		and CompanyID = @CompanyID
		
	if (@max is null)
		set @max = 0
	else
		set @Order = @max + 1
	
	insert tblCommStruct 
	(
		CommScenID, 
		CommRecID, 
		ParentCommRecID, 
		[Order], 
		Created, 
		CreatedBy, 
		LastModified, 
		LastModifiedBy, 
		CompanyID, 
		ParentCommStructID
	)
	values
	(
		@CommScenID, 
		@CommRecID, 
		@ParentCommRecID, 
		@Order, 
		getdate(), 
		@UserID, 
		getdate(), 
		@UserID, 
		@CompanyID, 
		@ParentCommStructID
	)

	select scope_identity()
end
else begin
	select @CommStructID
end


end