using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaFileHeaderRecord.
	/// </summary>
	public class NachaFileHeaderRecord : NachaRecord
	{
		string _priorityCode;
		string _immediateDestination;
		string _immediateOrigin;
		DateTime _transmissionDate;
		string _fileIdModifier;
		int _recordSize;
		string _blockingFactor;
		string _formatCode;
		string _destinationName;
		string _originName;
		string _referenceCode;
        string _CCDCompanyName;
        string _CCDCompanyID;
        string _FileType;

		public string PriorityCode
		{
			get
			{
				return _priorityCode;
			}
			set
			{
				_priorityCode = value;
			}
		}

		public string ImmediateDestination
		{
			get
			{
				return _immediateDestination;
			}
			set
			{
				_immediateDestination = value;
			}
		}

		public string ImmediateOrigin
		{
			get
			{
				return _immediateOrigin;
			}
			set
			{
				_immediateOrigin = value;
			}
		}

		public DateTime TransmissionDate
		{
			get
			{
				return _transmissionDate;
			}
			set
			{
				_transmissionDate = value;
			}
		}

		public string FileIdModifier
		{
			get
			{
				return _fileIdModifier;
			}
			set
			{
				_fileIdModifier = value;
			}
		}

		public int RecordSize
		{
			get
			{
				return _recordSize;
			}
			set
			{
				_recordSize = value;
			}
		}

		public string BlockingFactor
		{
			get
			{
				return _blockingFactor;
			}
			set
			{
				_blockingFactor = value;
			}
		}

		public string FormatCode
		{
			get
			{
				return _formatCode;
			}
			set
			{
				_formatCode = value;
			}
		}

		public string DestinationName
		{
			get
			{
				return _destinationName;
			}
			set
			{
				_destinationName = value;
			}
		}

		public string OriginName
		{
			get
			{
				return _originName;
			}
			set
			{
				_originName = value;
			}
		}

		public string ReferenceCode
		{
			get
			{
				return _referenceCode;
			}
			set
			{
				_referenceCode = value;
			}
		}

        public string CCDCompanyName
        {
            get
            {
                return _CCDCompanyName;
            }
            set
            {
                _CCDCompanyName = value;
            }
        }

        public string CCDCompanyID
        {
            get
            {
                return _CCDCompanyID;
            }
            set
            {
                _CCDCompanyID = value;
            }
        }

        public string FileType
        {
            get
            {
                return _FileType;
            }
            set
            {
                _FileType = value;
            }
        }

		public NachaFileHeaderRecord(string destination, string destinationCompany, string origin, string originCompany, string ccdCompanyName, string ccdCompanyID, string sFileType) :
			base(RecordType.FileHeader)
		{
			PriorityCode = "01";
			ImmediateDestination = destination;
			ImmediateOrigin = origin;
			TransmissionDate = DateTime.Now;
			FileIdModifier = "A";
			RecordSize = 94;
			BlockingFactor = "10";
			FormatCode = "1";
			DestinationName = destinationCompany;
			OriginName = originCompany;
            CCDCompanyName = ccdCompanyName;
            CCDCompanyID = ccdCompanyID;
            FileType = sFileType;
		}

		public override void Write(TextWriter writer)
		{
			writer.Write(((int)RecordType).ToString());
			
			StringHelper.Pad(writer, PriorityCode, 2, '0');
			writer.Write(PriorityCode);
			
			StringHelper.Pad(writer, ImmediateDestination, 10);
			writer.Write(ImmediateDestination);

			StringHelper.Pad(writer, ImmediateOrigin, 10);
			writer.Write(ImmediateOrigin);

			writer.Write(TransmissionDate.ToString("yyMMdd"));

			writer.Write(TransmissionDate.ToString("HHmm"));

			StringHelper.Pad(writer, FileIdModifier, 1);
			writer.Write(FileIdModifier);

			string recordSize = RecordSize.ToString();
			StringHelper.Pad(writer, recordSize, 3, '0');
			writer.Write(recordSize);

			StringHelper.Pad(writer, BlockingFactor, 2);
			writer.Write(BlockingFactor);

			StringHelper.Pad(writer, FormatCode, 1);
			writer.Write(FormatCode);

			writer.Write(DestinationName);
            StringHelper.Pad(writer, DestinationName, 23);

			writer.Write(OriginName);
            StringHelper.Pad(writer, OriginName, 23);

			StringHelper.Pad(writer, ReferenceCode, 8);
			writer.Write(ReferenceCode);
            writer.Write("\r\n");
        }
	}
}