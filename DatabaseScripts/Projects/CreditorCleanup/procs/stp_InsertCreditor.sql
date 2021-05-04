 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCreditor')
	BEGIN
		DROP  Procedure   stp_InsertCreditor
	END
GO

create procedure stp_InsertCreditor
(
	@CreditorGroupID int,
	@Name varchar(250),
	@Street varchar(50),
	@Street2 varchar(50),
	@City varchar(50),
	@StateID int,
	@ZipCode varchar(20),
	@UserID int
)
as
begin

if exists (select 1 from tblcreditor where creditorgroupid = @CreditorGroupID and street = @Street and isnull(street2,'') = @Street2 and city = @City and isnull(stateid,0) = isnull(@StateID,0) and zipcode = @ZipCode) begin
	select creditorid from tblcreditor where creditorgroupid = @CreditorGroupID and street = @Street and isnull(street2,'') = @Street2 and city = @City and stateid = @StateID and zipcode = @ZipCode
end
else begin
	insert tblcreditor (creditorgroupid,name,street,street2,city,stateid,zipcode,created,createdby,lastmodified,lastmodifiedby)
	values (@CreditorGroupID,@Name,@Street,@Street2,@City,@StateID,@ZipCode,getdate(),@UserID,getdate(),@UserID)
	
	select scope_identity()
end


end
go