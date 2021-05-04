IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertC21Deposit')
	BEGIN
		DROP  Procedure  stp_InsertC21Deposit
	END

GO

CREATE Procedure stp_InsertC21Deposit
@ClientId int,
@TransactionDate datetime,
@CheckNumber varchar(50),
@Description varchar(255),
@Amount money,
@Hold datetime =null,
@HoldBy int = null,
@ImportId int = null,
@CreatedBy int
AS
BEGIN
	Insert into tblregister(ClientId, TransactionDate, CheckNumber, Description, Amount, Balance, EntryTypeId, IsFullyPaid, Hold, HoldBy, ImportId, Created, CreatedBy)
	Values(@ClientId, @TransactionDate, @CheckNumber, @Description, @Amount, 0, 3, 0, @Hold, @HoldBy, @ImportId, GetDate(), @CreatedBy )
	
	Select  scope_identity()
END

GO
 