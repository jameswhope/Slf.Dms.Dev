/****** Object:  Trigger [trg_tblRoadmap_UpdateCurrentClientStatus_Update]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRoadmap_UpdateCurrentClientStatus_Update] ON [dbo].[tblRoadmap]
FOR update
AS

DECLARE @clientId int
SELECT @clientId=ClientId FROM inserted

exec stp_LoadClientStatus @clientid
GO
