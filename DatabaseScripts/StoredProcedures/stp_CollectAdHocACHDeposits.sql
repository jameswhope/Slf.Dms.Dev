/****** Object:  StoredProcedure [dbo].[stp_CollectAdHocACHDeposits]    Script Date: 11/19/2007 15:26:58 ******/
DROP PROCEDURE [dbo].[stp_CollectAdHocACHDeposits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectAdHocACHDeposits]
	(
		@fordate datetime = null
	)

as

-----------------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING MONTHLY ACH DEPOSITS
-- (1)	Create temp table and fill it with all clients that have AdHoc ACH's which should be 
--		collected for the selected day.
-- (2)	Run the process against those AdHoc ACH's.
-- (3)	Analyze the day after the current process day.  if it is a no bank day, run this
--		proc again for that day
-----------------------------------------------------------------------------------------------

exec stp_CollectAdHocACHDeposits_S @fordate
exec stp_CollectAdHocACHDeposits_P @fordate
GO
