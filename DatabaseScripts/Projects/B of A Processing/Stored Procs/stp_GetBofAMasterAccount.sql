IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBofAMasterAccount')
	BEGIN
		DROP  Procedure  stp_GetBofAMasterAccount
	END

GO

/****** Object:  StoredProcedure [dbo].stp_GetBofAMasterAccount]    Script Date: 01/28/2010 16:29:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/05/2009
-- Updated: 08/04/2010
-- Description:	Gets the B of A Master Account number
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetBofAMasterAccount] 
(
	@BankID INT
)
AS
BEGIN
	SET NOCOUNT ON;
		SELECT WooleryMasterAcct FROM tblBank_NACHA WHERE NACHABankID = @BankID
END


GO

/*
GRANT EXEC ON [stp_GetBofAMasterAccount TO PUBLIC

GO
*/

