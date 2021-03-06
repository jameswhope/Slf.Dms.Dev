/****** Object:  StoredProcedure [dbo].[update_NachaRegisterItem]    Script Date: 11/19/2007 15:27:47 ******/
DROP PROCEDURE [dbo].[update_NachaRegisterItem]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_NachaRegisterItem]
(
	@nachaRegisterId int,
	@nachaFileId int,
	@idTidbit varchar(32)
)

AS

BEGIN

SET NOCOUNT ON

UPDATE tblNachaRegister
	SET
		NachaFileId=@nachaFileId,
		IdTidbit=@idTidbit
WHERE
	NachaRegisterId=@nachaRegisterId
END
GO
