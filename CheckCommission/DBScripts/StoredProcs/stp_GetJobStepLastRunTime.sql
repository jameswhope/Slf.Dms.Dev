IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetJobStepLastRunTime')
	BEGIN
		DROP  Procedure  stp_GetJobStepLastRunTime
	END

GO

CREATE PROCEDURE  stp_GetJobStepLastRunTime  
@StepName Varchar(max)
AS
BEGIN
select top 1 CONVERT(DATETIME, RTRIM(run_date)) + (run_time * 9  + run_time % 10000 * 6 + run_time % 100 * 10 + 25 * run_duration) / 216e4 
from msdb.dbo.sysjobhistory
where step_name = @StepName
and run_status = 1
order by instance_id desc
END

GO

