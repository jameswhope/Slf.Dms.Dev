Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Imports System.Web.Configuration
Imports System.Configuration

Imports System.Data.SqlClient

Partial Class _Agent_Default
    Inherits System.Web.UI.Page

    Public Structure BatchEntry
        Public CommBatchId As Integer
        Public BatchDate As Date
        Public Amount As Single
    End Structure

    Structure CommissionBatchEntry
        Public ClientID As Integer
        Public Name As String
        Public Amount As Single
    End Structure

    Structure CommissionPersonEntry
        Public EntryType As String
        Public Percent As String
        Public Amount As Single
    End Structure

    Public UserID As Integer
    Public UserTypeID As Integer
    Public CommRecID As Integer
    Public connString As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim config As Configuration = WebConfigurationManager.OpenWebConfiguration(ResolveUrl("~"))
        connString = config.AppSettings.Settings("connectionstring").Value.ToString()

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" + UserID.ToString()))

        If UserTypeID = 2 Then
            CommRecID = Integer.Parse(DataHelper.FieldLookup("tblUser", "CommRecID", "UserId=" + UserID.ToString()))
        Else
            CommRecID = -1
        End If

        If Not IsPostBack Then
            ddlCompany.Visible = False

            Dim cmpName As String
            Dim userPerm As Integer = UserID

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT isnull(UserGroupID, 3) FROM tblUser WHERE UserID = " + UserID.ToString()
                    cmd.Connection.Open()
                    Dim permission As Integer = cmd.ExecuteScalar()
                    If permission = 6 Or permission = 11 Or permission = 20 Then
                        userPerm = -2
                        ddlCommRec.Items.Clear()

                        Dim rec As Integer
                        Dim abbr As String

                        cmd.CommandText = "SELECT CommRecID, Abbreviation FROM tblCommRec WHERE CompanyID is null"
                        Using recRead As IDataReader = cmd.ExecuteReader()
                            While recRead.Read()
                                rec = DatabaseHelper.Peel_int(recRead, "CommRecID")
                                abbr = DatabaseHelper.Peel_string(recRead, "Abbreviation")
                                ddlCommRec.Items.Add(New ListItem(abbr, rec, True))
                            End While
                        End Using

                        ddlCommRec.Visible = True
                    Else
                        userPerm = UserID
                        ddlCommRec.Visible = False
                    End If

                    ddlCompany.Items.Clear()

                    cmd.CommandText = "SELECT isnull(CompanyIDs, 0) FROM tblUserCompany WHERE UserID = " + userPerm.ToString()
                    Dim companies() As String = cmd.ExecuteScalar().ToString().Split(",")
                    For Each cmp As Integer In companies
                        cmd.CommandText = "SELECT lower(ShortCoName) FROM tblCompany WHERE CompanyID = " + cmp.ToString()
                        cmpName = cmd.ExecuteScalar()
                        ddlCompany.Items.Add(New ListItem(StrConv(cmpName, VbStrConv.ProperCase), cmpName, True))
                    Next
                End Using
            End Using

            ddlCompany.Visible = True

            'txtTransDate1.Text = DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + DateTime.Now.Year.ToString().Substring(2, 2)
            'txtTransDate2.Text = DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + DateTime.Now.Year.ToString().Substring(2, 2)
            txtTransDate1.Text = "103106"
            txtTransDate2.Text = "103106"
        End If
    End Sub

    Protected Sub btnRequery_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRequery.Click
        If CommRecID < 0 Then
            CommRecID = ddlCommRec.SelectedItem.Value
        End If

        If Not IsDate(txtTransDate1.Text) Then
            txtTransDate1.Text = MakeValidDate(txtTransDate1.Text)
        End If

        If Not IsDate(txtTransDate2.Text) Then
            txtTransDate2.Text = MakeValidDate(txtTransDate2.Text)
        End If

        If CDate(txtTransDate1.Text) > CDate(txtTransDate2.Text) Then
            Dim tempdate As String = txtTransDate2.Text
            txtTransDate2.Text = txtTransDate1.Text
            txtTransDate1.Text = tempdate
        End If

        Requery()
    End Sub

    Public Function MakeValidDate(ByVal str As String) As String
        Dim month As Integer = CInt(str.Substring(0, 2))
        Dim day As Integer = CInt(str.Substring(3, 2))
        Dim year As Integer = CInt(str.Substring(6, 2))

        If month > 12 Then
            month = 12
        End If

        If day > 30 And (month = 2 Or month = 4 Or month = 6 Or month = 9 Or month = 11) Then
            day = 30
        End If

        If day > 28 And month = 2 Then
            If year Mod 4 = 0 Then
                day = 29
            Else
                day = 28
            End If
        End If

        Return (month.ToString().PadLeft(2, "0") + "/" + day.ToString().PadLeft(2, "0") + "/" + year.ToString().PadLeft(2, "0"))
    End Function

    Public Sub Requery()
        lblError.Visible = False
        tblNone.Visible = False
        tblHeaders.Visible = False
        trvBatches.Visible = False
        trvBatches.Nodes.Clear()

        Dim batches As List(Of BatchEntry)
        Dim details As List(Of CommissionBatchEntry)
        Dim persons As Dictionary(Of Integer, List(Of CommissionPersonEntry))
        Dim idxbatch As Integer = 0
        Dim idxdetail As Integer = 0
        Dim idxperson As Integer = 0

        Dim cmd As New SqlCommand

        Try
            cmd.CommandTimeout = 0
            cmd.Connection = New SqlConnection(connString)
            cmd.Connection.Open()

            batches = PopulateBatches(cmd)

            For Each batch As BatchEntry In batches
                trvBatches.Nodes.Add(New TreeNode("<td><img src=""" + ResolveUrl("~\images\16x16_folder2.png") + """ width=""16"" height=""16"">&nbsp;</td><td align=""left"" width=""25%"" style=""font-family:Arial;font-size:14px;"">" + batch.CommBatchId.ToString() + "</td><td align=""left"" width=""50%"" style=""font-family:Arial;font-size:14px;"">" + batch.BatchDate.ToString("MM/dd/yyyy") + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:14px;"">" + batch.Amount.ToString("c") + "</td>", idxbatch))

                details = PopulateDetails(batch.CommBatchId, cmd)
                persons = PopulatePerson(batch.CommBatchId, cmd)

                idxdetail = 0
                For Each detail As CommissionBatchEntry In details
                    trvBatches.Nodes(idxbatch).ChildNodes.Add(New TreeNode("<td><img src=""" + ResolveUrl("~\images\16x16_person.png") + """ width=""16"" height=""16""></td><td align=""left"" width=""20%"" style=""font-family:Arial;font-size:12px;"">" + detail.ClientID.ToString() + "</td><td align=""left"" width=""50%"" style=""font-family:Arial;font-size:12px;"">" + detail.Name.ToString() + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + detail.Amount.ToString("c") + "</td>", idxdetail))

                    idxperson = 0
                    For Each info As CommissionPersonEntry In persons(detail.ClientID)
                        trvBatches.Nodes(idxbatch).ChildNodes(idxdetail).ChildNodes.Add(New TreeNode("<td align=""left"" width=""50%"" style=""font-family:Arial;font-size:12px;"">" + info.EntryType.ToString() + "</td><td align=""left"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + info.Percent.ToString() + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + info.Amount.ToString("c") + "</td>", idxperson))
                        idxperson += 1
                    Next

                    idxdetail += 1
                Next

                idxbatch += 1
            Next
        Catch ex As Exception
            lblError.Text = ex.ToString()
            lblError.Visible = True
        Finally
            cmd.Connection.Close()
            cmd.Dispose()
        End Try

        If idxbatch = 0 Then
            tblNone.Visible = True
        Else
            tblHeaders.Visible = True
            trvBatches.Visible = True
        End If
    End Sub

    Public Function PopulateBatches(ByVal cmd As SqlCommand) As List(Of BatchEntry)
        Dim batches As New List(Of BatchEntry)
        Dim b As BatchEntry

        cmd.CommandText = "exec stp_ReportGetAgencyBatches_" + ddlCompany.SelectedItem.Value + " '" + txtTransDate1.Text + "', '" + txtTransDate2.Text + "', '" + CommRecID.ToString() + "'"

        Using rd As IDataReader = cmd.ExecuteReader()
            While rd.Read()
                b = New BatchEntry
                b.CommBatchId = DatabaseHelper.Peel_int(rd, "CommBatchId")
                b.BatchDate = DatabaseHelper.Peel_date(rd, "BatchDate")
                b.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                batches.Add(b)
            End While
        End Using
        'End Using

        Return batches
    End Function

    Public Function PopulateDetails(ByVal batchid As Integer, ByVal cmd As SqlCommand) As List(Of CommissionBatchEntry)
        Dim tempEntry As CommissionBatchEntry
        Dim CommissionBatch As New List(Of CommissionBatchEntry)

        cmd.CommandText = "exec stp_ReportGetCommissionBatchTransfers '" + batchid.ToString() + "', '" + CommRecID.ToString() + "'"

        Using rd As IDataReader = cmd.ExecuteReader()
            While rd.Read()
                tempEntry = New CommissionBatchEntry
                tempEntry.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tempEntry.Name = DatabaseHelper.Peel_string(rd, "ClientName").Trim()
                tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                CommissionBatch.Add(tempEntry)
            End While
        End Using

        Return CommissionBatch
    End Function

    Public Function PopulatePerson(ByVal commbatchid As Integer, ByVal cmd As SqlCommand) As Dictionary(Of Integer, List(Of CommissionPersonEntry))
        Dim tempEntries As New List(Of CommissionPersonEntry)
        Dim tempEntry As CommissionPersonEntry
        Dim tempClientID As Integer = 0
        Dim lastClientID As Integer = 0
        Dim CommissionPerson As New Dictionary(Of Integer, List(Of CommissionPersonEntry))

        cmd.CommandText = "exec stp_ReportGetCommissionBatchTransfersByClient_all '" + commbatchid.ToString() + "', " + CommRecID.ToString()

        Using rd As SqlDataReader = cmd.ExecuteReader()
            While rd.Read()
                lastClientID = tempClientID

                tempEntry = New CommissionPersonEntry
                tempClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tempEntry.EntryType = DatabaseHelper.Peel_string(rd, "EntryType")
                tempEntry.Percent = Math.Round(DatabaseHelper.Peel_float(rd, "Percent") * 100, 2).ToString() + "%"
                tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                If Not tempClientID = lastClientID Then
                    CommissionPerson.Add(lastClientID, tempEntries)
                    tempEntries = New List(Of CommissionPersonEntry)
                End If

                tempEntries.Add(tempEntry)
            End While
        End Using

        CommissionPerson.Add(tempClientID, tempEntries)
        tempEntries = New List(Of CommissionPersonEntry)

        Return CommissionPerson
    End Function

End Class