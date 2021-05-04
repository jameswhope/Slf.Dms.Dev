Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_settings_properties_property
    Inherits System.Web.UI.Page

#Region "Variables"

    Private PropertyID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblProperty"

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            PropertyID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                LoadRecord()
            End If

            SetRollups()
            SetAttributes()

        End If

        Me.Master.AddPnlBody = True
    End Sub
    Private Sub SetAttributes()

        lboValues.Attributes("ondblclick") = "javascript:lboValues_OnDblClick(this);"

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this property</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Print();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Print this property</a>")

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM " & baseTable & " WHERE PropertyID = @PropertyID"

        DatabaseHelper.AddParameter(cmd, "PropertyID", PropertyID)

        Session("rptcmd_rptProperty") = cmd

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblProperty.Text = DatabaseHelper.Peel_string(rd, "Display")
                lblPropertyID.Text = DatabaseHelper.Peel_int(rd, "PropertyID")
                lblName.Text = DatabaseHelper.Peel_string(rd, "Display")
                lblType.Text = DatabaseHelper.Peel_string(rd, "Type")
                lblDescription.Text = DatabaseHelper.Peel_string(rd, "Description")

                chkNullable.Checked = DatabaseHelper.Peel_bool(rd, "Nullable")

                If DatabaseHelper.Peel_bool(rd, "Multi") Then

                    chkMulti.Checked = True
                    pnlMulti.Visible = True
                    txtValue.Style("display") = "none"

                    Dim Values As String = DatabaseHelper.Peel_string(rd, "Value")

                    Dim Parts() As String = Values.Split("|")

                    txtValue.Text = Values

                    For i As Integer = 0 To Parts.Length - 1

                        Dim Value As String = Parts(i)

                        Select Case lblType.Text.ToLower
                            Case "dollar amount", "number"
                                lboValues.Items.Add(New ListItem(DataHelper.Nz_double(Value).ToString("##0.00"), Value))
                                txtAdd.MaxLength = 6
                            Case "percentage"
                                lboValues.Items.Add(New ListItem((DataHelper.Nz_double(Value) * 100).ToString("##0.00"), Value))
                                txtAdd.MaxLength = 6
                            Case Else
                                lboValues.Items.Add(New ListItem(Value, Value))
                        End Select

                    Next

                Else

                    Select Case lblType.Text.ToLower
                        Case "dollar amount", "number"
                            txtValue.Text = DataHelper.Nz_double(DatabaseHelper.Peel_string(rd, "Value")).ToString("##0.00")
                        Case "percentage"
                            txtValue.Text = (DataHelper.Nz_double(DatabaseHelper.Peel_string(rd, "Value")) * 100).ToString("##0.00")
                        Case Else
                            txtValue.Text = DatabaseHelper.Peel_string(rd, "Value")
                    End Select

                    chkMulti.Checked = False
                    pnlMulti.Visible = False
                    txtValue.Style.Remove("display")

                End If

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""admin_settings_properties_property""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Function RequiredExist() As Boolean

        Dim Messages As New ArrayList

        'required fields

        pnlError.Visible = Messages.Count > 0

        tdError.InnerText = String.Join("<br>", Messages.ToArray(GetType(String)))

        Return Messages.Count = 0

    End Function
    Private Sub SaveRecord()

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Not chkMulti.Checked Then
            Select Case lblType.Text.ToLower
                Case "percentage"
                    DatabaseHelper.AddParameter(cmd, "Value", Double.Parse(txtValue.Text) / 100)
                Case "dollar amount", "number"
                    DatabaseHelper.AddParameter(cmd, "Value", Double.Parse(txtValue.Text).ToString("###0.00"))
                Case Else
                    DatabaseHelper.AddParameter(cmd, "Value", txtValue.Text)
            End Select
        Else
            DatabaseHelper.AddParameter(cmd, "Value", txtValue.Text)
        End If

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(0))

        DatabaseHelper.BuildUpdateCommandText(cmd, baseTable, "PropertyID = " & PropertyID)

        Try

            cmd.Connection.Open()
            cmd.Transaction = cmd.Connection.BeginTransaction()

            With cmd.Transaction

                cmd.ExecuteNonQuery()

                Try
                    .Commit()
                Catch
                    .Rollback()
                End Try

            End With

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        SaveRecord()
        Close()

    End Sub
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Close()
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/settings/properties")
    End Sub
End Class