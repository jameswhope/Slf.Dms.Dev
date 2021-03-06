/****** Object:  UserDefinedFunction [dbo].[getentitydisplay]    Script Date: 11/19/2007 14:49:15 ******/
DROP FUNCTION [dbo].[getentitydisplay]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getentitydisplay]
(
	@relationtypeid int,
	@relationid int
)

returns varchar(100)
begin

declare @result varchar(100)

if @relationtypeid = 1 begin --client
	set @result=
	(
		select 
			coalesce(firstname,'?') + ' ' + coalesce(lastname,'?')
		from
			tblclient c inner join
			tblperson p on c.primarypersonid=p.personid
		where
			c.clientid=@relationid
	)
end else if @relationtypeid = 2 begin --creditor account
	set @result=
	(
		select 
			cr.name  + ' ' + 
			isnull(
			case 
				when len(ci.accountnumber)>=5 then '***' + substring(ci.accountnumber,len(ci.accountnumber)-3,len(ci.accountnumber))
				else ci.accountnumber
			end
			,'')
		from
			tblaccount a inner join
			tblcreditorinstance ci on a.currentcreditorinstanceid=ci.creditorinstanceid inner join
			tblcreditor cr on ci.creditorid=cr.creditorid
		where
			a.accountid=@relationid
	)
end else if @relationtypeid = 3 begin --contact
	set @result=
	(
		select 
			co.firstname + ' ' + co.lastname
		from
			tblcontact co
		where
			co.contactid=@relationid
	)
end else if @relationtypeid = 4 begin --register
	set @result=
	(
		select 
			et.[name] + ' of $' + convert(varchar,abs(r.amount),1) + ' on ' + convert(varchar,transactiondate,6)
		from
			tblregister r inner join
			tblentrytype et on r.entrytypeid=et.entrytypeid
		where
			r.registerid=@relationid
	)
end else if @relationtypeid = 5 begin --register payment
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(r.amount),1) + ' on ' + convert(varchar,paymentdate,6) + ' for ' + et.[name]
		from
			tblregisterpayment rp inner join
			tblregister r on rp.feeregisterid=r.registerid inner join
			tblentrytype et on r.entrytypeid=et.entrytypeid
		where
			rp.registerpaymentid=@relationid
	)
end else if @relationtypeid = 8 begin --person/applicant
	set @result=
	(
		select 
			firstname + ' ' + lastname
		from
			tblperson p
		where
			p.personid=@relationid
	)
end else if @relationtypeid = 11 begin --ach rule
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(depositamount),1) + ' starting ' + convert(varchar,startdate,6)
		from
			tblruleach ar
		where
			ar.ruleachid=@relationid
	)
end else if @relationtypeid = 13 begin --ad hoc ach
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(depositamount),1) + ' for ' + convert(varchar,depositdate,6)
		from
			tbladhocach ah
		where
			ah.adhocachid=@relationid
	)
end else if @relationtypeid = 14 begin --check to print
	set @result=
	(
		select 
			'of $' + convert(varchar,abs(amount),1) + ' for ' + convert(varchar,checkdate,6)
		from
			tblchecktoprint ctp
		where
			ctp.checktoprintid=@relationid
	)
end else if @relationtypeid = 15 begin --negotiation
	set @result=
	(
		select 
			'for account ' + dbo.getentitydisplay(2,m.accountid)
		from
			tblmediation m
		where
			m.mediationid=@relationid
	)
end

return @result

end
GO
