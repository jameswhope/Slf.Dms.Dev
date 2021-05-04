/****** Object:  StoredProcedure [dbo].[stp_Audit_SetCurrentUser]    Script Date: 11/19/2007 15:26:55 ******/
DROP PROCEDURE [dbo].[stp_Audit_SetCurrentUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_Audit_SetCurrentUser]
(
	@userid int
)
as

delete from tblsysprocessuser where spid=@@spid
insert into tblsysprocessuser(spid,userid) values (@@spid,@userid)
GO
