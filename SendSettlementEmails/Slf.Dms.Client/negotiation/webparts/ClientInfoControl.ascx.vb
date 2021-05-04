Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class negotiation_webparts_ClientInfoControl
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Public accountID As String
    Public DataclientID As String
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

        If Not IsPostBack Then
            DataclientID = Request.QueryString("cid")
            accountID = Request.QueryString("crid")

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
                                DataclientID = ViewState("ClientDocuments_ClientID")
                                accountID = ViewState("ClientDocuments_AccountID")
                            End If
                        End Using
                    End Using
                End Using

            End If

            If accountID IsNot Nothing And DataclientID IsNot Nothing Then
                Me.LoadClientInfo(DataclientID, accountID)
                Me.hiddenIDs.Value = DataclientID & ":" & accountID
            End If
        End If

        If Not ViewState("ClientDocuments_ClientID") Is Nothing Then
            BuildDocumentPanes(ViewState("ClientDocuments_ClientID"), ViewState("ClientDocuments_AccountID"))
        End If

    End Sub
#End Region

#Region "Other Events"
    Protected Sub gvSummary_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                If Not rowView("CurrentCreditorName").ToString = "" Then
                    If Integer.Parse(rowView("verified")) = 0 And IsDBNull(rowView("settled")) Then
                        e.Row.Style("background-color") = "#FFFF99"
                    End If

                    Select Case rowView("AccountStatusID").ToString
                        Case "54"
                            e.Row.Style("background-color") = "rgb(210,255,210)"
                        Case "55"
                            e.Row.Style("background-color") = "rgb(255,210,210)"
                    End Select

                    Dim strAcct As String = e.Row.Cells(1).Text.Replace("(duplicate)", "")
                    If strAcct.Length > 3 And strAcct.ToString <> "&nbsp;" Then
                        e.Row.Cells(1).Text = Right(strAcct, 4)
                    End If
                End If
        End Select
    End Sub
    Protected Sub gvSummary_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvSummary.Sorting
        Dim dtSummary As DataTable = DirectCast(ViewState("gvSummaryDataSource"), DataTable)

        If Not dtSummary Is Nothing Then

            Dim dataView As DataView = New DataView(dtSummary)
            Dim sortExp As String = "[" & e.SortExpression & "]"

            If sortExp = "[Note]" Then
                sortExp = "[Subject],[Description] "
            End If
            If ViewState("SortDir") = "ASC" Then
                sortExp += " DESC"
                ViewState("SortDir") = "DESC"
            Else
                sortExp += " ASC"
                ViewState("SortDir") = "ASC"
            End If

            dataView.Sort = sortExp

            Dim dtSort As DataTable = dataView.ToTable
            gvSummary.DataSource = dtSort
            gvSummary.DataBind()

            ViewState("gvSummaryDataSource") = dtSort

        End If
    End Sub

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
    ''' <summary>
    ''' formats ssn
    ''' </summary>
    ''' <param name="SSN"></param>
    ''' <returns>###-##-#####</returns>
    ''' <remarks></remarks>
    Public Function FormatSSN(ByVal SSN As String) As String
        Dim strTemp As String
        Try
            strTemp = SSN.Substring(0, 3) & "-" & SSN.Substring(3, 2) & "-" & SSN.Substring(5, 4)
            Return strTemp
        Catch ex As Exception
            Return ""
        End Try
    End Function

    ''' <summary>
    ''' load client info
    ''' </summary>
    ''' <param name="strClientID"></param>
    ''' <remarks></remarks>
    Public Sub LoadClientInfo(ByVal strClientID As String, Optional ByVal strAccountID As String = Nothing)
        'removed creditor
        Dim sqlSelect As New StringBuilder
        sqlSelect.Append("SELECT c.accountnumber, p.PersonID, p.ClientID, p.SSN, p.FirstName, p.LastName, p.Gender, isnull(p.DateOfBirth,'') as [DateOfBirth], ")
        sqlSelect.Append("p.LanguageID, p.EmailAddress, p.Street, p.Street2, p.City, p.StateID, p.ZipCode, ")
        sqlSelect.Append("p.Relationship, p.CanAuthorize, p.Created, p.CreatedBy, p.LastModified, p.LastModifiedBy, ")
        sqlSelect.Append("p.WebCity, p.WebStateID, p.WebZipCode, p.WebAreaCode, p.WebTimeZoneID, p.ThirdParty, ")
        sqlSelect.Append("(CASE p.relationship WHEN 'prime' THEN 1 ELSE 0 END) AS isprime, s.Name AS statename, s.Abbreviation AS stateabbreviation, ")
        sqlSelect.Append("l.Name AS languagename, tblcreatedby.FirstName + ' ' + tblcreatedby.LastName AS createdbyname, ")
        sqlSelect.Append("tbllastmodifiedby.FirstName + ' ' + tbllastmodifiedby.LastName AS lastmodifiedbyname, DATEDIFF(day, ISNULL(YEAR(p.DateOfBirth), ")
        sqlSelect.Append("YEAR(GETDATE())), YEAR(GETDATE())) AS ClientAge, (CASE p.relationship WHEN 'prime' THEN 'Client' ELSE 'Co-Applicant' END) AS LabelHdr, tblCompany.Name as [SettlementAttorney] ")
        sqlSelect.Append("FROM tblPerson as p LEFT OUTER JOIN ")
        sqlSelect.Append("tblState as s ON p.StateID = s.StateID INNER JOIN tblLanguage as l ON p.LanguageID = l.LanguageID INNER JOIN ")
        sqlSelect.Append("tblClient as c ON p.ClientID = c.ClientID INNER JOIN tblCompany ON c.CompanyID = tblCompany.CompanyID LEFT OUTER JOIN ")
        sqlSelect.Append("tblUser AS tblcreatedby ON p.CreatedBy = tblcreatedby.UserID LEFT OUTER JOIN tblUser AS tbllastmodifiedby ON p.LastModifiedBy = tbllastmodifiedby.UserID ")
        sqlSelect.AppendFormat("WHERE (p.ClientID = {0}) ORDER BY isprime DESC, p.CanAuthorize DESC, p.DateOfBirth DESC ", strClientID)
        Using dtClient As Data.DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlSelect.ToString, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))

            For Each drow As DataRow In dtClient.Rows
                Me.lblHeader.Text = drow("LabelHdr").ToString & ":"
                Me.FirstNameLabel.Text = drow("FirstName").ToString
                Me.LastNameLabel.Text = drow("LastName").ToString
                Me.lblClientStreet.Text = drow("street").ToString
                Me.lblClientCity.Text = drow("city").ToString
                Me.SSNLabel.Text = Me.FormatSSN(drow("SSN").ToString)
                Me.ImgDialSSN.Attributes.Add("onclick", String.Format("parent.dialpad('{0}');", drow("SSN").ToString.Trim))
                Me.lblClientAge.Text = drow("ClientAge").ToString
                Me.stateabbreviationLabel.Text = drow("stateabbreviation").ToString
                Me.lblSettAtty.Text = drow("SettlementAttorney").ToString
                Me.lblClientAcctNum.Text = drow("Accountnumber").ToString
                Me.lblZipCode.Text = drow("ZipCode").ToString
                Me.lblClientStatus.Text = ClientHelper.GetStatus(strClientID)

                If FormatDateTime(drow("DateOfBirth").ToString, DateFormat.ShortDate) = "1/1/1900" Then
                    Me.lblDOB.Text = ""
                Else
                    Me.lblDOB.Text = FormatDateTime(drow("DateOfBirth").ToString, DateFormat.ShortDate)
                End If
                Exit For
            Next

          
            If dtClient.Rows.Count > 1 Then
                Me.coAppRow1.Style("display") = ""
                For i As Integer = 1 To dtClient.Rows.Count - 1
                    Dim cRow As Data.DataRow = dtClient.Rows(i)
                    Me.lblCoAppHdr.Text = cRow("LabelHdr").ToString & ": "
                    Me.lblCoAppFirst.Text = cRow("FirstName").ToString
                    Me.lblCoAppLast.Text = cRow("LastName").ToString
                    Me.lblCoAppSSN.Text = Me.FormatSSN(cRow("SSN").ToString)
                    Me.lblCoAppAge.Text = cRow("ClientAge").ToString
                    Me.lblCoappClientStreet.Text = cRow("street").ToString
                    Me.lblCoappClientCity.Text = cRow("city").ToString
                    Me.CoappstateabbreviationLabel.Text = cRow("stateabbreviation").ToString
                    Me.lblCoappZipCode.Text = cRow("ZipCode").ToString
                    If FormatDateTime(cRow("DateOfBirth").ToString, DateFormat.ShortDate) = "1/1/1900" Then
                        Me.lblCoappDOB.Text = ""
                    Else
                        Me.lblCoappDOB.Text = FormatDateTime(cRow("DateOfBirth").ToString, DateFormat.ShortDate)
                    End If
                Next
            Else
                Me.coAppRow1.Style("display") = "none"
                Me.lblCoAppHdr.Text = ""
                Me.lblCoAppFirst.Text = ""
                Me.lblCoAppLast.Text = ""
                Me.lblCoAppSSN.Text = ""
                Me.lblCoAppAge.Text = ""
                Me.lblCoappClientStreet.Text = ""
                Me.lblCoappClientCity.Text = ""
                Me.CoappstateabbreviationLabel.Text = ""
                Me.lblCoappZipCode.Text = ""
                Me.lblCoappDOB.Text = ""
            End If

        End Using
        'get acct summary
        sqlSelect = New StringBuilder
        sqlSelect.AppendFormat("get_ClientAccountOverviewList {0}", strClientID)
        Using dtSummary As Data.DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlSelect.ToString, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            Me.gvSummary.DataSource = dtSummary
            Me.gvSummary.DataBind()
            Dim intAcctCount As Integer = dtSummary.Select("currentcreditorname <> ''").Length
            Me.tcClientInformation.Tabs(1).HeaderText = "Account Summary (" & intAcctCount & ")"
            ViewState("gvSummaryDataSource") = Me.gvSummary.DataSource
        End Using
        If strAccountID IsNot Nothing Then
            BuildDocumentPanes(strClientID, strAccountID)
        End If


    End Sub

    Private Sub ClearForm()
        Me.coAppRow1.Style("display") = "none"
        Me.lblCoAppHdr.Text = ""
        Me.lblCoAppFirst.Text = ""
        Me.lblCoAppLast.Text = ""
        Me.lblCoAppSSN.Text = ""
        Me.lblCoAppAge.Text = ""
        Me.lblCoappClientStreet.Text = ""
        Me.lblCoappClientCity.Text = ""
        Me.CoappstateabbreviationLabel.Text = ""
        Me.lblCoappZipCode.Text = ""
        Me.lblCoappDOB.Text = ""
    End Sub

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

            accDocuments.RequireOpenedPane = False
            accDocuments.SelectedIndex = -1

            pnlDocuments.Visible = Not clientDocs Is Nothing Or Not creditorDocs Is Nothing Or Not legalDocs Is Nothing
            pnlNoDocuments.Visible = Not pnlDocuments.Visible
        End If
    End Sub

    Private Function BuildDocumentPane(ByVal root As String, ByVal name As String) As AccordionPane
        Dim pane As AccordionPane = Nothing
        Dim fileInfo As FileInfo()

        If Directory.Exists(root) Then
            Dim count As Integer
            Dim tempDoc As DocScan
            Dim docID As String
            Dim newName As String
            Dim table As New HtmlTable()


            table.Attributes.Add("style", "margin:0px;overflow-x:hidden;padding:0px;table-layout:fixed;width:90%;")
            table.Attributes.Add("cellpadding", "0")
            table.Attributes.Add("cellspacing", "0")
            table.Attributes.Add("nowrap", "nowrap")

            '02.09.09.ug
            'grab all documents for an accountid not just orig cred
            'also get docs in CreditorDocs root folder
            If name = "Creditor" Then
                Dim idx As Integer = root.LastIndexOf("\")
                Dim FolderName As String = root.Substring(idx + 1)
                Dim fInfo As String() = FolderName.Split("_")

                pane = New AccordionPane()

                Dim di As DirectoryInfo = New DirectoryInfo(root.Substring(0, idx))
                fileInfo = di.GetFiles()
                If fileInfo.Length > 0 Then
                    For Each subFile As FileInfo In fileInfo
                        If subFile.Name.ToLower <> "thumbs.db" Then
                            If Not subFile.Name.Contains("__") Then
                                table.Controls.Add(AddDocTableRow(subFile))
                                count += 1
                            End If
                        End If
                        
                    Next
                End If

                Dim directories() As DirectoryInfo = di.GetDirectories(fInfo(0) & "*", SearchOption.AllDirectories)
                For Each subDir As DirectoryInfo In directories
                    fileInfo = subDir.GetFiles()
                    If fileInfo.Length > 0 Then
                        For Each subFile As FileInfo In fileInfo
                            If subFile.Name.ToLower <> "thumbs.db" Then
                                If Not subFile.Name.Contains("__") Then
                                    table.Controls.Add(AddDocTableRow(subFile))
                                    count += 1
                                End If
                            End If
                            
                        Next
                    End If
                Next
                Dim header As New Literal()
                header.Text = name & " (" & CStr(count) & ")"

                pane.HeaderContainer.Controls.Add(header)
                pane.ContentContainer.Controls.Add(table)
            Else
                Dim dirInfo As New DirectoryInfo(root)
                fileInfo = dirInfo.GetFiles()

                If fileInfo.Length > 0 Then
                    pane = New AccordionPane()
                    For Each subFile As FileInfo In fileInfo
                        If subFile.Name.ToLower <> "thumbs.db" Then
                            If Not subFile.Name.Contains("__") Then
                                table.Controls.Add(AddDocTableRow(subFile))
                                count += 1
                            End If
                        End If
                    Next

                    Dim header As New Literal()
                    header.Text = name & " (" & CStr(count) & ")"

                    pane.HeaderContainer.Controls.Add(header)
                    pane.ContentContainer.Controls.Add(table)
                End If

            End If
        End If

        Return pane
    End Function
    Private Function AddDocTableRow(ByVal fileToParse As FileInfo) As HtmlTableRow
        Dim tempDoc As DocScan
        Dim docID As String
        Dim newName As String

        tempDoc = LoadDoc(fileToParse.Name, docID)

        newName = LocalHelper.GetVirtualDocFullPath(fileToParse.FullName)

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
        checkbox.Attributes.Add("onpropertychange", "javascript:SelectDocument(this, '" & fileToParse.FullName.Replace("\", "\\") & "');")
        tdCheckbox.Controls.Add(checkbox)

        tdImage.Attributes.Add("style", "text-align:center;width:20px;")

        imgDocument.Src = "~/negotiation/images/16x16_file.png"
        imgDocument.Attributes.Add("style", "border:0px;height:16px;width:16px;")
        imgDocument.Alt = ""
        tdImage.Controls.Add(imgDocument)

        tdDocumentName.Attributes.Add("style", "cursor:hand;overflow-x:hidden;text-align:left;width:auto;")
        tdDocumentName.Attributes.Add("nowrap", "nowrap")
        tdDocumentName.Attributes.Add("onclick", "javascript:OpenDocument('" + newName + "');")
        tdDocumentName.InnerText = tempDoc.DocumentName

        tr.Controls.Add(tdCheckbox)
        tr.Controls.Add(tdImage)
        tr.Controls.Add(tdDocumentName)

        Return tr

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

        Dim cmdStr As String = "SELECT isnull(dt.DisplayName, 'NA') as DisplayName, isnull(ds.ReceivedDate, '01-01-1900') as Received, isnull(ds.Created, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocumentType as dt left join tblDocScan as ds on ds.DocID = '" + docID + "' left join tblUser as u on u.UserID = ds.CreatedBy WHERE dt.TypeID = '" + docTypeID + "'"

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
                    cmd.CommandText = "SELECT dt.DisplayName, '01-01-1900' as Received, isnull(dr.RelatedDate, '01-01-1900') as Created, isnull(u.FirstName + ' ' + u.LastName, 'NA') as CreatedBy FROM tblDocRelation as dr left join tblUser as u on u.UserID = dr.RelatedBy inner join tblDocumentType as dt on dt.TypeID = '" + docTypeID + "' WHERE dr.DocID = '" + docID + "'"

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