BEGIN
DECLARE @CommRecGroupId int

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%SEIDEMAN%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%TSLF%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%PALMER%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%TPF%'
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Lexxiom%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Lexxiom%'
		
		Update tblAgency Set
		ParentAgencyId = 852
		Where Code = 'DMSI'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code = 'Lexxiom'
		
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Avert%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Stonewall%' or Abbreviation Like '%Avert%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%AVERTLLC%'
		
		Update tblAgency Set
		ParentAgencyId = 844
		Where Code like '%DEBTRELGRP%' and Code like '%EDEBT%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Debt Choice%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%DebtChoice%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%DEBTCHOICE%'
		
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Antilla%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Antilla%'
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Global Network%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%GNUSAMI%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%GNUSAMI%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Potter%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Potter%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Slakter%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Slakter%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%SLF_STRM_1%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Lauzon%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Lauzon%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Debt Relief Foundation%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%DebtRelief%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%DEBTRELIEF%'
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Zero%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%DebtZero%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%DebtZero%'
	END

SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Allen%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%Allen%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%SmithAllen%'
	END
	
SELECT @CommRecGroupid = CommRecGroupId FROM tblCommRecGroup Where CommRecGroupName Like '%Gateway%'
IF (@CommRecGroupid is not null)
	BEGIN
		Update  tblCommRec Set
		CommRecGroupId =  @CommRecGroupid
		Where  Abbreviation Like '%TGRN%'
		
		Update tblAgency Set
		IsCommRec = 1,
		CommRecGroupId =  @CommRecGroupid
		Where Code like '%TGRN%'
				
		Update tblAgency Set
		ParentAgencyId = 854
		Where Code like '%Belmont%'
		
	END
	
Update tblUser Set
CommRecGroupid = c.CommRecGroupid
FROM tblUser u
INNER Join tblCommRec c  on u.CommRecId = c.CommRecId


END 

GO 