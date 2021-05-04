using System;
using System.IO;

namespace Slf.Dms.Ach
{
	/// <summary>
	/// Summary description for NachaFileControlRecord.
	/// </summary>
	public class NachaFileControlRecord : NachaRecord
	{
		int _batchCount;
		int _blockCount;
		int _entryCount;
		long _entryHash;
		double _debitTotal;
		double _creditTotal;
		string _reserved;

		public int BatchCount
		{
			get { return _batchCount; }
			set { _batchCount = value; }
		}

		public int BlockCount
		{
			get { return _blockCount; }
			set { _blockCount = value; }
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

		public string Reserved
		{
			get { return _reserved; }
			set { _reserved = value; }
		}

		public NachaFileControlRecord(int batchCount, int blockCount, int entryCount,
									  long entryHash, double debitTotal, double creditTotal) :
			base(RecordType.FileControl)
		{
			BatchCount = batchCount;
			BlockCount = blockCount;
			EntryCount = entryCount;
			EntryHash = entryHash;
			DebitTotal = debitTotal;
			CreditTotal = creditTotal;
		}

		public override void Write(TextWriter writer)
		{
			writer.Write(((int)RecordType).ToString());
			
			string batchCount = BatchCount.ToString();
			StringHelper.Pad(writer, batchCount, 6, '0');
			writer.Write(batchCount);
			
			string blockCount = BlockCount.ToString();
			StringHelper.Pad(writer, blockCount, 6, '0');
			writer.Write(blockCount);

			string entryCount = EntryCount.ToString();
			StringHelper.Pad(writer, entryCount, 8, '0');
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
			
			StringHelper.Pad(writer, Reserved, 39);
			writer.Write(Reserved);
            writer.Write("\r\n");
        }
	}
}