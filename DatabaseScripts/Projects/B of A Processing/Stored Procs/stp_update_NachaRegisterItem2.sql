IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_update_NachaRegisterItem2')
	BEGIN
		DROP  Procedure  stp_update_NachaRegisterItem2
	END

GO

/****** Object:  StoredProcedure [dbo].[stp_update_NachaRegisterItem2]    Script Date: 02/22/2010 09:13:25 
This is for BofA transactions created by Jim Hope 02/22/2010******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[stp_update_NachaRegisterItem2]
(
	@nachaRegisterId int,
	@nachaFileId int
)

AS

BEGIN

SET NOCOUNT ON

UPDATE tblNachaRegister2
	SET
		NachaFileId=@nachaFileId
WHERE
	NachaRegisterId=@nachaRegisterId
END
GO

/*
GRANT EXEC ON stp_update_NachaRegisterItem2 TO PUBLIC

GO
*/

