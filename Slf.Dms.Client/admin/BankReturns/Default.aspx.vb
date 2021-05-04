Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports Infragistics.WebUI.UltraWebGrid

Partial Class admin_BankReturns_Default
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private c_cnDatabase As New OleDb.OleDbConnection()
    Private c_blnSortColumnName As String = ""
    Private c_blnSortAscending As Boolean = True

#End Region

#Region "Page routines"

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        'With Me.grdReturnedItems.DisplayLayout.Bands(0)
        '    If c_blnSortColumnName <> "" Then
        '        If c_blnSortColumnName = "u.LastName" Then
        '            c_blnSortColumnName = "Rep"
        '        End If
        '        If c_blnSortAscending = True Then
        '            .Columns.FromKey(c_blnSortColumnName).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Ascending
        '        Else
        '            .Columns.FromKey(c_blnSortColumnName).SortIndicator = Infragistics.WebUI.UltraWebGrid.SortIndicator.Descending
        '        End If
        '    Else
        '        Dim i As Integer
        '        For i = 2 To .Columns.Count - 1
        '            .Columns.Item(i).SortIndicator = SortIndicator.None
        '        Next
        '    End If
        'End With
    End Sub

    Protected Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        ' Who's making the changes
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        ' On postback don't do anything yet else inatilize the data
        If IsPostBack Then

        Else
            InitalizeData()
            dtStartDate.Text = Format(Now, "MM/dd/yyyy").ToString()
            dtEndDate.Text = Format(Now.AddDays(1), "MM/dd/yyyy").ToString()
        End If

    End Sub

    Protected Sub InitalizeData()

        'Clients
        'Me.ddlClientName.DataSource = Nothing
        'Me.ddlClientName.DataSource = NOCHelper.GetClients(NOCHelper.GetClientSQL, "Clients")
        'Me.ddlClientName.DataBind()

    End Sub

    Public Sub View_Run(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        Dim Flags As Boolean = False
        Dim intClientID As Integer = -1
        Dim dtStartDate As Date
        Dim dtEndDate As Date
        Dim strAccountNo As String = ""
        Dim i As Integer = 0
        Dim dsReturns As DataSet = Nothing

        'Assign the variables for the SQL statement
        If CInt(Val(Me.hdnClientID.Value)) > 0 Then
            intClientID = CInt(Me.hdnClientID.Value)
        End If
        If intClientID > 5008 Then
            Flags = True
        Else
            intClientID = 0
        End If

        If Not Me.hdnStartDate.Value = "" Then
            dtStartDate = "#" & Me.hdnStartDate.Value & "#"
        End If
        If Len(dtStartDate) = 8 Then Flags = True

        If Not Me.hdnEndDate.Value = "" Then
            dtEndDate = "#" & Me.hdnEndDate.Value & "#"
        End If
        If Len(dtEndDate) = 8 Then Flags = True

        If Not Me.hdnAccountNo.Value = "" Then
            strAccountNo = Me.hdnAccountNo.Value
        End If
        If strAccountNo <> "" Then Flags = True

        'Make a report
        Dim dtReturns As DataTable = NOCHelper.BuildReportSQL(Format(dtStartDate, "MM/dd/yyyy"), Flags, Format(dtEndDate, "MM/dd/yyyy"), strAccountNo, intClientID)
        dsReturns = New DataSet("ReturnedItems")
        dsReturns.Tables.Add(dtReturns)

        With grdReturnedItems
            ' Assign the data source to the grid and bind it.
            .Clear()
            .ResetColumns()
            .DataSourceID = Nothing
            .DataSource = dsReturns
            .DataBind()

            ' Setup the columns
            .Columns(0).Hidden = True
            .Columns(0).Key = "col0Data"
            .Columns(1).Hidden = True

            For i = 2 To .Columns.Count - 1
                .Columns(i).Header.Style.Font.Bold = False
                .Columns(i).Header.Style.Font.Name = "Tahoma"
                .Columns(i).Header.Style.Font.Size = "10"
                .Columns(i).Header.Style.Height = "25"
                .Columns(i).AllowUpdate = AllowUpdate.No
                .Columns(i).AllowRowFiltering = False
            Next

            .Columns(2).Width = "125"
            .Columns(2).Header.Caption = "Lexx-Account"
            .Columns(2).FilterIcon = Infragistics.WebUI.Shared.DefaultableBoolean.NotSet
            .Columns(2).Key = "Lexx-Account"

            .Columns(3).Width = "150"
            .Columns(3).Header.Caption = "Client Name"

            .Columns(4).Header.Caption = "Routing No"
            .Columns(4).Width = "75"

            .Columns(5).Header.Caption = "Account No"
            .Columns(5).Width = "125"

            .Columns(6).Header.Caption = "Amount"
            .Columns(6).Width = "100"
            .Columns(6).Format = "$ ###,###,##0.00"

            .Columns(7).Header.Caption = "Law Firm"
            .Columns(7).Width = "200"

            .Columns(8).Header.Caption = "Settlement"
            .Columns(8).Width = "75"

            .Columns(9).Header.Caption = "Reason"
            .Columns(9).Width = "250"

            .DisplayLayout.ViewType = ViewType.Flat
        End With

        Me.lblCount.Text = "Selection Count: " & grdReturnedItems.Rows.Count

    End Sub

    Protected Sub grdReturnedItems_InitializeRow(ByVal sender As Object, ByVal e As RowEventArgs) Handles grdReturnedItems.InitializeRow
        If IsPostBack Then
            Dim ClientID As Integer = e.Row.Cells.FromKey("ClientID").Value
            e.Row.Cells.FromKey("AccountNo").TargetURL = "..\..\Clients\Client\Finances\Default.aspx?id=" & ClientID
        End If
    End Sub

#End Region
End Class
