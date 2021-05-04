Drop Table tblVICILeadStatus
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVICILeadStatus')
	BEGIN
		CREATE TABLE [tblVICILeadStatus](
		[VICILeadStatusCode] [varchar](10) NOT NULL PRIMARY KEY,
		[Description] [varchar](255) NULL,
		[LeadStatusId] [int] NULL, 
		[CallResultTypeId] [int] NULL,
		[DialerStatusId] [int] NOT NULL,
		[Contacted] [bit] NOT NULL DEFAULT 0,
		[LeadReasonId] [int] NULL,
		[AutoNote] [bit] not null default 0) 
	END
	
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVICILeadStatus')
	BEGIN
		Delete from tblVICILeadStatus
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('A','Answering Machine',13,2,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('AA','Answering Machine Auto',13,2,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('AB','Busy Auto',15,5,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, LeadReasonId, AutoNote )
		Values('ADC','Disconnected Number Auto',14,9,4,0,27,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('AFAX','Fax Machine Auto',15,4,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('AFTHRS','Inbound After Hours Drop',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('AL','Answering Machine Msg Played',13,3,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('AM','Answering Machine Sent to Mesg',13,3,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('B','Busy',15,5,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('BAD','Bad Lead',14,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('CALLBK','Call Back',24,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('CBHOLD','Call Back Hold',24,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, LeadReasonId, AutoNote )
		Values('DC','Disconnected Number',14,9,4,0,27,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('DEC','Declined Representation',12,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('DNC','Do not Call',9,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('DNCL','Do not Call Hopper Match',9,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted)
		Values('DROP','Agent Not Available',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('ERI','Agent Error',NULL,4,6,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('INCALL','Lead Being Called',NULL,NULL,3,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('N','No Answer',15,4,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('NA','No Answer Auto',15,4,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('NANQUE','Inbound No Agent No Queue Drop',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('New','New Lead',16,NULL,1,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, LeadReasonId, AutoNote )
		Values('NI','Not Interested',12,1,4,1,23,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('NP','Does not Qualify',8,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('PDROP','PDROP',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('PM','Played Message',NULL,3,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('PU','Call Picked Up',NULL,NULL,4,0,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('QVMAIL','Queue Abandon Voicemail Left',13,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('RCV','Call Received',NULL,NULL,4,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('OTHERC','Another call related to the Lead',NULL,NULL,4,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('SALE','Sale Made',NULL,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('STP','Lead Stopped',NULL,NULL,0,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('SPK','Spoke with lead',2,1,4,1,1)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('TIMEOT','Inbound Queue Timeout Drop',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted )
		Values('XDROP','Agent Not Available IN',NULL,NULL,4,0)
		Insert Into tblVICILeadStatus(VICILeadStatusCode, [Description], LeadStatusId, CallResultTypeId, DialerStatusId, Contacted, AutoNote )
		Values('XFER','Phone Call Transferred',NULL,NULL,4,1,1)
	
END

GO

update tblleadstatus set show = 1 where description = 'Callback'

GO