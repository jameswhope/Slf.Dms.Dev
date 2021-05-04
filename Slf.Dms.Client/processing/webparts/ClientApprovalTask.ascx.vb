Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Partial Class processing_webparts_ClientApprovalTask
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Public TaskID As Integer = 0
    Private UserID As Integer
    Public AccNumber As String
    Public SettlementID As Integer
    Public _ClientID As Integer
    Public _AccountId As Integer
    Public Selected As String
    Private subFolder As String
    Private _callResolutionId As Integer
    Private _IsPopup As Boolean
    Private _MatterId As Integer

    Public Property CallResolutionId() As Integer
        Get
            Return _callResolutionId
        End Get
        Set(ByVal value As Integer)
            _callResolutionId = value
        End Set
    End Property
    Public Property IsPopup() As Boolean
        Get
            Return _IsPopup
        End Get
        Set(ByVal value As Boolean)
            _IsPopup = value
        End Set
    End Property

#Region "Events"
    ''' <summary>
    ''' Event Defined for value changes in Drop down
    ''' </summary>
    ''' <param name="selectedValue">The value selected in the Drop down </param>
    ''' <remarks>EVent raised when the Value in the drop down changes</remarks>
    Public Event SelectedValueChanged(ByVal selectedValue As String)
#End Region

#End Region

#Region "Page Events"
    ''' <summary>
    ''' Loads the page with approval form
    ''' </summary>
    ''' <param name="sender">sender object</param>
    ''' <param name="e">Arguments of the event</param>
    ''' <remarks>If CallResolutionID is populated, it is a verbal approval else written</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("id") Is Nothing Then
            TaskID = Integer.Parse(Request.QueryString("id"))
            SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))
            _ClientID = SettlementMatterHelper.GetClientFromTask(Integer.Parse(Request.QueryString("id")))
            _AccountId = SettlementMatterHelper.GetSettlementInformation(SettlementID).AccountID
            AccNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientId = " & _ClientID)
            _MatterId = SettlementMatterHelper.GetSettlementInformation(SettlementID).MatterId
            Me.IsPopup = False
        End If

        If Not IsPostBack Then
            LoadApprovalForm(SettlementID)
            DialerScheduler.Client = _ClientID
            DialerScheduler.MatterId = _MatterId
            DialerScheduler.LoadDateTime()
        End If
    End Sub
#End Region

#Region "Other Events"
    ''' <summary>
    ''' Clears all the data and re-loads the approval form
    ''' </summary>    
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkCancel.Click
        lblApprovalType.Text = ddlApprovalType.SelectedValue
        Selected = ddlApprovalType.SelectedValue
        HideErrorMessage()
        LoadPendingClientApprovalControls()
    End Sub
    ''' <summary>
    ''' Method called when Click event is registered on Save link button
    ''' </summary>   
    ''' <remarks>Saves the Scanned copy in the temporary location to the Creditor Docs on Server. Resolves the Client Approval TAsk</remarks> 
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles lnkSave.Click
        Dim dateString As String = String.Format("{0:yyMMdd}", DateTime.Now)
        Dim docId As String = String.Empty
        Dim folderRoot As String = System.Configuration.ConfigurationManager.AppSettings("ClientApproval")
        Dim Information As SettlementMatterHelper.SettlementInformation = SettlementMatterHelper.GetSettlementInformation(SettlementID)
        Dim filePath As String = ""
        Using att As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(SettlementID)
            filePath = String.Format("{0}\ClientApproval\{1}\{2}_D6004SCAN_{3}.pdf", folderRoot, SettlementID, AccNumber, dateString)
        End Using

        Dim adjustedDesc As String = "Settlement Fee Adjustment - "
        Dim delFeeDesc As String = "Settlement Delivery Fee - "
        Dim adjustedSettlementFee As Double = Val(txtSettlementFee.Text)
        Dim adjustedDeliveryAmt As Double = Val(txtDeliveryAmount.Text)

        HideErrorMessage()

        '*** uncomment for production ***
        '*** no scanner - removed scanning in process ***'
        'If Not ddlApprovalType.SelectedValue.Equals("Verbal") Then
        '    If Not File.Exists(filePath) Then
        '        If radAccept.Checked Then
        '            ShowErrorMessage("Scan the document containing Client's Approval using the Common tasks. " & _
        '                            "Then select Save")
        '            Exit Sub
        '        End If
        '    Else
        '        docId = Me.AttachDocument(filePath)
        '    End If
        'End If

        Dim returnValue As Integer = -1
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()
            returnValue = SettlementMatterHelper.ResolveClientApproval(SettlementID, UserID, ddlApprovalType.SelectedValue, radAccept.Checked, txtNotes.Text, IIf(radAccept.Checked, Nothing, ddlReason.SelectedValue), dateString, docId, subFolder, Path.GetFileNameWithoutExtension(filePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(1))

            'end tasks previously handled by the PaymentInformation webpart
            If returnValue = 0 Then
                'Insert the Settlement Roadmap
                Using settinfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(SettlementID)
                    Dim matterID As Integer = settinfo.SettlementMatterID
                    Dim currenttaskid As Integer = SettlementMatterHelper.GetMatterCurrentTaskID(matterID)
                    If settinfo.IsClientStipulation Then
                        Me.Response.Redirect("~/processing/tasksummary/default.aspx?id=" & currenttaskid)
                    Else
                        Response.Redirect("~/default.aspx")
                    End If
                End Using
            Else
                ShowErrorMessage("Error Occured while saving the approval. Scan Again and Save")
            End If
        End Using
    End Sub
    ''' <summary>
    ''' Raises the SelectedValueChanged Event
    ''' </summary>
    ''' <remarks>The implementation of this event is in the TaskSummary page</remarks>
    Protected Sub ddlApprovalType_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlApprovalType.TextChanged
        HideErrorMessage()
        Selected = ddlApprovalType.SelectedValue

        If ddlApprovalType.SelectedValue.Equals("Verbal") Then
            txtNotes.Visible = False

            If radAccept.Checked Then
                trSave.Style.Item("display") = "none"
            End If
        Else
            txtNotes.Visible = True
            trSave.Style.Item("display") = ""
        End If

        RaiseEvent SelectedValueChanged(Selected)
    End Sub

#End Region

#Region "Utilities"
    ''' <summary>
    ''' Loads the controls based on the resolution/state of the task
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify the Settlement</param>
    ''' <remarks>Added functionality, so that on refreshing page after submit, appropriate controls are loaded</remarks>
    Public Sub LoadApprovalForm(ByVal _SettlementId As Integer)

        If Not SettlementID = 0 Then
            Me.SettlementID = _SettlementId

            Dim Resolved As Nullable(Of DateTime) = DataHelper.Nz_ndate(DataHelper.FieldLookup("tblTask", "Resolved", "TaskID = " & TaskID))
            If Resolved.HasValue Then
                Dim clientApproval As SettlementMatterHelper.ClientVerification
                clientApproval = SettlementMatterHelper.GetClientApproval(SettlementID)

                lblNotes.Text = clientApproval.Note
                txtNotes.Visible = False
                lblNotes.Visible = True

                lblApprovalType.Text = clientApproval.ApprovalType
                ddlApprovalType.Visible = False
                lblApprovalType.Visible = True
                lblStatus.Visible = True

                If Not String.IsNullOrEmpty(clientApproval.RejectionReason) Then
                    lblStatus.Text = "Rejected"
                    lblReason.Text = clientApproval.RejectionReason
                    lblReasonText.Visible = True
                    lblReason.Visible = True
                Else : lblStatus.Text = "Accepted"
                End If

                radAccept.Visible = False
                radReject.Visible = False
                trSave.Style.Item("display") = "none"
            Else
                radAccept.Attributes.Add("onClick", "javascript:ChangeStatus(0)")
                radReject.Attributes.Add("onClick", "javascript:ChangeStatus(1)")
                LoadPendingClientApprovalControls()
                If Me.CallResolutionId <> -1 Then
                    Selected = "Verbal"
                Else
                    Selected = "Written"
                End If

                ddlApprovalType.SelectedValue = Selected
                LoadRejectionReasons()

                If ddlApprovalType.SelectedValue.Equals("Verbal") Then
                    txtNotes.Visible = False

                    If radAccept.Checked Then
                        trSave.Style.Item("display") = ""
                    End If
                End If

                Dim Information As SettlementMatterHelper.SettlementInformation = SettlementMatterHelper.GetSettlementInformation(_SettlementId)
                txtSettlementFee.Text = Format(Information.SettlementFee + Information.AdjustedSettlementFee, "#.00")
                hdnSettlementFee.Value = Information.SettlementFee + Information.AdjustedSettlementFee
                txtDeliveryAmount.Text = Format(Information.DeliveryAmount, "#.00")
                hdnDeliveryAmount.Value = Information.DeliveryAmount
            End If
        End If
    End Sub
    ''' <summary>
    ''' Saves the Scanned document to appropriate folder and enters all the document relations
    ''' </summary>
    ''' <param name="filePath">The path of the temporary scanned document</param>
    ''' <returns>integer representing the DocumentId of the Saved document</returns>
    ''' <remarks>This method creates an entry of the document in tblDocScan and relates the document to account</remarks>
    Private Function AttachDocument(ByVal filePath As String) As String

        Dim newFilePath As String = SettlementMatterHelper.BuildDocumentPath(_AccountId, _ClientID, "D6004SCAN")
        SharedFunctions.DocumentAttachment.CreateDirForClient(_ClientID)

        File.Move(filePath, newFilePath)
        Dim fdir As String = filePath.Substring(0, filePath.LastIndexOf("\"))

        'delete all file in folder first
        For Each f As String In Directory.GetFiles(fdir, "*.*", SearchOption.AllDirectories)
            File.Delete(f)
        Next
        Directory.Delete(fdir)



        Dim folderPaths() As String = newFilePath.Split("\")
        Dim docID As String = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))
        subFolder = SettlementMatterHelper.GetSubFolder(_AccountId)

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()
            Dim cmdStr As String = "INSERT INTO tblDocScan(DocID,ReceivedDate, Created,CreatedBy) VALUES ('" & docID & "',getdate(),getdate()," & UserID.ToString() & ")"

            Using cmd As New SqlCommand(cmdStr, connection)
                cmd.ExecuteNonQuery()
            End Using

            cmdStr = "INSERT INTO tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder,RelatedDate, RelatedBy, DeletedFlag, deleteddate, deletedby)  VALUES (" & _
                    _ClientID.ToString() + ", " + _AccountId.ToString() + ", 'account', 'D6004SCAN', '" + docID + "', '" + DateTime.Now.ToString("yyMMdd") + "', '" + subFolder + "', getdate(), " + UserID.ToString() + ", 0,  null,0)"
            Using cmd As New SqlCommand(cmdStr, connection)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Return docID
    End Function
    ''' <summary>
    ''' Loads the reasons for rejection
    ''' </summary>
    ''' <remarks>Populated only when the client rejects the settlement</remarks>
    Private Sub LoadRejectionReasons()
        Using cmd As New SqlCommand("SELECT ReasonName FROM tblClientRejectionReason", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                ddlReason.ClearSelection()
                ddlReason.Items.Add("")
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlReason.Items.Add(reader("ReasonName"))
                    End While
                End Using
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Loads the controls for approval form
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub LoadPendingClientApprovalControls()
        'Client Pending Approval
        ddlApprovalType.Enabled = True
        ddlApprovalType.Visible = True
        lblApprovalType.Enabled = False
        lblApprovalType.Visible = False
        txtNotes.Visible = True
        txtNotes.Enabled = True
        lblReasonText.Enabled = False
        lblReasonText.Visible = False
        lnkSave.Enabled = True
        lnkSave.Visible = True
        lnkCancel.Enabled = True
        lnkCancel.Visible = True

    End Sub
    ''' <summary>
    ''' Loads the controls after Saving the form
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub LoadSaveControls()
        Try
            Dim status As String = String.Empty
            If radAccept.Checked Then
                status = radAccept.Text
            End If
            If radReject.Checked Then
                status = radReject.Text
            End If

            'On Clicking Save
            ddlApprovalType.Enabled = False
            ddlApprovalType.Visible = False
            lblApprovalType.Enabled = True
            lblApprovalType.Visible = True
            txtNotes.ReadOnly = True
            txtNotes.Style.Add("background-color", "Transparent")
            txtNotes.Style.Add("border", "0px")

            lblStatus.Text = status
            radAccept.Enabled = False
            radAccept.Visible = False
            radReject.Enabled = False
            radReject.Visible = False

            lblStatus.Visible = True
            lblStatus.Enabled = True
            lblReasonText.Text = ddlReason.SelectedValue
            If status.Equals("Accepted") Then
                ddlReason.Enabled = False
                ddlReason.Visible = False
                lblReason.Enabled = False
                lblReason.Visible = False
                lblReasonText.Enabled = False
                lblReasonText.Visible = False
            Else
                ddlReason.Enabled = False
                ddlReason.Visible = False
                lblReason.Enabled = True
                lblReason.Visible = True
                lblReasonText.Enabled = True
                lblReasonText.Visible = True
            End If

            trSave.Style.Item("display") = "none"

        Catch ex As Exception

        End Try
        
    End Sub
    ''' <summary>
    ''' Show any error messages
    ''' </summary>
    ''' <param name="strMessage"></param>
    ''' <remarks></remarks>
    Private Sub ShowErrorMessage(ByVal strMessage As String)
        dvError.Style.Add("display", "inline")
        tdError.InnerHtml = strMessage
    End Sub
    ''' <summary>
    ''' Hides the error message block
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub HideErrorMessage()
        dvError.Style.Add("display", "none")
        tdError.InnerHtml = ""
    End Sub

#End Region


End Class
