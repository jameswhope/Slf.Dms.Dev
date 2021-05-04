Imports Lexxiom.BusinessData
Imports System.Data
Imports Drg.Util.DataHelpers


Public Class CriteriaDashBoard
    Private daCriteriaDashBoard As Drg.Util.DataHelpers.CriteriaDashBoard


    Public Sub New()
        daCriteriaDashBoard = New Drg.Util.DataHelpers.CriteriaDashBoard
    End Sub

    Public Overloads Function GetDashBoard(ByVal iKeyId As Integer) As Data.DataSet
        Try
            Return daCriteriaDashBoard.GetDashBoard(iKeyId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Overloads Function GetDashBoard(ByVal iKeyId As Integer, ByVal FilterClause As String) As Data.DataSet
        Try
            Return daCriteriaDashBoard.GetDashBoard(iKeyId, FilterClause)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Overloads Function GetDashBoard(ByVal iKeyId As Integer, ByVal iParentKeyId As Integer, ByVal sFilterClause As String, ByVal sFilterType As String) As Data.DataSet
        Try
            Return daCriteriaDashBoard.GetDashBoard(iKeyId, iParentKeyId, sFilterClause, sFilterType)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetDashBoardSummary(ByVal iKeyId As Integer, ByVal sSummaryType As String) As Data.DataSet
        Try
            Return daCriteriaDashBoard.GetDashBoardSummary(iKeyId, sSummaryType)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class
