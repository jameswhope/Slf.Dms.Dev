IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_WriteToWCFLog')
	BEGIN
		DROP Procedure stp_WriteToWCFLog
	END
GO 

create procedure stp_WriteToWCFLog
(
	@SessionId varchar(50),
	@Process varchar(30),
	@Status varchar(20),
	@Message nvarchar(max),
	@Show bit
)
as 
begin

if exists (select 1 from tblWCFLogs where Process = @Process and convert(varchar(10),Created,101) = convert(varchar(10),getdate(),101) and SessionId <> @SessionID) begin
	if not exists (select 1 from tblWCFLogs where Process = @Process and SessionId = @SessionID) begin
		insert tblWCFLogs (SessionId,Process,Status,Message,Show,Created)
		values (@SessionId,@Process,'','--------------------------new iteration--------------------------',1,getdate())
	end
end

insert tblWCFLogs (SessionId,Process,Status,Message,Show,Created)
values (@SessionId,@Process,@Status,@Message,@Show,getdate())

end