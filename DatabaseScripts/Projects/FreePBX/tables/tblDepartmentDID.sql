IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDepartmentDID')
	BEGIN
		CREATE  Table tblDepartmentDID(
			DepartmentId int not null,
			DID varchar(10) not null,
			Created  datetime not null default GetDate(),
			CreatedBy int not null,
			primary key (DepartmentId, DID),
			foreign key (DepartmentID) references tblDepartment(DepartmentID) on delete no action
		)
	END
	
GO

INSERT INTO tblDepartmentDID(DepartmentId, DID, CreatedBy) VALUES (1,'9519684375',785)

INSERT INTO tblDepartmentDID(DepartmentId, DID, CreatedBy) VALUES (2,'9519684380',785)

INSERT INTO tblDepartmentDID(DepartmentId, DID, CreatedBy) VALUES (3,'9519684385',785)

INSERT INTO tblDepartmentDID(DepartmentId, DID, CreatedBy) VALUES (4,'9519684390',785)