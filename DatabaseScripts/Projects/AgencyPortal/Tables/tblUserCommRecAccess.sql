IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserCommRecAccess')
	BEGIN
		CREATE TABLE tblUserCommRecAccess
		(
			UserId int not null,  
			CommRecId int not null,
			constraint pk_UserCommRecAccess primary key clustered ( UserId, CommRecId ),
			foreign key (CommRecId) references tblCommRec(CommRecId) on delete cascade
		)
	END
GO

