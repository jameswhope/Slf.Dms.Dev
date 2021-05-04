/****** Object:  Trigger [trg_tblRoadmap_UpdateCurrentClientStatus_Delete]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trg_tblRoadmap_UpdateCurrentClientStatus_Delete] ON [dbo].[tblRoadmap]
FOR delete
AS

DECLARE @clientId int
SELECT @clientId=ClientId FROM deleted

exec stp_LoadClientStatus @clientid
GO
