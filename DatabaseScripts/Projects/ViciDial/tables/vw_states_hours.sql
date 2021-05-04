IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_States_Hours')
	BEGIN
		DROP  View vw_States_Hours
	END
GO

CREATE View vw_States_Hours  
AS
select st.stateid, st.abbreviation as statecode, 
startdate = dateadd(hh, -8 - z.FromUTC, cast(convert(varchar(10), getdate(), 101) + ' 08:00:00 AM' as datetime)), 
enddate = dateadd(hh, -8 - z.FromUTC, cast(convert(varchar(10), getdate(), 101) + ' 08:00:00 PM' as datetime)) 
from dbo.tblstate st
inner join dbo.tbltimezone z on z.timezoneid = st.defaulttimezone

GO

 