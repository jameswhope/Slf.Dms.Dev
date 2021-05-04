
set identity_insert tblCommRec on

if not exists (select 1 from tblCommRec where CommRecID = 29) begin

	INSERT INTO tblCommRec (
	CommRecID,
	CommRecTypeID,
	Abbreviation,
	Display,
	IsCommercial,
	IsLocked,
	IsTrust,
	Method,
	Bankname,
	RoutingNumber,
	AccountNumber,
	[Type],
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy,
	CompanyID,
	AgencyID,
	ParentCommRecID)
	VALUES (
	29,
	3,
	'Avert',
	'Avert Financial LLC (080108)',
	'True',
	'False',
	'False',
	'ACH',
	'Bank of America',
	'122400724',
	'501007287532',
	'C',
	getdate(),
	493,
	getdate(),
	493,
	null,
	null,
	17) 
	
end

set identity_insert tblCommRec off