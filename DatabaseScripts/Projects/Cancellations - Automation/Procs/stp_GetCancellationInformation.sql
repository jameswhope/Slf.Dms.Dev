IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetCancellationInformation')
	BEGIN
		DROP  Procedure  stp_GetCancellationInformation
	END

GO

CREATE Procedure stp_GetCancellationInformation
(
	@MatterId int	
)
AS
BEGIN
	
	SELECT cl.CancellationId,
		   cl.ClientId,
		   cl.MatterId,
		   c.AvailableSDA,
		   c.SDABalance,
		   c.PFOBalance,
		   (isnull(c.SDAbalance,0) - isnull(c.PFOBalance,0) - isnull(c.BankReserve,0) - isnull(c.AvailableSDA,0)) AS FundsOnHold,
		   cl.IsDeleted,
		   cl.HasAssociatedMatters,
		   cl.ClientAgreedToPay,
		   cl.IsFeeOwed,
		   cl.ClientRequestedRefund,
		   cl.Totalrefund,
		   cl.ApprovedBy As ApprovedId,
		   (au.FirstName + ' ' + au.LastName) As ApprovedBy,
		   cl.ApprovedDate,
		   cr.CancellationSubReasonId,
		   ccr.CancellationSubReason,
		   m.MatterSubStatusId,
			m.MatterStatusCodeId,
			m.MatterStatusId,
			m.IsDeleted As IsMatterDeleted,
			ms.MatterStatus,
			msc.MatterStatusCode,
			mss.MatterSubStatus,
			cr.AgencyName,
			cr.AttorneyName,
			cr.AttorneyAddress,
			cr.AttorneyCity,
			cr.AttorneyState,
			cr.AttorneyZipCode,
			cr.AttorneyPhone,
			cr.AttorneyEmail,
			ad.DeliveryAddress,
			ad.DeliveryCity,
			ad.DeliveryState,
			ad.DeliveryZip,
			ad.DeliveryPhone,
			ad.DeliveryFax,
			ad.DeliveryEmail,
			ad.PayableTo,
			isnull(ad.DeliveryFee, 15) As DeliveryFee,
			ad.DeliveryMethod,
			ref.RegisterId,
			ref.EntryTypeId,
			(r.Amount*-1) As Amount,
			r.Description
	FROM 
		tblCancellation cl inner join
		tblMatter m ON m.MatterId = cl.MatterId inner join
		tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId inner join
		tblMatterStatusCode msc ON msc.MatterStatusCodeId = m.MatterStatusCodeId inner join
		tblMatterSubStatus mss ON mss.MatterSubStatusId = m.MatterSubStatusId inner join
		tblClient c ON c.ClientId = cl.ClientId left join
		tblCancellationReasonSummary cr ON cr.MatterId = cl.MatterId left join
		tblClientCancellationSubReason ccr ON ccr.CancellationSubReasonId = cr.CancellationSubReasonId left join
		tblAccount_DeliveryInfo ad ON ad.MatterId = cl.MatterId left join
		tblUser au ON au.UserId = cl.ApprovedBy left join
		tblCancellation_RefundInfo ref ON ref.MatterId = cl.MatterId left join
		tblRegister r ON r.RegisterId = ref.RegisterId
	WHERE cl.MatterId = @MatterId
	
END

GO

