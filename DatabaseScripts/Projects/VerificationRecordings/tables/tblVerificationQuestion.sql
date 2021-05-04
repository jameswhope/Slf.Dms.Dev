IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationQuestion')
	BEGIN
	CREATE TABLE tblVerificationQuestion(
		QuestionId int identity(1,1) not null primary key,
		QuestionTextEN varchar(max) not null,
		QuestionTextSp varchar(max) null,
	    [Order] int not null
	)
	END
GO



