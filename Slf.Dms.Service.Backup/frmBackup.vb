'Option Explicit On 

'Imports Drg.Util.Helpers
'Imports Drg.Util.DataAccess

''Imports EnterpriseDT.Net.Ftp
'Imports Xceed.Ftp

'Imports ICSharpCode.SharpZipLib.zip
'Imports ICSharpCode.SharpZipLib.Checksums

'Imports System.Configuration
'Imports System.Windows.Forms

'Public Class frmBackup
'    Inherits System.Windows.Forms.Form

'#Region "Variables"

'    Private _sqlserver As String = ConfigurationManager.AppSettings("_sqlserver")
'    Private _sqlusername As String = ConfigurationManager.AppSettings("_sqlusername")
'    Private _sqlpassword As String = ConfigurationManager.AppSettings("_sqlpassword")

'    Private _log As String = ConfigurationManager.AppSettings("log")
'    Private _temp As String = ConfigurationManager.AppSettings("temp")
'    Private _dir As String = ConfigurationManager.AppSettings("directory")

'    Private _size As Long = 0

'    'Private WithEvents _ftp As New EnterpriseDT.Net.Ftp.Pro.ProFTPClient
'    Private WithEvents _ftp As New Xceed.Ftp.FtpClient

'    Private WithEvents _tmr As New Timer

'#End Region

'#Region "Delegates"

'    Public Delegate Sub DelegatePutProgress(ByVal pctDone As Integer)

'#End Region

'#Region " Windows Form Designer generated code "

'    Public Sub New()
'        MyBase.New()

'        'This call is required by the Windows Form Designer.
'        InitializeComponent()

'        'Add any initialization after the InitializeComponent() call

'    End Sub

'    'Form overrides dispose to clean up the component list.
'    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
'        If disposing Then
'            If Not (components Is Nothing) Then
'                components.Dispose()
'            End If
'        End If
'        MyBase.Dispose(disposing)
'    End Sub

'    'Required by the Windows Form Designer
'    Private components As System.ComponentModel.IContainer

'    'NOTE: The following procedure is required by the Windows Form Designer
'    'It can be modified using the Windows Form Designer.  
'    'Do not modify it using the code editor.
'    Friend WithEvents pbUpload As System.Windows.Forms.ProgressBar
'    Friend WithEvents Label1 As System.Windows.Forms.Label
'    Friend WithEvents Label2 As System.Windows.Forms.Label
'    Friend WithEvents Label5 As System.Windows.Forms.Label
'    Friend WithEvents pbTotal As System.Windows.Forms.ProgressBar
'    Friend WithEvents lblCurrentDB As System.Windows.Forms.Label
'    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
'    Friend WithEvents lblCurrentStatus As System.Windows.Forms.Label
'    Friend WithEvents lblTransfrerredLable As System.Windows.Forms.Label
'    Friend WithEvents lblTransferred As System.Windows.Forms.Label
'    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
'        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmBackup))
'        Me.pbUpload = New System.Windows.Forms.ProgressBar
'        Me.Label1 = New System.Windows.Forms.Label
'        Me.Label2 = New System.Windows.Forms.Label
'        Me.pbTotal = New System.Windows.Forms.ProgressBar
'        Me.Label5 = New System.Windows.Forms.Label
'        Me.lblCurrentDB = New System.Windows.Forms.Label
'        Me.lblCurrentStatus = New System.Windows.Forms.Label
'        Me.PictureBox1 = New System.Windows.Forms.PictureBox
'        Me.lblTransfrerredLable = New System.Windows.Forms.Label
'        Me.lblTransferred = New System.Windows.Forms.Label
'        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
'        Me.SuspendLayout()
'        '
'        'pbUpload
'        '
'        Me.pbUpload.Location = New System.Drawing.Point(10, 182)
'        Me.pbUpload.Name = "pbUpload"
'        Me.pbUpload.Size = New System.Drawing.Size(486, 16)
'        Me.pbUpload.TabIndex = 0
'        '
'        'Label1
'        '
'        Me.Label1.Location = New System.Drawing.Point(12, 136)
'        Me.Label1.Name = "Label1"
'        Me.Label1.Size = New System.Drawing.Size(100, 15)
'        Me.Label1.TabIndex = 1
'        Me.Label1.Text = "Current Status:"
'        '
'        'Label2
'        '
'        Me.Label2.Location = New System.Drawing.Point(12, 121)
'        Me.Label2.Name = "Label2"
'        Me.Label2.Size = New System.Drawing.Size(100, 15)
'        Me.Label2.TabIndex = 2
'        Me.Label2.Text = "Current Database:"
'        '
'        'pbTotal
'        '
'        Me.pbTotal.Location = New System.Drawing.Point(10, 204)
'        Me.pbTotal.Name = "pbTotal"
'        Me.pbTotal.Size = New System.Drawing.Size(486, 25)
'        Me.pbTotal.TabIndex = 3
'        '
'        'Label5
'        '
'        Me.Label5.BackColor = System.Drawing.Color.White
'        Me.Label5.Font = New System.Drawing.Font("Tahoma", 21.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
'        Me.Label5.Location = New System.Drawing.Point(5, 5)
'        Me.Label5.Name = "Label5"
'        Me.Label5.Size = New System.Drawing.Size(365, 40)
'        Me.Label5.TabIndex = 14
'        Me.Label5.Text = "DMS Data Backup"
'        '
'        'lblCurrentDB
'        '
'        Me.lblCurrentDB.ForeColor = System.Drawing.SystemColors.ActiveCaption
'        Me.lblCurrentDB.Location = New System.Drawing.Point(112, 121)
'        Me.lblCurrentDB.Name = "lblCurrentDB"
'        Me.lblCurrentDB.Size = New System.Drawing.Size(208, 15)
'        Me.lblCurrentDB.TabIndex = 17
'        '
'        'lblCurrentStatus
'        '
'        Me.lblCurrentStatus.ForeColor = System.Drawing.SystemColors.ActiveCaption
'        Me.lblCurrentStatus.Location = New System.Drawing.Point(112, 136)
'        Me.lblCurrentStatus.Name = "lblCurrentStatus"
'        Me.lblCurrentStatus.Size = New System.Drawing.Size(208, 15)
'        Me.lblCurrentStatus.TabIndex = 18
'        Me.lblCurrentStatus.Text = "Backup is queued..."
'        '
'        'PictureBox1
'        '
'        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
'        Me.PictureBox1.Location = New System.Drawing.Point(274, -2)
'        Me.PictureBox1.Name = "PictureBox1"
'        Me.PictureBox1.Size = New System.Drawing.Size(222, 167)
'        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
'        Me.PictureBox1.TabIndex = 19
'        Me.PictureBox1.TabStop = False
'        '
'        'lblTransfrerredLable
'        '
'        Me.lblTransfrerredLable.Location = New System.Drawing.Point(12, 151)
'        Me.lblTransfrerredLable.Name = "lblTransfrerredLable"
'        Me.lblTransfrerredLable.Size = New System.Drawing.Size(100, 15)
'        Me.lblTransfrerredLable.TabIndex = 20
'        Me.lblTransfrerredLable.Text = "Transferred:"
'        Me.lblTransfrerredLable.Visible = False
'        '
'        'lblTransferred
'        '
'        Me.lblTransferred.ForeColor = System.Drawing.SystemColors.ActiveCaption
'        Me.lblTransferred.Location = New System.Drawing.Point(112, 151)
'        Me.lblTransferred.Name = "lblTransferred"
'        Me.lblTransferred.Size = New System.Drawing.Size(208, 14)
'        Me.lblTransferred.TabIndex = 21
'        Me.lblTransferred.Visible = False
'        '
'        'frmBackup
'        '
'        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
'        Me.BackColor = System.Drawing.Color.White
'        Me.ClientSize = New System.Drawing.Size(508, 241)
'        Me.Controls.Add(Me.lblTransferred)
'        Me.Controls.Add(Me.lblTransfrerredLable)
'        Me.Controls.Add(Me.PictureBox1)
'        Me.Controls.Add(Me.lblCurrentStatus)
'        Me.Controls.Add(Me.lblCurrentDB)
'        Me.Controls.Add(Me.Label5)
'        Me.Controls.Add(Me.pbTotal)
'        Me.Controls.Add(Me.Label2)
'        Me.Controls.Add(Me.Label1)
'        Me.Controls.Add(Me.pbUpload)
'        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
'        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
'        Me.MaximizeBox = False
'        Me.Name = "frmBackup"
'        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
'        Me.Text = "DMS Backup"
'        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
'        Me.ResumeLayout(False)
'        Me.PerformLayout()

'    End Sub

'#End Region

'    Private Sub frmBackup_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

'        'MessageBox.Show("asdf")
'        'Dim ts As New Threading.ThreadStart(AddressOf Backup)
'        'Dim t As New Threading.Thread(ts)

'        't.Start()

'        'Backup()

'        '_tmr.Interval = 15000
'        '_tmr.Start()

'    End Sub
'    Public Sub Backup()

'        'setup ftp
'        '_ftp.RemoteHost = ConfigurationManager.AppSettings("host")
'        _ftp.Timeout = 999999

'        'fire up ftp
'        _ftp.Connect(ConfigurationManager.AppSettings("host"))

'        'authenticate
'        _ftp.Login(ConfigurationManager.AppSettings("username"), ConfigurationManager.AppSettings("password"))

'        '_ftp.Hostname = ConfigurationManager.AppSettings("host")
'        '_ftp.Username = ConfigurationManager.AppSettings("username")
'        '_ftp.Password = ConfigurationManager.AppSettings("password")
'        '_ftp.Passive = True

'        'set some 
'        ForceValidateLog()
'        LogBeginning()

'        'update display
'        UpdateStatus("Connecting to remote FTP...")
'        LogBackup("*** FTP CONNECTED ***")

'        If CreatedTempFolder() Then

'            'retrieve databases
'            Dim Databases() As String = ConfigurationManager.AppSettings("databases").Split(New Char() {",", ";"})

'            'loop through databases to backup
'            If Databases.Length > 0 Then

'                pbTotal.Value = 0
'                pbTotal.Maximum = Databases.Length * 3

'                For Each Database As String In Databases

'                    lblCurrentDB.Text = Database

'                    If BackupWasSuccessful(Database) Then

'                        pbTotal.Value += 1

'                        LogBackup("Database " & Database & " - backed up")

'                        Dim ZippedFile As String = BackupWasZipped(Database)

'                        pbTotal.Value += 1

'                        If ZippedFile.Length > 0 Then

'                            LogBackup("Database " & Database & " - zipped (deflate compression)")

'                            If TransferWasSuccessful(ZippedFile, Database) Then

'                                pbTotal.Value += 1

'                                LogBackup("Database " & Database & " - transferred to FTP")

'                            Else

'                                pbTotal.Value += 1

'                                LogBackup("Database " & Database & " - transfer to FTP failed")

'                            End If
'                        Else

'                            pbTotal.Value += 1

'                            LogBackup("Database " & Database & " - zipped failed")

'                        End If
'                    Else

'                        LogBackup("Database " & Database & " - backup failed")

'                    End If
'                Next
'            End If

'        End If

'        'update display
'        UpdateStatus("Disconnecting from remote FTP...")

'        'jump off
'        _ftp.Disconnect()
'        '_ftp.Quit()

'        'update display
'        LogBackup("*** FTP DISCONNECTED ***")

'        'wipe out temp data
'        'CleanupFiles()
'        LogEnd()

'        Close()

'    End Sub
'    Private Function BackupWasSuccessful(ByVal Database As String) As Boolean

'        UpdateStatus("Backing up database [Instantiating TSQL]...")

'        Try

'            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

'                cmd.CommandText = "BACKUP DATABASE " & Database & " TO DISK = '" & _
'                    FileHelper.Normalize(_temp) & Database & "' WITH INIT"

'                Using cn As IDbConnection = cmd.Connection

'                    cn.Open()
'                    cmd.ExecuteNonQuery()

'                End Using

'            End Using

'            Return True

'        Catch ex As Exception
'            Return False
'        End Try

'    End Function
'    Private Function TransferWasSuccessful(ByVal FileName As String, ByVal Database As String) As Boolean

'        UpdateStatus("Transferring files to FTP...")

'        Dim dir As String = FileHelper.Normalize(_dir) & Database

'        'TODO: Check and remove enough space on the server to store the current file
'        'ClearSpace(fi.Length)

'        'make sure directory exists
'        If ForceValidateDirectory(dir) Then

'            lblTransferred.Visible = True
'            lblTransfrerredLable.Visible = True

'            pbUpload.Value = 0

'            _size = New IO.FileInfo(FileHelper.Normalize(_temp) & FileName).Length

'            Try

'                '_ftp.ChDir(dir)
'                '_ftp.ChangeRemoteDir(dir)
'                _ftp.ChangeCurrentFolder(dir)

'                _ftp.SendFile(FileHelper.Normalize(_temp) & FileName, FileName)
'                '_ftp.Put(FileHelper.Normalize(_temp) & FileName, FileName)

'                Return True

'                'If _ftp.PutFile(FileHelper.Normalize(_temp) & FileName, FileName) <> 0 Then
'                '    Return True
'                'End If

'            Catch
'                Return False
'            Finally

'                lblTransferred.Visible = False
'                lblTransfrerredLable.Visible = False

'                pbUpload.Value = 0

'            End Try

'        Else
'            Return False
'        End If

'    End Function
'    Private Function BackupWasZipped(ByVal Database As String) As String

'        UpdateStatus("Zipping backup files [maximum deflate compression]...")

'        Dim Encrypt As Boolean = Boolean.Parse(ConfigurationManager.AppSettings("encrypt"))
'        Dim Password As String = ConfigurationManager.AppSettings("encryptPassword")

'        Dim i As Long = 0
'        'Dim objCrc32 As New Crc32
'        Dim strmZipOutputStream As ZipOutputStream = Nothing

'        Dim strmFile As IO.FileStream = Nothing

'        Dim dbFile As String = FileHelper.Normalize(_temp) & Database
'        Dim zipFile As String = Now.ToString("yyyy.MM.dd.HH.mm.ss") & ".zip"

'        If IO.File.Exists(dbFile) Then

'            Try

'                strmZipOutputStream = New ZipOutputStream(IO.File.Create(FileHelper.Normalize(_temp) & zipFile))
'                strmZipOutputStream.SetLevel(6)

'                If Encrypt Then
'                    strmZipOutputStream.Password = Password
'                End If

'                Dim abyBuffer(8192) As Byte

'                strmFile = IO.File.OpenRead(dbFile)

'                Dim objZipEntry As ZipEntry = New ZipEntry(IO.Path.GetFileName(dbFile))

'                objZipEntry.DateTime = DateTime.Now
'                objZipEntry.Size = strmFile.Length
'                strmZipOutputStream.PutNextEntry(objZipEntry)

'                Dim read As Integer = 0
'                Dim readTotal As Integer = 0

'                While readTotal < strmFile.Length
'                    read = strmFile.Read(abyBuffer, 0, 8192)

'                    strmZipOutputStream.Write(abyBuffer, 0, read)

'                    readTotal += read
'                End While

'            Catch
'                Return String.Empty
'            Finally

'                If Not strmFile Is Nothing Then
'                    strmFile.Close()
'                End If

'                If Not strmZipOutputStream Is Nothing Then
'                    strmZipOutputStream.Finish()
'                    strmZipOutputStream.Close()
'                End If

'            End Try

'            Return zipFile

'        Else
'            Return String.Empty
'        End If

'    End Function
'    Private Sub CleanupFiles()

'        UpdateStatus("Cleaning up temporary folders and files...")

'        If IO.Directory.Exists(_temp) Then
'            IO.Directory.Delete(_temp, True)
'        End If

'    End Sub
'    Private Function CreatedTempFolder() As Boolean

'        Try

'            'make sure directory exists
'            If Not IO.Directory.Exists(_temp) Then
'                IO.Directory.CreateDirectory(_temp)
'            End If

'            LogBackup("Temp folder (""" & _temp & """ for database backup was succesfully created")

'            If CreateLocalShare() Then
'                LogBackup("Temp folder (""" & _temp & """ for database backup was succesfully shared")
'                Return True
'            Else
'                LogBackup("Temp folder (""" & _temp & """ for database backup was NOT succesfully shared")
'                Return False
'            End If

'        Catch
'            LogBackup("Temp folder for database backup was NOT succesfully created")
'            Return False
'        End Try

'    End Function
'    Private Function CreateLocalShare() As Boolean

'        Dim objFSO, objWMIService, objNewShare, objNewShareSD
'        Dim errReturn As Integer

'        Try

'            objFSO = CreateObject("Scripting.FileSystemObject")

'            If objFSO.FolderExists("\\" & SystemInformation.ComputerName & "\" & New IO.DirectoryInfo(_temp).Name) Then
'                Return True
'            Else

'                objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")

'                objNewShare = objWMIService.Get("Win32_Share")
'                objNewShareSD = objWMIService.Get("Win32_SecurityDescriptor")

'                errReturn = objNewShare.Create(_temp, New IO.DirectoryInfo(_temp).Name, 0)

'            End If

'            Return True

'        Catch
'            Return False
'        End Try

'    End Function
'    Public Sub UpdateStatus(ByVal strMessage As String)
'        lblCurrentStatus.Text = strMessage
'        Application.DoEvents()
'    End Sub
'    Private Function ForceValidateDirectory(ByVal Directory As String) As Boolean

'        'Dim err As Integer

'        Try

'            'Dim cur As String = _ftp.Pwd
'            Dim cur As String = _ftp.GetCurrentFolder
'            'Dim cur As String = _ftp.GetCurrentRemoteDir

'            Dim dirs() As String = Directory.Split(New Char() {"/", "\"})

'            For i As Integer = 0 To dirs.Length - 1

'                If dirs(i).Length > 0 Then

'                    Try

'                        'try to connect to this directory
'                        '_ftp.ChDir(dirs(i))
'                        _ftp.ChangeCurrentFolder(dirs(i))

'                    Catch ex1 As Exception 'could not connect

'                        Try

'                            'create this directory
'                            '_ftp.MkDir(dirs(i))
'                            _ftp.CreateFolder(dirs(i))

'                            'now try to connect to this directory
'                            '_ftp.ChDir(dirs(i))
'                            _ftp.ChangeCurrentFolder(dirs(i))

'                        Catch ex2 As Exception 'still no luck trying to get in

'                            'change cur dir back to original
'                            '_ftp.ChDir(cur)
'                            _ftp.ChangeCurrentFolder(cur)

'                            Return False 'return out

'                        End Try

'                    End Try

'                End If

'            Next

'            'change cur dir back to original
'            '_ftp.ChDir(cur)
'            _ftp.ChangeCurrentFolder(cur)

'            Return True

'        Catch
'            Return False
'        Finally

'        End Try

'    End Function
'    Private Sub ForceValidateLog()

'        If Not IO.File.Exists(_log) Then

'            Dim dir As String = New IO.FileInfo(_log).DirectoryName

'            If Not IO.Directory.Exists(dir) Then
'                IO.Directory.CreateDirectory(dir)
'            End If

'        End If

'    End Sub
'    Private Sub LogBeginning()

'        Dim writer As New IO.StreamWriter(_log, True)

'        writer.WriteLine()
'        writer.WriteLine()
'        writer.WriteLine("Backup started " & Format(Now, "MM.dd.yyyy.hh.mm.ss"))
'        writer.WriteLine("-------------------------------------------------------------------------------------------------------------")
'        writer.Close()

'        Application.DoEvents()

'    End Sub
'    Private Sub LogEnd()

'        Dim writer As New IO.StreamWriter(_log, True)

'        writer.WriteLine("-------------------------------------------------------------------------------------------------------------")
'        writer.WriteLine("Backup ended " & Format(Now, "MM.dd.yyyy.hh.mm.ss"))
'        writer.WriteLine()
'        writer.WriteLine()
'        writer.Close()

'        Application.DoEvents()

'    End Sub
'    Private Sub LogBackup(ByVal strLog As String)

'        Dim writer As New IO.StreamWriter(_log, True)

'        writer.WriteLine(Format(Now, "MM.dd.yyyy.hh.mm.ss") & vbTab & strLog)
'        writer.Close()

'        Application.DoEvents()

'    End Sub
'    Private Sub _tmr_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles _tmr.Tick

'        _tmr.Stop()

'        Backup()

'    End Sub
'    'Private Sub _ftp_BytesTransferred(ByVal sender As Object, ByVal e As EnterpriseDT.Net.Ftp.BytesTransferredEventArgs) Handles _ftp.BytesTransferred

'    '    Dim pctDone As Double = e.ByteCount / _size

'    '    pbUpload.Value = pctDone * 100

'    '    lblTransferred.Text = "Uploading " & FileHelper.FormatBytes(e.ByteCount) & " of " _
'    '        & FileHelper.FormatBytes(_size) & " (" & pctDone.ToString("#,##0.##%") & ")"

'    '    Application.DoEvents()

'    'End Sub
'    'Private Sub _ftp_TransferCompleteEx(ByVal sender As Object, ByVal e As EnterpriseDT.Net.Ftp.TransferEventArgs) Handles _ftp.TransferCompleteEx
'    '    'upload finished
'    'End Sub
'    'Private Sub _ftp_TransferStartedEx(ByVal sender As Object, ByVal e As EnterpriseDT.Net.Ftp.TransferEventArgs) Handles _ftp.TransferStartedEx
'    '    'upload started
'    'End Sub
'    'Private Sub _ftp_PutProgress(ByVal pctDone As Integer) Handles _ftp.PutProgress

'    '    pbUpload.Value = pctDone

'    '    lblTransferred.Text = "Uploading " & FileHelper.FormatBytes((pctDone / 100) * _size) & " of " _
'    '        & FileHelper.FormatBytes(_size) & " (" & pctDone.ToString("#,##0") & "%)"

'    '    Application.DoEvents()

'    'End Sub
'    'Private Sub _ftp_FileTransferStatus(ByVal sender As Object, ByVal e As Xceed.Ftp.FileTransferStatusEventArgs) Handles _ftp.FileTransferStatus

'    '    Dim pctDone As Double = e.BytesTransferred / e.BytesTotal

'    '    pbUpload.Value = pctDone * 100

'    '    SetTransferredText("Uploading " & FileHelper.FormatBytes(e.BytesTransferred) & " of " _
'    '        & FileHelper.FormatBytes(_size) & " (" & pctDone.ToString("#,##0.##%") & ")")

'    '    Application.DoEvents()

'    'End Sub

'    'Delegate Sub SetTransferredTextCallback(ByVal Value As String)

'    'Private Sub SetTransferredText(ByVal Value As String)

'    '    If lblTransferred.InvokeRequired Then

'    '        Dim d As New SetTransferredTextCallback(AddressOf SetTransferredText)

'    '        Invoke(d, New Object() {Value})

'    '    Else
'    '        lblTransferred.Text = Value
'    '    End If

'    'End Sub
'End Class