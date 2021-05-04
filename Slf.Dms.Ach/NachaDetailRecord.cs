using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaDetailRecord.
	/// </summary>
	public class NachaDetailRecord : NachaRecord
	{
		TransactionCode _transactionCode;
		string _routingNumber;
		//string _routingCheckDigit;
		string _accountNumber;
		double _amount;
		string _individualId;
		string _individualName;
		string _discretionaryData;
		bool _hasAddenda;
		int _traceNumber;

		public TransactionCode TransactionCode
		{
			get { return _transactionCode; }
			set { _transactionCode = value; }
		}

		public string RoutingNumber
		{
			get { return _routingNumber; }
			set { _routingNumber = value; }
		}

		public string AccountNumber
		{
			get { return _accountNumber; }
			set { _accountNumber = value; }
		}

		public double Amount
		{
			get { return _amount; }
			set { _amount = value; }
		}

		public string IndividualId
		{
			get { return _individualId; }
			set { _individualId = value; }
		}

		public string IndividualName
		{
			get { return _individualName; }
			set { _individualName = value; }
		}

		public string DiscretionaryData
		{
			get { return _discretionaryData; }
			set { _discretionaryData = value; }
		}

		public bool HasAddenda
		{
			get { return _hasAddenda; }
			set { _hasAddenda = value; }
		}

		public int TraceNumber
		{
			get { return _traceNumber; }
			set { _traceNumber = value; }
		}

		public NachaDetailRecord(TransactionCode transactionCode,
			string routingNumber, string accountNumber, double amount,
			string individualId, string individualName) :
			base(RecordType.EntryDetail)
		{
			TransactionCode = transactionCode;
			RoutingNumber = routingNumber;
			AccountNumber = accountNumber;
			Amount = amount;
			IndividualId = individualId;
			IndividualName = individualName;
			HasAddenda = false;
		}

		public override void Write(TextWriter writer)
		{
			writer.Write(((int)RecordType).ToString());
			
			writer.Write(((int)TransactionCode).ToString());

            if (RoutingNumber != null && RoutingNumber.Length > 9)
            {
                writer.Write(RoutingNumber.Substring(RoutingNumber.Length - 9, 9));
            }
            else
            {
                StringHelper.Pad(writer, RoutingNumber, 9, '0');
                writer.Write(RoutingNumber);
            }

            StringHelper.ForceTo(writer, AccountNumber, 17);

			string amount = (Amount * 100).ToString("0");
			StringHelper.Pad(writer, amount, 10, '0');
			writer.Write(amount);

			StringHelper.Pad(writer, IndividualId, 15);
			writer.Write(IndividualId);

			StringHelper.ForceTo(writer, IndividualName, 22);

			StringHelper.Pad(writer, DiscretionaryData, 2);
			writer.Write(DiscretionaryData);

			if (HasAddenda)
				writer.Write('1');
			else
				writer.Write('0');

			string traceNumber = (TraceNumber != 0) ? TraceNumber.ToString() : null;

			StringHelper.Pad(writer, traceNumber, 15, '0');
			writer.Write(traceNumber);
            writer.Write("\r\n");
		}
	}
}
