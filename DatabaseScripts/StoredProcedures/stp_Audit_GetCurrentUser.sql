/****** Object:  StoredProcedure [dbo].[stp_Audit_GetCurrentUser]    Script Date: 11/19/2007 15:26:54 ******/
DROP PROCEDURE [dbo].[stp_Audit_GetCurrentUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Audit_GetCurrentUser]
as

select dbo.currentuser()
GO
