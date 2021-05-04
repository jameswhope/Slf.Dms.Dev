using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrAccountElement : CmbrElement
    {
        public CmbrAccountElement()
            : base()
        {
            //new account element
        }

        #region Enums & Structures

        private List<CmbrTransactionDetailRecord> _transactionDetails = new List<CmbrTransactionDetailRecord>();

        #endregion

        #region Class Level Variables

        private CmbrAccountIdentifierRecord _header = null;
        private CmbrAccountTrailerRecord _footer = null;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        public List<CmbrTransactionDetailRecord> TransactionDetails
        {
            get
            {
                return _transactionDetails;
            }
            //set
            //{
            //    _transactionDetails = value;
            //}
        }

        public CmbrAccountIdentifierRecord Header
        {
            get
            {
                return _header;
            }
            set
            {
                _header = value;
            }
        }

        public CmbrAccountTrailerRecord Footer
        {
            get
            {
                return _footer;
            }
            set
            {
                _footer = value;
            }
        }

        #endregion

        #region Public Methods

        #endregion

        #region Private Methods

        internal override void GetRecordsInternal(List<CmbrRecord> recordList)
        {
            recordList.Add(Header);

            foreach (CmbrTransactionDetailRecord trans in _transactionDetails)
            {
                recordList.Add(trans);
            }

            recordList.Add(Footer);
        }

        #endregion

    }

}
