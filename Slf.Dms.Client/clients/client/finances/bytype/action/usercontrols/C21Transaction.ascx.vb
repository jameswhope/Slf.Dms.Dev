Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Slf.Dms.Records
Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic


Partial Class Clients_client_finances_bytype_action_usercontrols_C21Transaction
    Inherits System.Web.UI.UserControl

    Private qs As QueryStringCollection

    Private RegisterId As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            RegisterId = DataHelper.Nz_string(qs("rid"))

            If Not IsPostBack Then
                BindControls()
            End If

        End If
    End Sub


    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Private Function BindControls() As String
        Dim transactionId As String = String.Empty
        Dim C21ImageVirtualPath As String = ConfigurationManager.AppSettings("C21ImageVirtualPath").ToString

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCheck21TransactionByDepositId")
        DatabaseHelper.AddParameter(cmd, "DepositId", RegisterId)

        Using cmd
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Me.lblTransactionID.Text = DatabaseHelper.Peel_string(rd, "Transaction Id")
                        Me.lblAccountNumber.Text = DatabaseHelper.Peel_string(rd, "Account Number")
                        Me.lblCheckNumber.Text = DatabaseHelper.Peel_string(rd, "Check Number")
                        Me.lblAmount.Text = DatabaseHelper.Peel_decimal(rd, "Amount").ToString("c")
                        Me.lblCreated.Text = DatabaseHelper.Peel_date(rd, "Created")
                        Me.lblReceivedDate.Text = DatabaseHelper.Peel_date(rd, "Received Date")
                        Me.lblProcessedDate.Text = DatabaseHelper.Peel_date(rd, "Processed Date")
                        Me.lblState.Text = DatabaseHelper.Peel_string(rd, "State")
                        Me.lblStatus.Text = DatabaseHelper.Peel_string(rd, "Status")
                        Me.trFrontImage.Visible = DatabaseHelper.Peel_string(rd, "Front Image").Trim.Length > 0
                        Me.imgFront.ImageUrl = C21ImageVirtualPath & "/" & DatabaseHelper.Peel_string(rd, "Front Image").Replace("\", "/")
                        Me.trBackImage.Visible = DatabaseHelper.Peel_string(rd, "Back Image").Trim.Length > 0
                        Me.imgBack.ImageUrl = C21ImageVirtualPath & "/" & DatabaseHelper.Peel_string(rd, "Back Image").Replace("\", "/")
                        Exit While
                    End While
                End Using
            End Using
        End Using

        Return transactionId
    End Function
End Class
