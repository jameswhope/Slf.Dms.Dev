
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_LeadSourceID default 0 for LeadSourceID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_LanguageID default 0 for LanguageID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_DeliveryID default 0 for DeliveryID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_RepID default 0 for RepID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_StatusID default 0 for StatusID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_ConcernsID default 0 for ConcernsID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_BehindID default 0 for BehindID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_TimeZoneID default 0 for TimeZoneID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_CompanyID default 0 for CompanyID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_StateID default 0 for StateID
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_Created default getdate() for Created
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_LastModified default getdate() for LastModified
alter table tblleadapplicant with nocheck add constraint DF_tblLeadApplicant_DOB default '1/1/1900' for DOB
 