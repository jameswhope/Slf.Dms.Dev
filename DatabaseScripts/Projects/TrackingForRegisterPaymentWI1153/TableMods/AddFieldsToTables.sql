 IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'VoidDate')
	alter table tblRegisterPayment add  [VoidDate] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'BounceDate')
	alter table tblRegisterPayment add  [BounceDate] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'Created')
	alter table tblRegisterPayment add  [Created] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'CreatedBy')
	alter table tblRegisterPayment add  [CreatedBy] int null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'Modified')
	alter table tblRegisterPayment add  [Modified] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPayment' and COLUMN_NAME = 'ModifiedBy')
	alter table tblRegisterPayment add  [ModifiedBy] int null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'VoidDate')
	alter table tblRegisterPaymentDeposit add  [VoidDate] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'BounceDate')
	alter table tblRegisterPaymentDeposit add  [BounceDate] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'Created')
	alter table tblRegisterPaymentDeposit add  [Created] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'CreatedBy')
	alter table tblRegisterPaymentDeposit add  [CreatedBy] int null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'Modified')
	alter table tblRegisterPaymentDeposit add  [Modified] datetime null 
IF not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='tblRegisterPaymentDeposit' and COLUMN_NAME = 'ModifiedBy')
	alter table tblRegisterPaymentDeposit add  [ModifiedBy] int null 