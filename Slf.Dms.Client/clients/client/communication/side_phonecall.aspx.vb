Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_side_phonecall
    Inherits Page

#Region "Variables"

    Private Action As String
    Public PhoneCallID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblNote"
    Private UserID As Integer

    Public DataClientID As Integer
    Public RelationTypeID As Integer
    Public RelationTypeName As String
    Public RelationID As Integer
    Public ClientName As String
    Public EntityName As String
    Public ContextSensitive As String
    Public AddRelationType As String
#End Region


    Private Sub PopulateExternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, PersonID FROM tblPerson WHERE ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        DataClientID = DataHelper.Nz_int(Request.QueryString("ClientID"), -1)
        ClientName = ClientHelper.GetDefaultPersonName(DataClientID)
        RelationTypeID = DataHelper.Nz_int(Request.QueryString("RelationTypeID"), -1)
        RelationID = DataHelper.Nz_int(Request.QueryString("RelationID"), -1)
        EntityName = Request.QueryString("EntityName")
        RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & RelationTypeID)

        If RelationTypeID = 2 Then
            ContextSensitive = "account"
        Else
            ContextSensitive = "all"
        End If

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not qs Is Nothing Then

            PhoneCallID = DataHelper.Nz_int(qs("phonecallid"), 0)
            Action = DataHelper.Nz_string(qs("a"))


            If Not IsPostBack Then

                HandleAction()

                Select Case Action
                    Case "a"
                        hdnTempPhoneCallID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                    Case Else
                        hdnTempPhoneCallID.Value = 0
                End Select

                GetRelationType()

                LoadDocuments()
            End If

        End If

    End Sub
    Private Sub GetRelationType()
        Using cmd As New SqlCommand("SELECT DocRelation FROM tblRelationType WHERE RelationTypeID = " + RelationTypeID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                AddRelationType = cmd.ExecuteScalar().ToString()
            End Using
        End Using
    End Sub
    Private Sub HandleAction()

        PopulateExternal()
        PopulateInternal()

        Select Case Action
            Case "a"    'add
                ltrNew.Text = "New&nbsp;"
                txtStarted.Text = Now.ToString("MM/dd/yyyy hh:mm:ss tt")
                ListHelper.SetSelected(cboInternal, UserID)
            Case Else   'edit
                LoadRecord()
        End Select
    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneCall WHERE PhoneCallID = @PhoneCallID"

        DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim lastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")

                If txtMessage.Text.Length = 0 Then
                    txtMessage.Text = DatabaseHelper.Peel_string(rd, "Body")
                    txtSubject.Text = DatabaseHelper.Peel_string(rd, "Subject")
                    txtStarted.Text = DatabaseHelper.Peel_date(rd, "StartTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                    txtEnded.Text = DatabaseHelper.Peel_date(rd, "EndTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                    txtPhoneNumber.Text = DatabaseHelper.Peel_string(rd, "PhoneNumber")
                End If

                ListHelper.SetSelected(cboExternal, DatabaseHelper.Peel_int(rd, "PersonID").ToString())
                ListHelper.SetSelected(cboInternal, DatabaseHelper.Peel_int(rd, "UserID").ToString())

                Select Case DatabaseHelper.Peel_bool(rd, "Direction")

                    Case True
                        rbOutgoing.Checked = True
                        rbIncoming.Checked = False
                    Case False
                        rbOutgoing.Checked = False
                        rbIncoming.Checked = True
                        ltrSwapOnLoad.Text = "<script>var cboInternal = document.getElementById(""" + cboInternal.ClientID + """);"
                        ltrSwapOnLoad.Text += "var cboExternal = document.getElementById(""" + cboExternal.ClientID + """);"
                        ltrSwapOnLoad.Text += "var tdSenderHolder = document.getElementById(""" + tdSenderHolder.ClientID + """);"
                        ltrSwapOnLoad.Text += "var tdRecipientHolder = document.getElementById(""" + tdRecipientHolder.ClientID + """);"
                        ltrSwapOnLoad.Text += "tdSenderHolder.appendChild(cboExternal);"
                        ltrSwapOnLoad.Text += "tdRecipientHolder.appendChild(cboInternal);</script>"
                End Select

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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
    Private Sub Close()
        Response.Write("<script>self.location='" & Session("Comms_LastURL") & "';</script>")
        Session("phonecall_back") = True
    End Sub
    Private Function InsertOrUpdatePhoneCall() As Integer
        Dim startDate As DateTime
        Dim endDate As DateTime

        Dim pch As New NewPhoneCallHelper

        If Not DateTime.TryParse(txtStarted.Text, startDate) Then
            startDate = DateTime.Now
        End If

        If Not DateTime.TryParse(txtEnded.Text, endDate) Then
            endDate = DateTime.Now
        End If

        If Action = "a" Then
            PhoneCallID = pch.InsertPhoneCall(DataClientID, UserID, cboInternal.SelectedValue, cboExternal.SelectedValue, rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, txtMessage.Text, txtSubject.Text, startDate, endDate)
            SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempPhoneCallID.Value, "phonecall", DataClientID, PhoneCallID)

            If RelationTypeID > 1 Then
                pch.RelatePhoneCall(PhoneCallID, RelationTypeID, RelationID)
            End If
        Else

            pch.UpdatePhoneCall(PhoneCallID, UserID, DataHelper.Nz_int(cboInternal.SelectedValue), _
                DataHelper.Nz_int(cboExternal.SelectedValue), rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, _
                txtMessage.Text, txtSubject.Text, startDate, endDate)

        End If

        Return PhoneCallID
    End Function
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempPhoneCallID.Value, "phonecall", UserID)

        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save()
        Close()
    End Sub
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub
    Private Sub LoadDocuments()
        If PhoneCallID = 0 Then
            'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempPhoneCallID.Value), "phonecall", Request.Url.AbsoluteUri)
            rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(Integer.Parse(hdnTempPhoneCallID.Value), "phonecall", Request.Url.AbsoluteUri)
        Else
            'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(PhoneCallID, "phonecall", Request.Url.AbsoluteUri)
            rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(PhoneCallID, "phonecall", Request.Url.AbsoluteUri)
        End If

        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub
    Private Sub Save()
        'save record
        InsertOrUpdatePhoneCall()
    End Sub
End Class