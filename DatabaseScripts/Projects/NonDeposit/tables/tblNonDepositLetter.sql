IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositLetter')
	BEGIN
		CREATE TABLE tblNonDepositLetter
		(
			NonDepositLetterId int not null identity(1,1) Primary Key,
			NonDepositId int not null,
			ReplacementId int null,
			RegisterId int null,
			LetterType varchar(50) not null,
			Created datetime not null,
			CreatedBy int not null,
			PrintedDate datetime null,
			PrintedBy int null 
		)
END

GO
