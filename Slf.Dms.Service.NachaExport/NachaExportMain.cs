using System;
using System.Configuration;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;
using System.Windows.Forms;
using System.Web.Mail;
using System.Collections.Generic;

using Drg.Util.PGPHelper;
using Drg.Util.DataAccess;
using Drg.Util.DataHelpers;

using EnterpriseDT.Net.Ftp;

using Slf.Dms.Ach;

namespace Slf.Dms.Service.ICBImport
{
	public class NachaExportMain
	{
		[STAThread]
		static void Main(string[] parms) 
		{
			using (TextWriter tw = new StreamWriter(LogFile, true))
            {
				// Hook up a log file trace writer
				Trace.Listeners.Add(new TextWriterTraceListener(tw));

                try
                {
                    //Trace.WriteLine("Checking for business day");

                    //if (IsBusinessDay())
                    //{
                        //Trace.WriteLine("Today is a business day... Continuing process...");

                        int fileId = -1;

                        if (parms.Length == 2)
                        {
                            if (string.Compare(parms[0], "-manualfile", true) == 0)
                                fileId = int.Parse(parms[1]);
                        }

                        StringWriter emailWriter = null;
                        TextWriterTraceListener emailListener = null;

                        StringWriter ImportWriter = null;
                        TextWriterTraceListener ImportListener = null;

                        ImportWriter = new StringWriter();
                        ImportListener = new TextWriterTraceListener(ImportWriter);

                        Trace.Listeners.Add(ImportListener);

                        if (LogEmailTo != null && LogEmailTo.Length > 0)
                        {
                            // Hook up a listener to compile the log for emailing
                            emailWriter = new StringWriter();
                            emailListener = new TextWriterTraceListener(emailWriter);

                            Trace.Listeners.Add(emailListener);
                        }

                        DateTime effectiveDate = GetEffectiveDate();

                        DataTable transactionsTable;

                        if (fileId == -1)
                            transactionsTable = GetOutstandingNachaRegisterItems();
                        else
                            transactionsTable = GetNachaRegisterItems(fileId);

                        NachaFile file = new NachaFile("062001319", "COLONIAL BANK", "1752892096", "TSLF");

                        BuildBatches(file, transactionsTable, effectiveDate);

                        file.End();

                        string nachaFile;

                        using (StringWriter w = new StringWriter())
                        {
                            file.Write(w);

                            nachaFile = w.ToString();
                        }

                        string nachaTotalFile = BuildTotalFile(transactionsTable);

                        bool ftpUpload = false;

                        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["ftpUpload"]))
                            bool.TryParse(ConfigurationManager.AppSettings["ftpUpload"], out ftpUpload);

                        if (ftpUpload)
                            UploadFiles(nachaFile, nachaTotalFile);

                        bool createFile = false;

                        if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["createFile"]))
                            bool.TryParse(ConfigurationManager.AppSettings["createFile"], out createFile);

                        if (createFile)
                            CreateFiles(nachaFile, nachaTotalFile);

                        if (fileId == -1)
                        {
                            fileId = CreateFile(DateTime.Now, effectiveDate);

                            UpdateTransactions(fileId, transactionsTable);
                        }

                        if (emailListener != null)
                        {
                            emailListener.Flush();
                            emailWriter.Flush();

                            Trace.Listeners.Remove(emailListener);
                            emailListener.Dispose();

                            EmailLog(emailWriter.ToString());

                            emailWriter.Close();
                        }

                        if (ImportListener != null)
                        {
                            ImportListener.Flush();
                            ImportWriter.Flush();

                            Trace.Listeners.Remove(ImportListener);
                            ImportListener.Dispose();

                            ImportWriter.Close();
                        }
                    //}
                    //else
                    //{
                    //    Trace.WriteLine("Today isn't a business day... Aborting process...");
                    //}
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.ToString());
                }
                finally
                {
                    foreach (TraceListener listener in Trace.Listeners)
                        listener.Flush();
                }
            }
		}

        static DateTime GetEffectiveDate()
        {
            DateTime effectiveDate = DateTime.Now.AddDays(1);

            while (!IsBusinessDay(effectiveDate))
                effectiveDate = effectiveDate.AddDays(1);

            return effectiveDate;
        }

        static DataTable GetOutstandingNachaRegisterItems()
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("get_OutstandingNachaRegisterItems"))
            using (cmd.Connection)
            {
                cmd.Connection.Open();

                using (IDataReader rd = cmd.ExecuteReader(CommandBehavior.SingleResult))
                {
                    DataTable table = new DataTable();

                    table.Load(rd);

                    return table;
                }
            }
        }

        static DataTable GetNachaRegisterItems(int fileId)
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("get_NachaRegisterItems"))
            using (cmd.Connection)
            {
                DatabaseHelper.AddParameter(cmd, "nachaFileId", fileId);

                cmd.Connection.Open();

                using (IDataReader rd = cmd.ExecuteReader(CommandBehavior.SingleResult))
                {
                    DataTable table = new DataTable();

                    table.Load(rd);

                    return table;
                }
            }
        }

        static void BuildBatches(NachaFile file, DataTable transactionsTable, DateTime effectiveDate)
        {
            transactionsTable.DefaultView.Sort = "CommRecId";

            // First do personal transactions
            transactionsTable.DefaultView.RowFilter = "IsPersonal=1";

            BuildBatches(file, transactionsTable.DefaultView.ToTable(), effectiveDate, EntryClass.PreAuthorizedPaymentOrDeposit);

            // Then do commercial transactions
            transactionsTable.DefaultView.RowFilter = "IsPersonal=0";

            BuildBatches(file, transactionsTable.DefaultView.ToTable(), effectiveDate, EntryClass.CashConcentrationDebit);
        }

        static void BuildBatches(NachaFile file, DataTable transactionsTable, DateTime effectiveDate, EntryClass entryClass)
        {
            int commRecId = 0;
            string AccountType = null;
            NachaBatch batch = null;

            foreach (DataRow row in transactionsTable.Rows)
            {
                if ((int)row["CommRecId"] != commRecId)
                {
                    commRecId = (int)row["CommRecId"];

                    batch = file.StartBatch(entryClass, GetMasterAccountName(commRecId), "062001319", effectiveDate, effectiveDate);
                }

                //check account type - either return it in the transactionsTable
                //or a direct call to the db (one call per row)

                AccountType = (string)row["AccountType"];

                if (AccountType == "S") // savings
                {
                    if ((double)(decimal)row["Amount"] > 0) // deposit to savings
                    {
                        batch.AddEntry(TransactionCode.AutomatedDepositToSavings, (string)row["RoutingNumber"],
                            (string)row["AccountNumber"], Math.Abs((double)(decimal)row["Amount"]),
                            row["NachaRegisterId"].ToString(), (string)row["Name"]);
                    }
                    else // debit from savings
                    {
                        batch.AddEntry(TransactionCode.AutomatedDebitFromSavings, (string)row["RoutingNumber"],
                            (string)row["AccountNumber"], Math.Abs((double)(decimal)row["Amount"]),
                            row["NachaRegisterId"].ToString(), (string)row["Name"]);
                    }
                }
                else //checkings
                {
                    if ((double)(decimal)row["Amount"] > 0) // deposit to checkings
                    {
                        batch.AddEntry(TransactionCode.AutomatedDepositToChecking, (string)row["RoutingNumber"],
                            (string)row["AccountNumber"], Math.Abs((double)(decimal)row["Amount"]),
                            row["NachaRegisterId"].ToString(), (string)row["Name"]);
                    }
                    else // debit from checkings
                    {
                        batch.AddEntry(TransactionCode.AutomatedDebitFromChecking, (string)row["RoutingNumber"],
                            (string)row["AccountNumber"], Math.Abs((double)(decimal)row["Amount"]),
                            row["NachaRegisterId"].ToString(), (string)row["Name"]);
                    }
                }
            }
        }

        static string GetMasterAccountName(int commRecId)
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("get_CommRecAccountName"))
            using (cmd.Connection)
            {
                DatabaseHelper.AddParameter(cmd, "commRecId", commRecId);

                cmd.Connection.Open();

                return (string)cmd.ExecuteScalar();
            }
        }

        static string BuildTotalFile(DataTable transactionsTable)
        {
            decimal debitAmount = 0;
            decimal creditAmount = 0;
            int creditCount = 0;
            int debitCount = 0;

            foreach (DataRow row in transactionsTable.Rows)
            {
                if ((decimal)row["Amount"] > 0)
                {
                    creditAmount += (decimal)row["Amount"];

                    creditCount++;
                }
                else
                {
                    debitAmount -= (decimal)row["Amount"];

                    debitCount++;
                }
            }

            return DateTime.Now.ToString("yyyy-MM-dd") + "\r\n" +
                   "SEIDEMAN LAW FIRM\r\n" + 
                   creditCount.ToString() + "\r\n" +
                   debitCount.ToString() + "\r\n" +
                   creditAmount.ToString("0.00") + "\r\n" +
                   debitAmount.ToString("0.00");
        }

        static void UploadFiles(string nachaFile, string nachaTotalFile)
        {
            FTPClient ftp = new FTPClient();
            
            ftp.RemoteHost = FtpServer;
            ftp.ControlPort = FtpControlPort;

            ftp.Connect();

            Trace.WriteLine("Logging in...");
            ftp.Login(FtpUserName, FtpPassword);

            Trace.WriteLine("Setting up passive, BINARY transfers...");
            ftp.ConnectMode = FTPConnectMode.PASV;
            ftp.TransferType = FTPTransferType.BINARY;

            if (FtpFolder != null && FtpFolder.Length > 0)
                // TODO: log
                ftp.ChDir(FtpFolder);

            string dateFragment = DateTime.Now.ToString("_yyyy_MM_dd") + ".dat";

            PutString(ftp, "nacha" + dateFragment, nachaFile);
            PutString(ftp, "nacha_total" + dateFragment, nachaTotalFile);

            ftp.Quote("literal site ack", null);

            ftp.Quit();
        }

        static void CreateFiles(string nachaFile, string nachaTotalFile)
        {
            string fileLocation = ConfigurationManager.AppSettings["fileLocation"];

            Directory.CreateDirectory(fileLocation);

            string dateFragment = DateTime.Now.ToString("_yyyy_MM_dd") + ".dat";

            string nachaFileName = GetUniqueFileName(Path.Combine(fileLocation, "nacha" + dateFragment));
            string nachaTotalFileName = GetUniqueFileName(Path.Combine(fileLocation, "nacha_total" + dateFragment));

            File.WriteAllText(nachaFileName, nachaFile);
            File.WriteAllText(nachaTotalFileName, nachaTotalFile);
        }

        static string GetUniqueFileName(string originalFileName)
        {
            string path = Path.GetDirectoryName(originalFileName);
            string fileName = Path.GetFileNameWithoutExtension(originalFileName);
            string ext = Path.GetExtension(originalFileName);

            int i = 1;

            while (File.Exists(originalFileName))
            {
                originalFileName = Path.Combine(path, fileName + " (" + i + ")" + ext);

                i++;
            }

            return originalFileName;
        }
        
        static void PutString(FTPClient ftp, string fileName, string data)
        {
            byte[] byteData = Encoding.ASCII.GetBytes(data);

            string encrypt = ConfigurationManager.AppSettings["encrypt"];

            if (!string.IsNullOrEmpty(encrypt) && bool.Parse(encrypt))
            {
                string publicKeyring = ConfigurationManager.AppSettings["publicKeyring"];
                string privateKeyring = ConfigurationManager.AppSettings["privateKeyring"];
                string passphrase = ConfigurationManager.AppSettings["passphrase"];

                PGPHelper.Initialize();

                string pgpFileName = Path.Combine(Path.GetDirectoryName(fileName), Path.GetFileNameWithoutExtension(fileName)) + ".pgp";

                byteData = PGPHelper.Encrypt(byteData, fileName, publicKeyring, privateKeyring, passphrase);

                fileName = pgpFileName;
            }

            ftp.Put(byteData, fileName);
        }

        static int CreateFile(DateTime date, DateTime effectiveDate)
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("insert_NachaFile"))
            using (cmd.Connection)
            {
                DatabaseHelper.AddParameter(cmd, "date", date);
                DatabaseHelper.AddParameter(cmd, "effectiveDate", effectiveDate);

                cmd.Connection.Open();

                return (int)cmd.ExecuteScalar();
            }
        }

        static void UpdateTransactions(int fileId, DataTable transactions)
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("update_NachaRegisterItem"))
            using (cmd.Connection)
            {
                IDataParameter nachaRegisterId = DatabaseHelper.CreateAndAddParamater(cmd, "nachaRegisterId", DbType.Int32);
                IDataParameter idTidbit = DatabaseHelper.CreateAndAddParamater(cmd, "idTidbit", DbType.AnsiString);

                //idTidbit.Size = 32;

                DatabaseHelper.AddParameter(cmd, "NachaFileId", fileId);

                cmd.Connection.Open();

                using (IDbTransaction trans = cmd.Connection.BeginTransaction())
                {
                    cmd.Transaction = trans;

                    foreach (DataRow row in transactions.Rows)
                    {
                        nachaRegisterId.Value = (int)row[0];
                        idTidbit.Value = row[0].ToString();

                        cmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                }
            }
        }

        static bool IsBusinessDay()
        {
            return IsBusinessDay(DateTime.Now);
        }

        static bool IsBusinessDay(DateTime date)
        {
            // Check for the weekend
            if (date.DayOfWeek != DayOfWeek.Saturday && date.DayOfWeek != DayOfWeek.Sunday)
            {
                // Check for holiday
                if (!IsBankHoliday(date))
                    return true;
            }

            return false;
        }

        static bool IsBankHoliday(DateTime date)
        {
            using (IDbCommand cmd = ConnectionFactory.CreateCommand("get_IsBankHoliday"))
            using (cmd.Connection)
            {
                DatabaseHelper.AddParameter(cmd, "date", date);

                cmd.Connection.Open();

                return (int)cmd.ExecuteScalar() > 0;
            }
        }

		static void EmailLog(string log)
		{
			if (LogEmailTo != null && LogEmailTo.Length > 0)
			{
				MailMessage msg = new MailMessage();

				msg.From = "service@dmsisupport.com";
				msg.To = LogEmailTo;
				msg.Subject = "Import Log for " + DateTime.Now.ToShortDateString();
				msg.Body = log;

				SmtpMail.SmtpServer = SmtpServer;

				try
				{
					SmtpMail.Send(msg);
				}
				catch (Exception ex)
				{
					Trace.WriteLine("Exception sending mail:");
					Trace.WriteLine(ex.ToString());
				}
			}
		}

		public static string ConnectionString
		{
			get
			{
				return ConfigurationManager.AppSettings["connectionString"];
			}
		}

		public static string FtpServer
		{
			get
			{
				return ConfigurationManager.AppSettings["ftpServer"];
			}
		}

        public static int FtpControlPort
        {
            get
            {
                string ftpPort = ConfigurationManager.AppSettings["ftpControlPort"];

                if (string.IsNullOrEmpty(ftpPort))
                    ftpPort = "21";

                return int.Parse(ftpPort);
            }
        }
        
        public static string FtpFolder
		{
			get
			{
				return ConfigurationManager.AppSettings["ftpFolder"];
			}
		}

		public static string FtpUserName
		{
			get
			{
				return ConfigurationManager.AppSettings["ftpUserName"];
			}
		}

		public static string FtpPassword
		{
			get
			{
				return ConfigurationManager.AppSettings["ftpPassword"];
			}
		}

		public static string LogFile
		{
			get
			{
				string logFile = ConfigurationManager.AppSettings["logFile"];

				if (logFile == null || logFile.Length == 0)
					logFile = Path.Combine(Path.GetDirectoryName(Assembly.GetEntryAssembly().Location), "Import.log");

				return logFile;
			}
		}
		
		public static string LogEmailTo
		{
			get
			{
				return ConfigurationManager.AppSettings["logEmailTo"];
			}
		}

		public static string SmtpServer
		{
			get
			{
				string server = ConfigurationManager.AppSettings["smtpServer"];

				if (server == null || server.Length == 0)
					return "localhost";
				else
					return server;
			}
		}
	}
}