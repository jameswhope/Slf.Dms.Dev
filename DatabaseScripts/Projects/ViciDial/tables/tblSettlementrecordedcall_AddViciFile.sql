 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementRecordedCall')
 BEGIN
	IF col_length('tblSettlementRecordedCall', 'ViciFileName') is null
		Alter table tblSettlementRecordedCall Add ViciFileName  varchar(255) null 
END
 