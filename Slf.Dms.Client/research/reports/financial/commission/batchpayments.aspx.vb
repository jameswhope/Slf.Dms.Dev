Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_financial_commission_batchpayments
    Inherits PermissionPage

    Structure BatchInformation
        Public CommBatchIDs As String
        Public CommRecID As Integer
        Public AgencyName As String
        Public Amount As Single
    End Structure

    Private UserID As Integer
    Private qs As QueryStringCollection

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not IsPostBack Then
            Dim da As SqlDataAdapter
            Dim ds As New DataSet
            Dim CompanyIDs As String

            Using cmd As SqlCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                    cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

                    If Len(CompanyIDs) > 0 Then
                        cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
                    End If

                    cmd.CommandText &= " ORDER BY ShortCoName"

                    da = New SqlDataAdapter(cmd)
                    da.Fill(ds)

                    ddlCompany.DataSource = ds.Tables(0)
                    ddlCompany.DataTextField = "ShortCoName"
                    ddlCompany.DataValueField = "CompanyID"
                    ddlCompany.DataBind()
                End Using
            End Using
        End If

        If Not qs Is Nothing Then
            If Not IsPostBack Then
                LoadValues(GetControls(), Me)
                LoadQuickPickDates()
                Requery()
                SetAttributes()
            End If
        End If

    End Sub

    Private Sub SetAttributes()
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
    End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If

    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)

        Return c

    End Function

    Private Sub Requery()
        Dim batches As New Dictionary(Of Integer, BatchInformation)
        Dim CommRecID As Integer
        Dim CommBatchID As String
        Dim Amount As Single
        Dim tempBatch As BatchInformation
        Dim totalCommission As Single = 0

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatches")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
                DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))
                DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedItem.Value)

                cmd.Connection.Open()

                Using rd As SqlDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        tempBatch = New BatchInformation
                        CommBatchID = CStr(DatabaseHelper.Peel_int(rd, "CommBatchID"))
                        tempBatch.AgencyName = DatabaseHelper.Peel_string(rd, "AgencyName")
                        CommRecID = DatabaseHelper.Peel_int(rd, "CommRecID")
                        tempBatch.CommRecID = CommRecID
                        Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        tempBatch.CommBatchIDs = CommBatchID
                        tempBatch.Amount = Amount

                        totalCommission += Amount

                        If batches.ContainsKey(CommRecID) Then
                            tempBatch = batches(CommRecID)
                            tempBatch.CommBatchIDs += "," + CommBatchID
                            tempBatch.Amount += Amount
                            batches.Remove(CommRecID)
                        End If

                        batches.Add(CommRecID, tempBatch)
                    End While
                End Using

                Dim newBatches As New List(Of BatchInformation)

                For Each batch As BatchInformation In batches.Values
                    newBatches.Add(batch)
                Next

                tdTotal.InnerHtml = "Total Commission: " & totalCommission.ToString("c")
                rpBatches.DataSource = newBatches
                rpBatches.DataBind()

                rpBatches.Visible = newBatches.Count > 0
                pnlNone.Visible = newBatches.Count = 0
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
    Private Sub Save()

        'blow away current stuff first
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If


        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlQuickPickDate.ID, "index", _
            ddlQuickPickDate.SelectedIndex)

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Requery()
        Save()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Batch Payments")
    End Sub
    Protected Function GetBatchNumber(ByVal CommBatchId As Integer) As String
        Dim length As Integer = CType(Session("MaxBatchId"), Integer).ToString.Length
        Dim id As String = CommBatchId.ToString
        Return id.PadLeft(length, "0"c)
    End Function


End Class
