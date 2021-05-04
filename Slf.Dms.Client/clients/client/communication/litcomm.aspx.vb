Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communciation_litcomm
    Inherits PermissionPage

#Region "Variables"
    Private ClientID As Integer
    Public CommTable As String
    Public CommDate As Integer
    Public CommTime As Integer
    Public Staff As String
    Public AccountNumber As String
    Private ClientName As String
    Private AttorneyName As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ClientID = Integer.Parse(Request.QueryString("id"))
        CommTable = Request.QueryString("table")
        CommDate = Integer.Parse(Request.QueryString("date"))
        CommTime = Integer.Parse(Request.QueryString("time"))
        Staff = Request.QueryString("staff")

        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()).ToString()
        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()).ToString()
        ClientName = GetClientName(ClientID)
        AttorneyName = GetAttorneyName(DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " + ClientID.ToString))

        lnkClient.InnerText = ClientName & " - " & AttorneyName & " - " & AccountNumber
        lnkClient.HRef = "~\clients\client\?id=" + ClientID.ToString()

        lnkCommunications.HRef = "~\clients\client\communication\litigation.aspx?id=" + ClientID.ToString()

        lblNote.Text = "Litigation"

        If Not IsPostBack Then
            HandleAction()

            LoadCommunication()
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

    Private Sub HandleAction()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
    End Sub

    Private Sub LoadCommunication()
        Using cmd As New SqlCommand("SELECT memo as Message, " + IIf(CommTable = "tm8user.phone", "subject", "[desc]") + _
        " as Subject, dateadd(s, (c_time - 1)/100, dateadd(d, c_date, '12-28-1800')) as Created, " + _
        "created_by as CreatedBy, dateadd(s, (m_time - 1)/100, dateadd(d, m_date, '12-28-1800')) as Modified, staff as ModifiedBy FROM " + _
        CommTable + " WHERE mat_no = '" + AccountNumber + "' and [date] = " + CommDate.ToString() + " and time = " + CommTime.ToString() + " and staff = '" + _
        Staff + "'", New SqlConnection(ConfigurationSettings.AppSettings.Item("connectionstringtimematters").ToString()))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtCreatedBy.Text = reader("CreatedBy").ToString()
                        txtCreatedDate.Text = DateTime.Parse(reader("Created")).ToString("g")

                        txtLastModifiedBy.Text = reader("ModifiedBy").ToString()
                        txtLastModifiedDate.Text = DateTime.Parse(reader("Modified")).ToString("g")

                        lblSubject.Text = reader("Subject").ToString()
                        txtMessage.Text = reader("Message").ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub Close()
        Response.Redirect("~/clients/client/communication/litigation.aspx?id=" & ClientID)
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class