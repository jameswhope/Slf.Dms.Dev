/****** Object:  StoredProcedure [dbo].[sp_who_dms]    Script Date: 11/19/2007 15:26:50 ******/
DROP PROCEDURE [dbo].[sp_who_dms]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_who_dms]  --- 1995/11/28 15:48
       @loginame sysname = NULL --or 'active'
as

declare	 @spidlow	int,
		 @spidhigh	int,
		 @spid		int,
		 @sid		varbinary(85)

select	 @spidlow	=     0
		,@spidhigh	= 32767


if (	@loginame is not NULL
   AND	upper(@loginame collate Latin1_General_CI_AS) = 'ACTIVE'
   )
	begin

	select spid , ecid, status
              ,loginame=rtrim(loginame)
	      ,hostname ,blk=convert(char(5),blocked)
	      ,dbname = case
						when dbid = 0 then null
						when dbid <> 0 then db_name(dbid)
					end
		  ,cmd
		  ,request_id
	INTO #dms.tmpSys
	from  master.dbo.sysprocesses
	where spid >= @spidlow and spid <= @spidhigh AND
	      upper(cmd) <> 'AWAITING COMMAND'

	return (0)
	end

if (@loginame is not NULL
   AND	upper(@loginame collate Latin1_General_CI_AS) <> 'ACTIVE'
   )
begin
	if (@loginame like '[0-9]%')	-- is a spid.
	begin
		select @spid = convert(int, @loginame)
		select spid, ecid, status,
			   loginame=rtrim(loginame),
			   hostname,blk = convert(char(5),blocked),
			   dbname = case
							when dbid = 0 then null
							when dbid <> 0 then db_name(dbid)
						end
			  ,cmd
			  ,request_id
		from  master.dbo.sysprocesses
		where spid = @spid
	end
	else
	begin
		select @sid = suser_sid(@loginame)
		if (@sid is null)
		begin
			raiserror(15007,-1,-1,@loginame)
			return (1)
		end
		select spid, ecid, status,
			   loginame=rtrim(loginame),
			   hostname ,blk=convert(char(5),blocked),
			   dbname = case
							when dbid = 0 then null
							when dbid <> 0 then db_name(dbid)
						end
			   ,cmd
			   ,request_id
		from  master.dbo.sysprocesses
		where sid = @sid
	end
	return (0)
end


-- loginame arg is null
select spid,
	   ecid,
	   status,
       loginame=rtrim(loginame),
	   hostname,
	   blk=convert(char(5),blocked),
	   dbname = case
					when dbid = 0 then null
					when dbid <> 0 then db_name(dbid)
				end
	   ,cmd
	   ,request_id
from  master.dbo.sysprocesses
where spid >= @spidlow and spid <= @spidhigh



return (0) -- sp_who
GO
