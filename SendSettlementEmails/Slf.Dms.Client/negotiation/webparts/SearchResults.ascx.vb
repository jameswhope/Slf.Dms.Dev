Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Data

Partial Class negotiation_webparts_SearchResults
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer
    Private Const PageSize As Integer = 5
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pnlSearchClients.Visible = False
        pnlNoSearchClients.Visible = True

        UserID = Integer.Parse(Page.User.Identity.Name)
    End Sub
#End Region

#Region "Other Events"
    Protected Sub grvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grvResults.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                'e.Row.Attributes.Add("onclick", "ClientClick(" & DataBinder.Eval(e.Row.DataItem, "ClientID") & ");")

                Dim html As String = "<div id='myDiv" + e.Row.RowIndex.ToString + "' style='display:none'>" & GetClientAccountList(DataBinder.Eval(e.Row.DataItem, "ClientID").ToString) & "</div>"
                Dim index As Integer = e.Row.Cells.Count - 1
                Dim i As Integer

                e.Row.Cells(0).ID = "CellInfo" & e.Row.RowIndex.ToString
                For i = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Attributes("onclick") = "HideShowPanel('myDiv" & e.Row.RowIndex.ToString() & "');ChangePlusMinus('" & e.Row.Cells(0).ClientID & "');"
                Next
                e.Row.Cells(index).Text = e.Row.Cells(index).Text & "</td><tr><td></td><td colspan='" & index.ToString & "'>" & html
        End Select
    End Sub

    Protected Sub grvResults_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grvResults.PageIndexChanging
        Requery(hdnSearch.Value, hdnDepth.Value, hdnOrder.Value, e.NewPageIndex)
    End Sub

    Protected Sub grvResults_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles grvResults.Sorting
        Requery(hdnSearch.Value, hdnDepth.Value, "ORDER BY " & e.SortExpression & " " & IIf(e.SortDirection = SortDirection.Ascending, "ASC", "DESC"))
    End Sub
#End Region

#Region "Utilities"
    Public Sub Requery(ByVal search As String, ByVal depth As String, ByVal order As String, Optional ByVal pageIndex As Integer = 0)
        If Not String.IsNullOrEmpty(search) Then
            Dim results As Integer = RequeryClients(StringHelper.SplitQuoted(search, " ", """").ToArray(GetType(String)), depth, order, pageIndex)

            UserHelper.StoreSearch(UserID, search, results, results, 0, 0, 0, 0, 0)
        End If

        hdnSearch.Value = search
        hdnDepth.Value = depth
        hdnOrder.Value = order
    End Sub

    Private Function RequeryClients(ByVal Values() As String, ByVal depth As String, ByVal orderBy As String, ByVal pageIndex As Integer) As Integer
        Dim Where As String = String.Empty

        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values

            If Value.ToLower = "and" Then
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                Section = String.Empty
            Else
                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section &= "[Name] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [AccountNumber] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [SSN] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [Address] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [ContactNumber] LIKE '%" & Value.Replace("'", "''") & "%'"
            End If
        Next

        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            Where = "WHERE (" & String.Join(" AND ", Sections.ToArray()) & ")"
        Else
            Where = "WHERE 0=1"
        End If

        If UserID = 10 Or UserID = 11 Then
            Where += " AND CompanyID in (10,11)"
        End If

        Dim ClientSearches As New List(Of ClientSearch)
        Dim searchParams As New List(Of SqlParameter)
        searchParams.Add(New SqlParameter("where", Where))

        If Not String.IsNullOrEmpty(orderBy) Then
            searchParams.Add(New SqlParameter("orderby", orderBy))
        End If

        If depth = "assignments" Then
            searchParams.Add(New SqlParameter("ids", GetMyAssignments()))
        End If

        Using dt As DataTable = SqlHelper.GetDataTable("stp_NegotiationClientSearches", Data.CommandType.StoredProcedure, searchParams.ToArray)
            For Each reader As DataRow In dt.Rows
                ClientSearches.Add(New ClientSearch(reader("ClientID").ToString, _
                    reader("ClientStatus").ToString, _
                    reader("Type").ToString, _
                    reader("Name").ToString, _
                    reader("Address").ToString, _
                    reader("ContactType").ToString, _
                    reader("ContactNumber").ToString, ResolveUrl("~/")))
            Next
        End Using

        grvResults.PageIndex = pageIndex
        grvResults.PageSize = PageSize
        grvResults.DataSource = ClientSearches
        grvResults.DataBind()

        pnlSearchClients.Visible = ClientSearches.Count > 0
        pnlNoSearchClients.Visible = ClientSearches.Count = 0

        Return ClientSearches.Count
    End Function

    Private Function GetMyAssignments() As String
        Dim filterIDs As New List(Of String)
        Dim entityIDs As New List(Of String)

        filterIDs.Add("-1")

        Using cmd As New SqlCommand("SELECT DISTINCT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and UserID = " & UserID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        entityIDs.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        For Each entityID As Integer In entityIDs
            filterIDs.Add(GetFilters(entityID))
        Next

        Return String.Join(", ", filterIDs.ToArray())
    End Function

    Private Function GetFilters(ByVal entityID As String) As String
        Dim list As New List(Of String)()

        list.Add("-1")

        Using cmd As New SqlCommand("SELECT isnull(FilterID, 0) as FilterID FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID = " & entityID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        list.Add(reader("FilterID"))
                    End While
                End Using
            End Using
        End Using

        AddChildFiltersRec(list, entityID)

        Return String.Join(",", list.ToArray())
    End Function

    Private Sub AddChildFiltersRec(ByRef list As List(Of String), ByVal entityID As String)
        Dim ids As New List(Of String)

        Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE ParentNegotiationEntityID = " & entityID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ids.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        If ids.Count > 0 Then
            Using cmd As New SqlCommand("SELECT isnull(xr.FilterID, 0) as FilterID FROM tblNegotiationFilterXref as xr inner join tblNegotiationFilters as nf on nf.FilterID = xr.FilterID WHERE xr.Deleted = 0 and nf.Deleted = 0 and nf.FilterType = 'leaf' and xr.EntityID in (" & String.Join(", ", ids.ToArray()) & ")", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If Not list.Contains(reader("FilterID")) Then
                                list.Add(reader("FilterID"))
                            End If
                        End While
                    End Using
                End Using
            End Using

            For Each id As Integer In ids
                AddChildFiltersRec(list, id)
            Next
        End If
    End Sub

    Private Function GetClientAccountList(ByVal clientID As String) As String
        Dim row As Data.DataRow
        Dim table As New System.Text.StringBuilder
        Dim dataSet As New Data.DataSet
        Dim sqlDA As SqlDataAdapter

        Using cmd As SqlCommand = ConnectionFactory.CreateCommand("get_ClientAccountOverviewList") '"stp_NegotiationGetAccountOverview")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "clientId", clientID)

                'If hdnDepth.Value = "assignments" Then
                'DatabaseHelper.AddParameter(cmd, "ids", GetMyAssignments())
                'End If

                sqlDA = New SqlDataAdapter(cmd)
                cmd.Connection.Open()
                sqlDA.Fill(dataSet)
                If cmd.Connection.State = Data.ConnectionState.Open Then
                    cmd.Connection.Close()
                End If
                If dataSet.Tables(0).Rows.Count = 0 Then
                    Return "<div style='color:red'>No accounts exist for this client.</div>"
                End If
            End Using
        End Using

        table.Append("<table onmouseover='RowHover(this, true)' onmouseout='RowHover(this, false)' onselectstart = 'return false;' border='0' cellpadding='2' cellspacing='0' style='border: solid 1px #a0a0a0; width: 100%; background-color: #ffffff'>")
        table.Append("<thead>")
        table.Append(" <tr>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='left'>Creditor</th>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='left'>Phone</th>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='left'>Account #</th>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='center'>Status</th>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='right'>Original</th>")
        table.Append("  <th style='background-color:#c0c0c0; border-bottom: solid 1px #a0a0a0; padding-right:10px' align='right'>Current</th>")
        table.Append(" </tr>")
        table.Append("</thead>")
        table.Append("<tbody>")

        For Each row In dataSet.Tables(0).Rows
            table.Append("<a>")
            table.Append("<tr style='cursor:hand' onclick='RowClick(" & clientID & "," & row("AccountID").ToString & ")'>")

            If (Not row("OriginalCreditorName") Is DBNull.Value) AndAlso (Not row("OriginalCreditorName").Equals(row("CurrentCreditorName"))) Then
                table.Append("<td style='padding-right:10px; vertical-align: top'>" & row("OriginalCreditorName").ToString & "<br />" _
                    & "<img src='images/rootend3.png' style='margin:3 0 0 5;' align='absmiddle' border='0' />" & row("CurrentCreditorName").ToString & "</td>")
                table.Append("<td style='padding-right:10px; vertical-align: top'>" & LocalHelper.FormatPhone(row("OriginalCreditorPhone").ToString) & "<br />" _
                    & LocalHelper.FormatPhone(row("CurrentCreditorPhone").ToString) & "</td>")
            Else
                table.Append("<td style='padding-right:10px; vertical-align: top'>" & LocalHelper.FormatPhone(row("CurrentCreditorName").ToString) & "</td>")
                table.Append("<td style='padding-right:10px; vertical-align: top'>" & LocalHelper.FormatPhone(row("CurrentCreditorPhone").ToString) & "</td>")
            End If

            table.Append("<td style='padding-right:10px; vertical-align: top'>" & "****" & Right(row("CurrentAccountNumber").ToString, 4) & "</td>")
            table.Append("<td style='padding-right:10px; vertical-align: top' align='center'>" & row("AccountStatusCode").ToString & "</td>")
            table.Append("<td style='padding-right:10px; vertical-align: top' align='right'>" & String.Format("{0:c}", Val(row("OriginalAmount"))) & "</td>")
            table.Append("<td style='padding-right:10px; vertical-align: top' align='right'>" & String.Format("{0:c}", Val(row("CurrentAmount"))) & "</td>")

            table.Append("</tr>")
            table.Append("</a>")
        Next

        table.Append("</tbody>")
        table.Append("</table>")

        Return table.ToString
    End Function
#End Region

End Class