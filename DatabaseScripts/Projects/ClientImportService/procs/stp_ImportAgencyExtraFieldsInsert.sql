IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ImportAgencyExtraFieldsInsert')
	BEGIN
		DROP  Procedure  stp_ImportAgencyExtraFieldsInsert
	END

GO

CREATE Procedure stp_ImportAgencyExtraFieldsInsert
@ClientId int,
@LeadNumber varchar(50) = null,
@DateSent datetime = null,
@DateReceived datetime = null,
@SeidemanPullDate datetime = null,
@DebtTotal float = null,
@MissingInfo varchar(255) = null,
@UserId int
AS
BEGIN
insert into tblAgencyExtraFields01(ClientId, LeadNumber, DateSent, DateReceived, SeidemanPullDate,
DebtTotal, MissingInfo, Created, CreatedBy, LastModified, LastModifiedBy)
values(@ClientId, @LeadNumber, @DateSent, @DateReceived, @SeidemanPullDate,
@DebtTotal, @MissingInfo, GetDate(), @UserId, GetDate(), @UserId)
END

GO

