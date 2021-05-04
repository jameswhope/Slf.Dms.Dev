/*Add effective dates and companyid columns to tblTrust */
ALTER TABLE tblTrust
ADD EffectiveStartDate datetime,
ADD EffectiveEndDate datetime,
ADD CompanyIDs nvarchar(50)