IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_getBatches')
	BEGIN
		DROP  Procedure  stp_settlementimport_getBatches
	END

GO

CREATE Procedure stp_settlementimport_getBatches
as
BEGIN
	SELECT DISTINCT 
		[SettlementYear] = year(sett.created)
		, [SettlementMonth] = datename(m,sett.created)
		, [MonthNumber] = month(sett.created)
		, [NumSettlements] = count(distinct creditoraccountid)
	FROM tblSettlements AS sett 
	WHERE [status] = 'a' and active = 1 
	group by YEAR(sett.Created) ,datename(m,sett.created),	Month(sett.created)
	order by YEAR(sett.Created) desc,	Month(sett.created) desc
END



GRANT EXEC ON stp_settlementimport_getBatches TO PUBLIC


