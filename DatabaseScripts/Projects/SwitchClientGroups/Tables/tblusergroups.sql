IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblusergroups')
	BEGIN
		CREATE TABLE tblusergroups
		(  userid int not null,
		   usergroupid int not null,
		   isdefaultgroup bit not null default 0,
		   created datetime not null,
		   createdby int not null,
		   lastmodified datetime not null,
		   lastmodifiedby int not null
		   CONSTRAINT [PK_userid_usergroupId] PRIMARY KEY CLUSTERED (Userid, UserGroupId)
		)
	END
GO

 