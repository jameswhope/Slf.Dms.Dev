using System;
using System.Collections.Generic;
using System.Text;

namespace Slf.Dms.Ach
{
    class CmbrFileElement : CmbrElement
    {
        public CmbrFileElement()
            : base()
        {
            //new file element
        }

        #region Enums & Structures

        private List<CmbrGroupElement> _groups = new List<CmbrGroupElement>();

        #endregion

        #region Class Level Variables

        private CmbrFileHeaderRecord _header = null;
        private CmbrFileTrailerRecord _footer = null;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        public List<CmbrGroupElement> Groups
        {
            get
            {
                return _groups;
            }
            //set
            //{
            //    _groups = value;
            //}
        }

        public CmbrFileHeaderRecord Header
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

        public CmbrFileTrailerRecord Footer
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
            recordList.Add(this.Header);

            foreach (CmbrGroupElement group in _groups)
            {
                group.GetRecordsInternal(recordList);
            }

            recordList.Add(this.Footer);
        }

        #endregion

    }
}//End namespace
