IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SettlementImport_DeleteSettlements')
	BEGIN
		DROP  Procedure  stp_SettlementImport_DeleteSettlements
	END

GO

CREATE Procedure stp_SettlementImport_DeleteSettlements
(
@year int,
@month int
)
as
BEGIN
	/*
	declare @year int
	declare @month int

	set @year = 2009
	set @month = 7
	*/
	delete from tblSettlementTrackerImports	WHERE YEAR(Date) = @year AND MONTH(Date) = @month

END



GRANT EXEC ON stp_SettlementImport_DeleteSettlements TO PUBLIC



