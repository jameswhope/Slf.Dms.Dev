Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient

Partial Class util_pop_findcreditorgroup
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadStates()
            LoadRecord()
            txtCreditor.Focus()
            Page.Form.DefaultButton = btnSearch.ClientID
        End If
    End Sub

    Private Sub LoadRecord()
        Dim qs As QueryStringCollection = LoadQueryString()
        Dim intStateID As Integer

        If Not qs Is Nothing Then
            txtCreditor.Text = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("creditor")).Trim)).Trim
            txtStreet.Text = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("street")).Trim))
            txtStreet2.Text = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("street2")).Trim))
            txtCity.Text = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("city")).Trim))
            txtZipCode.Text = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("zipcode")).Trim))
            intStateID = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_int(DataHelper.Nz_string(qs("stateid")).Trim)))
            ListHelper.SetSelected(cboStateID, intStateID)
            If txtCreditor.Text <> "" Then
                Requery()
            End If
        End If
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

    Private Sub LoadStates()
        Dim obj As New DataHelperBase
        Dim tbl As DataTable = obj.GetStates()
        Dim row As DataRow

        row = tbl.NewRow
        row("Abbreviation") = ""
        row("StateID") = "-1"
        tbl.Rows.InsertAt(row, 0)

        cboStateID.DataSource = tbl
        cboStateID.DataTextField = "Abbreviation"
        cboStateID.DataValueField = "StateID"
        cboStateID.DataBind()
    End Sub

    Private Sub Requery()
        Dim dsCreditors As New DataSet
        Dim dv As DataView
        Dim intNoCreditors As Integer

        If txtCreditor.Text.Trim.Length > 0 Then
            dsCreditors = CreditorGroupHelper.GetCreditorGroups(txtCreditor.Text, txtStreet.Text, txtStreet2.Text, txtCity.Text, cboStateID.SelectedItem.Value)
            dv = dsCreditors.Tables(0).DefaultView
            Accordion1.DataSource = dv
            Accordion1.DataBind()

            For Each row As DataRow In dsCreditors.Tables(0).Rows
                intNoCreditors += CInt(row("NoCreditors"))
            Next
            lblNoCreditors.Text = intNoCreditors & " creditor" & IIf(intNoCreditors = 1, "", "s") & " found."

            If dsCreditors.Tables(0).Rows.Count > 1 And intNoCreditors > 1 Then
                Accordion1.SelectedIndex = -1
            Else
                Accordion1.SelectedIndex = 0
            End If

            lnkAddCreditorGroup.Visible = True
        End If
    End Sub

    Protected Sub gvCreditors_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rv As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim validated As String

                If Not rv.Row.Item(7) Is DBNull.Value Then
                    If rv.Row.Item(7).ToString.ToLower = "true" Then
                        validated = "1"
                        e.Row.Style("background-color") = "#D2FFD2"
                        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#C9EFC9';")
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#D2FFD2';")
                    Else 'pending validation
                        validated = "0"
                        e.Row.Style("background-color") = "#FFDB72"
                        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#FFCE49';")
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#FFDB72';")
                    End If
                Else 'old creditor, no validation required
                    validated = "-1"
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If

                e.Row.Style("cursor") = "hand"

                If Val(rv.Row.Item(1)) > 0 Then
                    e.Row.Attributes.Add("onclick", "selectCreditor(" & rv.Row.Item(0).ToString & "," & rv.Row.Item(1).ToString & ",""" & rv.Row.Item(9).ToString.Replace("""", "'") & """,""" & rv.Row.Item(2).ToString.Replace("""", "'") & """,""" & rv.Row.Item(3).ToString.Replace("""", "'") & """,""" & rv.Row.Item(4).ToString.Replace("""", "'") & """," & rv.Row.Item(10).ToString & ",""" & rv.Row.Item(5).ToString.Replace("""", "'") & """," & validated & ");")
                Else 'add new address to creditor group
                    e.Row.Attributes.Add("onclick", "addCreditor(" & rv.Row.Item(0).ToString & "," & rv.Row.Item(1).ToString & ",""" & rv.Row.Item(9).ToString & """,2);")
                End If
        End Select
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        txtCity.Text = ""
        txtStreet.Text = ""
        txtStreet2.Text = ""
        txtZipCode.Text = ""
        cboStateID.ClearSelection()
        txtStreet.Focus()
        Requery()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSearch.Click
        Requery()
    End Sub
End Class
