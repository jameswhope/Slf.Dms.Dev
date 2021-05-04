IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositType')
	BEGIN
		Create Table tblNonDepositType(
			NonDepositTypeId int not null Primary Key Clustered,
			ShortDescription varchar(10) not null,
			Description varchar(100) not null
		)
	END
GO

  