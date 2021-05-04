IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationPreviewGroupDetail')
	BEGIN
		DROP  Procedure  stp_NegotiationPreviewGroupDetail
	END

GO

CREATE procedure [dbo].[stp_NegotiationPreviewGroupDetail]
@DisplayColumns varchar(max),@Where varchar(max), @PageNum int, @PageSize int
as
EXEC 
('
WITH ChildGridPage AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY '+ @DisplayColumns +') AS RowNum
          , ' + @DisplayColumns + '
      FROM tblCache_PreviewGrid
		WHERE ' + @Where + '
)

SELECT * 
FROM ChildGridPage
WHERE RowNum BETWEEN ('+@PageNum+' - 1) * '+@PageSize+' + 1 AND '+@PageNum+' * '+@PageSize+'
ORDER BY ' + @DisplayColumns +''
)

GO


GRANT EXEC ON stp_NegotiationPreviewGroupDetail TO PUBLIC

GO


