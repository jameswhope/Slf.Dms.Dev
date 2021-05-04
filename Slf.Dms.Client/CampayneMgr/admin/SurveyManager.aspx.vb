Imports System.Collections.Generic
Imports System.Data

Imports AjaxControlToolkit

Imports SurveyHelper

Partial Class admin_SurveyManager
    Inherits System.Web.UI.Page

#Region "Enumerations"

    Public Enum enumCreatetype
        cSurvey = 0
        cQuestionInsert = 1
        cQuestionEdit = 2
    End Enum

#End Region 'Enumerations

#Region "Properties"

    Public Property QuestionID() As Integer
        Get
            Return ViewState("QuestionID")
        End Get
        Set(ByVal value As Integer)
            ViewState("QuestionID") = value
        End Set
    End Property

    Public Property ShowDragHandle() As Boolean
        Get
            Return ViewState("_showDragHandle")
        End Get
        Set(ByVal value As Boolean)
            ViewState("_showDragHandle") = value
        End Set
    End Property

    Public Property SurveyID() As Integer
        Get
            Return ViewState("_surveyID")
        End Get
        Set(ByVal value As Integer)
            ViewState("_surveyID") = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"
    Protected Sub admin_SurveyManager_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
    End Sub

    Protected Sub gvSurvey_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSurvey.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                SurveyID = e.CommandArgument
                dsQuestions.SelectParameters("surveyid").DefaultValue = e.CommandArgument
                dsQuestions.DataBind()

                btnCreateQuestion.Style("display") = "block"
                btnCreateQuestion.OnClientClick = String.Format("return ShowQuestion('{0}','-1','','','','','','','','','False');", SurveyID)

                btnTestSurvey.Style("display") = "block"
                btnTestSurvey.OnClientClick = String.Format("return TestSurvey('{0}');", SurveyID)

                btnCheck.Style("display") = "block"
                btnCheck.OnClientClick = String.Format("return CheckSurvey('{0}');", SurveyID)

        End Select
    End Sub

    Protected Sub gvSurvey_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSurvey.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEditSurvey")
                lnk.OnClientClick = String.Format("return ShowSurveyEdit('{0}','{1}','{2}','{3}');", rowView("surveyid").ToString, _
                                                  rowView("Description").ToString, _
                                                  IIf(IsDBNull(rowView("StartingQuestionID")), 0, rowView("StartingQuestionID").ToString), _
                                                  rowView("FinishedText").ToString)
        End Select
    End Sub

    Protected Sub rlQuestions_ItemDataBound(ByVal sender As Object, ByVal e As AjaxControlToolkit.ReorderListItemEventArgs) Handles rlQuestions.ItemDataBound
        Select Case e.Item.ItemType
            Case ListItemType.Item
                Dim rowView As DataRowView = CType(e.Item.DataItem, DataRowView)
                Dim lnk As LinkButton = e.Item.FindControl("lnkSelect")
                Dim qid As String = rowView("questionid").ToString
                Dim sid As String = rowView("surveyid").ToString
                Dim options As New List(Of String)
                'QuestionID, NextQuestionID, Question, QuestionType, QuestionBranchUrl, QuestionBranchResponse
                ', QuestionOfferID, QuestionPopUnderUrl, QuestionPopUpUrl
                Dim qol As List(Of QuestionOption) = SurveyHelper.GetQuestionOptions(qid)
                For Each qo As QuestionOption In qol
                    options.Add(String.Format("{0}:{1}", qo.OptionID, qo.OptionText))
                Next
                'Dim dlg As String = String.Format("return ShowQuestion('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}');", sid, qid, _
                '                                  rowView("Question").ToString, _
                '                                  rowView("QuestionPlainText").ToString, _
                '                                  rowView("QuestionType").ToString, _
                '                                  Join(options.ToArray, "|"), _
                '                                  rowView("QuestionBranchUrl").ToString, _
                '                                  rowView("QuestionBranchResponse").ToString, _
                '                                  rowView("QuestionOfferID").ToString, _
                '                                  rowView("QuestionPopUnderUrl").ToString, _
                '                                  rowView("QuestionPopUpUrl").ToString, _
                '                                  rowView("Active").ToString)
                Dim dlg As String = String.Format("return ShowQuestionAJAX('{0}','{1}');", sid, qid)
                lnk.OnClientClick = dlg

        End Select
    End Sub
    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvSurvey.DataBind()
        rlQuestions.DataBind()
    End Sub
#End Region 'Methods

End Class