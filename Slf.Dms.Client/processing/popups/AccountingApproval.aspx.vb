Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Linq
Partial Class processing_popups_AccountingApproval
    Inherits System.Web.UI.Page
    Public UserID As Integer
    Public SettlementID As Integer
    Public MatterId As Integer

#Region "Structures"
    ''' <summary>
    ''' Structure to Hold the Document information pertaining to a Settlement
    ''' </summary>
    ''' <remarks>DocumentName is the Display name of the doc, FolderName (CreditorDocs/ClientDocs/LegalDocs), 
    ''' Filepath is the SubFolder and Filename(AcctNumber_DocTypeId_DocId_DateString.pdf/tif) of the document</remarks>
    Public Structure DocScan
        Public DocumentName As String
        Public FolderName As String
        Public FilePath As String

        Public Sub New(ByVal _DocumentName As String, ByVal _FolderName As String, ByVal _FilePath As String)
            Me.DocumentName = _DocumentName
            Me.FilePath = _FilePath
            Me.FolderName = _FolderName
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("mid") Is Nothing Then
            Response.Redirect("~/processing/")
        Else
            MatterId = Integer.Parse(Request.QueryString("mid"))
            SettlementID = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
        End If

        If Not Page.IsPostBack AndAlso SettlementID <> 0 Then
            Dim DataClientid As Integer = (DataHelper.FieldLookupIDs("tblSettlements", "ClientId", "SettlementId = " & SettlementID)(0))
            Dim acctNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientId = " & DataClientid)
            Me.SettCalcs.LoadSettlementInfo(SettlementID)
            Me.BuildDocuments(SettlementID, DataClientid, acctNumber)
        End If

    End Sub

    Private Sub BuildDocuments(ByVal _SettlementId As Integer, ByVal _ClientId As Integer, ByVal acctNumber As String)
        'TODO>>*****This code is duplicate of code from Client Documents Web part. See if the code can be centralized******'
        Dim root As String = "\\" & DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " & _ClientId) + "\" & _
            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " & _ClientId) & "\" & _
            acctNumber & "\"

        Dim DocList As List(Of DocScan)
        Dim newName As String
        Dim fileName As String
        Dim DocsToDisplay() As String = {"Settlement Acceptance Form", "Settlement in Full Letter", "Client Stipulation Letter (Signed)", "Restrictive Endorsement Letter", "Settlement Client Stipulation"}

        DocList = LoadDoc(_SettlementId)

        Dim tr As New HtmlTableRow()
        tr.Attributes.Add("class", "entry2")

        If DocList.Count > 0 Then
            For Each doc As DocScan In DocList
                'Create document only if they are settlement related: SAF, SIF, Scanned/recorded SAF

                If DocsToDisplay.Contains(doc.DocumentName) Then
                    fileName = root & doc.FolderName & "\" & doc.FilePath

                    If doc.DocumentName.Trim.ToLower = "settlement recorded call" Then
                        fileName = SettlementMatterHelper.FixSettlementRecordedExtension(fileName)
                    End If

                    If File.Exists(fileName) Then
                        newName = LocalHelper.GetVirtualDocFullPath(fileName)
                        Dim tdImage As New HtmlTableCell()
                        Dim tdDocumentName As New HtmlTableCell()
                        Dim imgDocument As New HtmlImage()

                        tdImage.Attributes.Add("style", "text-align:center;width:20px;")
                        imgDocument.Src = "~/images/16x16_pdf.png"
                        imgDocument.Attributes.Add("style", "border:0px;height:16px;width:16px;")
                        imgDocument.Alt = ""
                        tdImage.Controls.Add(imgDocument)

                        tdDocumentName.Attributes.Add("style", "cursor:hand;overflow-x:hidden;text-align:left;width:auto;")
                        tdDocumentName.Attributes.Add("nowrap", "nowrap")
                        tdDocumentName.Attributes.Add("onclick", "javascript:OpenDocument('" + newName + "');")
                        tdDocumentName.InnerText = doc.DocumentName

                        tr.Controls.Add(tdImage)
                        tr.Controls.Add(tdDocumentName)
                    End If
                End If
            Next
            If tr.Controls.Count > 0 Then
                tblDocuments.Rows.Add(tr)
                tblDocuments.Visible = True
            End If

        End If
    End Sub

    Private Function LoadDoc(ByVal _SettlementId As Integer) As List(Of DocScan)
        Dim final As New List(Of DocScan)

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_GetSettlementDocuments"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", _SettlementId)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim doc As New DocScan(DatabaseHelper.Peel_string(reader, "DocumentName"), DatabaseHelper.Peel_string(reader, "FolderName"), DatabaseHelper.Peel_string(reader, "FilePath"))
                        final.Add(doc)
                    End While
                End Using
            End Using
        End Using

        Return final
    End Function
End Class
