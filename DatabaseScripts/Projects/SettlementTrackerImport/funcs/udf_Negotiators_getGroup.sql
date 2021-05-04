IF EXISTS (SELECT * FROM sysobjects WHERE type = 'fn' AND name = 'udf_Negotiators_getGroup')
	BEGIN
		DROP  Function  udf_Negotiators_getGroup
	END

GO

CREATE FUNCTION [dbo].[udf_Negotiators_getGroup](@negotiatorID int)
RETURNS varchar(50)
WITH EXECUTE AS CALLER
as
BEGIN
	--DECLARE @cSearch char(50)
	-- Find all child records for the search condition
	--SET @cSearch = '18'

	-- Now, find all the PARENT rows for the search conditon
	declare @group varchar(50)
	set @group = NULL
	; WITH ProductCTE AS
	-- Anchor query (same as before)
		(SELECT NegotiationEntityID, Name, userid,ParentNegotiationEntityID FROM tblNegotiationEntity
	WHERE NegotiationEntityID = @negotiatorID --and deleted = 0 --and [type] = 'Group'
	UNION ALL
	-- Recursive query…reverse the parentid and id columns
	SELECT Neg.NegotiationEntityID, Neg.Name, neg.userid,Neg.ParentNegotiationEntityID
	FROM tblNegotiationEntity Neg
			INNER JOIN ProductCTE
	ON ProductCTE.ParentNegotiationEntityID = Neg.NegotiationEntityID ) 
	SELECT distinct @group = [Name] FROM ProductCTE WHERE Userid is null
	OPTION (MAXRECURSION 0);
	if @group is null
		BEGIN
			set @group = 'NO GROUP ASSIGNED'
		END

	return(@group);

END