Imports System.IO
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Partial Class util_pop_sendiddoc
    Inherits System.Web.UI.Page

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim debug As Boolean = True

        Dim leadId As Integer = Request.QueryString("leadId")
        'Dim dir As String = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir")
        Dim ext As String
        Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim PrivID As String = DataHelper.FieldTop1("tblLeadApplicant", "ProcessorID", "LeadApplicantID = " & leadId)
        Dim success As Boolean
        Dim filePath As String
        Dim documentId As String
        Dim response As Boolean

        If Not leadId > 0 Then
            Label1.Text = "Lead id not avail."
            Exit Sub
        End If

        If FileUpload1.HasFile Then
            ext = Path.GetExtension(FileUpload1.FileName).ToLower

            Dim docType As String = ddlDocTypes.SelectedItem.Value

            'Creates leadID directory on server and returns a string path
            filePath = CreateNewDocumentName(leadId, docType, PrivID, ext)

            'saves file uploaded to directory path
            FileUpload1.SaveAs(filePath)

            Select Case docType
                Case 2123
                    success = PrivicaHelper.UploadDocument(PrivID, filePath, "DriversLicence", "Driver's License", "Photo ID")
                    documentId = Guid.NewGuid().ToString & ext
                    AzureStorageHelper.ExportLeadDocumentTemp(FileUpload1.FileContent, documentId)
                Case 2124
                    success = PrivicaHelper.UploadDocument(PrivID, filePath, "StateID", "State Identification", "Photo ID")
                    documentId = Guid.NewGuid().ToString & ext
                    AzureStorageHelper.ExportLeadDocumentTemp(FileUpload1.FileContent, documentId)
                Case 2125
                    success = PrivicaHelper.UploadDocument(PrivID, filePath, "Passport", "Passport", "Photo ID")
                    documentId = Guid.NewGuid().ToString & ext
                    AzureStorageHelper.ExportLeadDocumentTemp(FileUpload1.FileContent, documentId)

                Case Else
                    Console.WriteLine("You typed something else")
            End Select

            If success Then
                Label1.ForeColor = Drawing.Color.Green
                Label1.Text = "Document Sent."
            Else
                Label1.ForeColor = Drawing.Color.Red
                Label1.Text = "Document Failed."
            End If

            If success Then
                response = PrivicaHelper.RequestReview(debug, PrivID)
            End If

            If response = True Then
                'email client login information
                PrivicaHelper.EmailClientPrivicaAccountInfo(leadId)

                'update database with values
                Dim cmd1 As SqlCommand
                Dim sql1 As New StringBuilder
                sql1.Append("update tblLeadApplicant set ")
                sql1.AppendFormat("LSALocked={0} ", 0)
                sql1.AppendFormat("where LeadApplicantID={0}", leadId)
                cmd1 = New SqlCommand(sql1.ToString, ConnectionFactory.Create())
                cmd1.Connection.Open()
                cmd1.ExecuteNonQuery()
                cmd1.Connection.Close()

            End If


            documentId = documentId.Replace(".gif", "").Replace(".pdf", "").Replace(".jpg", "").Replace(".jpeg", "")
            'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "CloseWindow", "closeAttach();", True)
            SaveLeadDocument(leadId, documentId, UserID, ddlDocTypes.SelectedItem.Value)

        Else
            Label1.Text = "No file selected."
        End If
    End Sub


    Public Shared Function CreateNewDocumentName(ByVal leadID As Integer, ByVal documentTypeID As String, ByVal processorID As String, ByVal ext As String) As String
        Dim tempName As New StringBuilder
        Dim tempPath As String
        Dim rootDIR As String = "e:\LeadTempDocs\"
        Dim dateStr As String = DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0")
        Dim sGUID As String
        sGUID = System.Guid.NewGuid.ToString()

        Dim tempDocID As String = String.Format("{0}_{1}_{2}_{3}{4}", processorID, documentTypeID, sGUID, dateStr, ext)

        tempPath = String.Format("{0}{1}\{2}", rootDIR, leadID, tempDocID)

        If Directory.Exists(rootDIR & leadID.ToString + "\") = False Then
            Directory.CreateDirectory(rootDIR & leadID.ToString + "\")
        End If

        Return tempPath
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

    Protected Sub util_pop_attachleaddoc_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsNothing(Request.QueryString("docType")) Then
            ds_DocTypes.SelectCommand = "select DocumentTypeID, DisplayName from tblDocumentType where DocumentTypeID = " & Request.QueryString("docType")
            ds_DocTypes.DataBind()
        End If
    End Sub

End Class
