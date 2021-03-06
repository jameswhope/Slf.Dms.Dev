/****** Object:  StoredProcedure [dbo].[stp_InputGrid_GetDefinition]    Script Date: 11/19/2007 15:27:23 ******/
DROP PROCEDURE [dbo].[stp_InputGrid_GetDefinition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_InputGrid_GetDefinition]
(
	@InputGridName varchar(255),
	@Col int = null
)
AS

BEGIN

	if @col is null begin
		select 
			* 
		from 
			tblinputgriddefinition inner join
			tblinputgrid on tblinputgriddefinition.inputgridid=tblinputgrid.inputgridid
		where
			inputgridname=@inputgridname
		order by
			col	

	end else begin

		select 
			* 
		from 
			tblinputgriddefinition inner join
			tblinputgrid on tblinputgriddefinition.inputgridid=tblinputgrid.inputgridid
		where
			inputgridname=@inputgridname
			and col=@col
		
	end

END
GO
