/****** Object:  StoredProcedure [dbo].[stp_GetRelationsForPhoneCall]    Script Date: 11/19/2007 15:27:15 ******/
DROP PROCEDURE [dbo].[stp_GetRelationsForPhoneCall]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetRelationsForPhoneCall]
	(
		@phonecallid int
	)

as

select 
	phonecallrelationid,
	pc.phonecallid,
	pcr.relationtypeid,
	pcr.relationid,
	rt.name as relationtypename,
	dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,
	rt.iconurl,
	rt.navigateurl
from
	tblphonecallrelation pcr inner join
	tblphonecall pc on pcr.phonecallid=pc.phonecallid inner join
	tblrelationtype rt on pcr.relationtypeid=rt.relationtypeid
where 
	pc.phonecallid=@phonecallid
GO
