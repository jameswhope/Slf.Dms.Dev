Option Strict On

Imports Drg.Util.DataHelpers

Public Class BulkNegotiation
    Inherits Negotiation

    Private objBulkHelper As BulkNegotiationHelper

   Public Sub New()
      objBulkHelper = New BulkNegotiationHelper
   End Sub

    Public Function LoadDashBoardSummary(ByVal intUserID As Integer) As DataTable
        Dim objCriteriaHelper As New Drg.Util.DataHelpers.CriteriaBuilder
        Dim tblFilters As DataTable
        Dim tblDashboard As DataTable
        Dim intEntityID As Integer

        Try
            intEntityID = objCriteriaHelper.GetEntityId(intUserID)

            tblFilters = objCriteriaHelper.GetEntityFilters(intEntityID, "base").Tables(0)
            tblFilters.Columns.Add("ClientCount", GetType(String))
            tblFilters.Columns.Add("AccountCount", GetType(String))
            tblFilters.Columns.Add("StatusCount", GetType(String))
            tblFilters.Columns.Add("StateCount", GetType(String))
            tblFilters.Columns.Add("ZipCodeCount", GetType(String))
            tblFilters.Columns.Add("CreditorCount", GetType(String))
            tblFilters.Columns.Add("TotalSDAAmount", GetType(String))

            For Each row As DataRow In tblFilters.Rows
                tblDashboard = objBulkHelper.GetDashBoard(CInt(row("FilterId")))
                If tblDashboard.Rows.Count > 0 Then
                    row("ClientCount") = tblDashboard.Rows(0)("ClientCount")
                    row("AccountCount") = tblDashboard.Rows(0)("AccountCount")
                    row("StatusCount") = tblDashboard.Rows(0)("StatusCount")
                    row("StateCount") = tblDashboard.Rows(0)("StateCount")
                    row("ZipCodeCount") = tblDashboard.Rows(0)("ZipCodeCount")
                    row("CreditorCount") = tblDashboard.Rows(0)("CreditorCount")
                    row("TotalSDAAmount") = String.Format("{0:c}", tblDashboard.Rows(0)("FundsAvailable"))
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try

        Return tblFilters

    End Function

    Public Function LoadBulkLists(ByVal intUserID As Integer) As DataTable
        Dim tblLists As DataTable

        Try
            tblLists = objBulkHelper.GetMyBulkLists(intUserID)
        Catch ex As Exception
            Throw ex
        End Try

        Return tblLists
    End Function

    Public Function GetListColumns(ByVal BulkListId As Integer) As DataTable
        Dim tblColumns As DataTable
        'Get List Columns Here
        tblColumns = objBulkHelper.GetListColumns(BulkListId)
        Return tblColumns
    End Function

    Public Function GetTemplateColumns(ByVal TemplateId As Integer) As DataTable
        Dim tblColumns As DataTable

        If TemplateId = -1 Then
            'Get Default columns
            tblColumns = objBulkHelper.GetDefaultColumns()
        Else
            'Get Template Columns Here
        End If
        Return tblColumns
    End Function

    Public Function GetAssigmentsByFilterId(ByVal FilterId As Integer) As DataTable
        Dim tblAssignments As DataTable
        'Get Assignments
        tblAssignments = objBulkHelper.GetAssignmentsByFilterId(FilterId)
        Return tblAssignments
    End Function

    Public Function GetAssigmentsByListId(ByVal BulkListId As Integer) As DataTable
        Dim tblAssignments As DataTable
        'Get Assignments
        tblAssignments = objBulkHelper.GetAssignmentsByListId(BulkListId)
        Return tblAssignments
    End Function

    Public Function GetAvailableCols(ByVal intBulkListID As Integer, Optional ByVal blnAddInsertCol As Boolean = True) As DataTable
        Dim tblCols As DataTable = objBulkHelper.GetAvailableCols(intBulkListID)
        Dim row As DataRow

        If blnAddInsertCol Then
            row = tblCols.NewRow
            row("Display") = "Insert Column"
            row("BulkFieldID") = "-1"
            tblCols.Rows.InsertAt(row, 0)
            tblCols.AcceptChanges()
        End If

        Return tblCols
    End Function

    Public Function GetAllColumns() As DataTable
        Dim tblCols As DataTable = objBulkHelper.GetAllColumns()
        Return tblCols
    End Function

    Public Function AddBulkList(ByVal strListName As String, ByVal intCreatedBy As Integer, ByVal intOwnedBy As Integer) As Integer
        Return objBulkHelper.AddBulkList(strListName.Trim, intCreatedBy, intOwnedBy)
    End Function

    Public Sub AddToBulkList(ByVal intBulkListID As Integer, ByVal intAccountID As Integer)
        objBulkHelper.AddToBulkList(intBulkListID, intAccountID)
    End Sub

    Public Sub RemoveFromBulkList(ByVal intBulkListID As Integer, ByVal intAccountID As Integer)
        objBulkHelper.RemoveFromBulkList(intBulkListID, intAccountID)
    End Sub

    Public Overloads Sub AddToListTemplate(ByVal intBulkListID As Integer, ByVal intBulkFieldID As Integer)
        objBulkHelper.AddToListTemplate(intBulkListID, intBulkFieldID, Nothing)
    End Sub

    Public Overloads Sub AddToListTemplate(ByVal intBulkListID As Integer, ByVal intBulkFieldID As Integer, ByVal Position As Integer)
        objBulkHelper.AddToListTemplate(intBulkListID, intBulkFieldID, Position)
    End Sub

    Public Sub DeleteFromListTemplate(ByVal intBulkListID As Integer, ByVal intBulkFieldID As Integer)
        objBulkHelper.DeleteFromListTemplate(intBulkListID, intBulkFieldID)
    End Sub

    Public Sub UpdateListTemplate(ByVal intBulkListID As Integer, ByVal ColumnListIds As String)
        Dim currentColumns As DataTable = GetListColumns(intBulkListID)
        Dim newColumns As String() = ColumnListIds.Split(","c)
        'Delete non-existing columns
        For Each dr As DataRow In currentColumns.Rows
            If Array.IndexOf(newColumns, dr("BulkFieldId").ToString) = -1 Then
                DeleteFromListTemplate(intBulkListID, Int32.Parse(dr("BulkFieldId").ToString))
            End If
        Next
        'Add All Columns
        For i As Integer = 0 To newColumns.Length - 1
            AddToListTemplate(intBulkListID, Int32.Parse(newColumns(i)), i)
        Next
    End Sub

    Public Sub UpdateAccountCurrentAmount(ByVal AccountId As Integer, ByVal Amount As Double, ByVal UserId As Integer)
        'Change Amount and CreditorInstanceAmount
        objBulkHelper.ChangeAccountCurrentAmount(AccountId, Amount, UserId)
    End Sub

    Public Sub SaveBulkList(ByVal BulkListId As Integer, ByVal AccountId As Integer, ByVal LastOfferMade As String, ByVal LastOfferReceived As String, ByVal LastNote As String, ByVal intUserID As Integer)
        objBulkHelper.SaveBulkList(BulkListId, AccountId, LastOfferMade, LastOfferReceived, LastNote, intUserID)
    End Sub


End Class