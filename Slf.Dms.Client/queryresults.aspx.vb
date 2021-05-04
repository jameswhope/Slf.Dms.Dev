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

Partial Class queryresults
    Inherits System.Web.UI.Page

    Private Const PageSize As Integer = 40

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Requery()

    End Sub

    Private Sub Requery()
        Dim sb As New StringBuilder()
        Dim sbXls As New StringBuilder()

        Dim cmd As IDbCommand = CommandHelper.DeepClone(CType(Session("queryresults_" & Request.QueryString("queryid")), IDbCommand))
        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable()

        da.Fill(dt)

        Dim PageIndex As Integer = DataHelper.Nz_int(Setting("p"))
        DisableBackSelectors(True)
        DisableForwardSelectors(True)
        Dim searchCount As Integer = dt.Rows.Count

        If PageIndex * PageSize >= searchCount Then
            PageIndex = -1
        End If

        If PageIndex = -1 Then
            PageIndex = searchCount \ PageSize
            Setting("p") = PageIndex
        End If

        If PageIndex = 0 Then
            DisableBackSelectors(False)
        End If

        If PageIndex = searchCount \ PageSize Then
            DisableForwardSelectors(False)
        End If

        txtPageNumber.Text = PageIndex + 1
        lblPageCount.Text = ((searchCount \ PageSize) + 1).ToString()

        If lblPageCount.Text = 0 Then

            lblPageCount.Text = 1

            DisableBackSelectors(False)
            DisableForwardSelectors(False)

        End If

        sbXls.Append("<table><tr>")
        Dim sbHeaders As New StringBuilder
        For i As Integer = 2 To dt.Columns.Count - 1
            sbXls.Append("<td>")
            sbHeaders.Append("<th align=""left"">")
            sbXls.Append(dt.Columns(i).ColumnName)
            sbHeaders.Append(dt.Columns(i).ColumnName)
            sbXls.Append("</td>")
            sbHeaders.Append("</th>")
        Next
        ltrHeaders.Text = sbHeaders.ToString

        If searchCount > 0 Then
            Dim i1 As Integer = Math.Min(PageIndex * PageSize, searchCount - 1)
            Dim i2 As Integer = Math.Min(i1 + PageSize - 1, searchCount - 1)
            For y As Integer = i1 To i2
                Dim r As DataRow = dt.Rows(y)
                Dim type As String = r("type")
                Dim typeid As Integer = r("typeid")

                Dim url As String = ""
                Select Case type
                    Case "client"
                        url = ResolveUrl("~/clients/client/?id=" & typeid)
                    Case "register"
                        Dim clientid As Integer = DataHelper.FieldLookup("tblregister", "clientid", "registerid=" & typeid)
                        url = ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & clientid & "&rid=" & typeid)
                End Select

                sb.Append("<a href=""#"" onclick=""javascript:RowOpen('" & url & "')""<tr>")
                For i As Integer = 2 To dt.Columns.Count - 1

                    sb.Append("<td>")
                    Dim o As Object = r(i)
                    sb.Append(o.ToString())
                    sb.Append("&nbsp;</td>")
                Next
                sb.Append("</tr></a>")
            Next


            sbXls.Append("</tr>")
            For y As Integer = 0 To dt.Rows.Count - 1
                Dim r As DataRow = dt.Rows(y)
                sbXls.Append("<tr>")
                For i As Integer = 2 To dt.Columns.Count - 1
                    sbXls.Append("<td>")
                    Dim o As Object = r(i)
                    sbXls.Append(o.ToString())
                    sbXls.Append("</td>")
                Next
                sbXls.Append("</tr>")
            Next
            sbXls.Append("</table>")


            ltrGrid.Text = sb.ToString
            Session("xls_" & Me.GetType.Name) = sbXls.ToString()

        Else

            Session("xls_" & Me.GetType.Name) = "<table><tr><td></td></tr></table>"

            txtPageNumber.Text = 0
            lblPageCount.Text = 0

            DisableBackSelectors(False)
            DisableForwardSelectors(False)

            txtPageNumber.Enabled = False

        End If

    End Sub

    Private Sub DisableBackSelectors(ByVal bOn As Boolean)

        lnkFirst.Enabled = bOn
        lnkPrevious.Enabled = bOn

        If bOn Then
            imgFirst.Src = ResolveUrl("~/images/16x16_selector_first.png")
            imgPrevious.Src = ResolveUrl("~/images/16x16_selector_prev.png")
        Else
            imgFirst.Src = ResolveUrl("~/images/16x16_selector_first_gray.png")
            imgPrevious.Src = ResolveUrl("~/images/16x16_selector_prev_gray.png")
        End If

    End Sub
    Private Sub DisableForwardSelectors(ByVal bOn As Boolean)

        lnkLast.Enabled = bOn
        lnkNext.Enabled = bOn
        If bOn Then
            imgLast.Src = ResolveUrl("~/images/16x16_selector_last.png")
            imgNext.Src = ResolveUrl("~/images/16x16_selector_next.png")
        Else
            imgLast.Src = ResolveUrl("~/images/16x16_selector_last_gray.png")
            imgNext.Src = ResolveUrl("~/images/16x16_selector_next_gray.png")
        End If

    End Sub
  
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub

    Protected Sub lnkFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirst.Click
        Setting("p") = 0
    End Sub
    Protected Sub lnkLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLast.Click
        Setting("p") = -1
    End Sub
    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNext.Click
        Setting("p") = DataHelper.Nz_int(Setting("p")) + 1
    End Sub
    Protected Sub lnkPrevious_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevious.Click
        Setting("p") = DataHelper.Nz_int(Setting("p")) - 1
    End Sub
    Protected Sub txtPageNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPageNumber.TextChanged
        Setting("p") = DataHelper.Nz_int(txtPageNumber.Text)
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Requery()

    End Sub
End Class
