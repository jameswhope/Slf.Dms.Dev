/****** Object:  StoredProcedure [dbo].[stp_GetClientID_or_AccountNo]    Script Date: 11/19/2007 15:27:05 ******/
DROP PROCEDURE [dbo].[stp_GetClientID_or_AccountNo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 10/22/2007
-- Description:	Get ClientID or AccountNo for a client
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetClientID_or_AccountNo] 
	-- Add the parameters for the stored procedure here
	@ClientID int = 0, 
	@AccountNo int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @ClientID <> 0
		begin
			SELECT ClientID, AccountNumber FROM tblClient WHERE ClientID = @ClientID
		end
	if @AccountNo <> 0
		begin
			SELECT ClientID, AccountNumber FROM tblClient WHERE AccountNumber = @AccountNo
		end
END
GO
