IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetTaskDueDate')
	BEGIN
		DROP  Procedure  stp_GetTaskDueDate
	END

GO

CREATE Procedure [dbo].[stp_GetTaskDueDate]
(
@SettlementDueDate datetime,
@TaskDueDate datetime output
)
As BEGIN

DECLARE @currentDate datetime,
		@daysRemaining int,
		@dayOfWeek int;
		

SELECT @currentDate = getdate();
SELECT @daysRemaining = (SELECT datediff(dd, @currentDate, @SettlementDueDate)),
		@dayOfWeek = (SELECT datepart(dw, @currentDate));

SELECT @dayOfWeek , @daysRemaining

IF @daysRemaining > 2 BEGIN
	IF @dayOfWeek = 5 BEGIN
		SET @TaskDueDate = dateadd(dd, 4, @currentDate);
	END	
	ELSE IF @dayOfWeek = 6 BEGIN
		SET @TaskDueDate = dateadd(dd, 3, @currentDate);	
	END
	ELSE BEGIN
		SET @TaskDueDate = dateadd(dd, 2, @currentDate);	
	END
END
ELSE BEGIN
	SET @TaskDueDate = @SettlementDueDate
END

END


GO

GRANT EXEC ON stp_GetTaskDueDate TO PUBLIC

GO


