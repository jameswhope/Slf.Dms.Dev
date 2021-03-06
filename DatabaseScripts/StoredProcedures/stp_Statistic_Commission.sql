/****** Object:  StoredProcedure [dbo].[stp_Statistic_Commission]    Script Date: 11/19/2007 15:27:45 ******/
DROP PROCEDURE [dbo].[stp_Statistic_Commission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_Commission]
(
	@date1 datetime = null,
	@date2 datetime = null,
	@companyid int = null,
	@agencyid int = null
)

as

if @date1 is null 
	set @date1 = convert(datetime,'1800.01.01')
if @date2 is null 
	set @date2 = convert(datetime,'9999.01.01')

SELECT
	t.commrecname,
	count(commpayid) as [count],
	sum(t.amount) as amount
FROM
	(
		SELECT 
			tblCommPay.CommPayID,
			tblCommRec.Abbreviation as CommRecName,
			tblCommPay.Amount
		FROM 
			tblCommBatch INNER JOIN 
			tblCommPay ON tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN
			tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId 
				AND (@companyid is null or tblCommStruct.CompanyID = @companyid) INNER JOIN
			tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
			tblCommScen s on s.CommScenID = tblCommBatch.CommScenID
				AND (@agencyid is null or s.AgencyID = @agencyid)
			
		WHERE
			( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= @date1) AND
			( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= @date2)

		UNION ALL

		SELECT 
			tblCommPay.CommPayID,
			tblCommRec.Abbreviation as CommRecName,
			tblCommPay.Amount
		FROM 
			tblCommBatch INNER JOIN 
			(SELECT [Percent],CommChargeBackId,CommPayID,ChargeBackDate,RegisterPaymentId,CommStructID,-Amount as Amount,CommBatchId FROM tblCommChargeBack) tblCommPay on tblCommBatch.CommBatchId=tblCommPay.CommBatchId INNER JOIN 
			tblCommStruct ON tblCommPay.CommStructId=tblCommStruct.CommStructId 
				AND (@companyid is null or tblCommStruct.CompanyID = @companyid) INNER JOIN
			tblCommRec ON tblCommStruct.CommRecId=tblCommRec.CommRecId INNER JOIN
			tblCommScen s on s.CommScenID = tblCommBatch.CommScenID
				AND (@agencyid is null or s.AgencyID = @agencyid)
		WHERE
			( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) >= @date1) AND
			( CAST(CONVERT(char(10), tblCommBatch.BatchDate, 101) AS datetime) <= @date2)

	) t
GROUP BY
	t.commrecname
GO
