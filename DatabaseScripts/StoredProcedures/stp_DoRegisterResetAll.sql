/****** Object:  StoredProcedure [dbo].[stp_DoRegisterResetAll]    Script Date: 11/19/2007 15:27:02 ******/
DROP PROCEDURE [dbo].[stp_DoRegisterResetAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_DoRegisterResetAll]

as


----------------------------------------------------
-- LOGIC FOR RESETTING ALL REGISTERS
-- (1) cycle the all registers and run
--     the reset register stored proc
----------------------------------------------------


-- (1) loop all registers
declare @registerid int

declare cursor_DoRegisterResetAll cursor for
	select
		registerid
	from
		tblregister

open cursor_DoRegisterResetAll

fetch next from cursor_DoRegisterResetAll into @registerid
while @@fetch_status = 0

	begin

		exec stp_DoRegisterReset @registerid

		fetch next from cursor_DoRegisterResetAll into @registerid

	end

close cursor_DoRegisterResetAll
deallocate cursor_DoRegisterResetAll
GO
