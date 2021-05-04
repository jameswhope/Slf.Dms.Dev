Imports AnalyticsHelper

Partial Class usercontrols_dateBarControl
    Inherits System.Web.UI.UserControl

    #Region "Events"

    Public Event dateBar_Change(ByVal surveyid As Integer, ByVal _From As String, ByVal _To As String)

    #End Region 'Events
    Private _bShowSurveys As Boolean
    Private _bShowSites As Boolean

    Public Property ShowSites() As Boolean
        Get
            Return _bShowSites
        End Get
        Set(ByVal value As Boolean)
            _bShowSites = value
        End Set
    End Property
#Region "Properties"

    Public Property ShowSurveys() As Boolean
        Get
            Return _bShowSurveys
        End Get
        Set(ByVal value As Boolean)
            _bShowSurveys = value
        End Set
    End Property
    Public Property FromDate() As String
        Get
            If String.IsNullOrEmpty(txtDate1.Text) Then
                txtDate1.Text = Now.ToString("M/d/yy")
            End If
            Return txtDate1.Text
        End Get
        Set(ByVal value As String)
            txtDate1.Text = value
        End Set
    End Property

    Public Property SurveyID() As Integer
        Get
            If IsNothing(ddlSurvey.SelectedItem) Then
                Return -1
            Else
                Return ddlSurvey.SelectedItem.Value
            End If

        End Get
        Set(ByVal value As Integer)
            ddlSurvey.SelectedValue = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            If String.IsNullOrEmpty(txtDate2.Text) Then
                txtDate2.Text = Now.ToString("M/d/yy")
            End If
            Return txtDate2.Text
        End Get
        Set(ByVal value As String)
            txtDate2.Text = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub ddlSurvey_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSurvey.SelectedIndexChanged
        RaiseEvent dateBar_Change(SurveyID, FromDate, ToDate)
    End Sub

    Private Sub SetDates()
        'This week
        FromDate = Now.ToString("M/d/yy")
        ToDate = Now.ToString("M/d/yy")

        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yy") & "," & Now.ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yy") & "," & Now.AddDays(-1).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    #End Region 'Methods

    Protected Sub usercontrols_dateBarControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If ShowSurveys = False Then
            lblSurveyName.Style("display") = "none"
            ddlSurvey.Style("display") = "none"
        Else
            lblSurveyName.Style("display") = "inline-block"
            ddlSurvey.Style("display") = "inline-block"
        End If
        If ShowSites = False Then
            ddlSites.Style("display") = "none"
        Else
            ddlSites.Style("display") = "inline-block"
        End If


        If Not IsPostBack Then
            SetDates()
        End If
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        RaiseEvent dateBar_Change(SurveyID, FromDate, ToDate)
    End Sub

End Class