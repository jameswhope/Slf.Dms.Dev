-- Setting up user access tables for current agency and SA user accounts

declare @userid int


select @userid = userid from tbluser where username = 'avert'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,838)
	insert tbluseragencyaccess values (@userid,840)
	insert tbluseragencyaccess values (@userid,842)
	insert tbluseragencyaccess values (@userid,843)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,17)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'avert2'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,838)
	insert tbluseragencyaccess values (@userid,840)
	insert tbluseragencyaccess values (@userid,842)
	insert tbluseragencyaccess values (@userid,843)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,29)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'epic'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,838)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,5)
	insert tblusercommrecaccess values (@userid,24)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'epicfamily'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,838)
	insert tbluseragencyaccess values (@userid,840)
	insert tbluseragencyaccess values (@userid,842)
	insert tbluseragencyaccess values (@userid,843)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,17)
	insert tblusercommrecaccess values (@userid,29)
	insert tblusercommrecaccess values (@userid,5)
	insert tblusercommrecaccess values (@userid,24)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'debtchoice'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,839)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,6)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'debtchoice08'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,839)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,6)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'debtchoiceall'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,839)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,6)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'smithallen'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess values (@userid,851)
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,26)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'blemelin'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess select @userid,commrecid from tblcommrec where istrust = 0
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99, agencyid=-99, commrecid=-99, usergroupid=11 where userid=@userid


select @userid = userid from tbluser where username = 'rlemelin'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess select @userid,commrecid from tblcommrec where istrust = 0
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99, agencyid=-99, commrecid=-99, usergroupid=11 where userid=@userid


select @userid = userid from tbluser where username = 'bseideman'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess select @userid,commrecid from tblcommrec where istrust = 0
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99, agencyid=-99, commrecid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'sseideman'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,3)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,1)
	insert tblusercompanyaccess values (@userid,2)
	insert tblusercompanyaccess values (@userid,3)
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set companyid=-99, agencyid=-99, commrecid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'rpalmer'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,18)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,2)
end
update tbluser set agencyid=-99, commrecid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'miniguez'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,30)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,3)
end
update tbluser set agencyid=-99, commrecid=-99 where userid=@userid


select @userid = userid from tbluser where username = 'rmossler'
if not exists (select 1 from tbluseragencyaccess where userid = @userid) begin
	insert tbluseragencyaccess select @userid, agencyid from tblagency
end
if not exists (select 1 from tblusercommrecaccess where userid = @userid) begin
	insert tblusercommrecaccess values (@userid,33)
end
if not exists (select 1 from tblusercompanyaccess where userid = @userid) begin
	insert tblusercompanyaccess values (@userid,4)
end
update tbluser set agencyid=-99, commrecid=-99 where userid=@userid

