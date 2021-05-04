using System;
using System.Collections.Generic;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaFile.
	/// </summary>
	public class NachaFile
	{
		string _destination;
		string _destinationName;
		string _origin;
		string _originName;
        string _CCDCompanyName;
        string _CCDCompanyID;
        string _FileType;

        List<NachaRecord> _records = new List<NachaRecord>();
        List<NachaBatch> _batches = new List<NachaBatch>();

		int _batchNumber = 0;

        public List<NachaRecord> Records
		{
			get
			{
				return _records;
			}
		}

		public string Destination
		{
			get
			{
				return _destination;
			}
		}

		public string DestinationName
		{
			get
			{
				return _destinationName;
			}
		}

		public string Origin
		{
			get
			{
				return _origin;
			}
		}

		public string OriginName
		{
			get
			{
				return _originName;
			}
		}

        public string CCDCompanyName
        {
            get
            {
                return _CCDCompanyName;
            }
        }

        public string CCDCompanyID
        {
            get
            {
                return _CCDCompanyID;
            }
        }

        public string FileType
        {
            get
            {
                return _FileType;
            }
        }

		public NachaFile(string destination, string destinationName, string origin, string originName, string CCDCompanyName, string CCDCompanyID, string FileType)
		{
			_destination = destination;
			_destinationName = destinationName;
			_origin = origin;
			_originName = originName;
            _CCDCompanyName = CCDCompanyName;
            _CCDCompanyID = CCDCompanyID;
            _FileType = FileType;

			_records.Add(new NachaFileHeaderRecord(_destination, _destinationName, _origin, _originName, CCDCompanyName, CCDCompanyID, FileType));
		}

		public NachaBatch StartBatch(EntryClass entryClass, string entryDescription, string routingNumber,
									 DateTime descriptiveDate, DateTime effectiveEntryDate)
		{
			// If there are unended batches, end them
			foreach (NachaBatch batch in _batches)
				if (!batch.IsEnded)
					batch.End();

			NachaBatch newBatch = new NachaBatch(this, ++_batchNumber, routingNumber,
								  entryClass, entryDescription, descriptiveDate, effectiveEntryDate);

			_batches.Add(newBatch);

			return newBatch;
		}

		public NachaFileControlRecord End()
		{
            // If there are unended batches, end them
            foreach (NachaBatch batch in _batches)
                if (!batch.IsEnded)
                    batch.End();
            
            int entryCount = 0;
			long entryHash = 0;
			double debitTotal = 0;
			double creditTotal = 0;

			foreach (NachaBatch batch in _batches)
			{
				entryCount += batch.EntryCount;
				entryHash += batch.EntryAccountHash;
				debitTotal += batch.DebitTotal;
				creditTotal += batch.CreditTotal;
			}

			NachaFileControlRecord control = new NachaFileControlRecord(_batches.Count, _records.Count + 1,
																		entryCount, entryHash, debitTotal, creditTotal);

			_records.Add(control);

			return control;
		}

		public void Write(TextWriter writer)
		{
			foreach (NachaRecord record in _records)
				record.Write(writer);
		}
	}
}