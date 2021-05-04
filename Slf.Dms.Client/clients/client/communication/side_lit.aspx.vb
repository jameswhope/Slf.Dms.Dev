Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_side_lit
    Inherits Page

#Region "Variables"
    Public DataClientID As Integer
    Public AccountNumber As String
    Public ClientName As String
    Public CommTable As String
    Public CommDate As Integer
    Public CommTime As Integer
    Public Staff As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        DataClientID = DataHelper.Nz_int(Request.QueryString("id"), -1)
        ClientName = ClientHelper.GetDefaultPersonName(DataClientID)
        CommTable = Request.QueryString("table")
        CommDate = Integer.Parse(Request.QueryString("date"))
        CommTime = Integer.Parse(Request.QueryString("time"))
        Staff = Request.QueryString("staff")

        AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + DataClientID.ToString()).ToString()

        LoadRecord()
    End Sub

    Private Sub LoadRecord()
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

    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Response.Write("<script>self.top.location='" & Session("Comms_LastURL") & "';</script>")
        Session("lit_back") = True
    End Sub
End Class