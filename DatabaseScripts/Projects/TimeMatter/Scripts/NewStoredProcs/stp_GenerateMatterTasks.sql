set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <02 - 16 December 2009>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : AutoGenerate TaskType=9

*/



CREATE procedure [dbo].[stp_GenerateMatterTasks]
(
	@MatterId int,
	--@CreditorInstanceId int,
	@ClientId int,	
	@UserId int

	
)

AS 

BEGIN

DECLARE @OldMaxTaskId int
DECLARE @NewMaxTaskId int
SET @OldMaxTaskId =(SELECT MAX(TaskId) from dbo.tblTask)

-- need to add creditor Instance too!

INSERT INTO tblTask
(
ParentTaskID
,TaskTypeID
,Description
,AssignedTo
,Due
,Resolved
,ResolvedBy
,TaskResolutionID
,Created
,CreatedBy
,LastModified
,LastModifiedBy

)
select 

NULL,
TaskTypeId,
DefaultDescription+'-' +(SELECT MatterNumber from dbo.tblMatter Where MatterId=@MatterId) ,
@UserId as AssignTo,
DateADD(d,1,getdate()) as DueDate,
NULL as Resolved,
NULL as ResolvedBy,
NULL as TaskResolutionId,
getdate(),
@UserId,
getdate(),
@UserId

from dbo.tblTasktype where TaskTypeCategoryId=9 


SET @NewMaxTaskId =(SELECT MAX(TaskId) from dbo.tblTask)



insert INTO tblClientTask
(

ClientID
,TaskID
,Created
,CreatedBy
,LastModified
,LastModifiedBy

)

select  
@ClientId,
TaskId,
getdate(),
@UserId,
getdate(),
@UserId

from tblTask where TaskId between @OldMaxTaskId+1 and @NewMaxTaskId


-- InsertInto Matter

INSERT INTO dbo.tblMatterTask
(
MatterId
,TaskId
,CreatedDatetime
,CreatedBy
)

select 

@MatterId as MatterId,
TaskId,
Created,
CreatedBy
from tblTask  where TaskId between @OldMaxTaskId+1 and @NewMaxTaskId


--select 
--
--TaskTypeId,
--DefaultDescription,
--1425 as AssignTo,
--DateADD(d,1,getdate()) as DueDate,
--NULL as Resolved,
--NULL as ResolvedBy,
--NULL as TaskResolutionId,
--getdate(),
--1425,
--getdate(),
--1425
-- from tblTasktype where TaskTypeCategoryId=9 
--
--



END








