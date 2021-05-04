Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Public Class clients_client_docs_data
    Inherits System.Web.UI.Page

#Region "Variables"

    Private Action As String
    Private DataEntryID As Integer
    Private DataEntryTypeID As Integer
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblDataEntry"

    Private UserID As Integer

#End Region

#Region "Properties"

    ReadOnly Property Control_txtConducted() As AssistedSolutions.WebControls.InputMask
        Get
            Return txtConducted
        End Get
    End Property
    ReadOnly Property Control_cboDataEntryTypeID() As DropDownList
        Get
            Return cboDataEntryTypeID
        End Get
    End Property

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            DataEntryID = DataHelper.Nz_int(qs("deid"), 0)
            DataEntryTypeID = DataHelper.Nz_int(qs("detid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                HandleAction()
            End If

            LoadMenu()

            SetupSheet()

        End If

    End Sub
    Private Sub LoadMenu()

        Dim CommonTasks As List(Of String) = CType(Master, clients_client).CommonTasks
        If Master.UserEdit Then
            'add applicant tasks
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")

            Select Case Action
                Case "a"    'add

                    If Not cboDataEntryTypeID.SelectedValue = 0 Then
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this data entry</a>")
                    End If

                Case Else   'edit

                    'add delete task
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this data entry</a>")

            End Select

            'add normal tasks
        End If
    End Sub
    Private Sub HandleAction()

        LoadDataEntryTypes()

        SetAttributes()

        Select Case Action
            Case "a"    'add

                lblDataEntry.Text = "Add New Data Entry"

            Case Else   'edit

                LoadRecord()

                cboDataEntryTypeID.Visible = False
                txtConducted.Visible = False

        End Select

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkDocuments.HRef = "~/clients/client/docs/?id=" & ClientID

    End Sub
    Private Sub SetAttributes()

    End Sub
    Private Sub LoadDataEntryTypes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetDataEntryTypesForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        cboDataEntryTypeID.Items.Clear()
        cboDataEntryTypeID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim MaxPerClient As Integer = DatabaseHelper.Peel_int(rd, "MaxPerClient")
                Dim NumDataEntries As Integer = DatabaseHelper.Peel_int(rd, "NumDataEntries")

                'only show listitem if maxperclient = -1 (meaning data entries are unlimited for this type)
                'or if the number of current data entries (for this client, for this type) are less than
                'the maximum allowed

                If MaxPerClient = -1 Or (NumDataEntries < MaxPerClient) Then
                    cboDataEntryTypeID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "DataEntryTypeID")))
                End If

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboDataEntryTypeID, DataEntryTypeID)

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblDataEntry WHERE DataEntryID = @DataEntryID"

        DatabaseHelper.AddParameter(cmd, "DataEntryID", DataEntryID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblConducted.Text = DatabaseHelper.Peel_datestring(rd, "Conducted", "MMM d, yyyy hh:mm tt")

                lblDataEntryTypeName.Text = DataHelper.FieldLookup("tblDataEntryType", "Name", "DataEntryTypeID = " & DataEntryTypeID) & "&nbsp;&nbsp;|"

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_docs_data""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        Response.Redirect("~/clients/client/docs/?id=" & ClientID)
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub cboDataEntryTypeID_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboDataEntryTypeID.SelectedIndexChanged

        Dim qsb As New QueryStringBuilder(Request.Url.Query)
        qsb("detid") = cboDataEntryTypeID.SelectedValue
        Response.Redirect("~/clients/client/docs/data.aspx?" & qsb.QueryString)

    End Sub
    Private Sub SetupSheet()

        If DataEntryTypeID = 0 Then 'nothing was selected

            pnlSheet.Visible = False
            pnlNoSheet.Visible = True

            lblError.Text = "Select a data entry type from the drop down list above.  This will " _
                & "display a preconfigured worksheet for the data you need to enter."

        Else

            If txtConducted.Text.Length = 0 Then
                txtConducted.Text = Now.ToString("MM/dd/yyyy hh:mm tt")
            End If

            pnlSheet.Visible = True
            pnlNoSheet.Visible = False

            LoadSheet(DataEntryTypeID)

        End If

    End Sub
    Private Sub LoadSheet(ByVal DataEntryTypeID As Integer)

        Dim VirtualPath As String = "~/clients/client/docs/sheets/" & DataEntryTypeID & ".ascx"

        If IO.File.Exists(Server.MapPath(VirtualPath)) Then 'sheet exists

            phSheet.Controls.Add(LoadControl(VirtualPath))

        End If

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete this data entry (tblDataEntry.DataEntryID)
        DataEntryHelper.Delete(DataEntryID)

        'because some docs may have been deleted, check and delete empty folders
        DocFolderHelper.DeleteEmptyFolders(ClientID)

        'back to docs page
        Response.Redirect("~/clients/client/docs/?id=" & ClientID)

    End Sub
End Class