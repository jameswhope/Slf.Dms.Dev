if exists (select * from sysobjects where name = 'stp_AddAttorneyState')
	drop procedure stp_AddAttorneyState
go

create procedure stp_AddAttorneyState
(
	@AttorneyID int
,	@State char(2)
,	@StateBarNum varchar(30)
)
as
begin
/*
	History:
	jhernandez		12/07/07	Created.
*/

if not exists (select 1 from tblAttyStates where AttorneyID = @AttorneyID and State = @State) begin
	insert tblAttyStates (AttorneyId, State, StateBarNum) values (@AttorneyId, @State, @StateBarNum)
end
else begin
	-- Update the record. StateBarNum is the only field that could have changed.
	update tblAttyStates set StateBarNum = @StateBarNum where AttorneyID = @AttorneyID and State = @State
end


end