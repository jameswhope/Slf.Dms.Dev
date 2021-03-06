/****** Object:  StoredProcedure [dbo].[stp_Permissions_User_IoU]    Script Date: 11/19/2007 15:27:30 ******/
DROP PROCEDURE [dbo].[stp_Permissions_User_IoU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_User_IoU]
	(
		@functionid int,
		@userid int,
		@canview bit,
		@canadd bit,
		@caneditown bit,
		@caneditall bit,
		@candeleteown bit,
		@candeleteall bit
	)

as

exec stp_permissions_user_iou_single @functionid,@userid,1,@canview
exec stp_permissions_user_iou_single @functionid,@userid,2,@canadd
exec stp_permissions_user_iou_single @functionid,@userid,3,@caneditown
exec stp_permissions_user_iou_single @functionid,@userid,4,@caneditall
exec stp_permissions_user_iou_single @functionid,@userid,5,@candeleteown
exec stp_permissions_user_iou_single @functionid,@userid,6,@candeleteall
GO
