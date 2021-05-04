
CREATE procedure [dbo].[stp_GetInitialFeeAmount_TKM_3tier]
	(
		@totaldebt money
	)

as

declare @propertyCategoryID int;

if @totaldebt >= 3500 and @totaldebt < 5000 begin
	set @propertyCategoryID = 10;
end
	
if @totaldebt >= 5000 and @totaldebt < 7500 begin
	set @propertyCategoryID = 11;
end
	
if @totaldebt >= 7500 begin
	set @propertyCategoryID = 12;
end

select isnull(sum(CAST(value AS decimal(18, 2))) , 0)
from tblProperty 
where PropertyCategoryID = @propertyCategoryID
and isInitialFee = 1
