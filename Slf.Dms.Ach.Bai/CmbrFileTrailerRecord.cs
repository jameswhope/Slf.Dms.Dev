using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrFileTrailerRecord: CmbrRecord
    {
        public CmbrFileTrailerRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _fileControlTotal;
        private string _numberOfGroups;
        private string _numberOfRecords;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string FileControlTotal
        {
            get
            {
                return _fileControlTotal;
            }
            set
            {
                _fileControlTotal = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string NumberOfGroups
        {
            get
            {
                return _numberOfGroups;
            }
            set
            {
                _numberOfGroups = value;
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
