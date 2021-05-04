if exists (select * from sysobjects where name = 'stp_RemoveAttorneyStateLic')
	drop procedure stp_RemoveAttorneyStateLic
go

create procedure stp_RemoveAttorneyStateLic
(
	@AttyStateID int
)
as
begin

declare @state char(2), @AttorneyID int

select @state = [state], @AttorneyId = AttorneyID from tblAttyStates where AttyStateID = @AttyStateID

-- removing state lic
delete from tblAttyStates where AttyStateID = @AttyStateID
-- removing primaries for that state
delete from tblCompanyStatePrimary where AttorneyID = @AttorneyID and [State] = @State

end