
if object_id('tblRevShareHours') is null begin
	create table tblRevShareHours
	(
		rDay varchar(20) not null,
		FromHr int not null,
		ToHr int not null,
		primary key (rDay)
	)

	insert  tblRevShareHours values ('Monday',18,7) 
	insert  tblRevShareHours values ('Tuesday',18,7)
	insert  tblRevShareHours values ('Wednesday',18,7)
	insert  tblRevShareHours values ('Thursday',18,7)
	insert  tblRevShareHours values ('Friday',18,7)
	insert  tblRevShareHours values ('Saturday',13,7)
	insert  tblRevShareHours values ('Sunday',0,24)
end