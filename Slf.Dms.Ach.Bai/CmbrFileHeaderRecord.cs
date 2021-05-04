using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrFileHeaderRecord: CmbrRecord
    {
        public CmbrFileHeaderRecord(CmbrRecordType recordType):base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _senderIdentification;   //Alphanumeric
        private string _receiverIdentification; //Alphanumeric
        private string _fileCreationDate;   //YYMMDD
        private string _fileCreationTime;   //24 hr time - 2400
        private string _fileIdentificationNumber;
        private string _physicalRecordLength;  //if null is variable
        private string _blockSize; //if null variable
        private string _versionNumber; 

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string SenderIdentification
        {
            get
            {
                return _senderIdentification;
            }
            set
            {
                _senderIdentification = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string ReceiverIdentification
        {
            get
            {
                return _receiverIdentification;
            }
            set
            {
                _receiverIdentification = value;
            }
        }

        [CmbrRecordProperty(3)]
        public string FileCreationDate
        {
            get
            {
                return _fileCreationDate;
            }
            set
            {
                _fileCreationDate = value;
            }
        }

        [CmbrRecordProperty(4)]
        public string FileCreationTime
        {
            get
            {
                return _fileCreationTime;
            }
            set
            {
                _fileCreationTime = value;
            }
        }

        [CmbrRecordProperty(5)]
        public string FileIdentificationNumber
        {
            get
            {
                return _fileIdentificationNumber;
            }
            set
            {
                _fileIdentificationNumber = value;
            }
        }

        [CmbrRecordProperty(6)]
        public string PhysicalRecordLength
        {
            get
            {
                return _physicalRecordLength;
            }
            set
            {
                _physicalRecordLength = value;
            }
        }

        [CmbrRecordProperty(7)]
        public string BlockSize
        {
            get
            {
                return _blockSize;
            }
            set
            {
                _blockSize = value;
            }
        }

        [CmbrRecordProperty(8)]
        public string VersionNumber
        {
            get
            {
                return _versionNumber;
            }
            set
            {
                _versionNumber = value;
            }
        }

        #endregion

        #region Public Methods

        #endregion

        #region Private Methods

        #endregion
    }

}
