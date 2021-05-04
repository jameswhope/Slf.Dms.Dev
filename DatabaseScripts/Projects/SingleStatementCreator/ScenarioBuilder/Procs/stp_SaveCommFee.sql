if exists (select * from sysobjects where name = 'stp_SaveCommFee')
	drop procedure stp_SaveCommFee
go

create procedure stp_SaveCommFee
(
	@CommStructID int,
	@EntryTypeID int,
	@Percent money,
	@IsPercent bit,
	@UserID int,
	@Order int = 0
)
as
begin

insert tblCommFee 
(
	CommStructID,
	EntryTypeID,
	[Percent],
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy--,
	--[Order],
	--IsPercent
)
values
(
	@CommStructID,
	@EntryTypeID,
	@Percent,
	getdate(),
	@UserID,
	getdate(),
	@UserID--,
	--@Order,
	--@IsPercent
)


end