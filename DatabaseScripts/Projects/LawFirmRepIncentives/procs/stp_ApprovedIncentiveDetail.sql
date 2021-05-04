IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ApprovedIncentiveDetail')
	DROP  Procedure  stp_ApprovedIncentiveDetail
GO

create procedure stp_ApprovedIncentiveDetail
(
	@repid int,
	@month int,
	@year int
)
as
begin

	-- initials
	select d.clientid, c.accountnumber, ic.externalclientid [leadapplicantid], p.firstname + ' ' + p.lastname [client], c.currentclientstatusid--, , dbo.udf_NextDepositDate(d.clientid) [nextdepositdate]
	from tblincentivedetail d
	join tblincentives i on i.incentiveid = d.incentiveid
	join tblclient c on c.clientid = d.clientid
	join tblperson p on p.personid = c.primarypersonid
	join tblimportedclient ic on ic.importid = c.serviceimportid
	where d.initial = 1
	and i.incentivemonth = @month
	and i.incentiveyear = @year
	and i.repid = @repid
	order by client
	
	-- residuals
	select d.clientid, c.accountnumber, ic.externalclientid [leadapplicantid], p.firstname + ' ' + p.lastname [client], c.currentclientstatusid
	from tblincentivedetail d
	join tblincentives i on i.incentiveid = d.incentiveid
	join tblclient c on c.clientid = d.clientid
	join tblperson p on p.personid = c.primarypersonid
	join tblimportedclient ic on ic.importid = c.serviceimportid
	where d.initial = 0
	and i.incentivemonth = @month
	and i.incentiveyear = @year
	and i.repid = @repid
	order by client

	-- team (where avail)
	if exists (	select 1
				from tblIncentivesTeam t
				join tblincentives i on i.incentiveid = t.repincentiveid
					and i.incentivemonth = @month
					and i.incentiveyear = @year
				where t.supid = @repid) begin
		
		-- supervisor's incentives
		select u.firstname + ' ' + u.lastname [rep], i.initialcount
		from tblincentives i 
		join tbluser u on u.userid = i.repid
		where i.incentivemonth = @month
			and i.incentiveyear = @year
			and i.repid = @repid
		
		union all
		
		-- team member incentives
		select u.firstname + ' ' + u.lastname [rep], i.initialcount
		from tblIncentivesTeam t
		join tblincentives i on i.incentiveid = t.repincentiveid
			and i.incentivemonth = @month
			and i.incentiveyear = @year
		join tbluser u on u.userid = i.repid
		where t.supid = @repid
		
		order by rep
	end
	else begin
		-- return empty table
		select '' [rep], 0 [initialcount]
		where 1=2
	end
end
go	 