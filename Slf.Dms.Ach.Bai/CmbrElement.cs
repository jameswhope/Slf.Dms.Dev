using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    public abstract class CmbrElement
    {
        public List<CmbrRecord> GetRecords()
        {
            List<CmbrRecord> recordList = new List<CmbrRecord>();

            GetRecordsInternal(recordList);

            return recordList;
        }

        internal abstract void GetRecordsInternal(List<CmbrRecord> recordList);
    }
}
