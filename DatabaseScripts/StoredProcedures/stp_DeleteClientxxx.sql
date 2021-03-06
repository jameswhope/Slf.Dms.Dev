/****** Object:  StoredProcedure [dbo].[stp_DeleteClientxxx]    Script Date: 11/19/2007 15:26:59 ******/
DROP PROCEDURE [dbo].[stp_DeleteClientxxx]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[stp_DeleteClientxxx]
(
	@clientId int
)

AS

SET NOCOUNT ON

--delete core info
delete from tblenrollment where clientid = @clientid
delete from tblphone where phoneid in (select personphoneid from tblpersonphone where personid in (select personid from tblperson where clientid = @clientid))
delete from tblpersonphone where personid in (select personid from tblperson where clientid = @clientid)
delete from tblphonecall where personid in (select personid from tblperson where clientid = @clientid)
delete from tblperson where clientid = @clientid
delete from tblagencyextrafields01 where clientid = @clientid
delete from tblclient where clientid=@clientid

--delete task stuff
select tbltask.taskid as taskid into #tmp from tbltask inner join tblclienttask on tbltask.taskid=tblclienttask.taskid where tblclienttask.clientid=@clientid
delete from tbltask where taskid in (select taskid from tblroadmaptask where taskid in (select taskid from #tmp))
delete from tblroadmaptask where taskid in (select taskid from #tmp)
delete from tblclienttask where taskid in(select taskid from #tmp)
delete from tblnote where noteid in (select noteid from tbltasknote where taskid in (select taskid from #tmp))
delete from tbltasknote where taskid in (select taskid from #tmp)
delete from tbltask where taskid in (select taskid from #tmp)
delete from tbltaskpropagationexception where clientid=@clientid
delete from tbltaskpropagationsaved where taskid in (select taskid from #tmp)
delete from tbltaskvalue where taskid in (select taskid from #tmp)
drop table #tmp

select tblregister.registerid into #tmp2 from tblregister where clientid=@clientid

--delete register stuff
delete from tblregister where clientid = @clientid
delete from tblregisterpayment where feeregisterid in (select registerid from #tmp2)
delete from tblregisterpaymentdeposit where depositregisterid in (select registerid from #tmp2)


--delete commission stuff
delete from tblCommChargeback WHERE CommPayID IN (select CommPayId from tblCommPay WHERE RegisterPaymentId IN (select registerid from #tmp2))
delete from tblCommPay WHERE RegisterPaymentId IN (select registerid from #tmp2)

drop table #tmp2

--delete account stuff
delete from tblcreditorinstance where accountid in (select accountid from tblaccount where clientid=@clientid)
delete from tblmediation where accountid in (select accountid from tblaccount where clientid=@clientid)
delete from tblaccount where clientid=@clientid


--misc
delete from tblclientanchangelog where clientid=@clientid
delete from tblnote where noteid in (select noteid from tblroadmapnote where roadmapid in (select roadmapid from tblroadmap where clientid=@clientid))
delete from tblroadmapnote where roadmapid in (select roadmapid from tblroadmap where clientid=@clientid)
delete from tblroadmap where clientid=@clientid
delete from tblnote where clientid=@clientid


delete from tblclientsearch where clientid=@clientid
delete from tblchecktoprint where clientid=@clientid

--clean up data entry stuff
delete from tbldoc where docid in (select docid from tbldataentrydoc where dataentryid in (select dataentryid from tbldataentry where clientid=@clientid))
delete from tbldataentrydoc where dataentryid in (select dataentryid from tbldataentry where clientid=@clientid)
delete from tbldataentryvalue where dataentryid in (select dataentryid from tbldataentry where clientid=@clientid)
delete from tbldataentry where clientid=@clientid
GO
