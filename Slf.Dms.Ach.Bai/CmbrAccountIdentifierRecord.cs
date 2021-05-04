using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.IO;
using System.Diagnostics;

namespace Slf.Dms.Ach
{
    class CmbrAccountIdentifierRecord: CmbrRecord
    {
        public CmbrAccountIdentifierRecord(CmbrRecordType recordType): base(recordType)
        {
            SetupRecordProperties();
        }

        #region Enums & Structures

        #endregion

        #region Class Level Variables

        private string _customerAccountNumber;   //Alphanumeric
        private string _currencyCode; //default is group currency code
        private List<string> _typeCode = new List<string>();
        private List<string> _amount = new List<string>();
        private List<string> _itemCount = new List<string>();
        private List<string> _fundsType = new List<string>();  

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        [CmbrRecordProperty(1)]
        public string CustomerAccountNumber
        {
            get
            {
                return _customerAccountNumber;
            }
            set
            {
                _customerAccountNumber = value;
            }
        }

        [CmbrRecordProperty(2)]
        public string CurrencyCode
        {
            get
            {
                return _currencyCode;
            }
            set
            {
                _currencyCode = value;
            }
        }

        [CmbrRecordProperty(3)]
        public List<string> TypeCode
        {
            get
            {
                return _typeCode;
            }
            //set
            //{
            //    _typeCode = value;
            //}
        }

        [CmbrRecordProperty(4)]
        public List<string> Amount
        {
            get
            {
                return _amount;
            }
            //set
            //{
            //    _amount = value;
            //}
        }

        [CmbrRecordProperty(5)]
        public List<string> ItemCount
        {
            get
            {
                return _itemCount;
            }
            //set
            //{
            //    _itemCount = value;
            //}
        }

        [CmbrRecordProperty(6)]
        public List<string> FundsType
        {
            get
            {
                return _fundsType;
            }
            //set
            //{
            //    _fundsType = value;
            //}
        }

        #endregion

        #region Public Methods

        public override string  ReturnValues()
        {
            StringBuilder result = new StringBuilder();
            string temp = string.Empty; int maxArrayLength = 0;
            Array tempArray = null;
            List<string> prop = null;
            List<Array> tempArrayList = new List<Array>();

            temp = ((int)(RecordProperties[0].GetValue(this, null))).ToString() + ",";
            if (temp.Length == 2)
            {
                result.Append(temp.PadLeft(3, '0'));
            }
                for (int i = 1; i < RecordProperties.Count; i++)
                {
                    if (RecordProperties[i].PropertyType.Name == "String")
                    {
                        result.Append(RecordProperties[i].GetValue(this, null).ToString() + ",");
                    }
                    else if (RecordProperties[i].PropertyType.Name == "List`1")
                    {
                        prop = ((List<string>)RecordProperties[i].GetValue(this, null));
                            tempArray = prop.ToArray();
                            tempArrayList.Add(tempArray);
                    }
                    else
                    {
                        Debug.Assert(false,
                            "This property type is not supported with the CmbrRecordProperty attribute at this tiem.");
                    }
                }

                foreach (Array myArray in tempArrayList)
                {
                    if (myArray.GetUpperBound(0) > maxArrayLength)
                    {
                        maxArrayLength = myArray.GetUpperBound(0);
                    }
                }

                for (int k = 0; k <= maxArrayLength; k++)
                {
                    foreach (Array myArray in tempArrayList)
                    {
                        //some arrays may not have same # of elements
                        if (k <= myArray.GetUpperBound(0))
                        {
                            result.Append(myArray.GetValue(k) + ",");
                        }
                    }
                }

            return result.ToString();
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// This method is overriden because we need to account for multiple values
        /// in some fields.
        /// </summary>
        /// <param name="fields"></param>
        /// <param name="record"></param>
        internal override void ReadValuesIntoProperties(string[] fields, CmbrRecord record)
        {
            List<string> prop = null;

            foreach (KeyValuePair<int, PropertyInfo> kvp in record.RecordProperties)
            {
                if (kvp.Key != 0)   //we are ignoring the RecordType property since it is set in the constructor
                {
                    if (kvp.Value.PropertyType.Name == "String")
                    {
                        kvp.Value.SetValue(record, fields[kvp.Key].ToString(), null);
                    }
                    else if (kvp.Value.PropertyType.Name == "List`1")   //List<string> is List`1
                    {
                        //if fields are repeated, read data into List<string> properties
                        int idx = kvp.Key;
                        while (idx < fields.Length)
                        {
                            prop = ((List<string>)kvp.Value.GetValue(this, null));
                            prop.Add(fields[idx].ToString());
                            idx += 4;
                        }
                    }
                    else
                    {
                        Debug.Assert(false,
                            "This property type is not supported with the CmbrRecordProperty attribute at this tiem.");
                    }
                }
            }
        }

        #endregion
    }

}
