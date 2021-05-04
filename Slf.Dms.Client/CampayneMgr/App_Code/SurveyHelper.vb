Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection

Public Class SurveyHelper

#Region "Methods"
    

    Public Shared Sub CopySurvey(ByVal surveyIDToCopy As Integer)
        Dim ssql As String = "stp_survey_copySurvey"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("SurveyID", surveyIDToCopy))
        SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function CreateQuestion(ByVal SurveyID As Integer, _
        ByVal Question As String, _
        ByVal QuestionType As String, _
        ByVal QuestionBranchUrl As String, _
        ByVal QuestionBranchResponse As String, _
        ByVal QuestionOfferID As Integer, _
        ByVal QuestionPopUnderUrl As String, _
        ByVal QuestionPopUpUrl As String, _
        ByVal QuestionPlainText As String, _
        ByVal QuestionActive As Boolean) As Integer
        Dim questionID As Integer = -1
        Dim ssql As String = "stp_survey_createQuestion"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("SurveyID", SurveyID))
        params.Add(New SqlParameter("Question", Question))
        params.Add(New SqlParameter("QuestionType", QuestionType))
        params.Add(New SqlParameter("QuestionBranchUrl", IIf(String.IsNullOrEmpty(QuestionBranchUrl), DBNull.Value, QuestionBranchUrl)))
        params.Add(New SqlParameter("QuestionBranchResponse", IIf(String.IsNullOrEmpty(QuestionBranchResponse), DBNull.Value, QuestionBranchResponse)))
        params.Add(New SqlParameter("QuestionOfferID", IIf(QuestionOfferID = -1, DBNull.Value, QuestionOfferID)))
        params.Add(New SqlParameter("QuestionPopUnderUrl", IIf(String.IsNullOrEmpty(QuestionPopUnderUrl), DBNull.Value, QuestionPopUnderUrl)))
        params.Add(New SqlParameter("QuestionPopUpUrl", IIf(String.IsNullOrEmpty(QuestionPopUpUrl), DBNull.Value, QuestionPopUpUrl)))
        params.Add(New SqlParameter("QuestionPlainText", QuestionPlainText))
        params.Add(New SqlParameter("Active", QuestionActive))

        questionID = SqlHelper.ExecuteScalar(ssql, CommandType.StoredProcedure, params.ToArray)

        Return questionID
    End Function
    Public Shared Function CheckSurvey(surveyID As Integer) As List(Of String)
        Dim results As New List(Of String)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("surveyID", surveyID))
        Dim noneActive As String = SqlHelper.ExecuteScalar("select count(*) from tblquestion where active = 1 and surveyid = @surveyid", CommandType.Text, params.ToArray)
        If noneActive = 0 Then
            results.Add("<br/><strong>WARNING:</strong>  This survey doesn't have any active questions!")
        End If

        params = New List(Of SqlParameter)
        params.Add(New SqlParameter("surveyID", surveyID))
        Using dtSurv As DataTable = SqlHelper.GetDataTable("SELECT QuestionID,questionplaintext,questionseq,NextQuestionID from tblQuestion where SurveyID = @surveyid", CommandType.Text, params.ToArray)
            For Each q As DataRow In dtSurv.Rows
                Dim qid As String = q("questionid").ToString
                Dim noOptions As String = SqlHelper.ExecuteScalar(String.Format("SELECT count(QuestionID) from tblOptions where QuestionID = {0}", qid), CommandType.Text)
                Dim qtext As String = q("questionplaintext").ToString
                If noOptions = 0 AndAlso qtext.ToLower <> "finished survey" Then
                    results.Add(String.Format("<br/><strong>WARNING:Missing Answers!</strong>  {0}", q("questionplaintext").ToString))
                End If

                Dim qseq As String = q("questionseq").ToString
                If String.IsNullOrEmpty(qseq) Then
                    results.Add(String.Format("<br/><strong>ERROR:Missing Sequence!</strong>  {0}", q("questionplaintext").ToString))
                End If
                Dim nseq As String = q("NextQuestionID").ToString
                If String.IsNullOrEmpty(nseq) Then
                    If qseq <> dtSurv.Rows.Count Then
                        results.Add(String.Format("<br/><strong>ERROR:Missing Next Question Sequence!</strong>  {0}", q("questionplaintext").ToString))
                    End If
                Else
                    If Integer.Parse(nseq) = 0 AndAlso qseq <> dtSurv.Rows.Count Then
                        results.Add(String.Format("<br/><strong>ERROR:Missing Next Question Sequence!</strong>  {0}", q("questionplaintext").ToString))
                    End If
                End If
            Next
        End Using

        params = New List(Of SqlParameter)
        params.Add(New SqlParameter("surveyID", surveyID))
        Using dt As DataTable = SqlHelper.GetDataTable("SELECT questionplaintext from tblQuestion where QuestionType is null OR QuestionType = '' and SurveyID = @surveyid", CommandType.Text, params.ToArray)
            For Each dr As DataRow In dt.Rows
                results.Add(String.Format("<br/><strong>WARNING:</strong>  This questions needs an answer type (ie radio, checkbox,text)!<br/>{0}", dr("questionplaintext").ToString))
            Next
        End Using

        Return results
    End Function
    Public Shared Sub CreateQuestionOption(ByVal QuestionID As Integer, ByVal OptionText As String, Optional ByVal optionID As String = Nothing)
        Dim ssql As String = "stp_survey_createQuestionOption"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("QuestionID", QuestionID))
        params.Add(New SqlParameter("OptionText", OptionText))
        If Not IsNothing(optionID) Then
            params.Add(New SqlParameter("OptionID", optionID))
        End If

        SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function CreateSurvey(ByVal Description As String, ByVal StartingSeq As Integer, ByVal FinishText As String) As Integer
        Dim surveyID As Integer = -1
        Dim ssql As String = "stp_survey_createSurvey"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("Description", Description))
        params.Add(New SqlParameter("StartingQuestionID", StartingSeq))
        params.Add(New SqlParameter("FinishedText", FinishText))

        surveyID = SqlHelper.ExecuteScalar(ssql, CommandType.StoredProcedure, params.ToArray)

        Return surveyID
    End Function

    Public Shared Function GetQuestion(ByVal questionID As Integer) As Question
        Dim q As New Question
        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select * from tblquestion where questionid = {0}", questionID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                q.QuestionID = dr("questionid").ToString
                q.SurveyID = dr("SurveyID").ToString
                q.NextQuestionID = dr("NextQuestionID")
                q.Question = dr("Question").ToString
                q.HelpText = IIf(IsDBNull(dr("HelpText")), "", dr("HelpText"))
                q.QuestionType = IIf(IsDBNull(dr("QuestionType")), "radio", dr("QuestionType"))
                q.Created = IIf(IsDBNull(dr("created")), "", dr("created"))
                q.QuestionSeq = IIf(IsDBNull(dr("QuestionSeq")), 0, dr("QuestionSeq").ToString)
                q.QuestionBranchUrl = IIf(IsDBNull(dr("QuestionBranchUrl")), "", dr("QuestionBranchUrl"))
                q.QuestionBranchResponse = IIf(IsDBNull(dr("QuestionBranchResponse")), "", dr("QuestionBranchResponse"))
                q.QuestionOfferID = IIf(IsDBNull(dr("QuestionOfferID")), -1, dr("QuestionOfferID"))
                q.QuestionPopUnderUrl = IIf(IsDBNull(dr("QuestionPopUnderUrl")), "", dr("QuestionPopUnderUrl"))
                q.QuestionPopUpUrl = IIf(IsDBNull(dr("QuestionPopUpUrl")), "", dr("QuestionPopUpUrl"))
                q.QuestionPlainText = IIf(IsDBNull(dr("QuestionPlainText")), "", dr("QuestionPlainText"))

                Exit For
            Next

        End Using
        Return q
    End Function

    Public Shared Function GetQuestionOptions(ByVal questionID As Integer) As List(Of QuestionOption)
        Dim qol As New List(Of QuestionOption)
        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select * from tbloptions where questionID = {0}", questionID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim qo As New QuestionOption
                qo.OptionID = IIf(IsDBNull(dr("OptionID")), -1, dr("OptionID"))
                qo.QuestionID = IIf(IsDBNull(dr("QuestionID")), -1, dr("QuestionID"))
                qo.OptionText = IIf(IsDBNull(dr("OptionText")), "", dr("OptionText"))
                qo.NextQuestionID = -1
                qo.Seq = IIf(IsDBNull(dr("Seq")), "", dr("Seq"))
                qo.Active = IIf(IsDBNull(dr("Active")), True, dr("Active"))
                qo.Created = IIf(IsDBNull(dr("Created")), "", dr("Created"))
                qo.LastModified = IIf(IsDBNull(dr("LastModified")), "", dr("LastModified"))
                qol.Add(qo)
            Next
        End Using

        Return qol
    End Function

    Public Shared Function GetQuestions(ByVal surveyID As Integer) As List(Of Question)
        Dim ql As New List(Of Question)

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select * from tblquestion where surveyid = {0}", surveyID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim q As New Question
                q.QuestionID = dr("questionid").ToString
                q.SurveyID = dr("SurveyID").ToString
                q.NextQuestionID = dr("NextQuestionID").ToString
                q.Question = dr("Question").ToString
                q.HelpText = dr("HelpText").ToString
                q.QuestionType = dr("QuestionType").ToString
                q.Created = dr("Created").ToString
                q.QuestionSeq = dr("QuestionSeq").ToString
                q.QuestionBranchUrl = dr("QuestionBranchUrl").ToString
                q.QuestionBranchResponse = dr("QuestionBranchResponse").ToString
                q.QuestionOfferID = IIf(IsDBNull(dr("QuestionOfferID")), 0, dr("QuestionOfferID").ToString)
                q.QuestionPopUnderUrl = dr("QuestionPopUnderUrl").ToString
                q.QuestionPopUpUrl = dr("QuestionPopUpUrl").ToString
                q.QuestionPlainText = dr("QuestionPlainText").ToString

                ql.Add(q)
            Next
        End Using

        Return ql
    End Function

    Public Shared Sub UpdateQuestion(ByVal q As Question)
        Dim ssql As String = "UPDATE tblquestion SET "
        ssql += String.Format("QuestionPlainText = '{0}'", q.QuestionPlainText)
        ssql += String.Format(",QuestionBranchResponse = '{0}'", q.QuestionBranchResponse)
        ssql += String.Format(",QuestionPopUnderUrl = '{0}'", q.QuestionPopUnderUrl)
        ssql += String.Format(",QuestionBranchUrl = '{0}'", q.QuestionBranchUrl)
        ssql += String.Format(",QuestionPopUpUrl = '{0}'", q.QuestionPopUpUrl)
        ssql += String.Format(",QuestionType = '{0}'", q.QuestionType)
        ssql += String.Format(",Question = '{0}', Active = {1} ", q.Question, IIf(q.Active = True, 1, 0))
        ssql += String.Format("where questionid = {0}", q.QuestionID)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)


    End Sub

#End Region 'Methods

#Region "Nested Types"

    <Serializable()> _
    Public Class Question

#Region "Fields"

        Private _Created As Date
        Private _HelpText As String
        Private _LastModified As Date
        Private _NextQuestionID As Integer
        Private _Question As String
        Private _QuestionBranchResponse As String
        Private _QuestionBranchUrl As String
        Private _QuestionID As Integer
        Private _QuestionOfferID As Integer
        Private _QuestionPlainText As String
        Private _QuestionPopUnderUrl As String
        Private _QuestionPopUpUrl As String
        Private _QuestionSeq As Integer
        Private _QuestionType As String
        Private _SurveyID As Integer
        Private _active As Boolean

#End Region 'Fields

#Region "Properties"

        Public Property Active() As Boolean
            Get
                Return _active
            End Get
            Set(ByVal value As Boolean)
                _active = value
            End Set
        End Property

        Public Property Created() As Date
            Get
                Return _Created
            End Get
            Set(ByVal Value As Date)
                _Created = Value
            End Set
        End Property

        Public Property HelpText() As String
            Get
                Return _HelpText
            End Get
            Set(ByVal Value As String)
                _HelpText = Value
            End Set
        End Property

        Public Property LastModified() As Date
            Get
                Return _LastModified
            End Get
            Set(ByVal Value As Date)
                _LastModified = Value
            End Set
        End Property

        Public Property NextQuestionID() As Integer
            Get
                Return _NextQuestionID
            End Get
            Set(ByVal Value As Integer)
                _NextQuestionID = Value
            End Set
        End Property

        Public Property Question() As String
            Get
                Return _Question
            End Get
            Set(ByVal Value As String)
                _Question = Value
            End Set
        End Property

        Public Property QuestionBranchResponse() As String
            Get
                Return _QuestionBranchResponse
            End Get
            Set(ByVal Value As String)
                _QuestionBranchResponse = Value
            End Set
        End Property

        Public Property QuestionBranchUrl() As String
            Get
                Return _QuestionBranchUrl
            End Get
            Set(ByVal Value As String)
                _QuestionBranchUrl = Value
            End Set
        End Property

        Public Property QuestionID() As Integer
            Get
                Return _QuestionID
            End Get
            Set(ByVal Value As Integer)
                _QuestionID = Value
            End Set
        End Property

        Public Property QuestionOfferID() As Integer
            Get
                Return _QuestionOfferID
            End Get
            Set(ByVal Value As Integer)
                _QuestionOfferID = Value
            End Set
        End Property

        Public Property QuestionPlainText() As String
            Get
                Return _QuestionPlainText
            End Get
            Set(ByVal Value As String)
                _QuestionPlainText = Value
            End Set
        End Property

        Public Property QuestionPopUnderUrl() As String
            Get
                Return _QuestionPopUnderUrl
            End Get
            Set(ByVal Value As String)
                _QuestionPopUnderUrl = Value
            End Set
        End Property

        Public Property QuestionPopUpUrl() As String
            Get
                Return _QuestionPopUpUrl
            End Get
            Set(ByVal Value As String)
                _QuestionPopUpUrl = Value
            End Set
        End Property

        Public Property QuestionSeq() As Integer
            Get
                Return _QuestionSeq
            End Get
            Set(ByVal Value As Integer)
                _QuestionSeq = Value
            End Set
        End Property

        Public Property QuestionType() As String
            Get
                Return _QuestionType
            End Get
            Set(ByVal Value As String)
                _QuestionType = Value
            End Set
        End Property

        Public Property SurveyID() As Integer
            Get
                Return _SurveyID
            End Get
            Set(ByVal Value As Integer)
                _SurveyID = Value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class QuestionOption

#Region "Fields"

        Private _Active As Boolean
        Private _Created As String
        Private _LastModified As String
        Private _NextQuestionID As Integer
        Private _OptionID As Integer
        Private _OptionText As String
        Private _QuestionID As Integer
        Private _Seq As Integer

#End Region 'Fields

#Region "Properties"

        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal Value As Boolean)
                _Active = Value
            End Set
        End Property

        Public Property Created() As String
            Get
                Return _Created
            End Get
            Set(ByVal Value As String)
                _Created = Value
            End Set
        End Property

        Public Property LastModified() As String
            Get
                Return _LastModified
            End Get
            Set(ByVal Value As String)
                _LastModified = Value
            End Set
        End Property

        Public Property NextQuestionID() As Integer
            Get
                Return _NextQuestionID
            End Get
            Set(ByVal Value As Integer)
                _NextQuestionID = Value
            End Set
        End Property

        Public Property OptionID() As Integer
            Get
                Return _OptionID
            End Get
            Set(ByVal Value As Integer)
                _OptionID = Value
            End Set
        End Property

        Public Property OptionText() As String
            Get
                Return _OptionText
            End Get
            Set(ByVal Value As String)
                _OptionText = Value
            End Set
        End Property

        Public Property QuestionID() As Integer
            Get
                Return _QuestionID
            End Get
            Set(ByVal Value As Integer)
                _QuestionID = Value
            End Set
        End Property

        Public Property Seq() As Integer
            Get
                Return _Seq
            End Get
            Set(ByVal Value As Integer)
                _Seq = Value
            End Set
        End Property

#End Region 'Properties

    End Class
#End Region 'Nested Types

End Class