 --Disable Triggers
 DISABLE TRIGGER trg_tblClient_WooleryClientUpdate ON DMS..tblClient
DISABLE TRIGGER trg_tblClient_WooleryClientInsert ON DMS..tblClient

DISABLE TRIGGER trg_tblClientBankAccount_WooleryClientInsert ON DMS..tblClientBankAccount
DISABLE TRIGGER trg_tblClientBankAccount_WooleryClientUpdate ON DMS..tblClientBankAccount

DISABLE TRIGGER trg_tblClientDepositDay_WooleryClientInsert ON DMS..tblClientDepositDay
DISABLE TRIGGER trg_tblClientDepositDay_WooleryClientUpdate ON DMS..tblClientDepositDay

DISABLE TRIGGER trg_tblDepositRuleACH_WooleryClientInsert ON DMS..tblDepositRuleAch;
DISABLE TRIGGER trg_tblDepositRuleACH_WooleryClientUpdate ON DMS..tblDepositRuleAch;

DISABLE TRIGGER trg_tblNachaRegister2_WooleryRecordInsert ON DMS..tblNachaRegister2;
DISABLE TRIGGER trg_tblNachaRegister2_WooleryRecordUpdate ON DMS..tblNachaRegister2;

DISABLE TRIGGER trg_tblRegister_WooleryRecordUpdate ON DMS..tblRegister;

DISABLE TRIGGER trg_tblRegisterPayment_WooleryRecordInsert ON DMS..tblRegisterPayment;

DISABLE TRIGGER trg_tblRegisterPaymentDeposit_WooleryRecordInsert ON DMS..tblRegisterPaymentDeposit;

--Enable Triggers
ENABLE TRIGGER trg_tblClient_WooleryClientUpdate ON DMS..tblClient;
ENABLE TRIGGER trg_tblClient_WooleryClientInsert ON DMS..tblClient;

ENABLE TRIGGER trg_tblClientBankAccount_WooleryClientInsert ON DMS..tblClientBankAccount;
ENABLE TRIGGER trg_tblClientBankAccount_WooleryClientUpdate ON DMS..tblClientBankAccount;

ENABLE TRIGGER trg_tblClientDepositDay_WooleryClientInsert ON DMS..tblClientDepositDay;
ENABLE TRIGGER trg_tblClientDepositDay_WooleryClientUpdate ON DMS..tblClientDepositDay;

ENABLE TRIGGER trg_tblDepositRuleACH_WooleryClientInsert ON DMS..tblDepositRuleAch;
ENABLE TRIGGER trg_tblDepositRuleACH_WooleryClientUpdate ON DMS..tblDepositRuleAch;

ENABLE TRIGGER trg_tblNachaRegister2_WooleryRecordInsert ON DMS..tblNachaRegister2;
ENABLE TRIGGER trg_tblNachaRegister2_WooleryRecordUpdate ON DMS..tblNachaRegister2;

ENABLE TRIGGER trg_tblRegister_WooleryRecordUpdate ON DMS..tblRegister;

ENABLE TRIGGER trg_tblRegisterPayment_WooleryRecordInsert ON DMS..tblRegisterPayment;

ENABLE TRIGGER trg_tblRegisterPaymentDeposit_WooleryRecordInsert ON DMS..tblRegisterPaymentDeposit