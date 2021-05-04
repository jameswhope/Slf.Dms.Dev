
Partial Class util_pop_addattorney
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.ddlAttorney.Attributes.Add("onChange", "javascript:OnChangeAttorney();")
            LoadAttorneys()
        End If
    End Sub

    Private Sub LoadAttorneys()
        Dim objAttorney As New Lexxiom.BusinessServices.Attorney
        Dim tblAttorneys As Data.DataTable = objAttorney.GetAttorneyListing(-1)
        Dim row As Data.DataRow

        row = tblAttorneys.NewRow
        row("FullName") = "Existing attorneys.."
        row("AttorneyID") = -1
        tblAttorneys.Rows.InsertAt(row, 0)

        ddlAttorney.DataSource = tblAttorneys
        ddlAttorney.DataTextField = "FullName"
        ddlAttorney.DataValueField = "AttorneyID"
        ddlAttorney.DataBind()

        objAttorney = Nothing
    End Sub

    Protected Sub lnkAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdd.Click
        Dim objAttorney As New Lexxiom.BusinessServices.Attorney
        Dim dsAttorneyDetail As Data.DataSet
        Dim rows() As Data.DataRow
        Dim id As Integer = -1
        Dim first As String = ""
        Dim mi As String = ""
        Dim last As String = ""
        Dim state As String = ""
        Dim bar As String = ""
        Dim ary() As String

        If rdoExisting.Checked Then
            id = CType(ddlAttorney.SelectedItem.Value, Integer)
            dsAttorneyDetail = objAttorney.AttorneyDetail(id)
            If dsAttorneyDetail.Tables(0).Rows.Count = 1 Then
                first = dsAttorneyDetail.Tables(0).Rows(0)("FirstName").ToString
                mi = dsAttorneyDetail.Tables(0).Rows(0)("MiddleName").ToString
                last = dsAttorneyDetail.Tables(0).Rows(0)("LastName").ToString
                bar = ddlStateBar.SelectedItem.Value
                If ddlStateBar.Items.Count > 1 Then
                    ary = ddlStateBar.SelectedItem.Text.Split(" - ")
                    state = ary(0)
                End If
            End If
        End If

        objAttorney = Nothing
        ScriptManager.RegisterStartupScript(Me, Me.GetType, "Add_EAttorney", "window.opener.AddEAttorney(" & id.ToString & ",'" & first & "','" & mi & "','" & last & "','" & state & "','" & bar & "'); window.close();", True)
    End Sub

    Protected Sub ddlAttorney_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAttorney.SelectedIndexChanged
        Dim objAttorney As New Lexxiom.BusinessServices.Attorney
        Dim dsAttorneyDetail As Data.DataSet
        Dim rows() As Data.DataRow
        Dim row As Data.DataRow
        Dim intAttorneyID As Integer
        Dim tblStateBars As New Data.DataTable
        Dim i As Integer

        tblStateBars.Columns.Add("State")
        tblStateBars.Columns.Add("StateBarNum")
        tblStateBars.AcceptChanges()

        intAttorneyID = CType(ddlAttorney.SelectedItem.Value, Integer)
        dsAttorneyDetail = objAttorney.AttorneyDetail(intAttorneyID)
        rows = dsAttorneyDetail.Tables(1).Select("IsRelated = 'true'")

        For i = 0 To rows.Length - 1
            row = tblStateBars.NewRow
            row("State") = rows(i)("State").ToString & " - " & rows(i)("StateBarNum").ToString
            row("StateBarNum") = rows(i)("StateBarNum")
            tblStateBars.Rows.Add(row)
        Next

        row = tblStateBars.NewRow
        row("State") = "Add New State Bar Information"
        row("StateBarNum") = ""
        tblStateBars.Rows.Add(row)

        ddlStateBar.DataSource = tblStateBars
        ddlStateBar.DataTextField = "State"
        ddlStateBar.DataValueField = "StateBarNum"
        ddlStateBar.DataBind()
        ddlStateBar.Visible = True

        lblStateBarsFor.Text = "State Bars for " & ddlAttorney.SelectedItem.Text

        objAttorney = Nothing
    End Sub
End Class
