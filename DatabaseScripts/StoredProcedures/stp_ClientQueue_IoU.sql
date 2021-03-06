/****** Object:  StoredProcedure [dbo].[stp_ClientQueue_IoU]    Script Date: 11/19/2007 15:26:56 ******/
DROP PROCEDURE [dbo].[stp_ClientQueue_IoU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_ClientQueue_IoU]
(
	@AgencyID int,
	@Row int,
	@Col int,
	@Value varchar(255)
)
AS

BEGIN

if (@value is null or @value = '') begin

	declare @cellCount int
	set @cellCount = (select count(*) from tblclientqueue where agencyid=@agencyid and row=@row)

	if (@cellCount = 1) begin
		--last cell in row.  Just set it to null
		update
			tblclientqueue
		set
			[value]='&nbsp;'
		where
			agencyid=@agencyid and row=@row and col=@col
	end else begin
		--delete cell
		delete from 
			tblclientqueue
		where
			agencyid=@agencyid and row=@row and col=@col
	end

end else begin

	declare @clientqueueid int
	set @clientqueueid=
	(
		select 
			clientqueueid 
		from 
			tblclientqueue 
		where 
			agencyid=@agencyid and row=@row and col=@col
	)

	if (@clientqueueid is null) begin

		insert into 
			tblclientqueue(agencyid,col,row,[value]) 
		values 
			(@agencyid,@col,@row,@value)

	end else begin

		update 
			tblclientqueue 
		set 
			[value]=@value 
		where 
			clientqueueid=@clientqueueid

	end

end

END
GO
