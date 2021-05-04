Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO

Imports AnalyticsHelper

Imports ReturnsHelper

Partial Class admin_returns
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _buyers As New Dictionary(Of Integer, String)
    Private _userid As Integer
    Dim gridSummary As New Hashtable
#End Region 'Fields

#Region "Properties"

    Public Property Buyers() As Dictionary(Of Integer, String)
        Get
            If IsNothing(ViewState("_buyers")) Then
                ViewState("_buyers") = New Dictionary(Of Integer, String)
            End If

            Return ViewState("_buyers")
        End Get
        Set(ByVal value As Dictionary(Of Integer, String))
            ViewState("_buyers") = value
        End Set
    End Property

    Public Property CurrentFilePath() As String
        Get
            Return ViewState("_CurrentFilePath")
        End Get
        Set(ByVal value As String)
            ViewState("_CurrentFilePath") = value
        End Set
    End Property

    Public Property FromDate() As String
        Get
            If String.IsNullOrEmpty(txtFrom.Text) Then
                txtFrom.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtFrom.Text
        End Get
        Set(ByVal value As String)
            txtFrom.Text = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            If String.IsNullOrEmpty(txtTo.Text) Then
                txtTo.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtTo.Text
        End Get
        Set(ByVal value As String)
            txtTo.Text = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Protected Sub admin_returns_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
        If Not IsPostBack Then
            SetDates()

            BindData()
        End If
    End Sub
    Private Sub BindData()
        dsValidate.SelectParameters("from").DefaultValue = txtFrom.Text
        dsValidate.SelectParameters("to").DefaultValue = txtTo.Text
        dsValidate.DataBind()
        gvValidate.DataBind()
    End Sub

    

    Private Sub SetDates()
        'This week
        FromDate = Now.ToString("MM/dd/yyyy")
        ToDate = Now.ToString("MM/dd/yyyy")

        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub
    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click


    End Sub
    Private Sub ShowToastFromCodeBehind(ByVal msgText As String, Optional msgType As String = "success", Optional bSticky As Boolean = False)
        Dim sb As New StringBuilder()
        sb.Append("$(function() { ")
        sb.AppendFormat("   showToast('{0}', '{1}',{2});", msgText, msgType, bSticky.ToString.ToLower)
        sb.Append("});")

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If sm.IsInAsyncPostBack Then
            ScriptManager.RegisterStartupScript(Page, Me.GetType, "myscript", sb.ToString(), True)
        End If
    End Sub

#End Region 'Methods

    Protected Sub lnkGetCounts_Click(sender As Object, e As System.EventArgs) Handles lnkGetCounts.Click
        dsValidate.SelectParameters("from").DefaultValue = txtFrom.Text
        dsValidate.SelectParameters("to").DefaultValue = txtTo.Text
        dsValidate.DataBind()
        gvValidate.DataBind()
    End Sub

    Protected Sub admin_returns_PreRender(sender As Object, e As System.EventArgs) Handles Me.PreRender
        GridViewHelper.AddJqueryUI(gvValidate)
    End Sub

    Protected Sub dsValidate_Selecting(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles dsValidate.Selecting
        e.Command.CommandTimeout = 300
    End Sub

    Protected Sub gvValidate_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvValidate.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)

                If gridSummary.ContainsKey("Price") Then
                    gridSummary("Price") += Double.Parse(rowview("price").ToString)
                Else
                    gridSummary.Add("Price", Double.Parse(rowview("price").ToString))
                End If
                If gridSummary.ContainsKey("Revenue") Then
                    gridSummary("Revenue") += Double.Parse(rowview("Revenue").ToString)
                Else
                    gridSummary.Add("Revenue", Double.Parse(rowview("Revenue").ToString))
                End If
                If gridSummary.ContainsKey("Total") Then
                    gridSummary("Total") += Double.Parse(rowview("Total").ToString)
                Else
                    gridSummary.Add("Total", Double.Parse(rowview("Total").ToString))
                End If
                If gridSummary.ContainsKey("Valid") Then
                    gridSummary("Valid") += Double.Parse(rowview("Valid").ToString)
                Else
                    gridSummary.Add("Valid", Double.Parse(rowview("Valid").ToString))
                End If
                If gridSummary.ContainsKey("Returned") Then
                    gridSummary("Returned") += Double.Parse(rowview("Returned").ToString)
                Else
                    gridSummary.Add("Returned", Double.Parse(rowview("Returned").ToString))
                End If
                If gridSummary.ContainsKey("PctValid") Then
                    gridSummary("PctValid") += Double.Parse(rowview("PctValid").ToString)
                Else
                    gridSummary.Add("PctValid", Double.Parse(rowview("PctValid").ToString))
                End If
            Case DataControlRowType.Footer
                e.Row.Cells(3).Text = FormatCurrency(gridSummary("Price").ToString / gvValidate.Rows.Count, 2, TriState.False, TriState.False, TriState.True)
                e.Row.Cells(4).Text = FormatCurrency(gridSummary("Revenue").ToString, 2, TriState.False, TriState.False, TriState.True)
                e.Row.Cells(5).Text = gridSummary("Total").ToString
                e.Row.Cells(6).Text = gridSummary("Valid").ToString
                e.Row.Cells(7).Text = gridSummary("Returned").ToString
                e.Row.Cells(8).Text = FormatPercent(gridSummary("Valid").ToString / gridSummary("Total").ToString, 2)


        End Select
    End Sub
End Class