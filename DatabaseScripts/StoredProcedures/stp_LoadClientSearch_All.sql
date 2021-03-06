/****** Object:  StoredProcedure [dbo].[stp_LoadClientSearch_All]    Script Date: 11/19/2007 15:27:24 ******/
DROP PROCEDURE [dbo].[stp_LoadClientSearch_All]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[stp_LoadClientSearch_All]

as


-- discretionary variables
declare @clientid int


declare a_cursor cursor for select clientid from tblclient

open a_cursor

fetch next from a_cursor into @clientid
while @@fetch_status = 0

	begin

		exec stp_LoadClientSearch @clientid

		fetch next from a_cursor into @clientid

	end

close a_cursor
deallocate a_cursor
GO
