if object_id('tblDepositRuleAch') is null 
begin
	CREATE TABLE tblDepositRuleAch
	(
		RuleACHId   int  IDENTITY(1,1) NOT NULL,
		StartDate	datetime NOT NULL,
		EndDate datetime NULL,
		DepositDay   int  NOT NULL,
		DepositAmount  money  NOT NULL,
		Created   datetime  NOT NULL,
		CreatedBy	  int  NOT NULL,
		LastModified datetime  NOT NULL,
		LastModifiedBy   int  NOT NULL,
		ClientDepositId   int  NOT NULL ,
		BankAccountId   int NOT NULL,
		OldRuleId int null,
		Locked bit not null default 0
	)
end