
create table tblIncentiveNonDepositChart
(
	NonDepositChartID int not null,
	ConvMin money not null,
	ConvMax money not null,
	Adjustment money not null,
	foreign key (NonDepositChartID) references tblIncentiveNonDepositCharts(NonDepositChartID) on delete cascade
) 

insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.000,0.004,0.80)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.005,0.009,0.85)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.010,0.014,0.90)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.015,0.019,0.95)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.020,0.024,1.00)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.025,0.029,1.05)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.030,0.034,1.10)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.035,0.039,1.15)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.040,0.044,1.20)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.045,0.049,1.25)
insert tblIncentiveNonDepositChart (NonDepositChartID,convmin,convmax,adjustment) values (200,0.050,1.000,1.30)
