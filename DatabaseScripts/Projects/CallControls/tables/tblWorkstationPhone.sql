 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblWorkstationPhone')
	BEGIN
		 CREATE TABLE tblWorkstationPhone
		(	
			WorkstationId int not null identity(1,1) Primary Key,
			WorkstationName varchar(255) not null,
			Extension int not null,
			PCAudio bit not null default 1		
		)
		
 		CREATE UNIQUE INDEX idx_UniqueWorkstationPhone ON tblWorkstationPhone(WorkstationName)

	END