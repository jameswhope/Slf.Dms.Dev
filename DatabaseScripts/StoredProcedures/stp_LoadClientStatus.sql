/****** Object:  StoredProcedure [dbo].[stp_LoadClientStatus]    Script Date: 11/19/2007 15:27:24 ******/
DROP PROCEDURE [dbo].[stp_LoadClientStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_LoadClientStatus]
	(
		@clientid int
	)

as


update
	tblclient
set
	currentclientstatusid = 
	(
		select top 1
			clientstatusid
		from
			tblroadmap
		where
			clientid = @clientid
		order by
			created desc, roadmapid desc
	)
where
	clientid = @clientid
GO
