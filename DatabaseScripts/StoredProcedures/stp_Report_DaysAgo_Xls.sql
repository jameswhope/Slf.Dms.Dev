/****** Object:  StoredProcedure [dbo].[stp_Report_DaysAgo_Xls]    Script Date: 11/19/2007 15:27:38 ******/
DROP PROCEDURE [dbo].[stp_Report_DaysAgo_Xls]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Report_DaysAgo_Xls]
(
	@startdate datetime=null,
	@includeonlytransactions varchar (8000)='1=1',
	@criteria varchar (8000)='1=1',
	@unioncriteria varchar (8000)='1=1',
	@neverdeposited bit = 0
)

as

if @startdate is null
	set @startdate=getdate()

set @unioncriteria=' and ' + @unioncriteria

declare @union varchar(8000)

if (@neverdeposited = 1) begin
	set @union = ' union all 
	select 
		c.clientid,
		c.created as hiredate,
		c.accountnumber,		
		c.depositmethod,
		c.depositamount,
		c.depositday,
		c.depositstartdate,
		a.agencyid,
		a.code as agencyname,
		cs.clientstatusid,
		cs.name as clientstatusname,

		(p.firstname + '' '' + p.lastname) as clientname,
		p.lastname,
		p.street,
		p.street2,
		p.city,
		s.name as statename,
		p.zipcode,
		(tblHomePhone.AreaCode + tblHomePhone.Number + '' '' + tblHomePhone.Extension) as HomePhone,
		(tblWorkPhone.AreaCode + tblWorkPhone.Number + '' '' + tblWorkPhone.Extension) as WorkPhone,
		
		null as daysago,
		null as registerid,
		null as transactiondate,
		null as amount,
		null as bounce,
		null as void,
		null as achyear
		
	from 
		tblclient c inner join
		tblperson p on c.primarypersonid = p.personid inner join
		tblstate s on p.stateid = s.stateid inner join
		tblclientstatus cs on c.currentclientstatusid = cs.clientstatusid inner join
		tblagency a on c.agencyid = a.agencyid 

		left outer join
		(
			select personid,ph1.* from tblpersonphone pph1 inner join tblphone ph1 on pph1.phoneid=ph1.phoneid
			where ph1.phonetypeid=27
		) tblHomePhone on tblHomePhone.personid=p.personid
		
		left outer join
		(
			select personid,ph1.* from tblpersonphone pph1 inner join tblphone ph1 on pph1.phoneid=ph1.phoneid
			where ph1.phonetypeid=27
		) tblWorkPhone on tblWorkPhone.personid=p.personid

	where 
		not c.clientid in (select r.clientid from tblregister r where r.entrytypeid in (3,10))
		
' + @unioncriteria
end else begin 
	set @union = ''	
end

set @criteria=' where ' + @criteria

exec
(
	'select
		t.clientid,
		t.hiredate,
		t.accountnumber,		
		t.depositmethod,
		t.depositamount,
		t.depositday,
		t.depositstartdate,
		
		t.agencyid,
		t.agencyname,
		t.clientstatusid,
		t.clientstatusname,

		t.clientname,
		t.lastname,
		t.street,
		t.street2,
		t.city,
		t.statename,
		t.zipcode,
		t.HomePhone,
		t.WorkPhone,
		
		t.daysago,
		t.registerid,
		t.transactiondate,
		t.amount,
		t.bounce,
		t.void,
		t.achyear
		
		
	from
		(
			select
				convert(money, datediff(mi, r.transactiondate, ''' + @startdate + ''')) / 1400 as daysago,
				c.depositmethod,
				c.depositamount,
				c.depositday,
				c.depositstartdate,
				c.created as hiredate,
				c.accountnumber,
				c.agencyid,
				a.code as agencyname,
				cs.clientstatusid,
				(p.firstname + '' '' + p.lastname) as clientname,
				p.lastname,
				p.street,
				p.street2,
				p.city,
				s.name as statename,
				p.zipcode,
				cs.name as clientstatusname,
				(tblHomePhone.AreaCode + tblHomePhone.Number + '' '' + tblHomePhone.Extension) as HomePhone,
				(tblWorkPhone.AreaCode + tblWorkPhone.Number + '' '' + tblWorkPhone.Extension) as WorkPhone,
				r.*
			from
				tblregister r inner join
				(
					select
						nr.clientid,
						max(registerid) as registerid
					from
						tblregister nr inner join
						(
							select
								clientid,
								max(transactiondate) as transactiondate
							from
								tblregister
							where
								(
									entrytypeid = 3 or
									entrytypeid = 10
								)
								and (' + @includeonlytransactions + ')
							group by
								clientid
						)
						as nnr on nr.clientid = nnr.clientid and nr.transactiondate = nnr.transactiondate
					group by
						nr.clientid
				)
				as nr on r.registerid = nr.registerid inner join
				tblclient c on r.clientid = c.clientid inner join
				tblperson p on c.primarypersonid = p.personid inner join
				tblstate s on p.stateid = s.stateid inner join
				tblclientstatus cs on c.currentclientstatusid = cs.clientstatusid inner join
				tblagency a on c.agencyid = a.agencyid 

				left outer join
				(
					select personid,ph1.* from tblpersonphone pph1 inner join tblphone ph1 on pph1.phoneid=ph1.phoneid
					where ph1.phonetypeid=27
				) tblHomePhone on tblHomePhone.personid=p.personid
				
				left outer join
				(
					select personid,ph1.* from tblpersonphone pph1 inner join tblphone ph1 on pph1.phoneid=ph1.phoneid
					where ph1.phonetypeid=27
				) tblWorkPhone on tblWorkPhone.personid=p.personid
				
		)
		as t
	
		' + @criteria
		
		+ @union

		+ ' order by lastname'
)
GO
