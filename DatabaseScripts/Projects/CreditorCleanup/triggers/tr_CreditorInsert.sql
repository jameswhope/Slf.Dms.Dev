
if object_id('tr_CreditorInsert','TR') is not null
	drop trigger tr_CreditorInsert
go

create trigger tr_CreditorInsert on tblCreditor after insert
as
begin

declare @CreditorID int, @Name varchar(250), @CreatedBy int, @Street varchar(50),
		@Street2 varchar(50), @City varchar(50), @StateID int, @ZipCode varchar(50)

select @CreditorID = CreditorID, @Name = Name, @CreatedBy = CreatedBy, @Street = Street,
		@Street2 = Street2, @City = City, @StateID = StateID, @ZipCode = ZipCode 
from INSERTED 

insert tblCreditorHistory (CreditorID,Name,CreatedBy,Street,Street2,City,StateID,ZipCode)
values (@CreditorID,@Name,@CreatedBy,@Street,@Street2,@City,@StateID,@ZipCode)

end
go    