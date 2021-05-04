
using System;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for RecordType.
	/// </summary>
	public enum RecordType
	{
		FileHeader = 1,
		CompanyBatchHeader = 5,
		EntryDetail = 6,
		CompanyBatchControl = 8,
		FileControl = 9
	}
}