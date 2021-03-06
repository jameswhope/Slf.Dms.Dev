/****** Object:  StoredProcedure [dbo].[stp_Permissions_UserType_IoU]    Script Date: 11/19/2007 15:27:31 ******/
DROP PROCEDURE [dbo].[stp_Permissions_UserType_IoU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Permissions_UserType_IoU]
	(
		@functionid int,
		@usertypeid int,
		@canview bit,
		@canadd bit,
		@caneditown bit,
		@caneditall bit,
		@candeleteown bit,
		@candeleteall bit
	)

as

exec stp_permissions_usertype_iou_single @functionid,@usertypeid,1,@canview
exec stp_permissions_usertype_iou_single @functionid,@usertypeid,2,@canadd
exec stp_permissions_usertype_iou_single @functionid,@usertypeid,3,@caneditown
exec stp_permissions_usertype_iou_single @functionid,@usertypeid,4,@caneditall
exec stp_permissions_usertype_iou_single @functionid,@usertypeid,5,@candeleteown
exec stp_permissions_usertype_iou_single @functionid,@usertypeid,6,@candeleteall
GO
