Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_litigation
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Public DataClientID As Integer
    Private AccountNumber As String
    Private ClientName As String
    Private AttorneyName As String
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

    Public Function MakeSnippet(ByVal s As String, ByVal length As Integer) As String
        Dim result As String = s

        If result.Length > length Then
            result = result.Substring(0, length - 3) + "..."
        End If

        Return result
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

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        tsMain.TabPages(2).Selected = True
    End Sub

    Private Sub LoadTabStrips()
        tsMain.TabPages.Clear()
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes", dvPanel0.ClientID, "default.aspx?id=" & DataClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Phone&nbsp;Calls", dvPanel1.ClientID, "phonecalls.aspx?id=" & DataClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Litigation", dvPanel2.ClientID))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        DataClientID = Integer.Parse(Request.QueryString("id"))
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + DataClientID.ToString()).ToString()
        ClientName = GetClientName(DataClientID)
        AttorneyName = GetAttorneyName(DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " + DataClientID.ToString))

        LoadTabStrips()
        LoadCommunication()

        If Not IsPostBack Then
            lnkClient.InnerText = ClientName & " - " & AttorneyName & " - " & AccountNumber
            lnkClient.HRef = "~\clients\client\?id=" + DataClientID.ToString()
        End If
    End Sub

    Private Function GetClientName(ByVal ClientID As Integer) As String

        Using cmd As New SqlCommand("SELECT FirstName + ' ' + LastName FROM tblPerson WHERE ClientID = " & ClientID, New SqlConnection(ConfigurationManager.AppSettings.Item("connectionstring").ToString()))
            Using cmd.Connection
                cmd.Connection.Open()
                Return cmd.ExecuteScalar
            End Using
        End Using

    End Function

    Private Function GetAttorneyName(ByVal CompanyID As Integer) As String
        Using cmd As New SqlCommand("SELECT Name FROM tblCompany WHERE CompanyID = " & CompanyID, New SqlConnection(ConfigurationManager.AppSettings.Item("connectionstring").ToString()))
            Using cmd.Connection
                cmd.Connection.Open()
                Return cmd.ExecuteScalar
            End Using
        End Using
    End Function

    Private Sub LoadCommunication()
        Dim comms As New List(Of LitCommunication)

        If AccountNumber.Length > 0 Then
            Dim ssql As String = String.Format("stp_get_LitigationNotes {0}", DataClientID)
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                For Each row As DataRow In dt.Rows
                    comms.Add(New LitCommunication(row("CommType").ToString(), DateTime.Parse(row("Date")), row("Description"), row("Content"), row("Staff"), row("CommTable"), CDate(row("CommDate")).ToOADate, CDate(row("CommTime")).ToOADate))
                Next
            End Using

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
            '                    comms.Add(New LitCommunication(reader("CommType").ToString(), DateTime.Parse(reader("Date")), reader("Description"), reader("Content"), reader("Staff"), reader("CommTable"), Integer.Parse(reader("CommDate")), Integer.Parse(reader("CommTime"))))
            '                End While
            '            End Using
            '        End Using
            '    End Using
        End If

        rpLitCommunication.DataSource = comms
        rpLitCommunication.DataBind()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(phCommunication_default, c, "Clients-Client Single Record-Communication-Default")
    End Sub
End Class