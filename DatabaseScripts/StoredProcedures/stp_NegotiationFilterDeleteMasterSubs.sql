IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationFilterDeleteMasterSubs')
	BEGIN
		DROP  Procedure  stp_NegotiationFilterDeleteMasterSubs
	END

GO

CREATE procedure [dbo].[stp_NegotiationFilterDeleteMasterSubs]
(
	@ParentFilterID int,
	@UserID int
)

AS

declare @filterid int

declare @vtblFilters table
(
	FilterID int
)

INSERT INTO
	@vtblFilters
EXEC
	stp_NegotiationFilterGetParentXref @ParentFilterID

declare cursor_filters cursor for
	SELECT
		FilterID
	FROM
		@vtblFilters

open cursor_filters

fetch next from cursor_filters into @filterid

while @@fetch_status = 0
begin
	exec stp_NegotiationFilterDelete @filterid, @UserID

	fetch next from cursor_filters into @filterid
end

close cursor_filters
deallocate cursor_filters

SELECT
	FilterID
FROM
	@vtblFilters