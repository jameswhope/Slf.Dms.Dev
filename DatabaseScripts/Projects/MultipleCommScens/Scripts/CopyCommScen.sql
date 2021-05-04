
if not exists (select 1 from tblcommstruct where commrecid in (24,29)) begin
	exec stp_CopyCommScen 1,5,24,'5/16/07 23:59:59','5/17/07','7/31/08 23:59:59',820
	exec stp_CopyCommScen 1,5,29,null,'8/1/08',null,820
	exec stp_CopyCommScen 11,17,29,'7/31/08 23:59:59','8/1/08',null,820
	exec stp_CopyCommScen 12,17,29,'7/31/08 23:59:59','8/1/08',null,820
	exec stp_CopyCommScen 13,17,29,'7/31/08 23:59:59','8/1/08',null,820

	-- cleanup orphan records
	delete from tblcommstruct where commscenid not in (select commscenid from tblcommscen) 
end