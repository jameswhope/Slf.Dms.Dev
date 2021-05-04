using System;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Windows.Forms;
using System.Web.Mail;

using Drg.Util.DataAccess;
using Drg.Util.DataHelpers;

using EnterpriseDT.Net.Ftp;

// TODO: create import header table for unique ids
// TODO: assign unique id to each import to enable rollback
// TODO: write to the Exception table

namespace Slf.Dms.Service.BankImport
{
	public class ImportMain
	{
		[STAThread]
		static void Main(string[] parms) 
		{
			using (TextWriter tw = new StreamWriter(LogFile, true))
			{
				// Hook up a log file trace writer
				Trace.Listeners.Add(new TextWriterTraceListener(tw));

				if (parms.Length > 0 && parms[0].ToLower() == "-batch")
				{
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

					string[] fileNames = GetFtpLatest();

                    List<int> ImportIds = new List<int>();

					if (fileNames != null)
					{
                        for (int i = 0; i < fileNames.Length; i++)
                        {
                            int ImportID = ImportFile(fileNames[i], ConnectionString);

                            if (ImportID != 0)
                                ImportIds.Add(ImportID);
                        }

						if (fileNames.Length > 0)
						{
							ExecuteAfterImportStoredProc(ConnectionString);
						}
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

                        // insert entire log against each import
                        foreach (int ImportID in ImportIds)
                        {
                            ImportLogHelper.Insert(ImportID, ImportWriter.ToString());
                        }

                        ImportWriter.Close();
                    }
				}
				else
				{
					Application.Run(new ImportMainForm());
				}
			}
		}

		static string[] GetFtpLatest()
		{
			Trace.WriteLine("--------------------------------");
			Trace.Write(DateTime.Now.ToString());
			Trace.Write(" - Retrieving from FTP\r\n");
			Trace.Write("Server: ");
			Trace.Write(FtpServer);
			Trace.Write("\r\nFolder: ");
			Trace.Write(FtpFolder);
			Trace.Write("\r\n--------------------------------\r\n");

			try 
			{
				Trace.WriteLine("Connecting...");
				FTPClient ftp = new FTPClient(FtpServer);

				Trace.WriteLine("Logging in...");
				ftp.Login(FtpUserName, FtpPassword);

				Trace.WriteLine("Setting up passive, ASCII transfers...");
                ftp.ConnectMode = FTPConnectMode.PASV;
				ftp.TransferType = FTPTransferType.ASCII;

				if (FtpFolder != null && FtpFolder.Length > 0)
					ftp.ChDir(FtpFolder);

				string[] files = ftp.Dir();

				ArrayList importFiles = new ArrayList(files.Length);

				for (int i = 0; i < files.Length; i++)
				{
					if (files[i].StartsWith("seidlock_tran9_"))
					{
						Trace.Write("Found file: ");
						Trace.Write(files[i]);
						Trace.Write("\r\n");

						string localPath = Path.Combine(FileLocation, files[i]);

                        if (File.Exists(localPath))
                            localPath = GetUniqueFileName(localPath);
                        
                        Trace.Write("Downloading to ");
						Trace.Write(localPath);
						Trace.Write("\r\n");

						ftp.Get(localPath, files[i]);

						Trace.WriteLine("Deleting file...");
						ftp.Delete(files[i]);

						importFiles.Add(localPath);
					}
					else
					{
						Trace.Write("Ignoring file: ");
						Trace.Write(files[i]);
						Trace.Write("... Bad naming convention...\r\n");
					}
				}

				// Shut down client                
				Trace.WriteLine("Logging off...");
				ftp.Quit();
            
				Trace.WriteLine("Process complete.");

				return (string[])importFiles.ToArray(typeof(string));
			} 
			catch (Exception e) 
			{
				Trace.WriteLine("Exception:");
				Trace.Write(e.ToString());
			}

			return null;
		}

        static string GetUniqueFileName(string originalFileName)
        {
            string path = Path.GetDirectoryName(originalFileName);
            string fileName = Path.GetFileNameWithoutExtension(originalFileName);
            string ext = Path.GetExtension(originalFileName);

            int i = 1;

            while (File.Exists(originalFileName))
            {
                originalFileName = Path.Combine(path, fileName + " DUPLICATE (" + i + ")" + ext);

                i++;
            }

            return originalFileName;
        }


        static byte[] GenerateMD5(string fileName)
        {
            using (MD5 md5 = MD5CryptoServiceProvider.Create())
                return md5.ComputeHash(File.ReadAllBytes(fileName));
        }

		public static int ImportFile(string fileName, string connectionString)
		{
            double HoldCheckAmount = double.Parse(PropertyHelper.Value("HoldCheckAmount"));
            double HoldCheckDays = double.Parse(PropertyHelper.Value("HoldCheckDays"));

			Trace.WriteLine("--------------------------------");
			Trace.Write(DateTime.Now.ToString());
			Trace.Write(" - Importing\r\n");
			Trace.Write("File: ");
			Trace.Write(fileName);
			Trace.Write("\r\nConnection String: ");
			Trace.Write(connectionString);
			Trace.Write("\r\n--------------------------------\r\n");

            byte[] md5;

            md5 = GenerateMD5(fileName);
            
            using (SqlConnection cn = new SqlConnection(connectionString))
            using (SqlCommand cmd = cn.CreateCommand())
            {
                cmd.CommandText = "SELECT ImportId FROM tblImport WHERE MD5=@MD5";

                DatabaseHelper.AddParameter(cmd, "MD5", md5);

                cn.Open();

                List<string> duplicateImportIds = new List<string>();

                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                        duplicateImportIds.Add(rd.GetInt32(0).ToString());
                }

                if (duplicateImportIds.Count > 0)
                {
                    Trace.WriteLine("Found duplicate files:");

                    for (int i = 0; i < duplicateImportIds.Count; i++)
                        Trace.WriteLine("ImportId = " + duplicateImportIds[i]);

                    Trace.WriteLine("Skipping Import!");

                    cmd.Parameters.Clear();

                    DatabaseHelper.AddParameter(cmd, "Imported", DateTime.Now);
                    DatabaseHelper.AddParameter(cmd, "ImportedBy", 24); // user 24 is Import Engine
                    DatabaseHelper.AddParameter(cmd, "Database", "TEXT FILE");
                    DatabaseHelper.AddParameter(cmd, "Table", fileName);
                    DatabaseHelper.AddParameter(cmd, "Description", "THIS FILE MATCHES PREVIOUS IMPORT " + string.Join(", ", duplicateImportIds.ToArray()));
                    DatabaseHelper.AddParameter(cmd, "MD5", md5);

                    cmd.CommandText = "INSERT INTO tblImport (Imported, ImportedBy, [Database], "
                        + "[Table], [Description], MD5) VALUES (@Imported, @ImportedBy, @Database, @Table, "
                        + "@Description, @MD5); SELECT CAST(SCOPE_IDENTITY() AS int)";

                    int importId = (int)cmd.ExecuteScalar();

                    return importId;

                }
            }

            try
			{
                int ImportID;
                
                using (StreamReader s = new StreamReader(fileName))
				using (SqlConnection cn = new SqlConnection(connectionString))
				{
					string dateString = s.ReadLine();

					DateTime date = new DateTime(int.Parse(dateString.Substring(4)),
						int.Parse(dateString.Substring(0, 2)),
						int.Parse(dateString.Substring(2, 2)));


					using (SqlCommand ImportCommand = cn.CreateCommand())
					{
                        DatabaseHelper.AddParameter(ImportCommand, "Imported", DateTime.Now);
                        DatabaseHelper.AddParameter(ImportCommand, "ImportedBy", 24); // user 24 is Import Engine
                        DatabaseHelper.AddParameter(ImportCommand, "Database", "TEXT FILE");
                        DatabaseHelper.AddParameter(ImportCommand, "Table", fileName);
                        DatabaseHelper.AddParameter(ImportCommand, "Description", "Daily lockbox report from Colonial Bank");
                        DatabaseHelper.AddParameter(ImportCommand, "MD5", md5);

                        ImportCommand.CommandText = "INSERT INTO tblImport (Imported, ImportedBy, [Database], " 
                            + "[Table], [Description], MD5) VALUES (@Imported, @ImportedBy, @Database, @Table, " 
                            + "@Description, @MD5); SELECT CAST(SCOPE_IDENTITY() AS int)";

                        cn.Open();

                        ImportID = (int)ImportCommand.ExecuteScalar();
					}

					string Line = null;
					int LineNumber = 2;
					int TotalLines = 0;
					double TotalAmount = 0;
					int TotalSuccessfulLines = 0;
					double TotalSuccessfulAmount = 0;

					while ((Line = s.ReadLine()) != null)
					{
						if (Line.Length > 0)
						{
							string[] Segments = Line.Split(',');

							if (Segments.Length == 4)
							{
								string AccountNumber = Segments[0];

                                int EntryTypeID = int.Parse(Segments[1]);
                                double Amount = double.Parse(Segments[2]);
                                string CheckNumber = Segments[3];

                                if (EntryTypeID == 9)
                                {
                                    EntryTypeID = 3; // the old bank code 9 (for deposit) is now 3
                                }

                                if (Segments[1] == "13" || Segments[1] == "9")
                                {
                                    TotalLines++;
                                    TotalAmount += Amount;

                                    int RecordsUpdated = 0;

                                    // lookup client
                                    int ClientID = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient",
                                        "ClientID", "AccountNumber = '" + AccountNumber.Replace("u", "0").Replace("U", "0").TrimStart(new char[] {'0'}) + "'"));

                                    // insert transaction against client
                                    if (ClientID != 0)
                                    {
                                        // create command
                                        IDbCommand cmd = ConnectionFactory.Create().CreateCommand();

                                        try
                                        {
                                            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID);
                                            DatabaseHelper.AddParameter(cmd, "TransactionDate", date);
                                            DatabaseHelper.AddParameter(cmd, "CheckNumber", CheckNumber);
                                            DatabaseHelper.AddParameter(cmd, "Amount", Amount);
                                            DatabaseHelper.AddParameter(cmd, "EntryTypeID", 3); // entrytype 3: deposit
                                            DatabaseHelper.AddParameter(cmd, "ImportID", ImportID);

                                            if (Amount >= HoldCheckAmount)
                                            {
                                                DatabaseHelper.AddParameter(cmd, "Hold", date.AddDays(HoldCheckDays));
                                                DatabaseHelper.AddParameter(cmd, "HoldBy", 24); // user 24: Import Engine
                                            }

                                            DatabaseHelper.BuildInsertCommandText(ref cmd, "tblRegister");

                                            cmd.Connection.Open();

                                            RecordsUpdated = cmd.ExecuteNonQuery();
                                        }
                                        finally
                                        {
                                            DatabaseHelper.EnsureConnectionClosed(cmd.Connection);
                                        }

                                        // run payment manager on client
                                        ClientHelper.CleanupRegister(ClientID);

                                        // run the rebalancer for client (necessary as inserted transactions
                                        // may be from an earlier date, thus making the balance incorrect)
                                        RegisterHelper.Rebalance(ClientID);
                                    }

                                    if (RecordsUpdated > 0)
                                    {
                                        TotalSuccessfulLines++;
                                        TotalSuccessfulAmount += Amount;

                                        Trace.Write("Line ");
                                        Trace.Write(LineNumber.ToString());
                                        Trace.Write(", Account ");
                                        Trace.Write(AccountNumber.ToString());
                                        Trace.Write(", Amount ");
                                        Trace.Write(Amount.ToString());
                                        Trace.Write(", Check ");
                                        Trace.Write(CheckNumber.ToString());
                                        Trace.Write(" SUCCESS\r\n");
                                    }
                                    else
                                    {
                                        Trace.Write("Line ");
                                        Trace.Write(LineNumber.ToString());
                                        Trace.Write(", Account ");
                                        Trace.Write(AccountNumber.ToString());
                                        Trace.Write(", Amount ");
                                        Trace.Write(Amount.ToString());
                                        Trace.Write(", Check ");
                                        Trace.Write(CheckNumber.ToString());
                                        Trace.Write(" insert error: Client not found.\r\n");

                                        // TODO: write exception log table
                                        //InsertException(
                                    }
                                }
                                else
                                {
                                    Trace.Write("Line ");
                                    Trace.Write(LineNumber.ToString());
                                    Trace.Write(", Account ");
                                    Trace.Write(AccountNumber.ToString());
                                    Trace.Write(", Amount ");
                                    Trace.Write(Amount.ToString());
                                    Trace.Write(", Check ");
                                    Trace.Write(CheckNumber.ToString());
                                    Trace.Write(" invalid Entry Type ");
                                    Trace.Write(Segments[1]);
                                    Trace.Write(".\r\n");

                                    // TODO: write exception log table
                                }
                        }
					    else
					    {
						    Trace.Write("Line ");
						    Trace.Write(LineNumber.ToString());
						    Trace.Write(" could not properly parse \"");
						    Trace.Write(Line);
						    Trace.Write("\". Skipping.\r\n");
							}

							LineNumber++;
						}
					}

					Trace.WriteLine("Import complete.");
					Trace.Write("Total line items: ");
					Trace.Write(TotalLines.ToString());
					Trace.Write(", Amount: ");
					Trace.Write(TotalAmount.ToString());
					Trace.Write("\r\nSuccessful line items: ");
					Trace.Write(TotalSuccessfulLines.ToString());
					Trace.Write(", Amount: ");
					Trace.Write(TotalSuccessfulAmount.ToString());
					Trace.Write("\r\nUnsuccessful line items: ");
					Trace.Write((TotalLines - TotalSuccessfulLines).ToString());
					Trace.Write(", Amount: ");
					Trace.Write((TotalAmount - TotalSuccessfulAmount).ToString());
					Trace.Write("\r\n");
				}

                return ImportID;
			}
			catch (FileNotFoundException ex)
			{
				Trace.Write("Could not find file:\r\n");
				Trace.Write(ex.ToString());
			}
			catch (IOException ex)
			{
				Trace.Write("IO error:\r\n");
				Trace.Write(ex.ToString());
			}
			catch (SqlException ex)
			{
				Trace.Write("SQL Error:\r\n");
				Trace.Write(ex.ToString());
			}
			catch (Exception ex)
			{
				Trace.Write("Exception:\r\n");
				Trace.Write(ex.ToString());
			}

            return 0;
		}

		public static void ExecuteAfterImportStoredProc(string connectionString)
		{
			Trace.WriteLine("--------------------------------");
			Trace.Write(DateTime.Now.ToString());
			Trace.Write(" - Updating transactions\r\n");
			Trace.Write("Stored Proc: ");
			Trace.Write(AfterImportStoredProc);
			Trace.Write("\r\nTimeout: ");
			Trace.Write(AfterImportTimeout);
			Trace.Write("\r\n--------------------------------\r\n");

			if (AfterImportStoredProc != null && AfterImportStoredProc.Length > 0)
			{
				using (SqlConnection cn = new SqlConnection(connectionString))
				using (SqlCommand cmd = cn.CreateCommand())
				{
					cmd.CommandText = AfterImportStoredProc;
					cmd.CommandType = CommandType.StoredProcedure;

					cmd.CommandTimeout = AfterImportTimeout;

					cn.Open();

					Trace.WriteLine("Executing...");
					cmd.ExecuteNonQuery();
					Trace.WriteLine("Completed");
				}
			}
			else
			{
				Trace.WriteLine("No stored procedure specified. Aborting.");
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
				return ConfigurationSettings.AppSettings["connectionString"];
			}
		}

		public static string FtpServer
		{
			get
			{
				return ConfigurationSettings.AppSettings["ftpServer"];
			}
		}

		public static string FtpFolder
		{
			get
			{
				return ConfigurationSettings.AppSettings["ftpFolder"];
			}
		}

		public static string FtpUserName
		{
			get
			{
				return ConfigurationSettings.AppSettings["ftpUserName"];
			}
		}

		public static string FtpPassword
		{
			get
			{
				return ConfigurationSettings.AppSettings["ftpPassword"];
			}
		}

		public static string LogFile
		{
			get
			{
				string logFile = ConfigurationSettings.AppSettings["logFile"];

				if (logFile == null || logFile.Length == 0)
					logFile = Path.Combine(Path.GetDirectoryName(Assembly.GetEntryAssembly().Location), "Import.log");

				return logFile;
			}
		}
		
		public static string LogEmailTo
		{
			get
			{
				return ConfigurationSettings.AppSettings["logEmailTo"];
			}
		}

		public static string SmtpServer
		{
			get
			{
				string server = ConfigurationSettings.AppSettings["smtpServer"];

				if (server == null || server.Length == 0)
					return "localhost";
				else
					return server;
			}
		}

		public static string FileLocation
		{
			get
			{
				return ConfigurationSettings.AppSettings["fileLocation"];
			}
		}

		public static string AfterImportStoredProc
		{
			get
			{
				return ConfigurationSettings.AppSettings["afterImportStoredProc"];
			}
		}

		public static int AfterImportTimeout
		{
			get
			{
				string timeout = ConfigurationSettings.AppSettings["afterImportTimeout"];

				if (timeout != null && timeout.Length > 0)
				{
					try
					{
						return int.Parse(timeout);
					}
					catch
					{
						return 1800;
					}
				}
				else
				{
					return 1800;
				}
			}
		}
	}
}