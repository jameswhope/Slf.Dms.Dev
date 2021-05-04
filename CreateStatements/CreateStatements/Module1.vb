Imports System
Imports System.IO
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Win32
Imports Microsoft.VisualBasic
Imports System.Security.Principal
Imports System.Security.Permissions
Imports System.IO.Compression
Imports ICSharpCode.SharpZipLib
Imports ICSharpCode
Imports System.Net
Imports EnterpriseDT
Imports EnterpriseDT.Net
Imports EnterpriseDT.Util
Imports System.Xml
Imports System.Configuration

Module Module1

#Region "Impersionation Functions and variables"

   Public Declare Auto Function LogonUser Lib "advapi32.dll" (ByVal lpszUsername As String, ByVal lpszDomain As String, ByVal lpszPassword As String, ByVal dwLogonType As Integer, ByVal dwLogonProvider As Integer, ByRef phToken As IntPtr) As Integer
   Public Declare Auto Function DuplicateToken Lib "advapi32.dll" (ByVal ExistingTokenHandle As IntPtr, ByVal ImpersonationLevel As Integer, ByRef DuplicateTokenHandle As IntPtr) As Integer
   Private LOGON32_LOGON_INTERACTIVE As Integer = 2
   Private LOGON32_PROVIDER_DEFAULT As Integer = 0
   Private moImpersonationContext As WindowsImpersonationContext
   Private Emaillog As Email

#End Region

#Region "Primary processing"

   Sub Main()

      'This process should be run in the SQL Agent after the stored procedure stp_BuildClientStatements has been run.
      'It is currently set to run against statements that are processed on the 1st - the 15th of every month and 
      'from the 16th to the End of the Month.

      Dim DoNotProcess As String = ""
      Dim Exceptions As String = ""
      Dim cnSQL As SqlConnection
      Dim cmSQL As SqlCommand
      Dim drSQL As SqlDataReader
      Dim dr As SqlDataReader
      Dim strSQL As String = ""
      Dim rptConn As SqlConnection
      Dim Folder As String
      Dim rMonth As String
      Dim sMonth As String
      Dim eMonth As String
      Dim Log As String = ""
      Dim x As Integer
      Dim y As Integer
      Dim CompanyID(0) As String
      Dim EOM As Date = DateSerial(Year(Now), Month(Now) + 1, 0)
      Dim transStartDate As Date
      Dim transEndDate As Date
      Dim f As StreamWriter
      Dim CalledFrom As Boolean
      Dim k As Integer
      Dim i As Integer
      Dim ZipFileName As String
      Dim ZipFileNames(3) As String
      Dim Path As String = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().GetName().CodeBase)
      Dim AccountNumber As String = ""
      Dim Host As String = ""
      Dim FTPUser As String = ""
      Dim FTPPwd As String = ""
      Dim TheSubject As String = "Successful"
      Dim DepositInfo As New List(Of String)
      Dim PmtDate As String
      Dim PmtAmount As String

      Dim aArgs As String = Command$()
      Dim split() As String = aArgs.Split(New [Char]() {"/"c})
      Dim cArgs(0) As String

      Dim s As String
      For Each s In split
         If s.Trim() <> "" Then
            If cArgs(0) = Nothing Then
               cArgs(0) = s
            Else
               ReDim Preserve cArgs(cArgs.Length)
               cArgs(cArgs.Length - 1) = s
            End If
         End If
      Next s
      If cArgs(0) Is Nothing Then
         '*****************************************
         'Validate run day
         'If Day(Now) <> 1 Or Day(Now) <> 16 Then
         'End
         'End If
         '*****************************************
         'Printer's Address and flags for production
         '/True /65.104.56.141 /DEBTMED /xh0uu3yt

         MsgBox("There is 1 mandatory command flag for this program, of the 4 and it's the first one. Each must be proceeded by a / forward slash." _
         & vbCrLf & vbCrLf & "1. /Command Line (True/False). /False - Show dialog boxes and messages. This is the required flag and it can only be True or False." _
         & vbCrLf & vbCrLf & "2. /Host: Either a URI or URL or IP address of the printer's FTP host." _
         & vbCrLf & vbCrLf & "3. /User Login to the FTP site." _
         & vbCrLf & vbCrLf & "4. /Password to the FTP site." _
         & vbCrLf & vbCrLf & "Command line example: " _
         & vbCrLf & vbCrLf & "CreateStatements.exe /False /127.0.0.1 /Login /Password" _
         & vbCrLf & vbCrLf & "The above result would be: " _
         & vbCrLf & vbCrLf & "Create, compress and upload files with user interaction required - /False = show dialogs, " _
         & "127.0.0.1 = remote address for upload - /Login - /Password." _
         & vbCrLf & vbCrLf & "1.) /False = When processing show messages. If you are going to run this process unattended you " _
         & vbCrLf & "must run with the first flag set to True. " _
         , MsgBoxStyle.Information, "Arguments are required.")
         End
         'Else
         'setup the defaults
         'CalledFrom = True  'Run from the command line
      End If

      For k = 0 To cArgs.Length - 1
         Select Case k
            Case 0
               If Trim(cArgs(k).ToLower) = "true" Then
                  CalledFrom = True
               Else
                  CalledFrom = False
               End If
            Case 1
               Host = Trim(cArgs(k).ToString)
            Case 2
               FTPUser = Trim(cArgs(k).ToString)
            Case 3
               FTPPwd = Trim(cArgs(k).ToString)
            Case Else 'default
               CalledFrom = True   'upload automatically, don't do it manually
         End Select
      Next k

      'Select the transactions for the period. Must go back one full month from the start date to today
      Dim TheStartDay As Int16
      Dim TheEndDay As Int16
      Dim StatementRunDay As String = TheStartDay
      Dim StatementMonth As String = DatePart(DateInterval.Month, Now)
      Dim StatementYear As String = Mid(DatePart(DateInterval.Year, Now), 3)

      'set the to and from dates for the report
      If DatePart(DateInterval.Day, Now) <= 15 Then
         TheStartDay = 1
         TheEndDay = 15
         StatementRunDay = "0" & CStr(TheStartDay)
         If Len(StatementMonth) = 1 Then
            StatementMonth = "0" & StatementMonth
         End If
         transStartDate = DateAdd(DateInterval.Day, -(DatePart(DateInterval.Day, Now) - 1), Now)
         transStartDate = DateAdd(DateInterval.Month, -1, transStartDate)
         transEndDate = DateAdd(DateInterval.Month, -1, EOM)
      Else
         TheStartDay = 16
         Select Case DatePart(DateInterval.Day, EOM)
            Case 31
               transEndDate = DateAdd(DateInterval.Day, -15, EOM)
               transStartDate = DateAdd(DateInterval.Month, -1, transEndDate)
               transStartDate = DateAdd(DateInterval.Day, -1, transStartDate)
            Case 30
               transEndDate = DateAdd(DateInterval.Day, -14, EOM)
               transStartDate = DateAdd(DateInterval.Month, -1, transEndDate)
               transStartDate = DateAdd(DateInterval.Day, -1, transStartDate)
            Case 29
               transEndDate = DateAdd(DateInterval.Day, -13, EOM)
               transStartDate = DateAdd(DateInterval.Month, -1, transEndDate)
               transStartDate = DateAdd(DateInterval.Day, -1, transStartDate)
            Case 28
               transEndDate = DateAdd(DateInterval.Day, -12, EOM)
               transStartDate = DateAdd(DateInterval.Month, -1, transEndDate)
               transStartDate = DateAdd(DateInterval.Day, -1, transStartDate)
         End Select
         TheEndDay = CInt(Day(EOM))
         StatementRunDay = CStr(TheStartDay)
         If Len(StatementMonth) = 1 Then
            StatementMonth = "0" & StatementMonth
         End If
      End If

      Dim StatementRun = StatementMonth & "/" & StatementRunDay & "/20" & StatementYear

      'set the months for the folder creation
      sMonth = Format(DateAdd(DateInterval.Month, 0, Now), "MMM")
      rMonth = Format(DateAdd(DateInterval.Month, 0, Now), "MMMM")
      eMonth = Format(DateAdd(DateInterval.Month, 0, Now), "MMM")

      transStartDate = Format(transStartDate, "MM/dd/yyyy")
      transEndDate = Format(transEndDate, "MM/dd/yyyy")

      ZipFileName = "\DMS_StatusRpt" & StatementMonth & StatementRunDay & StatementYear & ".zip"

      cnSQL = New SqlConnection
      rptConn = New SqlConnection

      Dim TodaysDate As String = Format(Now, "MM_dd_yyyy")

      'Get logged onto the server for storing the client statements on DC01 for now
      ImpersonateUser("MorningProcesses", "DMSI", "h0m3run!")

      '*********PRODUCTION PATH*****************************
      Dim BasePath As String = "\\DC01\d\Process\ClientStatements"
      '*********TEST PATH***********************************
      'Dim BasePath As String = "\\Dc01\d\Process\TestStatements"
      '****************************************************

      f = New StreamWriter(BasePath & "\StatementLogs_" & TodaysDate & ".log")
      f.WriteLine("Beginning the processing for Client Statements.......................................")

      f.WriteLine("**** BATCH Log started: " & Now() & vbCrLf & vbCrLf & "Payments due From: " & TheStartDay & " to " & TheEndDay & vbCrLf & vbCrLf)
      f.WriteLine("Activity Period Covered: " & transStartDate & " to " & transEndDate & vbCrLf & vbCrLf)
      f.WriteLine("Connecting to the databases." & vbCrLf)

      Try
         If cnSQL.State = ConnectionState.Open Then
            cnSQL.Close()
         End If

         '**************************PROD CONN**********************************
         cnSQL.ConnectionString = My.Settings.Item("ProductionConnString").ToString()
         cnSQL.Open()
         '**************************TEST CONN**********************************
         'cnSQL.ConnectionString = My.Settings.Item("TestingConnString").ToString()
         'cnSQL.Open()
         '*********************************************************************

         f.WriteLine("Production database opened. " & vbCrLf)
         f.WriteLine("Running the stored procedures. " & vbCrLf)

         If CalledFrom = False Then
            Dim answer As Integer = MsgBox("Have you run stp_ClientStatementBuilder?", MsgBoxStyle.Question + MsgBoxStyle.YesNo, "Run the procedure?")
            If answer = vbNo Then
               MsgBox("Please run the stored procedure stp_ClientStatementBuilder before running this program.", , "Run the procedure.")
               f.Close()
               End
            End If
         End If
      Catch ex As Exception
         f.WriteLine("Errors were encountered connecting to the database" & vbCrLf & ex.Message & Now & vbCrLf)
         If CalledFrom = False Then
            MsgBox("Unable to connect to the database. " & ex.Message)
         End If
         f.WriteLine("Stopped on error.....")
         'Write out the log file
         f.WriteLine("Program ended prematurely. " & Now)
         f.Close()
         TheSubject = "Failed"
         GoTo CleanUp
      End Try

      Try
         'Create the Folder for all the output*********************************************************
         If Not Directory.Exists(BasePath & "\Client_Stmts_" & sMonth & TheStartDay & "_" & eMonth & TheEndDay) Then
            Directory.CreateDirectory(BasePath & "\Client_Stmts_" & sMonth & TheStartDay & "_" & eMonth & TheEndDay)
            Folder = BasePath & "\Client_Stmts_" & sMonth & TheStartDay & "_" & eMonth & TheEndDay
         Else
            Folder = BasePath & "\Client_Stmts_" & sMonth & TheStartDay & "_" & eMonth & TheEndDay
         End If

      Catch ex As Exception
         f.WriteLine("Could not create the output folder. Process stopped." & ex.Message & Now & vbCrLf)
         f.WriteLine("Stopped on error.....")
         'Write out the log file
         f.WriteLine("Program ended prematurely. " & Now)
         f.Close()
         TheSubject = "Failed"
         GoTo CleanUp
      End Try

      Try
         strSQL = "SELECT CompanyID from tblCompany ORDER BY CompanyID"
         cmSQL = New SqlCommand(strSQL, cnSQL)
         x = 0
         drSQL = cmSQL.ExecuteReader
         If drSQL.HasRows Then
            Do While drSQL.Read()
               x += 1
               ReDim CompanyID(x - 1)
            Loop
            drSQL.Close()
         End If
         drSQL = cmSQL.ExecuteReader
         For x = 0 To CompanyID.Length - 1
            drSQL.Read()
            CompanyID(x) = drSQL.Item(0).ToString
         Next
         drSQL.Close()
      Catch ex As Exception
         drSQL.Close()
      End Try

      Try 'CLIENT NAMES AND ADDRESSES FILE
         'Open the tables for IO to the comma and pipe delimited file
         f.WriteLine("Opening the Client tables for reading." & vbCrLf)
         strSQL = "SELECT * FROM tblStatementPersonal ORDER BY accountnumber"

         cmSQL = New SqlCommand(strSQL, cnSQL)

         drSQL = cmSQL.ExecuteReader

         If drSQL.HasRows Then
            'If the file exists then overwrite it
            Dim fs As New FileInfo(Folder & "\DMS_StatusRpt_Personal_" & rMonth & ".txt")
            If fs.Exists Then
               fs.Delete()
            End If
            'Open the file for writing
            Using sw As StreamWriter = New StreamWriter(Folder & "\DMS_StatusRpt_Personal_" & rMonth & ".txt")
               f.WriteLine("Creating the Client csv file " & Folder & "\DMS_StatusRpt_Personal_" & rMonth & ".txt" & vbCrLf)
               f.WriteLine("Writing the Client data to the output file." & vbCrLf)
               While drSQL.Read()
                  'Check for nulls in the Deposit amount
                  AccountNumber = drSQL.Item(1).ToString
                  If drSQL.Item("DepAmt") Is DBNull.Value Then
                     'This is an exception don't write it out note it
                     DoNotProcess = DoNotProcess & drSQL.Item(1) & " - " & drSQL.Item(3).ToString & vbCrLf
                     GoTo NextRecord
                  End If
                  If drSQL.Item("DepAmt") <= 0 Then
                     'This is an exception don't write it out just note it
                     DoNotProcess = DoNotProcess & drSQL.Item(1) & " - " & drSQL.Item(3).ToString & vbCrLf
                     GoTo NextRecord
                  End If

                  '**************************More testing stuff*********************************
                  'TheStartDay = 1
                  '*************************************************************************

                  ' Get the multi deposit information if any, everynone will ultimatly be on this schedule currently not
                  Dim cn As New SqlConnection(cnSQL.ConnectionString.ToString)
                  strSQL = "SELECT DepositDay, DepositAmount, DepositMethod FROM tblClientDepositDay " _
                     & "WHERE ClientId = " & drSQL.Item(0) & " AND DeletedDate IS NULL ORDER BY DepositDay ASC"
                  Using cmd As New SqlCommand(strSQL, cn)
                     cmd.Connection.Open()
                     cmd.CommandTimeout = 180
                     dr = cmd.ExecuteReader
                  End Using

                  'If there is data then this is a multi deposit client.
                  If dr.HasRows Then
                     DepositInfo = GetPmts(dr, TheStartDay)
                  Else 'Otherwise this is not a multi deposit client
                     DepositInfo.Add(drSQL.Item(9).ToString & "|,|" & Format(drSQL.Item(10), "0.00"))
                     For x = 1 To 3
                        DepositInfo.Add(" |,| ")
                     Next
                  End If
                  dr.Close()
                  'Strip the first deposit date and amount
                  PmtDate = ""
                  PmtAmount = 0
                  split = DepositInfo(0).Split(New [Char]() {"|"c, "|,"})
                  For Each w As String In split
                     If w.Trim() <> "" Then
                        If PmtDate = "" Then
                           PmtDate = w
                        Else
                           PmtAmount = w
                        End If
                     End If
                  Next

                  ' Add the fields to the text file.
                  x = 0
                  y = 100 / 19
                  For x = 0 To 19
                     Select Case x
                        Case 1 To 7
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                        Case 8
                           'This statement is now in the table for direct use.
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                        Case 9
                           sw.Write("|" & PmtDate.ToString & "|,")
                        Case 10
                           sw.Write("|" & PmtAmount & "|,")
                        Case 11
                           sw.Write("|" & Format(drSQL.Item(x), "0") & "|,")
                        Case 12 To 16
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                        Case 17
                           sw.Write("|" & Format(Val(drSQL.Item(x).ToString), "(###) ###-####") & "|,")
                        Case 18
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                        Case 19
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                           'Add additional fields to the text file for multi deposit clients
                           For i = 0 To 3
                              If i <= 2 Then
                                 sw.Write("|" & DepositInfo(i).ToString & "|,")
                              Else
                                 sw.Write("|" & DepositInfo(i).ToString & "|" & vbCrLf)
                              End If
                              DepositInfo(i) = " "
                           Next i
                           i = 0
                           DepositInfo.Clear()
                     End Select
                  Next
                  PmtDate = ""
                  PmtAmount = ""
                  AccountNumber = " "
                  cn.Close()
NextRecord:
               End While
               sw.Close()
               f.WriteLine("**** CLIENT file written out: " & Now & vbCrLf)
            End Using

            'Begin building the files for the zip file
            ZipFileNames(0) = Folder & "\DMS_StatusRpt_Personal_" & rMonth & ".txt"
         Else
            drSQL.Close()
            f.WriteLine("No Client files were found in the table meeting this criteria." & Now & vbCrLf)
         End If
         'Close the dataReader
         drSQL.Close()
      Catch ex As Exception
         drSQL.Close()
         f.WriteLine("Errors were encountered in the client files " & vbCrLf & ex.Message & Now & vbCrLf)
         TheSubject = "Failed"
         GoTo CleanUp
         ExceptionHandler(3, AccountNumber, "Client", StatementRun)
      End Try

      Try 'CLIENT TRANSACTIONS FOR THE PERIOD
         'Now write the Client transaction files out
         Dim CompareAccountNo As String = ""

         f.WriteLine("Opening the Client transaction tables for reading." & vbCrLf)

         strSQL = "SELECT AccountNumber, TransactionDate, EntryTypeName, Amount, SDABalance, PFOBalance " _
         & "FROM tblStatementResults " _
         & "WHERE (TransactionDate >= '" & transStartDate & "') AND (TransactionDate <= '" & transEndDate & "') " _
         & "ORDER BY AccountNumber, TransactionDate"

         cmSQL = New SqlCommand(strSQL, cnSQL)

         drSQL = cmSQL.ExecuteReader

         If drSQL.HasRows Then
            'If the file exists then overwrite it
            Dim fs As New FileInfo(Folder & "\DMS_StatusRpt_Trans_" & rMonth & ".txt")
            If fs.Exists Then
               fs.Delete()
            End If
            'Open the file for writing
            Using sw As StreamWriter = New StreamWriter(Folder & "\DMS_StatusRpt_Trans_" & rMonth & ".txt")
               f.WriteLine("Creating the client transaction csv file " & Folder & "\DMS_StatusRpt_Trans_" & rMonth & ".txt" & vbCrLf)
               f.WriteLine("Writing the data to the client transaction file." & vbCrLf)
               While drSQL.Read()
                  'If the PFO account is less than 0 create an exception and do not process the record
                  If drSQL.Item("pfobalance") < 0 Then
                     AccountNumber = drSQL.Item("AccountNumber").ToString
                     If AccountNumber <> CompareAccountNo Then
                        DoNotProcess = DoNotProcess & vbCrLf & "EXCEPTION---->Account: " & drSQL.Item("AccountNumber").ToString & " has a negative PFO Balance in the transaction file. An entry for the statement was not created." & vbCrLf
                        ExceptionHandler(4, AccountNumber, "Client", StatementRun)
                        CompareAccountNo = AccountNumber
                        AccountNumber = ""
                     End If
                  Else
                     ' Add the fields to the file.
                     x = 0
                     y = 100 / 5
                     For x = 0 To 5
                        Select Case x
                           Case 0, 2
                              sw.Write("|" & drSQL.Item(x).ToString & "|,")
                           Case 1
                              sw.Write("|" & Format(drSQL.Item(x), "d") & "|,")
                           Case 3, 4
                              sw.Write("|" & Format(drSQL.Item(x), "0.00") & "|,")
                           Case 5
                              sw.Write("|" & Format(drSQL.Item(x), "0.00") & "|" & vbCrLf)
                        End Select
                     Next
                  End If
               End While
               sw.Close()
               f.WriteLine("**** TRANSACTION file written out.: " & Now & vbCrLf)
            End Using
         Else
            drSQL.Close()
            f.WriteLine("No Client transactions were found in the table meeting this criteria." & Now & vbCrLf)
            ExceptionHandler(5, 0, "Client", StatementRun)
         End If
         'Close the dataReader
         drSQL.Close()
      Catch ex As Exception
         drSQL.Close()
         If CalledFrom = False Then
            MsgBox(ex.Message)
         End If
         f.WriteLine("Errors were encountered in the transaction files " & vbCrLf & ex.Message & Now & vbCrLf)
         f.Close()
         ExceptionHandler(5, 0, "Client", StatementRun)
         TheSubject = "Failed"
         GoTo CleanUp
      End Try

      'Continue adding the files to the zip file
      ZipFileNames(1) = Folder & "\DMS_StatusRpt_Trans_" & rMonth & ".txt"

      Try 'CREDITOR OUTPUT
         'Write out the creditor file
         strSQL = "SELECT * FROM tblStatementCreditor WHERE Acct_No IS NOT NULL ORDER BY Acct_No"

         cmSQL = New SqlCommand(strSQL, cnSQL)

         drSQL = cmSQL.ExecuteReader

         If drSQL.HasRows Then
            'If the file exists then overwrite it
            Dim fs As New FileInfo(Folder & "\DMS_StatusRpt_Creditors_" & rMonth & ".txt")
            If fs.Exists Then
               fs.Delete()
            End If
            'Open the file for writing
            Using sw As StreamWriter = New StreamWriter(Folder & "\DMS_StatusRpt_Creditors_" & rMonth & ".txt")
               f.WriteLine("Creating the creditor csv file " & Folder & "\DMS_StatusRpt_Creditors_" & rMonth & ".txt" & vbCrLf)
               f.WriteLine("Writing the data to the creditor file." & vbCrLf)
               While drSQL.Read()
                  AccountNumber = drSQL.Item("Acct_No").ToString
                  ' Add the fields to the file.
                  x = 0
                  y = 100 / 4
                  For x = 0 To 4
                     Select Case x
                        Case 0 To 3
                           sw.Write("|" & drSQL.Item(x).ToString & "|,")
                        Case 4
                           sw.Write("|" & Format(drSQL.Item(x), "0.00") & "|" & vbCrLf)
                     End Select
                     AccountNumber = ""
                  Next
               End While
               sw.Close()
               f.WriteLine("**** CREDITOR file written out: " & Now & vbCrLf)
            End Using
         Else
            drSQL.Close()
            f.WriteLine("No Creditor files were found in the table meeting this criteria." & Now & vbCrLf)
            ExceptionHandler(6, AccountNumber, "Creditor", StatementRun)
         End If
         'Close the dataReader
         drSQL.Close()

         'Continue adding the files to the zip file
         ZipFileNames(2) = Folder & "\DMS_StatusRpt_Creditors_" & rMonth & ".txt"

         'MESSAGE file
         Using ms As StreamWriter = New StreamWriter(Folder & "\DMS_StatusRpt_Message_" & rMonth & ".txt")
            f.WriteLine("Creating the message file " & Folder & "\DMS_StatusRpt_Message_" & rMonth & ".txt" & vbCrLf)
            f.WriteLine("Writing the data to the Message file." & vbCrLf)
            For x = 0 To CompanyID.Length - 1
               ms.WriteLine("|" & CompanyID(x) & "|,|" & "|")
            Next x
            ms.Close()
            f.WriteLine("**** MESSAGE file written out: " & Now & vbCrLf)
            f.WriteLine("Cleaning up..." & vbCrLf)
         End Using
         'Let them know we're done here
         f.WriteLine("File(s) created and process finished." & vbCrLf)
         f.WriteLine("**** BATCH completed ..." & Now & vbCrLf)
         f.WriteLine("Finished!!")
      Catch ex As Exception
         f.WriteLine("Errors were encountered in the creditor files " & vbCrLf & ex.Message & Now & vbCrLf)
         Exceptions = Exceptions & "**ERRORS were encountered.** "
         ExceptionHandler(6, 0, "General", StatementRun)
      End Try
      cnSQL.Close()
NameZip:
      'Finish the zip file
      ZipFileNames(3) = Folder & "\DMS_StatusRpt_Message_" & rMonth & ".txt"
CompressFile:
      Try
         CompressFile(ZipFileNames, Folder & ZipFileName, StatementRun)
      Catch ex As Exception
         ExceptionHandler(11, 0, "General error.", StatementRun)
         TheSubject = "Failed"
         GoTo CleanUp
      End Try
FTP:
      If Host <> "" And FTPUser <> "" And FTPPwd <> "" Then
         Try
            'Ftp the file up to the printer
            FTPFileToPrinter(Host, FTPUser, FTPPwd, Folder & ZipFileName, Mid(ZipFileName, 2), StatementRun)
            f.WriteLine("Files compressed and sent to printer at: " & Now)
         Catch ex As Exception
            ExceptionHandler(12, 0, "FTP Failed", StatementRun)
            Using lw As StreamWriter = New StreamWriter(Folder & "\Statement builder logs_" & rMonth & ".txt")
               lw.WriteLine(Log)
               lw.Close()
            End Using
            TheSubject = "Failed"
            GoTo CleanUp
         End Try
      End If

      'Write out the log file
      Using lw As StreamWriter = New StreamWriter(Folder & "\Statement builder logs_" & rMonth & ".txt")
         If Exceptions <> "" Then
            Log = Log & Exceptions & vbCrLf & Exceptions & vbCrLf & vbCrLf
            If DoNotProcess <> "" Then
               Log = Log & vbCrLf & vbCrLf & "EXCEPTIONS:" & vbCrLf & vbCrLf & "***Deposit Amount was <= 0:***" & vbCrLf & vbCrLf & DoNotProcess
               f.WriteLine(Log)
            End If
         Else
            If DoNotProcess <> "" Then
               Log = Log & vbCrLf & vbCrLf & "EXCEPTIONS:" & vbCrLf & vbCrLf & "***Deposit Amount was < 0:***" & vbCrLf & vbCrLf & DoNotProcess
               f.WriteLine(Log)
            End If
         End If
         lw.WriteLine(Log)
         lw.Close()
      End Using
      'Store the data on the run
CleanUp:
      'Clean up and get out
      cnSQL.Close()
      If Not drSQL Is Nothing Then
         drSQL.Close()
      End If
      If Not cmSQL Is Nothing Then
         cmSQL.Dispose()
      End If
      f.Close()
      undoImpersonation()
      Emaillog = New Email
      Emaillog.To = "cnott@lexxiom.com"
      Emaillog.From = "ClientStatements@Lexxiom.com"
      Emaillog.Subject = "Client Statements for: " & Now
      Emaillog.Attach = BasePath & "\StatementLogs_" & TodaysDate & ".log"
      Emaillog.Body = "The Client statement creation and upload results were " & TheSubject & ". Logs attached."
      Emaillog.SmtpServer = "DC02"
      '********************************************************************************
      'Emaillog.Send()
Bye:
   End Sub

#End Region

#Region "Impersonation"

   Public Function ImpersonateUser(ByVal userName As String, ByVal domain As String, ByVal password As String) As Boolean
      '------------------------------------------------
      'PURPOSE: Impersonate a specific user
      'INPUTS: username(str), domain (str), pwd(str)
      'OUTPUTS: Boolean
      '------------------------------------------------
      Try
         Dim otempWindowsIdentity As WindowsIdentity
         Dim token As IntPtr
         Dim tokenDuplicate As IntPtr
         If LogonUser(userName, domain, password, LOGON32_LOGON_INTERACTIVE, _
         LOGON32_PROVIDER_DEFAULT, token) <> 0 Then
            If DuplicateToken(token, 2, tokenDuplicate) <> 0 Then
               otempWindowsIdentity = New WindowsIdentity(tokenDuplicate)
               moImpersonationContext = otempWindowsIdentity.Impersonate()
               If moImpersonationContext Is Nothing Then
                  ImpersonateUser = False
               Else
                  ImpersonateUser = True
               End If
            Else
               ImpersonateUser = False
            End If
         Else
            ImpersonateUser = False
         End If
      Catch ex As Exception
         Throw New System.Exception("Error Occurred in ImpersonateUser() : " & ex.ToString)
      End Try
   End Function

   Public Sub undoImpersonation()
      '------------------------------------------------
      'PURPOSE: Undo the impersonation
      'INPUTS: None
      'OUTPUTS: None
      '------------------------------------------------

      Try
         moImpersonationContext.Undo()
      Catch ex As Exception
         Throw New System.Exception("Error Occurred in undoImpersonation() : " & ex.ToString)
      End Try

   End Sub

#End Region

#Region "Compression"

   Public Sub CompressFile(ByVal sourceFile() As String, ByVal destinationFile As String, ByVal PeriodCovered As String)
      Dim crc As New ICSharpCode.SharpZipLib.Checksums.Crc32()
      Dim s As New Zip.ZipOutputStream(File.Create(destinationFile))

      Try
         s.SetLevel(9)
         For i As Integer = 0 To sourceFile.Length - 1
            ' 0 - store only to 9 - means best compression 

            ' Must use a relative path here so that files show up in the Windows Zip File Viewer 
            Dim entry As New Zip.ZipEntry(Path.GetFileName(sourceFile(i)))
            entry.DateTime = DateTime.Now

            ' Read in the 
            Using fs As FileStream = File.OpenRead(sourceFile(i))

               Dim buffer As Byte() = New Byte(fs.Length - 1) {}
               fs.Read(buffer, 0, buffer.Length)

               entry.Size = fs.Length
               fs.Close()

               crc.Reset()
               crc.Update(buffer)
               entry.Crc = crc.Value
               s.PutNextEntry(entry)
               s.Write(buffer, 0, buffer.Length)
            End Using
         Next
         ExceptionHandler(9, 0, "Compression", PeriodCovered)
      Catch ex As Exception
         ExceptionHandler(11, 0, "Compression", PeriodCovered)
      Finally
         s.Finish()
         s.Close()
      End Try
   End Sub

   Public Sub DecompressFile(ByVal sourceFile As String, ByVal destinationFile As String)

      ' make sure the source file is there
      If File.Exists(sourceFile) = False Then
         Throw New FileNotFoundException
      End If

      ' Create the streams and byte arrays needed
      Dim sourceStream As FileStream = Nothing
      Dim destinationStream As FileStream = Nothing
      Dim decompressedStream As GZipStream = Nothing
      Dim quartetBuffer As Byte() = Nothing

      Try
         ' Read in the compressed source stream
         sourceStream = New FileStream(sourceFile, FileMode.Open)

         ' Create a compression stream pointing to the destination stream
         decompressedStream = New GZipStream(sourceStream, CompressionMode.Decompress, True)

         ' Read the footer to determine the length of the destination file
         quartetBuffer = New Byte(4) {}
         Dim position As Integer = CType(sourceStream.Length, Integer) - 4
         sourceStream.Position = position
         sourceStream.Read(quartetBuffer, 0, 4)
         sourceStream.Position = 0
         Dim checkLength As Integer = BitConverter.ToInt32(quartetBuffer, 0)

         Dim buffer(checkLength + 100) As Byte
         Dim offset As Integer = 0
         Dim total As Integer = 0

         ' Read the compressed data into the buffer
         While True
            Dim bytesRead As Integer = decompressedStream.Read(buffer, offset, 100)
            If bytesRead = 0 Then
               Exit While
            End If
            offset += bytesRead
            total += bytesRead
         End While

         ' Now write everything to the destination file
         destinationStream = New FileStream(destinationFile, FileMode.Create)
         destinationStream.Write(buffer, 0, total)

         ' and flush everything to clean out the buffer
         destinationStream.Flush()

      Catch ex As ApplicationException
         'MessageBox.Show(ex.Message, "An Error occured during compression", MessageBoxButtons.OK, MessageBoxIcon.Error)
      Finally
         ' Make sure we always close all streams
         If Not (sourceStream Is Nothing) Then
            sourceStream.Close()
         End If
         If Not (decompressedStream Is Nothing) Then
            decompressedStream.Close()
         End If
         If Not (destinationStream Is Nothing) Then
            destinationStream.Close()
         End If
      End Try

   End Sub

#End Region

#Region "Exception Handler"

   Private Sub ExceptionHandler(ByVal ErrorCode As Integer, ByVal AccountNumber As Integer, ByVal ExceptionType As String, ByVal PeriodCovered As String)
      Dim cnH As SqlConnection
      Dim CmdH As SqlCommand
      Dim drH As SqlDataReader
      Dim ReasonH As String = ""


      cnH = New SqlConnection
      '*******TEST Connection string ******************
      'cnH.ConnectionString = My.Settings.Item("TestingConnString").ToString()
      '*******************************************
      cnH.ConnectionString = My.Settings.Item("ProductionConnString").ToString()

      If cnH.State = ConnectionState.Closed Then
         cnH.Open()
      End If

      Dim strSQL As String = "SELECT ExceptionReason FROM tblStatementExceptionReasons WHERE ExceptionReasonID = " & ErrorCode

      Try
         CmdH = New SqlCommand(strSQL, cnH)
         drH = CmdH.ExecuteReader
         If drH.HasRows Then
            drH.Read()
            ReasonH = drH.Item(0).ToString
         End If
         drH.Close()

         strSQL = "INSERT INTO tblStatementExceptions (ExceptionDate, AccountNumber, " _
         & "ExceptionReasonID, ExceptionReason, ExceptionType, Created, CreatedBy, Modified, ModifiedBy, PeriodCovered) " _
         & "VALUES ('" & Now & "', " & AccountNumber & ", " & ErrorCode & ", '" & ReasonH & "', '" & ExceptionType & "', '" _
         & Now & "', " & 24 & ", '" & Now & "', " & 24 & ", '" & PeriodCovered & "')"

         CmdH = New SqlCommand(strSQL, cnH)

         CmdH.ExecuteNonQuery()


      Catch ex As Exception

      Finally
         If cnH.State = ConnectionState.Open Then
            cnH.Close()
         End If
         CmdH.Dispose()
      End Try

   End Sub

#End Region

#Region "FTP processing"

   Private Sub FTPFileToPrinter(ByVal Host As String, ByVal FTPUser As String, ByVal FTPPwd As String, ByVal LocalFile As String, ByVal RemoteFile As String, ByVal PeriodCovered As String)
      Dim ftp As Ftp.FTPClient = Nothing

      Try
         ftp = New Ftp.FTPClient()
         ftp.RemoteHost = Host
         ftp.Connect()
         ftp.User(FTPUser)
         ftp.Password(FTPPwd)
         ftp.ConnectMode = EnterpriseDT.Net.Ftp.FTPConnectMode.PASV
         ftp.TransferType = EnterpriseDT.Net.Ftp.FTPTransferType.BINARY

         Dim files As Array = ftp.Dir(".", True)
         Dim i As Integer = 0
         Dim FileName As String
         While i < files.Length
            FileName = files(i).ToString()
            If FileName.Contains(RemoteFile.ToString) Then
               ftp.Delete(RemoteFile.ToString)
            End If
            i += 1
         End While

         ftp.Put(LocalFile, RemoteFile)

         files = ftp.Dir(".", True)
         i = 0
         While i < files.Length
            FileName = files(i).ToString()
            If FileName.Contains(RemoteFile.ToString) Then
               ExceptionHandler(10, 0, "FTP Transfer", PeriodCovered)
            End If
            i += 1
         End While
         'ExceptionHandler(10, 0, "FTP Transfer", PeriodCovered)
      Catch ex As Exception
         ExceptionHandler(11, 0, "FTP Transfer", PeriodCovered)
      Finally

         ftp.Quit()
      End Try
   End Sub

#End Region

#Region "MultiDeposit Processing"

   Private Function GetPmts(ByVal dr As SqlDataReader, ByVal StmtDay As Integer) As List(Of String)
      'for now it's the 1st-15th and 16th-EOM

      Dim dMonth As String = ""
      Dim dYear As Integer
      Dim NewPmtDate As String
      Dim PmtDates As New List(Of String)
      Dim i As Integer
      Try
         Dim SortedDays(,) As String = SortTheDays(dr, StmtDay)

         For i = 0 To (SortedDays.Length / 2) - 1
            If SortedDays(i, 0) <> Nothing Then
               If StmtDay = 16 Then 'From the 1st of next month through the end of next month
                  dMonth = GetTheMonth(Month(DateAdd(DateInterval.Month, 1, Now)))
                  If DatePart(DateInterval.Month, Now) = 12 Then
                     dYear = DatePart(DateInterval.Year, DateAdd(DateInterval.Month, 1, Now))
                  Else
                     dYear = DatePart(DateInterval.Year, Now)
                  End If
               End If

               If StmtDay = 1 Then 'Break the months apart 16th of this month to the 15th of next
                  If SortedDays(i, 0) >= 15 Then
                     dMonth = GetTheMonth(Month(DateAdd(DateInterval.Month, 1, Now)))
                     If DatePart(DateInterval.Month, Now) = 12 Then
                        dYear = DatePart(DateInterval.Year, DateAdd(DateInterval.Month, 1, Now))
                     Else
                        dYear = DatePart(DateInterval.Year, Now)
                     End If
                  Else
                     dMonth = GetTheMonth(Month(Now))
                     dYear = DatePart(DateInterval.Year, Now)
                  End If
               End If

               NewPmtDate = dMonth.ToString & " " & SortedDays(i, 0).ToString & ", " & dYear.ToString & "|,|" & Format(CDbl(SortedDays(i, 1)), "0.00")
               PmtDates.Add(NewPmtDate)
            End If
         Next

         If PmtDates.Count <> 4 Then
            For i = PmtDates.Count To 3
               PmtDates.Add(" |,| ")
            Next
         End If

         Return PmtDates
      Catch ex As Exception

      End Try
   End Function

   Private Function GetTheMonth(ByVal month As Integer) As String
      Select Case month
         Case 1
            Return "Jan"
         Case 2
            Return "Feb"
         Case 3
            Return "Mar"
         Case 4
            Return "Apr"
         Case 5
            Return "May"
         Case 6
            Return "Jun"
         Case 7
            Return "Jul"
         Case 8
            Return "Aug"
         Case 9
            Return "Sep"
         Case 10
            Return "Oct"
         Case 11
            Return "Nov"
         Case 12
            Return "Dec"
         Case Else
            Return "Oops"
      End Select
   End Function

   Private Function SortTheDays(ByVal dr As SqlDataReader, ByVal StmtDay As Integer) As String(,)
      Dim unSorted(3, 1) As String
      Dim Sorted(3, 1) As String
      Dim i As Integer = 0

      Do While dr.Read
         unSorted(i, 0) = dr.Item("DepositDay").ToString
         unSorted(i, 1) = dr.Item("DepositAmount").ToString
         i += 1
      Loop

      For i = 0 To (unSorted.Length / 2) - 1
         If unSorted(i, 0) >= StmtDay And unSorted(i, 0) <> Nothing Then
            Sorted(i, 0) = unSorted(i, 0)
            Sorted(i, 1) = unSorted(i, 1)
         End If
         If unSorted(i, 0) < StmtDay And unSorted(i, 0) <> Nothing Then
            Sorted(i, 0) = unSorted(i, 0)
            Sorted(i, 1) = unSorted(i, 1)
         End If
      Next

      Return Sorted
   End Function

   Private Function BuildTheReport(ByVal dr As SqlDataReader) As DataSet
      Return StatementDataHelper.convertDataReaderToDataSet(dr)
   End Function

   Private Function CreateReport(ByVal dr As SqlDataReader) As String

      Try
         Dim NewDs As DataSet = BuildTheReport(dr)
         Dim strBldr As New System.Text.StringBuilder
         Dim xmlDocument As Xml.XmlDataDocument = New Xml.XmlDataDocument(NewDs)
         Dim xslCompTran As Xsl.XslCompiledTransform = New Xsl.XslCompiledTransform

         xslCompTran.Load(System.Configuration.ConfigurationSettings.AppSettings("ImportXsltPath").ToString() & "XSLTMultiDeposit.xslt")

         Dim ms As New System.IO.MemoryStream
         Dim sr As System.IO.StreamReader

         xslCompTran.Transform(xmlDocument, Nothing, ms)
         sr = New System.IO.StreamReader(ms, System.Text.Encoding.UTF8)
         ms.Position = 0
         strBldr.Append(sr.ReadToEnd)

         If Not sr Is Nothing Then sr.Close()
         If Not ms Is Nothing Then ms.Close()

         Return strBldr.ToString()
      Catch ex As Exception
         Dim result As String
         result += "</td><td>" & Now & ": " & "Creating and shipping the client statements was successful, but there was an error creating the log report. Please notify IT......."
      End Try
   End Function

#End Region

End Module
