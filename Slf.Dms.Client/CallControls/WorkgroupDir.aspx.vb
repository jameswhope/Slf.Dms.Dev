Imports ININ.IceLib.Directories
Imports ININ.IceLib.Connection
Imports System.Collections.ObjectModel
Imports System.Collections.Generic
Imports ININ.IceLib.People
Imports System.Data
Imports Drg.Util.DataAccess

Partial Class CallControls_WorkgroupDir
    Inherits System.Web.UI.Page

    Private _session As ININ.IceLib.Connection.Session
    Private _directoryMan As DirectoriesManager
    Private _contactDir As ContactDirectory
    Private _userStatuses As UserStatusList
    Private _peopleMan As PeopleManager

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _session = Session("IceSession")
        _peopleMan = Session("IcePeopleMan")

        If Not IsPostBack Then
            LogUseEvent()
            LoadQueues()
            If ddlWorkGroupQueues.Items.Count > 0 Then ddlWorkGroupQueues.SelectedIndex = 0
        End If
    End Sub

    Private Sub DisplayDirectory(ByVal WorkGroupName As String)
        If Not _session Is Nothing Then
            _directoryMan = DirectoriesManager.GetInstance(_session)
            Dim dirConfig As DirectoryConfiguration = New DirectoryConfiguration(_directoryMan)
            If Not dirConfig.IsWatching Then dirConfig.StartWatching()

            Dim meta As DirectoryMetadata = dirConfig.GetList(0)

            _contactDir = New ContactDirectory(_directoryMan, meta)

            Dim filterItems As Collection(Of ContactFilterItem) = GetFilter()

            Dim sortItems As New Collection(Of ContactSortItem)
            sortItems.Add(New ContactSortItem(ContactProperty.LastName, ComponentModel.ListSortDirection.Ascending))
            sortItems.Add(New ContactSortItem(ContactProperty.FirstName, ComponentModel.ListSortDirection.Ascending))

            Dim watchsetts As New ContactDirectoryWatchSettings(0, 9999, filterItems, sortItems)
            If Not _contactDir.IsWatching Then _contactDir.StartWatching(watchsetts)

            Dim entries As ReadOnlyCollection(Of ContactEntry) = _contactDir.GetList()

            Me.grdPhoneBook.DataSource = entries
            Me.grdPhoneBook.DataBind()
        End If

    End Sub

    Private Function GetFilter() As Collection(Of ContactFilterItem)
        Dim filter As New Collection(Of ContactFilterItem)

        If Me.ddlWorkGroupQueues.SelectedIndex >= 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.Workgroups, ContactFilterType.Wildcards, "*" & Me.ddlWorkGroupQueues.SelectedValue & "*"))
        End If

        If Me.txtLastName.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.LastName, ContactFilterType.Wildcards, Me.txtLastName.Text.Trim & "*"))
        End If
        If Me.txtFirstName.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.FirstName, ContactFilterType.Wildcards, Me.txtFirstName.Text.Trim & "*"))
        End If
        If Me.txtExtension.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.Extension, ContactFilterType.Wildcards, Me.txtExtension.Text.Trim & "*"))
        End If

        Return filter
    End Function

    Public Function GetUserStatus(ByVal UserId As String) As String
        _userStatuses = Session("IceUserStatusList")
        If Not _userStatuses Is Nothing Then
            _userStatuses.GetUserStatus(UserId)
            Return _userStatuses.GetUserStatus(UserId).StatusMessageDetails.MessageText
        Else
            Return "Unknown"
        End If
    End Function

    Protected Sub grdPhoneBook_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdPhoneBook.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim userId As String = CType(e.Row.DataItem, ContactEntry).UserId

            _userStatuses = Session("IceUserStatusList")

            Dim userst As UserStatus = Nothing
            If Not _userStatuses Is Nothing Then
                userst = _userStatuses.GetUserStatus(userId)
            End If

            Dim ctl As Label = e.Row.Cells(6).FindControl("lbStatus")
            Dim img As Image = e.Row.Cells(6).FindControl("ImgStatus")
            Dim lnk As LinkButton = e.Row.Cells(2).FindControl("lnkExt")
            Dim lblTimeInStatus As Label = e.Row.Cells(7).FindControl("lblTimeInStatus")
            Dim lblOnPhone As Label = e.Row.Cells(8).FindControl("lblOnPhone")
            Dim lblLoggedIn As Label = e.Row.Cells(9).FindControl("lblLoggedIn")

            If Not User Is Nothing Then
                ctl.Text = userst.StatusMessageDetails.MessageText
                img.visible = False
                img.ImageUrl = "" '"file:\\\" & userst.StatusMessageDetails.IconFileName
                lblOnPhone.Text = IIf(userst.OnPhone, "Yes", "")
                If userst.StatusChangedHasValue Then
                    Dim ts As TimeSpan = Now.Subtract(userst.StatusChanged)
                    lblTimeInStatus.Text = String.Format("{0}d:{1:D2}:{2:D2}:{3:D2}", ts.Days, ts.Hours, ts.Minutes, ts.Seconds)
                Else
                    lblTimeInStatus.Text = ""
                End If
                lblLoggedIn.Text = IIf(userst.LoggedIn, "Yes", "No")
            Else
                img.ImageUrl = ""
                ctl.Text = "Unknown"
                lblOnPhone.Text = ""
                lblTimeInStatus.Text = ""
                lblLoggedIn.Text = ""
            End If

            'Set filter
            Dim visible As Boolean = True
            If Me.txtStatus.Text.Trim.Length > 0 Then
                visible = ctl.Text.Trim.ToLower.StartsWith(Me.txtStatus.Text.Trim.ToLower) AndAlso IIf(chkNotOnPhone.Checked, userst.OnPhone = False, True) AndAlso IIf(chkLoggedIn.Checked, userst.LoggedIn = True, True)
            End If

            e.Row.Visible = visible AndAlso IIf(chkNotOnPhone.Checked, userst.OnPhone = False, True) AndAlso IIf(chkLoggedIn.Checked, userst.LoggedIn = True, True)

        End If

    End Sub

    Protected Sub Timer5_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer5.Tick
        DisplayDirectory(Me.ddlWorkGroupQueues.SelectedValue)
    End Sub

    Private Sub LogUseEvent()
        Dim uInfo As UserInfo = Session("IceUserInfo")
        Try
            CallControlsHelper.InsertCallEvent(Nothing, Nothing, "LookupOpened", uInfo.UserID)
        Catch ex As Exception
            LogException("[SM]LogLookup: " & ex.Message, uInfo)
        End Try
    End Sub

    Private Sub LogException(ByVal Message As String, ByVal uInfo As UserInfo)
        Try
            CallControlsHelper.InsertCallMessageLog(Message, uInfo.UserID)
        Catch ex As Exception
            'Do nothing
        End Try
    End Sub

    Private Sub LoadQueues()
        Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim UserGroupID As Integer = DataHelper.FieldLookup("tblUser", "UserGroupID", "Userid = " & UserID)
        Dim DefaultTransferQueue As String = DataHelper.FieldLookup("tblUserGroup", "DefaultTransferQueue", "UserGroupId = " & UserGroupID)
        If Not DefaultTransferQueue Is Nothing AndAlso DefaultTransferQueue.Trim.Length = 0 Then
            DefaultTransferQueue = "NotSet"
        End If
        Me.ddlWorkGroupQueues.DataSource = ConnectionContext.GetWorkGroupQueues(DefaultTransferQueue)
        Me.ddlWorkGroupQueues.DataTextField = "workgroup"
        Me.ddlWorkGroupQueues.DataValueField = "workgroup"
        Me.ddlWorkGroupQueues.DataBind()
    End Sub

    Private Function GetOneAvailableInQueue(ByVal WorkGroupName As String) As String
        Dim usersAv As New List(Of UserDetail)
        Dim directoryMan = DirectoriesManager.GetInstance(_session)
        Dim dirConfig As DirectoryConfiguration = New DirectoryConfiguration(directoryMan)
        If Not dirConfig.IsWatching Then dirConfig.StartWatching()

        Dim meta As DirectoryMetadata = dirConfig.GetList(0)
        Dim contactDir As New ContactDirectory(directoryMan, meta)
        Dim filter As New Collection(Of ContactFilterItem)

        filter.Add(New ContactFilterMatch(ContactProperty.Workgroups, ContactFilterType.Wildcards, "*" & Me.ddlWorkGroupQueues.SelectedValue & "*"))
        Dim filterItems As Collection(Of ContactFilterItem) = filter

        Dim sortItems As New Collection(Of ContactSortItem)

        Dim watchsetts As New ContactDirectoryWatchSettings(0, 9999, filterItems, sortItems)
        If Not contactDir.IsWatching Then contactDir.StartWatching(watchsetts)

        Dim entries As ReadOnlyCollection(Of ContactEntry) = contactDir.GetList()
        _userStatuses = Session("IceUserStatusList")

        Dim st As UserStatus
        For Each entry As ContactEntry In entries
            st = _userStatuses.GetUserStatus(entry.UserId)
            If st.LoggedIn AndAlso Not st.OnPhone AndAlso st.StatusMessageDetails.MessageText.ToLower.Contains("available") Then
                usersAv.Add(New UserDetail(entry.FirstName, entry.LastName, entry.Extension, st))
            End If
        Next

        If usersAv.Count > 0 Then
            Dim index As Integer = CInt(Int(usersAv.Count * Rnd()))
            index = CInt(Int(usersAv.Count * Rnd()))
            Return usersAv.Item(index).Extension
        End If

        Return ""
    End Function

    Private Sub TransferToAvailable(ByVal WorkGroupName As String)
        Dim ext As String = GetOneAvailableInQueue(WorkGroupName)
        If ext.Trim.Length > 0 Then
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "ExprTransfer", String.Format("CloseDialog('{0}', 'transfer');", ext), True)
        Else
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "NoAvailableTransfers", "alert('No one is available to accept calls in that group');", True)
        End If
    End Sub

    Protected Sub ddlWorkGroupQueues_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlWorkGroupQueues.SelectedIndexChanged
        DisplayDirectory(ddlWorkGroupQueues.SelectedValue)
        Me.updContact.Update()
    End Sub

    Protected Sub ImgExpTrans_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImgExpTrans.Click
        Try
            TransferToAvailable(Me.ddlWorkGroupQueues.SelectedValue)
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me.Page, GetType(Page), "ErrPerm", String.Format("alert('{0}');", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

End Class
