if exists (select * from sysobjects where name = 'stp_SaveStatePrimary')
	drop procedure stp_SaveStatePrimary
go

create procedure stp_SaveStatePrimary
(
	@CompanyID int
,	@State char(2)
,	@AttorneyID int
,	@UserId int
)
as
begin


if @AttorneyID > 0 begin 
	-- user has selected to assign a state primary
	if exists (select 1 from tblCompanyStatePrimary where CompanyID = @CompanyID and State = @State and AttorneyID <> @AttorneyID) begin
		-- user has changed who the state primary attorney is for this state
		update tblCompanyStatePrimary
		set AttorneyID = @AttorneyID, LastModified = getdate(), LastModifiedBy = @UserID
		where CompanyID = @CompanyID and State = @State
	end
	else if not exists (select 1 from tblCompanyStatePrimary where CompanyID = @CompanyID and State = @State) begin
		-- adding a new state primary
		insert tblCompanyStatePrimary (CompanyID, AttorneyID, [State], CreatedBy) values (@CompanyID, @AttorneyID, @State, @UserID)
	end
end
else begin 
	-- user has selected to remove the primary for this state or there is no state primary needed
	delete from tblCompanyStatePrimary where CompanyID = @CompanyID and State = @State
end


end