IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTULoanType')
 BEGIN
	IF col_length('tblTULoanType', 'Exclude') is null
		Alter table tblTULoanType Add Exclude bit default 0
 END
 
 GO
 
 Update tblTULoanType Set Exclude = 1 Where TypeCode in ('AL','AU','AX','BC','BL','BU','CB','CE','CI','CO','CP','CR','CV','CY','DR','DS','EM','FC','FD','FI','FL','FM','FR','FT','GA','GE','GF','GG','GO','GS','GU','GV','HE','IE','LE','LI','LN','LS','MB','NT','PS','RD','RE','RL','RM','SA','SC','SE','SF','SI','SM','SR','ST','SU','SX','TS','UC','VM','WT')
