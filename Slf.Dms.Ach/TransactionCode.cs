using System;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for TransactionCode.
	/// </summary>
	public enum TransactionCode
	{
		AutomatedDepositToChecking = 22,
		PrenotificationOfCheckingCreditAuthorization = 23,
		AutomatedDebitFromChecking = 27,
		PrenotificationOfCheckingDebitAuthorization = 28,
		AutomatedDepositToSavings = 32,
		PrenotificationOfSavingsCreditAuthorization = 33,
		AutomatedDebitFromSavings = 37,
		PrenotificationOfSavingsDebitAuthorization = 38
	}
}
