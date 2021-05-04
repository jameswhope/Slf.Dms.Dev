Imports Lexxiom.BusinessServices
Imports System.Drawing
Imports System.Text
Imports System.Data

Partial Class Clients_client_creditors_mediation_criteriadistribution
    Inherits System.Web.UI.Page



    Dim bsCriteriaDashBoard As Lexxiom.BusinessServices.CriteriaDashBoard = New Lexxiom.BusinessServices.CriteriaDashBoard()
    Dim bsCriteria As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()
    Dim iCriteriaId As Integer = 0
    Dim iEntityId As Integer = 0
    Dim sCustomFilter As String = ""
    Dim sExitFlag As Boolean = False

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub LoadDashBoardSummary(ByVal gv As GridView)
        Dim dsDashBoard As DataSet = New DataSet
        Dim RowIndx, iKeyId As Integer
        Dim dtRow() As DataRow
        Try

            dsDashBoard = bsCriteriaDashBoard.GetDashBoard(iCriteriaId)
            For RowIndx = 0 To gv.Rows.Count - 1
                iKeyId = gv.DataKeys(RowIndx).Value
                dtRow = dsDashBoard.Tables(0).Select("FilterId=" & iKeyId)
                gv.Rows(RowIndx).Cells(3).Text = dtRow(0)("ClientCount")
                gv.Rows(RowIndx).Cells(4).Text = dtRow(0)("AccountCount")
                gv.Rows(RowIndx).Cells(5).Text = dtRow(0)("StatusCount")
                gv.Rows(RowIndx).Cells(6).Text = dtRow(0)("StateCount")
                gv.Rows(RowIndx).Cells(7).Text = dtRow(0)("ZipCodeCount")
                gv.Rows(RowIndx).Cells(8).Text = dtRow(0)("CreditorCount")
                gv.Rows(RowIndx).Cells(9).Text = String.Format("{0:c}", dtRow(0)("TotalSDAAmount"))
            Next
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub LoadDashBoardSummary(ByVal gv As GridView, ByVal sChild As String)
        Dim dsDashBoard As DataSet = New DataSet
        Dim RowIndx, iKeyId As Integer
        Try

            For RowIndx = 0 To gv.Rows.Count - 1
                iKeyId = gv.DataKeys(RowIndx).Value
                dsDashBoard = bsCriteriaDashBoard.GetDashBoard(iKeyId)
                If (dsDashBoard.Tables(0).Rows.Count > 0) Then
                    gv.Rows(RowIndx).Cells(3).Text = dsDashBoard.Tables(0).Rows(0)("ClientCount")
                    gv.Rows(RowIndx).Cells(4).Text = dsDashBoard.Tables(0).Rows(0)("AccountCount")
                    gv.Rows(RowIndx).Cells(5).Text = dsDashBoard.Tables(0).Rows(0)("StatusCount")
                    gv.Rows(RowIndx).Cells(6).Text = dsDashBoard.Tables(0).Rows(0)("StateCount")
                    gv.Rows(RowIndx).Cells(7).Text = dsDashBoard.Tables(0).Rows(0)("ZipCodeCount")
                    gv.Rows(RowIndx).Cells(8).Text = dsDashBoard.Tables(0).Rows(0)("CreditorCount")
                    gv.Rows(RowIndx).Cells(9).Text = String.Format("{0:c}", dsDashBoard.Tables(0).Rows(0)("TotalSDAAmount"))
                End If
            Next
        Catch ex As Exception
            Throw ex
        Finally
            dsDashBoard.Dispose()
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="lbl"></param>
    ''' <param name="msg"></param>
    ''' <param name="isError"></param>
    ''' <remarks></remarks>
    Protected Sub DisplayMsg(ByVal lbl As Label, ByVal msg As String, ByVal isError As Boolean)
        If (isError) Then
            lbl.BackColor = Color.LightGoldenrodYellow
            lbl.ForeColor = Color.Red
        Else
            lbl.BackColor = Color.Transparent
            lbl.ForeColor = Color.Black
        End If
        lbl.Text = msg
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GetIdFromQueryString()
        Try
            If Not Page.IsPostBack Then
                If ((iCriteriaId > 0) Or (iEntityId > 0)) Then                
                    ShowFilter()
                Else
                    BuildErrorDisplay()
                End If
            End If
            If (sExitFlag = True) Then
                ucCriteriaBuilder.LoadFlag = sExitFlag
                ucCriteriaBuilder.Visible = False
            Else
                BuildHeaderDisplay()
            End If
        Catch ex As Exception

        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub GetIdFromQueryString()
        If Not Request.QueryString("CriteriaId") Is Nothing Then
            iCriteriaId = CInt(Request.QueryString("CriteriaId"))
        End If
        If Not Request.QueryString("filter") Is Nothing Then
            sCustomFilter = Request.QueryString("filter")
        End If
        If Not Request.QueryString("entityid") Is Nothing Then
            iEntityId = Request.QueryString("entityid")
        End If
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub BuildErrorDisplay()
        'Error Display
        Dim sb As StringBuilder = New StringBuilder

        sb.Append("<table style='BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda' cellspacing='5' cellpadding='0' border='0'>")
        sb.Append("<tr>")
        sb.Append("<td valign='top' style='width:20;'><img src='" & ResolveUrl("~/images/message.png") & "' /></td>")
        If (iEntityId = 0) Then
            sb.Append("<td style='font-family: tahoma; font-size: 11px; width: 100%; color: red;'>&nbsp;Entity information not defined.</td>")
        Else
            sb.Append("<td style='font-family: tahoma; font-size: 11px; width: 100%; color: red;'>&nbsp;Entity Id (" & iEntityId & ") is not assigned distribution criteria.</td>")
        End If
        sb.Append("</tr>")
        sb.Append("</table>&nbsp;<br />")

        ltHeader.Text = sb.ToString()
        sExitFlag = True
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub BuildHeaderDisplay()
        'Main Criteira Header
        ltHeader.Text = "<table border='0' cellpadding='0' cellspacing='0'><tr><td><img src='" & ResolveUrl("~/images/16x16_report.png") & "' /></td><td style='font-family: tahoma; font-size: 11px; width: 100%; color: rgb(50,112,163);'>&nbsp;Master Criteria</td></tr></table>"

        'Sub Criteria Header
        ltSubHeader.Text = "<table border='0' cellpadding='0' cellspacing='0'><tr><td><img src='" & ResolveUrl("~/images/16x16_report.png") & "' /></td><td style='font-family: tahoma; font-size: 11px; width: 100%; color: rgb(50,112,163);'>&nbsp;Sub Criteria</td></tr><tr><td>&nbsp;</td></tr></table>"
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Protected Sub ShowFilter()
        Dim dsList As DataSet = New DataSet
        Dim dsChildList As DataSet = New DataSet
        Try
            If (iCriteriaId > 0) Then
                dsList = bsCriteria.GetFilters(sCustomFilter, iCriteriaId)
            ElseIf (iEntityId > 0) Then
                dsList = bsCriteria.GetEntityFilters(iEntityId, "base")
            End If
            If (dsList.Tables.Count > 0) Then
                If (dsList.Tables(0).Rows.Count > 0) Then
                    grdCriteria.DataSource = dsList.Tables(0).DefaultView
                    grdCriteria.DataBind()
                    If (iCriteriaId > 0) Then
                        LoadDashBoardSummary(grdCriteria)
                    ElseIf (iEntityId > 0) Then
                        LoadDashBoardSummary(grdCriteria, "Entity")
                    End If
                Else
                    BuildErrorDisplay()
                End If
            Else
                BuildErrorDisplay()
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsList.Dispose()
        End Try
    End Sub

    Protected Sub grdCriteria_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdCriteria.RowDataBound
        Dim sFilterText, sTrimmedDisplay As String
        If (e.Row.RowType = DataControlRowType.DataRow Or e.Row.RowType = DataControlRowType.EmptyDataRow) Then
            sFilterText = e.Row.Cells(2).Text
            If (sFilterText.Length > 85) Then
                sTrimmedDisplay = sFilterText.Substring(0, 85)
                e.Row.Cells(2).Text = sFilterText.Substring(0, sTrimmedDisplay.LastIndexOf(" ")) & "..."
            End If
        End If
    End Sub
End Class
