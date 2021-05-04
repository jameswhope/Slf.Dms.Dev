IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCheckSiteStatusReason')
	BEGIN
		 
CREATE TABLE tblCheckSiteStatusReason
(	ReasonId int identity(1,1) not null,
	ReasonCode varchar(4) not null,
	ReasonDescription varchar(255) not null,
	Status int not null
)

Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E01', 'Bad Image', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E02', 'No Amount', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E02', 'No Amount', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E03', 'No MICR', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E04', 'Foreign Check', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E05', 'Piggy Back', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E06', 'Invalid MICR', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E07', 'Invalid Item', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E08', 'Unreadable Amount', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E09', 'Unreadable MICR', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E10', 'Duplicate Check', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E11', 'User Request', 2)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E71', 'Check with no Invoice', 1)
Insert into tblCheckSiteStatusReason(ReasonCode,  ReasonDescription, Status)
Values ('E72', 'No Shadow Store Found', 1)

END
GO

