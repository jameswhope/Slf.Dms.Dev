Imports Drg.Util.DataHelpers

Public MustInherit Class BusinessServicesBase

    Private objDAL As DataHelperBase

    Sub Init()
        objDAL = New DataHelperBase
    End Sub

    Public Function GetStates(Optional ByVal blnAddPleaseSelect As Boolean = False) As DataTable
        Dim tblStates As DataTable = objDAL.GetStates
        Dim row As DataRow

        If blnAddPleaseSelect Then
            row = tblStates.NewRow
            row("StateID") = -1
            row("Abbreviation") = ""
            row("Name") = "Please select"
            tblStates.Rows.InsertAt(row, 0)
        End If

        Return tblStates
    End Function

    Public Function SelectDistinct(ByVal tblSource As DataTable, ByVal columnName As String) As DataTable
        Dim tbl As DataTable
        Dim lastCol As Object = Nothing
        Dim row, duprow As DataRow

        tbl = New DataTable
        tbl.Columns.Add(columnName)
        tbl.AcceptChanges()

        For Each row In tblSource.Select("", columnName)
            If lastCol Is Nothing Then
                lastCol = row(columnName)
                duprow = tbl.NewRow
                duprow(0) = row(columnName)
                tbl.Rows.Add(duprow)
            Else
                If Not ColumnEqual(lastCol, row(columnName)) Then
                    lastCol = row(columnName)
                    duprow = tbl.NewRow
                    duprow(0) = row(columnName)
                    tbl.Rows.Add(duprow)
                End If
            End If
        Next

        Return tbl
    End Function

    Private Function ColumnEqual(ByVal col1 As Object, ByVal col2 As Object)
        If col1 Is DBNull.Value Or col2 Is DBNull.Value Then
            Return False
        Else
            Return col1.Equals(col2)
        End If
    End Function

End Class
