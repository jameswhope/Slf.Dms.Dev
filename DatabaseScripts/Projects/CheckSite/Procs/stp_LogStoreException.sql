if exists (select * from sysobjects where name = 'stp_LogStoreException')
	drop procedure stp_LogStoreException
go

create procedure stp_LogStoreException
(
	@ClientID int = null
,	@Exception varchar(2000)
,	@StackTrace varchar(8000) = null
,	@Method varchar(50)
)
as
begin
/*
	History:
	jhernandez		05/23/08	Created.
*/

insert tblStoreExceptionLog (ClientID,Exception,StackTrace,Method)
values (@ClientID,@Exception,@StackTrace,@Method)


end