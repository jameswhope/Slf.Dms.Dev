
if object_id('tblIncentiveNonDepositCharts') is null begin
	create table tblIncentiveNonDepositCharts
	(
		NonDepositChartID int identity(200,1) not null,
		ValidFrom datetime not null,
		ValidTo datetime,
		primary key (NonDepositChartID)
	)
	
	insert tblIncentiveNonDepositCharts (validfrom) values ('1/1/11')
end 