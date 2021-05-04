IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_scanning_insertScanDescription')
	BEGIN
		DROP  Procedure  stp_scanning_insertScanDescription
	END

GO

CREATE Procedure stp_scanning_insertScanDescription

	(
		@DocID varchar(100),
		@Description text,
		@UserID int
	)
AS
BEGIN
	--Insert new row
	INSERT INTO tblDocScanDescriptions(DocID,Description,Created,CreatedBy,Modified,ModifiedBy)
	VALUES(@DocID,@Description,getdate(),@UserID,getdate(),@UserID)
END

GO


GRANT EXEC ON stp_scanning_insertScanDescription TO PUBLIC

GO


