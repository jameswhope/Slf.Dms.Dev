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

Partial Class admin_settings_negotiation_assignment
    Inherits System.Web.UI.Page

    Private UserID As Integer

#Region "Event"
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this rule</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save and close</a>")

    End Sub
    Private Function GetCriteria() As String
        Dim result As String = ""

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            cmd.CommandText = "select [value] from tblquerysetting where classname=@classname and userid=@userid and object=@object"
            DatabaseHelper.AddParameter(cmd, "classname", Me.GetType.Name)
            DatabaseHelper.AddParameter(cmd, "userid", UserID)
            DatabaseHelper.AddParameter(cmd, "object", txtCriteria.ID)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    If rd.Read Then
                        result = rd.GetString(0)
                    End If
                End Using
            End Using
        End Using

        Return result
    End Function
    Private Sub Save()
        DataHelper.Delete("tblrulenegotiation")

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.Connection.Open()

                Dim Users As String() = txtCriteria.Value.Split("|")
                For Each u As String In Users
                    Dim parts As String() = u.Split(",")
                    cmd.Parameters.Clear()
                    DatabaseHelper.AddParameter(cmd, "userid", Integer.Parse(parts(0)))
                    DatabaseHelper.AddParameter(cmd, "rangestart", parts(1))
                    DatabaseHelper.AddParameter(cmd, "rangeend", parts(2))
                    DatabaseHelper.AddParameter(cmd, "lastmodifiedby", UserID)
                    DatabaseHelper.BuildInsertCommandText(cmd, "tblrulenegotiation")
                    cmd.ExecuteNonQuery()
                Next
            End Using
        End Using
    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CType(Page.User.Identity.Name, Integer)

        SetAttributes()

        LoadMediators()

        SetRollups()
    End Sub
    Private Sub SetAttributes()
        lstMediators.BorderColor = System.Drawing.Color.Gray
        lstMediators.BorderStyle = BorderStyle.Solid
        lstMediators.BorderWidth = 1
    End Sub

#End Region
#Region "Query"
    Private Sub LoadMediators()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMediators")

        lstMediators.Items.Clear()

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()

                    Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                    Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                    Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")

                    Dim li As New ListItem(FirstName & " " & LastName, UserID)

                    lstMediators.Items.Add(li)

                End While

            End Using
        End Using

    End Sub

    Private Sub LoadGrid()
        Dim dtPlanned As New DataTable
        dtPlanned.Columns.Add("Start")
        dtPlanned.Columns.Add("End")
        dtPlanned.Columns.Add("FullName")
        dtPlanned.Columns.Add("UserID")

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNegotiatorRules")
        Dim da As New SqlDataAdapter(cmd)
        da.Fill(dtPlanned)

        Dim sb As New StringBuilder()
        For i As Integer = 0 To dtPlanned.Rows.Count - 1
            Dim dr As DataRow = dtPlanned.Rows(i)
            Dim disabled1 As String = IIf(i = 0, " disabled=""true"" ", "")
            Dim disabled2 As String = IIf(i = dtPlanned.Rows.Count - 1, " disabled=""true"" ", "")

            Dim value1 As String = ""
            If i = 0 Then
                value1 = " value=""Aa"" "
            ElseIf Not IsDBNull(dr("RangeStart")) Then
                value1 = " value=""" & dr("RangeStart") & """"
            End If

            Dim value2 As String = ""
            If i = dtPlanned.Rows.Count - 1 Then
                value2 = " value=""Zz"" "
            ElseIf Not IsDBNull(dr("RangeEnd")) Then
                value2 = " value=""" & dr("RangeEnd") & """"
            End If

            sb.Append("<tr UserID=""" & dr("UserID") & """>")
            sb.Append("<td><input onkeypress=""AllowOnlyLetters(event);"" onblur=""LinkValues(this, 0)"" UserID=""" & dr("UserID") & """ type=""textbox"" maxlength=""2"" style=""width:30px;font-family:tahoma;font-size:11px""" + disabled1 + value1 + "/></td>")
            sb.Append("<td><input onkeypress=""AllowOnlyLetters(event);"" onblur=""LinkValues(this, 1)"" UserID=""" & dr("UserID") & """ type=""textbox"" maxlength=""2"" style=""width:30px;font-family:tahoma;font-size:11px""" + disabled2 + value2 + "/></td>")
            sb.Append("<td UserID=""" & dr("UserID") & """>" & dr("FullName") & "</td>")

            sb.Append("</tr>")
        Next

        ltrGrid.Text = sb.ToString()
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/settings/rules/")
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save()
    End Sub

    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Close()
    End Sub

    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click
        Save()
        Close()
    End Sub
#End Region

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadGrid()
    End Sub
End Class

