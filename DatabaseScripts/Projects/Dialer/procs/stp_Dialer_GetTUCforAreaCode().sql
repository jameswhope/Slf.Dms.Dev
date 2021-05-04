IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetTimeZoneforAreaCode')
	BEGIN
		DROP  Procedure  stp_Dialer_GetTimeZoneforAreaCode
	END

GO

CREATE Procedure stp_Dialer_GetTimeZoneforAreaCode
@AreaCode varchar(3)
AS
Select v.stateId, s.defaulttimezone, z.fromutc  
from vw_areacode_state v 
inner join tblstate s on s.stateid = v.stateid 
inner join tbltimezone z on z.timezoneid = s.defaulttimezone
where areacode = @AreaCode

GO


