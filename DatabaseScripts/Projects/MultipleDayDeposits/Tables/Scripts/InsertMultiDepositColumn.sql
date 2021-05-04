IF NOT EXISTS  (SELECT * FROM syscolumns WHERE id=object_id('tblClient') 
AND name='MultiDeposit'
ALTER TABLE tblClient ADD 'MultiDeposit' bit 0
GO