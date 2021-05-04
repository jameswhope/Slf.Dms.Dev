IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_ClientCurrentStatusCreated')
		DROP  view  vw_ClientCurrentStatusCreated 
GO

create view vw_ClientCurrentStatusCreated 
as


select c.clientid, c.currentclientstatusid, c.created [clientcreated], max(r.created)[statuscreated], min(r.created)[minstatuscreated]
from tblclient c
join tblroadmap r on r.clientid = c.clientid and r.clientstatusid = c.currentclientstatusid
group by c.clientid, c.currentclientstatusid, c.created

 