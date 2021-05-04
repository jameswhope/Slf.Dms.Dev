IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDeposit')
	BEGIN
		CREATE TABLE tblNonDeposit
		(NonDepositId int identity(1,1) not null Primary Key Clustered,
		 Created datetime  NOT NULL,
		 CreatedBy int  NOT NULL,
		 LastModified datetime  NOT NULL,
		 LastModifiedBy int  NOT NULL,
		 ClientId int  NOT NULL,
 		 MatterId int  NOT NULL,
 		 MissedDate datetime null,
 		 DepositAmount money null,
 		 DepositId int null,
 		 NonDepositTypeId int not null,
 		 Deleted datetime  NULL,
		 DeletedBy int  NULL,
		 DateLetterSent datetime null,
		 LetterType varchar(50) null,
		 CurrentReplacementId int null,
		 PlanId int null
 		)
	END
GO


  
