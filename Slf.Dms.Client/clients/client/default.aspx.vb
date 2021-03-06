Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records
Imports Slf.Dms.Controls.PermissionHelper

Imports System
Imports System.IO
Imports System.Net
Imports System.Data
Imports System.Drawing
Imports System.Diagnostics
Imports System.Data.SqlClient
Imports System.Collections.Generic

Imports iTextSharp
Imports iTextSharp.text.pdf

Imports ClientFileDocumentHelper

Partial Class clients_client_default
    Inherits PermissionPage

#Region "Variables"

    Private _showdeworksheet As Boolean
    Private _showuwworksheet As Boolean
    Private _deResolved As Boolean
    Private _uwResolved As Boolean

    Public QueryString As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Private grdRoadmapSmall As New Slf.Dms.Controls.RoadmapGridSmall
    Private ClientStatusID As Integer
    Private UserTypeID As Integer
    Private UserGroupID As Integer

    Private relations As New List(Of SharedFunctions.DocRelation)

    Private conv_companyID As Integer
    Private conv_stateid As Integer

    Public Mode As String = String.Empty
    Private SortField As String
    Private SortOrder As String
    Private HeadersMatters As Dictionary(Of String, HtmlTableCell)
#End Region

#Region "Structures"
    Public Structure RegisterTransaction
        Public RegisterFirst As Integer
        Public ID As Integer
        Public [Date] As Date
        Public CheckNumber As String
        Public EntryTypeID As Integer
        Public EntryTypeName As String
        Public OriginalAmount As Object
        Public Amount As Double
        Public SDABalance As Double
        Public PFOBalance As Double
        Public [Description] As String
        Public AccountID As Object
        Public AccountCreditorName As String
        Public AccountNumber As String
        Public AccountCurrentAmount As Double
        Public AdjustedRegisterID As Object
        Public AdjustedRegisterTransactionDate As Date
        Public AdjustedRegisterEntryTypeID As Integer
        Public AdjustedRegisterEntryTypeName As String
        Public AdjustedRegisterAmount As Double
        Public AdjustedRegisterOriginalAmount As Double
        Public ACHMonth As Object
        Public ACHYear As Object
        Public FeeMonth As Object
        Public FeeYear As Object
        Public BouncedOrVoided As Boolean
        Public NumNotes As Integer
        Public NumPhoneCalls As Integer

        Public Sub New(ByVal _RegisterFirst As Integer, ByVal _ID As Integer, ByVal _Date As Date, ByVal _CheckNumber As String, _
            ByVal _EntryTypeID As Integer, ByVal _EntryTypeName As String, ByVal _OriginalAmount As Object, ByVal _Amount As Double, _
            ByVal _SDABalance As Double, ByVal _PFOBalance As Double, ByVal _Description As String, ByVal _AccountID As Object, _
            ByVal _AccountCreditorName As String, ByVal _AccountNumber As String, ByVal _AccountCurrentAmount As Double, _
            ByVal _AdjustedRegisterID As Object, ByVal _AdjustedRegisterTransactionDate As Date, ByVal _AdjustedRegisterEntryTypeID As Integer, _
            ByVal _AdjustedRegisterEntryTypeName As String, ByVal _AdjustedRegisterAmount As Double, ByVal _AdjustedRegisterOriginalAmount As Double, _
            ByVal _ACHMonth As Object, ByVal _ACHYear As Object, ByVal _FeeMonth As Object, ByVal _FeeYear As Object, ByVal _BouncedOrVoided As Boolean, _
            ByVal _NumNotes As Integer, ByVal _NumPhoneCalls As Integer)

            Me.AccountCreditorName = _AccountCreditorName
            Me.AccountCurrentAmount = _AccountCurrentAmount
            Me.AccountID = _AccountID
            Me.AccountNumber = _AccountNumber
            Me.ACHMonth = _ACHMonth
            Me.ACHYear = _ACHYear
            Me.AdjustedRegisterAmount = _AdjustedRegisterAmount
            Me.AdjustedRegisterEntryTypeID = _AdjustedRegisterEntryTypeID
            Me.AdjustedRegisterEntryTypeName = _AdjustedRegisterEntryTypeName
            Me.AdjustedRegisterID = _AdjustedRegisterID
            Me.AdjustedRegisterOriginalAmount = _AdjustedRegisterOriginalAmount
            Me.AdjustedRegisterTransactionDate = _AdjustedRegisterTransactionDate
            Me.Amount = _Amount
            Me.BouncedOrVoided = _BouncedOrVoided
            Me.CheckNumber = _CheckNumber
            Me.[Description] = _Description
            Me.EntryTypeID = _EntryTypeID
            Me.EntryTypeName = _EntryTypeName
            Me.FeeMonth = _FeeMonth
            Me.FeeYear = _FeeYear
            Me.NumNotes = _NumNotes
            Me.NumPhoneCalls = _NumPhoneCalls
            Me.OriginalAmount = _OriginalAmount
            Me.PFOBalance = _PFOBalance
            Me.RegisterFirst = _RegisterFirst
            Me.ID = _ID
            Me.SDABalance = _SDABalance
            Me.[Date] = _Date
        End Sub
    End Structure
#End Region

#Region "rpTransactions_Display"

    Public Function rpTransactions_RowStyle(ByVal Row As RegisterTransaction) As String

        Dim BouncedOrVoided As Boolean = Row.BouncedOrVoided

        If BouncedOrVoided Then
            Return "style=""background-color:rgb(255,210,210);"""
        Else
            Return ""
        End If

    End Function
    Public Function rpTransactions_Notes(ByVal Row As RegisterTransaction) As String

        Dim NumNotes As Integer = StringHelper.ParseInt(Convert.ToString(Row.NumNotes))
        Dim NumPhoneCalls As Integer = StringHelper.ParseInt(Convert.ToString(Row.NumPhoneCalls))

        If NumNotes > 0 Or NumPhoneCalls > 0 Then
            Return "<img src=""" & ResolveUrl("~/images/11x16_paperclip.png") & """ border=""0"" />"
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpTransactions_Associations(ByVal Row As RegisterTransaction) As String

        Dim EntryTypeID As Integer = StringHelper.ParseInt(Row.EntryTypeID)
        Dim EntryTypeName As String = Convert.ToString(Row.EntryTypeName)
        Dim AdjustedRegisterID As Object = Row.AdjustedRegisterID
        Dim AccountID As Object = Row.AccountID

        Dim Parts As New List(Of String)

        If Not AdjustedRegisterID Is DBNull.Value Then

            Dim Icon As String = String.Empty

            Dim Amount As Double = StringHelper.ParseDouble(Row.Amount)
            Dim AdjustedRegisterEntryTypeName As String = Convert.ToString(Row.AdjustedRegisterEntryTypeName)

            If Not EntryTypeName = "Payment" Then
                If Amount < 0 Then
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle"" title=""Up"" />"
                Else
                    Icon = "<img style=""margin-right:8;"" src=""" & ResolveUrl("~/images/12x13_arrow_down.png") & """ align=""absmiddle"" title=""Down"" />"
                End If
            End If

            Parts.Add(Icon & AdjustedRegisterEntryTypeName & " " & Convert.ToString(AdjustedRegisterID))

        ElseIf EntryTypeID = 1 Then 'maintenance fee

            Dim FeeMonth As Object = Row.FeeMonth
            Dim FeeYear As Object = Row.FeeYear

            If Not FeeMonth Is DBNull.Value AndAlso Not FeeYear Is DBNull.Value Then
                Parts.Add(New DateTime(StringHelper.ParseInt(FeeYear), StringHelper.ParseInt(FeeMonth), 1).ToString("MMMM yyyy"))
            End If

        ElseIf EntryTypeID = 3 Then 'deposit

            Dim CheckNumber As String = Convert.ToString(Row.CheckNumber)
            Dim ACHMonth As Object = Row.ACHMonth
            Dim ACHYear As Object = Row.ACHYear

            If CheckNumber.Length > 0 Then
                Parts.Add("CHK # " & CheckNumber)
            End If

            If Not ACHMonth Is DBNull.Value AndAlso Not ACHYear Is DBNull.Value Then
                Parts.Add("ACH for " & New DateTime(StringHelper.ParseInt(ACHYear), StringHelper.ParseInt(ACHMonth), 1).ToString("MMM yyyy"))
            End If

        ElseIf Not AccountID Is DBNull.Value Then

            Dim AccountCreditorName As String = Convert.ToString(Row.AccountCreditorName)
            Dim AccountNumber As String = Convert.ToString(Row.AccountNumber)

            If AccountNumber.Length > 3 Then
                Parts.Add(AccountCreditorName & " ****" & AccountNumber.Substring(AccountNumber.Length - 4))
            Else
                Parts.Add(AccountNumber)
            End If

        End If

        If Parts.Count > 0 Then
            Return String.Join(", ", Parts.ToArray())
        Else
            Return "&nbsp;"
        End If

    End Function
    Public Function rpTransactions_Amount(ByVal OriginalAmount As Object, ByVal Amount As Double) As String

        If Not OriginalAmount Is DBNull.Value Then
            Return Math.Abs(CType(OriginalAmount, Double)).ToString("$#,##0.00")
        Else
            Return Math.Abs(Amount).ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_SDABalance(ByVal SDABalance As Double) As String

        If SDABalance < 0 Then
            Return "<font style=""color:red;"">" & SDABalance.ToString("$#,##0.00") & "</font>"
        Else
            Return SDABalance.ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_PFOBalance(ByVal PFOBalance As Double) As String

        If PFOBalance < 0 Then
            Return "<font style=""color:red;"">" & PFOBalance.ToString("$#,##0.00") & "</font>"
        Else
            Return PFOBalance.ToString("$#,##0.00")
        End If

    End Function
    Public Function rpTransactions_Redirect(ByVal Row As RegisterTransaction) As String

        Dim ID As Integer = StringHelper.ParseInt(Row.ID)
        Dim EntryTypeID As Integer = StringHelper.ParseInt(Row.EntryTypeID)
        Dim EntryTypeName As String = Convert.ToString(Row.EntryTypeName)

        If EntryTypeID = -1 And EntryTypeName = "Payment" Then
            Return ResolveUrl("~/clients/client/finances/bytype/payment.aspx?id=" & ClientID & "&rpid=" & ID)
        Else
            Return ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=" & ID)
        End If

    End Function

#End Region
    Protected ReadOnly Property Identity() As String
        Get
            Return Me.Page.GetType.Name & "_" & Me.ID
        End Get
    End Property
    Protected Property Setting(ByVal s As String) As Object
        Get
            Return Session(Identity & "_" & s)
        End Get
        Set(ByVal value As Object)
            Session(Identity & "_" & s) = value
        End Set
    End Property

    Protected ReadOnly Property Setting(ByVal s As String, ByVal d As Object) As Object
        Get
            Dim o As Object = Setting(s)
            If o Is Nothing Then
                Return d
            Else
                Return o
            End If
        End Get
    End Property
    Public Function GetPage(ByVal type As String) As String
        Return type
    End Function
    Public Function GetQSID(ByVal type As String) As String
        Select Case type
            Case "note"
                Return "nid"
            Case "phonecall"
                Return "pcid"
            Case "email"
                Return "eid"
        End Select
        Return String.Empty
    End Function

    Public Function GetMatterImage(ByVal group As String) As String
        Select Case group
            Case "1"
                Return ResolveUrl("~/images/matter.jpg")
            Case "2"
                Return ResolveUrl("~/images/16x16_user.png")
            Case "3"
                Return ResolveUrl("~/images/matter.jpg")
            Case "4"
                Return ResolveUrl("~/images/matter.jpg")
            Case "5"
                Return ResolveUrl("~/images/matter.jpg")
        End Select
        Return String.Empty
    End Function
    Public Function GetTaskId(ByVal MatterId As Integer) As Integer
        Dim tasks = DataHelper.FieldLookupIDs("tblMatter", "CurrentTaskId", "MatterId = " & MatterId)

        If Not tasks Is Nothing And tasks.Length > 0 Then
            Return tasks(0)
        End If

        Return 0
    End Function
    Public Function GetImage(ByVal type As String, ByVal direction As Object) As String
        Select Case type
            Case "note"
                Return ResolveUrl("~/images/16x16_note.png")
            Case "phonecall"
                Dim dir = CType(direction, Boolean)
                Return ResolveUrl("~/images/16x16_call" & IIf(dir, "out", "in") & ".png")
            Case "email"
                Return ResolveUrl("~/images/16x16_email_read.png")
        End Select
        Return String.Empty
    End Function
    Private ReadOnly Property UserID() As Integer
        Get
            Return Master.UserID
        End Get
    End Property
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID() As Integer
        Get
            Return DataClientID
        End Get
    End Property
    Private Function GetFullyQualifiedNameForMatters(ByVal s As String) As String
        Select Case s
            Case "ThMatterType"
                Return "MatterTypeCode"
            Case "ThMatterDate"
                Return "MatterDate"
            Case "ThMatterStatusCode"
                Return "MatterStatusCode"
            Case "ThMatterSubStatus"
                Return "MatterSubStatus"
            Case "ThMatterNumber"
                Return "MatterNumber"
            Case "ThDesc"
                Return "MatterMemo"
            Case "ThAccNo"
                Return "AccountNumber"
            Case "ThAttorney"
                Return "Attorney"
        End Select
        Return "MatterDate"
    End Function

    Public Sub SetSortImageMatters()
        HeadersMatters(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function
    Private Sub LoadHeadersMatters()
        HeadersMatters = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersMatters, ThMatterType)
        AddHeader(HeadersMatters, ThMatterDate)
        AddHeader(HeadersMatters, ThMatterStatusCode)
        AddHeader(HeadersMatters, ThMatterSubStatus)
        AddHeader(HeadersMatters, ThMatterNumber)
        AddHeader(HeadersMatters, ThDesc)
        AddHeader(HeadersMatters, ThAccNo)
        AddHeader(HeadersMatters, ThAttorney)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Protected Sub grdCommunication_agency_OnFillTable(ByRef tbl As System.Data.DataTable) Handles grdCommunication_agency.OnFillTable
        Dim t As New DataTable
        t.Columns.Add("ClickableURL", GetType(String))
        t.Columns.Add("IconSrcURL", GetType(String))
        t.Columns.Add("Date", GetType(DateTime))
        t.Columns.Add("By", GetType(String))
        t.Columns.Add("Direction", GetType(String))
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim type As String = DatabaseHelper.Peel_string(rd, "type")
                        Dim commdate As DateTime = DatabaseHelper.Peel_date(rd, "date")
                        Dim by As String = DatabaseHelper.Peel_string(rd, "by")
                        Dim direction As Nullable(Of Boolean) = DatabaseHelper.Peel_nbool(rd, "direction")

                        Dim fieldid As String = DatabaseHelper.Peel_int(rd, "fieldid")

                        Dim r As DataRow = t.NewRow
                        r("ClickableURL") = ResolveUrl("~/clients/client/communication/" & GetPage(type) & ".aspx") & "?id=" & DataClientID.ToString & "&" & GetQSID(type) & "=" & fieldid
                        r("IconSrcURL") = GetImage(type, direction)
                        r("Date") = commdate
                        r("By") = by
                        If direction.HasValue Then
                            r("Direction") = IIf(direction, "Outgoing", "Incoming")
                        End If
                        t.Rows.Add(r)
                    End While
                End Using
            End Using
        End Using
        tbl = t
    End Sub
    Protected Sub grdCommunication_my_OnFillTable(ByRef tbl As System.Data.DataTable) Handles grdCommunication_my.OnFillTable
        Dim t As New DataTable
        t.Columns.Add("ClickableURL", GetType(String))
        t.Columns.Add("IconSrcURL", GetType(String))
        t.Columns.Add("Date", GetType(DateTime))
        t.Columns.Add("By", GetType(String))
        t.Columns.Add("Message", GetType(String))
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "UserID", UserID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim type As String = DatabaseHelper.Peel_string(rd, "type")
                        Dim commdate As DateTime = DatabaseHelper.Peel_date(rd, "date")
                        Dim by As String = DatabaseHelper.Peel_string(rd, "by")
                        Dim message As String = DatabaseHelper.Peel_string(rd, "message")
                        Dim fieldid As String = DatabaseHelper.Peel_int(rd, "fieldid")

                        Dim r As DataRow = t.NewRow
                        r("ClickableURL") = ResolveUrl("~/clients/client/communication/" & GetPage(type) & ".aspx") & "?id=" & DataClientID.ToString & "&" & GetQSID(type) & "=" & fieldid
                        r("IconSrcURL") = GetImage(type, False) 'direction irrelevant, becuase there are notes only
                        r("Date") = commdate
                        r("By") = by
                        r("Message") = message
                        t.Rows.Add(r)
                    End While
                End Using
            End Using
        End Using
        tbl = t
    End Sub

    'Move this code PhoneCallHelper when refactoring
    Private Function RegisterInboundCall(ByVal clientId As Integer, ByVal userId As Integer, ByVal callId As Long) As Long
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", clientId)
        DatabaseHelper.AddParameter(cmd, "UserID", userId)
        DatabaseHelper.AddParameter(cmd, "CallID", callId, SqlDbType.BigInt)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblInboundCall", "InboundCall", SqlDbType.BigInt)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function

    Private Sub LogIfIncommingCall()
        Try
            'Find out if page was activated by an incomming phone call
            'Fails if not CallId found
            If Not qs.Item("CallId") Is Nothing Then
                'Log the call
                Dim CallId As Long = Long.Parse(qs.Item("CallId"))
                'PhoneCallHelper.RegisterInboundCall(ClientID, UserID, CallId)
                RegisterInboundCall(ClientID, UserID, CallId)
            End If
        Catch ex As Exception
            Throw
        End Try
    End Sub

    Private Sub LoadMatters()
        SortField = Setting("SortField", "ThMatterDate")
        SortOrder = Setting("SortOrder", "DESC")

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMattersClientId")
            Using cmd.Connection
                cmd.Connection.Open()
                If Mode <> "M" Then
                    DatabaseHelper.AddParameter(cmd, "returntop", 10)
                End If
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY " + GetFullyQualifiedNameForMatters(SortField) + " " + SortOrder)

                Using rd As IDataReader = cmd.ExecuteReader()
                    rpMatterInstance.DataSource = rd
                    rpMatterInstance.DataBind()
                End Using
                pnlNoMatters.Visible = rpMatterInstance.Items.Count = 0
            End Using
        End Using

        LoadHeadersMatters()
        SetSortImageMatters()
    End Sub
    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        If txtSortField.Value = Setting("SortField") Then
            'toggle sort order
            If Setting("SortOrder") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortField.Value
            SortOrder = "DESC"
        End If
        SortField = txtSortField.Value

        Setting("SortField") = SortField
        Setting("SortOrder") = SortOrder
    End Sub

    '''''The Archive redirect is here
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserId=" & UserID))

        'UserGroupID = DataHelper.FieldLookup("tblUser", "UserGroupID", "XXX=" & UserID)

        Session("Comms_LastPage") = "side_commsholder"

        qs = LoadQueryString()

        Dim IsArchived As String = IsClientArchived(ClientID)
        If IsArchived <> "" Then
            Response.Redirect("~\ArchiveViewer.aspx?ap=" & IsArchived)
            Exit Sub
        End If

        PrepQuerystring()

        If Not qs Is Nothing Then
            Mode = DataHelper.Nz_string(qs("mode"))
        End If

        'Find out if page was activated by an incomming phone call
        If Not IsPostBack Then LogIfIncommingCall()

        If Not qs Is Nothing Then
            'check for verification worksheets that need to be complete and redirect
            CheckVerificationWorksheets()

            LoadRoadmaps()

            If Not IsPostBack Then
                relations = SharedFunctions.DocumentAttachment.GetRelationsForClient(ClientID)
                LoadPrimaryPerson()
                LoadUpcomingTasks()
                If Mode = "E" Then
                    LoadAllEmails()
                ElseIf Mode = "N" Then
                    LoadAllNotes()
                ElseIf Mode = "P" Then
                    LoadAllPhoneCalls()
                Else
                    LoadAllCommunication()
                End If

                LoadStatistics()
                LoadGeneralInfo()
                LoadBalances()
                LoadTransactions()
                LoadAttorneyContact()
                LoadHardship()
                LoadDialerInfo()
                CheckTasksPastDue()
            End If

            SetRollups()
        End If
    End Sub

    Private Sub LoadDialerInfo()
        If ClientID > 0 Then
            Me.DialerScheduler.Client = Me.ClientID
            Me.DialerScheduler.LoadDateTime()
        End If
    End Sub

    Public Function GetAttachmentText(ByVal id As Integer, ByVal type As String) As String
        For Each rel As SharedFunctions.DocRelation In relations
            If rel.RelationID = id And rel.RelationType = type Then
                Return "<img src=""" + ResolveUrl("~/images/11x16_paperclip.png") + """ border="""" alt="""" />"
            End If
        Next

        Return "&nbsp"
    End Function

    Private Sub LoadHardship()
        Dim obj As Object = SqlHelper.ExecuteScalar("select max(hardshipdate) from tblhardshipdata where clientid = " & ClientID, CommandType.Text)
        If IsDate(obj) Then
            lblHardship.Text = String.Format("<a href='hardship/?id={0}' class='lnk'>{1}</a>", ClientID, Format(CDate(obj), "M/d/yyyy"))
        Else
            lblHardship.Text = String.Format("<a href='hardship/?id={0}' class='lnk'>Not on file</a>", ClientID)
        End If
    End Sub

    Private Sub LoadGeneralInfo()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read Then

                        Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyId")
                        Dim CompanyId As Integer = DatabaseHelper.Peel_int(rd, "CompanyId")

                        conv_companyID = CompanyId

                        lblCompany.Text = DataHelper.FieldLookup("tblCompany", "Name", "CompanyId=" & CompanyId)
                        lblAgency.Text = DataHelper.FieldLookup("tblAgency", "Code", "AgencyId=" & AgencyId)
                    End If
                End Using
            End Using
        End Using

        Dim LeadNumber As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblAgencyExtraFields01", "LeadNumber", "ClientId=" & ClientID))
        If Not String.IsNullOrEmpty(LeadNumber) Then lblLeadNumber.Text = "Lead Number: " & LeadNumber & "<br>"
    End Sub

    Private Sub LoadBalances()
        Dim SDABal As Double, AvailSDA As Double, PFOBal As Double, Reserve As Double, OnHold As Double

        ClientHelper2.GetBalances(ClientID, SDABal, Reserve, AvailSDA, PFOBal, OnHold)

        lblAvailSDABal.Text = FormatCurrency(AvailSDA, 2)
        lblSDABal.Text = FormatCurrency(SDABal, 2)
        lblReserve.Text = FormatCurrency(Reserve, 2)
        lblPFOBal.Text = FormatCurrency(PFOBal, 2)
        lblFundsOnHold.Text = FormatCurrency(OnHold, 2)

        If AvailSDA < 0 Then
            lblAvailSDABal.ForeColor = Color.Red
        End If

        If PFOBal < 0 Then
            lblPFOBal.ForeColor = Color.Red
        End If
    End Sub

    Private Sub ForceRedirect(ByVal url As String, ByVal ClientId As Integer)
        Dim l As List(Of Integer)
        If Session("ForcedRedirects") Is Nothing Then
            l = New List(Of Integer)
        Else
            l = CType(Session("ForcedRedirects"), List(Of Integer))
        End If
        l.Add(ClientId)
        Session("ForcedRedirects") = l
        Response.Redirect(url & ClientId)
    End Sub
    Private Function ForceRedirectPrev(ByVal ClientId As Integer) As Boolean
        If Not Session("ForcedRedirects") Is Nothing Then
            Dim l As List(Of Integer) = CType(Session("ForcedRedirects"), List(Of Integer))
            If l.Contains(ClientId) Then
                Return True
            End If
        End If
        Return False
    End Function
    Private Sub CheckVerificationWorksheets()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblClient WHERE ClientID = @ClientID"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read Then

                        Dim VWDEResolved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWDEResolved")
                        Dim VWUWResolved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "VWUWResolved")

                        If Not VWDEResolved.HasValue Then 'DE has NOT been resolved

                            Dim ClientStatusID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID=" & ClientID))

                            'current user IS data entry user
                            If UserHelper.HasPosition(UserID, 5) Or (ClientStatusID = 23 AndAlso UserTypeID = 1) Then

                                'redirect to data entry worksheet
                                If Not ForceRedirectPrev(ClientID) Then
                                    ForceRedirect("~/clients/client/dataentry.aspx?id=", ClientID)
                                End If
                            End If

                            _showdeworksheet = True
                            _deResolved = False

                        Else 'DE HAS been resolved
                            _deResolved = True
                            If Not VWUWResolved.HasValue Then 'UW has NOT been resolved

                                Dim AssignedUnderwriter As Integer = DataHelper.Nz_int(DataHelper.FieldLookup( _
                                    "tblClient", "AssignedUnderwriter", "ClientID = " & ClientID))

                                If UserID = AssignedUnderwriter Then 'current user IS assigned underwriter

                                    'redirect to underwriting worksheet
                                    If Not ForceRedirectPrev(ClientID) Then
                                        ForceRedirect("~/clients/client/underwriting.aspx?id=", ClientID)
                                    End If
                                End If

                                _showuwworksheet = True
                                _uwResolved = False
                            Else
                                _uwResolved = True
                            End If
                        End If
                    End If
                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadTransactions()
        Dim trans As New List(Of RegisterTransaction)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTransactionsNoPayments")

        DatabaseHelper.AddParameter(cmd, "Where", "WHERE r.ClientID = " & ClientID)
        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY r.TransactionDate DESC, r.RegisterID DESC")

        Dim Registers As New List(Of Register)

        Using cmd
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        trans.Add(New RegisterTransaction(DataHelper.Nz_int(reader("RegisterFirst")), DataHelper.Nz(reader("ID"), DBNull.Value), _
                        DataHelper.Nz_date(reader("Date")), DataHelper.Nz_string(reader("CheckNumber")), DataHelper.Nz_int(reader("EntryTypeID")), _
                        DataHelper.Nz_string(reader("EntryTypeName")), DataHelper.Nz(reader("OriginalAmount"), DBNull.Value), DataHelper.Nz_double(reader("Amount")), _
                        DataHelper.Nz_double(reader("SDABalance")), DataHelper.Nz_double(reader("PFOBalance")), reader("Description").ToString(), _
                        DataHelper.Nz(reader("AccountID"), DBNull.Value), DataHelper.Nz_string(reader("AccountCreditorName")), DataHelper.Nz_string(reader("AccountNumber")), DataHelper.Nz_double(reader("AccountCurrentAmount")), _
                        DataHelper.Nz(reader("AdjustedRegisterID"), DBNull.Value), DataHelper.Nz_date(reader("AdjustedRegisterTransactionDate")), DataHelper.Nz_int(reader("AdjustedRegisterEntryTypeID")), DataHelper.Nz_string(reader("AdjustedRegisterEntryTypeName")), _
                        DataHelper.Nz_double(reader("AdjustedRegisterAmount")), DataHelper.Nz_double(reader("AdjustedRegisterOriginalAmount")), _
                        DataHelper.Nz(reader("ACHMonth"), DBNull.Value), DataHelper.Nz(reader("ACHYear"), DBNull.Value), DataHelper.Nz(reader("FeeMonth"), DBNull.Value), _
                        DataHelper.Nz(reader("FeeYear"), DBNull.Value), DataHelper.Nz_bool(reader("BouncedOrVoided")), DataHelper.Nz_int(reader("NumNotes")), _
                        DataHelper.Nz_int(reader("NumPhoneCalls"))))
                    End While
                End Using
            End Using
        End Using

        rpTransactions.DataSource = CombineFee(trans)
        rpTransactions.DataBind()
    End Sub
    Private Function CombineFee(ByVal trans As List(Of RegisterTransaction)) As List(Of RegisterTransaction)
        Dim results As New List(Of RegisterTransaction)
        Dim temp As RegisterTransaction
        Dim numTrans As Integer = 0

        For Each tran As RegisterTransaction In trans
            temp = tran

            If tran.EntryTypeID = 42 Then
                For Each match As RegisterTransaction In trans
                    If match.EntryTypeID = 2 Then
                        If tran.AccountID.Equals(match.AccountID) Then
                            temp.Amount += match.Amount

                            Exit For
                        End If
                    End If
                Next
            End If

            If Not temp.EntryTypeID = 2 Then
                numTrans += 1
                results.Add(temp)
            End If

            If numTrans = 4 Then
                Exit For
            End If
        Next

        Return results
    End Function
    Private Sub LoadStatistics()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetStatsOverviewForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then

                    Dim NumAccounts As Integer = DatabaseHelper.Peel_int(rd, "NumAccounts")
                    Dim SumAccounts As Double = DatabaseHelper.Peel_double(rd, "SumAccounts")
                    Dim RegisterBalance As Double = DatabaseHelper.Peel_double(rd, "RegisterBalance")
                    Dim NumUnverifiedAccounts As Integer = DatabaseHelper.Peel_int(rd, "numUnVerifiedAccounts")
                    Dim SumUnVerified As Double = DatabaseHelper.Peel_double(rd, "sumUnVerified")

                    lblAccountsToSettle.Text = "(" & NumAccounts & ") <font style=""color:red;"">" & SumAccounts.ToString("$#,##0.00") & "</font>"
                    lblUVAccounts.Text = "(" & NumUnverifiedAccounts & ") <font style=""color:blue;"">" & SumUnVerified.ToString("$#,##0.00") & "</font>"

                End If

            End Using
        End Using

    End Sub
    Private Sub LoadAttorneyContact()
        Dim rd As SqlDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAttorneyContactInfo")
        Dim Addresses(2, 4) As String
        Dim Phones(5, 1) As String
        Dim c As Integer = 0

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        'Addresses
        Using cmd
            Using cmd.Connection
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                If rd.HasRows Then
                    Do While rd.Read()
                        Addresses(c, 0) = rd.Item("Type").ToString
                        Addresses(c, 1) = rd.Item("Address").ToString
                        Addresses(c, 2) = rd.Item("Address2").ToString
                        Addresses(c, 3) = rd.Item("City").ToString
                        Addresses(c, 4) = rd.Item("State").ToString
                        c += 1
                    Loop
                End If
            End Using
        End Using

        If Not Addresses(0, 1) Is Nothing Then
            'Populate Addresses
            'Remitt
            Me.lblRemittAdd.Text = Addresses(0, 1)
            If Addresses(0, 2).ToString <> "" Then
                Me.lblRemittAdd2.Visible = True
                Me.lblRemittAdd2.Text = Addresses(0, 2)
            Else
                Me.lblRemittAdd2.Visible = False
            End If
            Me.lblRemittCity.Text = Addresses(0, 3)
            Me.lblRemittState.Text = Addresses(0, 4)
            'Cust Svc
            Me.lblClientSvcsAdd.Text = Addresses(1, 1)
            If Addresses(1, 2).ToString <> "" Then
                Me.lblClientSvcsAdd2.Visible = True
                Me.lblClientSvcsAdd2.Text = Addresses(1, 2)
            Else
                Me.lblClientSvcsAdd2.Visible = False
            End If
            Me.lblClientSvcsCity.Text = Addresses(1, 3)
            Me.lblClientSvcsState.Text = Addresses(1, 4)
            'Creditor Svc
            Me.lblCreditorSvcsAdd.Text = Addresses(2, 1)
            If Addresses(2, 2).ToString <> "" Then
                Me.lblCreditorSvcsAdd2.visible = True
                Me.lblCreditorSvcsAdd2.Text = Addresses(2, 2)
            Else
                Me.lblCreditorSvcsAdd2.visible = False
            End If
            Me.lblCreditorSvcsCity.Text = Addresses(2, 3)
            Me.lblCreditorSvcsState.Text = Addresses(2, 4)

        c = 0

        'Phones
        cmd = ConnectionFactory.CreateCommand("stp_GetAttorneyPhoneInfo")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        Using cmd
            Using cmd.Connection
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                If rd.HasRows Then
                    Do While rd.Read()
                        Phones(c, 0) = rd.Item("Type").ToString
                        Phones(c, 1) = rd.Item("Number").ToString
                        c += 1
                    Loop
                End If
            End Using
        End Using

        c = 0

        'Populate phones
        Me.lblClientSvcsPhone.Text = Format(Val(Phones(0, 1)), "(###) ###-####") 'Compliance
        Me.lblClientSvcsFax.Text = Format(Val(Phones(1, 1)), "(###) ###-####")
        Me.lblCreditorSvcsPhone.Text = Format(Val(Phones(2, 1)), "(###) ###-####") 'Creditor
        End If

    End Sub

    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()

        Dim Views As List(Of String) = Master.Views
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then
            Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/roadmap.aspx") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_flowchart.png") & """ align=""absmiddle""/>Show full roadmap</a>")
            Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/enrollment.aspx") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_form_setup.png") & """ align=""absmiddle""/>Show screening</a>")

            Dim isSD As Boolean = (DataHelper.FieldLookup("tblClient", "ServiceImportId", "ClientID = " & ClientID).Trim.Length > 0)
            If isSD Then
                Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/sdcalculator.aspx") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_calculator.png") & """ align=""absmiddle""/>CID Calculator</a>")
            End If

            If _showdeworksheet Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/dataentry.aspx?id=" & ClientID) & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_worksheet.png") & """ align=""absmiddle""/>Data entry sheet</a>")
            End If

            If _showuwworksheet Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/underwriting.aspx?id=" & ClientID) & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_worksheet.png") & """ align=""absmiddle""/>Verification sheet</a>")
            End If

            If _uwResolved Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:UnresolveUWConfirm();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_worksheet.png") & """ align=""absmiddle""/>Unresolve verification</a>")
            ElseIf _deResolved Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:UnresolveDEConfirm();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_worksheet.png") & """ align=""absmiddle""/>Unresolve data entry</a>")
            End If

        End If

        If UserGroupID = 6 Or UserGroupID = 11 Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this client</a>")
        End If

        lnkAccountsToSettle.HRef = "~/clients/client/creditors/accounts/?id=" & ClientID
        lnkSDABalance.HRef = "~/clients/client/finances/register/?id=" & ClientID
        lnkPFOBalance.HRef = "~/clients/client/finances/register/?id=" & ClientID

        lnkRegister.HRef = "~/clients/client/finances/register/?id=" & ClientID


        ClientStatusID = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID=" & ClientID))
        If ClientStatusID = 24 AndAlso UserTypeID = 2 Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/resolveincompletedata.aspx?id=" & ClientID) & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_worksheet.png") & """ align=""absmiddle""/>Resolve Incomplete Data</a>")
        End If

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:Enter_Hardship();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_form_red.png") & """ align=""absmiddle""/>Enter Hardship</a>")

        '4.29.09.ug
        'only show for palmer NC clients
        'add client check to show
        Select Case ClientStatusID
            Case 15, 17, 18
            Case Else   'active client
                Select Case conv_companyID
                    Case 5
                    Case Else
                        If conv_stateid = 34 Or conv_stateid = 5 Then
                            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:Print_Package();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_new.png") & """ align=""absmiddle""/>Transfer Package</a>")
                            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""finances/sda/?id=" & ClientID & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_dataentrypropagation.png") & """ align=""absmiddle""/>Convert to Local Counsel</a>")
                        End If
                End Select

        End Select

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:ResetPassword();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_lock.png") & """ align=""absmiddle""/>Reset Client Password</a>")

        If "11,6,43".Contains(UserGroupID) Or PermissionHelperLite.HasPermission(UserID, "Research-Reports-Litigation") Then
            '9.2.09.ug
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Generate_ClientFile();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Generate Client File</a>")
        End If



        'Matters use same permissions as the Home page task tabs
        If PermissionHelperLite.HasPermission(UserID, "Home-Default Controls-Tasks") Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddMatter();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """ align=""absmiddle""/>Add Matter</a>")
        End If
    End Sub

    Private Sub LoadAllCommunication()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "10")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub LoadAllEmails()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "10")
        DatabaseHelper.AddParameter(cmd, "Type", "type='email'")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub LoadAllNotes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "10")
        'DatabaseHelper.AddParameter(cmd, "Type", "type='note'")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub LoadAllPhoneCalls()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "10")
        DatabaseHelper.AddParameter(cmd, "Type", "type='phonecall'")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub CheckTasksPastDue()

        Dim Tasks As List(Of Task) = ClientHelper.GetTasksPastDue(ClientID, UserID)

        If Not Tasks Is Nothing AndAlso Tasks.Count > 0 Then

            pnlMessage.Visible = True
            imgMessage.Src = "~/images/16x16_calendar.png"
            tdMessage.InnerHtml = "You have tasks related to this client that are past due.  See below:<ul>"

            For Each t As Task In Tasks
                tdMessage.InnerHtml += "<li><font style=""color:black;"">DUE: " & t.Due.ToString("MM/dd/yyyy") _
                    & "</font> - " & t.Description & "&nbsp;&nbsp;<a class=""lnk"" OnClick=""javascript:TaskClick(" & t.TaskID & "," & t.TaskTypeID & ");return false;"" href=""#"" " _
                    & """ style=""color:#a1a1a1;font-size:9"">RESOLVE</a>"
            Next

            tdMessage.InnerHtml += " </li></ul>"

        End If

    End Sub
    Private Sub LoadUpcomingTasks()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasksForClient")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "Criteria", "tblTask.Resolved = NULL AND tblTask.AssignedTo = " & UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpUpcomingTasks.DataSource = rd
            rpUpcomingTasks.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        trUpcomingTasksHeader.Visible = rpUpcomingTasks.Items.Count > 0
        trUpcomingTasksBody.Visible = rpUpcomingTasks.Items.Count > 0
        trUpcomingTasksSeparator.Visible = rpUpcomingTasks.Items.Count > 0

    End Sub
    Private Sub LoadRoadmaps()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRoadmapsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                grdRoadmapSmall.AddRoadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ParentRoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_int(rd, "ClientStatusID"), _
                    DatabaseHelper.Peel_int(rd, "ParentClientStatusID"), _
                    DatabaseHelper.Peel_string(rd, "ClientStatusName"), _
                    DatabaseHelper.Peel_string(rd, "Reason"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        pnlRoadmap.Controls.Add(grdRoadmapSmall)

    End Sub
    Private Sub ShowFirmMessagePopup(ByVal StateID As Integer)
        Dim mosslerMSG As New StringBuilder
        Select Case StateID
            Case 7
                Select Case ClientHelper.GetLanguage(DataClientID)
                    Case 2      'spanish
                        mosslerMSG.Append("Debido a cambios en la ley, El Bufete de abogados de Mossler ya no representar? a clientes en Connecticut. Estos cambios no incluyen a abogados con licencia de ")
                        mosslerMSG.Append("Connecticut. Por lo tanto, hemos arreglado con el abogado Glen A. Kurtis, con licencia de Connecticut, para proporcionarle representaci?n legal continua si usted da su ")
                        mosslerMSG.Append("consentimiento. Si usted no da su consentimiento, con mucho gusto reembolsaremos su dinero. Usted estar? recibiendo una carta y otros materiales de El Bufete de ")
                        mosslerMSG.Append("abogados de Mossler en el futuro pr?ximo.</br>")
                        mosslerMSG.AppendLine("<b>Si el cliente tiene preguntas con respecto a su CANTIDAD de REEMBOLSO o BALANCE de CDA:</b><br> por favor transferir a Retenci?n (7498) directamente.")
                    Case Else   'default english
                        mosslerMSG.Append("Due to changes in the law, The Mossler Law Firm will no longer represent clients in Connecticut.  These changes do not impact ")
                        mosslerMSG.Append("licensed Connecticut attorneys.   We have therefore arranged for Glen A. Kurtis, a licensed Connecticut attorney, to provide you ")
                        mosslerMSG.Append("continuing legal representation if you consent.  If you do not consent, we will gladly provide you a refund.  You will be ")
                        mosslerMSG.Append("receiving a letter and other materials from The Mossler Law Firm in the near future.<br>")
                        mosslerMSG.Append("<b>If the client has questions regarding their REFUND AMOUNT or BALANCE IN CDA:</b><br>")
                        mosslerMSG.Append("please transfer to Retention (7498) directly.<br>")
                End Select

                Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
                frm.Style("display") = "none"
                dvReport.Style("display") = "none"
                dvReport.Style.Remove("height")
                Dim lit As New LiteralControl(mosslerMSG.ToString)
                pnlRpt.Controls.Add(lit)
                popTitle.InnerHtml = "Connecticut Mossler Clients"
                programmaticModalPopup.Show()

            Case 47
                mosslerMSG.Append("<div style=""font-weight:bold; text-decoration:underline; tex-align:center; width:100%;"">To Vermont Mossler clients who ask about the settlement with the<br>Vermont Attorney General:</div><br>")
                mosslerMSG.Append("The Mossler Law Firm, in agreement with the Vermont Attorney General's Office, has elected ")
                mosslerMSG.Append("to cease doing business in Vermont. You will be receiving a letter and several other materials ")
                mosslerMSG.Append("from The Mossler Law Firm in the near future. This letter will enclose a complete refund of all ")
                mosslerMSG.Append("amounts you have deposited, less any amount paid to creditors on your behalf. Can I please verify ")
                mosslerMSG.Append("your address? If you have any more questions, please call the Vermont Attorney General's Office at 802-828-5507.<br>")
                mosslerMSG.Append("<b>If the client has questions regarding their REFUND AMOUNT:</b><br>")
                mosslerMSG.Append("Please transfer the call to Taylor Schwenke (354) or Kellie Anderson (403) directly.<br>If they ")
                mosslerMSG.Append("are not available, please email Taylor the client?s name, client?s file number (600#), and best ")
                mosslerMSG.Append("time and number to be reached.")
                Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
                frm.Style("display") = "none"
                dvReport.Style("display") = "none"
                dvReport.Style.Remove("height")
                Dim lit As New LiteralControl(mosslerMSG.ToString)
                pnlRpt.Controls.Add(lit)
                popTitle.InnerHtml = "Vermont Mossler Clients"
                programmaticModalPopup.Show()
        End Select
    End Sub
    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim SSN As String = DatabaseHelper.Peel_string(rd, "SSN")

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")

                conv_stateid = StateID

                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)
                Dim AccountNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID)
                Dim CompanyID As String = DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " & ClientID)

                'add mossler pop text
                If CompanyID = 4 Then
                    ShowFirmMessagePopup(StateID)
                End If

                lnkName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                If SSN.Length > 0 Then
                    lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(SSN, "___-__-____", "_", StringHelper.Filter.NumericOnly) & "<br>"
                End If

                If AccountNumber.Length > 0 Then
                    lblAccountNumber.Text = AccountNumber & "<br>"
                End If

                'If DatabaseHelper.Peel_bool(rd, "IsDeceased") = True Then
                '    lblDeceased.Text = "True"
                'Else
                '    lblDeceased.Text = "False"
                'End If


            Else
                lnkName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID)
            lnkStatus_ro.Text = lnkStatus.Text

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & ClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
        End If

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    ''''''Fundtion IsClientArchived added code
    Private Function IsClientArchived(ByVal iClientID As Integer) As String
        Return ""
        Dim IsArchived As String = ""
        Dim AccountNumber As String = ""
        Dim FileNames As String() = Nothing
        Dim rd As SqlDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_IsClientArchived")

        DatabaseHelper.AddParameter(cmd, "ClientID", iClientID)

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader()
            If rd.HasRows Then
                rd.Read()
                AccountNumber = rd.Item(0).ToString
                IsArchived = rd.Item(1).ToString
                If Directory.Exists(IsArchived) Then
                    FileNames = Directory.GetFiles(IsArchived)
                End If
                If Not FileNames Is Nothing Then
                    IsArchived = FileNames(0)
                End If
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return IsArchived

    End Function

    Protected Sub rpUpcomingTasks_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpUpcomingTasks.ItemDataBound

        Dim lblDue As Label = CType(e.Item.FindControl("lblDue"), Label)

        Dim Due As DateTime = e.Item.DataItem("Due")

        lblDue.ForeColor = IIf(DateTime.Compare(Due, Now) < 0, Color.Red, Color.Black)

    End Sub
    Protected Sub lnkName_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkName.Click
        Response.Redirect("~/clients/client/applicants/?id=" & ClientID)
    End Sub

    Protected Sub lnkUnresolveDE_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnresolveDE.Click
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UnresolveDEForClient")
            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Protected Sub lnkUnresolveUW_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnresolveUW.Click
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UnresolveUWForClient")
            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeleteClient")
            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Response.Redirect(ResolveUrl("~"))
    End Sub

    Protected Sub lnkStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStatus.Click
        Response.Redirect("~/clients/client/roadmap.aspx?id=" & ClientID)
    End Sub

    Protected Sub lnkResetPassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResetPassword.Click
        Dim password As String = "Temppass" + ClientID.ToString()
        Dim hashPassword = GenerateSHAHash(password.Trim)

        Dim params(1) As SqlParameter
        params(0) = New SqlParameter("@clientid", ClientID.ToString())
        params(1) = New SqlParameter("@Password", hashPassword)
        SqlHelper.ExecuteScalarCMS("stp_SetPasswordByClientID", CommandType.StoredProcedure, params)

        ScriptManager.RegisterStartupScript(Me, GetType(Page), "ClientTempPass", "alert(""Password set to Temppass" + ClientID.ToString() + "    Please give this password after verification of identity. Using this password will direct the client to enter a new password on the client portal. "");", True)
    End Sub

    Protected Function GenerateSHAHash(ByVal Password As String) As String
        Dim data As Byte()
        Dim hasher As System.Security.Cryptography.SHA1 = System.Security.Cryptography.SHA1.Create()

        data = hasher.ComputeHash(Encoding.ASCII.GetBytes(Password.Trim()))

        Dim sb As New StringBuilder(data.Length * 2, data.Length * 2)

        For i As Integer = 0 To data.Length - 1
            sb.Append(data(i).ToString("x").PadLeft(2, "0"c))
        Next

        Return sb.ToString()
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(lnkStatus, c, "Clients-Client Single Record-Big Roadmap", 1, False)
        AddControl(lnkStatus_ro, c, "Clients-Client Single Record-Big Roadmap", 1, True)

        AddControl(phCommunication_default, c, "Clients-Client Single Record-Communication-Default")
        AddControl(trCommunication_agency, c, "Clients-Client Single Record-Communication-Agency")
        AddControl(trCommunication_my, c, "Clients-Client Single Record-Communication-My")

        AddControl(phStatistics, c, "Clients-Client Single Record-Overview-Statistics")
        AddControl(phRegister, c, "Clients-Client Single Record-Register")
        AddControl(phRoadmap, c, "Clients-Client Single Record-Roadmap")
        AddControl(tdBigRoadmap_No, c, "Clients-Client Single Record-Big Roadmap")
        AddControl(tdBigRoadmap, c, "Clients-Client Single Record-Big Roadmap")
        AddControl(phTasks, c, "Clients-Client Single Record-Overview-Tasks")
        AddControl(phCommunication, c, "Clients-Client Single Record-Communication")
        AddControl(phSearch, c, "Client Search")

        AddControl(lblSSN, c, "Clients-Client Single Record-Overview-Lead Number", 1, True)
        AddControl(lblLeadNumber, c, "Clients-Client Single Record-Overview-Lead Number", 1, False)

        AddControl(phMatters, c, "Home-Default Controls-Tasks")
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadMatters()
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

    End Sub

    
    Protected Sub lnkHardship_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHardship.Click
        Response.Redirect("~/clients/client/hardship/?id=" & ClientID)
    End Sub
    Protected Sub hideModalPopupViaServer_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        programmaticModalPopup.Hide()
    End Sub
	Protected Sub lnkPrintPackage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrintPackage.Click
		Dim ssql As String = String.Format("Select top 1 stateid from tblperson where clientid = {0} and relationship = 'Prime'", DataClientID)
		Dim sID As String = SharedFunctions.AsyncDB.executeScalar(ssql, ConfigurationManager.AppSettings("connectionstring").ToLower)
		Dim newCompID As String = ""

		Select Case sID
			Case 34
				newCompID = 5
			Case 5
				newCompID = 3
		End Select

		Dim queryString As String = "../../Clients/client/reports/report.aspx?clientid=" & DataClientID & "&reports=NCCONVPKG_" & newCompID & "&user=" & UserID
		Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
		frm.Attributes("src") = queryString
		popTitle.InnerHtml = "Conversion Package"
		programmaticModalPopup.Show()
	End Sub
Protected Sub lnkGenerateClientFile_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGenerateClientFile.Click
        generateClientFile(Master.DataClientID, Response)
    End Sub

    Protected Sub lnkAllNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAllNotes.Click
        Response.Redirect("~/clients/client/default.aspx?id=" & ClientID & "&mode=N")
    End Sub

    Protected Sub lnkAllEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAllEmail.Click
        Response.Redirect("~/clients/client/default.aspx?id=" & ClientID & "&mode=E")
    End Sub

    Protected Sub lnkPhoneCalls_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPhoneCalls.Click
        Response.Redirect("~/clients/client/default.aspx?id=" & ClientID & "&mode=P")
    End Sub

    Protected Sub lnkAllMatters_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAllMatters.Click
        Response.Redirect("~/clients/client/default.aspx?id=" & ClientID & "&mode=M")
    End Sub

    Protected Sub lnkMattersView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkMattersView.Click
        Response.Redirect("~/clients/client/default.aspx?id=" & ClientID)
    End Sub

    Public Function GetClientID() As Integer
        Return ClientID
    End Function
End Class