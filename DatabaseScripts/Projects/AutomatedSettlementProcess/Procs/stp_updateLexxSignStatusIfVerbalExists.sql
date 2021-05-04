IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_updateLexxSignStatusIfVerbalExists')
	BEGIN
		DROP  Procedure  stp_updateLexxSignStatusIfVerbalExists
	END

GO

create procedure [dbo].[stp_updateLexxSignStatusIfVerbalExists]
(
@batchid varchar(50)
)
as
BEGIN
/*
	declare @batchid varchar(50)
	set @batchid  = '4c1257c8-3ebd-4562-a80a-81c2b25ce8f5'-- '01981a1c-8be4-4568-b385-8b1ce7c0ddec'
*/
	declare @clientid int, @matterID int
	select @clientid = ld.clientid, @matterid = s.matterid 
	from tblLexxSignDocs ld WITH(NOLOCK) 
	INNER JOIN tblSettlements s WITH(NOLOCK) on ld.RelationID = s.SettlementID
	where ld.SigningBatchID=@batchid
	and ld.RelationTypeID=21

	declare @created datetime
	select top 1 @created = t.created 
	from tblmatter m 
	left join tblmattertask mt on mt.matterid = m.matterid 
	left join tbltask t on t.taskid = mt.taskid 
	where tasktypeid = 72 and taskresolutionid = 1 and m.clientid =@clientid

	if @created is not null
		BEGIN
			update tbllexxsigndocs 
			set currentstatus = 'Verbal Accept', Completed = @created 
			where signingbatchid = @batchid and currentstatus = 'Document signed'
		END
		
	if exists(select MatterId from tblSettlementClientApproval where MatterId = @matterid)
		BEGIN
			update tbllexxsigndocs 
			set currentstatus = 'Verbal Accept', Completed = ld.submitted
			from tblLexxSignDocs ld WITH(NOLOCK) 
			INNER JOIN tblSettlements s WITH(NOLOCK) on ld.RelationID = s.SettlementID
			INNER JOIN tblSettlementClientApproval sa WITH(NOLOCK) on sa.MatterId = s.MatterId
			where ld.SigningBatchID=@batchid
			and ld.RelationTypeID=21
		END		
		
END


GRANT EXEC ON stp_updateLexxSignStatusIfVerbalExists TO PUBLIC

GO


