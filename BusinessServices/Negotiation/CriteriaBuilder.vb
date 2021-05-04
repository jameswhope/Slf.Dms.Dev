Imports Lexxiom.BusinessData
Imports System.Data
Imports Drg.Util.DataHelpers


Public Class CriteriaBuilder


    Private daCriteriaBuilder As Drg.Util.DataHelpers.CriteriaBuilder    

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        daCriteriaBuilder = New Drg.Util.DataHelpers.CriteriaBuilder()
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="ikeyId"></param>
    ''' <remarks></remarks>
    Public Sub Delete(ByVal ikeyId As Integer, ByVal UserId As Integer)
        Try
            daCriteriaBuilder.Delete(ikeyId, UserId)
            daCriteriaBuilder.DeleteCascade(ikeyId, UserId)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Add(ByVal dtTable As NegotiationData.NegotiationFilterDataDataTable, ByVal UserId As Integer, ByVal EntityId As Integer) As Integer
        Dim scopIdentity As Integer = 0
        Dim dtRow As NegotiationData.NegotiationFilterDataRow = dtTable.Rows(0)
        Try

            If dtRow.RowState = DataRowState.Added Then
                scopIdentity = daCriteriaBuilder.Add(dtTable, UserId)
            ElseIf dtRow.RowState = DataRowState.Modified Then
                scopIdentity = daCriteriaBuilder.Update(dtTable, UserId)
                daCriteriaBuilder.UpdateCascade(dtTable.Rows(0)("FilterId"), EntityId, UserId, dtTable.Rows(0)("FilterType"))
            End If
            Return scopIdentity
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Sub AppendToFilter(ByVal FilterClause As String, ByVal FilterDescription As String, ByVal FilterText As String, ByVal iKeyId As Integer, ByVal UserId As Integer, ByVal FilterType As String, ByVal EntityId As Integer)
        Try
            daCriteriaBuilder.AppendToFilter(FilterClause, FilterDescription, FilterText, iKeyId, UserId)
            daCriteriaBuilder.UpdateCascade(iKeyId, EntityId, UserId, FilterType)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function Validate(ByVal dtTable As NegotiationData.NegotiationFilterDataDataTable) As DataSet
        Dim dtRow As NegotiationData.NegotiationFilterDataRow = dtTable.Rows(0)
        Dim dsOverlap As DataSet = New DataSet
        Try
            dsOverlap = Validate(dtRow.FilterType.ToLower(), dtRow.FilterId, dtRow.FilterClause, dtRow.ParentFilterId)
            Return dsOverlap
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFilterType"></param>
    ''' <param name="ikey"></param>
    ''' <param name="sClause"></param>
    ''' <param name="iParentKey"></param>
    ''' <remarks></remarks>
    Public Overloads Function Validate(ByVal sFilterType As String, ByVal ikey As Integer, ByVal sClause As String, ByVal iParentKey As Integer) As DataSet
        Dim dsOverlap As DataSet = New DataSet
        Try
            Select Case sFilterType
                Case "root"
                    dsOverlap = daCriteriaBuilder.MasterCriteriaOverlap(ikey, sClause)
                Case "stem"
                    dsOverlap = daCriteriaBuilder.SiblingCriteriaOverlap(iParentKey, ikey, sClause)
            End Select
            Return dsOverlap
        Catch ex As Exception
            Throw ex
        Finally
            dsOverlap.Dispose()
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <param name="iFilterId"></param>
    ''' <param name="sType"></param>
    ''' <remarks></remarks>
    Public Sub SaveDetail(ByVal dtTable As Data.DataTable, ByVal iFilterId As Integer, ByVal sType As String)
        Try
            daCriteriaBuilder.SaveFilterDetail(dtTable, iFilterId, sType)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="dtTable"></param>
    ''' <param name="iFilterId"></param>
    ''' <param name="sType"></param>
    ''' <remarks></remarks>
    Public Sub SaveExclusion(ByVal dtTable As Data.DataTable, ByVal iFilterId As Integer, ByVal sType As String)
        Try
            daCriteriaBuilder.SaveExclusion(dtTable, iFilterId, sType)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FieldName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetFieldLookup(ByVal ExecString As String, ByVal FieldName As String) As DataSet
        Try
            Return daCriteriaBuilder.GetFieldLookup(ExecString, FieldName)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="iFilterId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetFilterDetail(ByVal iFilterId As Integer) As DataSet
        Try
            Return daCriteriaBuilder.GetFilterDetail(iFilterId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="UserId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function GetEntityId(ByVal UserId As Integer) As Integer
        Try
            If (IsAdministrator(UserId)) Then
                Return 0
            Else
                Return daCriteriaBuilder.GetEntityId(UserId)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="UserId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function IsAdministrator(ByVal UserId As Integer) As Boolean
        Try
            Return NegotiationHelper.IsAdministrator(UserId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sType"></param>
    ''' <param name="FilterId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetFilters(ByVal sType As String, ByVal FilterId As Integer) As Data.DataSet
        Try
            Return daCriteriaBuilder.GetFilters(sType, FilterId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="ParentFilterId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetFilters(ByVal ParentFilterId As Integer) As Data.DataSet
        Try
            Return daCriteriaBuilder.GetFilters(ParentFilterId)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetEntityFilters(ByVal EntityId As Integer, ByVal DisplayMode As String) As Data.DataSet
        Try
            Return daCriteriaBuilder.GetEntityFilters(EntityId, DisplayMode)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFilter"></param>
    ''' <param name="iGridSource"></param>
    ''' <param name="sType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function Preview(ByVal sFilter As String, ByVal ParentFilterId As Integer, ByVal iGridSource As Integer, ByVal sType As String) As Data.DataSet
        Dim dsPreview As DataSet = New DataSet
        Try
            Select Case sType.ToLower()
                Case "root"
                    dsPreview = daCriteriaBuilder.PreviewMasterCriteria(sFilter, iGridSource)
                Case "stem"
                    dsPreview = daCriteriaBuilder.PreviewSiblingCriteria(sFilter, iGridSource, ParentFilterId)
            End Select
            Return dsPreview
        Catch ex As Exception
            Throw ex
        Finally
            dsPreview.Dispose()
        End Try
    End Function

    Public Overloads Function Preview(ByVal ClientId As Integer, ByVal FilterId As Integer) As Data.DataSet
        Dim dsPreview As DataSet = New DataSet
        Try
            dsPreview = daCriteriaBuilder.PreviewDrill(ClientId, FilterId)
            Return dsPreview
        Catch ex As Exception
            Throw ex
        Finally
            dsPreview.Dispose()
        End Try
    End Function

    Public Function GetViewColumns() As Data.DataSet
        Dim dsViewColumns As DataSet = New DataSet
        Try
            dsViewColumns = daCriteriaBuilder.GetViewColumns()
            Return dsViewColumns
        Catch ex As Exception
            Throw ex
        Finally
            dsViewColumns.Dispose()
        End Try
    End Function

End Class
