using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrGroupElement : CmbrElement
    {
        public CmbrGroupElement()
            : base()
        {
            //new group elemnet
        }

        #region Enums & Structures

        private List<CmbrAccountElement> _accounts = new List<CmbrAccountElement>();

        #endregion

        #region Class Level Variables

        private CmbrGroupHeaderRecord _header = null;
        private CmbrGroupTrailerRecord _footer = null;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        public List<CmbrAccountElement> Accounts
        {
            get
            {
                return _accounts;
            }
            //set
            //{
            //    _accounts = value;
            //}
        }

        public CmbrGroupHeaderRecord Header
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

        public CmbrGroupTrailerRecord Footer
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

            foreach (CmbrAccountElement account in _accounts)
            {
                account.GetRecordsInternal(recordList);
            }

            recordList.Add(Footer);
        }

        #endregion

    }

}
