if not exists(Select ReasonId from  tblDialerCallReasonType Where reasonid = 2 )
insert into tblDialerCallReasonType(ReasonId, Description, Active, Priority, DefaultExpiration, WorkGroupQueueId, PhoneTypeId, GetClientsSP)
Values(2, 'NonDeposit', 1, 2, 1440, 3, 46, 'stp_Dialer_GetNextClient4NonDepositQueue')
