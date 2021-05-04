--drop table tblViciCampaignGroup 

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciCampaignGroup')
	BEGIN
		CREATE TABLE  tblViciCampaignGroup(
		[CampaignGroupId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		[ViciCampaignId] [varchar](8) NOT NULL,
		[SourceId] varchar(50) NOT NULL,
		[ViciMainListId] [int] NOT NULL,
		[Active] [bit] NOT NULL DEFAULT 0,
		[FillMaxLeads] [int] NOT NULL DEFAULT 0,
		[DialerGroupId] [int] NULL,
		[Priority] [int] NOT NULL DEFAULT 0,
		[GetLeadSPName] [varchar](50) NULL,
		[CustomAniSPName] [varchar](50) NULL)
	END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciCampaignGroup')
	BEGIN
		IF not exists(select CampaignGroupId from tblViciCampaignGroup where ViciCampaignId = 'CID')
			INSERT Into tblViciCampaignGroup (ViciCampaignId, SourceId, ViciMainListId, Active, FillMaxLeads, DialerGroupId, Priority, GetLeadSPName, CustomAniSPName) Values ('CID', 'CID', 101, 1, 100, 2, 1, 'stp_Vici_GetNextLeadsToCall_CID', 'stp_Vici_GetCustomAni_CID')
	END
	
GO

IF col_length('tblViciCampaignGroup', 'SetRankSPName') is null
	Alter table tblViciCampaignGroup Add SetRankSPName varchar(100) null
	
GO





