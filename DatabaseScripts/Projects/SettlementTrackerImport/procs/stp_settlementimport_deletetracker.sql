IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_deletetracker')
	BEGIN
		DROP  Procedure  stp_settlementimport_deletetracker
	END

GO

CREATE Procedure stp_settlementimport_deletetracker

	(
		@TrackerImportID int 
	)
AS
BEGIN
	DELETE FROM tblSettlementTrackerImports WHERE (TrackerImportID = @TrackerImportID)
END

GO


GRANT EXEC ON stp_settlementimport_deletetracker TO PUBLIC

GO


