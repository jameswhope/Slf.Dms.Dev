/****** Object:  StoredProcedure [dbo].[stp_ClientQueue_DeleteRow]    Script Date: 11/19/2007 15:26:55 ******/
DROP PROCEDURE [dbo].[stp_ClientQueue_DeleteRow]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_ClientQueue_DeleteRow]
(
	@AgencyID int,
	@Row int
)
AS

BEGIN

delete from 
	tblclientqueue 
where 
	agencyid = @agencyid 
	and row = @row

update 
	tblclientqueue 
set 
	row = row - 1 
where
	agencyid = @agencyid 
	and row > @row

END
GO
