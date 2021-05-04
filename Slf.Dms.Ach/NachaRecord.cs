using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaRecord.
	/// </summary>
	public abstract class NachaRecord
	{
		RecordType _recordType;

		public RecordType RecordType
		{
			get
			{
				return _recordType;
			}
			set
			{
				_recordType = value;
			}
		}

		public NachaRecord(RecordType recordType)
		{
			_recordType = recordType;
		}

		public abstract void Write(TextWriter writer);
	}
}