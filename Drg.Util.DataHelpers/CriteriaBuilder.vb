Imports Drg.Util.DataAccess
Imports Lexxiom.BusinessData
Imports System.Data.SqlClient
Imports System.Text




Public Class CriteriaBuilder
    Protected intCommandTimeOut As Integer = 90
    Protected cmdObj As IDbCommand

    Protected Overloads Function GetCommand(ByVal spName As String) As IDbCommand
        cmdObj = ConnectionFactory.CreateCommand(spName)
        cmdObj.CommandTimeout = intCommandTimeOut
        Return cmdObj
    End Function

    Protected Overloads Function GetCommand() As IDbCommand
        cmdObj = ConnectionFactory.Create().CreateCommand
        cmdObj.CommandTimeout = intCommandTimeOut
        Return cmdObj
    End Function


#Region "COMMON  "

    Public Function Add(ByVal dtTable As NegotiationData.NegotiationFilterDataDataTable, ByVal UserId As Integer) As Integer
        Dim dtRow As NegotiationData.NegotiationFilterDataRow
        Try
            If dtTable.Rows.Count > 0 Then
                dtRow = dtTable.Rows(0)
                cmdObj = GetCommand("stp_NegotiationFilterInsert")

                Return ExecuteAddUpdate(cmdObj, dtRow, UserId)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            If Not cmdObj Is Nothing Then
                DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
                Dispose(cmdObj)
            End If
        End Try
    End Function

    Public Overloads Function Update(ByVal dtTable As NegotiationData.NegotiationFilterDataDataTable, ByVal UserId As Integer) As Integer
        Dim dtRow As NegotiationData.NegotiationFilterDataRow
        Try
            If dtTable.Rows.Count > 0 Then
                dtRow = dtTable.Rows(0)
                cmdObj = GetCommand("stp_NegotiationFilterUpdate")
                Return ExecuteAddUpdate(cmdObj, dtRow, UserId)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            If Not cmdObj Is Nothing Then
                DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
                Dispose(cmdObj)
            End If
        End Try
    End Function

#Region "PARENT_ChILD CASCADE UPDATE"
    Public Overloads Sub Update(ByVal FilterId As Integer, ByVal AggregateClause As String, ByVal UserId As Integer)
        Try
            cmdObj = GetCommand("stp_NegotiationFilterHierarchyUpdate")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "AggregateClause", AggregateClause)
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        Finally
            If Not cmdObj Is Nothing Then
                DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
                Dispose(cmdObj)
            End If
        End Try
    End Sub

    Public Sub UpdateCascade(ByVal FilterId As Integer, ByVal EntityId As Integer, ByVal UserId As Integer, ByVal FilterType As String)
        Dim dsSib As DataSet = New DataSet
        Dim sAggregateFilterClause As String
        Dim indx As Integer
        Try
            dsSib = GetSiblings(FilterId)
            If (dsSib.Tables.Count > 0) Then
                If (dsSib.Tables(0).Rows.Count > 0) Then

                    If (EntityId > 0) Then
                        sAggregateFilterClause = GetAggregateSiblingCriteria(EntityId, FilterId)
                    Else
                        sAggregateFilterClause = GetAggregateCriteria(FilterId, FilterType)
                    End If
                    UpdateSibling(dsSib)
                    For indx = 0 To dsSib.Tables(0).Rows.Count - 1
                        Update(dsSib.Tables(0).Rows(indx)("FilterId"), sAggregateFilterClause, UserId)
                    Next
                End If
            End If

        Catch ex As Exception
            Throw ex
        Finally
            dsSib.Dispose()
        End Try
    End Sub

    Public Sub UpdateSibling(ByRef dsSib As DataSet)
        Dim indx As Integer
        Dim indxsib As Integer
        Dim ds As DataSet = New DataSet
        Dim dtRow() As DataRow
        Dim blnAddNew As Boolean = False

        Try

            If (dsSib.Tables(0).Rows.Count > 0) Then
                For indx = 0 To dsSib.Tables(0).Rows.Count - 1                    
                    ds = GetSiblings(dsSib.Tables(0).Rows(indx)("FilterId"))
                    If (ds.Tables.Count > 0) Then
                        If (ds.Tables(0).Rows.Count > 0) Then
                            For indxsib = 0 To ds.Tables(0).Rows.Count - 1
                                dtRow = dsSib.Tables(0).Select("filterId=" & ds.Tables(0).Rows(indxsib)("FilterId"))
                                If dtRow.Length = 0 Then
                                    dsSib.Tables(0).ImportRow(ds.Tables(0).Rows(indxsib))
                                    blnAddNew = True
                                End If
                            Next
                        End If
                    End If
                Next
                If (blnAddNew = True) Then UpdateSibling(dsSib)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsSib.Dispose()
        End Try
    End Sub

    Protected Function GetSiblings(ByVal FilterId As Integer) As DataSet
        Dim dsSibling As DataSet = New DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationChildFilterSelect")
            DatabaseHelper.AddParameter(cmdObj, "ParentFilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "RetrieveToDelete", 1)
            DatabaseHelper.ExecuteDataset(cmdObj, dsSibling)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            dsSibling.Dispose()
        End Try
        Return dsSibling
    End Function

    Protected Function GetAggregateCriteria(ByVal FilterId As Integer, ByVal FilterType As String) As String
        Dim dsAggregate As DataSet = New DataSet
        Dim sAggregateClause As String = ""
        Try
            cmdObj = GetCommand("stp_NegotiationMasterBaseFilterSelect")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "FilterType", FilterType)
            DatabaseHelper.ExecuteDataset(cmdObj, dsAggregate)
            If (dsAggregate.Tables(0).Rows.Count > 0) Then sAggregateClause = dsAggregate.Tables(0).Rows(0)("AndFilter")

        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            dsAggregate.Dispose()
        End Try
        Return sAggregateClause
    End Function

    Protected Function GetAggregateSiblingCriteria(ByVal EntityId As Integer, ByVal FilterId As Integer) As String
        Dim dsAggregate As DataSet = New DataSet
        Dim sAggregateClause As String = ""
        Try
            cmdObj = GetCommand("stp_NegotiationSiblingBaseFilterSelect")
            DatabaseHelper.AddParameter(cmdObj, "EntityId", EntityId)
            DatabaseHelper.AddParameter(cmdObj, "StemFilterId", FilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsAggregate)
            If (dsAggregate.Tables(0).Rows.Count > 0) Then sAggregateClause = dsAggregate.Tables(0).Rows(0)("AggregateClause")

        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            dsAggregate.Dispose()
        End Try
        Return sAggregateClause
    End Function

#End Region

    Public Sub AppendToFilter(ByVal FilterClause As String, ByVal FilterDescription As String, ByVal FilterText As String, ByVal iKeyId As Integer, ByVal UserId As Integer)
        Try
            cmdObj = GetCommand("stp_NegotiationFilterAppend")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", iKeyId)
            DatabaseHelper.AddParameter(cmdObj, "FilterClause", FilterClause)
            DatabaseHelper.AddParameter(cmdObj, "Description", FilterDescription)
            DatabaseHelper.AddParameter(cmdObj, "FilterText", FilterText)
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)

        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Sub
    Public Sub Delete(ByVal ikeyId As Integer, ByVal UserId As Integer)
        Try
            cmdObj = GetCommand("stp_NegotiationFilterDelete")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", ikeyId)
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)

            cmdObj = GetCommand("stp_NegotiationFilterDeleteMasterSubs")
            DatabaseHelper.AddParameter(cmdObj, "ParentFilterID", ikeyId)
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)

            Using reader As SqlDataReader = DatabaseHelper.ExecuteReader(cmdObj)
                While reader.Read()
                    DeleteCascade(CInt(reader("FilterID")), UserId)
                End While
            End Using
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Sub

    Public Sub DeleteCascade(ByVal FilterId As Integer, ByVal UserId As Integer)
        Dim dsSib As DataSet = New DataSet
        Dim indx As Integer
        Try
            dsSib = GetSiblings(FilterId)
            If (dsSib.Tables.Count > 0) Then
                If (dsSib.Tables(0).Rows.Count > 0) Then
                    For indx = 0 To dsSib.Tables(0).Rows.Count - 1
                        Delete(dsSib.Tables(0).Rows(indx)("FilterId"), UserId)
                    Next
                End If
                If (dsSib.Tables(0).Rows.Count > 0) Then
                    DeleteSibling(dsSib)
                    For indx = 0 To dsSib.Tables(0).Rows.Count - 1
                        Delete(dsSib.Tables(0).Rows(indx)("FilterId"), UserId)
                    Next
                End If
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsSib.Dispose()
        End Try
    End Sub

    Public Sub DeleteSibling(ByRef dsSib As DataSet)
        Dim indx As Integer
        Dim indxsib As Integer
        Dim ds As DataSet = New DataSet
        Dim dtRow() As DataRow
        Dim blnAddNew As Boolean = False

        Try

            If (dsSib.Tables(0).Rows.Count > 0) Then
                For indx = 0 To dsSib.Tables(0).Rows.Count - 1
                    ds = GetSiblings(dsSib.Tables(0).Rows(indx)("FilterId"))
                    If (ds.Tables.Count > 0) Then
                        If (ds.Tables(0).Rows.Count > 0) Then
                            For indxsib = 0 To ds.Tables(0).Rows.Count - 1
                                dtRow = dsSib.Tables(0).Select("filterId=" & ds.Tables(0).Rows(indxsib)("FilterId"))
                                If dtRow.Length = 0 Then
                                    dsSib.Tables(0).ImportRow(ds.Tables(0).Rows(indxsib))
                                    blnAddNew = True
                                End If
                            Next
                        End If
                    End If
                Next
                If (blnAddNew = True) Then DeleteSibling(dsSib)
            End If
        Catch ex As Exception
            Throw ex
        Finally
            dsSib.Dispose()
        End Try
    End Sub

    Public Function GetViewColumns() As DataSet
        Dim dsViewColumns As DataSet = New DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationViewColumnSelect")
            DatabaseHelper.ExecuteDataset(cmdObj, dsViewColumns)
            Return dsViewColumns
        Catch ex As Exception
            Throw ex
        Finally
            dsViewColumns.Dispose()
        End Try
    End Function

    Protected Function ExecuteAddUpdate(ByVal cmd As SqlCommand, ByVal dtRow As NegotiationData.NegotiationFilterDataRow, ByVal UserId As Integer) As Integer
        Try
            DatabaseHelper.AddParameter(cmd, "FilterId", dtRow.FilterId)
            DatabaseHelper.AddParameter(cmd, "FilterDescription", dtRow.Description)
            DatabaseHelper.AddParameter(cmd, "FilterClause", dtRow.FilterClause)
            DatabaseHelper.AddParameter(cmd, "FilterType", dtRow.FilterType)
            DatabaseHelper.AddParameter(cmd, "FilterText", dtRow.FilterText)
            DatabaseHelper.AddParameter(cmd, "ParentFilterId", dtRow.ParentFilterId)
            DatabaseHelper.AddParameter(cmd, "UserId", UserId)
            cmd.CommandTimeout = intCommandTimeOut
            Return DatabaseHelper.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Public Overloads Function GetFilters(ByVal sType As String, ByVal iFilterId As Integer) As Data.DataSet
        Dim dsFilters As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationFilterSelect")
            cmdObj.CommandTimeout = intCommandTimeOut
            DatabaseHelper.AddParameter(cmdObj, "FilterType", sType)
            DatabaseHelper.AddParameter(cmdObj, "FilterId", iFilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsFilters)
            Return dsFilters
        Catch ex As Exception
            Throw ex
        Finally
            Dispose(dsFilters)
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Function

    Public Overloads Function GetFilters(ByVal ParentFilterId As Integer) As Data.DataSet
        Dim dsFilters As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationChildFilterSelect")
            DatabaseHelper.AddParameter(cmdObj, "ParentFilterId", ParentFilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsFilters)
            Return dsFilters
        Catch ex As Exception
            Throw ex
        Finally
            Dispose(dsFilters)
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Function

    Public Overloads Function GetEntityFilters(ByVal EntityId As Integer, ByVal DisplayMode As String) As Data.DataSet
        Dim dsFilters As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationEntityFilterSelect")
            DatabaseHelper.AddParameter(cmdObj, "EntityId", EntityId)
            DatabaseHelper.AddParameter(cmdObj, "DisplayMode", DisplayMode)
            DatabaseHelper.ExecuteDataset(cmdObj, dsFilters)
            Return dsFilters
        Catch ex As Exception
            Throw ex
        Finally
            Dispose(dsFilters)
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Function

    Public Function GetFilterDetail(ByVal iFilterId As Integer) As Data.DataSet
        Dim dsFilter As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationFilterDetailSelect")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", iFilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsFilter)
            Return dsFilter
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsFilter)
        End Try
    End Function

    Public Sub SaveFilterDetail(ByVal dtTable As Data.DataTable, ByVal FilterId As Integer, ByVal sType As String)
        Dim indx As Integer
        Dim sb As StringBuilder = New StringBuilder()
        Dim sCmdString As String = ""
        Try
            RemoveCriteriaDetail(FilterId)
            cmdObj = GetCommand("stp_NegotiationFilterDetailInsert")
            For indx = 0 To dtTable.Rows.Count - 1
                sb.Length = 0
                cmdObj.Parameters.Clear()
                BuildParams(cmdObj, dtTable.Rows(indx), indx, sb, FilterId, sType)
                DatabaseHelper.ExecuteNonQuery(cmdObj)
            Next
            CleanExclusion(FilterId)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Sub

    Public Function GetFieldLookup(ByVal ExecWhere As String, ByVal ExecFieldName As String) As DataSet

        Dim dsCriteriaLookup As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationCriteriaLookup")
            DatabaseHelper.AddParameter(cmdObj, "ExecWhere", ExecWhere)
            DatabaseHelper.AddParameter(cmdObj, "ExecField", ExecFieldName)
            DatabaseHelper.ExecuteDataset(cmdObj, dsCriteriaLookup)
            Return dsCriteriaLookup
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsCriteriaLookup)
        End Try
    End Function

    Public Sub SaveExclusion(ByVal dtTable As Data.DataTable, ByVal FilterId As Integer, ByVal sType As String)
        Dim indx As Integer
        Dim sb As StringBuilder = New StringBuilder()
        Dim sCmdString As String = ""
        Try
            cmdObj = GetCommand("stp_NegotiationFilterDetailInsert")
            For indx = 0 To dtTable.Rows.Count - 1
                sb.Length = 0
                cmdObj.Parameters.Clear()
                BuildParams(cmdObj, dtTable.Rows(indx), indx, sb, FilterId, sType)
                DatabaseHelper.ExecuteNonQuery(cmdObj)
            Next
            CleanExclusion(FilterId)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Sub

    Private Sub CleanExclusion(ByVal FilterId As Integer)
        Try
            cmdObj = GetCommand("stp_NegotiationFilterDetailCleanUp")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try

    End Sub

    Private Sub RemoveCriteriaDetail(ByVal FilterId As Integer)
        Try
            cmdObj = GetCommand("stp_NegotiationFilterDetailDelete")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
        End Try
    End Sub

    Private Sub BuildParams(ByRef cmd As SqlCommand, ByVal dtRow As Data.DataRow, ByVal rowIndx As Integer, ByVal sb As StringBuilder, ByVal masterListId As Integer, ByVal sType As String)
        DatabaseHelper.AddParameter(cmd, "FilterId", masterListId)
        DatabaseHelper.AddParameter(cmd, "FilterType", sType)
        DatabaseHelper.AddParameter(cmd, "sequence", rowIndx)
        DatabaseHelper.AddParameter(cmd, "FieldName", dtRow("FieldName"))
        DatabaseHelper.AddParameter(cmd, "Operation", dtRow("drpFilter"))
        DatabaseHelper.AddParameter(cmd, "OperationVisible", dtRow("drpFilterVisible"))
        DatabaseHelper.AddParameter(cmd, "FirstInput", dtRow("Input1"))
        DatabaseHelper.AddParameter(cmd, "FirstInputVisible", dtRow("Input1Visible"))
        DatabaseHelper.AddParameter(cmd, "JoinClause", dtRow("drpClause"))
        DatabaseHelper.AddParameter(cmd, "JoinClauseVisible", dtRow("drpClauseVisible"))
        DatabaseHelper.AddParameter(cmd, "PctOf", dtRow("drpPctOf"))
        DatabaseHelper.AddParameter(cmd, "PctOfVisible", dtRow("drpPctOfVisible"))
        DatabaseHelper.AddParameter(cmd, "PctField", dtRow("drpPctField"))
        DatabaseHelper.AddParameter(cmd, "PctFieldVisible", dtRow("drpPctFieldVisible"))
    End Sub

#End Region

#Region "MASTER/SIBLING CRITERIA "

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="iParentFilterId"></param>
    ''' <param name="FilterId"></param>
    ''' <param name="FilterClause"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function SiblingCriteriaOverlap(ByVal iParentFilterId As Integer, ByVal FilterId As Integer, ByVal FilterClause As String) As DataSet
        Dim dsOverlap As DataSet = New DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationSiblingFilterExclusion")
            DatabaseHelper.AddParameter(cmdObj, "ParentEntityId", iParentFilterId)
            DatabaseHelper.AddParameter(cmdObj, "SourceFilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "filterClause", FilterClause)
            DatabaseHelper.ExecuteDataset(cmdObj, dsOverlap)
            Return dsOverlap
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsOverlap)
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FilterId"></param>
    ''' <param name="FilterClause"></param>
    ''' <remarks></remarks>
    Public Function MasterCriteriaOverlap(ByVal FilterId As Integer, ByVal FilterClause As String) As DataSet
        Dim dsOverlap As DataSet = New DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationMasterFilterExclusion")
            DatabaseHelper.AddParameter(cmdObj, "SourceFilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "filterClause", FilterClause)
            DatabaseHelper.ExecuteDataset(cmdObj, dsOverlap)
            Return dsOverlap
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsOverlap)
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFilter"></param>
    ''' <param name="iGridSource"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function PreviewSiblingCriteria(ByVal sFilter As String, ByVal iGridSource As Integer, ByVal ParentFilterId As Integer) As Data.DataSet
        Dim dsPreview As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationPreviewSibling")
            DatabaseHelper.AddParameter(cmdObj, "filterClause", sFilter)
            DatabaseHelper.AddParameter(cmdObj, "GridFilterId", iGridSource)
            DatabaseHelper.AddParameter(cmdObj, "ParentFilterId", ParentFilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsPreview)
            Return dsPreview
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsPreview)
        End Try
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sFilter"></param>
    ''' <param name="iGridSource"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function PreviewMasterCriteria(ByVal sFilter As String, ByVal iGridSource As Integer) As Data.DataSet
        Dim dsPreview As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationPreviewMaster")
            DatabaseHelper.AddParameter(cmdObj, "filterClause", sFilter)
            DatabaseHelper.AddParameter(cmdObj, "GridFilterId", iGridSource)
            DatabaseHelper.ExecuteDataset(cmdObj, dsPreview)
            Return dsPreview
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsPreview)
        End Try
    End Function

    Public Function PreviewDrill(ByVal ClientId As Integer, ByVal FilterId As Integer) As Data.DataSet
        Dim dsPreview As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationPreviewDrill")
            DatabaseHelper.AddParameter(cmdObj, "ClientId", ClientId)
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsPreview)
            Return dsPreview
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsPreview)
        End Try
    End Function


#End Region

#Region "DISPOSE"
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="cmd"></param>
    ''' <remarks></remarks>
    Protected Sub Dispose(ByVal cmd As SqlCommand)
        If Not (cmd Is Nothing) Then cmd.Dispose()
    End Sub

    Protected Sub Dispose(ByVal cmd As IDbCommand)
        If Not (cmd Is Nothing) Then cmd.Dispose()
    End Sub

    Protected Sub Dispose(ByVal ds As DataSet)
        If Not (ds Is Nothing) Then ds.Dispose()
    End Sub

#End Region

#Region "GET ENTITY ID"
    Public Function GetEntityId(ByVal UserId) As Integer
        Dim sQuery As String = ""
        Dim entityId As Integer = -999
        Try
            Using cmd As New SqlCommand("", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()
                    sQuery = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and UserID = " & UserId
                    cmd.CommandText = sQuery
                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        If rd.HasRows Then
                            rd.Read()
                            entityId = rd("NegotiationEntityID")
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw ex
        End Try
        Return entityId
    End Function

#End Region

End Class


''' <summary>
''' Criteria Dashboard Class
''' </summary>
''' <remarks></remarks>
Public Class CriteriaDashBoard
    Inherits CriteriaBuilder

#Region "DASHBOARD ITEMS "

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FilterId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetDashBoard(ByVal FilterId As Integer) As Data.DataSet
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationDashBoardSummary")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsDashboard)
            Return dsDashboard
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsDashboard)
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FilterId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetDashBoard(ByVal FilterId As Integer, ByVal FilterClause As String) As Data.DataSet
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationDashBoardSummary")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "GridFilterClause", FilterClause)
            DatabaseHelper.ExecuteDataset(cmdObj, dsDashboard)
            Return dsDashboard
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsDashboard)
        End Try
    End Function

    Public Overloads Function GetDashBoard(ByVal ParentFilterId As Integer, ByVal FilterId As Integer, ByVal FilterClause As String) As Data.DataSet
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationSiblingDashBoardSummary")
            DatabaseHelper.AddParameter(cmdObj, "ParentFilterId", ParentFilterId)
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "GridFilterClause", FilterClause)
            DatabaseHelper.ExecuteDataset(cmdObj, dsDashboard)
            Return dsDashboard
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsDashboard)
        End Try
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FilterId"></param>
    ''' <param name="ParentFilterId"></param>
    ''' <param name="FilterClause"></param>
    ''' <param name="sFiltertype"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetDashBoard(ByVal FilterId As Integer, ByVal ParentFilterId As Integer, ByVal FilterClause As String, ByVal sFiltertype As String) As Data.DataSet
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            Select Case sFiltertype
                Case "root"
                    'MasterCriteriaOverlap(FilterId, FilterClause)
                    dsDashboard = GetDashBoard(FilterId, FilterClause)
                Case "stem"
                    'SiblingCriteriaOverlap(ParentFilterId, FilterId, FilterClause)
                    dsDashboard = GetDashBoard(ParentFilterId, FilterId, FilterClause)
            End Select

            Return dsDashboard
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsDashboard)
        End Try
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="FilterId"></param>
    ''' <param name="sSummaryType"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overloads Function GetDashBoardSummary(ByVal FilterId As Integer, ByVal sSummaryType As String) As Data.DataSet
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_NegotiationDashBoardDrill")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.AddParameter(cmdObj, "DrillType", sSummaryType)
            DatabaseHelper.ExecuteDataset(cmdObj, dsDashboard)
            Return dsDashboard
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(dsDashboard)
            Dispose(cmdObj)
        End Try
    End Function
#End Region

End Class


