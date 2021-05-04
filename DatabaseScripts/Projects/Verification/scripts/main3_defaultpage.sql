
alter table tblusergroup add MainPage varchar(100)

-- Client Intake (need to instruct them to logout/in and remove ReturnUrl)
--update tblusergroup set defaultpage='clients/enrollment', mainpage='~/Main3.aspx' where usergroupid = 1

-- Verification
update tblusergroup set defaultpage=null, mainpage='~/Main3.aspx' where usergroupid = 2