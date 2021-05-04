Imports System.Collections.Generic
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Linq

Partial Class research_reports_financial_servicefees_FeePaidCompare
    Inherits System.Web.UI.Page

    Enum GridSection
        First = 0
        Second = 1
    End Enum

    Private _filters As List(Of ReportFeesFilter)
    Private _NotZeroGridColumns(1) As List(Of String)
    Private _PayeeIds As List(Of String)


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                 GlobalFiles.JQuery.UI, _
                                                 "~/jquery/json2.js", _
                                                 "~/jquery/jquery.multiselect.min.js", _
                                                 "~/jquery/plugins/table2CSV.js", _
                                                 "~/jquery/jquery.modaldialog.js" _
                                                 })

        Initialize()

        If Not Me.IsPostBack Then
            LoadCompanys()
            LoadAgencies()
            LoadPayees()
        End If

    End Sub

    Private Sub Initialize()
        _NotZeroGridColumns(GridSection.First) = New List(Of String)
        _NotZeroGridColumns(GridSection.Second) = New List(Of String)
    End Sub

    Private Sub LoadCompanys()
        Dim co As New Drg.Util.DataHelpers.CompanyHelper
        Me.ddlCompany.DataSource = co.CompanyList()
        Me.ddlCompany.DataValueField = "companyid"
        Me.ddlCompany.DataTextField = "shortconame"
        Me.ddlCompany.DataBind()
    End Sub

    Private Sub LoadAgencies()
        Dim ag As New Drg.Util.DataHelpers.AgencyHelper
        Me.ddlAgency.DataSource = ag.GetAgencies
        Me.ddlAgency.DataValueField = "agencyid"
        Me.ddlAgency.DataTextField = "code"
        Me.ddlAgency.DataBind()
    End Sub

    Private Sub LoadPayees()
        Dim cm As New Drg.Util.DataHelpers.CommissionHelper
        Dim crecs = From cr As DataRow In cm.GetCommRecs(-1).Rows _
                    Order By cr("abbreviation"), cr("commrecid") _
                    Select New With {.commrecid = cr("commrecid"), .abbreviation = String.Format("{0} ({1})", cr("abbreviation"), cr("commrecid"))}
        Me.ddlCommRec.DataSource = crecs.ToList
        Me.ddlCommRec.DataValueField = "commrecid"
        Me.ddlCommRec.DataTextField = "abbreviation"
        Me.ddlCommRec.DataBind()
    End Sub

    Protected Sub repeatFees_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles repeatFees.ItemDataBound
        Dim filter As ReportFeesFilter = CType(e.Item.DataItem, ReportFeesFilter)
        Dim ctrl As ASP.customtools_usercontrols_rptfeespaid_ascx = e.Item.FindControl("rptFeesCtrl")
        ctrl.LoadData(filter.DateRange1.StartDate, _
                      filter.DateRange1.EndDate, _
                      filter.DateRange2.StartDate, _
                      filter.DateRange2.EndDate, _
                      String.Join(",", filter.CompanyIds), _
                      String.Join(",", filter.AgencyIds), _
                      String.Join(",", filter.CommRecIds), _
                      String.Join(",", _PayeeIds.ToArray), _
                      filter.CombineIniFees)
        _NotZeroGridColumns(GridSection.First).AddRange(ctrl.ColumnsToShow(GridSection.First))
        _NotZeroGridColumns(GridSection.Second).AddRange(ctrl.ColumnsToShow(GridSection.Second))
    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        Dim ser As New JavaScriptSerializer()
        _filters = ser.Deserialize(Of List(Of ReportFeesFilter))(Me.hdnFilter.Value.Trim)
        _PayeeIds = New List(Of String)
        For Each Filter As ReportFeesFilter In _filters
            _PayeeIds.AddRange(Filter.CommRecIds)
        Next
        _PayeeIds = _PayeeIds.Distinct().ToList
        Me.repeatFees.DataSource = _filters
        Me.repeatFees.DataBind()
    End Sub

    Protected Sub repeatFees_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles repeatFees.PreRender
        _NotZeroGridColumns(GridSection.First) = _NotZeroGridColumns(GridSection.First).Distinct.ToList
        _NotZeroGridColumns(GridSection.Second) = _NotZeroGridColumns(GridSection.Second).Distinct.ToList

        Dim ctrl As ASP.customtools_usercontrols_rptfeespaid_ascx
        For Each item As RepeaterItem In Me.repeatFees.Items
            ctrl = item.FindControl("rptFeesCtrl")
            ctrl.RepaintGridColumns(_NotZeroGridColumns)
        Next
    End Sub
End Class

Public Class ReportFeesFilter
    Public Class DateRange
        Public StartDate As DateTime
        Public EndDate As DateTime
    End Class

    Private _DateRange1 As DateRange
    Private _DateRange2 As DateRange
    Private _CompanyIds As String()
    Private _AgencyIds As String()
    Private _CommRecIds As String()
    Private _CombineIniFees As Boolean = False

    Public Property DateRange1() As DateRange
        Get
            Return _DateRange1
        End Get
        Set(ByVal value As DateRange)
            _DateRange1 = value
        End Set
    End Property

    Public Property DateRange2() As DateRange
        Get
            Return _DateRange2
        End Get
        Set(ByVal value As DateRange)
            _DateRange2 = value
        End Set
    End Property

    Public Property CompanyIds() As String()
        Get
            Return _CompanyIds
        End Get
        Set(ByVal value As String())
            _CompanyIds = value
        End Set
    End Property

    Public Property AgencyIds() As String()
        Get
            Return _AgencyIds
        End Get
        Set(ByVal value As String())
            _AgencyIds = value
        End Set
    End Property

    Public Property CommRecIds() As String()
        Get
            Return _CommRecIds
        End Get
        Set(ByVal value As String())
            _CommRecIds = value
        End Set
    End Property

    Public Property CombineIniFees() As Boolean
        Get
            Return _CombineIniFees
        End Get
        Set(ByVal value As Boolean)
            _CombineIniFees = value
        End Set
    End Property


End Class