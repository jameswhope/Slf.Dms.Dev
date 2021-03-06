IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.tables WHERE table_name = 'tblWCFLogs') 
BEGIN
	CREATE TABLE [dbo].[tblWCFLogs](
		[LogID] [int] IDENTITY(1,1) NOT NULL,
		[SessionId] varchar(50) not null,
		[Created] [datetime] NOT NULL default(getdate()),
		[Process] varchar(20),
		[Status] varchar(20),
		[Message] [nvarchar](MAX) NOT NULL,
		[NachaRegisterID] [int] NULL
	) ON [PRIMARY]
END

if not exists (select 1 from syscolumns where id = object_id('tblWCFLogs') and name = 'Process') begin
	alter table tblWCFLogs add Process varchar(30)
end 

if not exists (select 1 from syscolumns where id = object_id('tblWCFLogs') and name = 'Status') begin
	alter table tblWCFLogs add Status varchar(20)
end 

if not exists (select 1 from syscolumns where id = object_id('tblWCFLogs') and name = 'Show') begin
	alter table tblWCFLogs add Show bit default(1) not null
end 