IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNotMappedC21items')
	BEGIN
		DROP  Procedure  stp_GetNotMappedC21items
	END

GO

CREATE Procedure stp_GetNotMappedC21items
AS
BEGIN
	Select 
TransactionId as [TransactionId],
ReceivedDate as [Received Date],
ProcessedDate as [Processed Date],
AccountNumber as [Account Number],
CheckNumber as [Check Number],
Amount as [Amount],
CASE [Status] 
	When 0 Then 'Good'
	When 1 Then 'Warning'
	When 2 Then 'Error'
	When 3 Then 'Returned'
	Else 'Unknown'
END as [Status],
CASE [State]
	When 0 Then 'Received'
	When 1 Then 'Processed'
	Else 'Unknown'
END as [State],
CASE CheckType
	When 1 Then 'Order'
	When 2 Then 'Bearer'
	Else 'Unknown'
END as [Check Type],
FrontImagePath as [Front Image],
BackImagePath as [Back Image],
Hide
From tblC21BatchTransaction
Where ItemType <> 2
And isnull(DepositId, '') = ''
And Closed = 1
--And Hide = 0
Order By ProcessedDate Desc
END


GO

