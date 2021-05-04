if exists (select * from sysobjects where name = 'stp_NegotiationInsertCreditor')
	drop procedure stp_NegotiationInsertCreditor
go

create procedure stp_NegotiationInsertCreditor
(
	@CreditorName varchar(50)
,	@Street1 varchar(50)
,	@Street2 varchar(50)
,	@City varchar(50)
,	@StateID int
,	@ZipCode varchar(50)
,	@CreatedBy int
,	@Validated bit
)
as
begin

insert tblCreditor (
	Name,
	Street,
	Street2,
	City,
	StateID,
	ZipCode,
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy,
	Validated
)
values (
	@CreditorName,
	@Street1,
	@Street2,
	@City,
	@StateID,
	@ZipCode,
	getdate(),
	@CreatedBy,
	getdate(),
	@CreatedBy,
	@Validated
)


select scope_identity()


end