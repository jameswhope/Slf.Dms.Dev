IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationFilterInsertParentXref')
	BEGIN
		DROP  Procedure  stp_NegotiationFilterInsertParentXref
	END

GO

CREATE procedure [dbo].[stp_NegotiationFilterInsertParentXref]
(
	@FilterID int,
	@ParentFilterID int
)

AS

if not exists (SELECT * FROM tblNegotiationFilterParentXref WHERE FilterID = @FilterID and ParentFilterID = @ParentFilterID)
begin
	INSERT
		tblNegotiationFilterParentXref (FilterID, ParentFilterID) 
	VALUES
		(
			@FilterID,
			@ParentFilterID
		)
end

--DELETE
--	tblNegotiationFilterParentXref
--WHERE
--	FilterID not in (SELECT FilterID FROM tblNegotiationFilters WHERE Deleted = 0)
--	or ParentFilterID not in (SELECT FilterID FROM tblNegotiationFilters WHERE Deleted = 0)