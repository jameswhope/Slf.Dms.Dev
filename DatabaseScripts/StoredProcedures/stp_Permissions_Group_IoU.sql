/****** Object:  StoredProcedure [dbo].[stp_Permissions_Group_IoU]    Script Date: 11/19/2007 15:27:28 ******/
DROP PROCEDURE [dbo].[stp_Permissions_Group_IoU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_Group_IoU]
	(
		@functionid int,
		@usergroupid int,
		@canview bit,
		@canadd bit,
		@caneditown bit,
		@caneditall bit,
		@candeleteown bit,
		@candeleteall bit
	)

as

exec stp_permissions_group_iou_single @functionid,@usergroupid,1,@canview
exec stp_permissions_group_iou_single @functionid,@usergroupid,2,@canadd
exec stp_permissions_group_iou_single @functionid,@usergroupid,3,@caneditown
exec stp_permissions_group_iou_single @functionid,@usergroupid,4,@caneditall
exec stp_permissions_group_iou_single @functionid,@usergroupid,5,@candeleteown
exec stp_permissions_group_iou_single @functionid,@usergroupid,6,@candeleteall
GO
