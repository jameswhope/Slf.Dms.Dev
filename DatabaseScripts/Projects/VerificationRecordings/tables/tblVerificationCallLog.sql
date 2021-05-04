IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationCallLog')
	BEGIN
		CREATE TABLE tblVerificationCallLog(
			VerificationCallLogId int identity(1,1) not null Primary Key,
			VerificationCallId int not null,
			QuestionNo int not null,
			--QuestionText varchar(max) not null,
			AnsweredNo bit not null default 0, 
			Created datetime not null default GetDate()
)
	END
GO




