 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DataPaging')
	BEGIN
		DROP  Procedure  stp_DataPaging
	END
GO
 
 CREATE procedure [dbo].[stp_DataPaging]
@TableName varchar(max), @DisplayColumns varchar(max),@Where varchar(max), @OrderBy varchar(max), @PageNum int, @PageSize int
as
EXEC 
('
WITH PagingTable AS
(
    SELECT ROW_NUMBER() OVER(ORDER BY '+ @OrderBy +') AS RowNum
          , ' + @DisplayColumns + '
      FROM ' + @TableName + ' WHERE ' + @Where + '
)

SELECT * 
FROM PagingTable
WHERE RowNum BETWEEN ('+@PageNum+' - 1) * '+@PageSize+' + 1 AND '+@PageNum+' * '+@PageSize+'
ORDER BY ' + @OrderBy +''
)

GRANT EXEC ON stp_DataPaging TO PUBLIC