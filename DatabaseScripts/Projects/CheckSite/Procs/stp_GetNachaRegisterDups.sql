
if exists (select * from sysobjects where name = 'stp_GetNachaRegisterDups')
	drop procedure stp_GetNachaRegisterDups
go

create procedure stp_GetNachaRegisterDups
(
	@NachaFileId int
)
as
begin
/*
	History:
	jhernandez		07/09/08	Returns any CheckSite clients that are also in colonial's batch.
								Should never return records!
*/

declare @date datetime

select @date = Date 
from tblNachaFile 
where NachaFileId = @NachaFileId

select * 
from tblNachaRegister
where NachaFileId in (select NachaFileId from tblNachaFile where Date > @date and NachaFileId < @NachaFileId)
	and ClientID in (select distinct ClientID from tblNachaRegister2 where NachaFileId = @NachaFileId)


end