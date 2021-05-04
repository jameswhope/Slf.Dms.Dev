Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class admin_settings_negotiation_selection
    Inherits PermissionPage


#Region "Variables"
    Private UserID As Integer
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        LoadStatuses()
        LoadAccountStatuses()
        LoadAgencies()

        If Not IsPostBack Then
            LoadRecord()
        End If
        SetRollups()
    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this rule</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save and close</a>")

    End Sub
    Private Sub AddValue(ByVal settings As DataTable, ByVal Name As String, ByVal value As String, ByVal type As Type, ByVal [Default] As Object)
        Dim o As Object = [Default]
        If value IsNot Nothing And value.Length > 0 Then
            If type Is GetType(Single) Then
                Single.TryParse(value, o)
            ElseIf type Is GetType(DateTime) Then
                DateTime.TryParse(value, o)
            ElseIf type Is GetType(Boolean) Then
                Boolean.TryParse(value, o)
            End If
        End If
        AddValue(settings, Name, o)
    End Sub
    Private Sub AddValue(ByVal settings As DataTable, ByVal Name As String, ByVal value As String, ByVal type As Type)
        AddValue(settings, Name, value, type, Nothing)
    End Sub
    Private Sub AddValue(ByVal settings As DataTable, ByVal Name As String, ByVal value As Object)
        settings.Rows.Add(New Object() {Name, value})
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/settings/rules/")
    End Sub
    Private Sub Save()
        Dim settings As New DataTable
        settings.Columns.Add("Name")
        settings.Columns.Add("Value")

        AddValue(settings, "AccountStatusChoice", optAccountStatusChoice.SelectedValue, GetType(Boolean))
        AddValue(settings, "AccountStatusIDs", csAccountStatusID.SelectedStr, GetType(String))
        AddValue(settings, "ClientStatusChoice", optClientStatusChoice.SelectedValue, GetType(Boolean))
        AddValue(settings, "ClientStatusIDs", csClientStatusID.SelectedStr, GetType(String))
        AddValue(settings, "AgencyChoice", optAgencyChoice.SelectedValue, GetType(Boolean))
        AddValue(settings, "AgencyIDs", csAgencyID.SelectedStr, GetType(String))
        AddValue(settings, "AccountBalance1", txtAccountBal1.Value, GetType(Single))
        AddValue(settings, "AccountBalance2", txtAccountBal2.Value, GetType(Single))
        AddValue(settings, "HireDate1", txtHireDate1.Text, GetType(DateTime))
        AddValue(settings, "HireDate2", txtHireDate2.Text, GetType(DateTime))
        AddValue(settings, "ThresholdPercent1", txtThresholdPercent1.Value, GetType(Single), 10)
        AddValue(settings, "ThresholdPercent2", txtThresholdPercent2.Value, GetType(Single))
        AddValue(settings, "UnassignedOnly", chkUnassignedOnly.Checked)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SetNameValueRule")
            Using cmd.Connection
                cmd.Connection.Open()
                For Each r As DataRow In settings.Rows
                    cmd.Parameters.Clear()
                    DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                    DatabaseHelper.AddParameter(cmd, "RuleTypeName", "NegotiationSelection")
                    DatabaseHelper.AddParameter(cmd, "RuleName", r("Name"))
                    DatabaseHelper.AddParameter(cmd, "Value", r("Value"))
                    cmd.ExecuteNonQuery()
                Next
            End Using
        End Using
    End Sub
    Private Sub LoadRecord()
        Dim settings As New DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_getnamevaluerule")
        DatabaseHelper.AddParameter(cmd, "ruletypename", "NegotiationSelection")
        Dim da As New SqlClient.SqlDataAdapter(cmd)
        da.Fill(settings)

        For Each r As DataRow In settings.Rows
            If Not r.IsNull("Value") Then


                Select Case r("Name")
                    Case "AccountStatusChoice"
                        optAccountStatusChoice.SelectedValue = r("Value").ToString
                    Case "ClientStatusChoice"
                        optClientStatusChoice.SelectedValue = r("Value").ToString
                    Case "AgencyChoice"
                        optAgencyChoice.SelectedValue = r("Value").ToString
                    Case "AccountStatusIDs"
                        csAccountStatusID.SelectedStr = r("Value")
                    Case "ClientStatusIDs"
                        csClientStatusID.SelectedStr = r("Value")
                    Case "AgencyIDs"
                        csAgencyID.SelectedStr = r("Value")
                    Case "AccountBalance1"
                        txtAccountBal1.Value = r("Value").ToString()
                    Case "AccountBalance2"
                        txtAccountBal2.Value = r("Value").ToString()
                    Case "HireDate1"
                        txtHireDate1.Text = CType(r("Value"), DateTime).ToString("MM/dd/yy")
                    Case "HireDate2"
                        txtHireDate2.Text = CType(r("Value"), DateTime).ToString("MM/dd/yy")
                    Case "ThresholdPercent1"
                        txtThresholdPercent1.Value = r("Value").ToString()
                    Case "ThresholdPercent2"
                        txtThresholdPercent2.Value = r("Value").ToString()
                    Case "UnassignedOnly"
                        chkUnassignedOnly.Checked = r("Value")
                End Select
            End If
        Next
    End Sub
#End Region
#Region "Util"
    Private Sub LoadAgencies()
        csAgencyID.Items.Clear()
        csAgencyID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblAgency order by code"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Code")
                        csAgencyID.AddItem(New ListItem(Name, AgencyId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csAgencyID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csAgencyID.ID + "'")
        End If
    End Sub
    Private Sub LoadStatuses()
        csClientStatusID.Items.Clear()
        csClientStatusID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblClientStatus"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim ClientStatusId As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csClientStatusID.AddItem(New ListItem(Name, ClientStatusId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csClientStatusID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csClientStatusID.ID + "'")
        End If
    End Sub
    Private Sub LoadAccountStatuses()
        csAccountStatusID.Items.Clear()
        csAccountStatusID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblAccountStatus"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim AccountStatusId As Integer = DatabaseHelper.Peel_int(rd, "AccountStatusID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Description")
                        Dim Code As String = DatabaseHelper.Peel_string(rd, "Code")
                        csAccountStatusID.AddItem(New ListItem(Code + " (" + Name + ")", AccountStatusId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csAccountStatusID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csAccountStatusID.ID + "'")
        End If
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
#End Region

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save()
    End Sub

    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Close()
    End Sub

    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click
        Save()
        close()
    End Sub

End Class
