
insert tblcommstruct (commscenid,commrecid,parentcommrecid,[order],created,createdby,lastmodified,lastmodifiedby,companyid)
select commscenid,commrecid,parentcommrecid,[order],created,createdby,lastmodified,lastmodifiedby,companyid
from (
	select commscenid, 
		case 
			when commrecid = 22 then 39 -- trust
			when commrecid = 20 then 38 -- gca
			when commrecid = 18 then 37 -- oa
			else commrecid 
		end [commrecid],
		case 
			when parentcommrecid = 22 then 39 -- trust
			when parentcommrecid = 20 then 38 -- gca
			when parentcommrecid = 18 then 37 -- oa
			else parentcommrecid 
		end [parentcommrecid],
		[order],
		getdate() [created],
		820 [createdby],
		getdate() [lastmodified],
		820 [lastmodifiedby],
		5 [companyid]
	from tblcommstruct
	where companyid = 2
) d
where not exists (select 1 from tblcommstruct cs
						where cs.commscenid = d.commscenid and cs.companyid = d.companyid
							 and cs.commrecid = d.commrecid and cs.parentcommrecid = d.parentcommrecid) 