IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDepartment')
	BEGIN
		CREATE  Table tblDepartment(
			DepartmentId int not null identity(1,1) primary key clustered,
			DepartmentName varchar(100) not null,
			Created datetime not null default GetDate(),
			CreatedBy int not null,
			DefaultPage  varchar(255) null,
			RefType  varchar(50) null,
			OutCallerId varchar(50) null			
		)
	END
GO

INSERT INTO tblDepartment(DepartmentName, CreatedBy, DefaultPage, RefType, OutCallerId) VALUES('CID',785,'~/clients/Enrollment/default.aspx','LEAD', NULL)
INSERT INTO tblDepartment(DepartmentName, CreatedBy, DefaultPage, RefType, OutCallerId) VALUES('Client Services',785,'~/search.aspx','CLIENT', NULL)
INSERT INTO tblDepartment(DepartmentName, CreatedBy, DefaultPage, RefType, OutCallerId) VALUES('Creditor Services',785,'~/negotiation/default.aspx',NULL, NULL)
INSERT INTO tblDepartment(DepartmentName, CreatedBy, DefaultPage, RefType, OutCallerId) VALUES('Litigation',785,'~/search.aspx','CLIENT', NULL)