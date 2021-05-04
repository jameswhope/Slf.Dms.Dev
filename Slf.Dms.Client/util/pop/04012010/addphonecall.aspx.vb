Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Partial Class util_pop_addphonecall
    Inherits System.Web.UI.Page
    Private Action As String
    Public AccountID As Integer
    Public PhoneCallID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblPhoneCall"
    Private UserID As Integer
    Private IsMy As Boolean
    Public AddRelation As Integer
    Public AddRelationType As String
    Public MatterId As Integer
    Public ClientRequestId As Integer
    Public CreditorInstanceId As Integer

    Private Sub PopulateExternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, PersonID FROM tblPerson WHERE ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboExternal.Items.Clear()
            cboExternal.Items.Add(New ListItem("", "0"))
            cboExternal.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")
                cboExternal.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "PersonID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub PopulateInternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, UserId FROM tblUser"

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboInternal.Items.Clear()
            cboInternal.Items.Add(New ListItem("", "0"))
            cboInternal.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")
                cboInternal.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "UserID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub PopulatePhonecallEntry()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT PhoneEntry, MatterPhoneEntryID FROM tblMatterPhoneEntry"

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboPhoneCallEntry.Items.Clear()
            cboPhoneCallEntry.Items.Add(New ListItem("Select", "0"))
            cboPhoneCallEntry.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "PhoneEntry")
                cboPhoneCallEntry.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "MatterPhoneEntryID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            'PhoneCallID = DataHelper.Nz_int(qs("pcid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            ''Added for MatterId 
            If Not qs("mid") Is Nothing Then
                MatterId = DataHelper.Nz_string(qs("mid"))
                CreditorInstanceId = DataHelper.FieldLookup("tblMatter", "CreditorInstanceId", "MatterID = " + MatterId.ToString())
            Else
                MatterId = 0
                CreditorInstanceId = 0
            End If

            ''Added for ClientRequestId 
            If Not qs("rid") Is Nothing Then
                ClientRequestId = DataHelper.Nz_string(qs("rid"))
            Else
                ClientRequestId = 0
            End If
            

            If Not IsPostBack Then
                RegisterStartupScript("onload", " <script>        window.onload = function() {  SetToNow('txtStarted') }     </script>")
                PopulateExternal()
                PopulateInternal()
                PopulatePhonecallEntry()
                ListHelper.SetSelected(cboInternal, UserID)
                AddRelation = 0

                hdnTempPhoneCallID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
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

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        PhoneCallID = PhoneCallHelper.InsertPhoneCall(ClientID, UserID, cboInternal.SelectedValue, cboExternal.SelectedValue, rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, txtMessage.Text, txtSubject.Text, DateTime.Parse(txtStarted.Text), DateTime.Parse(txtEnded.Text))
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)
        ' Id 19 is Matter    
        DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
        DatabaseHelper.AddParameter(cmd, "RelationID", MatterId)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblPhoneCallRelation", "PhoneCallRelationId", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            RegisterClientScriptBlock("onload", "<script> window.onload = function() { CloseMatterPhone(); } </script>")

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Sub cboPhoneCallEntry_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboPhoneCallEntry.SelectedIndexChanged
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "select PhoneEntryDesc,PhoneEntryBody from tblMatterPhoneEntry where MatterPhoneEntryID=@MatterPhoneEntryID"
            DatabaseHelper.AddParameter(cmd, "MatterPhoneEntryID", cboPhoneCallEntry.SelectedValue)
            txtSubject.Text = ""
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    txtSubject.Text = DatabaseHelper.Peel_string(rd, "PhoneEntryDesc")
                    txtMessage.Text = DatabaseHelper.Peel_string(rd, "PhoneEntryBody")
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
End Class
