using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrTransactionDetailRecord: CmbrRecord
    {
        public CmbrTransactionDetailRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _typeCode;
        private string _amount;
        private string _fundsType;
        private string _bankReferenceNumber;
        private string _customerReferenceNumber;
        private string _text;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string TypeCode
        {
            get
            {
                return _typeCode;
            }
            set
            {
                _typeCode = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string Amount
        {
            get
            {
                return _amount;
            }
            set
            {
                _amount = value;
            }
        }

        [CmbrRecordProperty(3)]
        public string FundsType
        {
            get
            {
                return _fundsType;
            }
            set
            {
                _fundsType = value;
            }
        }

        [CmbrRecordProperty(4)]
        public string BankReferenceNumber
        {
            get
            {
                return _bankReferenceNumber;
            }
            set
            {
                _bankReferenceNumber = value;
            }
        }

        [CmbrRecordProperty(5)]
        public string CustomerReferenceNumber
        {
            get
            {
                return _customerReferenceNumber;
            }
            set
            {
                _customerReferenceNumber = value;
            }
        }

        [CmbrRecordProperty(6)]
        public string Text
        {
            get
            {
                return _text.Replace("`", ",");
            }
            set
            {
                _text = value;
            }
        }

        #endregion

        #region Public Methods

        #endregion

        #region Private Methods

        #endregion
    }

}
