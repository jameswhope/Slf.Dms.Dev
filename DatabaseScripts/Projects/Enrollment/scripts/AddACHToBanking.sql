if not exists (select * from syscolumns
  where id=object_id('tblLeadBanks') and name='ACH')
    alter table tblLeadBanks add ACH bit 