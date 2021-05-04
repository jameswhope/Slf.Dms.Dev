'*************************************************************************
'	created:	2007/08/28
'	created:	28:8:2007   11:44
'	filename: 	C:\Documents and Settings\jhope\My Documents\A new Hope\Visual Studio 2005\Projects\ftp\VB\FtpSample\Ftp.vb
'	file path:	C:\Documents and Settings\jhope\My Documents\A new Hope\Visual Studio 2005\Projects\ftp\VB\FtpSample
'	file base:	Ftp
'	file ext:	vb
'	author:	Jim Hope	
'	Copyright: @ 2007 all rights reserved
'	purpose:	Ftp code to upload/download files to/from an ftp server
'*************************************************************************

Imports System
Imports EnterpriseDT.Net
Imports EnterpriseDT.Util.Debug

Module LexxiomFtp

   Private FRemoteHost As String = ""
   Private FRemotePath As String = "."
   Private FRemoteUser As String = ""
   Private FRemotePassword As String = ""
   Private FRemotePort As Integer = 0
   Private FRemoteFile As String
   Private FLocalFile As String
   Private response As String

   Sub Main(ByVal args() As String)
      If args.Length < 5 Then
         Usage()
         System.Environment.Exit(1)
      End If
      Dim log As Logger = Logger.GetLogger(GetType(LexxiomFtp))
      Dim host As String = args(0)
      Dim user As String = args(1)
      Dim password As String = args(2)
      Dim localfile As String = args(3)
      Dim remotefile As String = args(4)
      Logger.CurrentLevel = Level.ALL

      FRemoteHost = host
      FRemotePath = "."
      FRemoteUser = user
      FRemotePassword = password
      FRemotePort = 21
      FRemoteFile = remotefile
      FLocalFile = localfile

      If args.Length = 5 Then
         Upload()
      End If
   End Sub

   Private Sub Download(ByVal downloadUrl As String)
      Dim log As EnterpriseDT.Util.Debug.Logger = EnterpriseDT.Util.Debug.Logger.GetLogger(GetType(LexxiomFtp))
      Dim ftp As Ftp.FTPClient = Nothing
      ftp = New Ftp.FTPClient()
      ftp.RemoteHost = FRemoteHost
      ftp.Connect()
      ftp.Login(FRemoteUser, FRemotePassword)
      ftp.ConnectMode = EnterpriseDT.Net.Ftp.FTPConnectMode.PASV
      ftp.TransferType = EnterpriseDT.Net.Ftp.FTPTransferType.BINARY
      log.Debug("Directory before put:")
      Dim files As Array = ftp.Dir(".", True)
      Dim i As Integer = 0
      While i < files.Length
         log.Debug(files(i))
         i += 1
      End While
      log.Info("Getting file")
      ftp.Get(FLocalFile, FRemoteFile)
      log.Debug("Directory after put")
      files = ftp.Dir(".", True)
      i = 0
      While i < files.Length
         log.Debug(files(i))
         i += 1
      End While
      log.Info("Quitting client")
      ftp.Quit()
      log.Info("Test complete")
   End Sub

   Private Sub Upload()

      Dim log As EnterpriseDT.Util.Debug.Logger = EnterpriseDT.Util.Debug.Logger.GetLogger(GetType(LexxiomFtp))
      Dim ftp As Ftp.FTPClient = Nothing
      ftp = New Ftp.FTPClient()
      ftp.RemoteHost = FRemoteHost
      ftp.Connect()
      ftp.User(FRemoteUser)
      ftp.Password(FRemotePassword)
      'ftp.Login(FRemoteUser, FRemotePassword)
      ftp.ConnectMode = EnterpriseDT.Net.Ftp.FTPConnectMode.ACTIVE
      ftp.TransferType = EnterpriseDT.Net.Ftp.FTPTransferType.BINARY
      log.Debug("Directory before put:")
      'Dim files As Array = ftp.Dir(".", True)
      'Dim i As Integer = 0
      'While i < files.Length
      'log.Debug(files(i))
      'i += 1
      'End While
      log.Info("Putting file")
      ftp.Put("\\Dc01\d\Process\TestStatements\Client_Stmts_Mar16_Mar31\DMS_StatusRpt031608.zip", "DMS_StatusRpt031608.zip")
      log.Debug("Directory after put")
      'files = ftp.Dir(".", True)
      'i = 0
      'While i < files.Length
      'log.Debug(files(i))
      'i += 1
      'End While
      log.Info("Quitting client")
      ftp.Quit()
      log.Info("Test complete")
   End Sub

   Public Sub Usage()
      System.Console.Out.WriteLine("Usage: Host User Password Localfile Remotefile (User a fully qualified path for the local file.)")
   End Sub

End Module
