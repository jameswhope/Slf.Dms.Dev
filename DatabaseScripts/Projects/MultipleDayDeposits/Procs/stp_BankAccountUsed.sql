IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_BankAccountUsed')
	BEGIN
		DROP  Procedure  stp_BankAccountUsed
	END

GO

CREATE Procedure stp_BankAccountUsed
@BankAccountId int
AS
Select CT = count(b.BankAccountId) from tblClientBankAccount b
inner join 
(select ClientId, RoutingNumber, AccountNumber from tblnacharegister2
Where ClientId is not null and RoutingNumber is not null and AccountNumber is not null
Union All
select ClientId, RoutingNumber, AccountNumber from tblnacharegister
Where ClientId is not null and RoutingNumber is not null and AccountNumber is not null) b1
on b.ClientId = b1.ClientId and b.RoutingNumber = b1.RoutingNumber and b.AccountNumber = b1.AccountNumber
Where b.BankAccountId = @BankAccountId

GO

 

