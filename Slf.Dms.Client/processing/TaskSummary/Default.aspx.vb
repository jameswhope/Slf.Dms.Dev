Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO

Partial Class processing_TaskSummary_Default
    Inherits System.Web.UI.Page

#Region "Variables"
    Public UserID As Integer
    Public SettlementID As Integer
    Public MatterID As Integer
    Protected approvalTask As processing_webparts_ClientApprovalTask

    Private _DataClientID As String
    Private _AccountID As String
    Private _TaskTypeId As Integer
    Private TaskId As Integer
    Private _callResolutionId As Integer
    Private Information As SettlementMatterHelper.SettlementInformation
    Private CommonTasks As New List(Of String)


    Public Property DataClientID() As Integer
        Get
            Return _DataClientID
        End Get
        Set(ByVal value As Integer)
            _DataClientID = value
        End Set
    End Property
    Public Property AccountID() As Integer
        Get
            Return _AccountID
        End Get
        Set(ByVal value As Integer)
            _AccountID = value
        End Set
    End Property
    Public Property CallResolutionId() As Integer
        Get
            Return _callResolutionId
        End Get
        Set(ByVal value As Integer)
            _callResolutionId = value
        End Set
    End Property
    Public Property TaskTypeId() As Integer
        Get
            Return _TaskTypeId
        End Get
        Set(ByVal value As Integer)
            _TaskTypeId = value
        End Set
    End Property
#End Region

#Region "Page Events"
    ''' <summary>
    ''' Loads all the web parts 
    ''' </summary>
    ''' <param name="sender">sender object</param>
    ''' <param name="e">Argumenst of the event</param>
    ''' <remarks>The Id in the Request string is the the TaskId. 
    '''          If TaskId is 72, load ClientApproval Task
    '''          If TaskId is 78 load ClientStipulationApproval Task
    '''          If it is 71, Then VerificationTask is loaded
    '''          If it is 73, ProcessPayment is loaded
    ''' resoid is populated only when the dialer is accessing this page</remarks>
    ''' 

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If (Not sm.IsInAsyncPostBack) Then
            Dim css As String = String.Format("<link rel=""stylesheet"" href=""{0}"" type=""text/css"" />", ResolveUrl(GlobalFiles.JQuery.CSS))
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "MyCss4Jquery", css, False)
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                  GlobalFiles.JQuery.UI, _
                                                  "~/jquery/json2.js", _
                                                  "~/jquery/jquery.modaldialog.js" _
                                                  })

        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("id") Is Nothing Then
            Response.Redirect("~/processing/")
        Else
            TaskId = Integer.Parse(Request.QueryString("id"))
            SettlementID = SettlementMatterHelper.GetSettlementFromTask(TaskId)
        End If

        If Not Request.QueryString("resoid") Is Nothing Then
            CallResolutionId = Integer.Parse(Request.QueryString("resoid"))
        Else
            CallResolutionId = -1
        End If

        Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)
        MatterID = Information.MatterId
        _TaskTypeId = DataHelper.FieldLookupIDs("tblTask", "TaskTypeId", "TaskId = " & TaskId)(0)

        DataClientID = Information.ClientID
        AccountID = Information.AccountID

        If Not Page.IsPostBack Then
            wpCreditorInfoControl.LoadCreditorInfo(AccountID)
            SettCalcs.LoadSettlementInfo(SettlementID)

            If Not DataClientID = 0 And Not AccountID = 0 Then
                wpClientInfo.LoadClientInfo(DataClientID)
                AcctSummary.LoadAccounts(DataClientID)
            End If

            SettNotes.LoadNotes()
            '            ClientDocs.BuildDocumentPanes(SettlementID)
            If Information.IsPaymentArrangement Then
                Me.lblPayments.Text = String.Format("&nbsp;&nbsp;<a class=""lnkPA"" href=""javascript:void()"" onclick=""OpenPABox({0});return false;"">Payment&nbsp;Terms</a>", Information.SettlementID)
            End If
        End If

        LoadWorkflow(_TaskTypeId)

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me)
        sm.RegisterAsyncPostBackControl(AcctSummary)

    End Sub

    ''' <summary>
    ''' Handles the SelectedValueChanged Event raised from the ClientApprovalTask web part
    ''' </summary>
    ''' <param name="selectedValue">The Value selected in the DropDown ddlApprovalType</param>
    ''' <remarks>This method is used to fill up the Common tasks roll up based on the web part being loaded</remarks>
    Protected Sub wpClientApproval_SelectedValueChanged(ByVal selectedValue As String)
        FillUpCommonTasks(selectedValue)
    End Sub
#End Region

#Region "Utilities"
    ''' <summary>
    ''' Fills up the Common Tasks Roll up based on the Selected Value
    ''' </summary>
    ''' <param name="selectedValue">The Value selected in the Dropdown ddlApprovalType</param>
    ''' <remarks>The values can be either verbal or Written</remarks>
    Private Sub FillUpCommonTasks(ByVal selectedValue As String)

        If Not String.IsNullOrEmpty(selectedValue) Then
            CommonTasks.Clear()
            Select Case selectedValue
                Case "Written"
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_add.png") & """ align=""absmiddle""/>Scan Document</a>")
                Case "StipulationLetter"
                    Dim resolutionid As String = DataHelper.FieldLookup("tblTask", "TaskResolutionId", "TaskId = " & TaskId)
                    If String.IsNullOrEmpty(resolutionid) Then
                        CommonTasks.Add(String.Format("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:SendStipulationLetter({0});return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_email.png") & """ align=""absmiddle"" nowrap=""nowrap""/>Send Stipulation Letter</a>", SettlementID))
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_add.png") & """ align=""absmiddle"" nowrap=""nowrap""/>Scan Signed Stipulation</a>")
                    End If
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:window.location.href='" & ResolveUrl("~/clients/client/default.aspx?id=") & DataClientID & "';return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel2.png") & """ align=""absmiddle""/>Close</a>")
                Case Else
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenRecording();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_Phone.png") & """ align=""absmiddle""/>Record Client Approval</a>")
            End Select
            tblRollupCommonTasks.Rows.Clear()
            For Each t As String In CommonTasks
                Dim r As New HtmlTableRow()
                Dim c As New HtmlTableCell()

                c.NoWrap = True
                c.InnerHtml = t

                r.Cells.Add(c)

                tblRollupCommonTasks.Rows.Add(r)
            Next
        End If
    End Sub
    ''' <summary>
    ''' Loads the web part based on the TaskTypeId 
    ''' </summary>
    ''' <param name="taskTypeId">An Integer Value to uniquely identify the Task Type</param>
    ''' <remarks>The Processing team can have tasks 1)Client Approval 2)Settlement Verification 3)ProcessPayment
    ''' For Client APproval if resoId is populated then load the verbal approval control else written approval</remarks>
    Private Sub LoadWorkflow(ByVal taskTypeId As Integer)
        Dim uc As UserControl = Nothing
        Dim VirtualPath As String

        Select Case taskTypeId
            Case 72, 78
                VirtualPath = "~/processing/webparts/ClientApprovalTask.ascx"
                uc = LoadControl(VirtualPath)

                approvalTask = uc
                approvalTask.CallResolutionId = Me.CallResolutionId
                AddHandler approvalTask.SelectedValueChanged, AddressOf wpClientApproval_SelectedValueChanged

                If Me.CallResolutionId <> -1 Then
                    FillUpCommonTasks("Verbal")
                Else
                    FillUpCommonTasks("Written")
                End If
            Case 79, 82
                tabInfo.Style("display") = "none"
                VirtualPath = "~/processing/webparts/ClientDocumentAttachTask.ascx"
                uc = LoadControl(VirtualPath)
            Case 84
                FillUpCommonTasks("StipulationLetter")
                VirtualPath = "~/processing/webparts/StipulationLetterSentHistory.ascx"
                uc = LoadControl(VirtualPath)
                CType(uc, processing_webparts_StipulationLetterSentHistory).LoadHistory(SettlementID)
            Case Else
                VirtualPath = ""
        End Select

        If Not String.IsNullOrEmpty(VirtualPath) AndAlso Not uc Is Nothing Then
            phWorkflow.Controls.Add(uc)
            phWorkflow.Visible = True
            pnlNoWorkflow.Visible = False
        End If

    End Sub
    ''' <summary>
    ''' Method called by the delegates from the settlement workflows
    ''' </summary>
    ''' <param name="settlementid"></param>
    ''' <remarks>Re-loads the Settlement Notes and Documents</remarks>
    Private Sub LoadUpdatedControl(ByVal settlementid As Integer)
        Me.SettNotes.LoadCommData(DataClientID.ToString(), settlementid, 0, AccountID.ToString(), 0)
        'Me.ClientDocs.BuildDocumentPanes(settlementid)
    End Sub
#End Region

    Protected Sub lnkRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRefresh.Click
        Dim currenttaskid As Integer = SettlementMatterHelper.GetMatterCurrentTaskID(Information.MatterId)
        If currenttaskid <> TaskId Then
            Me.Response.Redirect("~/processing/tasksummary/default.aspx?id=" & currenttaskid)
        ElseIf Not approvalTask Is Nothing Then
            Me.approvalTask.LoadApprovalForm(SettlementID)
        End If
    End Sub
End Class