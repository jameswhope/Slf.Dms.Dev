Option Explicit On

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Reflection
Imports System.Collections.Generic

Partial Class admin_settings_references_single
    Inherits System.Web.UI.Page

#Region "Variables"

    Private _a As String

    Public _rid As Integer
    Public _referenceid As Integer

    Public _deletetitle As String
    Public _deletetext As String

    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            _a = DataHelper.Nz_string(qs("a"))
            _rid = DataHelper.Nz_int(qs("rid"))
            _referenceid = DataHelper.Nz_int(qs("id"))

            SetDisplay()

            If Not IsPostBack Then
                LoadRecord()
            End If

        End If

    End Sub
    Private Sub SetDisplay()

        If ReferenceHelper.Exists(_referenceid) Then

            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblReference WHERE ReferenceID = @ReferenceID"

            DatabaseHelper.AddParameter(cmd, "ReferenceID", _referenceid)

            Using cmd
                Using cmd.Connection
                    Using rd

                        cmd.Connection.Open()

                        rd = cmd.ExecuteReader()

                        If rd.Read() Then

                            Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

                            lblTitle.Text = DatabaseHelper.Peel_string(rd, "Title")

                            _deletetitle = "Delete " & DatabaseHelper.Peel_string(rd, "Title")
                            _deletetext = "Are you sure you want to delete this " & DatabaseHelper.Peel_string(rd, "Title").ToLower() & "?"

                            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")

                            If DatabaseHelper.Peel_bool(rd, "Edit") Then
                                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this " & DatabaseHelper.Peel_string(rd, "LastWord").ToLower() & "</a>")
                            End If

                            If Not _a = "a" Then
                                If DatabaseHelper.Peel_bool(rd, "Delete") Then
                                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""" & String.Format("Record_DeleteConfirm('{0}','{1}');return false;", _deletetitle, _deletetext) & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this " & DatabaseHelper.Peel_string(rd, "LastWord").ToLower() & "</a>")
                                End If
                            End If

                        End If

                    End Using
                End Using
            End Using

        Else
            Response.Redirect("~/admin/settings/references")
        End If

    End Sub
    Private Sub LoadRecord()

        'get field info
        Dim Fields As List(Of ReferenceField) = ReferenceFieldHelper.GetFieldsForReference(_referenceid, "SingleOrder")

        Dim Table As String = DataHelper.FieldLookup("tblReference", "Table", "ReferenceID = " & _referenceid)
        Dim KeyField As String = DataHelper.FieldLookup("tblReference", "KeyField", "ReferenceID = " & _referenceid)

        Dim IDs As New List(Of String)

        'render table
        Dim Output As New StringBuilder()

        Dim Category As String = String.Empty

        Dim dt As DataTable = Nothing

        If Not _a = "a" Then 'not adding so load

            dt = ReferenceHelper.GetRecords(ReferenceHelper.GetCommandText(Table, _
                Fields, "[" & Table & "].[" & KeyField & "] = " & _rid))

        End If

        For i As Integer = 0 To Fields.Count - 1

            Dim Field As ReferenceField = Fields(i)

            If Field.Single Then

                If Not Category = Field.Category Then

                    If Category.Length > 0 Then

                        'end the last category table
                        Output.Append("</table>")

                    End If

                    Category = Field.Category

                    'create new category table
                    Output.Append("<table class=""srefTable"" border=""0"" cellpadding=""0"" cellspacing=""5"">")
                    Output.Append("<tr><td class=""srefHeaderCell"" colspan=""2"">" & Category & "</td></tr>")

                End If

                Dim Caption As String = IIf(Field.Caption.Length > 0, Field.Caption, Field.Field)

                Output.Append("<tr>")
                Output.Append(" <td class=""srefEntryTitleCell"">" & Caption & ":</td>")

                Dim Value As String = String.Empty

                If Not dt Is Nothing Then
                    Value = GetValue(dt, Field.Type, Field.Field, Field.SingleFormat)
                End If

                Dim FieldToSave As String = IIf(Field.FieldToSave.Length > 0, Field.FieldToSave, Field.Field)

                Output.Append(" <td class=""srefEntryCell"">" & GetInput(Value, Field.Editable, _
                    Field.Required, Field.Validate, Field.Attributes, Field.Input, Field.IMMask, _
                    Field.DDLSource, Field.DDLValue, Field.DDLText, IDs, Caption, FieldToSave, Field.Type) & "</td>")

                Output.Append("</tr>")

            End If

        Next

        'end the last category table
        Output.Append("</table>")

        'append on invisible field markings
        Output.Append("<div style=""display:none;"" id=""dvFields"">" & String.Join(",", IDs.ToArray()) & "</div>")

        ltrFields.Text = Output.ToString()

        If IDs.Count > 0 Then
            bdMain.Attributes("onload") = "SetFocus('" & IDs(0) & "');"
        End If

    End Sub
    Private Function GetValue(ByVal dt As DataTable, ByVal Type As String, ByVal FieldName As String, ByVal Format As String) As String

        If dt.Rows.Count > 0 Then

            Select Case Type.ToLower()
                Case "bit"
                    Return DataHelper.Nz_bool(dt.Rows(0).Item(FieldName)).ToString()
                Case "int"
                    Return DataHelper.Nz_int(dt.Rows(0).Item(FieldName)).ToString(Format)
                Case "datetime"
                    Return DataHelper.Nz_date(dt.Rows(0).Item(FieldName)).ToString(Format)
                Case "money"
                    Return DataHelper.Nz_double(dt.Rows(0).Item(FieldName)).ToString(Format)
                Case Else
                    Return DataHelper.Nz_string(dt.Rows(0).Item(FieldName))
            End Select

        Else
            Return String.Empty
        End If

    End Function
    Private Function GetInput(ByVal Value As String, ByVal Editable As Boolean, ByVal Required As Boolean, _
        ByVal Validate As String, ByVal Attributes As String, ByVal Input As String, ByVal IMMask As String, _
        ByVal DDLSource As String, ByVal DDLValue As String, ByVal DDLText As String, _
        ByVal IDs As List(Of String), ByVal Caption As String, ByVal FieldToSave As String, _
        ByVal Type As String) As String

        If Editable Then

            Dim t As New TextBox

            Dim AfterText As String = String.Empty

            Using Writer As New IO.StringWriter
                Using HtmlWriter As New HtmlTextWriter(Writer)

                    Select Case Input.ToLower()
                        Case "chk"

                            Dim chk As CheckBox = GetCheckBox(DataHelper.Nz_bool(Value))

                            chk.ID = "chk" & Caption.Replace(" ", String.Empty)

                            IDs.Add(chk.ClientID)

                            chk.TabIndex = IDs.Count

                            chk.RenderControl(HtmlWriter)

                            AfterText = "<input"

                        Case "txt"

                            Dim txt As TextBox = GetTextBox(Value)

                            txt.ID = "txt" & Caption.Replace(" ", String.Empty)

                            IDs.Add(txt.ClientID)

                            txt.TabIndex = IDs.Count

                            txt.RenderControl(HtmlWriter)

                            AfterText = "<input"

                        Case "im"

                            Dim im As InputMask = GetInputMask(IMMask, Value)

                            im.ID = "im" & Caption.Replace(" ", String.Empty)

                            IDs.Add(im.ClientID)

                            im.TabIndex = IDs.Count

                            im.RenderControl(HtmlWriter)

                            AfterText = "<input"

                        Case "ddl"

                            Dim ddl As DropDownList = GetDropDownList(DDLSource, DDLValue, DDLText, Value)

                            ddl.ID = "ddl" & Caption.Replace(" ", String.Empty)

                            IDs.Add(ddl.ClientID)

                            ddl.TabIndex = IDs.Count

                            ddl.RenderControl(HtmlWriter)

                            AfterText = "<select"
                    End Select

                    Dim Control As String = Writer.ToString()

                    Return InsertAttributes(Control, AfterText, Attributes & " caption=""" & Caption & """" _
                        & " required=""" & Required.ToString().ToLower() & """ validate=""" _
                        & Validate & """ fieldtosave=""" & FieldToSave & """ fieldtype=""" & Type & """")

                End Using
            End Using

        Else
            Return Value
        End If

    End Function
    Private Function InsertAttributes(ByVal Control As String, ByVal AfterText As String, ByVal Attributes As String) As String

        If Control.Length >= AfterText.Length Then

            Dim i As Integer = 0
            Dim FoundIt As Boolean = False

            For i = 0 To Control.Length - AfterText.Length
                If Control.Substring(i, AfterText.Length) = AfterText Then
                    FoundIt = True
                    Exit For
                End If
            Next

            'promote i past aftertext length
            i += AfterText.Length

            If FoundIt Then
                Return Control.Substring(0, i + 1) & Attributes & Control.Substring(i)
            Else
                Return Control
            End If

        Else
            Return Control
        End If

    End Function
    Private Function GetCheckBox(ByVal Value As Boolean) As CheckBox

        GetCheckBox = New CheckBox()

        GetCheckBox.CssClass = "srefEntry"
        GetCheckBox.Checked = Value

    End Function
    Private Function GetTextBox(ByVal Value As String) As TextBox

        GetTextBox = New TextBox()

        GetTextBox.CssClass = "srefEntry"
        GetTextBox.Text = Value

    End Function
    Private Function GetDropDownList(ByVal Source As String, ByVal ValueField As String, _
        ByVal TextField As String, ByVal SelectedValue As String) As DropDownList

        GetDropDownList = New DropDownList()

        GetDropDownList.CssClass = "srefEntry"

        LoadDropDownList(GetDropDownList, Source, ValueField, TextField, SelectedValue)

    End Function
    Private Function GetInputMask(ByVal Mask As String, ByVal Value As String) As InputMask

        GetInputMask = New InputMask()

        GetInputMask.CssClass = "srefEntry"
        GetInputMask.Mask = Mask
        GetInputMask.Text = Value

    End Function
    Private Sub LoadDropDownList(ByVal ddl As DropDownList, ByVal Source As String, ByVal ValueField As String, ByVal TextField As String, ByVal SelectedValue As String)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = Source

        ddl.Items.Clear()

        Dim Empty As New ListItem(String.Empty, 0)

        ddl.Items.Add(Empty)

        Empty.Selected = True

        Using cmd
            Using cmd.Connection
                Using rd

                    cmd.Connection.Open()
                    rd = cmd.ExecuteReader()

                    While rd.Read()

                        Dim Value As String = DataHelper.Nz_string(rd.GetValue(rd.GetOrdinal(ValueField)))
                        Dim Text As String = DataHelper.Nz_string(rd.GetValue(rd.GetOrdinal(TextField)))

                        Dim li As New ListItem(Text, Value)

                        ddl.Items.Add(li)

                        If Text = SelectedValue Then
                            ddl.ClearSelection()
                            li.Selected = True
                        End If

                    End While

                End Using
            End Using
        End Using

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
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/settings/references/multi.aspx?id=" & _referenceid)
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        If txtSelected.Value.Length > 0 Then

            Dim Parts() As String = Regex.Split(txtSelected.Value, "<--\$-->")

            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            For Each Part As String In Parts

                Dim Values() As String = Part.Split("|")

                Try

                    Dim FieldName As String = Values(0)
                    Dim FieldType As String = Values(1)
                    Dim FieldValue As String = Values(2)

                    If Not (FieldName = "MatterTypeId" And _referenceid = 25) Then
                        Select Case FieldType.ToLower()
                            Case "bit"

                                If FieldValue.Length > 0 Then
                                    DatabaseHelper.AddParameter(cmd, FieldName, DataHelper.Nz_bool(FieldValue))
                                Else
                                    DatabaseHelper.AddParameter(cmd, FieldName, DBNull.Value, DbType.Boolean)
                                End If

                            Case "int"

                                If FieldValue.Length > 0 Then
                                    DatabaseHelper.AddParameter(cmd, FieldName, DataHelper.Nz_int(FieldValue))
                                Else
                                    DatabaseHelper.AddParameter(cmd, FieldName, DBNull.Value, DbType.Int32)
                                End If

                            Case "datetime"

                                If FieldValue.Length > 0 Then
                                    DatabaseHelper.AddParameter(cmd, FieldName, DataHelper.Nz_date(FieldValue))
                                Else
                                    DatabaseHelper.AddParameter(cmd, FieldName, DBNull.Value, DbType.DateTime)
                                End If

                            Case "varchar"

                                If FieldValue.Length > 0 Then
                                    DatabaseHelper.AddParameter(cmd, FieldName, FieldValue)
                                Else
                                    DatabaseHelper.AddParameter(cmd, FieldName, DBNull.Value, DbType.String)
                                End If

                        End Select
                    End If

                Catch ex As Exception

                End Try

            Next

            If cmd.Parameters.Count > 0 Then

                Dim Table As String = DataHelper.FieldLookup("tblReference", "Table", "ReferenceID = " & _referenceid)
                Dim KeyField As String = DataHelper.FieldLookup("tblReference", "KeyField", "ReferenceID = " & _referenceid)

                If _a = "a" Then 'insert

                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                    DatabaseHelper.BuildInsertCommandText(cmd, Table, KeyField, SqlDbType.Int)
                Else 'update

                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                    DatabaseHelper.BuildUpdateCommandText(cmd, Table, KeyField & " = " & _rid)

                End If

                Using cmd
                    Using cmd.Connection

                        'raise "before" events
                        If _a = "a" Then
                            ReferenceHelper.RaiseEvent("BeforeInsert", Table, 0)
                        Else
                            ReferenceHelper.RaiseEvent("BeforeUpdate", Table, _rid)
                        End If

                        cmd.Connection.Open()
                        cmd.ExecuteNonQuery()

                        If _referenceid = 25 Then
                            For Each Part As String In Parts

                                Dim Values() As String = Part.Split("|")


                                Dim FieldName As String = Values(0)
                                Dim FieldType As String = Values(1)
                                Dim FieldValue As String = Values(2)

                                If FieldName = "MatterTypeId" Then
                                    Dim matterCmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                                    If FieldValue.Length > 0 Then
                                        DatabaseHelper.AddParameter(matterCmd, FieldName, DataHelper.Nz_int(FieldValue))
                                    Else
                                        DatabaseHelper.AddParameter(matterCmd, FieldName, DBNull.Value, DbType.Int32)
                                    End If

                                    DatabaseHelper.AddParameter(matterCmd, "MatterSubStatusId", DataHelper.Nz_int(cmd.Parameters("@" & KeyField).Value))

                                    DatabaseHelper.BuildInsertCommandText(matterCmd, "tblMatterTypeSubStatus")
                                    DatabaseHelper.ExecuteNonQuery(matterCmd)
                                    matterCmd.Dispose()
                                End If
                            Next
                        End If

                        'raise "after" events
                        If _a = "a" Then
                            ReferenceHelper.RaiseEvent("AfterInsert", Table, DataHelper.Nz_int(cmd.Parameters("@" & KeyField).Value))
                        Else
                            ReferenceHelper.RaiseEvent("AfterUpdate", Table, _rid)
                        End If

                    End Using
                End Using
            End If

        End If

        'return to main
        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        Dim Table As String = DataHelper.FieldLookup("tblReference", "Table", "ReferenceID = " & _referenceid)
        Dim KeyField As String = DataHelper.FieldLookup("tblReference", "KeyField", "ReferenceID = " & _referenceid)

        ReferenceHelper.RaiseEvent("BeforeDelete", Table, _rid)

        'delete reference
        DataHelper.Delete(Table, KeyField & " = " & _rid)

        ReferenceHelper.RaiseEvent("AfterDelete", Table, _rid)

        'return to main
        Close()

    End Sub
End Class