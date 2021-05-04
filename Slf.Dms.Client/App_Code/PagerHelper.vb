Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.Collections.Generic

Public Class PagerHelper

    Public Shared Sub SetPage(ByVal pager As IPagerWrapper, ByVal page As Integer)
        If DataHelper.Nz_int(page) <= 0 Then
            SetRedirectPage(pager.Context, 0, pager.QsId)
        Else
            SetRedirectPage(pager.Context, page - 1, pager.QsId)
        End If
    End Sub
    Public Shared Sub First(ByVal pager As IPagerWrapper)
        SetRedirectPage(pager.Context, 0, pager.QsId)
    End Sub
    Public Shared Sub Last(ByVal pager As IPagerWrapper)
        SetRedirectPage(pager.Context, -1, pager.QsId)
    End Sub
    Public Shared Sub [Next](ByVal pager As IPagerWrapper)
        Dim PageIndex As Integer = DataHelper.Nz_int(pager.Context.Request.QueryString(pager.QsId))
        SetRedirectPage(pager.Context, PageIndex + 1, pager.QsId)
    End Sub
    Public Shared Sub Previous(ByVal pager As IPagerWrapper)
        Dim PageIndex As Integer = DataHelper.Nz_int(pager.Context.Request.QueryString(pager.QsId))
        SetRedirectPage(pager.Context, PageIndex - 1, pager.QsId)
    End Sub
    Public Structure HandleResult
        Dim LastPage As Boolean
    End Structure
    Private Shared Function Handle(ByVal c As ICollection, ByVal rp As Repeater, ByVal pager As PagerWrapper, ByVal PageSize As Integer) As HandleResult
        Dim hr As New HandleResult

        DisableBackSelectors(pager, True)
        DisableForwardSelectors(pager, True)

        Dim PageIndex As Integer = DataHelper.Nz_int(pager.Context.Request.QueryString(pager.QsId))
        Dim searchCount As Integer = c.Count

        If c.Count > 0 Then

            If PageIndex * PageSize >= c.Count Then
                PageIndex = -1
            End If

            If PageIndex = -1 Then

                PageIndex = ((c.Count) \ PageSize)

                SetRedirectPage(pager.Context, PageIndex, pager.QsId)

            End If

            If PageIndex = 0 Then
                DisableBackSelectors(pager)
            End If

            If PageIndex = ((c.Count) \ PageSize) Then
                DisableForwardSelectors(pager)
                hr.LastPage = True
            End If

            pager.txtPageNumber.Text = PageIndex + 1
            pager.lblPageCount.Text = ((c.Count) \ PageSize) + 1.ToString()

            If pager.lblPageCount.Text = 0 Then

                pager.lblPageCount.Text = 1

                DisableBackSelectors(pager)
                DisableForwardSelectors(pager)
                hr.LastPage = True

            End If

            Dim l As List(Of Object) = SetPage(c, PageIndex, PageSize)

            rp.DataSource = l
            rp.DataBind()

        Else

            pager.txtPageNumber.Text = 0
            pager.lblPageCount.Text = 0

            DisableBackSelectors(pager)
            DisableForwardSelectors(pager)

            pager.txtPageNumber.Enabled = False

        End If

        rp.Visible = c.Count > 0

        Return hr
    End Function

    Private Shared Function Handle(ByVal c As ICollection, ByVal rp As Repeater, ByVal pager As SmallPagerWrapper, ByVal PageSize As Integer) As HandleResult
        Dim hr As New HandleResult

        Dim searchCount As Integer = c.Count
        Dim PageIndex As Integer = DataHelper.Nz_int(pager.Context.Request.QueryString(pager.QsId))
        If c.Count > 0 Then

            If PageIndex * PageSize > (c.Count + c.Count Mod 2) Then
                PageIndex = 0
            End If

            If PageIndex = -1 Then

                PageIndex = ((c.Count + c.Count Mod 2) \ PageSize)

                SetRedirectPage(pager.Context, PageIndex, pager.QsId)

            End If

            If PageIndex = 0 Then
                pager.lnkFirst.Enabled = False
                pager.lnkPrevious.Enabled = False
            End If

            If PageIndex = ((c.Count + c.Count Mod 2) \ PageSize) Then
                pager.lnkLast.Enabled = False
                pager.lnkNext.Enabled = False
                hr.LastPage = True
            End If

            If c.Count <= PageSize Then
                pager.lnkFirst.Visible = False
                pager.lnkNext.Visible = False
                pager.lnkLast.Visible = False
                pager.lnkPrevious.Visible = False
                pager.lblPage.Visible = False
                hr.LastPage = True
            End If

            pager.lblPage.Text = " Page " + (PageIndex + 1).ToString() + " of " + (((c.Count + c.Count Mod 2) \ PageSize) + 1).ToString()

            Dim l As List(Of Object) = SetPage(c, PageIndex, PageSize)

            rp.DataSource = l
            rp.DataBind()

        End If
        Return hr
    End Function

    Public Shared Function Handle(ByVal c As ICollection, ByVal rp As Repeater, ByVal pager As IPagerWrapper, ByVal PageSize As Integer) As HandleResult
        If TypeOf pager Is SmallPagerWrapper Then
            Return Handle(c, rp, CType(pager, SmallPagerWrapper), PageSize)
        ElseIf TypeOf pager Is PagerWrapper Then
            Return Handle(c, rp, CType(pager, PagerWrapper), PageSize)
        End If
    End Function

    Private Shared Sub DisableBackSelectors(ByVal pager As PagerWrapper, ByVal bOn As Boolean)

        pager.lnkFirst.Enabled = bOn
        pager.lnkPrevious.Enabled = bOn

        If bOn Then
            pager.imgFirst.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_first.png")
            pager.imgPrevious.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_prev.png")
        Else
            pager.imgFirst.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_first_gray.png")
            pager.imgPrevious.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_prev_gray.png")
        End If

    End Sub
    Private Shared Sub DisableForwardSelectors(ByVal pager As PagerWrapper, ByVal bOn As Boolean)

        pager.lnkLast.Enabled = bOn
        pager.lnkNext.Enabled = bOn
        If bOn Then
            pager.imgLast.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_last.png")
            pager.imgNext.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_next.png")
        Else
            pager.imgLast.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_last_gray.png")
            pager.imgNext.Src = pager.imgFirst.ResolveUrl("~/images/16x16_selector_next_gray.png")
        End If

    End Sub
    Private Shared Sub DisableBackSelectors(ByVal pager As PagerWrapper)

        DisableBackSelectors(pager, False)

    End Sub
    Private Shared Sub DisableForwardSelectors(ByVal pager As PagerWrapper)

        DisableForwardSelectors(pager, False)

    End Sub
    
    Private Shared Function SetPage(ByVal col As IList, ByVal index As Integer, ByVal size As Integer) As List(Of Object)
        Dim l As New List(Of Object)

        Dim i1 As Integer = Math.Min(index * size, col.Count - 1)
        Dim i2 As Integer = Math.Min(i1 + size - 1, col.Count - 1)

        For i As Integer = i1 To i2
            l.Add(col(i))
        Next

        Return l
    End Function
    Private Shared Sub SetRedirectPage(ByVal context As HttpContext, ByVal index As Integer, ByVal type As String)

        Dim qsb As New QueryStringBuilder(context.Request.Url.Query)

        qsb(type) = index.ToString()

        Dim page As String = context.Request.Url.AbsolutePath.Substring(context.Request.Url.AbsolutePath.LastIndexOf("/"c) + 1)

        context.Response.Redirect(page & IIf(qsb.QueryString.Length > 0, "?" & qsb.QueryString, String.Empty))

    End Sub
End Class
Public Interface IPagerWrapper
    Property Context() As HttpContext
    Property QsId() As String
End Interface
Public Class PagerWrapper
    Implements IPagerWrapper

    Private _lnkFirst As LinkButton
    Private _lnkPrevious As LinkButton
    Private _lnkNext As LinkButton
    Private _lnkLast As LinkButton
    Private _imgFirst As HtmlImage
    Private _imgPrevious As HtmlImage
    Private _imgNext As HtmlImage
    Private _imgLast As HtmlImage
    Private _txtPageNumber As TextBox
    Private _lblPageCount As Label
    Private _context As HttpContext
    Private _qsid As String

    Public Sub New(ByVal lnkFirst As LinkButton, ByVal lnkPrevious As LinkButton, ByVal lnkNext As LinkButton, ByVal lnkLast As LinkButton, ByVal imgFirst As HtmlImage, ByVal imgPrevious As HtmlImage, ByVal imgNext As HtmlImage, ByVal imgLast As HtmlImage, ByVal txtPageNumber As TextBox, ByVal lblPageCount As Label, ByVal context As HttpContext, ByVal QsId As String)
        _lnkFirst = lnkFirst
        _lnkLast = lnkLast
        _lnkNext = lnkNext
        _lnkPrevious = lnkPrevious
        _txtPageNumber = txtPageNumber
        _lblPageCount = lblPageCount
        _imgFirst = imgFirst
        _imgNext = imgNext
        _imgPrevious = imgPrevious
        _imgLast = imgLast
        _context = context
        _qsid = QsId
    End Sub
    Public Sub SetPage(ByVal page As Integer)
        PagerHelper.SetPage(Me, page)
    End Sub
    Public Sub First()
        PagerHelper.First(Me)
    End Sub
    Public Sub [Next]()
        PagerHelper.Next(Me)
    End Sub
    Public Sub Previous()
        PagerHelper.Previous(Me)
    End Sub
    Public Sub Last()
        PagerHelper.Last(Me)
    End Sub

    Public Property QsId() As String Implements IPagerWrapper.QsId
        Get
            Return _qsid
        End Get
        Set(ByVal value As String)
            _qsid = value
        End Set
    End Property

    Public Property Context() As HttpContext Implements IPagerWrapper.Context
        Get
            Return _context
        End Get
        Set(ByVal value As HttpContext)
            _context = value
        End Set
    End Property
    Public Property imgFirst() As HtmlImage
        Get
            Return _imgFirst
        End Get
        Set(ByVal value As HtmlImage)
            _imgFirst = value
        End Set
    End Property
    Public Property imgPrevious() As HtmlImage
        Get
            Return _imgPrevious
        End Get
        Set(ByVal value As HtmlImage)
            _imgPrevious = value
        End Set
    End Property
    Public Property imgNext() As HtmlImage
        Get
            Return _imgNext
        End Get
        Set(ByVal value As HtmlImage)
            _imgNext = value
        End Set
    End Property
    Public Property imgLast() As HtmlImage
        Get
            Return _imgLast
        End Get
        Set(ByVal value As HtmlImage)
            _imgLast = value
        End Set
    End Property

    Public Property lnkFirst() As LinkButton
        Get
            Return _lnkFirst
        End Get
        Set(ByVal value As LinkButton)
            _lnkFirst = value
        End Set
    End Property
    Public Property lnkPrevious() As LinkButton
        Get
            Return _lnkPrevious
        End Get
        Set(ByVal value As LinkButton)
            _lnkPrevious = value
        End Set
    End Property
    Public Property lnkNext() As LinkButton
        Get
            Return _lnkNext
        End Get
        Set(ByVal value As LinkButton)
            _lnkNext = value
        End Set
    End Property
    Public Property lnkLast() As LinkButton
        Get
            Return _lnkLast
        End Get
        Set(ByVal value As LinkButton)
            _lnkLast = value
        End Set
    End Property
    Public Property txtPageNumber() As TextBox
        Get
            Return _txtPageNumber
        End Get
        Set(ByVal value As TextBox)
            _txtPageNumber = value
        End Set
    End Property
    Public Property lblPageCount() As Label
        Get
            Return _lblPageCount
        End Get
        Set(ByVal value As Label)
            _lblPageCount = value
        End Set
    End Property
End Class
Public Class SmallPagerWrapper
    Implements IPagerWrapper

    Private _lnkFirst As LinkButton
    Private _lnkPrevious As LinkButton
    Private _lnkNext As LinkButton
    Private _lnkLast As LinkButton
    
    Private _lblPage As Label
    Private _context As HttpContext
    Private _qsid As String

    Public Sub New(ByVal lnkFirst As LinkButton, ByVal lnkPrevious As LinkButton, ByVal lnkNext As LinkButton, ByVal lnkLast As LinkButton, ByVal lblPage As Label, ByVal context As HttpContext, ByVal QsId As String)
        _lnkFirst = lnkFirst
        _lnkLast = lnkLast
        _lnkNext = lnkNext
        _lnkPrevious = lnkPrevious

        _lblPage = lblPage

        _context = context
        _qsid = QsId
    End Sub

    Public Sub SetPage(ByVal page As Integer)
        PagerHelper.SetPage(Me, page)
    End Sub
    Public Sub First()
        PagerHelper.First(Me)
    End Sub
    Public Sub [Next]()
        PagerHelper.Next(Me)
    End Sub
    Public Sub Previous()
        PagerHelper.Previous(Me)
    End Sub
    Public Sub Last()
        PagerHelper.Last(Me)
    End Sub

    Public Property QsId() As String Implements IPagerWrapper.QsId
        Get
            Return _qsid
        End Get
        Set(ByVal value As String)
            _qsid = value
        End Set
    End Property

    Public Property Context() As HttpContext Implements IPagerWrapper.Context
        Get
            Return _context
        End Get
        Set(ByVal value As HttpContext)
            _context = value
        End Set
    End Property
   

    Public Property lnkFirst() As LinkButton
        Get
            Return _lnkFirst
        End Get
        Set(ByVal value As LinkButton)
            _lnkFirst = value
        End Set
    End Property
    Public Property lnkPrevious() As LinkButton
        Get
            Return _lnkPrevious
        End Get
        Set(ByVal value As LinkButton)
            _lnkPrevious = value
        End Set
    End Property
    Public Property lnkNext() As LinkButton
        Get
            Return _lnkNext
        End Get
        Set(ByVal value As LinkButton)
            _lnkNext = value
        End Set
    End Property
    Public Property lnkLast() As LinkButton
        Get
            Return _lnkLast
        End Get
        Set(ByVal value As LinkButton)
            _lnkLast = value
        End Set
    End Property
    Public Property lblPage() As Label
        Get
            Return _lblPage
        End Get
        Set(ByVal value As Label)
            _lblPage = value
        End Set
    End Property
End Class