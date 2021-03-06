/****** Object:  StoredProcedure [dbo].[stp_SetNameValueRule]    Script Date: 11/19/2007 15:27:44 ******/
DROP PROCEDURE [dbo].[stp_SetNameValueRule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_SetNameValueRule]
	(
		@userid int,
		@ruletypename varchar(50),
		@rulename varchar(50),
		@value sql_variant
	)

as

declare @ruletypeid int
set @ruletypeid=(select ruletypeid from tblruletype where [name]=@ruletypename)

declare @rulenamevalueid int
set @rulenamevalueid = (select rulenamevalueid from tblrulenamevalue where ruletypeid=@ruletypeid and [name]=@rulename)

if (@rulenamevalueid is null) begin
	insert into tblrulenamevalue(ruletypeid,[name],[value],lastmodifiedby)
	values (@ruletypeid,@rulename,@value,@userid)
end else begin
	update tblrulenamevalue
	set [value]=@value
	where rulenamevalueid=@rulenamevalueid
end
GO
