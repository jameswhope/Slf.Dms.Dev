if exists (select * from sysobjects where name = 'stp_InsertAttorney')
	drop procedure stp_InsertAttorney
go

create procedure stp_InsertAttorney
(
	@FirstName varchar(50)
,	@LastName varchar(50)
,	@MiddleName varchar(50)
,	@Suffix varchar(50) = null
,	@Address1 varchar(150) = null
,	@Address2 varchar(150) = null
,	@City varchar(50) = null
,	@State varchar(50) = null
,	@Zip varchar(15) = null
,	@Phone1 varchar(15) = null
,	@Phone2 varchar(15) = null
,	@Fax varchar(15) = null
,	@CreatedBy int
)
as
begin
/*
	Purpose:	Adds a new attorney record. Returns AttorneyID.

	History:
	11/30/07	jhernandez		Created.
	12/03/07	jhernandez		Checking for dups before inserting.
	12/07/07	jhernandez		Removed state fields that were moved to pivot tables. Also added
								optional parameters.
*/

if exists (select 1 from tblAttorney where FirstName = @FirstName and LastName = @LastName and isnull(MiddleName,'') = @MiddleName) begin
	-- Attorney name already exists, return their ID
	select AttorneyID from tblAttorney where FirstName = @FirstName and LastName = @LastName
end
else begin
	-- New attorney
	insert tblAttorney (
		FirstName
	,	LastName
	,	MiddleName
	,	Suffix
	,	Address1
	,	Address2
	,	City
	,	State
	,	Zip
	,	Phone1
	,	Phone2
	,	Fax
	,	Created
	,	CreatedBy
	,	LastModified
	,	LastModifiedBy
	)
	values (
		@FirstName
	,	@LastName
	,	@MiddleName
	,	@Suffix
	,	@Address1
	,	@Address2
	,	@City
	,	@State
	,	@Zip
	,	@Phone1
	,	@Phone2
	,	@Fax
	,	getdate()
	,	@CreatedBy
	,	getdate()
	,	@CreatedBy
	)

	select scope_identity()
end


end