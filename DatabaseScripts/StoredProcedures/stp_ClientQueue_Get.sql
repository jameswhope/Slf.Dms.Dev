/****** Object:  StoredProcedure [dbo].[stp_ClientQueue_Get]    Script Date: 11/19/2007 15:26:56 ******/
DROP PROCEDURE [dbo].[stp_ClientQueue_Get]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_ClientQueue_Get]
(
	@AgencyID int
)
AS

BEGIN

	select 
		*
	from
		tblClientQueue
	where
		agencyid=@agencyid
	order by
		row	

END
GO
