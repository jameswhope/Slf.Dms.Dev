Imports System.IO
Imports System.Data
Imports Drg.Util.DataAccess

Partial Class util_pop_attachleaddoc
    Inherits System.Web.UI.Page

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim leadId As Integer = Request.QueryString("leadId")
        'Dim dir As String = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir")
        Dim ext As String
        Dim documentId As String
        Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not leadId > 0 Then
            Label1.Text = "Lead id not avail."
            Exit Sub
        End If

        If FileUpload1.HasFile Then
            ext = Path.GetExtension(FileUpload1.FileName).ToLower

            If ext = ".i3r" Then

                'save file with GUID name and .i3r extension in directory and not in database
                'dir = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir") & "Audio/"
                documentId = Guid.NewGuid().ToString & ext
                AzureStorageHelper.ExportLeadDocumentAudio(FileUpload1.FileContent, documentId)

                'convert file to .wav (saving .wav and deleting .i3r)
                'ConvertFile_i3r_wav(String.Concat(dir, "\", documentId))
                'CallVerificationHelper.UpdateRecordedCallPath(leadId, String.Concat(dir, "\", documentId), True)

            ElseIf ext = ".wav" Then

                'dir = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir") & "Audio/"
                documentId = Guid.NewGuid().ToString & ext
                AzureStorageHelper.ExportLeadDocumentAudio(FileUpload1.FileContent, documentId)
                'CallVerificationHelper.UpdateRecordedCallPath(leadId, String.Concat(dir, "\", documentId), True)

            Else

                'save file with GUID in directory and save in database
                documentId = Guid.NewGuid().ToString & ext
                AzureStorageHelper.ExportLeadDocumentTemp(FileUpload1.FileContent, documentId)

            End If

            documentId = documentId.Replace(".pdf", "").Replace(".wav", "").Replace(".i3r", "")
            SaveLeadDocument(leadId, documentId, UserID, ddlDocTypes.SelectedItem.Value)
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "CloseWindow", "closeAttach();", True)
            Label1.Text = String.Format("File Completed.", documentId)
        Else
            Label1.Text = "No file selected."
        End If
    End Sub

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

    Protected Sub util_pop_attachleaddoc_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsNothing(Request.QueryString("docType")) Then
            ds_DocTypes.SelectCommand = "select DocumentTypeID, DisplayName from tblDocumentType where DocumentTypeID = " & Request.QueryString("docType")
            ds_DocTypes.DataBind()
        End If
    End Sub

End Class
