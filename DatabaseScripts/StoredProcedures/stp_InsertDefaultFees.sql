/****** Object:  StoredProcedure [dbo].[stp_InsertDefaultFees]    Script Date: 05/09/2008 13:34:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 05/09/2008
-- Description:	Inserts Default Fees in Comm Fee
-- =============================================
CREATE PROCEDURE [dbo].[stp_InsertDefaultFees] 
	@EntryTypeID int, 
	@CommStructID int 
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO tblCommFee(CommStructID, EntryTypeID, [Percent], Created, CreatedBy, LastModified, LastModifiedBy) 
	VALUES (@CommStructID, @EntryTypeID, 1, GETDATE(), 493, GETDATE(), 493)
END
