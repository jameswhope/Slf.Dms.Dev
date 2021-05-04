IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportCreateRoadmap')
	BEGIN
		DROP  Procedure  stp_ImportCreateRoadmap
	END

GO

CREATE Procedure stp_ImportCreateRoadmap
@ClientId int,
@ParentRoadMapId int = null,
@ClientStatusId int,
@Reason varchar(255) = null,
@UserId int,
@Created datetime
AS
BEGIN

Insert into tblRoadmap(ClientId, ParentRoadMapId, ClientStatusId, Reason, Created, CreatedBy, LastModified, LastModifiedBy)
Values(@ClientId, @ParentRoadMapId, @ClientStatusId, @Reason, @Created, @UserId, @Created, @UserId)

Select SCOPE_IDENTITY()

END


GO


