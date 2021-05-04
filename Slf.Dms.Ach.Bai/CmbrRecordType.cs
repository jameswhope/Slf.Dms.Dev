using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    public enum CmbrRecordType
    {
        FileHeader = 01,
        GroupHeader = 02,
        AccountIdentifier = 03,
        TransactionDetail = 16,
        AccountTrailer = 49,
        GroupTrailer = 98,
        FileTrailer = 99
    }
}

