Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Partial Class Clients_Enrollment_Goals
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            hdnCurMonth.Value = DatePart(DateInterval.Month, Today) & "/1/" & DatePart(DateInterval.Year, Today)
            LoadGoals()
        End If
    End Sub

    Private Sub LoadGoals()
        Dim tbl As DataTable
        Dim params As New List(Of SqlParameter)
        Dim row As DataRow
        Dim day As DateTime
        Dim cur As Integer
        Dim dayIndex As Integer = 0
        Dim bNewMonth As Boolean

        'first day of month
        day = CDate(hdnCurMonth.Value)
        hMonth.InnerHtml = Format(day, "MMMM yyyy")

        params.Add(New SqlParameter("@startdate", day))
        tbl = SqlHelper.GetDataTable("stp_GetGoals", CommandType.StoredProcedure, params.ToArray)
        bNewMonth = (tbl.Rows.Count = 0)

        tbl.Columns.Add("bgcolor", GetType(System.String))
        tbl.AcceptChanges()

        'days from last month
        While day.DayOfWeek > dayIndex
            row = tbl.NewRow
            row("day") = ""
            row("date") = "1/1/1900"
            row("goal") = "0"
            row("bgcolor") = "#FFFFFF"
            tbl.Rows.InsertAt(row, 0)
            dayIndex += 1
        End While

        If bNewMonth Then
            cur = DatePart(DateInterval.Month, day)
            While DatePart(DateInterval.Month, day) = cur
                row = tbl.NewRow
                row("day") = DatePart(DateInterval.Day, day)
                row("date") = day
                row("goal") = "0"
                row("submitted") = "0"
                row("diff") = "0"
                If day = Today Then
                    row("bgcolor") = "#E2F4FF"
                ElseIf day.DayOfWeek = DayOfWeek.Saturday Or day.DayOfWeek = DayOfWeek.Sunday Then
                    row("bgcolor") = "#FFF4BC"
                Else
                    row("bgcolor") = "#FFFFD5"
                End If
                tbl.Rows.Add(row)
                day = DateAdd(DateInterval.Day, 1, day)
            End While
        Else
            For Each r As DataRow In tbl.Rows
                day = CDate(r("date"))
                If day > CDate("1/1/1900") Then
                    If day = Today Then
                        r("bgcolor") = "#E2F4FF"
                    ElseIf CInt(r("diff")) >= 0 AndAlso day < Today AndAlso CInt(r("goal")) > 0 Then
                        r("bgcolor") = "#A0FF96"
                    ElseIf CInt(r("diff")) < 0 AndAlso day < Today AndAlso CInt(r("goal")) > 0 Then
                        r("bgcolor") = "#FF6866"
                    ElseIf day.DayOfWeek = DayOfWeek.Saturday Or day.DayOfWeek = DayOfWeek.Sunday Then
                        r("bgcolor") = "#FFF4BC"
                    Else
                        r("bgcolor") = "#FFFFD5"
                    End If
                End If
            Next
        End If

        DataList1.DataSource = tbl
        DataList1.DataBind()

        'reset buttons
        btnSave.Visible = False
        btnCancel.Visible = False

        If PermissionHelperLite.HasPermission(CInt(Page.User.Identity.Name), "Client Intake-Edit Goals") Then
            btnEdit.Visible = True
            If bNewMonth Then
                btnEdit_Click(Nothing, Nothing)
            End If
        End If
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Dim hdn As HiddenField
        Dim txt As TextBox
        Dim lbl As Label

        For Each item As DataListItem In DataList1.Items
            hdn = TryCast(item.FindControl("hdnDate"), HiddenField)
            txt = TryCast(item.FindControl("txtGoal"), TextBox)
            lbl = TryCast(item.FindControl("lblGoal"), Label)

            If CDate(hdn.Value) > CDate("1/1/1900") Then
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("@date", hdn.Value))
                params.Add(New SqlParameter("@goal", CInt(Val(txt.Text))))
                params.Add(New SqlParameter("@userid", Page.User.Identity.Name))
                SqlHelper.ExecuteNonQuery("stp_SaveGoal", , params.ToArray)
            End If
        Next

        LoadGoals()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        LoadGoals()
    End Sub

    Protected Sub btnEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEdit.Click
        Dim hdn As HiddenField
        Dim txt As TextBox
        Dim lbl As Label

        For Each item As DataListItem In DataList1.Items
            hdn = TryCast(item.FindControl("hdnDate"), HiddenField)
            txt = TryCast(item.FindControl("txtGoal"), TextBox)
            lbl = TryCast(item.FindControl("lblGoal"), Label)
            If IsDate(hdn.Value) Then
                txt.Visible = True
                lbl.Visible = False
            End If
        Next

        btnEdit.Visible = False
        btnSave.Visible = True
        btnCancel.Visible = True
    End Sub

    Protected Sub DataList1_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles DataList1.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim hdn As HiddenField = TryCast(e.Item.FindControl("hdnDate"), HiddenField)
            Dim tbl As HtmlTable = TryCast(e.Item.FindControl("tblGoal"), HtmlTable)
            Dim lbl As Label = TryCast(e.Item.FindControl("lblDiff"), Label)
            tbl.Visible = (CDate(hdn.Value) > CDate("1/1/1900"))
        End If
    End Sub

    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        Dim cur As Date = CDate(hdnCurMonth.Value)
        hdnCurMonth.Value = DateAdd(DateInterval.Month, 1, cur)
        LoadGoals()
    End Sub

    Protected Sub btnPrev_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPrev.Click
        Dim cur As Date = CDate(hdnCurMonth.Value)
        hdnCurMonth.Value = DateAdd(DateInterval.Month, -1, cur)
        LoadGoals()
    End Sub
End Class
