Imports ININ.IceLib.Directories
Imports ININ.IceLib.Connection
Imports System.Collections.ObjectModel
Imports ININ.IceLib.People


Partial Class CallControls_PhoneBook
    Inherits System.Web.UI.Page

    Private _session As ININ.IceLib.Connection.Session
    Private _directoryMan As DirectoriesManager
    Private _contactDir As ContactDirectory
    Private _userStatuses As UserStatusList


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LogUseEvent()
            DisplayDirectory()
            Timer1.Enabled = True
        End If
    End Sub

    Private Sub DisplayDirectory()
        _session = Session("IceSession")

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
        If Me.txtLastName.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.LastName, ContactFilterType.Wildcards, Me.txtLastName.Text.Trim & "*"))
        End If
        If Me.txtFirstName.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.FirstName, ContactFilterType.Wildcards, Me.txtFirstName.Text.Trim & "*"))
        End If
        If Me.txtExtension.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.Extension, ContactFilterType.Wildcards, Me.txtExtension.Text.Trim & "*"))
        End If
        If Me.txtDepartment.Text.Trim.Length > 0 Then
            filter.Add(New ContactFilterMatch(ContactProperty.Department, ContactFilterType.Wildcards, Me.txtDepartment.Text.Trim & "*"))
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

            Dim ctl As Label = e.Row.Cells(5).FindControl("lbStatus")
            Dim img As Image = e.Row.Cells(5).FindControl("ImgStatus")
            Dim lblTimeInStatus As Label = e.Row.Cells(6).FindControl("lblTimeInStatus")
            Dim lblOnPhone As Label = e.Row.Cells(7).FindControl("lblOnPhone")
            Dim lblLoggedIn As Label = e.Row.Cells(8).FindControl("lblLoggedIn")

            If Not userst Is Nothing Then
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
            If Me.txtStatus.Text.Trim.Length > 0 Then
                e.Row.Visible = ctl.Text.ToLower.Contains(Me.txtStatus.Text.ToLower.Trim)
            End If
        End If

    End Sub

    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        DisplayDirectory()
    End Sub

    Private Sub LogUseEvent()
        Dim uInfo As UserInfo = Session("IceUserInfo")
        Try
            CallControlsHelper.InsertCallEvent(Nothing, Nothing, "DirectoryOpened", uInfo.UserID)
        Catch ex As Exception
            LogException("[SM]LogOpenDirectory: " & ex.Message, uInfo)
        End Try
    End Sub

    Private Sub LogException(ByVal Message As String, ByVal uInfo As UserInfo)
        Try
            CallControlsHelper.InsertCallMessageLog(Message, uInfo.UserID)
        Catch ex As Exception
            'Do nothing
        End Try
    End Sub

End Class
