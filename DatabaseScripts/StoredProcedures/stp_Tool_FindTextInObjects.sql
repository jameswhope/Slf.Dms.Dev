/****** Object:  StoredProcedure [dbo].[stp_Tool_FindTextInObjects]    Script Date: 11/19/2007 15:27:46 ******/
DROP PROCEDURE [dbo].[stp_Tool_FindTextInObjects]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_Tool_FindTextInObjects]
	(
		@searchtext varchar(255)
	)

as


SELECT
	OBJECT_NAME(id) as ObjectName,
	case
		when OBJECTPROPERTY(id, 'IsProcedure') = 1 then 'Procedure'
		when OBJECTPROPERTY(id, 'IsTrigger') = 1 then 'Trigger'
		when OBJECTPROPERTY(id, 'IsView') = 1 then 'View'
	end as ObjectType
FROM
	syscomments
WHERE
	[text] LIKE '%' + @searchtext + '%'
GROUP BY
	OBJECT_NAME(id),
	syscomments.id
GO
