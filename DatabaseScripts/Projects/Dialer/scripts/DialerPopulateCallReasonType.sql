delete from tblDialerCallReasonType
insert into tblDialerCallReasonType(ReasonId, Description, Active, Priority, DefaultExpiration, WorkGroupQueueId, PhoneTypeId, GetClientsSP)
Values(1, 'Settlement', 1, 1, 120, 1, 46, 'stp_Dialer_GetNextClient4SettlQueue')

insert into tblDialerCallReasonType(ReasonId, Description, Active, Priority, DefaultExpiration, WorkGroupQueueId, PhoneTypeId, GetClientsSP)
Values(2, 'CIDNonDeposit', 1, 1, 1440, 4, 46, 'stp_Dialer_GetNextClient4CIDNonDepositQueue')

