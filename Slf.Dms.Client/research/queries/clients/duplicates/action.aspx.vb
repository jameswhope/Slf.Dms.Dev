Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient

Imports AssistedSolutions.WebControls

Partial Class research_queries_clients_duplicates_action
    Inherits PermissionPage

#Region "Variables"

    Public UserID As Integer
    Public PageEmpty1 As Boolean
    Public PageEmpty2 As Boolean
    Public PageEmpty3 As Boolean
    Public PageEmpty4 As Boolean
    Public PageEmpty5 As Boolean
#End Region
#Region "Util"
    Private Function IsPrimType(ByVal o As Object) As Boolean
        If TypeOf o Is Boolean Then
            Return True
        ElseIf TypeOf o Is Byte Then
            Return True
        ElseIf TypeOf o Is DateTime Then
            Return True
        ElseIf TypeOf o Is Decimal Then
            Return True
        ElseIf TypeOf o Is Integer Then
            Return True
        ElseIf TypeOf o Is Single Then
            Return True
        ElseIf TypeOf o Is Double Then
            Return True
        ElseIf TypeOf o Is String Then
            Return True
        End If
        Return False
    End Function
    Private Function AllEqual(ByVal l As List(Of Object)) As Boolean
        Dim o As Object = l(0)
        For i As Integer = 1 To l.Count - 1
            Dim o2 As Object = l(i)
            If (IsDBNull(o2) And Not IsDBNull(o)) Or IsDBNull(o) And Not IsDBNull(o2) Then
                Return False
            ElseIf Not IsDBNull(o2) And Not IsDBNull(o) Then
                If IsPrimType(o) AndAlso Not o2 = o Then Return False
            End If

        Next
        Return True
    End Function
    Private Function ContainsValue(ByVal c As PropertyCollection, ByVal s As String) As Boolean
        If Not c.ContainsKey(s) Then
            Return False
        Else
            Return Not (c(s) Is Nothing)
        End If
    End Function
    Public Sub SetColumnDefaults(ByVal c As DataColumn)
        If Not ContainsValue(c.ExtendedProperties, "Format") Then
            If c.DataType Is GetType(Boolean) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(Byte) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(DateTime) Then
                c.ExtendedProperties("Format") = "MM/dd/yyyy"
            ElseIf c.DataType Is GetType(Decimal) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(Integer) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(Single) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(Double) Then
                c.ExtendedProperties("Format") = Nothing
            ElseIf c.DataType Is GetType(String) Then
                c.ExtendedProperties("Format") = Nothing
            End If
        End If
    End Sub
    Protected Sub WriteValue(ByVal sb As StringBuilder, ByVal c As DataColumn, ByVal o As Object)
        If TypeOf o Is Boolean Then
            Dim v As Boolean = CType(o, Boolean)
            sb.Append(v.ToString())
        ElseIf TypeOf o Is Byte Then
            Dim v As Byte = CType(o, Byte)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is DateTime Then
            Dim v As DateTime = CType(o, DateTime)
            If v = DateTime.MinValue Then
                sb.Append("")
            Else
                sb.Append(v.ToString(c.ExtendedProperties("Format")))
            End If
        ElseIf TypeOf o Is Decimal Then
            Dim v As Decimal = CType(o, Decimal)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Integer Then
            Dim v As Integer = CType(o, Integer)
            sb.Append(v.ToString())
        ElseIf TypeOf o Is Single Then
            Dim v As Single = CType(o, Single)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Double Then
            Dim v As Double = CType(o, Double)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is String Then
            Dim v As String = CType(o, String)
            sb.Append(v)
        End If
    End Sub
    Private Function GetIDs() As List(Of Integer)

        Dim IDs As New List(Of Integer)

        Dim strIds As String = Context.Request.QueryString("ids")
        Dim aIds() As String = strIds.Split(",")
        For Each s As String In aIds
            IDs.Add(Integer.Parse(s))
        Next

        Return IDs

    End Function
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(User.Identity.Name)

        LoadClients()
        LoadCoapplicants()
        LoadAccounts()
        LoadNotes()
        LoadPhoneCalls()
        LoadRegisters()

    End Sub
    Private Sub Close()

        'issue javascript back to page to close form and reload opener
        Response.Write("<script type=""text/javascript"">window.close();</script>")

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(frmBody, c, "Research-Queries-Clients-Demographics-Duplicates")
    End Sub
#End Region
    Dim _ClientDataSet As DataSet
    Private Function FindColumnByCaption(ByVal dt As DataTable, ByVal caption As String) As String
        For i As Integer = 0 To dt.Columns.Count - 1
            Dim c As DataColumn = dt.Columns(i)
            If c.Caption.ToLower = caption.ToLower Or c.ColumnName.ToLower = caption.ToLower Then
                Return c.ColumnName
            End If
        Next
        Return -1
    End Function
    Private ReadOnly Property ClientDataSet() As DataSet
        Get
            If _ClientDataSet Is Nothing Then
                Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Query_DuplicatesDetail")
                    DatabaseHelper.AddParameter(cmd, "ClientIDs", Context.Request.QueryString("ids"))
                    _ClientDataSet = New DataSet()
                    Dim a As New SqlDataAdapter(cmd)
                    a.TableMappings.Add("Table", "Clients")
                    a.TableMappings.Add("Table1", "Coapplicants")
                    a.TableMappings.Add("Table2", "Accounts")
                    a.TableMappings.Add("Table3", "Notes")
                    a.TableMappings.Add("Table4", "PhoneCalls")
                    a.TableMappings.Add("Table5", "Registers")

                    a.Fill(_ClientDataSet)
                End Using

                Dim dt As DataTable = _ClientDataSet.Tables("Clients")
                dt.Columns("AccountNumber").Caption = "Account Number"
                dt.Columns("DepositMethod").Caption = "Deposit Method"
                dt.Columns("DepositDay").Caption = "Deposit Day"
                dt.Columns("DepositAmount").Caption = "Deposit Amount"
                dt.Columns("DepositStartDate").Caption = "Deposit Start Date"
                dt.Columns("BankName").Caption = "Bank Name"
                dt.Columns("BankRoutingNumber").Caption = "Bank Routing Number"
                dt.Columns("BankCity").Caption = "Bank City"
                dt.Columns("BankState").Caption = "Bank State"
                dt.Columns("MonthlyFee").Caption = "Monthly Fee"
                dt.Columns("MonthlyFeeDay").Caption = "Monthly Fee Day"
                dt.Columns("MonthlyFeeStartDate").Caption = "Monthly Fee Start Date"
                dt.Columns("FirstName").Caption = "First Name"
                dt.Columns("LastName").Caption = "Last Name"
                dt.Columns("SSN").Caption = "SSN"
                dt.Columns("Gender").Caption = "Gender"
                dt.Columns("DateOfBirth").Caption = "DOB"
                dt.Columns("Language").Caption = "Language"
                dt.Columns("Street").Caption = "Street"
                dt.Columns("Street2").Caption = "Street2"
                dt.Columns("City").Caption = "City"
                dt.Columns("State").Caption = "State"
                dt.Columns("ZipCode").Caption = "Zip"

                dt.Columns("AccountNumber").ExtendedProperties("Display") = True
                dt.Columns("DepositMethod").ExtendedProperties("Display") = True
                dt.Columns("DepositDay").ExtendedProperties("Display") = True
                dt.Columns("DepositAmount").ExtendedProperties("Display") = True
                dt.Columns("DepositStartDate").ExtendedProperties("Display") = True
                dt.Columns("BankName").ExtendedProperties("Display") = True
                dt.Columns("BankRoutingNumber").ExtendedProperties("Display") = True
                dt.Columns("BankCity").ExtendedProperties("Display") = True
                dt.Columns("BankState").ExtendedProperties("Display") = True
                dt.Columns("MonthlyFee").ExtendedProperties("Display") = True
                dt.Columns("MonthlyFeeDay").ExtendedProperties("Display") = True
                dt.Columns("MonthlyFeeStartDate").ExtendedProperties("Display") = True
                dt.Columns("FirstName").ExtendedProperties("Display") = True
                dt.Columns("LastName").ExtendedProperties("Display") = True
                dt.Columns("SSN").ExtendedProperties("Display") = True
                dt.Columns("Gender").ExtendedProperties("Display") = True
                dt.Columns("DateOfBirth").ExtendedProperties("Display") = True
                dt.Columns("Language").ExtendedProperties("Display") = True
                dt.Columns("Street").ExtendedProperties("Display") = True
                dt.Columns("Street2").ExtendedProperties("Display") = True
                dt.Columns("City").ExtendedProperties("Display") = True
                dt.Columns("State").ExtendedProperties("Display") = True
                dt.Columns("ZipCode").ExtendedProperties("Display") = True

                For Each c As DataColumn In dt.Columns
                    SetColumnDefaults(c)
                Next
            End If

            Return _ClientDataSet
        End Get
    End Property
    Private Sub LoadClients()
        Dim sb As New StringBuilder

        Dim Clients As DataTable = ClientDataSet().Tables("Clients")

        sb.Append("<tr><td></td>")
        For i As Integer = 0 To Clients.Rows.Count - 1
            sb.Append("<td onclick=""SelRow1(this);"">")
            sb.Append("Client " & (i + 1))
            sb.Append("</td>")
        Next

        sb.Append("<td>Result</td>")
        sb.Append("</tr>")

        For Each c As DataColumn In Clients.Columns
            Dim l As New List(Of Object)
            For Each r As DataRow In Clients.Rows
                l.Add(r(c.ColumnName))
            Next

            'skip whole row if there are no clients with this value
            If Not AllEqual(l) Then
                If Not c.ExtendedProperties("Display") = False Then
                    sb.Append("<tr>")
                    sb.Append("<td>" & c.Caption & "</td>")
                    For Each dr As DataRow In Clients.Rows
                        sb.Append("<td onclick=""SelCell1(this);""")
                        If c.ColumnName = "state" Then
                            sb.Append(" value=""" & dr("stateid"))
                        ElseIf c.ColumnName = "bankstate" Then
                            sb.Append(" value=""" & dr("bankstateid") & """")
                        End If
                        sb.Append(">")
                        WriteValue(sb, c, dr(c.ColumnName))
                        sb.Append("</td>")
                    Next
                    sb.Append("<td></td>")
                    sb.Append("</tr>")
                End If
            End If
        Next

        ltrPage0.Text = sb.ToString
    End Sub
    Private Sub LoadCoapplicants()
        Dim sb As New StringBuilder

        Dim Coapps As DataTable = ClientDataSet().Tables("Coapplicants")

        If Coapps.Rows.Count > 0 Then
            For Each dr As DataRow In Coapps.Rows
                sb.Append("<tr>")
                sb.Append("<td id=""" & dr("PersonID") & """>")
                Dim chk As New CheckBox
                chk.Text = dr("LastName") & ", " & dr("FirstName")
                Using sw As New System.IO.StringWriter(sb)
                    Using tw As New HtmlTextWriter(sw)
                        chk.RenderControl(tw)
                    End Using
                End Using
                sb.Append("</td>")
                sb.Append("</tr>")
            Next
        Else
            PageEmpty1 = True
        End If
        ltrPage1.Text = sb.ToString
    End Sub
    Private Sub LoadAccounts()
        Dim sb As New StringBuilder

        Dim Accts As DataTable = ClientDataSet().Tables("Accounts")

        If Accts.Rows.Count > 0 Then
            For Each dr As DataRow In Accts.Rows
                sb.Append("<tr>")
                sb.Append("<td id=""" & dr("AccountID") & """>")
                Dim chk As New CheckBox
                chk.Text = dr("Name")
                Using sw As New System.IO.StringWriter(sb)
                    Using tw As New HtmlTextWriter(sw)
                        chk.RenderControl(tw)
                    End Using
                End Using
                sb.Append("</td>")
                sb.Append("</tr>")
            Next
        Else
            PageEmpty2 = True
        End If
        ltrPage2.Text = sb.ToString
    End Sub
    Private Function MakeSnippet(ByVal s1 As String, ByVal s2 As String) As String
        Dim result As String = ""
        If Not String.IsNullOrEmpty(s1) Then
            result = "<b>" + s1 + ":</b> "
        End If
        result += s2
        If result.Length > 30 Then result = result.Substring(0, 30) + "..."
        Return result
    End Function
    Private Sub LoadNotes()
        Dim sb As New StringBuilder

        Dim Notes As DataTable = ClientDataSet().Tables("Notes")

        If Notes.Rows.Count > 0 Then
            For Each dr As DataRow In Notes.Rows
                sb.Append("<tr>")
                sb.Append("<td id=""" & dr("NoteID") & """>")
                Dim chk As New CheckBox
                chk.Text = MakeSnippet(DataHelper.Nz_string(dr("subject")), DataHelper.Nz_string(dr("value")))
                Using sw As New System.IO.StringWriter(sb)
                    Using tw As New HtmlTextWriter(sw)
                        chk.RenderControl(tw)
                    End Using
                End Using
                sb.Append("</td>")
                sb.Append("</tr>")
            Next
        Else
            PageEmpty3 = True
        End If
        ltrPage3.Text = sb.ToString
    End Sub
    Private Sub LoadPhoneCalls()
        Dim sb As New StringBuilder

        Dim PhoneCalls As DataTable = ClientDataSet().Tables("PhoneCalls")

        If PhoneCalls.Rows.Count > 0 Then
            For Each dr As DataRow In PhoneCalls.Rows
                sb.Append("<tr>")
                sb.Append("<td id=""" & dr("PhoneCallID") & """>")
                Dim chk As New CheckBox
                Using sw As New System.IO.StringWriter(sb)
                    Using tw As New HtmlTextWriter(sw)
                        chk.RenderControl(tw)
                    End Using
                End Using
                sb.Append("<select class=""entry"" style=""width:100px""></select>")
                sb.Append(MakeSnippet(DataHelper.Nz_string(dr("subject")), DataHelper.Nz_string(dr("body"))))
                sb.Append("</td></tr>")
            Next
        Else
            PageEmpty4 = True
        End If
        ltrPage4.Text = sb.ToString
    End Sub
    Private Sub LoadRegisters()
        Dim sb As New StringBuilder

        Dim Registers As DataTable = ClientDataSet().Tables("Registers")

        If Registers.Rows.Count > 0 Then
            For Each dr As DataRow In Registers.Rows
                sb.Append("<tr>")
                sb.Append("<td id=""" & dr("RegisterID") & """>")
                Dim chk As New CheckBox
                chk.Text = dr("Amount") & "(" & DataHelper.Nz_string(dr("entrytype")) & ")"
                Using sw As New System.IO.StringWriter(sb)
                    Using tw As New HtmlTextWriter(sw)
                        chk.RenderControl(tw)
                    End Using
                End Using
                sb.Append("</td>")
                sb.Append("</tr>")
            Next
        Else
            PageEmpty5 = True
        End If
        ltrPage5.Text = sb.ToString
    End Sub
    Private Function RemapField(ByVal s As String) As String
        Select Case s.ToLower
            Case "bankstate"
                Return "bankstateid"
            Case "state"
                Return "stateid"
        End Select
        Return s
    End Function
    Private Function ColumnIndex(ByVal dt As DataTable, ByVal ColumnName As String) As Integer
        For i As Integer = 0 To dt.Columns.Count - 1
            If dt.Columns(i).ColumnName = ColumnName Then
                Return i
            End If
        Next
    End Function
    Protected Sub lnkResolve_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResolve.Click
        Dim ds As DataSet = ClientDataSet()

        Dim rClients As New List(Of String)(Regex.Split(txtClients.Value, "\|\|\|"))
        Dim rCoapps As New List(Of String)(Regex.Split(txtCoapps.Value, "\|\|\|"))
        Dim rAccounts As New List(Of String)(Regex.Split(txtAccounts.Value, "\|\|\|"))
        Dim rPhoneCalls As New List(Of String)(Regex.Split(txtPhoneCalls.Value, "\|\|\|"))
        Dim rNotes As New List(Of String)(Regex.Split(txtNotes.Value, "\|\|\|"))
        Dim rRegisters As New List(Of String)(Regex.Split(txtRegisters.Value, "\|\|\|"))

        Dim tblClients As DataTable = ds.Tables("Clients")
        Dim tblCoapplicants As DataTable = ds.Tables("Coapplicants")
        Dim tblAccounts As DataTable = ds.Tables("Accounts")
        Dim tblNotes As DataTable = ds.Tables("Notes")
        Dim tblPhoneCalls As DataTable = ds.Tables("PhoneCalls")
        Dim tblRegisters As DataTable = ds.Tables("Registers")

        'pull over new client values
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmdP As IDbCommand = ConnectionFactory.Create().CreateCommand
                For Each s As String In rClients
                    Dim parts As String() = Regex.Split(s, "\|\,\|")
                    Dim ColumnName As String = FindColumnByCaption(tblClients, parts(0))

                    Dim i As Integer = ColumnIndex(tblClients, ColumnName)
                    tblClients.Rows(0)(ColumnName) = parts(1)
                    If i > 12 Then
                        DatabaseHelper.AddParameter(cmd, RemapField(ColumnName), tblClients.Rows(0)(ColumnName))
                    Else
                        DatabaseHelper.AddParameter(cmdP, RemapField(ColumnName), tblClients.Rows(0)(ColumnName))
                    End If
                Next

                If cmd.Parameters.Count > 0 Then
                    DatabaseHelper.BuildUpdateCommandText(cmd, "tblclient", "clientid=" & tblClients.Rows(0)("clientid"))
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End If

                If cmdP.Parameters.Count > 0 Then
                    DatabaseHelper.BuildUpdateCommandText(cmdP, "tblperson", "personid=(select primarypersonid from tblclient where clientid=" & tblClients.Rows(0)("clientid") & ")")
                    Using cmdP.Connection
                        cmdP.Connection.Open()
                        cmdP.ExecuteNonQuery()
                    End Using
                End If
            End Using
        End Using

        'associate selected coapps, delete others
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            For Each s As String In rCoapps
                Dim parts As String() = Regex.Split(s, "\|\,\|")
                Dim PersonID As Integer = parts(0)
                Dim Saved As Boolean = Boolean.Parse(parts(1))

                If Saved Then
                    DataHelper.FieldUpdate("tblperson", "clientid", tblClients.Rows(0)("ClientID"), "personid=" & PersonID)
                Else
                    'delete this person
                End If
            Next
        End Using

        'associate selected accounts, delete others
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            For Each s As String In rAccounts
                Dim parts As String() = Regex.Split(s, "\|\,\|")
                Dim AccountID As Integer = parts(0)
                Dim Saved As Boolean = Boolean.Parse(parts(1))

                If Saved Then
                    DataHelper.FieldUpdate("tblaccount", "clientid", tblClients.Rows(0)("ClientID"), "accountid=" & AccountID)
                Else
                    'delete this account
                End If
            Next
        End Using

        'associate selected notes, delete others
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            For Each s As String In rNotes
                Dim parts As String() = Regex.Split(s, "\|\,\|")
                Dim NoteID As Integer = parts(0)
                Dim Saved As Boolean = Boolean.Parse(parts(1))

                If Saved Then
                    DataHelper.FieldUpdate("tblnote", "clientid", tblClients.Rows(0)("ClientID"), "noteid=" & NoteID)
                Else
                    'delete this note
                End If
            Next
        End Using

        'associate selected phonecalls (and give correct personid), delete others
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            For Each s As String In rPhoneCalls
                Dim parts As String() = Regex.Split(s, "\|\,\|")
                Dim PhoneCallID As Integer = parts(0)
                Dim Saved As Boolean = Boolean.Parse(parts(1))
                Dim PersonID As Integer = parts(0)

                If Saved Then
                    DataHelper.FieldUpdate("tblpersonphone", "personid", PersonID, "phonecallid=" & PhoneCallID)
                Else
                    'delete this phone call
                End If
            Next
        End Using

        'associate selected registers, delete others
        '?


        'delete all but the first client

        Response.Write("<script>window.close()</script>")
    End Sub

End Class

