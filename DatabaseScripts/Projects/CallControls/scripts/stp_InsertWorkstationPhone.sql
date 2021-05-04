IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertWorkstationPhone')
	BEGIN
		DROP  Procedure  stp_InsertWorkstationPhone
	END

GO

CREATE Procedure stp_InsertWorkstationPhone
@WorkstationName varchar(255),
@Extension int,
@PCAudio bit = 1
AS
Insert Into tblWorkstationPhone(WorkstationName, Extension, PCAudio)
VALUES (@WorkstationName, @Extension, @PCAudio)

GO
 