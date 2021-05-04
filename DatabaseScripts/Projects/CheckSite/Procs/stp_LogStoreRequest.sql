if exists (select * from sysobjects where name = 'stp_LogStoreRequest')
	drop procedure stp_LogStoreRequest
go

create procedure stp_LogStoreRequest
(
	@ClientID int
,	@RequestType varchar(20)
,	@StatusDesc varchar(50)
,	@Notes varchar(500)
,	@RequestedBy int
)
as
begin
/*
	History:
	jhernandez		05/23/08	Logs a store request, that is, attempts to create, modify, or
								remove a virtual account with CheckSite
	jhernandez		06/02/08	Update client record with Plaza's trust id if a successful
								virtual account got created. These clients will now start
								transmitting through that bank.
	jhernandez		06/18/08	Bug fix: Hard coding trust id to 22
*/

insert tblStoreRequestLog (ClientID,RequestType,StatusDesc,Notes,RequestedBy)
values (@ClientID,@RequestType,@StatusDesc,@Notes,@RequestedBy)


if @RequestType = 'OpenAccount' and @StatusDesc = 'Succeeded' begin
	update tblClient 
	set TrustID = 22, LastModified = getdate(), LastModifiedBy = @RequestedBy
	where ClientID = @ClientID
end


end