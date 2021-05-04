Imports System.Text
Imports System.IO
Imports Drg.Util.DataAccess

Public Class frmMain
#Region "Properties"
    Private d1 As DateTime
    Private d2 As DateTime
    Private Format_Numeric As String = "0.00"
#End Region
#Region "Events"
    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        cboConnString.SelectedIndex = 1
        Dim OneMonthAgo As Date = Now.AddMonths(-1)

        cboMonth.SelectedIndex = OneMonthAgo.Month - 1
        txtYear.Text = OneMonthAgo.Year
    End Sub
    Private Sub btnBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowse.Click, Button1.Click
        If fbdFolder.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
            txtOutput.Text = fbdFolder.SelectedPath
        End If
    End Sub
    Private Sub btnClear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClear.Click
        txtStatusLog.Text = ""
    End Sub
    Private Sub btnBuild_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBuild.Click
        BuildAll()
    End Sub
#End Region
#Region "Util"
    Private Function ContainsNoCase(ByVal l As List(Of String), ByVal str As String) As Boolean
        For Each s As String In l
            If s.ToLower.Equals(str.ToLower) Then
                Return True
            End If
        Next
        Return False
    End Function
    Private Function IsNull(ByVal o1 As Object, ByVal o2 As Object) As Object
        If IsDBNull(o1) Then
            Return o2
        Else
            Return o1
        End If
    End Function
    Private Sub WriteFile(ByVal path As String, ByVal filename As String, ByVal value As String)
        If Not System.IO.Directory.Exists(path) Then
            System.IO.Directory.CreateDirectory(path)
        End If
        Using sw As StreamWriter = New StreamWriter(path & "/" & filename)
            sw.Write(value)
            sw.Close()
        End Using
    End Sub
    Private Sub WriteLine(ByVal sb As StringBuilder, ByVal dr As DataRow, ByVal DateFormat As String, ByVal Fields As List(Of String))
        Dim First As Boolean = True
        For i As Integer = 0 To dr.Table.Columns.Count - 1
            If ContainsNoCase(Fields, dr.Table.Columns(i).ColumnName) Then
                If Not First Then
                    sb.Append(",")
                End If
                sb.Append("|")
                WriteField(sb, dr, i, DateFormat)
                sb.Append("|")
                First = False
            End If
        Next
        sb.Append(vbCrLf)
    End Sub
    Private Sub WriteLine(ByVal sb As StringBuilder, ByVal rd As IDataReader, ByVal DateFormat As String)
        For i As Integer = 0 To rd.FieldCount - 1
            If Not i = 0 Then
                sb.Append(",")
            End If
            sb.Append("|")
            WriteField(sb, rd, i, DateFormat)
            sb.Append("|")
        Next
        sb.Append(vbCrLf)
    End Sub
    Private Function GetFromToString() As String
        Return "From " & d1.ToString("M/d/yyyy") & " to " & d2.ToString("M/d/yyyy")
    End Function
    Private Sub LogDone()
        Log("Done", False)
    End Sub
    Private Sub Log(ByVal s As String)
        Log(s, True)
    End Sub
    Private Sub Log(ByVal s As String, ByVal newline As Boolean)
        txtStatusLog.AppendText(IIf(newline, vbCrLf, "") & s)
    End Sub
#End Region
#Region "Build"
    Private Sub WriteField(ByVal sb As StringBuilder, ByVal dr As DataRow, ByVal i As Integer, ByVal DateFormat As String)
        If Not IsDBNull(dr(i)) Then
            Dim o As Object = dr(i)
            If TypeOf o Is String Then
                Dim s As String = CType(o, String)
                If s = "month range|last" Then
                    sb.Append(GetFromToString())
                Else
                    sb.Append(s)
                End If
            ElseIf TypeOf o Is Decimal Then
                Dim d As Decimal = CType(o, Decimal)
                If d = 0 Then
                    sb.Append("0")
                Else
                    sb.Append(d.ToString(Format_Numeric))
                End If
            ElseIf TypeOf o Is DateTime Then
                Dim d As DateTime = CType(o, DateTime)
                If d = DateTime.MinValue Then
                    sb.Append("")
                Else
                    sb.Append(d.ToString(DateFormat))
                End If
            End If
        End If
    End Sub
    Private Sub WriteField(ByVal sb As StringBuilder, ByVal rd As IDataReader, ByVal i As Integer, ByVal DateFormat As String)
        If Not rd.IsDBNull(i) Then
            Dim o As Object = rd.GetValue(i)
            If TypeOf o Is String Then
                Dim s As String = CType(o, String)
                If s = "month range|last" Then
                    sb.Append(GetFromToString())
                Else
                    sb.Append(s)
                End If
            ElseIf TypeOf o Is Decimal Then
                Dim d As Decimal = CType(o, Decimal)
                If d = 0 Then
                    sb.Append("0")
                Else
                    sb.Append(d.ToString(Format_Numeric))
                End If
            ElseIf TypeOf o Is DateTime Then
                Dim d As DateTime = CType(o, DateTime)
                If d = DateTime.MinValue Then
                    sb.Append("")
                Else
                    sb.Append(d.ToString(DateFormat))
                End If
            End If
        End If
    End Sub
    Private Function FileName(ByVal s As String) As String
        Return "DMS_StatusRpt_" & s & "_" & d1.ToString("MMMM_yyyy") & ".txt"
    End Function
    Private Sub BuildPersonal(ByVal rd As IDataReader, ByVal DateFormat As String)
        Dim sb As New StringBuilder
        While rd.Read
            WriteLine(sb, rd, DateFormat)
        End While
        'remove final line end
        If sb.Length >= 2 Then sb.Remove(sb.Length - 2, 2)
        LogDone()

        Dim fn As String = FileName("Personal")
        Log("Saving to """ & fn & """...")
        WriteFile(txtOutput.Text, fn, sb.ToString())
        LogDone()
    End Sub
    Private Sub BuildCreditors(ByVal rd As IDataReader, ByVal DateFormat As String)
        Dim sb As New StringBuilder
        While rd.Read
            WriteLine(sb, rd, DateFormat)
        End While
        'remove final line end
        If sb.Length >= 2 Then sb.Remove(sb.Length - 2, 2)
        LogDone()

        Dim fn As String = FileName("Creditors")
        Log("Saving to """ & fn & """...")
        WriteFile(txtOutput.Text, fn, sb.ToString())
        LogDone()
    End Sub
    Private Sub BuildTrans(ByVal transactions As DataRow(), ByVal fields As List(Of String), ByVal DateFormat As String)
        Dim sb As New StringBuilder
        For Each dr As DataRow In transactions
            WriteLine(sb, dr, DateFormat, fields)
        Next

        'remove final line end
        If sb.Length >= 2 Then sb.Remove(sb.Length - 2, 2)
        LogDone()

        Dim fn As String = FileName("Trans")
        Log("Saving to """ & fn & """...")
        WriteFile(txtOutput.Text, fn, sb.ToString())
        LogDone()
    End Sub
    Private Sub BuildMessage()
        Dim fn As String = FileName("Message")
        Log("Saving message to """ & fn & """...")
        WriteFile(txtOutput.Text, fn, "|" & txtMessage.Text & "|")
        LogDone()
    End Sub
    Private Sub BuildAll()
        Try
            Log("**********" & vbCrLf & "Initializing connection...")
            Using cn As IDbConnection = ConnectionFactory.Create(cboConnString.Text)
                Using cmd As IDbCommand = cn.CreateCommand
                    cmd.CommandTimeout = 9999
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = txtSpName.Text

                    DatabaseHelper.AddParameter(cmd, "date1", d1)
                    DatabaseHelper.AddParameter(cmd, "date2", d2)
                    cmd.Connection.Open()
                    LogDone()
                    Log("Extracting Personal Statement...")
                    Using rd As IDataReader = cmd.ExecuteReader()
                        BuildPersonal(rd, txtDateFormatPersonal.Text)

                        Log("Extracting Creditors Statement...")
                        rd.NextResult()
                        BuildCreditors(rd, txtDateFormatCreditor.Text)


                        Log("Extracting Trans Statement...")
                        rd.NextResult()
                        Dim transactions As DataRow() = GetTransactions(rd, d1, d2)
                        Dim fields() As String = {"AccountNumber", "Date", "Description", "Amount", "SDABalance", "PFOBalance"}
                        BuildTrans(transactions, New List(Of String)(fields), txtDateFormatTransaction.Text)
                    End Using
                End Using
            End Using

            BuildMessage()
            Log("Execution Complete")
        Catch ex As Exception
            Log("Error:  " & ex.ToString())
        End Try
    End Sub
#End Region
    Private Function GetTransactions(ByVal rd As IDataReader, ByVal d1 As DateTime, ByVal d2 As DateTime) As DataRow()
        Dim dt As New DataTable

        dt.Columns.Add("Id", GetType(Integer))
        dt.Columns.Add("ClientID", GetType(Integer))
        dt.Columns.Add("AccountNumber", GetType(String))
        dt.Columns.Add("Date", GetType(DateTime))
        dt.Columns.Add("Type", GetType(String))
        dt.Columns.Add("Description", GetType(String))
        dt.Columns.Add("Amount", GetType(Decimal))
        dt.Columns.Add("SDABalance", GetType(Decimal))
        dt.Columns.Add("PFOBalance", GetType(Decimal))
        dt.Columns.Add("EntryTypeId", GetType(Integer))
        dt.Columns.Add("Order", GetType(Integer))
        dt.Columns.Add("Fee", GetType(Boolean))
        dt.Columns.Add("CurrentClientStatusID", GetType(Integer))

        While (rd.Read())
            Dim dr As DataRow = dt.NewRow
            For Each c As DataColumn In dt.Columns
                dr(c.ColumnName) = rd(c.ColumnName)
            Next
            dt.Rows.Add(dr)
        End While

        Dim LastClientID As String = -1
        Dim LastSDABalance As Decimal = 0
        Dim LastPFOBalance As Decimal = 0

        For i As Integer = 0 To dt.Rows.Count - 1
            Dim dr As DataRow = dt.Rows(i)

            If Not dr("ClientID") = LastClientID Then
                LastSDABalance = 0
                LastPFOBalance = 0
            End If

            If IsNull(dr("Fee"), False) = True Then
                LastPFOBalance = LastPFOBalance + dr("Amount")
            ElseIf IsNull(dr("EntryTypeId"), 0) = -1 Then
                LastSDABalance = LastSDABalance - dr("Amount")
                LastPFOBalance = LastPFOBalance + dr("Amount")
            Else
                LastSDABalance = LastSDABalance + dr("Amount")
            End If

            dr("SDABalance") = LastSDABalance
            dr("PFOBalance") = LastPFOBalance

            LastClientID = dr("clientid")
        Next

        Dim where As String = "not currentclientstatusid in (15,16,17) and date >= '" & d1.ToString & "' and date <= '" & d2.ToString & "'"
        Dim order As String = "AccountNumber,Date,order"
        Return dt.Select(where, order)
    End Function

    Private Sub cboMonth_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboMonth.SelectedIndexChanged
        SetDate()
    End Sub

    Private Sub txtYear_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtYear.TextChanged
        SetDate()
    End Sub
    Private Sub SetDate()
        If Not String.IsNullOrEmpty(txtYear.Text) And cboMonth.SelectedIndex >= 0 Then
            d1 = New DateTime(Integer.Parse(txtYear.Text), cboMonth.SelectedIndex + 1, 1, 0, 0, 0)
            d2 = New DateTime(Integer.Parse(txtYear.Text), cboMonth.SelectedIndex + 1, DateTime.DaysInMonth(Integer.Parse(txtYear.Text), cboMonth.SelectedIndex + 1), 23, 59, 59)
        End If
    End Sub
End Class

