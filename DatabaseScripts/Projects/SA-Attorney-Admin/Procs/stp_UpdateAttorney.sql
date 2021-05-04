if exists (select * from sysobjects where name = 'stp_UpdateAttorney')
	drop procedure stp_UpdateAttorney
go

create procedure stp_UpdateAttorney
(
	@AttorneyID int
,	@FirstName varchar(50)
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
,	@LastModifiedBy int
)
as
begin
/*
	Purpose:	Updates an attorney record.

	History:
	12/03/07	jhernandez		Created.
	12/07/07	jhernandez		Added optional parameters
*/

update 
	tblAttorney
set
	FirstName = @FirstName
,	LastName = @LastName
,	MiddleName = @MiddleName
,	Suffix	= @Suffix
,	Address1 = @Address1
,	Address2 = @Address2
,	City = @City
,	State = @State
,	Zip = @Zip
,	Phone1 = @Phone1
,	Phone2 = @Phone2
,	Fax = @Fax
,	LastModified = getdate()
,	LastModifiedBy = @LastModifiedBy
where
	AttorneyID = @AttorneyID


end 