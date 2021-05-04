IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_areacode_state')
	BEGIN
		DROP  View vw_areacode_state
	END
GO

CREATE View vw_areacode_state AS
select distinct  stateid as Stateid, npa as AreaCode from tblareacodeworld

GO

 