IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationPreviewGroups')
	BEGIN
		DROP  Procedure  stp_NegotiationPreviewGroups
	END

GO

CREATE procedure [dbo].[stp_NegotiationPreviewGroups]
@GroupName varchar(max), @Where varchar(max)
as
EXEC 
('
	SELECT DISTINCT ' + @GroupName + ' as [GroupHdr]
	FROM tblCache_PreviewGrid
	WHERE ' + @Where + ' 
	ORDER BY ' + @GroupName
)

GO


GRANT EXEC ON stp_NegotiationPreviewGroups TO PUBLIC

GO


