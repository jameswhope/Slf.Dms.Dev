IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBofAMasterAccount')
	BEGIN
		DROP  Procedure  stp_GetBofAMasterAccount
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/05/2009
-- Description:	Gets the B of A Master Account number
-- =============================================
CREATE PROCEDURE stp_GetBofAMasterAccount 
AS
BEGIN
	SET NOCOUNT ON;
		SELECT AccountNumber FROM tblCommRec WHERE Abbreviation = 'LPSI'
END
GO
