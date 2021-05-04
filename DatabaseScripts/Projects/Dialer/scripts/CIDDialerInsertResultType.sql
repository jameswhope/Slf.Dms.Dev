delete from tblLeadDialerCallResultType

--Answer
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(1, 1, 60, 2, NULL,  1, '~/images/16x16_phone4.png', 1)

--No Message Left
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(2, 2, 60, 0, NULL,  2, '~/images/nomessageleft.gif', 4)

--Left Message
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(3, 3, 60, 13, NULL,  2, '~/images/mail.gif', 3)

--No Answer
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(4, 4, 60, 15, NULL, 2, '~/images/16x16_phone_noanswer.png', 2)

--Bad Number
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(5, 8, 60, 14, 26, 2, '~/images/16x16_phone_badnumber.png', 5)

--Disconnected Number
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(6, 9, 60, 14, 27, 2, '~/images/DisconnectedNumber.gif', 6)

--Busy NUmber
Insert Into tblLeadDialerCallResultType(LeadResultTypeId, ResultTypeId, Expiration, LeadStatusId, LeadReasonId, AppointmentStatusId, IconPath, TabOrder)
Values(7, 5, 60, 0, NULL, 2, '~/images/phonebusy.gif', 7)




  