Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper



Partial Class research_reports_financial_commission_batchpaymentsagency
    Inherits PermissionPage

    Public Structure BatchEntry
        Public CommBatchId As Integer
        Public BatchDate As Date
        Public Amount As Single
    End Structure

#Region "Variables"

    Private UserID As Integer
    Private qs As QueryStringCollection
    Private UserTypeID As Integer
    Public CommRecID As String

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        If Not IsPostBack Then
            ddlCompany.Visible = False

            Dim cmpName As String
            Dim userPerm As Integer = UserID

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT isnull(UserGroupID, 3) FROM tblUser WHERE UserID = " + UserID.ToString()
                    cmd.Connection.Open()

                    Dim permission As Integer = cmd.ExecuteScalar()

                    Select Case permission
                        Case 6, 11
                            Dim rec As Integer
                            Dim abbr As String
                            Dim da As SqlClient.SqlDataAdapter
                            Dim ds As New DataSet
                            Dim CompanyIDs As String

                            cmd.CommandText = "SELECT CommRecID, Abbreviation FROM tblCommRec WHERE CompanyID is null ORDER BY Abbreviation"
                            Using recRead As IDataReader = cmd.ExecuteReader()
                                While recRead.Read()
                                    rec = DatabaseHelper.Peel_int(recRead, "CommRecID")
                                    abbr = DatabaseHelper.Peel_string(recRead, "Abbreviation")
                                    ddlCommRec.Items.Add(New ListItem(abbr, rec, True))
                                End While
                            End Using

                            CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

                            cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

                            If Len(CompanyIDs) > 0 Then
                                cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
                            End If

                            cmd.CommandText &= " ORDER BY ShortCoName"

                            da = New SqlClient.SqlDataAdapter(cmd)
                            da.Fill(ds)

                            ddlCompany.DataSource = ds.Tables(0)
                            ddlCompany.DataTextField = "ShortCoName"
                            ddlCompany.DataValueField = "CompanyID"
                            ddlCompany.DataBind()

                            ddlCommRec.Visible = True
                        Case 20
                            userPerm = -2
                            ddlCommRec.Items.Clear()

                            Dim rec As Integer
                            Dim abbr As String
                            Dim allrecs As String
                            Dim sCommRecID As String = DataHelper.FieldLookup("tblUser", "CommrecID", "Userid = " & UserID)
                            Dim sCompany As String = DataHelper.FieldLookup("tblCommRec", "CompanyID", "Commrecid = " & sCommRecID)

                            cmd.CommandText = "SELECT CommRecID, Abbreviation FROM tblCommRec WHERE CompanyID = " & sCompany
                            Using recRead As IDataReader = cmd.ExecuteReader()
                                While recRead.Read()
                                    rec = DatabaseHelper.Peel_int(recRead, "CommRecID")
                                    abbr = DatabaseHelper.Peel_string(recRead, "Abbreviation")
                                    ddlCommRec.Items.Add(New ListItem(abbr, rec, True))
                                    allrecs += "," + rec.ToString()
                                End While
                            End Using

                            ddlCommRec.Items.Add(New ListItem("ALL", allrecs.Substring(1), True))
                            ddlCommRec.Visible = True

                            ddlCompany.Items.Clear()

                            cmd.CommandText = "SELECT isnull(CompanyIDs, 0) FROM tblUserCompany WHERE UserID = " + UserID.ToString()
                            Dim companies() As String = cmd.ExecuteScalar().ToString().Split(",")
                            For Each cmp As Integer In companies
                                cmd.CommandText = "SELECT lower(ShortCoName) FROM tblCompany WHERE CompanyID = " + cmp.ToString()
                                cmpName = cmd.ExecuteScalar()
                                ddlCompany.Items.Add(New ListItem(StrConv(cmpName, VbStrConv.ProperCase), cmpName, True))
                            Next
                        Case Else
                            userPerm = UserID
                            ddlCommRec.Visible = False
                    End Select
                End Using
            End Using

            ddlCompany.Visible = True
        End If

        If UserTypeID = 2 Then
            CommRecID = CStr(DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID)))
        End If

        qs = LoadQueryString()

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
        Dim batches As New Dictionary(Of Integer, BatchEntry)
        Dim CommBatchId As Integer
        Dim SumAmount As Single

        If Not UserTypeID = 2 Then
            CommRecID = ddlCommRec.SelectedItem.Value
        End If

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetAgencyBatches")
            Using cmd.Connection
                If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
                If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))

                DatabaseHelper.AddParameter(cmd, "CommRecIds", CommRecID)
                DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedItem.Value)

                cmd.Connection.Open()

                Using rd As SqlClient.SqlDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        Dim b As New BatchEntry
                        CommBatchId = DatabaseHelper.Peel_int(rd, "CommBatchId")
                        b.CommBatchId = CommBatchId
                        b.BatchDate = DatabaseHelper.Peel_date(rd, "BatchDate")
                        b.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        SumAmount += b.Amount

                        batches.Add(CommBatchId, b)
                    End While
                End Using

                Dim newBatches As New List(Of BatchEntry)

                For Each batch As BatchEntry In batches.Values
                    newBatches.Add(batch)
                Next


                tdTotal.InnerHtml = "Total: " & SumAmount.ToString("c")
                rpBatches.DataSource = newBatches
                rpBatches.DataBind()

                'Session("xls_batchdetail_list_batch") = newBatches

                rpBatches.Visible = newBatches.Count > 0
                tdTotal.Visible = newBatches.Count > 0
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
        AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Batch Payments-Agency")
    End Sub
    Protected Function GetBatchNumber(ByVal CommBatchId As Integer) As String
        Dim length As Integer = CType(Session("MaxBatchId"), Integer).ToString.Length
        Dim id As String = CommBatchId.ToString
        Return id.PadLeft(length, "0"c)
    End Function


End Class
