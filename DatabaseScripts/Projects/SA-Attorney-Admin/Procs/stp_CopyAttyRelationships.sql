if exists (select * from sysobjects where name = 'stp_CopyAttyRelationships')
	drop procedure stp_CopyAttyRelationships
go

create procedure stp_CopyAttyRelationships
(
	@SourceCompanyID int
,	@DestCompanyID int
,	@CopyPrimaries bit
,	@UserID int
)
as 
begin
/*
	History:
	jhernandez		03/06/08		Created
	jhernandez		03/11/08		Dont copy employed relationships
	jhernandez		03/17/08		Copy EmployedState
*/

insert tblAttyRelation (AttorneyID,CompanyID,AttyRelation,EmployedState,CreatedBy,LastModifiedBy)
select AttorneyID,CompanyID,AttyRelation,EmployedState,@UserID,@UserID
from (
	select AttorneyID,@DestCompanyID [CompanyID],AttyRelation,EmployedState
	from tblAttyRelation
	where CompanyID = @SourceCompanyID
) sub
where not exists (select 1 from tblAttyRelation r where r.AttorneyID = sub.AttorneyID and r.CompanyID = sub.CompanyID)


if @CopyPrimaries = 1 begin
	insert tblCompanyStatePrimary (CompanyID,AttorneyID,[State],CreatedBy)
	select CompanyID,AttorneyID,[State],@UserID
	from (
		select @DestCompanyID [CompanyID],AttorneyID,[State]
		from tblCompanyStatePrimary
		where CompanyID = @SourceCompanyID
	) sub
	where not exists (select 1 from tblCompanyStatePrimary p where p.CompanyID = sub.CompanyID and p.State = sub.State)
end


end