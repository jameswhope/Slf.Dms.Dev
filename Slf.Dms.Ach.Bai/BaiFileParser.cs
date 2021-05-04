using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.ComponentModel;

namespace Slf.Dms.Ach
{
    public class BaiFileParser
    {
        public BaiFileParser()
        {
            FileElements = new List<CmbrFileElement>();
        }

        #region Enums & Structures

        internal List<CmbrFileElement> FileElements = null;
        internal CmbrFileElement newFile = null;
        internal CmbrGroupElement newGroup = null;
        internal CmbrAccountElement newAccount = null;

        #endregion

        #region Class Level Variables

        int countFileElements = 0;
        int countGroupElements = 0;
        int countAccountElements = 0;

        #endregion

        #region Class Events

        #endregion

        #region Public Properties

        #endregion

        #region Public Methods

        public void Parse(string filename)
        {
            MemoryStream ms = new MemoryStream();
            ms = PreParse(filename);
            ms.Seek(0, SeekOrigin.Begin);
            string[] fields;
            string[] delimiter = new string[] { "," };
            using (Microsoft.VisualBasic.FileIO.TextFieldParser tfp = new Microsoft.VisualBasic.FileIO.TextFieldParser(ms))
            {
                tfp.Delimiters = delimiter;
                while (!tfp.EndOfData)
                {
                    fields = tfp.ReadFields();
                    CmbrRecord obj = null;
                    obj = CreateObjects(ref fields);
                    obj.ReadValuesIntoProperties(fields, obj);
                    //Add object (CmbrRecord) to Data Structure
                    AddRecord(obj);
                }
            }

        }

        /// <summary>
        /// The ListValues method drills down through all the objects, reading the
        /// property values into a string which is then returned.
        /// It is used for verification and testing.
        /// </summary>
        /// <param name="myList"></param>
        /// <returns></returns>
        public string ListValues()
        {
            StringBuilder result = new StringBuilder();
            if (FileElements.Count == 0)
            {
                result.Append("There are no current values." + Environment.NewLine + "Perhaps the file has not yet been parsed?");
            }
            else
            {
                // iterate through the tree and get each CmbrRecord object in order   
                foreach (CmbrFileElement myFile in FileElements)
                {
                    List<CmbrRecord> elements = myFile.GetRecords();
                    foreach (CmbrRecord rec in elements)
                    {
                        result.Append(rec.ReturnValues() + "/" + Environment.NewLine);
                    }
                }
            }
            return result.ToString();
        }

        #endregion

        #region Private Methods

        private static int CountOccurrences(string src, char find)
        {
            int ret = 0;
            foreach (char s in src)
            {
                if (s == find)
                {
                    ++ret;
                }
            }
            return ret;
        }

        /// <summary>
        /// The PreParse method takes a filename (including path), manipulates the data -
        /// removes the '/' Bai record termination character, eliminates the '88' continuation
        /// character, and basically turns it into a plain comma delimited file (in memory).
        /// This is done so that we can use the Microsoft.VisualBasic.FileIO.TextFieldParser
        /// instead of building our own.
        /// </summary>
        /// <param name="filename"></param>
        /// <returns>MemoryStream</returns>
        private MemoryStream PreParse(string filename)
        {
            string line = string.Empty; string prevLine = string.Empty; string prefix = string.Empty;
            int result = 0; char low = (char)0; char high = (char)31;
            StringBuilder sb = new StringBuilder();
            //creates an array of control codes (ASCII 0-31 - not visible) that could exist
            //in our BAI files and cause processing problems
            for (char ch = low; ch <= high; ch++)
            {
                sb.Append(ch.ToString());
            }
            Char[] nullChars = sb.ToString().ToCharArray();

            StringBuilder fileContents = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            MemoryStream myStream = new MemoryStream();
            using (StreamReader sr = new StreamReader(filename))
            {
                while ((line = sr.ReadLine()) != null)
                {
                    while ((result = line.IndexOfAny(nullChars)) != -1)
                    {
                        line = line.Remove(result, 1);
                    }
                    if (line.Length > 1)
                    {
                        prefix = line.Substring(0, 2);
                        switch (prefix)
                        {
                            case "01":
                            case "02":
                            case "03":
                            case "16":
                            case "49":
                            case "98":
                            case "99":
                                if (prevLine.EndsWith(",/"))
                                {
                                    prevLine = prevLine.Substring(0, prevLine.Length - 1) + ",";
                                }
                                else if (prevLine.EndsWith("/"))
                                {
                                    prevLine = prevLine.Substring(0, prevLine.Length - 1);
                                }
                                if (!string.IsNullOrEmpty(prevLine))
                                {
                                    prevLine = prevLine + Environment.NewLine;
                                }
                                if (prevLine.StartsWith("16") && prevLine.Length > prevLine.LastIndexOf(',') + 4)
                                {
                                    while (CountOccurrences(prevLine, ',') > 6)
                                    {   //tempoararily replace ',' in the last(6th & optional) text field with '`'
                                        sb2.Append(prevLine);
                                        prevLine = sb2.Replace(',', '`', prevLine.LastIndexOf(','), 1).ToString();
                                        sb2.Remove(0, sb2.Length);
                                    }
                                }
                                fileContents.Append(prevLine);
                                if (line.StartsWith("99"))
                                {
                                    fileContents.Append(line.Substring(0, line.Length - 1));
                                }
                                else
                                {
                                    //
                                }
                                prevLine = line;
                                break;
                            case "88":
                                if (prevLine.StartsWith("16"))
                                {
                                    line = line.Trim().Substring(3);    //eliminates the beginning '88,'
                                    prevLine = prevLine + line;
                                }
                                else   //prevLine StartsWith 03
                                {
                                    line = line.Trim().Substring(2);  //eliminates the beginning '88' and retains the comma
                                    if (prevLine.EndsWith("/"))
                                    {
                                        prevLine = prevLine.Substring(0, prevLine.Length - 2);
                                    }
                                }
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            StreamWriter sw = new StreamWriter(myStream);
            sw.Write(fileContents.ToString());
            sw.Flush();
            return myStream;
        }

        private CmbrRecord CreateObjects(ref string[] fields) //, ref int recType)
        {
            int recType = 0;
            Int32.TryParse(fields[0], out recType);

            switch (recType)    //set up object and populate properties
            {
                case 0:
                    //trap possible comments, line breaks, etc.
                    return null;
                case (int)CmbrRecordType.FileHeader:
                    CmbrFileHeaderRecord FileHeaderRecord = new CmbrFileHeaderRecord(CmbrRecordType.FileHeader);
                    return FileHeaderRecord;
                case (int)CmbrRecordType.GroupHeader:
                    CmbrGroupHeaderRecord GroupHeaderRecord = new CmbrGroupHeaderRecord(CmbrRecordType.GroupHeader);
                    return GroupHeaderRecord;
                case (int)CmbrRecordType.AccountIdentifier:
                    CmbrAccountIdentifierRecord AccountIdentifierRecord = new CmbrAccountIdentifierRecord(CmbrRecordType.AccountIdentifier);
                    return AccountIdentifierRecord;
                case (int)CmbrRecordType.TransactionDetail:
                    CmbrTransactionDetailRecord TransactionDetailRecord = new CmbrTransactionDetailRecord(CmbrRecordType.TransactionDetail);
                    return TransactionDetailRecord;
                case (int)CmbrRecordType.AccountTrailer:
                    CmbrAccountTrailerRecord AccountTrailerRecord = new CmbrAccountTrailerRecord(CmbrRecordType.AccountTrailer);
                    return AccountTrailerRecord;
                case (int)CmbrRecordType.GroupTrailer:
                    CmbrGroupTrailerRecord GroupTrailerRecord = new CmbrGroupTrailerRecord(CmbrRecordType.GroupTrailer);
                    return GroupTrailerRecord;
                case (int)CmbrRecordType.FileTrailer:
                    CmbrFileTrailerRecord FileTrailerRecord = new CmbrFileTrailerRecord(CmbrRecordType.FileTrailer);
                    return FileTrailerRecord;
                default:
                    System.Diagnostics.Debug.Assert(false, "Record Type not implemented.");
                    return null;
            }
        }

        private void AddRecord(CmbrRecord record)
        {
            int recType = 0;
            recType = (int)record.RecordType;
            switch (recType)
            {
                case 0:
                    //trap possible comments, line breaks, etc.
                    break;
                case (int)CmbrRecordType.FileHeader:
                    newFile = new CmbrFileElement();
                    newFile.Header = (CmbrFileHeaderRecord)record;  //record.GetType();
                    FileElements.Add(newFile);
                    countFileElements++;
                    countGroupElements = 0;
                    break;
                case (int)CmbrRecordType.GroupHeader:
                    newGroup = new CmbrGroupElement();
                    newGroup.Header = (CmbrGroupHeaderRecord)record;
                    FileElements[countFileElements - 1].Groups.Add(newGroup);
                    countGroupElements++;
                    countAccountElements = 0;
                    break;
                case (int)CmbrRecordType.AccountIdentifier:
                    newAccount = new CmbrAccountElement();
                    newAccount.Header = (CmbrAccountIdentifierRecord)record;
                    FileElements[countFileElements - 1].Groups[countGroupElements - 1].Accounts.Add(newAccount);
                    countAccountElements++;
                    break;
                case (int)CmbrRecordType.TransactionDetail:
                    FileElements[countFileElements - 1].Groups[countGroupElements - 1].Accounts[countAccountElements - 1].TransactionDetails.Add((CmbrTransactionDetailRecord)record);
                    break;
                case (int)CmbrRecordType.AccountTrailer:
                    FileElements[countFileElements - 1].Groups[countGroupElements - 1].Accounts[countAccountElements - 1].Footer = (CmbrAccountTrailerRecord)record;
                    break;
                case (int)CmbrRecordType.GroupTrailer:
                    FileElements[countFileElements - 1].Groups[countGroupElements - 1].Footer = (CmbrGroupTrailerRecord)record;
                    countAccountElements = 0;
                    break;
                case (int)CmbrRecordType.FileTrailer:
                    FileElements[countFileElements - 1].Footer = (CmbrFileTrailerRecord)record;
                    countGroupElements = 0;
                    break;
                default:
                    System.Diagnostics.Debug.Assert(false, "Record Type not implemented.");
                    break;
            }

        }

        #endregion
    }

}
