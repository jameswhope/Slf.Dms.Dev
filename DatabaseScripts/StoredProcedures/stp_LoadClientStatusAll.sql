/****** Object:  StoredProcedure [dbo].[stp_LoadClientStatusAll]    Script Date: 11/19/2007 15:27:24 ******/
DROP PROCEDURE [dbo].[stp_LoadClientStatusAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_LoadClientStatusAll]

as


update
	tblclient
set
	currentclientstatusid = 
	(
		select
			r.clientstatusid
		from
			tblroadmap r inner join
			(
				select
					max(roadmapid) as roadmapid
				from
					tblroadmap
				group by
					clientid
			)
			as s on r.roadmapid = s.roadmapid
		where
			r.clientid = tblclient.clientid
	)
GO
