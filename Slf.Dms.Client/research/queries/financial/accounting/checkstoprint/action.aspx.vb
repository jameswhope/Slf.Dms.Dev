Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic

Partial Class research_queries_financial_checkstoprint_action
    Inherits PermissionPage

#Region "Variables"

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(User.Identity.Name)

        If Not IsPostBack Then
            LoadPrintedBys()
        End If

        optClearSetting.Attributes("onpropertychange") = "optClearSetting_OnPropertyChange(this);"
        optPrintWithoutSetting.Attributes("onpropertychange") = "optPrintWithoutSetting_OnPropertyChange(this);"
        optSetWithoutPrinting.Attributes("onpropertychange") = "optSetWithoutPrinting_OnPropertyChange(this);"
        optPrintAndSet.Attributes("onpropertychange") = "optPrintAndSet_OnPropertyChange(this);"

    End Sub
    Private Sub LoadPrintedBys()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblUser ORDER BY LastName, FirstName"

            cboPrintedBy.Items.Clear()
            cboPrintedBy.Items.Add(New ListItem(String.Empty, 0))

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        cboPrintedBy.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LastName") _
                            & ", " & DatabaseHelper.Peel_string(rd, "FirstName"), _
                            DatabaseHelper.Peel_int(rd, "UserID")))

                    End While

                End Using
            End Using
        End Using

    End Sub
    Protected Sub lnkSetChecks_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSetChecks.Click

        'update checks with printed field info
        UpdateChecksToPrint(GetIDCriteria(GetCheckToPrintIDs))

        Close()

    End Sub
    Protected Sub lnkClearChecks_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearChecks.Click

        'clear printed field info from checks
        ClearChecksToPrint(GetIDCriteria(GetCheckToPrintIDs))

        Close()

    End Sub
    Private Function GetCheckToPrintIDs() As List(Of Integer)

        Dim CheckToPrintIDs As New List(Of Integer)

        Dim strIds As String = Context.Request.QueryString("ids")
        Dim Ids() As String = strIds.Split(",")
        For Each s As String In Ids
            CheckToPrintIDs.Add(Integer.Parse(s))
        Next

        Return CheckToPrintIDs

    End Function
    Private Function GetIDCriteria(ByVal CheckToPrintIDs As List(Of Integer)) As String

        Dim Criteria As String = String.Empty

        'build criteria
        For i As Integer = 0 To CheckToPrintIDs.Count - 1

            If Criteria.Length > 0 Then
                Criteria += "," & CheckToPrintIDs(i).ToString()
            Else
                Criteria = CheckToPrintIDs(i).ToString()
            End If

        Next

        Return Criteria

    End Function
    Private Sub UpdateChecksToPrint(ByVal Criteria As String)

        'do update
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "Printed", Now)
            DatabaseHelper.AddParameter(cmd, "PrintedBy", DataHelper.Nz_int(cboPrintedBy.SelectedValue))

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCheckToPrint", "CheckToPrintID IN (" & Criteria & ")")

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Private Sub ClearChecksToPrint(ByVal Criteria As String)

        'do update
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "Printed", DBNull.Value, DbType.DateTime)
            DatabaseHelper.AddParameter(cmd, "PrintedBy", DBNull.Value, DbType.Int32)

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCheckToPrint", "CheckToPrintID IN (" & Criteria & ")")

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Private Sub Close()

        'issue javascript back to page to close form and reload opener
        If optPrintAndSet.Checked Then
            Response.Write("<script type=""text/javascript"">window.close();</script>")
        Else
            Response.Write("<script type=""text/javascript"">window.parent.dialogArguments.location = " _
                & "window.parent.dialogArguments.location.href;window.close();</script>")
        End If

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(frmBody, c, "Research-Queries-Financial-Accounting-Checks To Print")
    End Sub
End Class