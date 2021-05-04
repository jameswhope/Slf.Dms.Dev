IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SettlementImport_CountSettlements')
	BEGIN
		DROP  Procedure  stp_SettlementImport_CountSettlements
	END

GO

CREATE Procedure stp_SettlementImport_CountSettlements
(
@year int,
@month int
)
as
BEGIN
	select count(*) 
	from tblSettlementTrackerImports
	where year(date) = @year and month(date) = @month
END


GRANT EXEC ON stp_SettlementImport_CountSettlements TO PUBLIC

