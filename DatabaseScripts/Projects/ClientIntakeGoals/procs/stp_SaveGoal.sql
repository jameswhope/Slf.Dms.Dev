IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveGoal')
	DROP  Procedure  stp_SaveGoal
GO

create procedure stp_SaveGoal
(
	@date datetime,
	@goal int,
	@userid int 
)
as
begin

if exists (select 1 from tblleadgoals where [date] = @date) begin
	update tblleadgoals 
	set goal = @goal, lastmodified = getdate(), lastmodifiedby = @userid
	where [date] = @date
end
else begin
	insert tblleadgoals ([date],goal,createdby)
	values (@date,@goal,@userid)
end

end
go