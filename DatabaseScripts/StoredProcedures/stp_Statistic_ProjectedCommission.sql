/****** Object:  StoredProcedure [dbo].[stp_Statistic_ProjectedCommission]    Script Date: 11/19/2007 15:27:45 ******/
DROP PROCEDURE [dbo].[stp_Statistic_ProjectedCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_ProjectedCommission]
	(
		@monthdate datetime='2006.10.01',
		@commrecid int=null
	)
 
as

declare @customid varchar(50)
set @customid=''
if not @commrecid is null
	set @customid=convert(varchar,@commrecid) + '|'
set @customid = @customid + convert(varchar,@monthdate,6)

select 
	* 
from 
	tblquerycache
where
	classname='default_aspx' and
	queryname='Projected Commissions' and
	customid=@customid
GO
