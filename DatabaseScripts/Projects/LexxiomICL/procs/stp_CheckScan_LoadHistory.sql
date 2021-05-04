IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckScan_LoadHistory')
	BEGIN
		DROP  Procedure  stp_CheckScan_LoadHistory
	END

GO

CREATE Procedure stp_CheckScan_LoadHistory
	(
		@filterdate  datetime = null,
		@batchstatus varchar(5) = null
	)
AS
BEGIN

	declare @tblHist table(SaveGUID varchar(50),Created datetime,CreatedBy varchar(500),[Total Verified Clients] int,[Total Verified Count]int,[Total Verified Amt]money,
[Total Processed]int,[Total Processed Amt]money,[Total ICL Processed]int,[Processed Date]datetime,ProcessedBy varchar(500),[Total ICL Processed Amt]money,	
TotalItems	int,TotalAmt money, batchStatus varchar(5))

	insert into @tblHist
SELECT     
	ic.SaveGUID
	, CONVERT(varchar, ic.Created, 101) AS Created
	, uc.FirstName + ' ' + uc.LastName AS CreatedBy
	, SUM(CASE WHEN Clientid = - 1 AND processed IS NULL THEN 0 ELSE 1 END) AS [Total Verified Clients]
	, SUM(CASE WHEN Verified IS NULL AND processed IS NULL THEN 0 ELSE 1 END) AS [Total Verified Count]
	, SUM(CASE WHEN Verified IS NULL THEN 0 ELSE checkamount END) AS [Total Verified Amt]
	, SUM(CASE WHEN registerid <> -1 THEN 1 ELSE 0 END) AS [Total Processed]
	, SUM(CASE WHEN registerid <> -1 THEN checkamount ELSE 0 END) AS [Total Processed Amt]
	, SUM(CASE WHEN Processed IS NULL THEN 0 ELSE 1 END) AS [Total ICL Processed]
	, max(Processed)[Processed Date]
	, max(up.FirstName + ' ' + up.LastName)  ProcessedBy
	, SUM(CASE WHEN Processed IS NULL THEN 0 ELSE checkamount END) AS [Total ICL Processed Amt]
	, ISNULL(COUNT(*), 0) AS TotalItems
	, ISNULL(SUM(ic.CheckAmount), 0) AS TotalAmt
	, null
	FROM tblICLChecks AS ic 
	INNER JOIN tblUser AS uc ON ic.CreatedBy = uc.UserID
	LEFT JOIN tblUser AS up ON ic.ProcessedBy= up.UserID
	WHERE (ic.DeleteDate IS NULL)
	and (convert(varchar,ic.Created,101) = @filterdate OR @filterdate  IS null)
	GROUP BY ic.SaveGUID, CONVERT(varchar, ic.Created, 101), uc.FirstName, uc.LastName
	ORDER BY Created DESC
	
	
	UPDATE @tblHist SET batchStatus = 'NP' where [Total Verified Count] <> [TotalItems] and [Total Processed] = 0
	UPDATE @tblHist SET batchStatus = 'P' where [Total Verified Count] = [TotalItems] and [Total Processed] = [TotalItems]
	
	select * from @tblHist where (batchStatus = @batchstatus OR @batchstatus is null)
	
END


GRANT EXEC ON stp_CheckScan_LoadHistory TO PUBLIC

