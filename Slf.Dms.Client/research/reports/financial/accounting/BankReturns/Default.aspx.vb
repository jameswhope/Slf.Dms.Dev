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

        With grdReturned
            ' Assign the data source to the grid and bind it.
            .DataSource = Nothing
            .DataSourceID = Nothing
            .DataSource = dsReturns
            .DataBind()
            ' Setup the columns
            .Columns(0).Visible = False
            .Columns(1).Visible = False
        End With

        Me.lblCount.Text = "Selection Count: " & grdReturned.Rows.Count

    End Sub

#End Region

End Class
