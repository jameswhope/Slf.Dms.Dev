/****** Object:  StoredProcedure [dbo].[stp_ReportGetCommissionBatchTransfers]    Script Date: 11/19/2007 15:27:43 ******/
DROP PROCEDURE [dbo].[stp_ReportGetCommissionBatchTransfers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ReportGetCommissionBatchTransfers]
(
	@CommBatchIDs varchar(1500),
	@CompanyID nvarchar(100),
	@CommRecID nvarchar(1000),
	@ClientCreatedDateFrom varchar(20) = '1/1/1900',
	@ClientCreatedDateTo varchar(20) = '1/1/2050'
)
as
begin
/*
	History:
	10/13/08	jhernandez		Settlement attorney portal
	10/24/08	jhernandez		Removed conditional filtering for commrecs 5 & 24. Using multiple scenarios now.
	12/15/08	jhernandez		Include payments made through Lexxiom
*/

SELECT ClientID, ClientName, sum(Amount) as Amount 
FROM (
	select person.ClientID, ltrim(person.FirstName + ' ' + person.LastName) as ClientName, comm.Amount as Amount 
	from tblCommPay as comm 
	join tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID 
	join tblRegister as register on register.RegisterID = registerpay.FeeRegisterID 
	join tblClient as client on client.ClientID = register.ClientID 
		and client.CompanyID = @CompanyID
		and (client.Created between @ClientCreatedDateFrom and @ClientCreatedDateTo)
	join dbo.splitstr(@CommBatchIDs,',') b on b.Value = comm.commbatchid
	join tblcommstruct cs on cs.commstructid = comm.commstructid 
		--and cs.parentcommrecid <> 4
	join dbo.splitstr(@CommRecID,',') r on r.Value = cs.commrecid
	left join tblPerson as person on person.PersonID = client.PrimaryPersonID
	
	union all
	
	select person.ClientID, ltrim(person.FirstName + ' ' + person.LastName) as ClientName, -comm.Amount as Amount 
	from tblCommChargeback as comm 
	join tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID 
	join tblRegister as register on register.RegisterID = registerpay.FeeRegisterID 
	join tblClient as client on client.ClientID = register.ClientID 
		and client.CompanyID = @CompanyID
		and (client.Created between @ClientCreatedDateFrom and @ClientCreatedDateTo)
	join dbo.splitstr(@CommBatchIDs,',') b on b.Value = comm.commbatchid
	join tblcommstruct cs on cs.commstructid = comm.commstructid 
		--and cs.parentcommrecid <> 4
	join dbo.splitstr(@CommRecID,',') r on r.Value = cs.commrecid
	left join tblPerson as person on person.PersonID = client.PrimaryPersonID
	
) as derivedtable 

GROUP BY ClientName, ClientID 
ORDER BY ClientName


end
GO
  