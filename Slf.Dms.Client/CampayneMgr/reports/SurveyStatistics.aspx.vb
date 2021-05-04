Imports AnalyticsHelper
Imports System.Data
Imports System.Collections.Generic

Partial Class admin_SurveyStatistics
    Inherits System.Web.UI.Page
    Private surveyGroupName As New List(Of String)
    Private questionGroupName As New List(Of String)

    Private Function BuildSummaryDatatable() As DataTable
        Dim dtNew As New DataTable
        'add static columns
        dtNew.Columns.Add("Question")
        dtNew.Columns.Add("Total")
        dtNew.Columns.Add("Response Total")
        dtNew.Columns.Add("% Responses of Total")
        dtNew.Columns.Add("No Response Total")
        dtNew.Columns.Add("% No Response of Total")
        Using dt As DataTable = TryCast(ds_Survey.Select(DataSourceSelectArguments.Empty), DataView).ToTable
            'build dt
            'loop thru rows creating columns for the responses
            For Each dr As DataRow In dt.Rows
                For Each dc As DataColumn In dt.Columns
                    If dc.ColumnName.ToLower = "answer" Then
                        If dtNew.Columns.Contains(dc.ColumnName) = False And dr(dc.ColumnName).ToString <> "" Then
                            Try
                                dtNew.Columns.Add(dr(dc.ColumnName).ToString)
                            Catch ex As DuplicateNameException
                                Continue For
                            End Try

                        End If
                    End If
                Next
            Next
        End Using
        Return dtNew
    End Function
    Private Sub BuildSummaryGrid()
        'build table
        Dim dtNew As DataTable = BuildSummaryDatatable()

        'fill table
        Dim nametbl As New Hashtable
        Using dt As DataTable = TryCast(ds_Survey.Select(DataSourceSelectArguments.Empty), DataView).ToTable
            'loop thru rows create or update
            For Each dr As DataRow In dt.Rows
                Dim nr As DataRow = dtNew.NewRow
                Dim qText As String = dr("questionplaintext").ToString
                If nametbl.Contains(qText) Then
                    nr("Question") = ""
                    Dim qRow() As Data.DataRow
                    qRow = dtNew.Select(String.Format("question = '{0}'", qText))
                    qRow(0)("No Response Total") = dr("LeftStepWithOutAnswer").ToString
                    For Each dc As DataColumn In dt.Columns
                        If dc.ColumnName.ToLower = "answer" Then
                            If dtNew.Columns.Contains(dr(dc.ColumnName).ToString) = True Then
                                Try
                                    qRow(0)(dr(dc.ColumnName).ToString) = dr("answercount").ToString
                                Catch ex As DuplicateNameException
                                    Continue For
                                End Try

                            End If
                        End If
                    Next
                Else
                    nr("Question") = dr("questionplaintext").ToString
                    nr("No Response Total") = dr("LeftStepWithOutAnswer").ToString
                    For Each dc As DataColumn In dt.Columns
                        If dc.ColumnName.ToLower = "answer" Then
                            If dtNew.Columns.Contains(dr(dc.ColumnName).ToString) = True Then
                                Try
                                    nr(dr(dc.ColumnName).ToString) = dr("answercount").ToString
                                Catch ex As DuplicateNameException
                                    Continue For
                                End Try

                            End If
                        End If
                    Next
                    dtNew.Rows.Add(nr)
                    nametbl.Add(dr("questionplaintext").ToString, Nothing)
                End If
            Next

            'sum answer responses
            Dim dtTotal As Double = 0
            For Each dr As DataRow In dtNew.Rows
                Dim tot As Double = 0
                Dim noans As Integer = 0
                For i As Integer = 6 To dtNew.Columns.Count - 1
                    If Not String.IsNullOrEmpty(dr(i).ToString) Then
                        tot += dr(i).ToString
                    End If
                Next
                dr("Response Total") = tot
                If dtTotal = 0 Then
                    If noans = 0 Then
                        Double.TryParse(dr("No Response Total").ToString, noans)
                    End If
                    dtTotal += tot + noans
                End If
            Next

            'calculate %
            For i As Integer = 0 To dtNew.Rows.Count - 1
                Dim tot As Double = 0
                Dim ltot As Double = 0
                Double.TryParse(dtNew.Rows(i)("Response Total").ToString, tot)
                Double.TryParse(dtNew.Rows(i)("No Response Total").ToString, ltot)

                dtNew.Rows(i)("% Responses of Total") = FormatPercent(tot / dtTotal, 2)
                dtNew.Rows(i)("Total") = CStr(tot + ltot)
                dtNew.Rows(i)("% No Response of Total") = FormatPercent(ltot / dtTotal, 2)
            Next

            'formatting
            gvSummary.AutoGenerateColumns = False
            gvSummary.Columns.Clear()
            For Each dc As DataColumn In dtNew.Columns
                Dim bc As New BoundField
                bc.DataField = dc.ColumnName
                bc.HeaderText = dc.ColumnName
                Select Case (dc.ColumnName.ToLower)
                    Case "question"
                        bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                        bc.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                        bc.HeaderStyle.VerticalAlign = VerticalAlign.Bottom
                    Case Else
                        bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                        bc.HeaderStyle.Wrap = True
                        bc.HeaderStyle.Width = New Unit(75)
                        bc.HeaderStyle.VerticalAlign = VerticalAlign.Bottom
                        bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                End Select
                bc.HeaderStyle.CssClass = "ui-widget-header"
                bc.ItemStyle.CssClass = "ui-widget-content"

                gvSummary.Columns.Add(bc)
            Next

            'bind data
            gvSummary.DataSource = dtNew
            gvSummary.DataBind()

        End Using
    End Sub
    Private Sub LoadReport()
        Try
            ds_Survey.SelectParameters("surveyid").DefaultValue = dateBarControl1.SurveyID
            ds_Survey.SelectParameters("from").DefaultValue = dateBarControl1.FromDate
            ds_Survey.SelectParameters("to").DefaultValue = dateBarControl1.ToDate & " 23:59"
            ds_Survey.DataBind()

            BuildSummaryGrid()


        Catch ex As Exception

            'LeadHelper.LogError("SurveyStatistics", ex.Message, ex.StackTrace)

        End Try
    End Sub

    Protected Sub admin_SurveyStatistics_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        dateBarControl1.ShowSurveys = True
        dateBarControl1.ShowSites = False
        If Not IsPostBack Then

            LoadReport()
        End If

    End Sub
    Protected Sub gvSummary_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.addHandOnHover(e)
                GridViewHelper.styleGridviewRows(e, hoverColor:="#f5f5dc", AltRowColor:="#F9F9F9")
        End Select
    End Sub

    Protected Sub dateBarControl1_dateBar_Change(ByVal surveyid As Integer, ByVal _From As String, ByVal _To As String) Handles dateBarControl1.dateBar_Change
        LoadReport()
    End Sub
End Class
