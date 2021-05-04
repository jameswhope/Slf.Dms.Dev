/****** Object:  StoredProcedure [dbo].[stp_GetEntityDisplay]    Script Date: 11/19/2007 15:27:09 ******/
DROP PROCEDURE [dbo].[stp_GetEntityDisplay]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_GetEntityDisplay]
(
	@relationtypeid int,
	@relationid int
)

AS

select dbo.getentitydisplay (@relationtypeid, @relationid)
GO
