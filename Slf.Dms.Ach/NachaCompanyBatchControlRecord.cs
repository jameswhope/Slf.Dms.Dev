using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaCompanyBatchControlRecord.
	/// </summary>
	public class NachaCompanyBatchControlRecord : NachaRecord
	{
		string _serviceClassCode;
		int _entryCount;
		long _entryHash;
		double _debitTotal;
		double _creditTotal;
		string _companyId;
		string _reserved1;
		string _reserved2;
		string _routingNumber;
		int _batchNumber;

		public string ServiceClassCode
		{
			get { return _serviceClassCode; }
			set { _serviceClassCode = value; }
		}

		public int EntryCount
		{
			get { return _entryCount; }
			set { _entryCount = value; }
		}

		public long EntryHash
		{
			get { return _entryHash; }
			set { _entryHash = value; }
		}

		public double DebitTotal
		{
			get { return _debitTotal; }
			set { _debitTotal = value; }
		}

		public double CreditTotal
		{
			get { return _creditTotal; }
			set { _creditTotal = value; }
		}

		public string CompanyId
		{
			get { return _companyId; }
			set { _companyId = value; }
		}

		public string Reserved1
		{
			get { return _reserved1; }
			set { _reserved1 = value; }
		}

		public string Reserved2
		{
			get { return _reserved2; }
			set { _reserved2 = value; }
		}

		public string RoutingNumber
		{
			get { return _routingNumber; }
			set { _routingNumber = value; }
		}

		public int BatchNumber
		{
			get { return _batchNumber; }
			set { _batchNumber = value; }
		}

		public NachaCompanyBatchControlRecord(int entryCount, long entryHash,
											  double debitTotal, double creditTotal,
											  string companyId, string routingNumber,
											  int batchNumber) :
			base(RecordType.CompanyBatchControl)
		{
			ServiceClassCode = "200";
			EntryCount = entryCount;
			EntryHash = entryHash;
			DebitTotal = debitTotal;
			CreditTotal = creditTotal;
			CompanyId = companyId;
			RoutingNumber = routingNumber;
			BatchNumber = batchNumber;
		}

		public override void Write(TextWriter writer)
		{
			writer.Write(((int)RecordType).ToString());
			
			StringHelper.Pad(writer, ServiceClassCode, 3);
			writer.Write(ServiceClassCode);
			
			string entryCount = EntryCount.ToString();
			StringHelper.Pad(writer, entryCount, 6, '0');
			writer.Write(entryCount);

			string entryHash = EntryHash.ToString();

			if (entryHash.Length > 10)
				entryHash = entryHash.Substring(entryHash.Length - 10, 10);
			StringHelper.Pad(writer, entryHash, 10, '0');
			writer.Write(entryHash);

			string debitTotal = (DebitTotal * 100).ToString("0");
			StringHelper.Pad(writer, debitTotal, 12, '0');
			writer.Write(debitTotal);

			string creditTotal = (CreditTotal * 100).ToString("0");
			StringHelper.Pad(writer, creditTotal, 12, '0');
			writer.Write(creditTotal);

			writer.Write(CompanyId);
            StringHelper.Pad(writer, CompanyId, 10);

			StringHelper.Pad(writer, Reserved1, 19);
			writer.Write(Reserved1);

			StringHelper.Pad(writer, Reserved2, 6);
			writer.Write(Reserved2);

			StringHelper.Pad(writer, RoutingNumber, 8);
            if (RoutingNumber != null && RoutingNumber.Length > 8)
			    writer.Write(RoutingNumber.Substring(0, 8));
            else
                writer.Write(RoutingNumber);
		
			string batchNumber = BatchNumber.ToString();
			StringHelper.Pad(writer, batchNumber, 7, '0');
			writer.Write(batchNumber);
            writer.Write("\r\n");
        }
	}
}
