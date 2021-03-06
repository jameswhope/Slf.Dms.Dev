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
		@CompanyID nvarchar(10),
		@CommRecID nvarchar(10),
		@ClientCreatedDateFrom varchar(20) = '1/1/1900',
		@ClientCreatedDateTo varchar(20) = '1/1/2050'
	)

as

declare @cmd nvarchar(MAX)

set @cmd = 'SELECT ClientID, ClientName, sum(Amount) as Amount FROM (SELECT person.ClientID, ltrim(person.FirstName + '' '' + person.LastName) as ClientName, comm.Amount as Amount FROM tblCommPay as comm inner join tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID inner join tblRegister as register on register.RegisterID = registerpay.FeeRegisterID inner join tblClient as client on client.ClientID = register.ClientID left join tblPerson as person on person.PersonID = client.PrimaryPersonID WHERE comm.commbatchid in ('
set @cmd = @cmd + @CommBatchIDs
set @cmd = @cmd + ') and client.CompanyID = '
set @cmd = @cmd + @CompanyID
set @cmd = @cmd + ' and commstructid in (SELECT commstructid FROM tblcommstruct WHERE commrecid in ('

if @CommRecID = '24'
begin
	set @cmd = @cmd + '5'
end
else
begin
	set @cmd = @cmd + @CommRecID
end

set @cmd = @cmd + ') and parentcommrecid <> 4)'


if @CommRecID = '5'
begin
	set @cmd = @cmd + ' and client.Created <= ''05-16-2007'''
end
else if @CommRecID = '24'
begin
	set @cmd = @cmd + ' and client.Created > ''05-16-2007'''
end
else 
begin
	set @cmd = @cmd + ' and (client.Created between ''' + @ClientCreatedDateFrom + ''' and ''' + @ClientCreatedDateTo + ''')'
end

set @cmd = @cmd + ' UNION ALL SELECT person.ClientID, ltrim(person.FirstName + '' '' + person.LastName) as ClientName, -comm.Amount as Amount FROM tblCommChargeback as comm inner join tblRegisterPayment as registerpay on registerpay.RegisterPaymentID = comm.RegisterPaymentID inner join tblRegister as register on register.RegisterID = registerpay.FeeRegisterID inner join tblClient as client on client.ClientID = register.ClientID left join tblPerson as person on person.PersonID = client.PrimaryPersonID WHERE comm.commbatchid in ('
set @cmd = @cmd + @CommBatchIDs + ') and client.CompanyID = '
set @cmd = @cmd + @CompanyID
set @cmd = @cmd + ' and commstructid in (SELECT commstructid FROM tblcommstruct WHERE commrecid in ('

if @CommRecID = '24'
begin
	set @cmd = @cmd + '5'
end
else
begin
	set @cmd = @cmd + @CommRecID
end

set @cmd = @cmd + ') and parentcommrecid <> 4)'


if @CommRecID = '5'
begin
	set @cmd = @cmd + ' and client.Created <= ''05-16-2007'''
end
else if @CommRecID = '24'
begin
	set @cmd = @cmd + ' and client.Created > ''05-16-2007'''
end
else 
begin
	set @cmd = @cmd + ' and (client.Created between ''' + @ClientCreatedDateFrom + ''' and ''' + @ClientCreatedDateTo + ''')'
end

set @cmd = @cmd + ') as derivedtable GROUP BY ClientName, ClientID ORDER BY ClientName'

exec (@cmd)
GO
