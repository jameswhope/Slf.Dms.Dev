/****** Object:  StoredProcedure [dbo].[stp_DoRegisterResetAllForClient]    Script Date: 11/19/2007 15:27:02 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterResetAllForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_DoRegisterResetAllForClient]
	(
		@clientid int
	)

as


----------------------------------------------------
-- LOGIC FOR RESETTING ALL REGISTERS FOR CLIENT
-- (1) cycle the clients registers and run
--     the reset register stored proc
----------------------------------------------------


-- (1) loop clients registers
declare @registerid int

declare cursor_DoRegisterResetAllForClient cursor for
	select
		registerid
	from
		tblregister
	where
		clientid = @clientid

open cursor_DoRegisterResetAllForClient

fetch next from cursor_DoRegisterResetAllForClient into @registerid
while @@fetch_status = 0

	begin

		exec stp_DoRegisterReset @registerid

		fetch next from cursor_DoRegisterResetAllForClient into @registerid

	end

close cursor_DoRegisterResetAllForClient
deallocate cursor_DoRegisterResetAllForClient
GO
