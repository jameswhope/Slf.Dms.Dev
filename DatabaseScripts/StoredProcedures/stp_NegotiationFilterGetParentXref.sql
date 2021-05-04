IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationFilterGetParentXref')
	BEGIN
		DROP  Procedure  stp_NegotiationFilterGetParentXref
	END

GO

CREATE procedure [dbo].[stp_NegotiationFilterGetParentXref]
(
	@ParentFilterID int
)

AS

--DELETE
--	tblNegotiationFilterParentXref
--WHERE
--	FilterID not in (SELECT FilterID FROM tblNegotiationFilters)
--	or ParentFilterID not in (SELECT FilterID FROM tblNegotiationFilters)

SELECT FilterID FROM tblNegotiationFilterParentXref WHERE ParentFilterID = @ParentFilterID