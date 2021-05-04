Imports Microsoft.VisualBasic
Imports Microsoft.Azure
Imports Microsoft.WindowsAzure.Storage
Imports Microsoft.WindowsAzure.Storage.Blob
Imports System.Collections.Generic

Public Class AzureStorageHelper

    Public Shared Function GetClientsFiles(ByVal acct1 As Integer, ByVal filedir As String) As List(Of String)

        'Currently Producing this URL
        'https://lexxwarestore1.blob.core.windows.net/doctestfolder/7005543/ClientDocs/7005543_C2001_A5737387_170510.pdf?sv=2017-07-29&sr=b&sig=mrUO2VCNxpXSLjCpFKFOXzVNvrhyR6Ie5bZaCVGFLHE%3D&st=2018-06-28T18%3A04%3A44Z&se=2018-06-29T18%3A09%3A44Z&sp=racwdl

        Dim listofFiles As New List(Of String)
        Dim accountnumber As Integer = acct1
        Dim storage As String = filedir
        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("doctestfolder")

        ' ex. 7006784
        Dim acct As CloudBlobDirectory = container.GetDirectoryReference(accountnumber.ToString)

        ' ex. /clientdocs/
        Dim storagefolder As CloudBlobDirectory = acct.GetDirectoryReference(storage)

        'For each file
        For Each blob As IListBlobItem In storagefolder.ListBlobs()

            Dim strlst As String() = blob.Uri.ToString.Split(New Char() {"/"c})
            Dim filename As String = strlst(6).ToString()

            Dim blobfile As CloudBlockBlob = container.GetBlockBlobReference(accountnumber.ToString + "/" + storage.ToString + "/" + filename)
            'Create SAS for individual file 

            Dim sasConstraits As New SharedAccessBlobPolicy()
            sasConstraits.SharedAccessStartTime = DateTimeOffset.UtcNow.AddMinutes(-5)
            sasConstraits.SharedAccessExpiryTime = DateTimeOffset.UtcNow.AddHours(24)
            sasConstraits.Permissions = SharedAccessBlobPermissions.List AndAlso SharedAccessBlobPermissions.Read

            'Generate the Shared Access Signature on the Blob
            Dim querystringSAS As String = blobfile.GetSharedAccessSignature(sasConstraits)

            listofFiles.Add(blob.Uri.ToString() + querystringSAS)
        Next

        Return listofFiles

    End Function

    Public Shared Function GetLeadDocuments(ByVal DocumentId As String, Optional ByVal filedir As String = Nothing) As List(Of String)
        'Currently Producing this URL
        'https://lexxwarestore1.blob.core.windows.net/doctestfolder/7005543/ClientDocs/7005543_C2001_A5737387_170510.pdf?sv=2017-07-29&sr=b&sig=mrUO2VCNxpXSLjCpFKFOXzVNvrhyR6Ie5bZaCVGFLHE%3D&st=2018-06-28T18%3A04%3A44Z&se=2018-06-29T18%3A09%3A44Z&sp=racwdl

        Dim listofFiles As New List(Of String)

        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("leaddocuments")

        ' ex. 7006784
        If filedir IsNot Nothing Then
            Dim storage As String = filedir
            Dim storagefolder As CloudBlobDirectory = container.GetDirectoryReference(storage)
        End If

        'For each file
        For Each blob As IListBlobItem In container.ListBlobs()

            Dim strlst As String() = blob.Uri.ToString.Split(New Char() {"/"c})
            Dim filename As String = strlst(3).ToString()

            Dim blobfile As CloudBlockBlob = container.GetBlockBlobReference(filename)
            'Create SAS for individual file 

            Dim sasConstraits As New SharedAccessBlobPolicy()
            sasConstraits.SharedAccessStartTime = DateTimeOffset.UtcNow.AddMinutes(-5)
            sasConstraits.SharedAccessExpiryTime = DateTimeOffset.UtcNow.AddHours(24)
            sasConstraits.Permissions = SharedAccessBlobPermissions.List AndAlso SharedAccessBlobPermissions.Read

            'Generate the Shared Access Signature on the Blob
            Dim querystringSAS As String = blobfile.GetSharedAccessSignature(sasConstraits)

            listofFiles.Add(blob.Uri.ToString() + querystringSAS)
        Next

        Return listofFiles
    End Function

    Public Shared Sub ExportLeadDocumentTemp(ByVal doc As System.IO.Stream, ByVal DocId As String)

        ' Retrieve storage account information from connection string
        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("leaddocuments")
        'Dim acct As CloudBlobDirectory = container.GetDirectoryReference("temp")

        Try
            'Await container.CreateIfNotExistsAsync()
        Catch generatedExceptionName As StorageException
            Throw
        End Try

        Dim blockBlob As CloudBlockBlob = container.GetBlockBlobReference(DocId)

        ' Upload a BlockBlob to the newly created client ID container
        Select Case System.IO.Path.GetExtension(DocId)
            Case "pdf"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/pdf"
                blockBlob.SetProperties()
            Case "html"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "text/html"
                blockBlob.SetProperties()
            Case "wav"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/wav"
                blockBlob.SetProperties()
            Case Else
        End Select

        doc.Seek(0, System.IO.SeekOrigin.Begin)
        blockBlob.UploadFromStream(doc)

    End Sub

    Public Shared Sub ExportLeadDocumentAudio(ByVal doc As System.IO.Stream, ByVal DocId As String)

        ' Retrieve storage account information from connection string
        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("leaddocuments")
        Dim acct As CloudBlobDirectory = container.GetDirectoryReference("audio")

        Try
            'Await container.CreateIfNotExistsAsync()
        Catch generatedExceptionName As StorageException
            Throw
        End Try

        Dim blockBlob As CloudBlockBlob = container.GetBlockBlobReference(DocId)

        ' Upload a BlockBlob to the newly created client ID container
        Select Case System.IO.Path.GetExtension(DocId)
            Case "pdf"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/pdf"
                blockBlob.SetProperties()
            Case "html"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "text/html"
                blockBlob.SetProperties()
            Case "wav"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/wav"
                blockBlob.SetProperties()
            Case Else
        End Select

        doc.Seek(0, System.IO.SeekOrigin.Begin)
        blockBlob.UploadFromStream(doc)

    End Sub

    Public Shared Sub ExportClientUpload(ByVal doc As System.IO.Stream, ByVal DocId As String, ByVal AccountNumber As String, ByVal filedir As String)

        ' Retrieve storage account information from connection string
        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("doctestfolder")
        Dim acct As CloudBlobDirectory = container.GetDirectoryReference(AccountNumber)
        Dim acct1 As CloudBlobDirectory = acct.GetDirectoryReference(filedir)

        Try
            'Await container.CreateIfNotExistsAsync()
        Catch generatedExceptionName As StorageException
            Throw
        End Try

        Dim blockBlob As CloudBlockBlob = acct1.GetBlockBlobReference(DocId)
        blockBlob.FetchAttributes()
        blockBlob.SetProperties()

        ' Upload a BlockBlob to the newly created client ID container
        Select Case System.IO.Path.GetExtension(DocId)
            Case "pdf"
                blockBlob.Properties.ContentType = "application/pdf"
            Case "html"
                blockBlob.Properties.ContentType = "text/html"
            Case "wav"
                blockBlob.Properties.ContentType = "application/wav"
            Case Else
        End Select

        doc.Seek(0, System.IO.SeekOrigin.Begin)
        blockBlob.UploadFromStream(doc)

    End Sub

    Public Shared Sub ExportSIFUpload(ByVal doc As System.IO.Stream, ByVal DocId As String)

        ' Retrieve storage account information from connection string
        Dim storageAccount As CloudStorageAccount = CreateStorageAccountFromConnectionString(CloudConfigurationManager.GetSetting("StorageConnectionString"))

        ' Create a blob client for interacting with the blob service.
        Dim blobClient As CloudBlobClient = storageAccount.CreateCloudBlobClient()

        ' Create a container for organizing blobs within the storage account.
        Dim container As CloudBlobContainer = blobClient.GetContainerReference("doctestfolder")
        Dim acct As CloudBlobDirectory = container.GetDirectoryReference("sifupload")

        Try
            'Await container.CreateIfNotExistsAsync()
        Catch generatedExceptionName As StorageException
            Throw
        End Try

        Dim blockBlob As CloudBlockBlob = acct.GetBlockBlobReference(DocId)

        ' Upload a BlockBlob to the newly created client ID container
        Select Case System.IO.Path.GetExtension(DocId)
            Case "pdf"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/pdf"
                blockBlob.SetProperties()
            Case "html"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "text/html"
                blockBlob.SetProperties()
            Case "wav"
                blockBlob.FetchAttributes()
                blockBlob.Properties.ContentType = "application/wav"
                blockBlob.SetProperties()
            Case Else
        End Select

        doc.Seek(0, System.IO.SeekOrigin.Begin)
        blockBlob.UploadFromStream(doc)

    End Sub

    Private Shared Function CreateStorageAccountFromConnectionString(storageConnectionString As String) As CloudStorageAccount
        Dim storageAccount As CloudStorageAccount
        storageAccount = CloudStorageAccount.Parse(storageConnectionString)
        Return storageAccount
    End Function

End Class
