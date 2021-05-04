Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_phonecalls
    Inherits PermissionPage

#Region "Variables"
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
    Public QueryString As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Private UserID As Integer
    Private UserTypeID As Integer

    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)

    Private relations As New List(Of SharedFunctions.DocRelation)
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
        AddHeader(Headers, tdDate)
        AddHeader(Headers, tdDuration)
        AddHeader(Headers, tdPerson)
        AddHeader(Headers, tdUser)
        AddHeader(Headers, tdUserType)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "tdDate"
                Return "pc.starttime"
            Case "tdDuration"
                Return "datediff(ss,pc.starttime,pc.endtime)"
            Case "tdPerson"
                Return "p.lastname"
            Case "tdUser"
                Return "u.lastname"
            Case "tdUserType"
                Return "ut.name"
        End Select
        Return "Unknown"
    End Function
#End Region

    Public Function MakeSnippet(ByVal s As String, ByVal length As Integer) As String
        Dim result As String = s
        If result.Length > length Then result = result.Substring(0, length - 3) + "..."
        Return result
    End Function

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadHeaders()
        SortField = Setting("SortField", "tdDate")
        SortOrder = Setting("SortOrder", "DESC")

        LoadCommunication()

        SetSortImage()

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(1).Selected = True

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes", dvPanel0.ClientID, "default.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Phone&nbsp;Calls", dvPanel1.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Litigation", dvPanel2.ClientID, "litigation.aspx?id=" & ClientID))

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        LoadTabStrips()

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then
            If Not IsPostBack Then
                relations = SharedFunctions.DocumentAttachment.GetRelationsForClient(ClientID)

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/" & QueryString

                SetRollups()
            End If
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
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddApplicant();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_person_add.png") & """ align=""absmiddle""/>Add new applicant</a>")
            'CommonTasks.Add("<hr size=""1""/>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddCall();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_phone2.png") & """ align=""absmiddle""/>Make Phone Call</a>")
        End If
        If UserTypeID = 5 Then 'Attorneys always can add notes
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddNote();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """ align=""absmiddle""/>Add a note</a>")
        End If
    End Sub

    Public Structure GridPhoneCall
        Dim PhoneCallID As Integer
        Dim PersonName As String
        Dim UserType As String
        Dim UserName As String
        Dim CallDate As DateTime
        Dim CallDateEnd As DateTime
        Dim Duration As String
        Dim Subject As String
        Dim Body As String
        Dim strDirection As String
        Dim Direction As Boolean
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
    End Structure
    Private Sub LoadCommunication()
        Dim PhoneCalls As New List(Of GridPhoneCall)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhoneCalls2")
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
                DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedName(SortField) + " " + SortOrder)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim pc As New GridPhoneCall

                        pc.PhoneCallID = DatabaseHelper.Peel_int(rd, "PhoneCallID")
                        pc.PersonName = DatabaseHelper.Peel_string(rd, "person")
                        pc.UserName = DatabaseHelper.Peel_string(rd, "by")
                        pc.UserType = DatabaseHelper.Peel_string(rd, "UserType")
                        pc.CallDate = DatabaseHelper.Peel_date(rd, "starttime")
                        pc.Body = DatabaseHelper.Peel_string(rd, "body")
                        pc.Subject = DatabaseHelper.Peel_string(rd, "subject")
                        pc.CallDateEnd = DatabaseHelper.Peel_date(rd, "endtime")
                        pc.Direction = DatabaseHelper.Peel_bool(rd, "direction")
                        pc.Color = DatabaseHelper.Peel_string(rd, "color")
                        pc.TextColor = DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black")
                        pc.BodyColor = LocalHelper.AdjustColor(DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black"), 1.5)
                        pc.strDirection = IIf(pc.Direction, "To", "From")
                        pc.Duration = LocalHelper.FormatTimeSpan(pc.CallDateEnd.Subtract(pc.CallDate))

                        PhoneCalls.Add(pc)
                    End While
                End Using
            End Using
        End Using

        rpPhoneCalls.DataSource = PhoneCalls
        rpPhoneCalls.DataBind()

        rpPhoneCalls.Visible = rpPhoneCalls.Items.Count > 0
        pnlNoNotes.Visible = rpPhoneCalls.Items.Count = 0
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

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelected.Value.Length > 0 Then

            'get selected "," delimited NoteId's
            Dim Communications() As String = txtSelected.Value.Split(",")

            Dim PhoneCallIDs As New List(Of Integer)

            For Each com As String In Communications
                PhoneCallIDs.Add(DataHelper.Nz_int(com))
            Next

            If PhoneCallIDs.Count > 0 Then
                PhoneCallHelper.Delete(PhoneCallIDs.ToArray())
            End If

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(phCommunication_default, c, "Clients-Client Single Record-Communication-Default")
    End Sub

End Class
