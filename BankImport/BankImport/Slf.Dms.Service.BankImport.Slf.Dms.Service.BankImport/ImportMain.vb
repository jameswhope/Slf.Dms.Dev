Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports EnterpriseDT.Net.Ftp
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Diagnostics
Imports System.IO
Imports System.Net.Mail
Imports System.Reflection
Imports System.Security.Cryptography
Imports System.Windows.Forms

Namespace Slf.Dms.Service.BankImport.Slf.Dms.Service.BankImport
    Public Class ImportMain
        ' Methods
        Private Shared Sub EmailLog(ByVal log As String)
            If (IIf(((Not ImportMain.LogEmailTo Is Nothing) AndAlso (ImportMain.LogEmailTo.Length > 0)), 1, 0) <> 0) Then
                Dim message As New MailMessage("service@dmsisupport.com", ImportMain.LogEmailTo)
                Dim client As New SmtpClient(ImportMain.SmtpServer)
                message.Subject = ("Import Log for " & DateTime.Now.ToShortDateString)
                message.Body = log
                Try 
                    client.Send(message)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim exception As Exception = exception1
                    Trace.WriteLine("Exception sending mail:")
                    Trace.WriteLine(exception.ToString)
                    ProjectData.ClearProjectError
                End Try
            End If
        End Sub

        Private Shared Function GenerateMD5(ByVal fileName As String) As Byte()
            Using md As MD5 = MD5.Create
                Return md.ComputeHash(File.ReadAllBytes(fileName))
            End Using
        End Function

        Private Shared Function GetFtpLatest() As String()
            Trace.WriteLine("--------------------------------")
            Trace.Write(DateTime.Now.ToString)
            Trace.Write(" - Retrieving from FTP" & ChrW(13) & ChrW(10))
            Trace.Write("Server: ")
            Trace.Write(ImportMain.FtpServer)
            Trace.Write(ChrW(13) & ChrW(10) & "Folder: ")
            Trace.Write(ImportMain.FtpFolder)
            Trace.Write(ChrW(13) & ChrW(10) & "--------------------------------" & ChrW(13) & ChrW(10))
            Try
                Trace.WriteLine("Connecting...")
                Dim client As New FTPClient(ImportMain.FtpServer)
                Trace.WriteLine("Logging in...")
                client.Login(ImportMain.FtpUserName, ImportMain.FtpPassword)
                Trace.WriteLine("Setting up passive, ASCII transfers...")
                client.ConnectMode = FTPConnectMode.PASV
                client.TransferType = FTPTransferType.ASCII
                If (IIf(((Not ImportMain.FtpFolder Is Nothing) AndAlso (ImportMain.FtpFolder.Length > 0)), 1, 0) <> 0) Then
                    client.ChDir(ImportMain.FtpFolder)
                End If
                Dim textArray2 As String() = client.Dir
                Dim list As New ArrayList(textArray2.Length)
                Dim num2 As Integer = (textArray2.Length - 1)
                Dim i As Integer = 0
                Do While (i <= num2)
                    If textArray2(i).Contains("lock_tran9_") Then
                        Trace.Write("Found file: ")
                        Trace.Write(textArray2(i))
                        Trace.Write(ChrW(13) & ChrW(10))
                        Dim strPath As String = Path.Combine(ImportMain.FileLocation, textArray2(i))
                        If File.Exists(strPath) Then
                            strPath = ImportMain.GetUniqueFileName(strPath)
                        End If
                        Trace.Write("Downloading to ")
                        Trace.Write(strPath)
                        Trace.Write(ChrW(13) & ChrW(10))
                        client.Get(strPath, textArray2(i))
                        Trace.WriteLine("Deleting file...")
                        client.Delete(textArray2(i))
                        list.Add(strPath)
                    Else
                        Trace.Write("Ignoring file: ")
                        Trace.Write(textArray2(i))
                        Trace.Write("... Bad naming convention..." & ChrW(13) & ChrW(10))
                    End If
                    i += 1
                Loop
                Trace.WriteLine("Logging off...")
                client.Quit()
                Trace.WriteLine("Process complete.")
                Return DirectCast(list.ToArray(GetType(String)), String())
            Catch exception1 As Exception
                ProjectData.SetProjectError(exception1)
                Dim exception As Exception = exception1
                Trace.WriteLine("Exception:")
                Trace.Write(exception.ToString)
                ProjectData.ClearProjectError()
            End Try
            Return Nothing
        End Function

        Private Shared Function GetUniqueFileName(ByVal originalFileName As String) As String
            Dim directoryName As String = Path.GetDirectoryName(originalFileName)
            Dim fileNameWithoutExtension As String = Path.GetFileNameWithoutExtension(originalFileName)
            Dim extension As String = Path.GetExtension(originalFileName)
            Dim i As Integer = 1
            Do While File.Exists(originalFileName)
                originalFileName = Path.Combine(directoryName, String.Concat(New Object() {fileNameWithoutExtension, " DUPLICATE (", i, ")", extension}))
                i += 1
            Loop
            Return originalFileName
        End Function

        Public Shared Function ImportFile(ByVal fileName As String, ByVal connectionString As String) As Integer
            Dim CurrentClientID As Integer
            Dim ClientIDs As New List(Of Integer)
            Dim num6 As Integer
            Dim num2 As Double = Double.Parse(PropertyHelper.Value("HoldCheckAmount"))
            Dim num3 As Double = Double.Parse(PropertyHelper.Value("HoldCheckDays"))
            Trace.WriteLine("--------------------------------")
            Trace.Write(DateTime.Now.ToString)
            Trace.Write(" - Importing" & ChrW(13) & ChrW(10))
            Trace.Write("File: ")
            Trace.Write(fileName)
            Trace.Write(ChrW(13) & ChrW(10) & "Connection String: ")
            Trace.Write(connectionString)
            Trace.Write(ChrW(13) & ChrW(10) & "--------------------------------" & ChrW(13) & ChrW(10))
            Dim buffer As Byte() = ImportMain.GenerateMD5(fileName)
            Using connection As SqlConnection = New SqlConnection(connectionString)
                Using cmd As SqlCommand = connection.CreateCommand
                    cmd.CommandTimeout = 300
                    cmd.CommandText = "SELECT ImportId FROM tblImport WHERE MD5=@MD5"
                    DatabaseHelper.AddParameter(cmd, "MD5", buffer)
                    connection.Open()
                    Dim list As New List(Of String)
                    Using reader As SqlDataReader = cmd.ExecuteReader
                        Do While reader.Read
                            list.Add(reader.GetInt32(0).ToString)
                        Loop
                    End Using
                    If (list.Count > 0) Then
                        Trace.WriteLine("Found duplicate files:")
                        Dim num16 As Integer = (list.Count - 1)
                        Dim i As Integer = 0
                        Do While (i <= num16)
                            Trace.WriteLine(("ImportId = " & list.Item(i)))
                            i += 1
                        Loop
                        Trace.WriteLine("Skipping Import!")
                        cmd.Parameters.Clear()
                        DatabaseHelper.AddParameter(cmd, "Imported", DateTime.Now)
                        DatabaseHelper.AddParameter(cmd, "ImportedBy", &H18)
                        DatabaseHelper.AddParameter(cmd, "Database", "TEXT FILE")
                        DatabaseHelper.AddParameter(cmd, "Table", fileName)
                        DatabaseHelper.AddParameter(cmd, "Description", ("THIS FILE MATCHES PREVIOUS IMPORT " & String.Join(", ", list.ToArray)))
                        DatabaseHelper.AddParameter(cmd, "MD5", buffer)
                        cmd.CommandText = "INSERT INTO tblImport (Imported, ImportedBy, [Database], [Table], [Description], MD5) VALUES (@Imported, @ImportedBy, @Database, @Table, @Description, @MD5); SELECT CAST(SCOPE_IDENTITY() AS int)"
                        Return Conversions.ToInteger(cmd.ExecuteScalar)
                    End If
                End Using
            End Using
            Try
                Using reader2 As StreamReader = New StreamReader(fileName)
                    Using connection2 As SqlConnection = New SqlConnection(connectionString)
                        Dim text2 As String = reader2.ReadLine
                        Dim time As New DateTime(Integer.Parse(text2.Substring(4)), Integer.Parse(text2.Substring(0, 2)), Integer.Parse(text2.Substring(2, 2)))
                        Using command2 As SqlCommand = connection2.CreateCommand
                            command2.CommandTimeout = 300
                            DatabaseHelper.AddParameter(command2, "Imported", DateTime.Now)
                            DatabaseHelper.AddParameter(command2, "ImportedBy", &H18)
                            DatabaseHelper.AddParameter(command2, "Database", "TEXT FILE")
                            DatabaseHelper.AddParameter(command2, "Table", fileName)
                            DatabaseHelper.AddParameter(command2, "Description", "Daily lockbox report from Colonial Bank")
                            DatabaseHelper.AddParameter(command2, "MD5", buffer)
                            command2.CommandText = "INSERT INTO tblImport (Imported, ImportedBy, [Database], [Table], [Description], MD5) VALUES (@Imported, @ImportedBy, @Database, @Table, @Description, @MD5); SELECT CAST(SCOPE_IDENTITY() AS int)"
                            connection2.Open()
                            num6 = Conversions.ToInteger(command2.ExecuteScalar)
                        End Using
                        Dim message As String = Nothing
                        Dim num7 As Integer = 2
                        Dim num8 As Integer = 0
                        Dim num9 As Double = 0
                        Dim num10 As Integer = 0
                        Dim num5 As Double = 0
                        message = reader2.ReadLine
                        Do While (Not message Is Nothing)
                            If (IIf(((Not message Is Nothing) AndAlso (message.Length > 0)), 1, 0) <> 0) Then
                                Dim textArray As String() = message.Split(New Char() {","c})
                                If (textArray.Length = 4) Then
                                    Dim text3 As String = textArray(0)
                                    Dim num11 As Integer = Integer.Parse(textArray(1))
                                    Dim num12 As Double = Double.Parse(textArray(2))
                                    Dim text4 As String = textArray(3)
                                    If (num11 = 9) Then
                                        num11 = 3
                                    End If
                                    If (IIf(((Operators.CompareString(textArray(1), "13", False) = 0) OrElse (Operators.CompareString(textArray(1), "9", False) = 0)), 1, 0) <> 0) Then
                                        num8 += 1
                                        num9 = (num9 + num12)
                                        Dim num13 As Integer = 0
                                        Dim num14 As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "ClientID", ("AccountNumber = '" & text3.Replace("u", "0").Replace("U", "0").TrimStart(New Char() {"0"c}) & "'")))
                                        CurrentClientID = num14
                                        If (num14 <> 0) Then
                                            Dim command3 As IDbCommand = ConnectionFactory.Create.CreateCommand
                                            command3.CommandTimeout = 300
                                            Try
                                                DatabaseHelper.AddParameter(command3, "ClientID", num14)
                                                DatabaseHelper.AddParameter(command3, "TransactionDate", time)
                                                DatabaseHelper.AddParameter(command3, "CheckNumber", text4)
                                                DatabaseHelper.AddParameter(command3, "Amount", num12)
                                                DatabaseHelper.AddParameter(command3, "EntryTypeID", 3)
                                                DatabaseHelper.AddParameter(command3, "ImportID", num6)
                                                If (num12 >= num2) Then
                                                    DatabaseHelper.AddParameter(command3, "Hold", time.AddDays(num3))
                                                    DatabaseHelper.AddParameter(command3, "HoldBy", &H18)
                                                End If
                                                DatabaseHelper.BuildInsertCommandText((command3), "tblRegister")
                                                command3.Connection.Open()
                                                num13 = command3.ExecuteNonQuery
                                            Finally
                                                DatabaseHelper.EnsureConnectionClosed(command3.Connection)
                                            End Try
                                            ClientHelper.CleanupRegister(num14)
                                            ClientIDs.Add(num14)
                                            'RegisterHelper.Rebalance(num14)
                                        End If
                                        If (num13 > 0) Then
                                            num10 += 1
                                            num5 = (num5 + num12)
                                        Else
                                            Trace.Write("Line ")
                                            Trace.Write(num7.ToString)
                                            Trace.Write(", Account ")
                                            Trace.Write(text3.ToString)
                                            Trace.Write(", Amount ")
                                            Trace.Write(num12.ToString)
                                            Trace.Write(", Check ")
                                            Trace.Write(text4.ToString)
                                            Trace.Write(" insert error: Client not found." & ChrW(13) & ChrW(10))
                                        End If
                                    Else
                                        Trace.Write("Line ")
                                        Trace.Write(num7.ToString)
                                        Trace.Write(", Account ")
                                        Trace.Write(text3.ToString)
                                        Trace.Write(", Amount ")
                                        Trace.Write(num12.ToString)
                                        Trace.Write(", Check ")
                                        Trace.Write(text4.ToString)
                                        Trace.Write(" invalid Entry Type ")
                                        Trace.Write(textArray(1))
                                        Trace.Write("." & ChrW(13) & ChrW(10))
                                    End If
                                Else
                                    Trace.Write("Line ")
                                    Trace.Write(num7.ToString)
                                    Trace.Write(" could not properly parse """)
                                    Trace.Write(message)
                                    Trace.Write(""". Skipping." & ChrW(13) & ChrW(10))
                                End If
                                num7 += 1
                            End If
                            message = reader2.ReadLine
                        Loop
                        Trace.WriteLine("Import complete.")
                        Trace.Write("Total line items: ")
                        Trace.Write(num8.ToString)
                        Trace.Write(", Amount: ")
                        Trace.Write(num9.ToString)
                        Trace.Write(ChrW(13) & ChrW(10) & "Successful line items: ")
                        Trace.Write(num10.ToString)
                        Trace.Write(", Amount: ")
                        Trace.Write(num5.ToString)
                        Trace.Write(ChrW(13) & ChrW(10) & "Unsuccessful line items: ")
                        Trace.Write((num8 - num10).ToString)
                        Trace.Write(", Amount: ")
                        Trace.Write((num9 - num5).ToString)
                        Trace.Write(ChrW(13) & ChrW(10))
                    End Using
                End Using

                Trace.Write("Assigning Negotiators..." & ChrW(13) & ChrW(10))

                Using cmd As New SqlCommand("", New SqlConnection(connectionString))
                    Using cmd.Connection
                        cmd.CommandTimeout = 3600

                        cmd.Connection.Open()

                        For Each id As Integer In ClientIDs
                            CurrentClientID = id
                            cmd.CommandText = "exec stp_AssignNegotiator " + id.ToString()

                            cmd.ExecuteNonQuery()
                        Next
                    End Using
                End Using

                Trace.Write("Assigned Negotiators For All " & ClientIDs.Count & " Clients." & ChrW(13) & ChrW(10))

                Return num6
            Catch exception1 As FileNotFoundException
                ProjectData.SetProjectError(exception1)
                Dim exception As FileNotFoundException = exception1
                Trace.Write("Could not find file:" & ChrW(13) & ChrW(10))
                Trace.Write(exception.ToString)
                ProjectData.ClearProjectError()
            Catch exception5 As IOException
                ProjectData.SetProjectError(exception5)
                Dim exception2 As IOException = exception5
                Trace.Write("IO error:" & ChrW(13) & ChrW(10))
                Trace.Write(exception2.ToString)
                ProjectData.ClearProjectError()
            Catch exception6 As SqlException
                ProjectData.SetProjectError(exception6)
                Dim exception3 As SqlException = exception6
                Trace.Write("Died Trying To Process Client: " & CurrentClientID & ChrW(13) & ChrW(10))
                Trace.Write("SQL Error:" & ChrW(13) & ChrW(10))
                Trace.Write(exception3.ToString)
                ProjectData.ClearProjectError()
            Catch exception7 As Exception
                ProjectData.SetProjectError(exception7)
                Dim exception4 As Exception = exception7
                Trace.Write("Exception:" & ChrW(13) & ChrW(10))
                Trace.Write(exception4.ToString)
                ProjectData.ClearProjectError()
            End Try
            Return 0
        End Function

        <STAThread()> _
        Public Shared Sub Main(ByVal parms As String())
            Using writer As TextWriter = New StreamWriter(ImportMain.LogFile, True)
                Trace.Listeners.Add(New TextWriterTraceListener(writer))
                If (IIf(((parms.Length > 0) AndAlso (Operators.CompareString(parms(0).Trim.ToLower, "-batch", False) = 0)), 1, 0) <> 0) Then
                    Dim ftpLatest As String()
                    Dim writer2 As StringWriter = Nothing
                    Dim listener As TextWriterTraceListener = Nothing
                    Dim writer3 As StringWriter = Nothing
                    Dim listener2 As TextWriterTraceListener = Nothing
                    writer3 = New StringWriter
                    listener2 = New TextWriterTraceListener(writer3)
                    Trace.Listeners.Add(listener2)
                    If (IIf(((Not ImportMain.LogEmailTo Is Nothing) AndAlso (ImportMain.LogEmailTo.Length > 0)), 1, 0) <> 0) Then
                        writer2 = New StringWriter
                        listener = New TextWriterTraceListener(writer2)
                        Trace.Listeners.Add(listener)
                    End If
                    If (parms.Length > 1) Then
                        ftpLatest = parms(1).Replace("""", "").Split(New Char() {","c})
                    Else
                        ftpLatest = ImportMain.GetFtpLatest
                    End If
                    Dim list As New List(Of Integer)
                    If (Not ftpLatest Is Nothing) Then
                        Dim num4 As Integer = (ftpLatest.Length - 1)
                        Dim i As Integer = 0
                        Do While (i <= num4)
                            Dim item As Integer = ImportMain.ImportFile(ftpLatest(i), ImportMain.ConnectionString)
                            If (item <> 0) Then
                                list.Add(item)
                            End If
                            i += 1
                        Loop
                        Trace.WriteLine("Goodbye.")
                    End If
                    If (Not listener Is Nothing) Then
                        listener.Flush()
                        writer2.Flush()
                        Trace.Listeners.Remove(listener)
                        listener.Dispose()
                        ImportMain.EmailLog(writer2.ToString)
                        writer2.Close()
                    End If
                    If (Not listener2 Is Nothing) Then
                        listener2.Flush()
                        writer3.Flush()
                        Trace.Listeners.Remove(listener2)
                        listener2.Dispose()
                        Dim num3 As Integer
                        For Each num3 In list
                            ImportLogHelper.Insert(num3, writer3.ToString)
                        Next
                        writer3.Close()
                    End If
                Else
                    Application.Run(New ImportMainForm)
                End If
            End Using
        End Sub


        ' Properties
        Public Shared ReadOnly Property AfterImportStoredProc As String
            Get
                Return ConfigurationSettings.AppSettings.Item("afterImportStoredProc")
            End Get
        End Property

        Public Shared ReadOnly Property AfterImportTimeout As Integer
            Get
                Dim s As String = ConfigurationSettings.AppSettings.Item("afterImportTimeout")
                If (IIf(((Not s Is Nothing) AndAlso (s.Length > 0)), 1, 0) <> 0) Then
                    Try 
                        Return Integer.Parse(s)
                    Catch exception1 As Exception
                        ProjectData.SetProjectError(exception1)
                        Dim exception As Exception = exception1
                        ProjectData.ClearProjectError
                        Return &H708
                        ProjectData.ClearProjectError
                    End Try
                End If
                Return &H708
            End Get
        End Property

        Public Shared ReadOnly Property ConnectionString As String
            Get
                Return ConfigurationSettings.AppSettings.Item("connectionString")
            End Get
        End Property

        Public Shared ReadOnly Property FileLocation As String
            Get
                Return ConfigurationSettings.AppSettings.Item("fileLocation")
            End Get
        End Property

        Public Shared ReadOnly Property FtpFolder As String
            Get
                Return ConfigurationSettings.AppSettings.Item("ftpFolder")
            End Get
        End Property

        Public Shared ReadOnly Property FtpPassword As String
            Get
                Return ConfigurationSettings.AppSettings.Item("ftpPassword")
            End Get
        End Property

        Public Shared ReadOnly Property FtpServer As String
            Get
                Return ConfigurationSettings.AppSettings.Item("ftpServer")
            End Get
        End Property

        Public Shared ReadOnly Property FtpUserName As String
            Get
                Return ConfigurationSettings.AppSettings.Item("ftpUserName")
            End Get
        End Property

        Public Shared ReadOnly Property LogEmailTo As String
            Get
                Return ConfigurationSettings.AppSettings.Item("logEmailTo")
            End Get
        End Property

        Public Shared ReadOnly Property LogFile As String
            Get
                Dim text2 As String = ConfigurationSettings.AppSettings.Item("logFile")
                If (IIf(((Not text2 Is Nothing) AndAlso (text2.Length <> 0)), 1, 0) <> 0) Then
                    Return text2
                End If
                Return Path.Combine(Path.GetDirectoryName(Assembly.GetEntryAssembly.Location), "Import.log")
            End Get
        End Property

        Public Shared ReadOnly Property SmtpServer As String
            Get
                Dim text2 As String = ConfigurationSettings.AppSettings.Item("smtpServer")
                If (IIf(((Not text2 Is Nothing) AndAlso (text2.Length <> 0)), 1, 0) <> 0) Then
                    Return text2
                End If
                Return "localhost"
            End Get
        End Property

    End Class
End Namespace

