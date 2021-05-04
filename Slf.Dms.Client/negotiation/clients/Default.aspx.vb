Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Web.Script.Services
Imports System.Web.Services

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates
Imports iTextSharp.text.pdf
Imports System.Globalization

Partial Class negotiation_clients_Default
    Inherits System.Web.UI.Page

#Region "Fields"

    Public CreditorInstanceID As String
    Public DataclientID As String
    Public UserID As String
    Public creditorID As String

    Private creds As Dictionary(Of Integer, LetterTemplates.CreditorInfo)

#End Region 'Fields

#Region "Methods"

    Public Shared Function GetMonthlySpan(clientid As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("clientId", clientid))

        Return SqlHelper.GetDataTable("stp_GetMonthlySpanByClientId", CommandType.StoredProcedure, params.ToArray)

    End Function

    <System.Web.Services.WebMethodAttribute()>
    Public Shared Function getSpan(ByVal clientid As String) As String
        Dim result As String = ""
        Dim MinimumMonth As Double = 0.0
        Try
            Using dt As DataTable = GetMonthlySpan(clientid)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem"" align=""left"">Month/Year</th>")
                    tbl.Append("<th class=""headitem"" align=""right"">Amount Left</th>")
                    tbl.Append("</tr>")
                    Dim i As Integer = 0
                    Dim tdCSSClass As String = ""
                    Dim convTot As Double = 0, revTot As Double = 0
                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#EAEAEA;"">")
                        End If
                        tdCSSClass = "griditem"
                        tbl.AppendFormat("<td class=""{2}"">{0} {1}</td>", CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(dr("month").ToString), dr("year").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""right"">{0}</td>", FormatCurrency(IIf(IsDBNull(dr("amount")), 0, dr("amount").ToString), 2, TriState.True, TriState.False, TriState.True), tdCSSClass)
                        tbl.Append("</tr>")

                        'Select Lowest Month Amount
                        MinimumMonth += IIf(IsDBNull(dr("amount")), 0, Val(dr("amount")))

                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem"" align=""right"">{0}</th>", FormatCurrency(MinimumMonth, 2, TriState.True, TriState.False, TriState.True))
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No Information Is Available.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethodAttribute()>
    Public Shared Function PM_sendLOR(ByVal dClientID As String, ByVal credInstID As String, ByVal sendTypeDescr As String, ByVal sendToAddress As String, ByVal LORPAth As String, ByVal currentUserID As String) As String
        Dim result As String = ""
        Dim sBody As New StringBuilder
        Dim recips As New List(Of String)
        Dim poaPath As String = String.Empty
        Dim clientSixNumber As String = String.Empty
        Dim firmURL As String = String.Empty
        Dim bGotPOA As Boolean = False

        Using dtClient As DataTable = SqlHelper.GetDataTable(String.Format("select accountnumber ,website " &
                                                                           "from tblclient c WITH(NOLOCK) " &
                                                                           "inner join tblCompany co WITH(NOLOCK) ON c.CompanyID = co.CompanyID " &
                                                                           "where clientid = {0}", dClientID), CommandType.Text)
            For Each c As DataRow In dtClient.Rows
                clientSixNumber = c("accountnumber").ToString
                firmURL = c("website").ToString.Replace("www.", "")
                Exit For
            Next
        End Using


        If String.IsNullOrEmpty(sendToAddress) Then
            Throw New Exception("Send to is required!")
        End If
        If String.IsNullOrEmpty(credInstID) Then
            Throw New Exception("Problem getting Creditor information!")
        End If
        If String.IsNullOrEmpty(LORPAth) Then
            Throw New Exception("Problem getting document!")
        End If

        'get poa doc if it exists
        Dim ServerPath As String = String.Format("\\{0}", ConfigurationManager.AppSettings("storage_documentPath").ToString).Replace("\\", "\")
        Dim clientDIR As New IO.DirectoryInfo(ServerPath & "\" & clientSixNumber.Trim & "\clientdocs")
        Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf")
        For Each cFile As IO.FileInfo In clientFiles
            Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
            If fileParts.Length > 1 Then
                Select Case fileParts(1).ToString
                    Case "9019"
                        poaPath = cFile.FullName
                        bGotPOA = True
                        Exit For
                End Select
            End If
        Next


        Select Case sendTypeDescr
            Case "e"
                recips.Add(sendToAddress)
                Dim letterName As String = "LetterOfRepresentation"
                Dim letterHTML As New StringBuilder

                sBody.Append("To Whom it May Concern:<br/><br/>")
                sBody.Append("Attached to this e-mail is the Letter of Representation from the Law Firm.   ")
                sBody.Append("Per our recent conversation the Law Firm is providing you with the attached documents.<br/>")
                sBody.Append("<ul><li>Letter Of Representation</li>")

                Dim atts As New List(Of String)
                atts.Add(LORPAth)
                If bGotPOA Then
                    atts.Add(poaPath)
                    sBody.Append("<li>Power of Attorney</li>")
                End If
                sBody.Append("</ul>")

                For Each r As String In recips
                    EmailHelper.SendMessage(String.Format("noreply@{0}", firmURL), r, "Letter of Representation from Law Office".ToUpper, sBody.ToString, atts)
                Next
                NoteHelper.InsertNote(String.Format("Letter of Representation has been emailed to {0}.", sendToAddress), currentUserID, dClientID)
                result = "Document has been emailed!"
            Case "f"

                Try
                    'Dim objFaxDocument As New FAXCOMEXLib.FaxDocument
                    'Dim objFaxServer As New FAXCOMEXLib.FaxServer
                    'Dim objSender As FaxSender
                    'Dim JobID As Object

                    'objFaxServer.Connect("LAB1-STU15")
                    'objFaxDocument.Body = LORPAth
                    'objFaxDocument.DocumentName = "My First Fax"
                    'objFaxDocument.Recipients.Add(sendToAddress)
                    'objFaxDocument.AttachFaxToReceipt = True
                    'objFaxDocument.Note = "Letter of Representation"
                    'objFaxDocument.Subject = "Today's fax"
                    'JobID = objFaxDocument.ConnectedSubmit(objFaxServer)
                    'result = "The Job ID is :" & JobID(0)
                    NoteHelper.InsertNote(String.Format("Letter of Representation has been faxed to {0}.", sendToAddress), currentUserID, dClientID)
                Catch ex As Exception
                    Throw ex
                End Try

        End Select

        Return result

    End Function
    <System.Web.Services.WebMethodAttribute()>
    Public Shared Sub PM_sendOverwriteNotice(ByVal settID As String, ByVal userID As Integer)

        Dim recips As New List(Of String)
        'recips.Add("RFakhoury@lawfirmcsd.com")
        recips.Add("ugreenridge@lexxiom.com")

        Dim sBody As New StringBuilder
        Dim overwriteUser As String = UserHelper.GetName(userID)
        sBody.AppendLine(String.Format("{0} has overwritten a settlement matter.<br>", overwriteUser))

        Dim ssql As String = "select top 1 [OrigNeg]=u.FirstName + ' ' + u.LastName,[CreditorName]=cr.name + ' #' + right(ci.AccountNumber,4),s.created ,[ClientName]=p.FirstName + ' ' + p.lastname,c.AccountNumber from tblSettlements s WITH(NOLOCK) " & _
                            "inner join tblUser u WITH(NOLOCK) ON s.CreatedBy = u.UserID inner join tblaccount a WITH(NOLOCK) " & _
                            "ON s.CreditorAccountID = a.AccountID inner join tblCreditorInstance ci WITH(NOLOCK) ON " & _
                            "ci.CreditorInstanceID = a.CurrentCreditorInstanceID inner join tblCreditor cr with(nolock) " & _
                            "on ci.creditorid = cr.CreditorID inner join tblClient c WITH(NOLOCK) on c.clientid=s.ClientID inner join tblperson p WITH(NOLOCK) on p.PersonID=c.PrimaryPersonID "
        ssql += String.Format("where status = 'a' AND active = 1 and SettlementID = {0}", settID)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                sBody.AppendLine(String.Format("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Client: {0} - {1}<br>", dr("clientname").ToString, dr("accountnumber").ToString))
                sBody.AppendLine(String.Format("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Creditor: {0}<br>", dr("CreditorName").ToString))
                sBody.AppendLine(String.Format("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Created by: {0}<br>", dr("OrigNeg").ToString))
                sBody.AppendLine(String.Format("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Created on: {0}<br>", dr("created").ToString))
                Exit For
            Next
        End Using


        For Each r As String In recips
            EmailHelper.SendMessage("itgroup@lexxiom.com", r, "Settlement Matter Overwritten!".ToUpper, sBody.ToString)
        Next

    End Sub
    Protected Sub AvailableNegotiations_LoadSettlement(ByVal sDataClientID As String, ByVal sAccountID As String) Handles AvailableNegotiations.LoadSettlement
        'load new client and account for settlement process
        'retrieve current selected row from available negotiations
        'load settlement user controls
        Me.AvailableNegotiations.StartSession(sDataClientID, sAccountID, Me.UserID)
        Me.SettlementClientInfoControl1.LoadClientInfo(sDataClientID, sAccountID)
        Me.SettlementCreditorInfoControl1.LoadCreditorInfo(sAccountID, sDataClientID, False)
        Me.SettlementCalculatorControl1.LoadAccountInfo(sDataClientID, sAccountID)
        Me.SessionNotesControl1.BindGrid(sDataClientID, sAccountID)
        Me.SessionNotesControl1.LoadInfoData(sDataClientID, sAccountID, True)
    End Sub

    Protected Sub AvailableNegotiations_MyAssignments(ByVal count As String) Handles AvailableNegotiations.MyAssignments
        hMyAssignments.InnerHtml = "<img src='../images/minimize_off.png' width='20' height='22' border='0' align='right' style='cursor: hand;' onclick='dyntog(div_assign,this)' title='Click to Minimize the table' /> My Assignments (" & count & ")"
    End Sub

    Protected Sub AvailableNegotiations_ResetGuid(ByVal newNoteID As String) Handles AvailableNegotiations.ResetGuid
        'reset the guid for all controls
        Me.SettlementCalculatorControl1.noteID = newNoteID
        Me.SettlementCreditorInfoControl1.noteID = newNoteID
        Me.SessionNotesControl1.noteID = newNoteID

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'get current userid and store in session
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("cid") IsNot Nothing Then
            DataclientID = Request.QueryString("cid")
        End If

        If Request.QueryString("crid") IsNot Nothing Then
            creditorID = Request.QueryString("crid")
            CreditorInstanceID = Drg.Util.DataHelpers.AccountHelper.GetCurrentCreditorInstanceID(creditorID)
        End If

        If Not IsPostBack Then

            'retrieve client and creditor accountid from url
            creditorID = Request.QueryString("crid")
            DataclientID = Request.QueryString("cid")

            'not present nothing selected show nothing
            If creditorID Is Nothing And DataclientID Is Nothing Then
                Dim SettID As String = Request.QueryString("sid")
                If SettID IsNot Nothing Then
                    Me.SettlementCalculatorControl1.LoadSettlementInfo(SettID)
                    'load settlement user controls
                    Me.AvailableNegotiations.StartSession(DataclientID, Me.SettlementCalculatorControl1.accountID, UserID)
                    creditorID = Me.SettlementCalculatorControl1.accountID
                    Me.SettlementClientInfoControl1.LoadClientInfo(Me.SettlementCalculatorControl1.DataClientID, Me.SettlementCalculatorControl1.accountID)
                    Me.SettlementCreditorInfoControl1.LoadCreditorInfo(Me.SettlementCalculatorControl1.accountID, Me.SettlementCalculatorControl1.DataClientID, True)
                    Me.SessionNotesControl1.LoadInfoData(Me.SettlementCalculatorControl1.DataClientID, Me.SettlementCalculatorControl1.accountID, True)

                Else
                    creditorID = -1
                    Exit Sub
                End If
                'Else
                'Me.AvailableNegotiations.StartSession(DataclientID, creditorID, UserID)
            End If

            'payment calculator control
            PaymentArrangementCalculator.DataClientID = DataclientID
            PaymentArrangementCalculator.AccountID = creditorID
            'PaymentArrangementCalculator.ViewInfoBlock(True)
            PaymentArrangementCalculator.Show()

            Me.AvailableNegotiations.StartSession(DataclientID, creditorID, UserID)

            NegotiationHelper.RegisterClientVisit(DataclientID, UserID)

            ReportsControl1.UserID = UserID
            ReportsControl1.DataClientID = DataclientID
            ReportsControl1.CreditorAccountID = creditorID

        End If



    End Sub

    Protected Sub SessionNotesControl_NewNote(ByVal noteID As Integer) Handles SessionNotesControl1.NewNote
        Me.SettlementCalculatorControl1.noteID = noteID
        Me.AvailableNegotiations.noteID = noteID
        Me.SettlementCreditorInfoControl1.noteID = noteID
    End Sub

    Protected Sub SettlementCalculatorControl_InsertedOffer(ByVal SettlementID As String, ByVal settlementStatus As String, ByVal dataClientID As String, ByVal accountID As String) Handles SettlementCalculatorControl1.InsertedOffer
        'rebind grid to show new offer
        Me.SessionNotesControl1.BindGrid(SettlementID)

        If settlementStatus = "A" Then
            Dim iClientID As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tblsettlements", "ClientID", "SettlementID = " & SettlementID)
            Dim iAcctID As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tblsettlements", "CreditorAccountID", "SettlementID = " & SettlementID)
            SettlementClientInfoControl1.LoadClientInfo(iClientID, iAcctID)
            Master.UpdateSIFCount()
            Me.SessionNotesControl1.LoadInfoData(Me.SettlementCalculatorControl1.DataClientID, Me.SettlementCalculatorControl1.accountID, True)
        End If

    End Sub

    Protected Sub SettlementCreditorInfoControl_EditComplete(ByVal EditClientID As String, ByVal EditCreditorAcctID As String) Handles SettlementCreditorInfoControl1.EditComplete
        Me.SettlementCalculatorControl1.LoadAccountInfo(EditClientID, EditCreditorAcctID)
        Me.SessionNotesControl1.BindGrid(EditClientID, EditCreditorAcctID)
        Me.SessionNotesControl1.LoadInfoData(EditClientID, EditCreditorAcctID, False)
    End Sub

    Protected Sub SettlementCreditorInfoControl_LoadCreditorFilter(ByVal CreditorName As String) Handles SettlementCreditorInfoControl1.LoadCreditorFilter
        Try
            Me.AvailableNegotiations.LoadData("cr.name Like ''%" & CreditorName.Replace("'", "''''") & "%''")
        Catch ex As Exception
            Response.Write("SettlementCreditorInfoControl1_LoadCreditorFilter Error - " & vbCrLf & ex.Message)
        End Try
    End Sub

    Protected Sub SettlementHistoryControl_SelectOffer(ByVal settlementID As String) Handles SessionNotesControl1.SelectOffer
        'load settlement offer
        Me.SettlementCalculatorControl1.LoadSettlementInfo(settlementID)
    End Sub

#End Region 'Methods

End Class