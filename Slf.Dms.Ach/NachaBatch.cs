using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaBatch.
	/// </summary>
	public class NachaBatch
	{
        List<NachaRecord> _entries = new List<NachaRecord>();
		int _batchNumber;

		NachaFile _file;

		int _entryCount;
		long _entryAccountHash;
		double _debitTotal;
		double _creditTotal;

		bool _isEnded = false;

		public int EntryCount
		{
			get { return _entryCount; }
		}

		public long EntryAccountHash
		{
			get { return _entryAccountHash; }
		}

		public double DebitTotal
		{
			get { return _debitTotal; }
		}

		public double CreditTotal
		{
			get { return _creditTotal; }
		}

		public bool IsEnded
		{
			get
			{
				return _isEnded;
			}
		}

		public NachaBatch(NachaFile file, int batchNumber, string routingNumber,
						  EntryClass entryClass, string entryDescription,
						  DateTime descriptiveDate, DateTime effectiveEntryDate)
		{
			_batchNumber = batchNumber;
			_file = file;

			_file.Records.Add(new NachaCompanyBatchHeaderRecord(_file, batchNumber, routingNumber,
																entryClass, entryDescription,
																descriptiveDate, effectiveEntryDate));
		}

		public NachaDetailRecord AddEntry(TransactionCode transactionCode,
			string routingNumber, string accountNumber, double amount,
			string individualId, string individualName)
		{
			NachaDetailRecord detail = new NachaDetailRecord(transactionCode,
															 routingNumber, accountNumber, amount,
															 individualId, individualName);

			_file.Records.Add(detail);

            detail.TraceNumber = int.Parse(individualId);
            
            _entryCount++;

            int routingNumberHash;

            if (routingNumber.Length < 9)
                routingNumber = routingNumber.PadLeft(9, '0');

            Trace.WriteLine("Adding entry... routing number: " + routingNumber);

            //if (routingNumber.Length > 8)
                routingNumberHash = int.Parse(routingNumber.Substring(0, 8));
            //else
            //    routingNumberHash = int.Parse(routingNumber);

			_entryAccountHash += routingNumberHash;

			switch (transactionCode)
			{
				case TransactionCode.AutomatedDepositToChecking:
				case TransactionCode.PrenotificationOfCheckingCreditAuthorization:
				case TransactionCode.AutomatedDepositToSavings:
				case TransactionCode.PrenotificationOfSavingsCreditAuthorization:
					_creditTotal += amount;

					break;
				case TransactionCode.AutomatedDebitFromChecking:
				case TransactionCode.PrenotificationOfCheckingDebitAuthorization:
				case TransactionCode.AutomatedDebitFromSavings:
				case TransactionCode.PrenotificationOfSavingsDebitAuthorization:
					_debitTotal += amount;

					break;
			}

			return detail;
		}

		public NachaCompanyBatchControlRecord End()
		{
			NachaCompanyBatchControlRecord control = new NachaCompanyBatchControlRecord(_entryCount, _entryAccountHash,
																						_debitTotal, _creditTotal,
																						_file.Origin, _file.Destination,
																						_batchNumber);
			_file.Records.Add(control);
			
			_isEnded = true;

			return control;
		}
	}
}
