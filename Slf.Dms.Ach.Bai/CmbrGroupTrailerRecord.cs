using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrGroupTrailerRecord: CmbrRecord
    {
        public CmbrGroupTrailerRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _groupControlTotal;
        private string _numberOfAccounts;
        private string _numberOfRecords;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string GroupControlTotal
        {
            get
            {
                return _groupControlTotal;
            }
            set
            {
                _groupControlTotal = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string NumberOfAccounts
        {
            get
            {
                return _numberOfAccounts;
            }
            set
            {
                _numberOfAccounts = value;
            }
        }

        [CmbrRecordProperty(3)]
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
