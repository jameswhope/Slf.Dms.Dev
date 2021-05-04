Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls
Imports system.Data.SqlClient
Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class side_comms
    Inherits System.Web.UI.Page

    Public UserID As Integer
    Private AccountNumber As String
    Public DataClientID As Integer
    Private RelationTypeID As Integer
    Private RelationTypeName As String
    Private RelationID As Integer
    Public ClientName As String

    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)


#Region "Property"
    Private ReadOnly Property ClientRelationTypeID() As Integer
        Get
            Return DataHelper.FieldLookup("tblRelationType", "RelationTypeID", "[table]='tblClient'")
        End Get
    End Property

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
    Protected Sub RemoveSetting(ByVal s As String)
        Session.Remove(Identity & "_" & s)
    End Sub
#End Region
#Region "Event"
    Protected Sub lnkOpenPhoneCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkOpenPhoneCall.Click
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_phonecallholder.aspx?phonecallid=" & txtPhoneCallID.Value))
        Response.Write("&ClientID=" & DataClientID)

        If rblMode.SelectedValue = "2" Then
            Response.Write("&RelationTypeID=" & RelationTypeID)
            Response.Write("&RelationID=" & RelationID)
            Response.Write("&EntityName=" & Request.QueryString("EntityName"))
        Else
            Response.Write("&RelationTypeID=" & 1)
            Response.Write("&RelationID=" & DataClientID)
            Response.Write("&EntityName=" & ClientName)
        End If

        Response.Write("';</script>")
    End Sub

    Protected Sub lnkOpenNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkOpenNote.Click
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_noteholder.aspx?noteid=" & txtNoteID.Value))
        Response.Write("&ClientID=" & DataClientID)

        If rblMode.SelectedValue = "2" Then
            Response.Write("&RelationTypeID=" & RelationTypeID)
            Response.Write("&RelationID=" & RelationID)
            If Not IsNothing(Request.QueryString("EntityName")) Then
                Response.Write("&EntityName=" & Request.QueryString("EntityName").Replace("'", "%60"))
            End If
        Else
            Response.Write("&RelationTypeID=" & 1)
            Response.Write("&RelationID=" & DataClientID)
            Response.Write("&EntityName=" & ClientName)
        End If

        Response.Write("';</script>")
    End Sub

    Protected Sub lnkOpenLit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkOpenLit.Click
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_litholder.aspx" & txtLitString.Value))
        Response.Write("';</script>")
    End Sub

    Protected Sub lnkAddNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddNote.Click
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_noteholder.aspx?a=a"))
        Response.Write("&ClientID=" & DataClientID)

        If rblMode.SelectedValue = "2" Then
            Response.Write("&RelationTypeID=" & RelationTypeID)
            Response.Write("&RelationID=" & RelationID)
            If Not IsNothing(Request.QueryString("EntityName")) Then
                Response.Write("&EntityName=" & Request.QueryString("EntityName").Replace("'", "\'"))
            End If

        Else
            Response.Write("&RelationTypeID=" & 1)
            Response.Write("&RelationID=" & DataClientID)
            Response.Write("&EntityName=" & ClientName.Replace("'", "\'"))
        End If

        Response.Write("';</script>")
    End Sub

    Protected Sub lnkAddPhoneCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddPhoneCall.Click
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_phonecallholder.aspx?a=a"))
        Response.Write("&ClientID=" & DataClientID)

        If rblMode.SelectedValue = "2" Then
            Response.Write("&RelationTypeID=" & RelationTypeID)
            Response.Write("&RelationID=" & RelationID)
            Response.Write("&EntityName=" & Request.QueryString("EntityName"))
        Else
            Response.Write("&RelationTypeID=" & 1)
            Response.Write("&RelationID=" & DataClientID)
            Response.Write("&EntityName=" & ClientName)
        End If


        Response.Write("';</script>")
    End Sub

    Private Sub AutoAddPhoneCall()
        Response.Write("<script>self.location='")
        Response.Write(ResolveUrl("~/clients/client/communication/side_phonecallholder.aspx?a=a"))
        Response.Write("&ClientID=" & DataClientID)

        If rblMode.SelectedValue = "2" Then
            Response.Write("&RelationTypeID=" & RelationTypeID)
            Response.Write("&RelationID=" & RelationID)
            Response.Write("&EntityName=" & Request.QueryString("EntityName"))
        Else
            Response.Write("&RelationTypeID=" & 1)
            Response.Write("&RelationID=" & DataClientID)
            Response.Write("&EntityName=" & ClientName)
        End If
        Response.Write("';</script>")
    End Sub

#End Region
#Region "Sorting"

    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadHeaders()

        If txtSortField.Value = Setting("SortField") Then
            'toggle sort order
            If Setting("SortOrder") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortField.Value
            SortOrder = "ASC"
        End If
        SortField = txtSortField.Value

        Setting("SortField") = SortField
        Setting("SortOrder") = SortOrder

    End Sub
    Public Sub SetSortImage()
        Headers(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub
    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function
    Private Sub LoadHeaders()
        Headers = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(Headers, tdCreatedBy)
        AddHeader(Headers, tdDate)
        AddHeader(Headers, tdPerson)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "tdCreatedBy"
                Return "ByLastName"
            Case "tdDate"
                Return "StartTime"
            Case "tdPerson"
                Return "PersonLastName"
        End Select
        Return "Unknown"
    End Function
#End Region
#Region "Structures"
    Public Structure LitCommunication
        Public CommType As String
        Public [Date] As DateTime
        Public Description As String
        Public Content As String
        Public Staff As String
        Public CommTable As String
        Public CommDate As Integer
        Public CommTime As Integer

        Public Sub New(ByVal _CommType As String, ByVal _Date As DateTime, ByVal _Description As String, ByVal _Content As String, ByVal _Staff As String, ByVal _CommTable As String, ByVal _CommDate As Integer, ByVal _CommTime As Integer)
            Me.CommType = _CommType
            Me.Date = _Date
            Me.Description = _Description
            Me.Content = _Content
            Me.Staff = _Staff
            Me.CommTable = _CommTable
            Me.CommDate = _CommDate
            Me.CommTime = _CommTime
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        DataClientID = Integer.Parse(Request.QueryString("ClientID"))
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + DataClientID.ToString()).ToString()
        ClientName = ClientHelper.GetDefaultPersonName(DataClientID).Replace("'", "&#39;")

        RelationTypeID = Integer.Parse(Request.QueryString("RelationTypeID"))
        RelationID = Integer.Parse(Request.QueryString("RelationID"))
        RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & RelationTypeID)

        If Not IsPostBack Then

            rblMode.Items(1).Text += " " + ClientName

            If Integer.Parse(Request.QueryString("RelationTypeID")) = -1 Then
                rblMode.Items.RemoveAt(2)
            Else
                rblMode.SelectedIndex = 2
                dvEntityName.InnerHtml = Request.QueryString("EntityName")
                dvEntityType.InnerHtml = RelationTypeName
            End If
        End If

        If Not Session("note_back") Is Nothing Then
            rblMode.SelectedIndex = Setting("rblMode_SelectedIndex")
            Session.Remove("note_back")
        Else
            Setting("rblMode_SelectedIndex") = rblMode.SelectedIndex
        End If

        If Not IsPostBack Then
            '10.15.10.ug
            'save last comm url
            Session("Comms_LastURL") = Request.Url.ToString

            'Load settings
            Dim AutoSync As Boolean
            Boolean.TryParse(QuerySettingHelper.Lookup(Me.GetType.Name, UserID, "AutoSync"), AutoSync)
            Session("Comms_AutoSync") = AutoSync
            ddlOpenIn.SelectedIndex = DataHelper.Nz_int(QuerySettingHelper.Lookup(Me.GetType.Name, UserID, ddlOpenIn.ID))
        End If

    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadHeaders()
        SortField = Setting("SortField", "tdDate")
        SortOrder = Setting("SortOrder", "DESC")

        LoadComms()

        SetSortImage()

        If Session("Comms_AutoSync") Then lnkAutoSync.Attributes("class") = "gridButtonSel" Else lnkAutoSync.Attributes("class") = "gridButton"

        If Not Request.QueryString("auto") Is Nothing AndAlso Request.QueryString("auto") = "phonecall" Then
            AutoAddPhoneCall()
        End If

    End Sub
    Private Sub LoadComms()
        Dim dt As New DataTable
        dt.Columns.Add("CommType", GetType(Integer))
        dt.Columns.Add("PK", GetType(Integer))
        dt.Columns.Add("Subject", GetType(String))
        dt.Columns.Add("Value", GetType(String))
        dt.Columns.Add("By", GetType(String))
        dt.Columns.Add("ByLastName", GetType(String))
        dt.Columns.Add("StartTime", GetType(DateTime))
        dt.Columns.Add("EndTime", GetType(DateTime))
        dt.Columns.Add("UserType", GetType(String))
        dt.Columns.Add("Color", GetType(String))
        dt.Columns.Add("TextColor", GetType(String))
        dt.Columns.Add("BodyColor", GetType(String))
        dt.Columns.Add("Person", GetType(String))
        dt.Columns.Add("PersonLastName", GetType(String))
        dt.Columns.Add("Direction", GetType(String))
        dt.Columns.Add("LitType", GetType(String))
        dt.Columns.Add("Staff", GetType(String))
        dt.Columns.Add("CommDate", GetType(String))
        dt.Columns.Add("CommTime", GetType(String))
        dt.Columns.Add("CommTable", GetType(String))

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotes2")
            Using cmd.Connection
                cmd.Connection.Open()

                DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
                DatabaseHelper.AddParameter(cmd, "clientonly", rblMode.SelectedValue = "1")

                If rblMode.SelectedValue = "2" Then
                    DatabaseHelper.AddParameter(cmd, "relationid", RelationID)
                    DatabaseHelper.AddParameter(cmd, "relationtypeid", RelationTypeID)
                End If

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        If rblMode.SelectedValue = "3" Then
                            If Not IsDBNull(rd("relationtypeid")) Then
                                If rd("relationtypeid") = "19" Then
                                Else
                                    Continue While
                                End If
                            Else
                                Continue While
                            End If
                        End If

                        Dim dr As DataRow = dt.NewRow
                        dr("CommType") = 0
                        dr("PK") = rd("NoteID")
                        dr("Subject") = rd("Subject")
                        dr("Value") = rd("Value")
                        dr("By") = rd("By")
                        dr("ByLastName") = rd("ByLastName")
                        dr("StartTime") = rd("Date")
                        dr("EndTime") = rd("Date")
                        dr("UserType") = rd("UserType")
                        dr("Color") = rd("Color")
                        dr("TextColor") = DataHelper.Nz(rd("TextColor"), "black")
                        dr("BodyColor") = LocalHelper.AdjustColor(DataHelper.Nz(rd("TextColor"), "black"), 1.5)

                        dt.Rows.Add(dr)
                    End While
                End Using

                cmd.CommandText = "stp_GetPhoneCallsForCommunication"

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        If rblMode.SelectedValue = "3" Then
                            If Not IsDBNull(rd("relationtypeid")) Then
                                If rd("relationtypeid") = "19" Then
                                Else
                                    Continue While
                                End If
                            Else
                                Continue While
                            End If
                        End If
                        Dim dr As DataRow = dt.NewRow
                        dr("CommType") = 1
                        dr("PK") = rd("PhoneCallID")
                        dr("Subject") = rd("Subject")
                        dr("Value") = rd("Body")
                        dr("By") = rd("By")
                        dr("ByLastName") = rd("ByLastName")
                        dr("StartTime") = rd("StartTime")
                        dr("EndTime") = rd("EndTime")
                        dr("UserType") = rd("UserType")
                        dr("Color") = rd("Color")
                        dr("TextColor") = DataHelper.Nz(rd("TextColor"), "black")
                        dr("BodyColor") = LocalHelper.AdjustColor(DataHelper.Nz(rd("TextColor"), "black"), 1.5)
                        dr("Person") = rd("Person")
                        dr("PersonLastName") = rd("PersonLastName")
                        dr("Direction") = rd("Direction")

                        dt.Rows.Add(dr)
                    End While
                End Using
            End Using
        End Using

        'Dim Rows As New List(Of DataRow)
        ''12.3.2008.ug
        ''add try..catch so we don't fail when timematters crashes
        'Try

        '    Using cmd As New SqlCommand("SELECT AccountNumber, CommType, [Description], [Content], Staff, [Date], CommDate, CommTime, CommTable FROM (SELECT mat_no as AccountNumber, " + _
        '    "'note' as CommType, [desc] as [Description], memo as [Content], staff, " + _
        '    "dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date], [date] as CommDate, time as CommTime, 'tm8user.notes' as CommTable FROM tm8user.notes UNION ALL " + _
        '    "SELECT mat_no as AccountNumber, 'phonecall' as CommType, subject as [Description], memo as [Content], staff, " + _
        '    "dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date], [date] as CommDate, time as CommTime, 'tm8user.phone' as CommTable FROM tm8user.phone UNION ALL " + _
        '    "SELECT mat_no as AccountNumber, 'mail' as CommType, [desc] as [Description], memo as [Content], staff, " + _
        '    "dateadd(s, (time - 1)/100, dateadd(d, [date], '12-28-1800')) as [date], [date] as CommDate, time as CommTime, 'tm8user.mail' as CommTable FROM tm8user.mail) as LitCommunications " + _
        '    "WHERE AccountNumber = '" + AccountNumber + "' ORDER BY [Date] desc, Staff", New SqlConnection(ConfigurationSettings.AppSettings.Item("connectionstringtimematters").ToString()))
        '        Using cmd.Connection
        '            cmd.Connection.Open()

        '            Using reader As SqlDataReader = cmd.ExecuteReader()
        '                While reader.Read()
        '                    Dim dr As DataRow = dt.NewRow

        '                    dr("CommType") = 2
        '                    dr("PK") = 0
        '                    dr("Subject") = reader("Description")
        '                    dr("Value") = reader("Content")
        '                    dr("By") = reader("Staff")
        '                    dr("ByLastName") = ""
        '                    dr("StartTime") = reader("Date")
        '                    dr("EndTime") = reader("Date")
        '                    dr("UserType") = "Litigation"
        '                    dr("Color") = ""
        '                    dr("LitType") = reader("CommType")
        '                    dr("Staff") = reader("Staff")
        '                    dr("CommDate") = reader("CommDate")
        '                    dr("CommTime") = reader("CommTime")
        '                    dr("CommTable") = reader("CommTable")

        '                    Rows.Add(dr)
        '                End While
        '            End Using
        '        End Using
        '    End Using
        'Catch ex As Exception
        '    Exit Try
        'End Try

        'Using cmd As New SqlCommand("", ConnectionFactory.Create())
        '    Using cmd.Connection
        '        cmd.Connection.Open()

        '        For Each dr As DataRow In Rows
        '            cmd.CommandText = "SELECT TextColor FROM tblRuleCommColor WHERE EntityType = 'User Group' and EntityID = (SELECT UserGroupID FROM tblUserGroup WHERE [Name] = 'Litigation')"
        '            dr("TextColor") = DataHelper.Nz(cmd.ExecuteScalar(), "black")

        '            cmd.CommandText = "SELECT TextColor FROM tblRuleCommColor WHERE EntityType = 'User Group' and EntityID = (SELECT UserGroupID FROM tblUserGroup WHERE [Name] = 'Litigation')"
        '            dr("BodyColor") = LocalHelper.AdjustColor(DataHelper.Nz(cmd.ExecuteScalar(), "black"), 1.5)

        '            cmd.CommandText = "SELECT TOP 1 FirstName + ' ' + LastName FROM tblPerson WHERE Relationship = 'Primary' and ClientID = " + DataClientID.ToString()
        '            dr("Person") = DataHelper.Nz(cmd.ExecuteScalar(), "")

        '            cmd.CommandText = "SELECT TOP 1 LastName FROM tblPerson WHERE Relationship = 'Primary' and ClientID = " + DataClientID.ToString()
        '            dr("PersonLastName") = DataHelper.Nz(cmd.ExecuteScalar(), "")
        '            dr("Direction") = 1

        '            dt.Rows.Add(dr)
        '        Next
        '    End Using
        'End Using

        Dim result As New StringBuilder

        rpNotes.Visible = True
        rpPhoneCalls.Visible = True
        rpLitigation.Visible = True

        For Each dr As DataRow In dt.Select(Nothing, GetFullyQualifiedName(SortField) + " " + SortOrder)

            If dr("CommType") = 0 Then 'note
                rpNotes.DataSource = New DataRow() {dr}
                rpNotes.DataBind()
                result.Append(RenderToString(rpNotes))
            ElseIf dr("CommType") = 1 Then 'phonecall
                rpPhoneCalls.DataSource = New DataRow() {dr}
                rpPhoneCalls.DataBind()
                result.Append(RenderToString(rpPhoneCalls))
            ElseIf dr("CommType") = 2 Then 'litigation
                rpLitigation.DataSource = New DataRow() {dr}
                rpLitigation.DataBind()
                result.Append(RenderToString(rpLitigation))
            End If
        Next

        rpNotes.Visible = False
        rpPhoneCalls.Visible = False
        rpLitigation.Visible = False

        ltrGrid.Text = result.ToString

    End Sub

    Public Shared Function RenderToString(ByVal ctrl As Control) As String
        Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder
        Dim tw As System.IO.StringWriter = New System.IO.StringWriter(sb)
        Dim hw As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(tw)
        ctrl.RenderControl(hw)
        Return sb.ToString
    End Function

    Public Function GetImage(ByVal CommType As String) As String
        Select Case CommType.ToLower()
            Case "phonecall"
                Return ResolveUrl("~\images\16x16_phone.png")
            Case "mail"
                Return ResolveUrl("~\images\16x16_email_read.png")
            Case Else
                Return ResolveUrl("~\images\16x16_note.png")
        End Select
    End Function

    Public Function MakeSnippet(ByVal s As String, ByVal length As Integer) As String
        Dim result As String = s
        If result.Length > length Then result = result.Substring(0, length - 3) + "..."
        Return result
    End Function
End Class