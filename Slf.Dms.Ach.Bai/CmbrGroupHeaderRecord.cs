using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrGroupHeaderRecord : CmbrRecord
    {
        public CmbrGroupHeaderRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _ultimateReceiverIdentification;   //Alphanumeric
        private string _originatorIdentification; //Alphanumeric
        private string _groupStatus;
        private string _asOfDate;   //YYMMDD
        private string _asOfTime;   //24 hr time - 9999 can be used for End of Day
        private string _currencyCode;  //default is USD
        private string _asOfDateModifier; //reference only

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string UltimateReceiverIdentification
        {
            get
            {
                return _ultimateReceiverIdentification;
            }
            set
            {
                _ultimateReceiverIdentification = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string OriginatorIdentification
        {
            get
            {
                return _originatorIdentification;
            }
            set
            {
                _originatorIdentification = value;
            }
        }

        [CmbrRecordProperty(3)]
        public string GroupStatus
        {
            get
            {
                return _groupStatus;
            }
            set
            {
                _groupStatus = value;
            }
        }

        [CmbrRecordProperty(4)]
        public string AsOfDate
        {
            get
            {
                return _asOfDate;
            }
            set
            {
                _asOfDate = value;
            }
        }

        [CmbrRecordProperty(5)]
        public string AsOfTime
        {
            get
            {
                return _asOfTime;
            }
            set
            {
                _asOfTime = value;
            }
        }

        [CmbrRecordProperty(6)]
        public string CurrencyCode
        {
            get
            {
                if (string.IsNullOrEmpty(_currencyCode) == true )
                {
                    return "USD";
                }
                else
                {
                    return _currencyCode;
                }
            }
            set
            {
                _currencyCode = value;
            }
        }

        [CmbrRecordProperty(7)]
        public string AsOfDateModifier
        {
            get
            {
                return _asOfDateModifier;
            }
            set
            {
                _asOfDateModifier = value;
            }
        }

        #endregion

        #region Public Methods

        #endregion

        #region Private Methods

        #endregion
    }

}
