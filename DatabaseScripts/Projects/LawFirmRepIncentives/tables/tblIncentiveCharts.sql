
if object_id('tblIncentiveCharts') is null begin
	create table tblIncentiveCharts
	(
		IncentiveChartID int identity(100,1) not null,
		ValidFrom datetime not null,
		ValidTo datetime,
		Supervisor bit default(0) not null,
		primary key (IncentiveChartID)
	)
end