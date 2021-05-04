Option Explicit On

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_settings_references_multi
    Inherits System.Web.UI.Page

#Region "Variables"

    Public _referenceid As Integer

    Public _deletetitle As String
    Public _deletetext As String

    Private _iconsrc As String
    Private _iconnewsrc As String

    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            _referenceid = DataHelper.Nz_int(qs("id"))

            SetDisplay()

            If Not IsPostBack Then
                LoadGrid()
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
                            lblTitle2.Text = DatabaseHelper.Peel_string(rd, "TitlePlural")

                            _deletetitle = DatabaseHelper.Peel_string(rd, "TitlePlural")
                            _deletetext = "selection of " & DatabaseHelper.Peel_string(rd, "TitlePlural").ToLower()

                            _iconsrc = ResolveUrl(DatabaseHelper.Peel_string(rd, "IconSrc"))
                            _iconnewsrc = ResolveUrl(DatabaseHelper.Peel_string(rd, "IconNewSrc"))


                            Dim Add As Boolean = DatabaseHelper.Peel_bool(rd, "Add")
                            Dim Edit As Boolean = DatabaseHelper.Peel_bool(rd, "Edit")
                            Dim Delete As Boolean = DatabaseHelper.Peel_bool(rd, "Delete")
                            Dim InfoBoxMessage As String = DatabaseHelper.Peel_string(rd, "InfoBoxMessage")

                            If Add Then
                                If _referenceid = 10 Then
                                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Add();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & _iconsrc & """ align=""absmiddle""/>Add Attorney" & "</a>")
                                Else
                                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Add();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & _iconsrc & """ align=""absmiddle""/>Add " & DatabaseHelper.Peel_string(rd, "LastWord").ToLower() & "</a>")
                                End If
                            End If

                            If Delete Then
                                pnlDelete.Style("display") = "inline"
                            Else
                                pnlDelete.Style("display") = "none"
                            End If

                            Dim NumFlags As Integer = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
                                "UserID = " & UserID & " AND InfoBoxID = " & 2)

                            lblInfoBox.Text = InfoBoxMessage
                            trInfoBox.Visible = (InfoBoxMessage.Length > 0 And NumFlags = 0)

                        End If

                    End Using
                End Using
            End Using

        Else
            Response.Redirect("~/admin/settings/references")
        End If

    End Sub
    Private Sub LoadGrid()

        'get field info
        Dim Fields As List(Of ReferenceField) = ReferenceFieldHelper.GetFieldsForReference(_referenceid, "MultiOrder")

        Dim Table As String = DataHelper.FieldLookup("tblReference", "Table", "ReferenceID = " & _referenceid)
        Dim KeyField As String = DataHelper.FieldLookup("tblReference", "KeyField", "ReferenceID = " & _referenceid)

        'render table
        Dim Output As New StringBuilder()

        Output.Append("<table class=""trefTable"" onmouseover=""RowHover(this,true)"" onmouseout=""RowHover(this,false)"" cellpadding=""0"" cellspacing=""0"" border=""0"">")

        'render header
        Output.Append(" <tr>")
        Output.Append("     <td align=""center"" style=""width:20;"" class=""trefHeaderCell""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);"" style=""cursor:pointer;"" title=""Check All"" src=""" & ResolveUrl("~/images/11x11_checkall.png") & """ border=""0"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);"" style=""cursor:pointer;display:none;"" title=""Uncheck All"" src=""" & ResolveUrl("~/images/11x11_uncheckall.png") & """ border=""0"" /></td>")
        Output.Append("     <td class=""trefHeaderCell"" style=""width:22;"" align=""center""><img src=""" & ResolveUrl("~/images/16x16_icon.png") & """ border=""0"" align=""absmiddle""/></td>")

        For i As Integer = 0 To Fields.Count - 1

            Dim Field As ReferenceField = Fields(i)

            If Field.Multi Then

                Dim Caption As String = IIf(Field.Caption.Length > 0, Field.Caption, Field.Field)

                Dim Align As String = IIf(Field.Align.Length > 0, " align=""" & Field.Align & """", String.Empty)
                Dim Width As String = IIf(Field.Width.Length > 0, " style=""width:" & Field.Width & ";""", String.Empty)

                Dim Style As String = "trefHeaderCell"

                If i > 0 AndAlso Fields(i - 1).Align.ToLower() = "right" Then
                    Style = "trefHeaderCellRightOfLeft"
                End If

                Output.Append("<td class=""" & Style & """" & Align & Width & ">" & Caption & "</td>")

            End If

        Next

        Output.Append(" </tr>")

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = ReferenceHelper.GetCommandText(Table, Fields)

        Using cmd
            Using cmd.Connection
                Using rd

                    cmd.Connection.Open()
                    rd = cmd.ExecuteReader()

                    Dim c As Integer = 0

                    While rd.Read()

                        Dim KeyValue As Integer = DatabaseHelper.Peel_int(rd, KeyField)

                        'Dim OnMouseUp As String = " onmouseup=""RowClick(" & KeyValue & ");"" "
                        'Dim OnMouseOut As String = " onmouseout=""RowHover(this, false);"" "
                        'Dim OnMouseOver As String = " onmouseover=""RowHover(this, true);"" "

                        'render rows
                        Output.Append("<a href=""javascript:RowClick(" & KeyValue & ")"">")
                        Output.Append("<tr>")
                        Output.Append(" <td style=""width:20;"" class=""trefBodyCell"" align=""center""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;window.event.cancelBubble=true;return false;"" src=""" & ResolveUrl("~/images/13x13_check_cold.png") & """ border=""0"" align=""absmiddle"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;window.event.cancelBubble=true;return false;"" style=""display:none;"" src=""" & ResolveUrl("~/images/13x13_check_hot.png") & """ border=""0"" align=""absmiddle"" /><input onpropertychange=""AddOrDrop(this, " & KeyValue & ");"" style=""display:none;"" type=""checkbox"" /></td>")
                        Output.Append(" <td style=""width:22;"" class=""trefBodyCell"" align=""center""><img src=""" & _iconsrc & """ border=""0""/></td>")

                        For i As Integer = 0 To Fields.Count - 1

                            Dim Field As ReferenceField = Fields(i)

                            Dim Value As String = GetValue(rd, Field.Field, Field.Type, Field.MultiFormat)

                            If Field.Multi Then 'can add to grid

                                Dim Align As String = IIf(Field.Align.Length > 0, " align=""" & Field.Align & """", String.Empty)

                                Dim Style As String = "trefBodyCell"

                                If i > 0 AndAlso Fields(i - 1).Align.ToLower() = "right" Then
                                    Style = "trefBodyCellRightOfLeft"
                                End If

                                Output.Append("<td class=""" & Style & """" & Align & ">" & Value & "</td>")

                            End If

                        Next

                        Output.Append("</tr>")
                        Output.Append("</a>")
                        c += 1

                    End While

                    If c = 0 Then

                        lblNoRecords.Visible = True
                        lblNoRecords.Text = "There are no " & _deletetitle.ToLower() & " in the database."

                    Else
                        lblNoRecords.Visible = False
                    End If

                End Using
            End Using
        End Using

        Output.Append("</table>")

        ltrGrid.Text = Output.ToString()

    End Sub
    Private Function GetValue(ByVal rd As IDataReader, ByVal FieldName As String, ByVal Type As String, _
        ByVal Format As String) As String

        GetValue = String.Empty

        Select Case Type.ToLower()
            Case "bit"

                If DatabaseHelper.Peel_bool(rd, FieldName) Then
                    GetValue = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0""/>"
                Else
                    GetValue = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_empty.png") & """ border=""0""/>"
                End If

            Case "int"
                GetValue = DatabaseHelper.Peel_int(rd, FieldName).ToString(Format)
            Case "varchar"
                GetValue = DatabaseHelper.Peel_string(rd, FieldName)
            Case "datetime"
                GetValue = DatabaseHelper.Peel_date(rd, FieldName).ToString(Format)
            Case "money"
                GetValue = DatabaseHelper.Peel_double(rd, FieldName).ToString(Format)
        End Select

        If GetValue.Length = 0 Then
            GetValue = "&nbsp;"
        End If

    End Function
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""admin_settings_properties_property""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelected.Value.Length > 0 Then

            Dim Table As String = DataHelper.FieldLookup("tblReference", "Table", "ReferenceID = " & _referenceid)
            Dim KeyField As String = DataHelper.FieldLookup("tblReference", "KeyField", "ReferenceID = " & _referenceid)

            'get selected "," delimited ID's
            Dim Values() As String = txtSelected.Value.Split(",")

            For Each Value As String In Values

                Dim ID As Integer = Integer.Parse(Value)

                ReferenceHelper.RaiseEvent("BeforeDelete", Table, ID)

                If StringHelper.Validate(StringHelper.ValidationType.NumberInteger, Value) Then
                    DataHelper.Delete(Table, KeyField & " = " & ID)
                End If

                ReferenceHelper.RaiseEvent("AfterDelete", Table, ID)

            Next

            'reload same page (of refereces)
            Response.Redirect(Request.Url.AbsoluteUri)

        End If

    End Sub
    Protected Sub lnkCloseInformation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformation.Click

        'insert flag record
        UserInfoBoxHelper.Insert(2, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
End Class