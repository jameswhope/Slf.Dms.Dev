
create function udf_GetDepositDate
(
	@DepositDay int,
	@MonthAdd int
)
returns datetime 
as
begin

declare @DepositDate varchar(10)

set @DepositDate  = cast(month(dateadd(month,@MonthAdd,getdate())) as varchar(2)) + '/' + cast(@DepositDay as varchar(2))  + '/' + cast(year(dateadd(month,@MonthAdd,getdate())) as varchar(4))

while isdate(@DepositDate) = 0 begin
	set @DepositDay = @DepositDay -1
	set @DepositDate = cast(month(dateadd(month,@MonthAdd,getdate())) as varchar(2)) + '/' + cast(@DepositDay as varchar(2))  + '/' + cast(year(dateadd(month,@MonthAdd,getdate())) as varchar(4))
end


return cast(@DepositDate as datetime)

end
go  