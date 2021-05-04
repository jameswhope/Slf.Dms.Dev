Imports System.Data.SqlClient
Imports System.IO
Imports Microsoft.Azure
Imports Microsoft.WindowsAzure.Storage
Imports Microsoft.WindowsAzure.Storage.Blob

Module Module1
    ''' <summary>
    ''' 1. .
    ''' 2. Inform all clients of impending draft date three days prior to draft date.
    ''' Clients will be informed via email if any of the forementioned events occur. 
    ''' </summary>
    ''' <remarks></remarks>
    Sub Main()

        'Variables
        Dim Debugging As Boolean = True
        Dim AccountNumber As Integer = -1

        RunTransferDocs(Debugging, AccountNumber)
    End Sub

    Public Sub RunTransferDocs(ByVal dBug As Boolean, ByVal Acct As Integer)

        'Announcement
        If dBug Then
            Console.WriteLine("Starting Transfer of Lead Documents in the Cloud to Client Documents also to the Cloud.")
        End If

        'Get List to Transfer
        Dim dt As DataTable = GetAllPossibleClients()

        Console.WriteLine(String.Format("Transferring {0} Documents.", dt.Rows.Count))

        For Each client As DataRow In dt.Rows

            Dim file As String = client("DocumentId")
            Dim filetype As String = client("DocumentTypeID")
            Dim accountnumber As String = client("AccountNumber")
            Dim clientid As String = client("ClientID")
            Dim folder As String = client("DocFolder")
            Dim ext As String = ""



            If file.Contains(".") Then
                Dim strArray As String() = file.Split(".")
                file = strArray(0).ToString
            End If

            If filetype = "345" Then
                ext = ".wav"
            Else
                ext = ".pdf"
            End If

            file = file + ext

            Dim newFileName As String = GetUniqueDocumentName(clientid, filetype, ext)

            TransferFile(file, newFileName, accountnumber, folder)

        Next

        Console.WriteLine("Ending Transfer of Lead Documents in the Cloud to Client Documents also to the Cloud.")
        Console.Read()
    End Sub

    Public Function GetUniqueDocumentName(ByVal AccountNumber As String, ByVal docTypeID As String, Optional ByVal ext As String = ".pdf") As String
        Dim ret As String

        ret = AccountNumber + "_" + docTypeID + "_" + GetDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ext

        Return ret
    End Function

    Private Function GetDocID() As String

        Dim docID As String = "A"

        Dim Query As String = "stp_GetDocumentNumber"
        docID += SqlHelper.ExecuteScalar(Query, CommandType.StoredProcedure).ToString()

        Return docID
    End Function

    Public Function GetAllPossibleClients() As DataTable

        Dim Query As String = "GetAllPossibleClientToTransfer"
        Return SqlHelper.GetDataTable(Query, CommandType.StoredProcedure)

    End Function

    Public Sub TransferFile(OldFileName As String, NewFileName As String, AccountNumber As String, Optional ByVal StorageDirectory As String = "")

        ' Storage Access
        Dim storageAccountOriginate As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))
        Dim storageAccountTarget As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClientTarget As CloudBlobClient = storageAccountTarget.CreateCloudBlobClient()
        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClientTarget.GetContainerReference("doctestfolder")
        ' ex. 7006784
        Dim TargetBlob As CloudBlockBlob

        ' Create a blob client for interacting with the blob service.
        Dim blobClientOriginate As CloudBlobClient = storageAccountOriginate.CreateCloudBlobClient()
        Dim containerOriginate As CloudBlobContainer = blobClientOriginate.GetContainerReference("leaddocuments")

        Dim SourceBlob As CloudBlockBlob = containerOriginate.GetBlockBlobReference(OldFileName)
        TargetBlob = container.GetBlockBlobReference(AccountNumber.ToString + "/" + StorageDirectory.ToString + "/" + NewFileName)
        Try
            TargetBlob.StartCopy(SourceBlob)
            'Console.WriteLine(String.Format("File Copied for Account: {0}, FileName: {1}", AccountNumber, OldFileName))
        Catch ex As Exception
            Console.WriteLine(String.Format("File Did Not Copy for Account: {0}, FileName: {1}, Error Message: {2}", AccountNumber, OldFileName, ex.Message))
        End Try


    End Sub

    Private Function CreateStorageAccountFromConnectionString(storageConnectionString As String) As CloudStorageAccount
        Dim storageAccount As CloudStorageAccount
        storageAccount = CloudStorageAccount.Parse(storageConnectionString)
        Return storageAccount
    End Function



End Module
