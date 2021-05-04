update tblleadcalculator set
reoccurringdepositday = 30
where reoccurringdepositday = 31

GO

Insert into tblLeadDeposits(LeadApplicantId, DepositDay, DepositAmount, Created, CreatedBy, LastModified, LastModifiedBy)
select LeadApplicantId, isnull(ReOccurringDepositDay,1), Isnull(DepositCommittment,0.00), getdate(), 785, getdate(), 785 
from tblleadCalculator 
where leadapplicantId not in (Select leadapplicantid from tblLeadDeposits)

GO