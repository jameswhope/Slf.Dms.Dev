IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlements_getTotalsByUserID')
	BEGIN
		DROP  Procedure  stp_settlements_getTotalsByUserID
	END

GO

CREATE Procedure stp_settlements_getTotalsByUserID
	(
		@userid int
	)
AS
BEGIN
	declare @year int,@month int,@IsSuper bit,@UserGroup int,@Team varchar(30)

	SET @year = year(getdate())
	SET @month = month(getdate())

	select @UserGroup= UserGroupID FROM tblUser where UserID = @userid

	SELECT @IsSuper = isnull(ne.IsSupervisor,0), @team = ng.Name
	FROM tblNegotiationEntity AS ne 
	left JOIN (SELECT NegotiationEntityID,  Name, ParentNegotiationEntityID, ParentType, UserID, Deleted, LastRefresh 
	FROM tblNegotiationEntity WHERE (Type = 'group')) AS ng ON ne.ParentNegotiationEntityID = ng.NegotiationEntityID 
	WHERE (ne.Type = 'Person') AND (ne.Name <> 'New Person') AND (ne.Deleted <> 1) and ne.UserID=@userid

	declare @tblR table(rOrder int,[NegotiatorName] varchar(150),[TotalFees] money,[TotalBalance]  money,[TotalSettAmt] money,[TotalUnits] int,[TotalAvgPct] float,[PaidFees] money,[PaidBalance] money,[PaidSettAmt] money,[PaidUnits] int,[PaidAvgPct] float,[PctPaid] float, [AllSubmissions] int,[PaidAvgFee] money)
	insert into @tblR 
	select 
	rOrder = 0
	,[NegotiatorName] = Negotiator
	,[TotalFees] = convert(money,sum(case when year(date) = @year and month(date) = @month then settlementfees else 0 end))
	,[TotalBalance]  =  sum(case when year(date) = @year and month(date) = @month  then balance else 0 end)
	,[TotalSettAmt] =  sum(case when year(date) = @year and month(date) = @month then settlementamt else 0 end)
	,[TotalUnits] = sum(case when year(date) = @year and month(date) = @month then 1 else 0 end)
	,[TotalAvgPct] = case when sum(case when year(date) = @year and month(date) = @month then balance else 0 end) = 0 then 0 else sum(case when year(date) = @year and month(date) = @month and canceldate is null then settlementamt else 0 end)/isnull(nullif(sum(case when year(date) = @year and month(date) = @month and canceldate is null then balance else 0 end),0),1)end
	,[PaidFees] = convert(money,sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then settlementfees else 0 end))
	,[PaidBalance] = sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then balance else 0 end)
	,[PaidSettAmt] = sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null  then settlementamt else 0 end)
	,[PaidUnits] = sum(case when  year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then 1 else 0 end)
	,[PaidAvgPct] = case when sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null  then balance else 0 end) = 0 then 0 else sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then settlementamt else 0 end)/isnull(nullif(sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then balance else 0 end),0),1) end
	,[PctPaid] = sum(case when  year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then 1 else 0 end)/cast(isnull(nullif(sum(case when year(date) = @year and month(date) = @month and canceldate is null and expired is null then 1 else 0 end),0),1) as float)
	,[AllSubmissions] = sum(case when year(date) = @year and month(date) = @month then 1 else 0 end)
	,[PaidAvgFee] = convert(money,sum(case when year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then settlementfees else 0 end))/isnull(nullif(sum(case when  year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null and expired is null then 1 else 0 end),0),1)
	from tblSettlementTrackerImports [sti] with(nolock)
	inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
	where (s.createdby= @userID OR (@IsSuper = 1 AND Team = @team ) OR @userGroup = 11)
	--where canceldate is null and expired is null
	group by Negotiator 
	having sum(case when  year(paid) =@year and month(paid) = @month and paid is not null and canceldate is null  then 1 else 0 end) >= 0
	order by Negotiator

	select NegotiatorName
	,TotalFees = isnull(TotalFees,0)
	,TotalBalance= isnull(TotalBalance,0)
	,TotalSettAmt= isnull(TotalSettAmt,0)
	,TotalUnits= isnull(TotalUnits,0)
	,TotalAvgPct= isnull(TotalAvgPct,0)
	,PaidFees= isnull(PaidFees,0)
	,PaidBalance= isnull(PaidBalance,0)
	,PaidSettAmt= isnull(PaidSettAmt,0)
	,PaidUnits= isnull(PaidUnits,0)
	,PaidAvgPct= isnull(PaidAvgPct,0)
	,PctPaid= isnull(PctPaid,0)
	,[AllSubmissions] = isnull([AllSubmissions],0)
	,[PaidAvgFee] = isnull(PaidAvgFee,0)
	from @tblR where NegotiatorName <> ''and (TotalUnits <> 0 or PaidUnits <> 0)
	order by rorder



END

GO


GRANT EXEC ON stp_settlements_getTotalsByUserID TO PUBLIC

GO


