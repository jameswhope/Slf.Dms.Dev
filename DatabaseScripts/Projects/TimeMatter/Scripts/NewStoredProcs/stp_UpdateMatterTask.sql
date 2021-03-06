set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <05 - 17 February 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Updates the tasks of a matter
*/
CREATE procedure [dbo].[stp_UpdateMatterTask]
(
	@TaskId int,
	@MatterId int,
	@DueDate datetime,
	@TaskTypeId int,
	@Description varchar(500),
	@AssignedTo int,
	@ClientId int,	
	@UserId int,
	@DueZoneDisplay int,
	@AssignedToGroupId int
	--,@TimeBlock varchar(50)
)
as

if @TaskId>0
Begin

--	Declare @DBTimeDiff as int
--	Declare @FromUTC as int
--	Select @DBTimeDiff=FromUTC from tblTimeZone Where DBIsHere=1
--	Select @FromUTC=FromUTC from tblTimeZone Where TimeZoneID=@DueZoneDisplay
--	
--	Set @DueDate=DateAdd(hh,(@FromUTC-@DBTimeDiff),@DueDate)

	UPDATE dbo.tblTask 
	SET TaskTypeID=@TaskTypeId, Description=@Description, AssignedTo=@AssignedTo,
	Due=@DueDate, LastModified=getdate() ,LastModifiedBy=@UserId, 
	DueDateZoneDisplay=@DueZoneDisplay, AssignedToGroupId=@AssignedToGroupId
	--,TimeBlock=@TimeBlock
	WHERE TaskID=@TaskId

End

















