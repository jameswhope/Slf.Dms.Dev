IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementMatterStatusStats')
	BEGIN
		DROP  Procedure  stp_GetSettlementMatterStatusStats
	END

GO

CREATE Procedure stp_GetSettlementMatterStatusStats
(@userid int)
AS
BEGIN
declare @IsSuper bit,@UserGroup int

select @UserGroup= UserGroupID FROM tblUser where UserID = @userid

SELECT @IsSuper = isnull(ne.IsSupervisor,0)
FROM tblNegotiationEntity AS ne 
left JOIN (SELECT NegotiationEntityID,  Name, ParentNegotiationEntityID, ParentType, UserID, Deleted, LastRefresh 
FROM tblNegotiationEntity WHERE (Type = 'group')) AS ng ON ne.ParentNegotiationEntityID = ng.NegotiationEntityID 
WHERE (ne.Type = 'Person') AND (ne.Name <> 'New Person') AND (ne.Deleted <> 1) and ne.UserID=@userid

select  mc.MatterStatusCode, count(* )[Total] 
from tblsettlements s with(nolock) 
inner join tblmatter m with(nolock) on s.matterid = m.matterid 
inner join tblmatterstatuscode  mc with(nolock) on m.matterstatuscodeid = mc.matterstatuscodeid 
where ((s.createdby= @userID OR @IsSuper = 1) OR @userGroup = 11)
group by mc.MatterStatusCode 
order by mc.MatterStatusCode 
option (fast 100)

END

GO


GRANT EXEC ON stp_GetSettlementMatterStatusStats TO PUBLIC

GO


