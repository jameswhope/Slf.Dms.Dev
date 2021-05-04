using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.IO;
using System.Diagnostics;

namespace Slf.Dms.Ach
{
	public class CmbrRecord
	{
		public CmbrRecord(CmbrRecordType recordType)
		{
			_recordType = recordType;
		}

		[AttributeUsage(AttributeTargets.Property)]
		public class CmbrRecordPropertyAttribute : Attribute
		{
			public CmbrRecordPropertyAttribute(int positionInRecord)
			{
				_position = positionInRecord;
			}

			private int _position = 0;

			public int Position
			{
				get
				{
					return _position;
				}
			}
		}

		#region Enums & Structures

        private SortedList<int, System.Reflection.PropertyInfo> _recordProperties = new SortedList<int, System.Reflection.PropertyInfo>();

		#endregion

		#region Class Level Variables

		protected CmbrRecordType _recordType;

		#endregion

		#region Class Events

		#endregion

		#region Public Properties

        public SortedList<int, System.Reflection.PropertyInfo> RecordProperties
        {
            get
            {
                return _recordProperties;
            }
        }

		[CmbrRecordProperty(0)]
		public CmbrRecordType RecordType
		{
			get     //this is read only - there is no 'set'
			{
				return _recordType;
			}
		}

		#endregion

		#region Public Methods

        //define as virtual, and override in CmbrAccountIdentifierRecord
        public virtual string ReturnValues()
        {
            StringBuilder result = new StringBuilder();
            string temp = string.Empty;

            temp = ((int)(RecordProperties[0].GetValue(this, null))).ToString() + ",";

            if (temp.Length == 2)
            {
                result.Append(temp.PadLeft(3, '0'));
            }
            else
            {
                result.Append(temp);
            }
            for (int i = 1; i < RecordProperties.Count; i++)
            {
                result.Append(RecordProperties[i].GetValue(this, null).ToString() + ",");
            }
            
            return result.ToString();
        }

		#endregion

		#region Private Methods

        /// <summary>
        /// This method is inherited by all the RecordTypes, and is called from their
        /// constructors.
        /// </summary>
		protected void SetupRecordProperties()
		{
			//Use reflection to iterate through the properties and add them to the
			//_recordProperties list in the correct order.
			Type typeInfo = this.GetType();
			PropertyInfo[] allProperties = typeInfo.GetProperties();
			foreach (PropertyInfo myProp in allProperties)
			{
				object allAttributes = myProp.GetCustomAttributes(true);
				Array allMyAttributes = (Array)allAttributes;
				foreach (CmbrRecordPropertyAttribute myAttribute in allMyAttributes)
				{
					if (myAttribute is CmbrRecordPropertyAttribute)
					{
						//method is called from subclasses so 'this' refers to the subclass
						this._recordProperties.Add(myAttribute.Position, myProp);
					}
				}
			}
		}

        /// <summary>
        /// This method is overriden in the CmbrAccountIdentifierRecord aka AcctHeader, 
        /// since the AcctHeader has some properties that contain multiple values.
        /// </summary>
        /// <param name="fields"></param>
        /// <param name="record"></param>
		internal virtual void ReadValuesIntoProperties(string[] fields, CmbrRecord record)
		{
			foreach (KeyValuePair<int, PropertyInfo> kvp in record._recordProperties)
			{
				if (kvp.Key != 0)   //we are ignoring the RecordType property since it is set in the constructor
				{
					if (kvp.Value.PropertyType.Name == "String")
					{
						kvp.Value.SetValue(record, fields[kvp.Key].ToString(), null);
					}
					else
					{
						Debug.Assert(false,
							"All properties with the CmbrRecordProperty attribute are strings with the exception of RecordType.");
					}
				}
			}
		}

		#endregion
	}

}
