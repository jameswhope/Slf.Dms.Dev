IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateC21BatchTransaction')
	BEGIN
		DROP  Procedure  stp_UpdateC21BatchTransaction
	END

GO

CREATE Procedure stp_UpdateC21BatchTransaction
@TransactionId varchar(50),
@FrontImagePath varchar(max) = Null,
@BackImagePath varchar(max) = Null,
@DepositId int = Null,
@Status int = Null,
@State int = Null,
@ItemType int = Null,
@CheckType int = Null,
@CheckNumber varchar(50) = Null,
@AccountNumber varchar(50) = Null,
@Amount money = Null,
@ReceivedDate datetime = Null,
@ProcessedDate datetime = Null,
@ExceptionCode varchar(255) = Null,
@Notes varchar(max) = Null,
@Closed bit = Null,
@LastMapped datetime = Null,
@LastMappedBy int = Null
AS
Update tblC21BatchTransaction Set
FrontImagePath = isnull(@FrontImagePath, FrontImagePath),
BackImagePath = isnull(@BackImagePath, BackImagePath),
DepositId = isnull(@DepositId, DepositId),
[Status] = isnull(@Status, Status),
[State] = isnull(@State, State),
ReceivedDate = isnull(@ReceivedDate, ReceivedDate),
ProcessedDate = isnull(@ProcessedDate, ProcessedDate),
ItemType = isnull(@ItemType, ItemType),
CheckType = isnull(@CheckType, CheckType),
CheckNumber = isnull(@CheckNumber, CheckNumber),
AccountNumber = isnull(@AccountNumber, AccountNumber),
Amount = isnull(@Amount, Amount),
ExceptionCode = isnull(@ExceptionCode, ExceptionCode),
Notes = isnull(@Notes, Notes),
Closed = isnull(@Closed, Closed),
LastMapped = isnull(@LastMapped, LastMapped),
LastMappedBy = isnull(@LastMappedBy, LastMappedBy)
Where TransactionId = @TransactionId

GO
