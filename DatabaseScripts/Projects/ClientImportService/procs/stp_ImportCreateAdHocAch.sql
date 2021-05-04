IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportCreateAdHocAch')
	BEGIN
		DROP  Procedure  stp_ImportCreateAdHocAch
	END

GO

CREATE Procedure stp_ImportCreateAdHocAch
@ClientID int, 
@RegisterID int = null,
@DepositDate datetime, 
@DepositAmount money, 
@BankName varchar(50), 
@BankRoutingNumber varchar(50), 
@BankAccountNumber varchar(50), 
@BankType varchar(1) = null, 
@UserId int,
@InitialDraftYN bit = 0
AS
BEGIN
Insert into tblAdHocACH(
ClientID, RegisterID, DepositDate, DepositAmount, 
BankName, BankRoutingNumber, BankAccountNumber, BankType, 
Created, CreatedBy, LastModified, LastModifiedBy, 
InitialDraftYN)
Values(@ClientID, @RegisterID, @DepositDate, @DepositAmount, 
@BankName, @BankRoutingNumber, @BankAccountNumber, @BankType, 
GetDate(), @UserId, GetDate(), @UserId, 
@InitialDraftYN)
END

GO

