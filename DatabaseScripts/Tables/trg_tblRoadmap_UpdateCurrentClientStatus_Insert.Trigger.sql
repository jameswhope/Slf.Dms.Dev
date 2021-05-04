/****** Object:  Trigger [trg_tblRoadmap_UpdateCurrentClientStatus_Insert]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRoadmap_UpdateCurrentClientStatus_Insert] ON [dbo].[tblRoadmap]
FOR Insert
AS

DECLARE @clientId int
SELECT @clientId=ClientId FROM inserted

exec stp_LoadClientStatus @clientid
GO
