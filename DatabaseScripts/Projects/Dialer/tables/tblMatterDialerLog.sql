IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblMatterDialerLog')
	BEGIN
		Create Table tblMatterDialerLog(MatterDialerLogId int not null identity(1,1) Primary Key,
									    PrimaryCallMadeId int not null,
									    MatterId int not null,
									    ReasonId int not null,
										Created datetime not null)
	END
GO

 
