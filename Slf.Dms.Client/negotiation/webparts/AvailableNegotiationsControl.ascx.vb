Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports SharedFunctions.AsyncDB
Partial Class negotiation_webparts_AvailableNegotiationsControl
    Inherits System.Web.UI.UserControl
#Region "Declares"
    Private UserID As Integer
    Public DataClientID As String
    Public accountID As String
    Private intTotRecords As Integer
    Private Const DisplayColumns As String = "[AccountID],[ClientID], [ApplicantFullName],[ApplicantLastName],[ApplicantFirstName],[currentcreditoraccountnumber] , [FundsAvailable], [CurrentCreditor], [AccountStatus], [CurrentAmount], LastOffer, OfferDirection"
    Public Event LoadSettlement(ByVal sDataClientID As String, ByVal sAccountID As String)
    Public Event ResetGuid(ByVal newNoteID As String)
    Public Event MyAssignments(ByVal count As String)
    Private _ListLocation As LocationOfList
    Public Property ListLocation() As LocationOfList
        Get
            Return _ListLocation
        End Get
        Set(ByVal value As LocationOfList)
            _ListLocation = value
        End Set
    End Property
    Public Enum LocationOfList
        HomePage = 0
        ClientPage = 1
    End Enum
    Public Property noteID() As String
        Get
            Return Me.hdnNoteID.Value
        End Get
        Set(ByVal value As String)
            Me.hdnNoteID.Value = value
        End Set
    End Property

#End Region
#Region "Events"
#Region "Gridview"
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'add row events
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                e.Row.Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + e.Row.RowIndex.ToString))

                'change offer direction image
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim img As Image = e.Row.FindControl("imgDir")
                If Not IsDBNull(rowView("LastOffer")) Then
                    Select Case rowView("offerdirection").ToString
                        Case "Made"
                            img.ImageUrl = "~/negotiation/images/offerout.png"
                        Case "Received"
                            img.ImageUrl = "~/negotiation/images/offerin.png"
                    End Select
                Else
                    img.Visible = False
                End If

                'show last for of acct
                Dim tempAcct As String = rowView("currentcreditoraccountnumber").ToString
                If InStr(tempAcct, "'(duplicate)'") <> 0 Then
                    tempAcct = tempAcct.Replace("'(duplicate)'", "")
                End If
                tempAcct = Right(tempAcct, 4)
                e.Row.Cells(3).Text = tempAcct
        End Select
    End Sub
    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Select Case e.CommandName.ToLower
            Case "select"
                Dim gv As GridView = DirectCast(sender, GridView)
                Dim dk As DataKey = gv.DataKeys(e.CommandArgument)

                Me.hdnIds.Value = dk(1) & ":" & dk(0)

                'if on home page use a redirect if not use web part connection
                Select Case _ListLocation
                    Case LocationOfList.HomePage
                        Page.Response.Redirect("~/negotiation/clients/default.aspx?crid=" & dk(0).ToString & "&cid=" & dk(1).ToString & "&g=" & Me.noteID)

                    Case LocationOfList.ClientPage
                        NegotiationHelper.RegisterClientVisit(dk(1), UserID)
                        RaiseEvent LoadSettlement(dk(1).ToString, dk(0).ToString)
                    Case Else
                End Select
        End Select
    End Sub
    Protected Sub GridView1_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.DataBound
        Select Case Me._ListLocation
            Case LocationOfList.HomePage
            Case LocationOfList.ClientPage
                
        End Select
    End Sub
    Protected Sub GridView1_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.EmptyDataRow
                Select Case Me._ListLocation
                    Case LocationOfList.HomePage
                        e.Row.Controls.Clear()

                        Dim tblCell As New TableCell
                        tblCell.Text = "No accounts assigned!"
                        e.Row.Controls.Add(tblCell)
                        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Center
                        e.Row.Cells(0).ForeColor = System.Drawing.Color.Gray

                End Select
        End Select
    End Sub
    Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)

        Dim sortField As String
        'check session sort direction
        If ViewState("SortDir") = "ASC" Then
            sortField = e.SortExpression & " DESC"
            ViewState("SortDir") = "DESC"
        Else
            sortField = e.SortExpression & " ASC"
            ViewState("SortDir") = "ASC"
        End If
        ViewState("SortField") = sortField

        'Me.LoadData(IIf(ViewState("FilterClause") Is Nothing, Nothing, ViewState("FilterClause")), sortField, Me.GridView1.PageIndex + 1)



    End Sub
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        Session("UserID") = UserID

        If Session("EntityID") Is Nothing Then
            Session("EntityID") = DataHelper.FieldLookup("tblNegotiationEntity ", "NegotiationEntityID", "UserID = " & Session("UserID"))
        End If

        If Not IsPostBack Then
            DataClientID = Request.QueryString("cid")
            accountID = Request.QueryString("crid")
            If accountID Is Nothing And ClientID Is Nothing Then
                Exit Sub
            End If
            Me.hdnIds.Value = DataClientID & ":" & accountID
            Select Case Me.ListLocation
                Case LocationOfList.HomePage
                    'Me.LoadData()
                Case LocationOfList.ClientPage
            End Select
            ViewState("SortDir") = "DESC"
            'ViewState("FilterClause") = Nothing
        End If
        trFilter.Style("display") = "none"
    End Sub
    Protected Sub lnkCloseSession_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseSession.Click
        Select Case Me.ListLocation
            Case LocationOfList.ClientPage
                CloseSession()
            Case LocationOfList.HomePage

        End Select
    End Sub
    Protected Sub ddlPage_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim ddlCurrentPage As DropDownList = DirectCast(sender, DropDownList)

        'Me.LoadData(IIf(ViewState("FilterClause") Is Nothing, Nothing, ViewState("FilterClause")), IIf(ViewState("SortField") Is Nothing, Nothing, ViewState("SortField")), CInt(ddlCurrentPage.SelectedValue))

        ViewState("GridPageIndex") = ddlCurrentPage.SelectedValue

    End Sub
    Protected Sub ibtnFilter_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        If txtFilter.Text.ToString = "" Then Exit Sub

        ViewState("GridPageIndex") = 0

        'build filter exp
        Dim filterExp As String = ddlColumns.SelectedValue & " Like '" & txtFilter.Text & "%'"
        'If ViewState("FilterClause") IsNot Nothing Then
        '    ViewState("FilterClause") = ViewState("FilterClause").ToString & " AND (" & filterExp & ")"
        'Else
        '    ViewState("FilterClause") = filterExp
        'End If


        'Me.LoadData(filterExp, IIf(ViewState("SortField") Is Nothing, Nothing, ViewState("SortField")))

    End Sub
    Protected Sub lnkReset_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Try
            ViewState("GridPageIndex") = 0
            ViewState("FilterClause") = Nothing
            ViewState("SortField") = Nothing
            txtfilter.text = ""
            'Me.LoadData()

        Catch ex As Exception
            Exit Sub
        End Try
    End Sub

#End Region
#Region "Subs"
    Public Sub LoadData(Optional ByVal FilterClause As String = Nothing, Optional ByVal SortCol As String = Nothing, Optional ByVal PageNumber As Integer = 1, Optional ByVal blnOfferAccepted As Boolean = False)
        Dim cnString As String = System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString

        Select Case Me.ListLocation
            Case LocationOfList.HomePage
                Me.GridView1.PageSize = 10
                trFilter.Style("display") = "none"
            Case LocationOfList.ClientPage
                Me.GridView1.PageSize = 13
                trFilter.Style("display") = "block"
        End Select

        ViewState("GridPageIndex") = PageNumber

        If SortCol Is Nothing Then
            SortCol = "lastoffer desc, ApplicantFirstName, ApplicantLastName"
        End If
        If Session("EntityID") IsNot Nothing Then
            If Session("EntityID").ToString <> "" Then
                'add viewstate filter if exists
                If FilterClause IsNot Nothing Then
                    ViewState("FilterClause") = FilterClause
                Else
                    FilterClause = ""
                End If

            Else
                Me.GridView1.DataSourceID = ""
                Me.GridView1.DataSource = Nothing
                Me.GridView1.DataBind()
            End If
        Else
            Me.GridView1.DataSourceID = ""
            Me.GridView1.DataSource = Nothing
            Me.GridView1.DataBind()
        End If
    End Sub
    Public Sub CloseSession()
        'close all open sessions for user
        'DataClientID = Request.QueryString("cid")
        'Dim intNoteIDs As Integer() = DataHelper.FieldLookupIDs("tblNote", "NoteID", String.Format("Value = 'Negotiation Session Started' and (createdby = {0} or lastmodifiedby = {0}) and clientid = {1}", Session("UserID").ToString, DataClientID))
        'If intNoteIDs.Length > 0 Then
        '    NoteHelper.Delete(intNoteIDs)
        'End If
    End Sub
    Public Sub StartSession(ByVal SessionDataClientID As String, ByVal SessionAccountID As String, ByVal SessionUserID As String)
        CloseSession()
        noteID = NoteHelper.InsertNote("Negotiation Session Started", SessionUserID, SessionDataClientID)
        If SessionAccountID = -1 Then
            NoteHelper.RelateNote(noteID, 1, SessionDataClientID)
        Else
            NoteHelper.RelateNote(noteID, 2, SessionAccountID)
        End If

        RaiseEvent ResetGuid(Me.noteID)

    End Sub
#End Region

End Class
