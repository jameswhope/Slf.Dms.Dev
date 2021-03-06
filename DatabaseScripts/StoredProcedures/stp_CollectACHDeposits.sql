/****** Object:  StoredProcedure [dbo].[stp_CollectACHDeposits]    Script Date: 11/19/2007 15:26:57 ******/
DROP PROCEDURE [dbo].[stp_CollectACHDeposits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_CollectACHDeposits]
	(
		@fordate datetime = null
	)

as


-----------------------------------------------------------------------------------------------
-- LOGIC FOR COLLECTING MONTHLY ACH DEPOSITS
-- (1) Determine if the for date is the last day of the month.  If it is, include any day
--     after it numerically up through 31
-- (2) Create temp table and fill it with all clients that should be collected for this
--     time period.  Use the following:
--     (a) Find where clients match up in the ACH rules first.
--     (b) Find where clients match up by their default records, excluding any that were
--         found by matching up in the ACH rules.
-- (4) Analyze the day after the current process day.  if it is a no bank day, run this
--     proc again for that day
-----------------------------------------------------------------------------------------------

exec stp_CollectACHDeposits_S @fordate
exec stp_CollectACHDeposits_P @fordate
GO
