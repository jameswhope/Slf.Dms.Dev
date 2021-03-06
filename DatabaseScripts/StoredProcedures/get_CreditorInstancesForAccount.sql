/****** Object:  StoredProcedure [dbo].[get_CreditorInstancesForAccount]    Script Date: 11/19/2007 15:26:48 ******/
DROP PROCEDURE [dbo].[get_CreditorInstancesForAccount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_CreditorInstancesForAccount]
(
	@accountId int
)

AS

SET NOCOUNT ON

SELECT
	*
FROM
	tblCreditorInstance
WHERE
	AccountId=@accountId
order by
	acquired,
	creditorinstanceid
GO
