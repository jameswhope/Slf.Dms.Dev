
set identity_insert tblcompany on

insert tblcompany (companyid,name,[default],shortconame,created,createdby,lastmodified,lastmodifiedby,contact1,billingmessage,sigpath,controlledaccountname)
values (6,'The Law Offices of Barker & Associates',0,'BARKER',getdate(),820,getdate(),820,'Sissie Barker','Monday thru Friday 7:00 am to 6:00 pm PST','\\nas02\Sig\signature_Barker.jpg','Barker General Clearing Account')

set identity_insert tblcompany off


set identity_insert tblcommrec on

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (41,1,'BARK OA','Barker Operating Account',1,0,0,0,'ACH','BANK OF HAWAII','121301028','0006346162','C',getdate(),820,getdate(),820,6,3)

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (42,1,'BARK GCA','Barker General Clearing Account',1,0,0,1,'ACH','','0','0','C',getdate(),820,getdate(),820,6,1)

insert tblcommrec (commrecid,commrectypeid,abbreviation,display,iscommercial,islocked,istrust,isgca,method,bankname,routingnumber,accountnumber,[type],created,createdby,lastmodified,lastmodifiedby,companyid,accounttypeid)
values (43,1,'BARK Trust','Barker Client Trust',1,0,1,0,'ACH','','0','0','C',getdate(),820,getdate(),820,6,2)

set identity_insert tblcommrec off


INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (2, 6, 'P.O. Box 2200', 'c/o Lexxiom Payment Solutions, Inc.', 'Rancho Cucamonga', 'CA', '91729-2200', getdate())

INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (3, 6, 'P.O. Box 3000', '', 'Rancho Cucamonga', 'CA', '91729-3000', getdate())

INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (4, 6, 'P.O. Box 3000', '', 'Rancho Cucamonga', 'CA', '91729-3000', getdate())

INSERT INTO tblCompanyAddresses (AddressTypeID, CompanyID, Address1, Address2, City, State, Zipcode, date_created)
VALUES (5, 6, '11690 Pacific Ave.', 'Suite 100', 'Fontana', 'CA', '92337-8224', getdate())



INSERT INTO tblCompanyPhones (companyphoneid, CompanyID, PhoneType, PhoneNumber) VALUES (42, 6, 46, '8007458390') -- CustomerServicePhone/Client Services
INSERT INTO tblCompanyPhones (companyphoneid, CompanyID, PhoneType, PhoneNumber) VALUES (42, 6, 48, '8007454694') -- CompliancePhone
INSERT INTO tblCompanyPhones (companyphoneid, CompanyID, PhoneType, PhoneNumber) VALUES (42, 6, 50, '9095817524') -- CreditorServicesPhone



insert tblcommstruct (commscenid,commrecid,parentcommrecid,[order],created,createdby,lastmodified,lastmodifiedby,companyid)
select commscenid,commrecid,parentcommrecid,[order],created,createdby,lastmodified,lastmodifiedby,companyid
from (
	select commscenid, 
		case 
			when commrecid = 32 then 43 -- trust
			when commrecid = 31 then 42 -- gca
			when commrecid = 30 then 41 -- oa
			else commrecid 
		end [commrecid],
		case 
			when parentcommrecid = 32 then 43 -- trust
			when parentcommrecid = 31 then 42 -- gca
			when parentcommrecid = 30 then 41 -- oa
			else parentcommrecid 
		end [parentcommrecid],
		[order],
		getdate() [created],
		820 [createdby],
		getdate() [lastmodified],
		820 [lastmodifiedby],
		6 [companyid]
	from tblcommstruct
	where companyid = 3
) d
where not exists (select 1 from tblcommstruct cs
						where cs.commscenid = d.commscenid and cs.companyid = d.companyid
							 and cs.commrecid = d.commrecid and cs.parentcommrecid = d.parentcommrecid) 
							 
							 
							 
UPDATE tblCommStruct
SET ParentCommStructID = sub.[parent]
FROM 
(
	SELECT s.CommStructID [child], p.CommStructID [parent]
	FROM tblCommStruct s
	JOIN tblCommStruct p 
		ON p.CommScenId = s.CommScenID 
		AND p.CompanyID = s.CompanyID 
		AND p.CommRecID = s.ParentCommRecID
) sub
WHERE CommStructID = sub.[child] AND ParentCommStructID IS NULL
AND CompanyID = 6



-- get palmer structs
select distinct cs.commstructid, commscenid, commrecid, parentcommrecid, [order] 
into #iniguez
from tblcommstruct cs
join tblcommfee f on f.commstructid = cs.commstructid
where companyid = 3

-- get peavey structs
select distinct commstructid, commscenid, commrecid, parentcommrecid, [order] 
into #barker
from tblcommstruct
where companyid = 6

-- need to differenciate any dup structs
update #iniguez 
set [order] = 99
where commstructid in (
	select max(commstructid)
	from #iniguez
	group by commstructid, commscenid, commrecid, parentcommrecid, [order] 
	having count(*) > 1
)

update #barker
set [order] = 99
where commstructid in (
	select max(commstructid)
	from #barker
	group by commstructid, commscenid, commrecid, parentcommrecid, [order] 
	having count(*) > 1
)


declare 
	@iniguez_commstructid int, 
	@iniguez_commscenid int,
	@iniguez_commrecid int,
	@iniguez_parentcommrecid int,
	@iniguez_order int,
	@peavey_commstructid int

declare cur cursor for select commstructid, commscenid, commrecid, parentcommrecid, [order] from #iniguez

open cur 
fetch next from cur into @iniguez_commstructid, @iniguez_commscenid, @iniguez_commrecid, @iniguez_parentcommrecid, @iniguez_order

while @@fetch_status = 0 begin
	if @iniguez_commrecid = 32 set @iniguez_commrecid = 43 -- trust
	if @iniguez_commrecid = 31 set @iniguez_commrecid = 42 -- gca
	if @iniguez_commrecid = 30 set @iniguez_commrecid = 41 -- oa

	if @iniguez_parentcommrecid = 32 set @iniguez_parentcommrecid = 43 -- trust
	if @iniguez_parentcommrecid = 31 set @iniguez_parentcommrecid = 42 -- gca
	if @iniguez_parentcommrecid = 30 set @iniguez_parentcommrecid = 41 -- oa

	select @peavey_commstructid = commstructid
	from #barker
	where commscenid = @iniguez_commscenid
	and commrecid = @iniguez_commrecid
	and parentcommrecid = @iniguez_parentcommrecid
	and [order] = @iniguez_order

	insert tblcommfee (commstructid,entrytypeid,[percent],created,createdby,lastmodified,lastmodifiedby)
	select @peavey_commstructid,entrytypeid,[percent],getdate(),820,getdate(),820
	from tblcommfee
	where commstructid = @iniguez_commstructid

	fetch next from cur into @iniguez_commstructid, @iniguez_commscenid, @iniguez_commrecid, @iniguez_parentcommrecid, @iniguez_order
end

close cur
deallocate cur

drop table #iniguez
drop table #barker 



