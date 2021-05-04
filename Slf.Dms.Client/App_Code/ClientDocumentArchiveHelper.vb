Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Threading
Imports System.Net
Imports System.Net.Mail
Imports System.Text.RegularExpressions
Imports SharedFunctions.AsyncDB
Imports Ionic.Zip

Public Class ClientDocumentArchiveHelper
	''' <summary>
	''' archive state enum
	''' </summary>
	''' <remarks></remarks>
	Public Enum StorageSolutionType
		Archive = 0
		Restore = 1
	End Enum
	Public Class ArchiveEventArgs
		Private TheData As String
		Public Sub New(ByVal Data As String)
			TheData = Data
		End Sub
		Public ReadOnly Property Data() As String
			Get
				Return TheData
			End Get
		End Property
	End Class
#Region "Client Methods"
	''' <summary>
	''' retrieve list of cancelled clients where cancel date is n months from current date
	''' </summary>
	''' <param name="timeFrameInMonths"></param>
	''' <returns></returns>
	''' <remarks></remarks>
	Public Shared Function getArchiveClients(ByVal clientStatusID As Integer, ByVal timeFrameInMonths As Integer) As List(Of archiveClient)

		Dim ssql As String = String.Format("select c.accountnumber, c.clientid,'\\'+ storageserver +'\' + storageroot + '\' + accountnumber[FolderLocation] " & _
		  ",r.LastModified[CancelDate] from tblclient as c inner join tblroadmap as r on " & _
		  "c.clientid=r.clientid and r.clientstatusid = " & clientStatusID & " where c.currentclientstatusid = " & clientStatusID & " " & _
		  "and r.LastModified < dateadd(m,-{0},getdate()) order by r.LastModified desc", timeFrameInMonths)
		Dim dt As DataTable = executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)
		Dim a As New List(Of archiveClient)
		For Each c As DataRow In dt.Rows
			a.Add(New archiveClient(c("accountnumber").ToString, c("clientid").ToString, c("FolderLocation").ToString, c("CancelDate").ToString))
		Next

		Return a
	End Function
	''' <summary>
	''' get count of cancelled clients
	''' </summary>
	''' <param name="timeFrameInMonths"></param>
	''' <returns></returns>
	''' <remarks></remarks>
	Public Shared Function getArchiveClientsCount(ByVal clientStatusID As Integer, ByVal timeFrameInMonths As Integer) As Integer

		Dim ssql As String = String.Format("select count(*) from tblclient as c inner join tblroadmap as r on " & _
		  "c.clientid=r.clientid and r.clientstatusid = " & clientStatusID & " where c.currentclientstatusid = " & clientStatusID & " " & _
		  "and r.LastModified < dateadd(m,-{0},getdate())  and storageroot <> 'ClientFilesArchive'", timeFrameInMonths)
		Dim iRtn As Integer = executeScalar(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)
		Return iRtn

	End Function
	
#End Region
#Region "Structures"
	Public Structure restoreParams
		Public NotifyAddress As String
		Public clientListToRestore As List(Of restoreClient)
		Public destinationPath As String
		Sub New(ByVal _NotifyAddress As String, ByVal _clientListToRestore As List(Of restoreClient), ByVal _destinationPath As String)
			NotifyAddress = _NotifyAddress
			clientListToRestore = _clientListToRestore
			destinationPath = _destinationPath
		End Sub
	End Structure
	Public Structure archiveParams
		Public NotifyAddress As String
		Public ClientStatusID As Integer
		Public TimeFrameInMonthsSinceCancelled As Integer
		Public DocumentDirectory As String
		Public BackupDirectory As String
		Sub New(ByVal notifyEmails As String, ByVal _ClientStatusID As Integer, ByVal timeFrame As Integer, ByVal _DocumentDirectory As String, ByVal backupDir As String)
			NotifyAddress = notifyEmails
			TimeFrameInMonthsSinceCancelled = timeFrame
			BackupDirectory = backupDir
			DocumentDirectory = _DocumentDirectory
			ClientStatusID = _ClientStatusID
		End Sub
	End Structure
	Public Structure archiveClient
		Public LexxAccountNumber As String
		Public DataClientId As String
		Public FolderLocation As String
		Public CancelDate As String
		Sub New(ByVal _LexxAccountNumber As String, ByVal _DataClientId As String, ByVal _FolderLocation As String, ByVal _cancelDate As String)
			LexxAccountNumber = _LexxAccountNumber
			DataClientId = _DataClientId
			FolderLocation = _FolderLocation
			CancelDate = _cancelDate
		End Sub
	End Structure
	Public Structure restoreClient
		Public LexxAccountNumber As String
		Public ZipPackageName As String
		Public ZipPath As String
		Sub New(ByVal _lexxAcctNumber As String, ByVal _zipname As String, ByVal _zippath As String)
			LexxAccountNumber = _lexxAcctNumber
			ZipPackageName = _zipname
			ZipPath = _zippath
		End Sub
	End Structure
	Public Structure CurrentJob
		Public JobType As String
		Public JobUser As String
		Public JobStart As DateTime
	End Structure
#End Region
#Region "Classes"
	Public Class ClientArchiver
		Private _UserID As Integer
		Public Property UserID() As Integer
			Get
				Return _UserID
			End Get
			Set(ByVal value As Integer)
				_UserID = value
			End Set
		End Property
		Public Event archiveComplete(ByVal completeMessage As ArchiveEventArgs)
		Public Event archiveProgress(ByVal progressMsg As ArchiveEventArgs)
		Public Event restoreComplete(ByVal completeMessage As ArchiveEventArgs)
		Public Event restoreProgress(ByVal restoreMsg As ArchiveEventArgs)
		Sub New()

		End Sub
		Sub New(ByVal CurrentLoggedInUserID As Integer)
			UserID = CurrentLoggedInUserID
		End Sub
		''' <summary>
		''' archives client document folders to dc02
		''' </summary>
		''' <param name="timeFrameInMonths"></param>
		''' <param name="backupDirectory"></param>
		''' <remarks></remarks>
		''' 
		Public Sub archiveDocuments(ByVal client As archiveClient, ByVal backupDirectory As String)

			Dim backupPath As String = backupDirectory & "\"			'directory to save zip file too
			Dim sbLog As New StringBuilder
			Dim logLine As New StringBuilder
			Dim solID As Integer = -1
			Try
				solID = writeStorageLogEnty(1, 2, "Starting archiving job!")

				logLine.Append(Now.ToString & String.Format(":  Creating ZIP File for Client {0}", client.LexxAccountNumber))
				Dim zFilename As String = String.Format("{0}.zip", client.LexxAccountNumber)
				Using zip As New ZipFile
					Dim zPath As String = client.FolderLocation
					If Directory.Exists(zPath) Then
						zip.AddDirectory(zPath)
						logLine.Append(String.Format(". {0} Total Files", zip.Count))
						zip.Save(backupPath & zFilename)

						'delete files
						logLine.Append(Now.ToString & String.Format(": Deleting {0}", client.FolderLocation))
						If Directory.Exists(client.FolderLocation) Then
							Directory.Delete(client.FolderLocation, True)
						End If

					Else
						logLine.Append(".No Client Folder!")
					End If
				End Using
				sbLog.Append(vbCrLf)
				updateClientFileLocations(client.DataClientId, client.LexxAccountNumber, StorageSolutionType.Archive)
				RaiseEvent archiveProgress(New ArchiveEventArgs(logLine.ToString))
				sbLog.Append(logLine.ToString)

				updateStorageLogEnty(3, sbLog.ToString, solID)

				RaiseEvent archiveComplete(New ArchiveEventArgs("Archiving has completed!" & vbCrLf))

			Catch ex As Exception
				updateStorageLogEnty(1, ex.Message, solID)
				RaiseEvent archiveComplete(New ArchiveEventArgs(ex.Message))
			Finally

			End Try

		End Sub
		Public Sub archiveDocuments(ByVal notifyAddress As String, ByVal clientStatusID As Integer, ByVal timeFrameInMonths As Integer, ByVal documentDirectory As String, ByVal backupDirectory As String)

			Dim backupPath As String = backupDirectory & "\"			'directory to save zip file too
			Dim ClientList As List(Of archiveClient) = Nothing			'generic list of clients that need to be archived
			Dim sbLog As New StringBuilder

			Dim solID As Integer = -1
			Try
				solID = writeStorageLogEnty(1, 2, "Starting archiving job!")

				ClientList = getArchiveClients(clientStatusID, timeFrameInMonths)									 'fill list with clients from archive helper

				Dim i As Double = 1
				Dim totalRows As Integer = ClientList.Count
				sbLog.AppendLine(String.Format("Total Clients : {0}", totalRows))
				updateStorageLogEnty(1, String.Format("Total Clients : {0}", totalRows), solID)

				For Each client As archiveClient In ClientList
					Dim logLine As New StringBuilder
					logLine.Append(Now.ToString & String.Format(":  Creating ZIP File for Client {0}", client.LexxAccountNumber))
					Dim zFilename As String = String.Format("{0}.zip", client.LexxAccountNumber)
					Using zip As New ZipFile
						Dim zPath As String = documentDirectory & "\" & client.LexxAccountNumber
						If Directory.Exists(zPath) Then
							zip.AddDirectory(zPath)
							logLine.Append(String.Format(". {0} Total Files", zip.Count))
							zip.Save(backupPath & zFilename)

							'delete files
							logLine.Append(Now.ToString & String.Format(": Deleting {0}", documentDirectory & "\" & client.LexxAccountNumber))
							If Directory.Exists(documentDirectory & "\" & client.LexxAccountNumber) Then
								Directory.Delete(documentDirectory & "\" & client.LexxAccountNumber, True)
							End If

						Else
							logLine.Append(".No Client Folder!")
						End If
					End Using
					sbLog.Append(vbCrLf)
					updateClientFileLocations(client.DataClientId, client.LexxAccountNumber, StorageSolutionType.Archive)
					RaiseEvent archiveProgress(New ArchiveEventArgs(logLine.ToString))
					sbLog.Append(logLine.ToString)
					i += 1
				Next

				sbLog.Append(String.Format("Archived {0} clients", ClientList.Count) & vbCrLf)

				updateStorageLogEnty(3, sbLog.ToString, solID)

				Using msg As New MailMessage("LexxiomArchiver@lexxiom.com", notifyAddress, "Archiving has completed!", "Log File Attached")
					Dim mail As New SmtpClient("dc02.dmsi.local")
					Dim attachName As String = CreateLogFile(sbLog.ToString, ConfigurationManager.AppSettings("storage_documentPath").ToString, StorageSolutionType.Archive)
					msg.Attachments.Add(New Attachment(attachName))
					msg.Priority = MailPriority.High
					msg.IsBodyHtml = True
					mail.Send(msg)
				End Using

				RaiseEvent archiveComplete(New ArchiveEventArgs(String.Format("Archived {0} clients", ClientList.Count) & vbCrLf))

			Catch ex As Exception
				updateStorageLogEnty(1, ex.Message, solID)
				RaiseEvent archiveComplete(New ArchiveEventArgs(ex.Message))
			Finally
				ClientList = Nothing
			End Try

		End Sub
		Public Sub archiveDocuments(ByVal archiveParameters As archiveParams)
			archiveDocuments(archiveParameters.NotifyAddress, archiveParameters.ClientStatusID, archiveParameters.TimeFrameInMonthsSinceCancelled, archiveParameters.DocumentDirectory, archiveParameters.BackupDirectory)
		End Sub
		Public Sub archiveDocumentsAsync(ByVal archiveParameters As archiveParams)
			Dim t As New Thread(AddressOf archiveDocuments)
			t.Start(archiveParameters)

		End Sub
		''' <summary>
		''' restore documents from dc02
		''' </summary>
		''' <param name="notifyAddress"></param>
		''' <param name="clientListToRestore"></param>
		''' <param name="destinationPath"></param>
		''' <remarks></remarks>
		''' 
		Public Sub restoreDocuments(ByVal client As restoreClient, ByVal destinationPath As String)

			Dim restoreLog As New StringBuilder
			Dim solID As Integer = -1
			Try
				solID = writeStorageLogEnty(2, 2, "Restoring archive!")

				restoreLog.AppendLine(String.Format("Unzipping {0}", client.ZipPackageName) & vbCrLf)

				Dim clientAcct As String = Path.GetFileNameWithoutExtension(client.ZipPath)

				Dim ZipToUnpack As String = client.ZipPath

				Dim TargetDir As String = destinationPath & "\" & clientAcct
				Using zip1 As ZipFile = ZipFile.Read(ZipToUnpack)
					'AddHandler zip1.ExtractProgress, AddressOf UnzipProgress
					' here, we extract every entry, but we could extract    
					' based on entry name, size, date, etc.   
					For Each z As ZipEntry In zip1
						Try
							z.Extract(TargetDir, False)
							restoreLog.AppendLine(vbTab & String.Format("Restoring {0} to {1}", z.FileName.ToString, TargetDir) & vbCrLf)
							RaiseEvent restoreProgress(New ArchiveEventArgs(String.Format("Restoring {0} to {1}", z.FileName.ToString, TargetDir)))
						Catch zex As ZipException
							'file exists
						Catch ex As Exception
							RaiseEvent restoreProgress(New ArchiveEventArgs(ex.Message))
						End Try

					Next
				End Using

				Dim cid As String = executeScalar("select clientid from tblclient where accountnumber = " & clientAcct, ConfigurationManager.AppSettings("connectionstring").ToString)
				updateClientFileLocations(cid, clientAcct, StorageSolutionType.Restore)
				Try
					File.Delete(ZipToUnpack)
				Catch ex As Exception

				End Try

				updateStorageLogEnty(3, restoreLog.ToString, solID)

				RaiseEvent restoreComplete(New ArchiveEventArgs(restoreLog.ToString))

			Catch ex As Exception
				updateStorageLogEnty(1, ex.Message, solID)
				RaiseEvent restoreComplete(New ArchiveEventArgs(ex.Message.ToString))
			Finally
				restoreLog = Nothing
			End Try
		End Sub
		Public Sub restoreDocuments(ByVal notifyAddress As String, ByVal clientListToRestore As List(Of restoreClient), ByVal destinationPath As String)

			Dim restoreLog As New StringBuilder
			Dim solID As Integer = -1
			Try
				solID = writeStorageLogEnty(2, 2, "Restoring archive!")

				For Each client As restoreClient In clientListToRestore

					restoreLog.AppendLine(String.Format("Unzipping {0}", client.ZipPackageName) & vbCrLf)

					Dim clientAcct As String = Path.GetFileNameWithoutExtension(client.ZipPath)

					Dim ZipToUnpack As String = client.ZipPath

					Dim TargetDir As String = destinationPath & "\" & clientAcct
					Using zip1 As ZipFile = ZipFile.Read(ZipToUnpack)
						'AddHandler zip1.ExtractProgress, AddressOf UnzipProgress
						' here, we extract every entry, but we could extract    
						' based on entry name, size, date, etc.   
						For Each z As ZipEntry In zip1
							Try
								z.Extract(TargetDir, False)
								restoreLog.AppendLine(vbTab & String.Format("Restoring {0} to {1}", z.FileName.ToString, TargetDir) & vbCrLf)
								RaiseEvent restoreProgress(New ArchiveEventArgs(String.Format("Restoring {0} to {1}", z.FileName.ToString, TargetDir)))
							Catch zex As ZipException
								'file exists
							Catch ex As Exception
								RaiseEvent restoreProgress(New ArchiveEventArgs(ex.Message))
							End Try

						Next
					End Using

					Dim cid As String = executeScalar("select clientid from tblclient where accountnumber = " & clientAcct, ConfigurationManager.AppSettings("connectionstring").ToString)
					updateClientFileLocations(cid, clientAcct, StorageSolutionType.Restore)
					Try
						File.Delete(ZipToUnpack)
					Catch ex As Exception
						Continue For
					End Try

				Next
				restoreLog.AppendLine(String.Format("Unzipped {0} files", clientListToRestore.Count) & vbCrLf)

				updateStorageLogEnty(3, restoreLog.ToString, solID)

				RaiseEvent restoreComplete(New ArchiveEventArgs(restoreLog.ToString))

				Using msg As New MailMessage("LexxiomArchiver@lexxiom.com", notifyAddress, "Restoring has completed!", "Log File Attached")
					Dim mail As New SmtpClient("dc02.dmsi.local")
					Dim attachName As String = CreateLogFile(restoreLog.ToString, ConfigurationManager.AppSettings("storage_documentPath").ToString, StorageSolutionType.Restore)
					msg.Attachments.Add(New Attachment(attachName))
					msg.Priority = MailPriority.High
					msg.IsBodyHtml = True
					mail.Send(msg)
				End Using


			Catch ex As Exception
				updateStorageLogEnty(1, ex.Message, solID)
				RaiseEvent restoreComplete(New ArchiveEventArgs(ex.Message.ToString))
			Finally
				restoreLog = Nothing
			End Try
		End Sub
		Public Sub restoreDocuments(ByVal restoreParameters As restoreParams)
			restoreDocuments(restoreParameters.NotifyAddress, restoreParameters.clientListToRestore, restoreParameters.destinationPath)
		End Sub
		Public Sub restoreDocumentsAsync(ByVal restoreParameters As restoreParams)
			Dim t As New Thread(AddressOf restoreDocuments)
			t.Start(restoreParameters)

		End Sub
		''' <summary>
		''' update storage location in db
		''' </summary>
		''' <param name="DataClientID"></param>
		''' <param name="ClientAccountNumber"></param>
		''' <remarks></remarks>
		Private Sub updateClientFileLocations(ByVal DataClientID As String, ByVal ClientAccountNumber As String, ByVal archiveState As StorageSolutionType)
			Dim sqlClient As String = ""
			Select Case archiveState
				Case StorageSolutionType.Archive
					sqlClient = String.Format("update tblclient set storageserver ='dc02', storageroot = 'ClientFilesArchive' where clientid = {0}", DataClientID)
				Case StorageSolutionType.Restore
					sqlClient = String.Format("update tblclient set storageserver ='lex-dev-30', storageroot = 'ClientStorage' where clientid = {0}", DataClientID)
			End Select
			executeScalar(sqlClient, ConfigurationManager.AppSettings("connectionstring").ToString)
		End Sub
		''' <summary>
		''' get list of running jobs to show user
		''' </summary>
		''' <returns></returns>
		''' <remarks></remarks>
		Public Function IsJobRunningNow() As List(Of CurrentJob)

			Dim sqlCheck As String = "stp_StorageSolutions_getRunningArchiveJobs"
			Dim lst As List(Of CurrentJob) = Nothing
			Dim dt As DataTable = executeDataTableAsync(sqlCheck, ConfigurationManager.AppSettings("connectionstring").ToString)

			If dt.Rows.Count > 0 Then
				lst = New List(Of CurrentJob)
				For Each row As DataRow In dt.Rows
					lst.Add(New CurrentJob() With { _
					  .JobType = row("StorageSolutionType").ToString, _
					  .JobUser = row("UserName").ToString, _
					.JobStart = row("SolutionStatusDate").ToString _
					  })
				Next
				Return lst
			Else
				Return Nothing
			End If

		End Function

		Private Function writeStorageLogEnty(ByVal solutionTypeID As Integer, ByVal solutionStatusID As Integer, ByVal logEntry As String) As Integer

			Dim sqlInsert As String = String.Format("INSERT INTO [tblStorageSolutionsLogs]([SolutionTypeID],[SolutionStatusID]," & _
			   "[SolutionStatusDate],[Created],[CreatedBy],[ArchiveLog]) " & _
			   "OUTPUT Inserted.StorageSolutionID VALUES({0},{1},getdate(),getdate(),{2},'{3}')", solutionTypeID, solutionStatusID, UserID, logEntry)

			Dim solID As String = executeScalar(sqlInsert, ConfigurationManager.AppSettings("connectionstring").ToString)

			Return Integer.Parse(solID)

		End Function
		Private Sub updateStorageLogEnty(ByVal solutionStatusID As Integer, ByVal logEntry As String, ByVal solutionID As Integer)

			Dim sqlUpdate As String = String.Format("UPDATE [tblStorageSolutionsLogs] set [SolutionStatusID] = {0}," & _
			 "[SolutionStatusDate] = getdate(),[ArchiveLog]='{1}' " & _
			 "where StorageSolutionID = {2}", solutionStatusID, logEntry, solutionID)
			executeScalar(sqlUpdate, ConfigurationManager.AppSettings("connectionstring").ToString)

		End Sub
		Private Function CreateLogFile(ByVal logText As String, ByVal saveDirectory As String, ByVal logFileType As StorageSolutionType) As String
			If Directory.Exists(saveDirectory & "archivelogs") = False Then
				Directory.CreateDirectory(saveDirectory & "archivelogs")
			End If

			Dim logName As String = saveDirectory & String.Format("archivelogs\{0}_{1}.log", logFileType.ToString, Format(Now, "yyyyMMdd_hhss"))
			Dim sw As New StreamWriter(logName, False)
			sw.Write(logText)
			sw.Flush()
			sw.Close()
			sw.Dispose()

			Return logName
		End Function
	End Class
	Public Class ftpHelper
#Region "FTP client class"
		''' <summary>
		''' A wrapper class for .NET 2.0 FTP
		''' </summary>
		''' <remarks>
		''' This class does not hold open an FTP connection but 
		''' instead is stateless: for each FTP request it 
		''' connects, performs the request and disconnects.
		''' </remarks>
		Public Class FTPclient
#Region "CONSTRUCTORS"
			''' <summary>
			''' Blank constructor
			''' </summary>
			''' <remarks>Hostname, username and password must be set manually</remarks>
			Sub New()

			End Sub
			''' <summary>
			''' Constructor just taking the hostname
			''' </summary>
			''' <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
			''' <remarks></remarks>
			Sub New(ByVal Hostname As String)
				_hostname = Hostname
			End Sub

			''' <summary>
			''' Constructor taking hostname, username and password
			''' </summary>
			''' <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
			''' <param name="Username">Leave blank to use 'anonymous' but set password to your email</param>
			''' <param name="Password"></param>
			''' <remarks></remarks>
			Sub New(ByVal Hostname As String, ByVal Username As String, ByVal Password As String)
				_hostname = Hostname
				_username = Username
				_password = Password

			End Sub

#End Region



#Region "Directory functions"

			''' <summary>
			''' Return a simple directory listing
			''' </summary>
			''' <param name="directory">Directory to list, e.g. /pub</param>
			''' <returns>A list of filenames and directories as a List(of String)</returns>
			''' <remarks>For a detailed directory listing, use ListDirectoryDetail</remarks>
			Public Function ListDirectory(Optional ByVal directory As String = "") As List(Of String)

				'return a simple list of filenames in directory

                Dim ftp As System.Net.FtpWebRequest = GetRequest(GetDirectory(directory))

				'Set request to do simple list

                ftp.Method = System.Net.WebRequestMethods.Ftp.ListDirectory



				Dim str As String = GetStringResponse(ftp)

				'replace CRLF to CR, remove last instance

				str = str.Replace(vbCrLf, vbCr).TrimEnd(Chr(13))

				'split the string into a list

				Dim result As New List(Of String)

				result.AddRange(str.Split(Chr(13)))

				Return result

			End Function

			''' <summary>
			''' Return a detailed directory listing
			''' </summary>
			''' <param name="directory">Directory to list, e.g. /pub/etc</param>
			''' <returns>An FTPDirectory object</returns>
			Public Function ListDirectoryDetail(Optional ByVal directory As String = "") As FTPdirectory

                Dim ftp As System.Net.FtpWebRequest = GetRequest(GetDirectory(directory))

				'Set request to do simple list

                ftp.Method = System.Net.WebRequestMethods.Ftp.ListDirectoryDetails



				Dim str As String = GetStringResponse(ftp)

				'replace CRLF to CR, remove last instance

				str = str.Replace(vbCrLf, vbCr).TrimEnd(Chr(13))

				'split the string into a list

				Return New FTPdirectory(str, _lastDirectory)

			End Function
#End Region

#Region "Upload: File transfer TO ftp server"

			''' <summary>
			''' Copy a local file to the FTP server
			''' </summary>
			''' <param name="localFilename">Full path of the local file</param>
			''' <param name="targetFilename">Target filename, if required</param>
			''' <returns></returns>
			''' <remarks>If the target filename is blank, the source filename is used
			''' (assumes current directory). Otherwise use a filename to specify a name
			''' or a full path and filename if required.</remarks>
			Public Function Upload(ByVal localFilename As String, Optional ByVal targetFilename As String = "") As Boolean

				'1. check source

				If Not File.Exists(localFilename) Then

					Throw New ApplicationException("File " & localFilename & " not found")

				End If

				'copy to FI

				Dim fi As New FileInfo(localFilename)

				Return Upload(fi, targetFilename)

			End Function

			''' <summary>
			''' Upload a local file to the FTP server
			''' </summary>
			''' <param name="fi">Source file</param>
			''' <param name="targetFilename">Target filename (optional)</param>
			''' <returns></returns>
			Public Function Upload(ByVal fi As FileInfo, Optional ByVal targetFilename As String = "") As Boolean

				'copy the file specified to target file: target file can be full path or just filename (uses current dir)



				'1. check target

				Dim target As String

				If targetFilename.Trim = "" Then

					'Blank target: use source filename & current dir

					target = Me.CurrentDirectory & fi.Name

				ElseIf targetFilename.Contains("/") Then

					'If contains / treat as a full path

					target = AdjustDir(targetFilename)

				Else

					'otherwise treat as filename only, use current directory

					target = CurrentDirectory & targetFilename

				End If



				Dim URI As String = Hostname & target

				'perform copy

                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)



				'Set request to upload a file in binary

                ftp.Method = System.Net.WebRequestMethods.Ftp.UploadFile

				ftp.UseBinary = True



				'Notify FTP of the expected size

				ftp.ContentLength = fi.Length



				'create byte array to store: ensure at least 1 byte!

				Const BufferSize As Integer = 2048

				Dim content(BufferSize - 1) As Byte, dataRead As Integer



				'open file for reading 

				Using fs As FileStream = fi.OpenRead()

					Try

						'open request to send

						Using rs As Stream = ftp.GetRequestStream

							Do

								dataRead = fs.Read(content, 0, BufferSize)

								rs.Write(content, 0, dataRead)

							Loop Until dataRead < BufferSize

							rs.Close()

						End Using

					Catch ex As Exception



					Finally

						'ensure file closed

						fs.Close()

					End Try



				End Using



				ftp = Nothing

				Return True



			End Function

#End Region

#Region "Download: File transfer FROM ftp server"

			''' <summary>
			''' Copy a file from FTP server to local
			''' </summary>
			''' <param name="sourceFilename">Target filename, if required</param>
			''' <param name="localFilename">Full path of the local file</param>
			''' <returns></returns>
			''' <remarks>Target can be blank (use same filename), or just a filename
			''' (assumes current directory) or a full path and filename</remarks>
			Public Function Download(ByVal sourceFilename As String, ByVal localFilename As String, Optional ByVal PermitOverwrite As Boolean = False) As Boolean

				'2. determine target file

				Dim fi As New FileInfo(localFilename)

				Return Me.Download(sourceFilename, fi, PermitOverwrite)

			End Function

			'Version taking an FtpFileInfo
			Public Function Download(ByVal file As FTPfileInfo, ByVal localFilename As String, Optional ByVal PermitOverwrite As Boolean = False) As Boolean

				Return Me.Download(file.FullName, localFilename, PermitOverwrite)

			End Function

			'Another version taking FtpFileInfo and FileInfo
			Public Function Download(ByVal file As FTPfileInfo, ByVal localFI As FileInfo, Optional ByVal PermitOverwrite As Boolean = False) As Boolean

				Return Me.Download(file.FullName, localFI, PermitOverwrite)

			End Function

			'Version taking string/FileInfo
			Public Function Download(ByVal sourceFilename As String, ByVal targetFI As FileInfo, Optional ByVal PermitOverwrite As Boolean = False) As Boolean

				'1. check target

				If targetFI.Exists And Not (PermitOverwrite) Then Throw New ApplicationException("Target file already exists")



				'2. check source

				Dim target As String

				If sourceFilename.Trim = "" Then

					Throw New ApplicationException("File not specified")

				ElseIf sourceFilename.Contains("/") Then

					'treat as a full path

					target = AdjustDir(sourceFilename)

				Else

					'treat as filename only, use current directory

					target = CurrentDirectory & sourceFilename

				End If



				Dim URI As String = Hostname & target



				'3. perform copy

                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)



				'Set request to download a file in binary mode

                ftp.Method = System.Net.WebRequestMethods.Ftp.DownloadFile

				ftp.UseBinary = True



				'open request and get response stream

				Using response As FtpWebResponse = CType(ftp.GetResponse, FtpWebResponse)

					Using responseStream As Stream = response.GetResponseStream

						'loop to read & write to file

						Using fs As FileStream = targetFI.OpenWrite

							Try

								Dim buffer(2047) As Byte

								Dim read As Integer = 0

								Do

									read = responseStream.Read(buffer, 0, buffer.Length)

									fs.Write(buffer, 0, read)

								Loop Until read = 0

								responseStream.Close()

								fs.Flush()

								fs.Close()

							Catch ex As Exception

								'catch error and delete file only partially downloaded

								fs.Close()

								'delete target file as it's incomplete

								targetFI.Delete()

								Throw

							End Try

						End Using

						responseStream.Close()

					End Using

					response.Close()

				End Using



				Return True

			End Function

#End Region

#Region "Other functions: Delete rename etc."

			''' <summary>
			''' Delete remote file
			''' </summary>
			''' <param name="filename">filename or full path</param>
			''' <returns></returns>
			''' <remarks></remarks>
			Public Function FtpDelete(ByVal filename As String) As Boolean

				'Determine if file or full path

				Dim URI As String = Me.Hostname & GetFullPath(filename)



                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)

				'Set request to delete

                ftp.Method = System.Net.WebRequestMethods.Ftp.DeleteFile

				Try

					'get response but ignore it

					Dim str As String = GetStringResponse(ftp)

				Catch ex As Exception

					Return False

				End Try

				Return True

			End Function

			''' <summary>
			''' Determine if file exists on remote FTP site
			''' </summary>
			''' <param name="filename">Filename (for current dir) or full path</param>
			''' <returns></returns>
			''' <remarks>Note this only works for files</remarks>
			Public Function FtpFileExists(ByVal filename As String) As Boolean

				'Try to obtain filesize: if we get error msg containing "550"

				'the file does not exist

				Try

					Dim size As Long = GetFileSize(filename)

					Return True



				Catch ex As Exception

					'only handle expected not-found exception

					If TypeOf ex Is System.Net.WebException Then

						'file does not exist/no rights error = 550

						If ex.Message.Contains("550") Then

							'clear 

							Return False

						Else

							Throw

						End If

					Else

						Throw

					End If

				End Try

			End Function

			''' <summary>
			''' Determine size of remote file
			''' </summary>
			''' <param name="filename"></param>
			''' <returns></returns>
			''' <remarks>Throws an exception if file does not exist</remarks>
			Public Function GetFileSize(ByVal filename As String) As Long

				Dim path As String

				If filename.Contains("/") Then

					path = AdjustDir(filename)

				Else

					path = Me.CurrentDirectory & filename

				End If

				Dim URI As String = Me.Hostname & path

                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)

				'Try to get info on file/dir?

                ftp.Method = System.Net.WebRequestMethods.Ftp.GetFileSize

				Dim tmp As String = Me.GetStringResponse(ftp)

				Return GetSize(ftp)

			End Function

			Public Function FtpRename(ByVal sourceFilename As String, ByVal newName As String) As Boolean

				'Does file exist?

				Dim source As String = GetFullPath(sourceFilename)

				If Not FtpFileExists(source) Then

					Throw New FileNotFoundException("File " & source & " not found")

				End If



				'build target name, ensure it does not exist

				Dim target As String = GetFullPath(newName)

				If target = source Then

					Throw New ApplicationException("Source and target are the same")

				ElseIf FtpFileExists(target) Then

					Throw New ApplicationException("Target file " & target & " already exists")

				End If



				'perform rename

				Dim URI As String = Me.Hostname & source



                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)

				'Set request to delete

                ftp.Method = System.Net.WebRequestMethods.Ftp.Rename

				ftp.RenameTo = target

				Try

					'get response but ignore it

					Dim str As String = GetStringResponse(ftp)

				Catch ex As Exception

					Return False

				End Try

				Return True

			End Function

			Public Function FtpCreateDirectory(ByVal dirpath As String) As Boolean

				'perform create

				Dim URI As String = Me.Hostname & AdjustDir(dirpath)

                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)

				'Set request to MkDir

                ftp.Method = System.Net.WebRequestMethods.Ftp.MakeDirectory

				Try

					'get response but ignore it

					Dim str As String = GetStringResponse(ftp)

				Catch ex As Exception

					Return False

				End Try

				Return True

			End Function

			Public Function FtpDeleteDirectory(ByVal dirpath As String) As Boolean

				'perform remove

				Dim URI As String = Me.Hostname & AdjustDir(dirpath)

                Dim ftp As System.Net.FtpWebRequest = GetRequest(URI)

				'Set request to RmDir

                ftp.Method = System.Net.WebRequestMethods.Ftp.RemoveDirectory

				Try

					'get response but ignore it

					Dim str As String = GetStringResponse(ftp)

				Catch ex As Exception

					Return False

				End Try

				Return True

			End Function

#End Region



#Region "private supporting fns"

			'Get the basic FtpWebRequest object with the
			'common settings and security
			Private Function GetRequest(ByVal URI As String) As FtpWebRequest

				'create request

				Dim result As FtpWebRequest = CType(FtpWebRequest.Create(URI), FtpWebRequest)

				'Set the login details

				result.Credentials = GetCredentials()

				'Do not keep alive (stateless mode)

				result.KeepAlive = False

				Return result

			End Function

			''' <summary>
			''' Get the credentials from username/password
			''' </summary>
            Private Function GetCredentials() As System.Net.ICredentials

                Return New System.Net.NetworkCredential(Username, Password)

            End Function

			''' <summary>
			''' returns a full path using CurrentDirectory for a relative file reference
			''' </summary>
			Private Function GetFullPath(ByVal file As String) As String

				If file.Contains("/") Then

					Return AdjustDir(file)

				Else

					Return Me.CurrentDirectory & file

				End If

			End Function

			''' <summary>
			''' Amend an FTP path so that it always starts with /
			''' </summary>
			''' <param name="path">Path to adjust</param>
			''' <returns></returns>
			''' <remarks></remarks>
			Private Function AdjustDir(ByVal path As String) As String

				Return CStr(IIf(path.StartsWith("/"), "", "/")) & path

			End Function

			Private Function GetDirectory(Optional ByVal directory As String = "") As String

				Dim URI As String

				If directory = "" Then

					'build from current

					URI = Hostname & Me.CurrentDirectory

					_lastDirectory = Me.CurrentDirectory

				Else

					If Not directory.StartsWith("/") Then Throw New ApplicationException("Directory should start with /")

					URI = Me.Hostname & directory

					_lastDirectory = directory

				End If

				Return URI

			End Function

			'stores last retrieved/set directory
			Private _lastDirectory As String = ""

			''' <summary>
			''' Obtains a response stream as a string
			''' </summary>
			''' <param name="ftp">current FTP request</param>
			''' <returns>String containing response</returns>
			''' <remarks>FTP servers typically return strings with CR and
			''' not CRLF. Use respons.Replace(vbCR, vbCRLF) to convert
			''' to an MSDOS string</remarks>
			Private Function GetStringResponse(ByVal ftp As FtpWebRequest) As String

				'Get the result, streaming to a string

				Dim result As String = ""

				Using response As FtpWebResponse = CType(ftp.GetResponse, FtpWebResponse)

					Dim size As Long = response.ContentLength

					Using datastream As Stream = response.GetResponseStream

						Using sr As New StreamReader(datastream)

							result = sr.ReadToEnd()

							sr.Close()

						End Using

						datastream.Close()

					End Using

					response.Close()

				End Using

				Return result

			End Function

			''' <summary>
			''' Gets the size of an FTP request
			''' </summary>
			''' <param name="ftp"></param>
			''' <returns></returns>
			''' <remarks></remarks>
			Private Function GetSize(ByVal ftp As FtpWebRequest) As Long

				Dim size As Long

				Using response As FtpWebResponse = CType(ftp.GetResponse, FtpWebResponse)

					size = response.ContentLength

					response.Close()

				End Using

				Return size

			End Function

#End Region



#Region "Properties"

			Private _hostname As String

			''' <summary>
			''' Hostname
			''' </summary>
			''' <value></value>
			''' <remarks>Hostname can be in either the full URL format
			''' ftp://ftp.myhost.com or just ftp.myhost.com
			''' </remarks>
			Public Property Hostname() As String

				Get

					If _hostname.StartsWith("ftp://") Then

						Return _hostname

					Else

						Return "ftp://" & _hostname

					End If

				End Get

				Set(ByVal value As String)

					_hostname = value

				End Set

			End Property

			Private _username As String

			''' <summary>
			''' Username property
			''' </summary>
			''' <value></value>
			''' <remarks>Can be left blank, in which case 'anonymous' is returned</remarks>
			Public Property Username() As String

				Get

					Return IIf(_username = "", "anonymous", _username)

				End Get

				Set(ByVal value As String)

					_username = value

				End Set

			End Property

			Private _password As String

			Public Property Password() As String

				Get

					Return _password

				End Get

				Set(ByVal value As String)

					_password = value

				End Set

			End Property

			''' <summary>
			''' The CurrentDirectory value
			''' </summary>
			''' <remarks>Defaults to the root '/'</remarks>
			Private _currentDirectory As String = "/"

			Public Property CurrentDirectory() As String

				Get

					'return directory, ensure it ends with /

					Return _currentDirectory & CStr(IIf(_currentDirectory.EndsWith("/"), "", "/"))

				End Get

				Set(ByVal value As String)

					If Not value.StartsWith("/") Then Throw New ApplicationException("Directory should start with /")

					_currentDirectory = value

				End Set

			End Property
#End Region



		End Class

#End Region
#Region "FTP file info class"

		''' <summary>
		''' Represents a file or directory entry from an FTP listing
		''' </summary>
		''' <remarks>
		''' This class is used to parse the results from a detailed
		''' directory list from FTP. It supports most formats of
		''' </remarks>
		Public Class FTPfileInfo
			'Stores extended info about FTP file
#Region "Properties"
			Public ReadOnly Property FullName() As String
				Get
					Return Path & Filename
				End Get
			End Property
			Public ReadOnly Property Filename() As String
				Get
					Return _filename
				End Get
			End Property
			Public ReadOnly Property Path() As String
				Get
					Return _path
				End Get
			End Property
			Public ReadOnly Property FileType() As DirectoryEntryTypes
				Get
					Return _fileType
				End Get
			End Property
			Public ReadOnly Property Size() As Long
				Get
					Return _size
				End Get
			End Property
			Public ReadOnly Property FileDateTime() As Date
				Get
					Return _fileDateTime
				End Get
			End Property
			Public ReadOnly Property Permission() As String
				Get
					Return _permission
				End Get
			End Property
			Public ReadOnly Property Extension() As String
				Get
					Dim i As Integer = Me.Filename.LastIndexOf(".")
					If i >= 0 And i < (Me.Filename.Length - 1) Then
						Return Me.Filename.Substring(i + 1)
					Else
						Return ""
					End If
				End Get
			End Property
			Public ReadOnly Property NameOnly() As String
				Get
					Dim i As Integer = Me.Filename.LastIndexOf(".")
					If i > 0 Then
						Return Me.Filename.Substring(0, i)
					Else
						Return Me.Filename
					End If
				End Get
			End Property
			Private _filename As String
			Private _path As String
			Private _fileType As DirectoryEntryTypes
			Private _size As Long
			Private _fileDateTime As Date
			Private _permission As String
#End Region
			''' <summary>
			''' Identifies entry as either File or Directory
			''' </summary>
			Public Enum DirectoryEntryTypes
				File
				Directory
			End Enum
			''' <summary>
			''' Constructor taking a directory listing line and path
			''' </summary>
			''' <param name="line">The line returned from the detailed directory list</param>
			''' <param name="path">Path of the directory</param>
			''' <remarks></remarks>
			Sub New(ByVal line As String, ByVal path As String)
				'parse line
				Dim m As Match = GetMatchingRegex(line)
				If m Is Nothing Then
					'failed
					Throw New ApplicationException("Unable to parse line: " & line)
				Else
					_filename = m.Groups("name").Value
					_path = path
					_size = CLng(m.Groups("size").Value)
					_permission = m.Groups("permission").Value
					Dim _dir As String = m.Groups("dir").Value
					If (_dir <> "" And _dir <> "-") Then
						_fileType = DirectoryEntryTypes.Directory
					Else
						_fileType = DirectoryEntryTypes.File
					End If

					Try
						_fileDateTime = Date.Parse(m.Groups("timestamp").Value)
					Catch ex As Exception
						_fileDateTime = Nothing
					End Try
				End If

			End Sub

			Private Function GetMatchingRegex(ByVal line As String) As Match

				Dim rx As Regex, m As Match
				For i As Integer = 0 To _ParseFormats.Length - 1
					rx = New Regex(_ParseFormats(i))
					m = rx.Match(line)
					If m.Success Then Return m
				Next

				Return Nothing

			End Function

#Region "Regular expressions for parsing LIST results"

			''' <summary>
			''' List of REGEX formats for different FTP server listing formats
			''' </summary>
			''' <remarks>
			''' The first three are various UNIX/LINUX formats, fourth is for MS FTP
			''' in detailed mode and the last for MS FTP in 'DOS' mode.
			''' I wish VB.NET had support for Const arrays like C# but there you go
			''' </remarks>
			Private Shared _ParseFormats As String() = { _
			 "(?<dir>[\-d])(?<permission>([\-r][\-w][\-xs]){3})\s+\d+\s+\w+\s+\w+\s+(?<size>\d+)\s+(?<timestamp>\w+\s+\d+\s+\d{4})\s+(?<name>.+)", _
			 "(?<dir>[\-d])(?<permission>([\-r][\-w][\-xs]){3})\s+\d+\s+\d+\s+(?<size>\d+)\s+(?<timestamp>\w+\s+\d+\s+\d{4})\s+(?<name>.+)", _
			 "(?<dir>[\-d])(?<permission>([\-r][\-w][\-xs]){3})\s+\d+\s+\d+\s+(?<size>\d+)\s+(?<timestamp>\w+\s+\d+\s+\d{1,2}:\d{2})\s+(?<name>.+)", _
			 "(?<dir>[\-d])(?<permission>([\-r][\-w][\-xs]){3})\s+\d+\s+\w+\s+\w+\s+(?<size>\d+)\s+(?<timestamp>\w+\s+\d+\s+\d{1,2}:\d{2})\s+(?<name>.+)", _
			 "(?<dir>[\-d])(?<permission>([\-r][\-w][\-xs]){3})(\s+)(?<size>(\d+))(\s+)(?<ctbit>(\w+\s\w+))(\s+)(?<size2>(\d+))\s+(?<timestamp>\w+\s+\d+\s+\d{2}:\d{2})\s+(?<name>.+)", _
			 "(?<timestamp>\d{2}\-\d{2}\-\d{2}\s+\d{2}:\d{2}[Aa|Pp][mM])\s+(?<dir>\<\w+\>){0,1}(?<size>\d+){0,1}\s+(?<name>.+)"}

#End Region
		End Class
#End Region
#Region "FTP Directory class"
		''' <summary>
		''' Stores a list of files and directories from an FTP result
		''' </summary>
		''' <remarks></remarks>
		Public Class FTPdirectory
			Inherits List(Of FTPfileInfo)
			Sub New()
				'creates a blank directory listing
			End Sub
			''' <summary>
			''' Constructor: create list from a (detailed) directory string
			''' </summary>
			''' <param name="dir">directory listing string</param>
			''' <param name="path"></param>
			''' <remarks></remarks>
			Sub New(ByVal dir As String, ByVal path As String)
				For Each line As String In dir.Replace(vbLf, "").Split(CChar(vbCr))
					'parse
					If line <> "" Then Me.Add(New FTPfileInfo(line, path))
				Next
			End Sub
			''' <summary>
			''' Filter out only files from directory listing
			''' </summary>
			''' <param name="ext">optional file extension filter</param>
			''' <returns>FTPdirectory listing</returns>
			Public Function GetFiles(Optional ByVal ext As String = "") As FTPdirectory
				Return Me.GetFileOrDir(FTPfileInfo.DirectoryEntryTypes.File, ext)
			End Function
			''' <summary>
			''' Returns a list of only subdirectories
			''' </summary>
			''' <returns>FTPDirectory list</returns>
			''' <remarks></remarks>
			Public Function GetDirectories() As FTPdirectory
				Return Me.GetFileOrDir(FTPfileInfo.DirectoryEntryTypes.Directory)
			End Function
			'internal: share use function for GetDirectories/Files
			Private Function GetFileOrDir(ByVal type As FTPfileInfo.DirectoryEntryTypes, Optional ByVal ext As String = "") As FTPdirectory
				Dim result As New FTPdirectory()
				For Each fi As FTPfileInfo In Me
					If fi.FileType = type Then
						If ext = "" Then
							result.Add(fi)
						ElseIf ext = fi.Extension Then
							result.Add(fi)
						End If
					End If
				Next
				Return result
			End Function
			Public Function FileExists(ByVal filename As String) As Boolean
				For Each ftpfile As FTPfileInfo In Me
					If ftpfile.Filename = filename Then
						Return True
					End If
				Next
				Return False
			End Function
			Private Const slash As Char = "/"
			Public Shared Function GetParentDirectory(ByVal dir As String) As String
				Dim tmp As String = dir.TrimEnd(slash)
				Dim i As Integer = tmp.LastIndexOf(slash)
				If i > 0 Then
					Return tmp.Substring(0, i - 1)
				Else
					Throw New ApplicationException("No parent for root")
				End If
			End Function
		End Class
#End Region
	End Class
#End Region
End Class
