Imports System
Imports System.Data
Imports System.Data.SqlClient

Public Class StatementDataHelper
   ''' <summary>
   ''' Converts a SqlDataReader to a DataSet
   ''' <param name='reader'>
   ''' SqlDataReader to convert.</param>
   ''' <returns>
   ''' DataSet filled with the contents of the reader.</returns>
   ''' </summary>
   Public Shared Function convertDataReaderToDataSet(ByVal reader As SqlDataReader) As DataSet
      Dim dataSet As New DataSet()
      Do
         ' Create new data table

         Dim schemaTable As DataTable = reader.GetSchemaTable()
         Dim dataTable As New DataTable()

         If schemaTable IsNot Nothing Then
            ' A query returning records was executed

            For i As Integer = 0 To schemaTable.Rows.Count - 1
               Dim dataRow As DataRow = schemaTable.Rows(i)
               ' Create a column name that is unique in the data table
               Dim columnName As String = DirectCast(dataRow("ColumnName"), String)
               '+ "<C" + i + "/>";
               ' Add the column definition to the data table
               Dim column As New DataColumn(columnName, DirectCast(dataRow("DataType"), Type))
               dataTable.Columns.Add(column)
            Next

            dataSet.Tables.Add(dataTable)

            ' Fill the data table we just created

            While reader.Read()
               Dim dataRow As DataRow = dataTable.NewRow()

               For i As Integer = 0 To reader.FieldCount - 1
                  dataRow(i) = reader.GetValue(i)
               Next

               dataTable.Rows.Add(dataRow)
            End While
         Else
            ' No records were returned

            Dim column As New DataColumn("RowsAffected")
            dataTable.Columns.Add(column)
            dataSet.Tables.Add(dataTable)
            Dim dataRow As DataRow = dataTable.NewRow()
            dataRow(0) = reader.RecordsAffected
            dataTable.Rows.Add(dataRow)
         End If
      Loop While reader.NextResult()
      Return dataSet
   End Function
End Class
