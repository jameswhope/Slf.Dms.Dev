using System;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaCompanyBatchHeaderRecord.
	/// </summary>
	public class NachaCompanyBatchHeaderRecord : NachaRecord
	{
		string _serviceClassCode;
		string _companyName;
		string _discretionaryData;
		string _companyIdentification;
		EntryClass _entryClass;
		string _entryDescription;
		DateTime _descriptiveDate;
		DateTime _effectiveEntryDate;
		string _reserved;
		string _originatorStatusCode;
		string _routingNumber;
		int _batchNumber;

		public string ServiceClassCode
		{
			get
			{
				return _serviceClassCode;
			}
			set
			{
				_serviceClassCode = value;
			}
		}

		public string CompanyName
		{
			get { return _companyName; }
			set { _companyName = value; }
		}

		public string DiscretionaryData
		{
			get { return _discretionaryData; }
			set { _discretionaryData = value; }
		}

		public string CompanyIdentification
		{
			get { return _companyIdentification; }
			set { _companyIdentification = value; }
		}

		public EntryClass EntryClass
		{
			get { return _entryClass; }
			set { _entryClass = value; }
		}

		public string EntryDescription
		{
			get { return _entryDescription; }
			set { _entryDescription = value; }
		}

		public DateTime DescriptiveDate
		{
			get { return _descriptiveDate; }
			set { _descriptiveDate = value; }
		}

		public DateTime EffectiveEntryDate
		{
			get { return _effectiveEntryDate; }
			set { _effectiveEntryDate = value; }
		}

		public string Reserved
		{
			get { return _reserved; }
			set { _reserved = value; }
		}

		public string OriginatorStatusCode
		{
			get { return _originatorStatusCode; }
			set { _originatorStatusCode = value; }
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

		public NachaCompanyBatchHeaderRecord(NachaFile file, int batchNumber, string routingNumber,
			EntryClass entryClass, string entryDescription,
			DateTime descriptiveDate, DateTime effectiveEntryDate) :
			base(RecordType.CompanyBatchHeader)
		{
			ServiceClassCode = "200";
            if (file.FileType == "CCD")
            {
                CompanyName = file.CCDCompanyName;
                CompanyIdentification = file.CCDCompanyID;
            }
            else
            {
                CompanyName = file.OriginName;
                CompanyIdentification = file.Origin;
            }

			EntryClass = entryClass;
			EntryDescription = entryDescription;
			DescriptiveDate = descriptiveDate;
			EffectiveEntryDate = effectiveEntryDate;
			OriginatorStatusCode = "1";
			RoutingNumber = routingNumber;
			BatchNumber = batchNumber;
		}

		public override void Write(System.IO.TextWriter writer)
		{
			writer.Write(((int)RecordType).ToString());
			
			StringHelper.Pad(writer, ServiceClassCode, 3);
			writer.Write(ServiceClassCode);

            StringHelper.ForceTo(writer, CompanyName, 16);

            StringHelper.ForceTo(writer, DiscretionaryData, 20);

            StringHelper.ForceTo(writer, CompanyIdentification, 10);

			switch (EntryClass)
			{
				case EntryClass.PreAuthorizedPaymentOrDeposit:
					writer.Write("PPD");

					break;
				case EntryClass.CashConcentrationDebit:
					writer.Write("CCD");

					break;
			}

            StringHelper.ForceTo(writer, EntryDescription, 10);

			writer.Write(DescriptiveDate.ToString("yyMMdd"));

			writer.Write(EffectiveEntryDate.ToString("yyMMdd"));

			StringHelper.Pad(writer, Reserved, 3);
			writer.Write(Reserved);

			StringHelper.Pad(writer, OriginatorStatusCode, 1);
			writer.Write(OriginatorStatusCode);

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