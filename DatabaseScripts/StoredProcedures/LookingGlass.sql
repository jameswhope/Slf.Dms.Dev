/****** Object:  StoredProcedure [dbo].[LookingGlass]    Script Date: 11/19/2007 15:26:49 ******/
DROP PROCEDURE [dbo].[LookingGlass]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[LookingGlass]


as
DECLARE @ProcessID int 
DECLARE @Handle VARBINARY(255)

CREATE TABLE #DmsWho1
(
	ProcessID INT,
	UserID INT,
	UserName VARCHAR(255),
	[Status] VARCHAR(255),
	Reads INT,
	Writes INT,
	CPU_Time INT,
	Elapsed_Time INT,
	ROW_COUNT INT,	
	LastSQL VARCHAR(8000),
	[handle] VARBINARY(255)	
)

INSERT INTO #DmsWho1 
SELECT pu.SPID,
	   pu.UserID,
	   u.UserName,
	   [Status] = MAX(UPPER(COALESCE
	   (
			r.[status],
			tt.[task_state],
			s.[status],
			''
	    ))),
	   Reads = MAX(COALESCE
	   (
			NULLIF(r.[reads], 0),
			NULLIF(s.[reads], 0),
			c.[num_reads],
			0
	   )),
	   [Writes] = MAX(COALESCE
	   (
			NULLIF(r.[writes], 0),
			NULLIF(s.[writes], 0),
			c.[num_writes],
			0
	   )),
	   [CPU_Time] = MAX(COALESCE
	   (
			NULLIF(tt.[CPU_Time], 0),
			NULLIF(r.[cpu_time], 0), 
			NULLIF(s.[cpu_time], 0),
			s.[total_scheduled_time], 
			0
	    )),
	    [Elapsed_Time] = MAX(COALESCE
		(
			r.[total_elapsed_time],
			s.[total_elapsed_time]
		)),
		[Row_Count] = MAX(s.[row_count]),
	   NULL,
	   r.sql_handle
FROM tblSysProcessUser pu
INNER JOIN tblUser u ON pu.UserID = u.UserID
INNER JOIN sys.dm_exec_requests r ON pu.SPID = r.[session_id]
LEFT OUTER JOIN sys.dm_exec_sessions s ON pu.SPID = s.[session_id]
LEFT OUTER JOIN sys.dm_os_waiting_tasks wt ON pu.SPID = wt.[session_id]
LEFT OUTER JOIN sys.dm_exec_connections c ON c.[session_id] = pu.SPID
LEFT OUTER JOIN
	(
		SELECT ot.[session_id],
			   ot.[task_state],
			   [CPU_Time] = MAX(oth.[usermode_time])
		FROM sys.dm_os_tasks ot
		INNER JOIN sys.dm_os_workers ow ON ot.[worker_address] = ow.[worker_address]
		INNER JOIN sys.dm_os_threads oth ON ow.[thread_address] = oth.[thread_address]
		GROUP BY ot.[session_id], ot.[task_state]
	) tt ON pu.SPID = tt.[session_id]
GROUP BY pu.SPID, pu.UserID, u.UserName, r.sql_handle

declare dmswhoCUR cursor local for select ProcessID, Handle from #DmsWho1 
open dmswhoCUR
fetch next from dmswhoCUR into @ProcessID, @Handle
while @@fetch_status = 0
	BEGIN
		UPDATE #DmsWho1 
		SET [LastSQL] = (
							SELECT [text] 
							FROM sys.dm_exec_sql_text(@Handle)
						)
		WHERE ProcessID = @ProcessID	     
	  fetch next from dmswhoCUR into @ProcessID, @Handle
      END
	
close dmswhoCUR
deallocate dmswhoCUR


SELECT ProcessID, UserID, UserName, [Status], Reads, Writes, CPU_Time, Elapsed_Time, ROW_COUNT, LastSQL FROM #DmsWho1
DROP TABLE #DmsWho1
GO
