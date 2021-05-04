IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositReplacement')
	BEGIN
		Create Table tblNonDepositReplacement(
			ReplacementId int not null identity(1,1) Primary Key Clustered,
			NonDepositId int not null,
			DepositDate datetime not null,
			DepositAmount money not null,
			Created datetime not null  default getdate(),
			CreatedBy int not null,
			LastModified datetime not null default getdate(),
			LastModifiedBy int not null,
			AdHocACHId int null,
			Closed bit not null default 0
		)
	END

GO

