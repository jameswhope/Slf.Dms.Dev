Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports LexxiomWebPartsControls

Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class negotiation_webparts_ClientDocuments
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer
#End Region

#Region "Structures"
    Public Structure DocScan
        Public DocumentName As String
        Public Received As String
        Public Created As String
        Public CreatedBy As String

        Public Sub New(ByVal _DocumentName As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.DocumentName = _DocumentName
            Me.Received = _Received
            Me.Created = _Created
            Me.CreatedBy = _CreatedBy
        End Sub
    End Structure
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Session("UserID") = UserID

        pnlDocuments.Visible = False
        pnlNoDocuments.Visible = True

        trDelete.Visible = False

        If Request.QueryString("sid") Is Nothing Then
            If Not Request.QueryString("cid") Is Nothing And ViewState("ClientDocuments_ClientID") Is Nothing Then
                ViewState("ClientDocuments_ClientID") = DataHelper.Nz_int(Request.QueryString("cid"), -1)
                ViewState("ClientDocuments_AccountID") = DataHelper.Nz_int(Request.QueryString("crid"), -1)
            End If

            If Not ViewState("ClientDocuments_ClientID") Is Nothing Then
                BuildDocumentPanes(ViewState("ClientDocuments_ClientID"), ViewState("ClientDocuments_AccountID"))
            End If
        Else
            Using cmd As New SqlCommand("SELECT ClientID, CreditorAccountID FROM tblSettlements WHERE SettlementID = " & Request.QueryString("sid"), _
            ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            ViewState("ClientDocuments_ClientID") = DataHelper.Nz_int(reader("ClientID"), -1)
                            ViewState("ClientDocuments_AccountID") = DataHelper.Nz_int(reader("CreditorAccountID"), -1)
                        End If
                    End Using
                End Using
            End Using

            If Not ViewState("ClientDocuments_ClientID") Is Nothing Then
                BuildDocumentPanes(ViewState("ClientDocuments_ClientID"), ViewState("ClientDocuments_AccountID"))
            End If
        End If
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        For Each str As String In hdnCurrentDoc.Value.Split("|")
            If File.Exists(str) Then
                File.Delete(str)
                SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(Path.GetFileName(str), UserID)
            End If
        Next

        BuildDocumentPanes(ViewState("ClientDocuments_ClientID"), ViewState("ClientDocuments_AccountID"))
    End Sub
#End Region

#Region "Utilities"
    Private Sub BuildDocumentPanes(ByVal clientID As Integer, ByVal accountID As Integer)
        If Not clientID = -1 Then
            Dim root As String = "\\" & DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " & clientID) + "\" & _
                DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " & clientID) & "\" & _
                DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & clientID) & "\"
            Dim clientRoot As String = root & "ClientDocs"
            Dim creditorRoot As String = root & "CreditorDocs\" & (accountID & "_" & AccountHelper.GetCreditorName(accountID)).Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")
            Dim legalRoot As String = root & "LegalDocs"

            accDocuments.Panes.Clear()

            Dim clientDocs As AccordionPane = BuildDocumentPane(clientRoot, "Client")
            Dim creditorDocs As AccordionPane = BuildDocumentPane(creditorRoot, "Creditor")
            Dim legalDocs As AccordionPane = BuildDocumentPane(legalRoot, "Legal")

            If Not clientDocs Is Nothing Then
                accDocuments.Panes.Add(clientDocs)
            End If

            If Not creditorDocs Is Nothing Then
                accDocuments.Panes.Add(creditorDocs)
            End If

            If Not legalDocs Is Nothing Then
                accDocuments.Panes.Add(legalDocs)
            End If

            Dim accountStatusID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblAccount", "AccountStatusID", "AccountID = " & accountID), -1)

            If Not (accountStatusID = 157 Or accountStatusID = 158 Or accountStatusID = 160) Then
                legalDocs = Nothing
            End If

            pnlDocuments.Visible = Not clientDocs Is Nothing Or Not creditorDocs Is Nothing Or Not legalDocs Is Nothing
            pnlNoDocuments.Visible = Not pnlDocuments.Visible
        End If
    End Sub

    Private Function BuildDocumentPane(ByVal root As String, ByVal name As String) As AccordionPane
        Dim pane As AccordionPane = Nothing

        If Directory.Exists(root) Then
            Dim dirInfo As New DirectoryInfo(root)
            Dim fileInfo As FileInfo() = dirInfo.GetFiles()

            Dim tempDoc As DocScan
            Dim docID As String
            Dim newName As String

            Dim table As New HtmlTable()

            table.Attributes.Add("style", "margin:0px;overflow-x:hidden;padding:0px;table-layout:fixed;width:90%;")
            table.Attributes.Add("cellpadding", "0")
            table.Attributes.Add("cellspacing", "0")
            table.Attributes.Add("nowrap", "nowrap")

            If fileInfo.Length > 0 Then
                Dim header As New Literal()
                header.Text = name

                pane = New AccordionPane()

                pane.HeaderContainer.Controls.Add(header)

                For Each subFile As FileInfo In fileInfo
                    If Not subFile.Name.Contains("__") Then
                        tempDoc = LoadDoc(subFile.Name, docID)

                        newName = LocalHelper.GetVirtualDocFullPath(subFile.FullName)

                        Dim tr As New HtmlTableRow()
                        Dim tdCheckbox As New HtmlTableCell()
                        Dim tdImage As New HtmlTableCell()
                        Dim tdDocumentName As New HtmlTableCell()
                        Dim checkbox As New HtmlInputCheckBox()
                        Dim imgDocument As New HtmlImage()

                        tr.Attributes.Add("style", "width:100%;")

                        tdCheckbox.Attributes.Add("style", "width:20px;")
                        tdCheckbox.Attributes.Add("nowrap", "nowrap")
                        tdCheckbox.Visible = False

                        checkbox.ID = "chk" & docID
                        checkbox.Attributes.Add("onpropertychange", "javascript:SelectDocument(this, '" & subFile.FullName.Replace("\", "\\") & "');")
                        tdCheckbox.Controls.Add(checkbox)

                        tdImage.Attributes.Add("style", "text-align:center;width:20px;")

                        imgDocument.Src = "~/negotiation/images/16x16_file.png"
                        imgDocument.Attributes.Add("style", "border:0px;height:16px;width:16px;")
                        imgDocument.Alt = ""
                        tdImage.Controls.Add(imgDocument)

                        tdDocumentName.Attributes.Add("style", "cursor:hand;text-align:left;width:auto;")
                        tdDocumentName.Attributes.Add("nowrap", "nowrap")
                        tdDocumentName.Attributes.Add("onclick", "javascript:OpenDocument('" + newName + "');")
                        tdDocumentName.InnerText = tempDoc.DocumentName

                        tr.Controls.Add(tdCheckbox)
                        tr.Controls.Add(tdImage)
                        tr.Controls.Add(tdDocumentName)

                        table.Controls.Add(tr)
                    End If
                Next

                pane.ContentContainer.Controls.Add(table)
            End If
        End If

        Return pane
    End Function

    Private Function LoadDoc(ByVal documentName As String, Optional ByRef outDocID As String = "") As DocScan
        Dim final As DocScan
        Dim docID As String
        Dim docTypeID As String
        Dim idx1 As Integer = documentName.IndexOf("_", 0) + 1
        Dim idx2 As Integer = documentName.IndexOf("_", idx1)

        docTypeID = documentName.Substring(idx1, idx2 - idx1)

        idx1 = documentName.IndexOf("_", idx2) + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)
        outDocID = docID

        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, 'NA') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocumentType as dt with(nolock) left join tblDocScan as ds with(nolock) on ds.DocID = '" + docID + "' left join tblUser as u with(nolock) on u.UserID = ds.CreatedBy WHERE dt.TypeID = '" + docTypeID + "'"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        final = New DocScan(DataHelper.Nz(reader("DisplayName"), "NA"), IIf(Date.Parse(reader("Received")).Year = 1900, "&nbsp;", Date.Parse(reader("Received")).ToString("d")), IIf(Date.Parse(reader("Created")).Year = 1900, "&nbsp;", Date.Parse(reader("Created")).ToString("d")), DataHelper.Nz(reader("CreatedBy"), "NA"))
                    Else
                        final = New DocScan(documentName, "", "", "")
                    End If
                End Using

                If final.Created.Length = 0 Then
                    cmd.CommandText = "SELECT dt.DisplayName, '01-01-1900' as Received, isnull(dr.RelatedDate, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocRelation as dr with(nolock) left join tblUser as u with(nolock) on u.UserID = dr.RelatedBy inner join tblDocumentType as dt with(nolock) on dt.TypeID = '" + docTypeID + "' WHERE dr.DocID = '" + docID + "'"

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            final = New DocScan(reader("DisplayName"), IIf(Date.Parse(reader("Received")).Year = 1900, "&nbsp;", Date.Parse(reader("Received")).ToString("d")), IIf(Date.Parse(reader("Created")).Year = 1900, "&nbsp;", Date.Parse(reader("Created")).ToString("d")), reader("CreatedBy"))
                        End If
                    End Using
                End If
            End Using
        End Using

        Return final
    End Function
#End Region



End Class