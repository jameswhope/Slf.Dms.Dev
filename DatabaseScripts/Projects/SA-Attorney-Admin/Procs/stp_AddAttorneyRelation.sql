if exists (select * from sysobjects where name = 'stp_AddAttorneyRelation')
	drop procedure stp_AddAttorneyRelation
go

create procedure stp_AddAttorneyRelation
(
	@AttorneyID int
,	@CompanyID int
,	@AttyRelation varchar(50)
,	@UserID int
,	@EmployedState char(2)
)
as
begin
/*
	History:
	jhernandez		12/01/07		Created.
	jhernandez		12/07/07		Added logic to add and update. Relations are unqiue by
									attorney id and company id.
	jhernandez		03/04/08		New columns, Employed, Created(By), LastModidified(By)
	jhernandez		03/12/08		Not using Employed, IsPrimary, AllowEmployedUpdate params
*/

if not exists (select 1 from tblAttyRelation where AttorneyID = @AttorneyID and CompanyID = @CompanyID)  begin
	-- Add new relation
	insert into tblAttyRelation (
		AttorneyID
	,	CompanyID
	,	AttyRelation
	,	EmployedState
	,	CreatedBy
	,	LastModifiedBy
	)
	values (
		@AttorneyID
	,	@CompanyID
	,	@AttyRelation
	,	@EmployedState
	,	@UserID
	,	@UserID
	)
end
else begin 	

	update 
		tblAttyRelation 
	set 
		AttyRelation = @AttyRelation,
		EmployedState = case when @EmployedState = '' then EmployedState else @EmployedState end, 
		LastModified = getdate(), 
		LastModifiedBy = @UserID 
	where 
		AttorneyID = @AttorneyID
		and CompanyID = @CompanyID 
		and (EmployedState <> @EmployedState or AttyRelation <> @AttyRelation)
end


end