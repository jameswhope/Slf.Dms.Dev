Imports Drg.Util.DataHelpers
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Partial Class processing_webparts_PendingCalculator
    Inherits System.Web.UI.UserControl


#Region "Declares"
    Private SettlementID As Integer
    Private Information As SettlementMatterHelper.SettlementInformation
    Public DataClientID As Integer
    Public AccountID As String
#End Region

#Region "Events"
    ''' <summary>
    ''' Loads the page with GridView Data
    ''' </summary>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.QueryString("id") Is Nothing Then
            SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))
            DataClientID = SettlementMatterHelper.GetClientFromTask(Integer.Parse(Request.QueryString("id")))
        End If

        If Not IsPostBack Then
            ViewState("SortDir") = "DESC"
            BindGrid(DataClientID)
        End If

    End Sub

#End Region

#Region "HistoryGridview"
    ''' <summary>
    ''' Method called to load data when Page is changed
    ''' </summary>
    Protected Sub GridView1_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView1.PageIndexChanging
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "stp_GetPendingSettlementsForClient"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    GridView1.DataSource = ds
                    GridView1.DataBind()
                End If
            End If
        End If

        Me.GridView1.PageIndex = e.NewPageIndex
        Me.GridView1.DataBind()
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f3f3f3'; ")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#ffffff'; this.style.textDecoration = 'none';")
        End Select
    End Sub
    Protected Sub GridView1_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortDir").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New Image()
                        img.ImageUrl = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub

    Protected Sub GridView1_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles GridView1.Sorting
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "stp_GetPendingSettlementsForClient"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim dataView As DataView = New DataView(ds.Tables(0))

                    Dim sortExp As String = "[" & e.SortExpression & "]"

                    If ViewState("SortDir") = "ASC" Then
                        sortExp += " DESC"
                        ViewState("SortDir") = "DESC"
                    Else
                        sortExp += " ASC"
                        ViewState("SortDir") = "ASC"
                    End If

                    dataView.Sort = sortExp
                    Dim dtSort As DataTable = dataView.ToTable
                    GridView1.DataSource = dtSort
                    GridView1.DataBind()
                End If
            End If
        End If

    End Sub

#End Region

#Region "Subs/Funcs"
    ''' <summary>
    ''' Binds the Grid with data of all the open settlements for a particular client
    ''' </summary>
    ''' <param name="sClientID">Integer to uniquely identify a client converted to string</param>
    ''' <remarks></remarks>
    Public Sub BindGrid(ByVal sClientID As Integer)
        DataClientID = sClientID
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "stp_GetPendingSettlementsForClient"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "ClientId", sClientID)

        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)

        If Not IsNothing(ds) Then
            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    GridView1.DataSource = ds
                    GridView1.DataBind()

                    lblSDABalance.Text = FormatCurrency(ds.Tables(0).Rows(0)("RegisterBalance").ToString, 2, 0, 0)
                    lblPFOBalance.Text = FormatCurrency(ds.Tables(0).Rows(0)("PFOBalance".ToString), 2, 0, 0)

                    Dim dep As DataSet = ClientHelper2.ExpectedDeposits(sClientID, DateAdd(DateInterval.Day, 90, Now))
                    If dep.Tables(1).Rows.Count > 0 Then
                        lblDeliveryDate.Text = Format(CDate(dep.Tables(1).Rows(0)("depositdate")), "MMM d")
                        lblDeliveryAmount.Text = FormatCurrency(Val(dep.Tables(1).Rows(0)("depositamount")), 2)
                    End If
                End If
            End If
        End If

    End Sub
#End Region


End Class
