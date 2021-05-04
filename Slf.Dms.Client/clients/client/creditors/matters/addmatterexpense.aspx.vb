Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Partial Class Clients_client_creditors_matters_addmatterexpense
    Inherits System.Web.UI.Page

#Region "Variables"

    Public MatterID As Integer
    Public UserID As Integer
    Public Shadows ClientID As Integer
    Public AccountId As Integer
    Dim MatterExpenseID As Int32 = 0
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        txtBillRate.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtBillTime.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
        txtBillRate.Attributes("onkeyup") = "calc();"
        txtBillTime.Attributes("onkeyup") = "calc();"

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            MatterID = DataHelper.Nz_int(qs("mid"), 0)
            AccountId = DataHelper.Nz_int(qs("aid"), 0)
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            MatterExpenseID = DataHelper.Nz_int(qs("meid"), 0)
        End If
        If Not IsPostBack Then
            'PopulateMatterStatusCode()
            PopulateAttorney()
            lblClient.Text = ClientHelper.GetDefaultPersonName(ClientID)
            lblClientID.Text = ClientID

            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()


            cmd.CommandText = "select tp.firstname,tp.lastname,  tcm.name,tp.EmailAddress, " & _
            " tpn.areacode , tpn.number , tpn.extension, tc.primarypersonid," & _
            " tp.street, tp.webcity,  (select name from tblstate where stateid=tp.webstateid) statename , tp.webzipcode, tc.SDABalance " & _
             " from tblperson tp, tblcompany tcm, tblClient tc  left outer join" & _
            " tblPersonPhone tpp on tc.primarypersonid=tpp.personid left outer join" & _
            " tblphone tpn on tpp.phoneid=tpn.phoneid" & _
             "  where(tc.clientid = @ClientID And tc.primarypersonid = tp.personid)" & _
            " and tc.companyid=tcm.companyid "
            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
            Try

                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

                If rd.Read() Then
                    lblFirm.Text = DatabaseHelper.Peel_string(rd, "name")

                End If
                rd.Close()
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            'Me.txtExpensesDate.MinDate = System.DateTime.Now.AddYears(-3)
            Me.txtExpensesDate.MaxDate = System.DateTime.Now.AddYears(3)
            Me.txtExpensesDate.NullDateLabel = ""
            PopulateValidLocalCounselforClient()
            LoadMatterNumber()
        End If
        If MatterExpenseID > 0 Then
            hylinkSave.Visible = False
            LoadMatterExpense(MatterExpenseID)
        End If

    End Sub
    Protected Sub LoadMatterExpense(ByVal Id As Int32)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()


        cmd.CommandText = "select * from tblmattertimeexpense where MatterTimeExpenseId=@MatterTimeExpenseId"
        DatabaseHelper.AddParameter(cmd, "MatterTimeExpenseId", Id)
        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                txtExpensesDate.Value = DatabaseHelper.Peel_ndate(rd, "TimeExpenseDatetime")
                Dim edate As DateTime = DatabaseHelper.Peel_ndate(rd, "TimeExpenseDatetime")
                Me.WebDateTimeEdit.EditModeText = edate.Hour.ToString() + ":" + edate.Minute.ToString()
                txtDesc.Text = DatabaseHelper.Peel_string(rd, "TimeExpenseDescription")
                txtBillTime.Text = DatabaseHelper.Peel_double(rd, "BillableTime")
                txtBillRate.Text = DatabaseHelper.Peel_double(rd, "BillRate")
                txtNote.Text = DatabaseHelper.Peel_string(rd, "Note")
                ddlAttorney.SelectedIndex = ddlAttorney.Items.IndexOf(ddlAttorney.Items.FindByValue(DatabaseHelper.Peel_int(rd, "AttorneyId")))

            End If
            rd.Close()
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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
    Private Sub PopulateValidLocalCounselforClient()
        ddlLocalCounsel.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetLocalCounselListbyClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))

                    End While
                End Using
            End Using
        End Using
    End Sub
    'Private Sub PopulateMatterStatusCode()
    '    ddlMatterStatusCode.Items.Clear()
    '    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '        Using cmd.Connection
    '            cmd.CommandText = "SELECT * FROM tblMatterStatusCode"

    '            cmd.Connection.Open()
    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                While rd.Read()
    '                    ddlMatterStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterStatusCode"), DatabaseHelper.Peel_int(rd, "MatterStatusCodeId")))
    '                End While
    '                ''Default MatterStatusCode is Pending 
    '                ddlMatterStatusCode.SelectedIndex = 15

    '            End Using
    '        End Using
    '    End Using
    'End Sub
    Private Sub LoadMatterNumber()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetMatterInstance"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterID)
                DatabaseHelper.AddParameter(cmd, "AccountId", AccountId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        txtMatterNumber.Text = rd("MatterNumber")
                        txtAccountNumber.Text = rd("AccountNumber")
                        txtMatterDate.Text = rd("MatterDate")
                        ddlLocalCounsel.SelectedIndex = ddlLocalCounsel.Items.IndexOf(ddlLocalCounsel.Items.FindByValue(rd("AttorneyID")))
                        txtLocalCounsel.Value = ddlLocalCounsel.SelectedItem.Text
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Sub PopulateAttorney()
        ddlAttorney.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                ' cmd.CommandText = "select AttorneyId, Firstname+' '+LastName as [name]  from tblAttorney order by name "
                cmd.CommandText = "stp_GetLocalCounselListbyClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlAttorney.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
                    End While
                    ''Default MatterStatusCode is Pending 
                    '  ddlMatterStatusCode.SelectedIndex = 15
                    ddlAttorney.Items.Insert(0, New ListItem("Select", "0"))
                End Using
            End Using
        End Using
    End Sub



    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()


        Dim ExpenseTime As String = Me.WebDateTimeEdit.EditModeText
        Dim ExpenseDate As String = Me.txtExpensesDate.CalendarLayout.SelectedDate
        Dim ExpenseDateTime As DateTime = DateTime.Parse(Me.txtExpensesDate.CalendarLayout.SelectedDate) + " " + Me.WebDateTimeEdit.EditModeText


        Try
            cmd.Connection.Open()
            cmd.CommandText = "insert into tblMatterTimeExpense (MatterId, TimeExpenseDatetime, TimeExpenseDescription, BillableTime, BillRate, AttorneyId, CreateDatetime, Createdby, Note)  values(@MatterID, @TimeExpenseDatetime,@TimeExpenseDescription, @BillableTime, @BillRate, @AttorneyId, getdate(),@UserID, @Note)"
            DatabaseHelper.AddParameter(cmd, "MatterID", MatterID)
            DatabaseHelper.AddParameter(cmd, "TimeExpenseDatetime", ExpenseDateTime)
            DatabaseHelper.AddParameter(cmd, "TimeExpenseDescription", txtDesc.Text)
            DatabaseHelper.AddParameter(cmd, "BillableTime", txtBillTime.Text)
            DatabaseHelper.AddParameter(cmd, "BillRate", txtBillRate.Text)
            DatabaseHelper.AddParameter(cmd, "AttorneyId", ddlAttorney.SelectedValue)
            'DatabaseHelper.AddParameter(cmd, "AttorneyId", ddlLocalCounsel.SelectedValue)
            DatabaseHelper.AddParameter(cmd, "Note", txtNote.Text)
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)


            cmd.ExecuteNonQuery()
            RegisterStartupScript("onLoad", "<script>self.close(); </script>")

        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
End Class
