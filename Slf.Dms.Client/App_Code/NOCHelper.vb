Imports System
Imports System.Data
Imports Drg.Util.DataAccess
Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class NOCHelper

    Public Shared Function BuildReportSQL(ByVal StartDate As String, ByVal Flags As Boolean, Optional ByVal EndDate As String = "01/01/2050", Optional ByVal AccountNumber As String = "", Optional ByVal ClientID As Integer = 0) As DataTable

        Dim i As Integer = -1
        Dim WhereClause As String = ""
        Dim Space As Char = " "c
        Dim Hyphen As Char = "-"c
        Dim Delimiters() As Char = {Space, Hyphen}
        Dim connectionString As String = ConfigurationManager.AppSettings("WAconnectionstring").ToString
        Dim dtReturns As DataTable

        Try
            Dim strSQL As String = "stp_NOC_Returns"
            Dim param As New SqlParameter
            Using cn As New SqlConnection(connectionString)
                cn.Open()
                Using cmd As New SqlCommand(strSQL, cn)
                    cmd.CommandType = CommandType.StoredProcedure
                    'Add the parameters some are 
                    cmd.Parameters.Add("@StartDate", SqlDbType.DateTime)
                    cmd.Parameters("@StartDate").Value = StartDate
                    cmd.Parameters.Add("@EndDate", SqlDbType.DateTime)
                    cmd.Parameters("@EndDate").Value = EndDate
                    If ClientID > 0 Then
                        cmd.Parameters.Add("@ClientID", SqlDbType.Int)
                        cmd.Parameters("@ClientID").Value = ClientID
                    End If
                    If AccountNumber <> "" Then
                        cmd.Parameters.Add("@AccountNumber", SqlDbType.VarChar)
                        cmd.Parameters("@AccountNumber").Value = "'" & AccountNumber & "'"
                    End If
                    dtReturns = New DataTable
                    Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                        dtReturns.Load(rdr)
                        Return dtReturns
                    End Using
                End Using
            End Using

        Catch ex As Exception
            Alert.Show("Error reading report data. " & ex.Message)
        End Try

    End Function

    Public Shared Function GetClientSQL() As String
        Return "SELECT ClientID, LastName + ', ' + FirstName as Name FROM tblPerson ORDER BY LastName"
    End Function

    Public Shared Function GetClients(ByVal strSQL As String, ByVal tblName As String) As DataSet
        Dim ds As New DataSet
        Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
            cnSQL.Open()
            Dim ClAdapter As New SqlDataAdapter(strSQL, cnSQL)
            ClAdapter.Fill(ds)
            ds.Tables(0).TableName = tblName
        End Using
        Return ds
    End Function

    Public Shared Function CreateTheReturnTable() As DataTable
        Dim dt As DataTable = New DataTable("ReturnedItems")
        Dim column As DataColumn

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "NOC5ID"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "ClientID"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "RegisterID"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "AccountNo"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "ClientName"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "RoutingNumber"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "AccountNumber"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "Amount"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "LawFirm"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "EffectiveDate"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "BouncedDescription"
        dt.Columns.Add(column)

        column = New DataColumn
        column.DataType = System.Type.GetType("System.String")
        column.ColumnName = "TraceNumber"
        dt.Columns.Add(column)

        Return dt
    End Function

    Public Overloads Shared Function getReportDataSet(ByVal strSQL As String, ByVal TableName As String) As Data.DataSet

        ' Returns a data set from a datatable and names it
        Dim dsTemp As Data.DataSet

        Try
            Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
                Dim adapter As New SqlDataAdapter()
                adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
                adapter.SelectCommand.CommandTimeout = 180
                dsTemp = New Data.DataSet
                adapter.Fill(dsTemp)
                dsTemp.Tables(0).TableName = TableName
            End Using
            Return dsTemp
        Catch ex As SqlException
            Alert.Show("This report has generated errors. Error: " & ex.Message)
            Return Nothing
        End Try

    End Function

    Public Shared Function ConvertSettlementDate(ByVal DayOfYear As Integer) As Date

    End Function

    Public Shared Function GetTheAmount(ByVal NOC5ID As String, ByVal ConnectionString As String) As String
        Dim strSQL As String = "SELECT Amount FROM tblNOC6 WHERE NOC5ID = " & NOC5ID
        Using cn As New SqlConnection(ConnectionString)
            cn.Open()
            Using cmd As New SqlCommand(strSQL, cn)
                Return cmd.ExecuteScalar
            End Using
        End Using

    End Function

End Class
