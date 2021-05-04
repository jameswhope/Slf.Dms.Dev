Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient

Imports Microsoft.VisualBasic

Imports SurveyHelper

Public Class DataMiningHelper

    #Region "Methods"

    Public Shared Function GetQuestions(ByVal surveyID As Integer) As List(Of DataMiningQuestion)
        Dim ql As New List(Of DataMiningQuestion)
        Dim ssql As String = "SELECT CAST(q.QuestionID AS varchar) + '|' + CAST(o.OptionID AS varchar) AS qoid , q.QuestionPlainText + ' ' + o.OptionText + '(' + CAST(COUNT(*) AS varchar) + ')' AS Question, COUNT(*) AS [ResponseCount] "
        ssql += "FROM tblLeadPath AS lp WITH (NOLOCK) INNER JOIN tblOptions AS o WITH (NOLOCK) ON o.OptionID = lp.OptionID INNER JOIN tblQuestion AS q WITH (NOLOCK) ON q.QuestionID = o.QuestionID "
        ssql += String.Format("WHERE (q.SurveyID = {0}) ", surveyID)
        ssql += "GROUP BY CAST(q.QuestionID AS varchar) + '|' + CAST(o.OptionID AS varchar), q.QuestionPlainText + ' ' + o.OptionText "
        ssql += "ORDER BY q.QuestionPlainText + ' ' + o.OptionText"

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim q As New DataMiningQuestion
                q.QuestionOptionID = dr("qoid").ToString
                q.QuestionText = dr("question").ToString
                q.Count = dr("ResponseCount").ToString

                ql.Add(q)
            Next
        End Using

        Return ql
    End Function

    #End Region 'Methods

    #Region "Nested Types"

    <DataObject(True)> _
    Public Class DataBatch

        #Region "Fields"

        Private _Active As Boolean
        Private _BatchName As String
        Private _Created As String
        Private _DataBatchID As Integer
        Private _LastExport As String
        Private _batchQuestions As List(Of DataBatchQuestionXRef)

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

        Public Property BatchName() As String
            Get
                Return _BatchName
            End Get
            Set(ByVal Value As String)
                _BatchName = Value
            End Set
        End Property

        Public Property BatchQuestions() As List(Of DataBatchQuestionXRef)
            Get
                Return _batchQuestions
            End Get
            Set(ByVal value As List(Of DataBatchQuestionXRef))
                _batchQuestions = value
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

        Public Property DataBatchID() As Integer
            Get
                Return _DataBatchID
            End Get
            Set(ByVal Value As Integer)
                _DataBatchID = Value
            End Set
        End Property

        Public Property LastExport() As String
            Get
                Return _LastExport
            End Get
            Set(ByVal Value As String)
                _LastExport = Value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"

        <DataObjectMethod(DataObjectMethodType.Select, True)> _
        Public Shared Function GetBatches() As List(Of DataBatch)
            Dim lst As New List(Of DataBatch)
            Using dt As DataTable = SqlHelper.GetDataTable("select * from tblDataBatch", CommandType.Text)
                For Each b As DataRow In dt.Rows
                    Dim bt As New DataBatch
                    bt.DataBatchID = b("DataBatchID").ToString
                    bt.BatchName = b("batchname").ToString
                    bt.Active = b("Active").ToString
                    bt.LastExport = b("LastExport").ToString
                    bt.Created = b("Created").ToString

                    Using dtQ As DataTable = SqlHelper.GetDataTable(String.Format("select * from tblDataBatchQuestionXRef where databatchid = {0}", bt.DataBatchID), CommandType.Text)
                        Dim bqs As New List(Of DataBatchQuestionXRef)
                        For Each q As DataRow In dtQ.Rows
                            Dim bq As New DataBatchQuestionXRef
                            bq.DataBatchQuestionID = q("DataBatchQuestionID").ToString
                            bq.DataBatchID = q("DataBatchID").ToString
                            bq.QuestionID = q("QuestionID").ToString
                            bq.OptionID = q("OptionID").ToString
                            bqs.Add(bq)
                        Next
                        bt.BatchQuestions = bqs
                    End Using
                    lst.Add(bt)
                Next
            End Using
            Return lst
        End Function

        <DataObjectMethod(DataObjectMethodType.Delete, True)> _
        Public Sub DeleteBatch(ByVal c As DataBatch)
            Dim ssql As String = "stp_databatch_DeleteBatch"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("DataBatchID", c.DataBatchID))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        End Sub

        <DataObjectMethod(DataObjectMethodType.Insert, True)> _
        Public Sub InsertBatch(ByVal c As DataBatch)
            ' Implement Insert logic
            Dim ssql As String = "stp_databatch_InsertBatch"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BatchName", c.BatchName))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        End Sub

        <DataObjectMethod(DataObjectMethodType.Update, True)> _
        Public Sub UpdateBatch(ByVal c As DataBatch)
            Dim ssql As String = "stp_databatch_UpdateBatch"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("DataBatchID", c.DataBatchID))
            params.Add(New SqlParameter("BatchName", c.BatchName))
            params.Add(New SqlParameter("Active", c.Active))
            params.Add(New SqlParameter("LastExport", IIf(IsNothing(c.LastExport), DBNull.Value, c.LastExport)))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        End Sub

        #End Region 'Methods

    End Class

    Public Class DataBatchQuestionXRef

        #Region "Fields"

        Private _DataBatchID As Integer
        Private _DataBatchQuestionID As Integer
        Private _OptionID As Integer
        Private _QuestionID As Integer

        #End Region 'Fields

        #Region "Properties"

        Public Property DataBatchID() As Integer
            Get
                Return _DataBatchID
            End Get
            Set(ByVal Value As Integer)
                _DataBatchID = Value
            End Set
        End Property

        Public Property DataBatchQuestionID() As Integer
            Get
                Return _DataBatchQuestionID
            End Get
            Set(ByVal Value As Integer)
                _DataBatchQuestionID = Value
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

        Public Property QuestionID() As Integer
            Get
                Return _QuestionID
            End Get
            Set(ByVal Value As Integer)
                _QuestionID = Value
            End Set
        End Property

        #End Region 'Properties

    End Class

    Public Class DataMiningQuestion

        #Region "Fields"

        Private _count As Integer
        Private _qid As String
        Private _qtext As String

        #End Region 'Fields

        #Region "Properties"

        Public Property Count() As Integer
            Get
                Return _count
            End Get
            Set(ByVal value As Integer)
                _count = value
            End Set
        End Property

        Public Property QuestionOptionID() As String
            Get
                Return _qid
            End Get
            Set(ByVal value As String)
                _qid = value
            End Set
        End Property

        Public Property QuestionText() As String
            Get
                Return _qtext
            End Get
            Set(ByVal value As String)
                _qtext = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    #End Region 'Nested Types

End Class