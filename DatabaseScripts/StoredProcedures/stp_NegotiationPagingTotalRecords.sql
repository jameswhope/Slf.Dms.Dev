IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationPagingTotalRecords')
	BEGIN
		DROP  Procedure  stp_NegotiationPagingTotalRecords
	END

GO

create procedure [dbo].[stp_NegotiationPagingTotalRecords]
@TableName varchar(max), @Where varchar(max)
as
EXEC 
('
SELECT count(*) 
FROM ' + @TableName + ' WHERE ' + @Where 
)



GO


GRANT EXEC ON stp_NegotiationPagingTotalRecords TO PUBLIC

GO


