IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertExtraFees2TMLF')
	BEGIN
		DROP  Procedure  stp_InsertExtraFees2TMLF
	END

GO

CREATE Procedure stp_InsertExtraFees2TMLF
@userid int = 28
AS
begin
declare @today datetime;
declare @startdate datetime;
declare @month varchar(10);
declare @day varchar(10);
declare @transDate datetime;
declare @transAmount money;
declare @balanceDue money;
declare @numberOfDaysInMonth int;

set @startdate = '2014/01/01 00:00:00.000'
set @today = getdate()
set @month = CONVERT(VARCHAR(10),YEAR(GETDATE())) + '/' + CONVERT(VARCHAR(10),MONTH(GETDATE()))
set @day = CONVERT(VARCHAR(10),YEAR(GETDATE())) + '/' + CONVERT(VARCHAR(10),MONTH(GETDATE())) + '/' + CONVERT(VARCHAR(10),DAY(GETDATE()))
set @numberOfDaysInMonth = datediff(day, dateadd(day, 1-day(@today), @today), dateadd(month, 1, dateadd(day, 1-day(@today), @today)))

declare @name varchar(100), @value varchar(50), @periodic varchar(50);

declare cur cursor for
select Name, Value, [Type]
from tblProperty 
where PropertyCategoryId = 13

open cur
fetch next from cur into @name, @value, @periodic

while @@fetch_status = 0 begin
	   select @balanceDue = 0.00
       if @periodic = 'Month' begin
              set @transDate = @month + '/1 00:00:00.000'
              select top 1 @balanceDue = balanceDue from tblTMLF2TSLF order by RecordID desc
              if (select TransactionType from tblTMLF2TSLF where TransactionDate = @Transdate and TransactionType = 'Monthly Installment') is null begin
                     insert into tblTMLF2TSLF 
                     (TransactionDate, TransactionType, TransactionAmount, BalanceDue, Created, CreatedBy) values 
                     (@transdate, 'Monthly Installment', CAST(REPLACE(@value,'.00','') AS decimal(18, 2)), CAST(REPLACE(@balanceDue + @value,'.00','') AS decimal(18, 2)), getdate(), @userid)
              end
              set @balanceDue = null;
       end
       else if @periodic = 'Day' begin
              set @transDate = @day
              select top 1 @balanceDue = balanceDue from tblTMLF2LEXX order by RecordID desc
              if (select TransactionAmount from tblTMLF2LEXX where TransactionDate = @Transdate and TransactionType = 'Daily Installment') is null begin
                     insert into tblTMLF2LEXX
                     (TransactionDate, TransactionType, TransactionAmount, BalanceDue, Created, CreatedBy) values 
                     (@transdate, 'Daily Installment', CAST(REPLACE(@value,'.00','') AS decimal(18, 2))/@numberOfDaysInMonth, @balanceDue + (CAST(REPLACE(@value,'.00','') AS decimal(18, 2))/@numberOfDaysInMonth), getdate(), @userid)
              end
              set @balanceDue = null;
       end

       fetch next from cur into @name, @value, @periodic

end -- while fetch   

close cur
deallocate cur


End

GO

 

