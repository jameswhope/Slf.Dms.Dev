 
create table tblIncentiveChart
(
	IncentiveChartID int not null,
	ClientsMin int not null,
	ClientsMax int not null,
	InitialPymt money not null,
	Residual money not null,
	ResidualOld money,
	foreign key (IncentiveChartID) references tblIncentiveCharts(IncentiveChartID) on delete cascade
)

/*
Thru Feb '10
insert tblIncentiveChart values (0,19,0,0)
insert tblIncentiveChart values (20,24,7.5,2)
insert tblIncentiveChart values (25,29,8.5,3)
insert tblIncentiveChart values (30,34,10,3.5)
insert tblIncentiveChart values (35,39,30,6.25)
insert tblIncentiveChart values (40,44,32,6.85)
insert tblIncentiveChart values (45,49,34,7.15)
insert tblIncentiveChart values (50,54,36,7.35)
insert tblIncentiveChart values (55,59,38,7.65)
insert tblIncentiveChart values (60,64,40,7.85)
insert tblIncentiveChart values (65,69,42,7.95)
insert tblIncentiveChart values (70,999,44,8.25)
*/

/*insert tblIncentiveChart values (101, 0, 24, 0.00,0.00)
insert tblIncentiveChart values (101,25, 29, 6.00,1.60)
insert tblIncentiveChart values (101,30, 34, 6.05,2.50)
insert tblIncentiveChart values (101,35, 39, 6.55,3.00)
insert tblIncentiveChart values (101,40, 44,21.25,4.45)
insert tblIncentiveChart values (101,45, 49,22.40,5.00)
insert tblIncentiveChart values (101,50, 54,23.60,5.15)
insert tblIncentiveChart values (101,55, 59,24.70,5.35)
insert tblIncentiveChart values (101,60, 64,25.80,5.55)
insert tblIncentiveChart values (101,65, 69,26.90,5.65)
insert tblIncentiveChart values (101,70, 74,28.00,5.70)
insert tblIncentiveChart values (101,75,999,29.05,5.95)

alter table tblincentivecharts add Supervisor bit default(0) not null
insert tblincentivecharts (validfrom,validto,supervisor) values ('3/1/10',null,1)

insert tblIncentiveChart values (102,  0,174, 0.00,0)
insert tblIncentiveChart values (102,175,199, 2.00,0)
insert tblIncentiveChart values (102,200,224, 3.60,0)
insert tblIncentiveChart values (102,225,249, 6.15,0)
insert tblIncentiveChart values (102,250,274, 8.30,0)
insert tblIncentiveChart values (102,275,299,10.35,0)
insert tblIncentiveChart values (102,300,324,12.60,0)
insert tblIncentiveChart values (102,325,349,14.50,0)
insert tblIncentiveChart values (102,350,374,16.10,0)
insert tblIncentiveChart values (102,375,999,17.90,0)

insert tblincentivecharts (validfrom,supervisor) values ('9/1/2010',0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,0,59,0,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,60,64,3,.5)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,65,69,3.5,.5)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,70,74,4,1)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,75,79,4.5,1.25)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,80,84,9,2.5)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,85,89,12,2.75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,90,94,12.5,3)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,95,99,13,3.5)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,100,104,14,3.75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,105,119,14.5,4)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (103,120,999,15,4.25)
*/
/*
-- new chart for sr. reps
update tblincentivecharts set validto = '8/31/10 23:59' where incentivechartid = 101
insert tblincentivecharts (validfrom,supervisor) values ('9/1/2010',0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,0,59,0,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,60, 64,  6.00,1.60)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,65, 69,  6.05,2.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,70, 74,  6.55,3.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,75, 79, 21.25,4.45)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,80, 84, 22.40,5.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,85, 89, 23.60,5.15)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,90, 94, 24.70,5.35)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,95, 99, 25.80,5.55)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,100,104,26.90,5.65)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,105,119,28.00,5.70)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (104,120,999,29.05,5.95)

update tblIncentiveChartXref
set incentivechartid = 104
where repid in (
,1421 
,1268 
,1422 
,1392 
,1431 
,1262
,1387) 
*/

/*-- new chart for reps (effective Oct 10)
update tblincentivecharts set validto = '9/30/10 23:59' where incentivechartid in (102,103,104)
insert tblincentivecharts (validfrom,supervisor) values ('10/1/2010',0)

insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105, 0, 59,     0,   0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,60, 64,  5.00, .50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,65, 69,  6.00,1.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,70, 74,  6.50,1.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,75, 79, 17.00,2.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,80, 84, 18.00,2.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,85, 89, 19.00,3.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,90, 94, 20.00,3.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,95, 99, 22.00,4.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,100,104,24.00,4.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,105,109,26.00,5.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (105,110,999,28.00,5.50)

update tblIncentiveChartXref
set incentivechartid = 105
where repid in (
1421 
,1392
,1473
,1491
,1431
,1413
,1474
,1485
,1492
,1476
,1422
)


-- supervisors (eff Oct 10)
insert tblincentivecharts (validfrom,supervisor) values ('10/1/2010',1)

insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,  0,359,     0,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,360,389,  2.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,390,419,  3.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,420,449,  4.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,450,479,  5.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,480,509,  8.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,510,539, 10.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,540,569, 12.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,570,599, 13.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,600,629, 14.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,630,659, 15.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (106,660,999, 16.00,0)

update tblIncentiveChartXref
set incentivechartid = 106
where repid in (1262,1268,1387)*/


/*
-- new chart for reps (effective Nov 10)
update tblincentivecharts set validto = '10/31/10 23:59' where incentivechartid in (105,106)
insert tblincentivecharts (validfrom,supervisor) values ('11/1/2010',0)

insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107, 0, 19,     0,   0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,20, 24, 15.00, .75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,25, 29, 18.00,1.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,30, 34, 20.00,1.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,35, 39, 36.00,2.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,40, 44, 38.00,2.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,45, 49, 39.00,2.75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,50, 54, 40.00,3.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,55, 59, 41.00,3.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,60, 64, 43.00,4.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,65, 69, 44.00,4.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (107,70,999, 46.00,5.00)

update tblIncentiveChartXref
set incentivechartid = 107
where incentivechartid = 105


-- supervisors (eff Nov 10)
insert tblincentivecharts (validfrom,supervisor) values ('10/1/2010',1)

insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,  0,119,     0,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,120,149,  5.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,150,179,  6.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,180,209,  7.50,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,210,239,  8.50,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,240,269, 13.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,270,299, 15.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,300,329, 17.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,330,359, 18.00,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,360,389, 18.50,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,390,419, 19.50,0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual) values (108,420,999, 20.00,0)

update tblIncentiveChartXref
set incentivechartid = 108
where incentivechartid = 106*/


-- new chart for reps (effective Jan 11)
update tblincentivecharts set validto = '12/31/10 23:59' where incentivechartid in (107,108)
insert tblincentivecharts (validfrom,supervisor) values ('1/1/2011',0)

insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109, 0, 19,     0,   0,    0)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,20, 24,  1.00,   0,  .75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,25, 29,  1.00,  .25,1.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,30, 34,  4.00, 1.60,1.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,35, 39,  7.25, 2.85,2.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,40, 44, 16.25, 6.50,2.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,45, 49, 19.00, 7.70,2.75)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,50, 54, 21.00, 8.35,3.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,55, 59, 22.50, 9.05,3.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,60, 64, 24.50, 9.95,4.00)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,65, 69, 27.00,10.95,4.50)
insert tblincentivechart (incentivechartid,clientsmin,clientsmax,initialpymt,residual,residualold) values (109,70,999, 29.00,11.90,5.00)

update tblIncentiveChartXref
set incentivechartid = 109
where incentivechartid = 107