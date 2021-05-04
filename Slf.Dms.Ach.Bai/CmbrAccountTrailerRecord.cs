using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrAccountTrailerRecord: CmbrRecord
    {
        public CmbrAccountTrailerRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _accountControlTotal;
        private string _numberOfRecords;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string AccountControlTotal
        {
            get
            {
                return _accountControlTotal;
            }
            set
            {
                _accountControlTotal = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string NumberOfRecords
        {
            get
            {
                return _numberOfRecords;
            }
            set
            {
                _numberOfRecords = value;
            }
        }

        #endregion

        #region Public Methods

        #endregion

        #region Private Methods

        #endregion
    }

}
