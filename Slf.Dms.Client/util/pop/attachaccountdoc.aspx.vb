Imports System.IO
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Collections.Generic

Partial Class util_pop_attachaccountdoc

    Inherits System.Web.UI.Page

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim clientid As Integer = Request.QueryString("id")
        Dim UserID As Integer
        Dim subfolder As String = Request.QueryString("rel")

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim ext As String
        Dim documentId As String

        Dim dir As String = CreateDirForClient(clientid)
        Dim docId As String = GetDocID()

        Dim value As String = ddlDocTypes.SelectedItem.Value
        Dim item As String = ddlDocTypes.SelectedValue

        Dim filePath As String = BuildAttachmentPath(value, docId, Now.ToString("yyMMdd"), clientid, subfolder)

        If FileUpload1.HasFile Then
            ext = Path.GetExtension(FileUpload1.FileName).ToLower

            If ext = ".i3r" Then

                'save file with GUID name and .i3r extension in directory and not in database
                documentId = filePath & ext
                FileUpload1.SaveAs(documentId)

                'convert file to .wav (saving .wav and deleting .i3r)
                ConvertFile_i3r_wav(documentId)

            Else

                documentId = filePath & ext
                FileUpload1.SaveAs(documentId)

            End If

            '-------
            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Try
                cmd.Connection.Open()

                Dim currentdatetime As DateTime = DateTime.Now

                cmd.CommandText = "insert into tbldocscan(docid, created,receiveddate,createdby)  values(@DocID, @currentdatetime, @currentdatetime, @UserID)"

                DatabaseHelper.AddParameter(cmd, "DocID", docId)
                DatabaseHelper.AddParameter(cmd, "currentdatetime", currentdatetime)
                DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                cmd.ExecuteNonQuery()

                cmd.Parameters.Clear()
                cmd.CommandText = "insert into tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder, RelatedDate, RelatedBy, DeletedFlag)  values (@ClientID, @RelationID, @RelationType, @DocTypeID, @RelDocID, @DateString, @SubFolder, @currentdatetime, @RelatedBy, 0);" '@latest=@@identity
                DatabaseHelper.AddParameter(cmd, "ClientID", clientid)
                DatabaseHelper.AddParameter(cmd, "RelationID", Request.QueryString("rel").ToString)
                DatabaseHelper.AddParameter(cmd, "RelationType", "account")
                DatabaseHelper.AddParameter(cmd, "SubFolder", subfolder)
                DatabaseHelper.AddParameter(cmd, "DocTypeID", item)
                DatabaseHelper.AddParameter(cmd, "RelDocID", docId)
                DatabaseHelper.AddParameter(cmd, "DateString", currentdatetime.ToString("yyMMdd"))

                DatabaseHelper.AddParameter(cmd, "currentdatetime", currentdatetime)
                DatabaseHelper.AddParameter(cmd, "RelatedBy", UserID)
                cmd.ExecuteNonQuery()

            Catch ex As Exception
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
            '-------

            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "CloseWindow", "closeAttach();", True)
        Else
            Label1.Text = "No file selected."
        End If
    End Sub

    Private Function GetDocID() As String
        Dim docID As String

        Dim query As String = "SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'"
        docID = SqlHelper.ExecuteScalar(query, CommandType.Text).ToString

        Dim stp As String = "stp_GetDocumentNumber"
        docID += SqlHelper.ExecuteScalar(stp, CommandType.StoredProcedure).ToString()

        Return docID
    End Function

    Public Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String = ""
        Dim tempDir As String = ""

        Dim query As String = "SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString()
        Dim dt As DataTable = SqlHelper.GetDataTable(query)

        Dim query2 As String = "SELECT DISTINCT [Name] FROM tblDocFolder"
        Dim dt2 As DataTable = SqlHelper.GetDataTable(query2)

        For Each dr As DataRow In dt.Rows
            rootDir = "\\" + dr("StorageServer").ToString + "\" + dr("StorageRoot").ToString + "\" + dr("AccountNumber").ToString + "\"
        Next

        If Not Directory.Exists(rootDir) Then
            Directory.CreateDirectory(rootDir)
        End If

        For Each dr As DataRow In dt2.Rows
            tempDir = rootDir + dr("Name").ToString
        Next

        If Not Directory.Exists(tempDir) Then
            Directory.CreateDirectory(tempDir)
        End If

        Return rootDir
    End Function

    Public Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByRef subFolder As String = "") As String
        Dim acctNo As String
        Dim server As String
        Dim storage As String
        Dim folder As String

        Dim query As String = "SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + clientID.ToString()
        Dim dt As DataTable = SqlHelper.GetDataTable(query)

        For Each dr As DataRow In dt.Rows
            acctNo = dr("AccountNumber").ToString()
            server = dr("StorageServer").ToString()
            storage = dr("StorageRoot").ToString()
        Next

        Dim query2 As String = "SELECT DocFolder FROM tblDocumentType WHERE TypeID = '" + docTypeID + "'"
        folder = SqlHelper.ExecuteScalar(query2, CommandType.Text)

        Dim param As New List(Of SqlParameter)
        param.Add(New SqlParameter("clientid", clientID))
        param.Add(New SqlParameter("accountid", Request.QueryString("rel").ToString))

        subFolder = subFolder + SqlHelper.ExecuteScalar("stp_getaccountfolder", CommandType.StoredProcedure, param.ToArray()) + "\"

        Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr
    End Function

    Private Sub ConvertFile_i3r_wav(fileName As String)
        'Set Appsettings
        Dim appFolder As String = System.Configuration.ConfigurationManager.AppSettings("Executables") & "encryptwave-w32r-1-1\"
        If Not appFolder Is Nothing AndAlso Not appFolder.Trim.Length = 0 Then
            Dim appCommand As String = Path.Combine(appFolder, "encryptwave-w32r-1-1.exe")
            Dim destFile As String = fileName.Replace(".i3r", ".wav")

            Dim psi As New System.Diagnostics.ProcessStartInfo(appCommand, String.Format("-d {0} {1}", fileName, destFile))
            psi.RedirectStandardOutput = False
            psi.WindowStyle = Diagnostics.ProcessWindowStyle.Hidden
            psi.UseShellExecute = False

            Dim runProcess As System.Diagnostics.Process
            runProcess = System.Diagnostics.Process.Start(psi)
            runProcess.WaitForExit(2000)
            If runProcess.HasExited Then
                If File.Exists(fileName) AndAlso File.Exists(destFile) Then
                    'File.Delete(fileName)
                End If
            End If
        End If

    End Sub

    Private Sub SaveLeadDocument(ByVal leadApplicantID As Integer, ByVal documentID As String, ByVal submittedBy As Integer, ByVal docType As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", leadApplicantID)
        DatabaseHelper.AddParameter(cmd, "DocumentId", documentID)
        DatabaseHelper.AddParameter(cmd, "DocumentTypeID", docType)
        DatabaseHelper.AddParameter(cmd, "SubmittedBy", submittedBy)
        DatabaseHelper.AddParameter(cmd, "Completed", Now)
        DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Uploaded")
        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadDocuments", "LeadDocumentID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

End Class
