IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositReplacementRegisterXref')
	BEGIN
		Create Table tblNonDepositReplacementRegisterXref(
			ReplacementId int not null,
			RegisterId int not null,
			Amount money,
			Created datetime not null  default getdate(),
			CreatedBy int not null
		)
	END

GO
