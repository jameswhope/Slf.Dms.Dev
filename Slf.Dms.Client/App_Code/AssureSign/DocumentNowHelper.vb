Imports Drg.Util.DataAccess
Imports Microsoft.VisualBasic
Imports System.Net
Imports System.Security.Cryptography
Imports System.Security.Cryptography.X509Certificates
Imports System.Data
Imports System.Data.SqlClient

Public Class DocumentNowHelper

    'AssureSign Administrator
    Private Const adminUserName As String = "jcook@lawfirmsd.com"
    Private Const adminUserPass As String = "pass"
    Private Const contextIdentifier As String = "05aa6b9b-cc8c-4014-abf0-ad8a04c8a70b"
    Private Const expirationDays As Integer = 30

    'AssureSign Templates
    'Private Shared templates() As String = {"012b07d5-09ae-de11-bc3c-00221958f751", _
    '                                        "9da2962d-0eae-de11-bc3c-00221958f751", _
    '                                        "2822c7f6-0aae-de11-bc3c-00221958f751", _
    '                                        "61d02940-10ae-de11-bc3c-00221958f751", _
    '                                        "b311fc7e-6fb3-de11-bc3c-00221958f751", _
    '                                        "34dd169c-72b3-de11-bc3c-00221958f751", _
    '                                        "e12506d3-6db3-de11-bc3c-00221958f751", _
    '                                        "45281534-73b3-de11-bc3c-00221958f751", _
    '                                        "5e0ad719-65b4-de11-bc3c-00221958f751"}

    Private Shared singleTemplates() As String = {"012b07d5-09ae-de11-bc3c-00221958f751", _
                                                  "48594bce-1db5-de11-bc3c-00221958f751", _
                                                  "b311fc7e-6fb3-de11-bc3c-00221958f751", _
                                                  "5e0ad719-65b4-de11-bc3c-00221958f751"}

    Private Shared singleCoverTemplates() As String = {"9da2962d-0eae-de11-bc3c-00221958f751", _
                                                       "c6a0f4b5-1fb5-de11-bc3c-00221958f751", _
                                                       "34dd169c-72b3-de11-bc3c-00221958f751", _
                                                       "c4b6c90a-24b5-de11-bc3c-00221958f751"}

    Private Shared coappTemplates() As String = {"2822c7f6-0aae-de11-bc3c-00221958f751", _
                                                 "fea51e60-27b5-de11-bc3c-00221958f751", _
                                                 "e12506d3-6db3-de11-bc3c-00221958f751", _
                                                 "5e0ad719-65b4-de11-bc3c-00221958f751"}

    Private Shared coappCoverTemplates() As String = {"61d02940-10ae-de11-bc3c-00221958f751", _
                                                      "d0631c98-28b5-de11-bc3c-00221958f751", _
                                                      "45281534-73b3-de11-bc3c-00221958f751", _
                                                      "c4b6c90a-24b5-de11-bc3c-00221958f751"}

    Public Enum DocType
        LSA
        LSACheck
        SchA
        Check
    End Enum

    'Public Enum DocType
    '    SingleClientLSA
    '    SingleClientLSAwithCover
    '    DualClientLSA
    '    DualClientLSAwithCover
    '    SingleClientScheduleA
    '    SingleClientScheduleAwithCover
    '    DualClientScheduleA
    '    DualClientScheduleAwithCover
    '    VoidedCheck
    'End Enum

    Public Shared Sub SendDocument(ByVal pdf As Byte(), ByVal firstName As String, ByVal lastName As String, ByVal leadEmail As String, ByVal leadApplicantID As Integer, ByVal userID As Integer, ByVal docType As DocType, ByVal bIncludeCoverLetter As Boolean)
        Dim client As New SubmitServiceClient
        Dim docs(0) As FileDocument
        Dim doc As New FileDocument
        Dim meta As New Metadata
        Dim temp As New Template
        Dim params(3) As Parameter
        Dim param As Parameter
        Dim file As New UnderlyingFile
        Dim result() As DocumentResult
        Dim bHasCoApp As Boolean = HasCoApplicant(leadApplicantID)

        firstName = StrConv(firstName, VbStrConv.ProperCase).Trim
        lastName = StrConv(lastName, VbStrConv.ProperCase).Trim

        meta.UserName = adminUserName
        meta.DocumentName = firstName & " " & lastName
        meta.ExpirationDate = CDate(Format(Now.AddDays(expirationDays), "yyyy-MM-dd"))
        meta.ExpirationDateSpecified = True

        param = New Parameter
        param.Name = "Signatory 1 Email Address"
        param.Value = Trim(leadEmail)
        params(0) = param

        param = New Parameter
        param.Name = "Signatory 1 First Name"
        param.Value = firstName
        params(1) = param

        param = New Parameter
        param.Name = "Signatory 1 Last Name"
        param.Value = lastName
        params(2) = param

        param = New Parameter
        param.Name = "Signatory 1 Password"
        param.Value = ""
        params(3) = param

        temp.Parameters = params

        If bHasCoApp Then
            If bIncludeCoverLetter Then
                temp.Id = New Guid(coappCoverTemplates(docType))
            Else
                temp.Id = New Guid(coappTemplates(docType))
            End If
        Else
            If bIncludeCoverLetter Then
                temp.Id = New Guid(singleCoverTemplates(docType))
            Else
                temp.Id = New Guid(singleTemplates(docType))
            End If
        End If

        file.FileType = SupportedFileType.PDF
        file.Data = pdf

        doc.ContextIdentifier = New Guid(contextIdentifier)
        doc.Metadata = meta
        doc.Template = temp
        doc.UnderlyingFile = file
        docs(0) = doc

        client.ClientCredentials.UserName.UserName = adminUserName
        client.ClientCredentials.UserName.Password = adminUserPass

        ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)

        Try
            result = client.SubmitWithFile(docs)
            SaveLeadDocument(leadApplicantID, Convert.ToString(result(0).Id), Convert.ToString(result(0).AuthToken), userID, leadEmail)
        Catch ex As Exception
            LogException(ex.Message)
        Finally
            If client.State <> ServiceModel.CommunicationState.Closed Then
                client.Close()
            End If
        End Try
    End Sub

    'Public Shared Sub SendDocuments(ByVal rDocs As Collections.Generic.Dictionary(Of String, GrapeCity.ActiveReports.SectionReport), ByVal firstName As String, ByVal lastName As String, ByVal leadEmail As String, ByVal leadApplicantID As Integer, ByVal userID As Integer)
    '    Dim client As New SubmitServiceClient
    '    Dim docs(rDocs.Count - 1) As FileDocument
    '    Dim doc As FileDocument
    '    Dim docType As DocType
    '    Dim meta As New Metadata
    '    Dim temp As Template
    '    Dim params(3) As Parameter
    '    Dim param As Parameter
    '    Dim file As UnderlyingFile
    '    Dim result() As DocumentResult
    '    Dim bHasCoApp As Boolean = HasCoApplicant(leadApplicantID)
    '    Dim memStream As System.IO.MemoryStream
    '    Dim pdf As GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
    '    Dim i As Integer

    '    firstName = StrConv(firstName, VbStrConv.ProperCase).Trim
    '    lastName = StrConv(lastName, VbStrConv.ProperCase).Trim

    '    meta.UserName = adminUserName
    '    meta.DocumentName = firstName & " " & lastName
    '    meta.ExpirationDate = CDate(Format(Now.AddDays(expirationDays), "yyyy-MM-dd"))
    '    meta.ExpirationDateSpecified = True

    '    param = New Parameter
    '    param.Name = "Signatory 1 Email Address"
    '    param.Value = Trim(leadEmail)
    '    params(0) = param

    '    param = New Parameter
    '    param.Name = "Signatory 1 First Name"
    '    param.Value = firstName
    '    params(1) = param

    '    param = New Parameter
    '    param.Name = "Signatory 1 Last Name"
    '    param.Value = lastName
    '    params(2) = param

    '    param = New Parameter
    '    param.Name = "Signatory 1 Password"
    '    param.Value = ""
    '    params(3) = param

    '    For Each rDoc In rDocs
    '        docType = StringToEnum(Of DocType)(rDoc.Key)

    '        temp = New Template
    '        temp.Id = New Guid(singleTemplates(docType))
    '        temp.Parameters = params

    '        memStream = New System.IO.MemoryStream
    '        pdf = New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
    '        pdf.Export(rDoc.Value.Document, memStream)
    '        memStream.Seek(0, IO.SeekOrigin.Begin)

    '        file = New UnderlyingFile
    '        file.FileType = SupportedFileType.PDF
    '        file.Data = memStream.ToArray

    '        doc = New FileDocument
    '        doc.ContextIdentifier = New Guid(contextIdentifier)
    '        doc.Metadata = meta
    '        doc.Template = temp
    '        doc.UnderlyingFile = file

    '        docs(i) = doc
    '        i += 1
    '    Next

    '    client.ClientCredentials.UserName.UserName = adminUserName
    '    client.ClientCredentials.UserName.Password = adminUserPass

    '    ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)

    '    Try
    '        result = client.SubmitWithFile(docs)
    '        SaveLeadDocument(leadApplicantID, Convert.ToString(result(0).Id), Convert.ToString(result(0).AuthToken), userID, leadEmail)
    '    Catch ex As Exception
    '        LogException(ex.Message)
    '    Finally
    '        If client.State <> ServiceModel.CommunicationState.Closed Then
    '            client.Close()
    '        End If
    '    End Try
    'End Sub

    Public Shared Sub LeadDocumentComplete(ByVal documentId As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim sendTo As String
        Dim tbl As DataTable
        Dim subject As String
        Dim body As String

        Try
            DatabaseHelper.AddParameter(cmd, "Completed", Now)
            DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Document signed")
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblLeadDocuments", String.Format("DocumentId='{0}'", documentId))
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

            'now notify the originator
            cmd.Parameters.Clear()
            cmd.CommandText = String.Format("select u.username, d.leadapplicantid, l.firstname + ' ' + l.lastname [lead] from tbluser u join tblleaddocuments d on d.submittedby = u.userid and d.documentid='{0}' join tblleadapplicant l on l.leadapplicantid = d.leadapplicantid", documentId)
            tbl = DatabaseHelper.ExecuteDataset(cmd).Tables(0)
            sendTo = tbl.Rows(0)("username") & "@lexxiom.com"
            subject = String.Format("Lead Documents Complete for {0}", tbl.Rows(0)("lead"))
            body = String.Format("<a href='http://service.lexxiom.com/clients/enrollment/newenrollment2.aspx?id={0}' target='_blank'>Click here to view</a>", tbl.Rows(0)("leadapplicantid"))
            EmailHelper.SendMessage("donotreply@lexxiom.com", sendTo, subject, body)
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Shared Sub LogException(ByVal message As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        '************Change table
        DatabaseHelper.AddParameter(cmd, "ExportData", message)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadExportData", "LeadExportDataID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Shared Function customCertificateValidation(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As Security.SslPolicyErrors) As Boolean
        Return True
    End Function

    Private Shared Sub SaveLeadDocument(ByVal leadApplicantID As Integer, ByVal documentID As String, ByVal authToken As String, ByVal submittedBy As Integer, ByVal signatoryEmail As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", leadApplicantID)
        DatabaseHelper.AddParameter(cmd, "DocumentId", documentID)
        DatabaseHelper.AddParameter(cmd, "AuthToken", authToken)
        DatabaseHelper.AddParameter(cmd, "SubmittedBy", submittedBy)
        DatabaseHelper.AddParameter(cmd, "SignatoryEmail", signatoryEmail)
        DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Waiting on signatures")
        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadDocuments", "LeadDocumentID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Shared Function HasCoApplicant(ByVal leadApplicantID As Integer) As Boolean
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()

        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("select count(*) from tblleadcoapplicant where leadapplicantid={0}", leadApplicantID)

        Return (CInt(DatabaseHelper.ExecuteScalar(cmd)) > 0)
    End Function

    'Private Shared Function StringToEnum(Of T)(ByVal name As String) As T
    '    Return DirectCast([Enum].Parse(GetType(T), name), T)
    'End Function

End Class
