Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic
Imports System.Linq
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports LexxiomLetterTemplates

Public Class LeadNameInfo
    Public FullName As String
    Public FirstName As String
    Public LastName As String
End Class

Public Class CallReasonType
    Public CallReasonId As Integer
    Public Reason As String
    Public Description As String
End Class

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class AjaxService
    Inherits System.Web.Services.WebService

    <WebMethod(MessageName:="IsDuplicateSSNSingle")> _
    Public Function IsDuplicateSSNSingle(ByVal SSN As String) As String
        If SmartDebtorHelper.IsDuplicate_SSN(SSN) Then
            Return "1"
        Else
            Return "0"
        End If
    End Function

    <WebMethod()> _
    Public Function IsDuplicateSSN(ByVal SSN As String, ByVal LeadId As String) As String
        If SmartDebtorHelper.IsDuplicate_SSN(SSN, LeadId) Then
            Return "1"
        Else
            Return "0"
        End If
    End Function

    <WebMethod()> _
    Public Function IsDuplicatePhone(ByVal Phone As String, ByVal LeadId As String, ByVal UserId As String) As String
        If SmartDebtorHelper.IsDuplicate_Phone(Phone, LeadId, UserId) Then
            Return "1"
        Else
            Return "0"
        End If
    End Function

    <WebMethod()> _
    Public Function SplitLeadName(ByVal Fullname As String) As LeadNameInfo
        Dim name As String = Regex.Replace(Fullname.Trim, "\s+", " ")
        Dim firstname As String = ""
        Dim lastname As String = ""

        Dim names As String() = Split(name, " ")

        If names.Length > 0 Then
            firstname = names(0)
            If names.Length > 1 Then
                'Get Middle Initial
                Dim nIndex As Integer = 1
                If names(1).Length = 1 OrElse (names(1).Length < 3 AndAlso names(1).EndsWith(".")) Then
                    firstname = firstname & " " & names(1)
                    nIndex = 2
                End If
                'Get LastName(s)
                lastname = String.Join(" ", names, nIndex, names.GetUpperBound(0) - nIndex + 1)
            End If
        End If

        Return New LeadNameInfo() With {.FirstName = firstname, .LastName = lastname, .FullName = name}
    End Function

    <WebMethod()> _
    Public Function GetCallReasons() As List(Of CallReasonType)
        Dim dt As DataTable = FreePBXHelper.GetCallReasons()
        Dim qry = From dr As DataRow In dt.AsEnumerable() _
                  Select New CallReasonType() With {.CallReasonId = dr("CallReasonId"), _
                                                    .Reason = dr("Reason"), _
                                                    .Description = dr("Description")}
        Return qry.ToList
    End Function

    <WebMethod()> _
    Public Sub UpdateCallReason(ByVal CallId As Integer, ByVal ReasonId As Integer)
        FreePBXHelper.UpdateCallReason(CallId, ReasonId)
    End Sub

    <WebMethod()> _
    Public Function AttachVicidialSettlementRecording(ByVal RecordingId As Integer, ByVal FullRecordingName As String) As Boolean
        Dim dt As DataTable = DialerHelper.GetSettlementRecordedCall(RecordingId)
        Dim dr As DataRow
        Dim newfilename As String
        If dt.Rows.Count > 0 AndAlso FullRecordingName.Trim.Length > 0 Then
            dr = dt.Rows(0)
            'Attach the document
            newfilename = FreePBXHelper.AttachRecordedDocument(dr("clientid"), dr("userid"), FullRecordingName, "9074", "ClientDocs", System.IO.Path.GetExtension(FullRecordingName))
            'Update Settlement Recording
            If newfilename.Trim.Length > 0 Then
                FreePBXHelper.AttachDocToReference("matter", dr("matterid"), dr("userid"), System.IO.Path.GetFileName(newfilename), "ClientDocs")
                CallControlsHelper.UpdateCallRecording(dr("recid"), "", newfilename, "", 0, "")
                Return True
            End If
        End If
        Return False
    End Function

    <WebMethod()> _
    Public Function AttachVicidialVerificationRecording(ByVal RecordingId As Integer, ByVal FullRecordingName As String) As Boolean
        Try
            Dim dt As DataTable = CallVerificationHelper.GetVerificationRecordedCall(RecordingId)
            Dim dr As DataRow
            Dim newfilename As String = String.Empty
            If dt.Rows.Count > 0 AndAlso FullRecordingName.Trim.Length > 0 Then
                dr = dt.Rows(0)
                Dim persontype As String = "lead applicant"
                If Not dr("clientid") Is DBNull.Value AndAlso dr("clientid") > 0 Then
                    persontype = "client"
                End If
                Select Case persontype.ToLower
                    Case "client"
                        Dim DocTypeId As String = "9072"
                        newfilename = FreePBXHelper.AttachRecordedDocument(dr("clientid"), dr("userid"), FullRecordingName, DocTypeId, "ClientDocs", System.IO.Path.GetExtension(FullRecordingName))
                    Case "lead applicant"
                        Dim leaddocspath As String = ConfigurationManager.AppSettings("leadDocumentsDir").ToString
                        leaddocspath = System.IO.Path.Combine(leaddocspath, "audio")
                        newfilename = System.IO.Path.Combine(leaddocspath, System.IO.Path.GetFileName(FullRecordingName))
                        If Not System.IO.File.Exists(newfilename) Then
                            System.IO.File.Move(FullRecordingName, newfilename)
                        End If

                        SmartDebtorHelper.SaveLeadDocument(dr("leadapplicantid"), System.IO.Path.GetFileNameWithoutExtension(newfilename), dr("userid"), SmartDebtorHelper.DocType.VerificationRecorded)
                End Select

                If newfilename.Trim.Length > 0 Then CallVerificationHelper.UpdateRecordedCallPath(RecordingId, newfilename)

            End If

            Return newfilename.Length > 0
        Catch ex As Exception
            Throw
            Return False
        End Try
    End Function

    <WebMethod()> _
    Public Function GetNotes(ClientId As String) As String

        Dim query As String = String.Format("select Created, Value from tblNote where ClientId = {0} order by created desc", ClientId)

        Dim result As String = ""
        Try
            Using dt As DataTable = SqlHelper.GetDataTable(query, CommandType.Text)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem"" align=""left"">Date</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">Note</th>")
                    tbl.Append("</tr>")
                    Dim i As Integer = 0
                    Dim tdCSSClass As String = ""
                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:rgb(246,246,246)"">")
                        End If
                        tbl.AppendFormat("<td class=""griditem1"">{0}</td>", dr("Created").ToString)
                        tbl.AppendFormat("<td class=""griditem2"">{0}</td>", dr("Value").ToString)
                        tbl.Append("</tr>")
                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No Notes For This Client.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <WebMethod()> _
    Public Sub InsertNote(ByVal Value As String, ByVal UserID As Integer, ByVal ClientID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Value.Length > 5000 Then
            DatabaseHelper.AddParameter(cmd, "Value", Value.Substring(0, 5000))
        Else
            DatabaseHelper.AddParameter(cmd, "Value", Value)
        End If

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNote", "NoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    <WebMethod()> _
    Public Function LoadClient(ByVal PersonID As String) As Object
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("PersonId", PersonID))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GlobalLoadClient", CommandType.StoredProcedure, params.ToArray)
        Dim result As New List(Of String())

        For Each dr As DataRow In dt.Rows
            result.Add(New String() {"firstname", dr("firstname").ToString()})
            result.Add(New String() {"lastname", dr("lastname").ToString()})
            result.Add(New String() {"address", dr("address").ToString()})
            result.Add(New String() {"city", dr("city").ToString()})
            result.Add(New String() {"state", dr("name").ToString()})
            result.Add(New String() {"zip", dr("zip").ToString()})
            result.Add(New String() {"email", dr("email").ToString()})
            result.Add(New String() {"phone", dr("phone").ToString()})
            result.Add(New String() {"language", dr("language").ToString()})
            result.Add(New String() {"client", dr("clientid").ToString()})
        Next

        Return Newtonsoft.Json.JsonConvert.SerializeObject(result)
    End Function

    <WebMethod()> _
    Public Function LoadUnassignedLeads() As String
        Dim result As String = ""

        Try
            Using dt As DataTable = SqlHelper.GetDataTable("stp_GetUnassignedLeads", CommandType.StoredProcedure)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    'tbl.Append("<table id=""mytable"" class=""table table-striped table-condensed"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th>Full Name</th>")
                    tbl.Append("<th>Phone</th>")
                    tbl.Append("<th>Language</th>")
                    tbl.Append("<th>Status</th>")
                    tbl.Append("<th>Created</th>")
                    tbl.Append("<th>Total Debt</th>")
                    tbl.Append("<th>Source</th>")
                    tbl.Append("<th>Dialed</th>")
                    tbl.Append("<th>State</th>")
                    tbl.Append("<th>TimeZone</th>")
                    tbl.Append("</tr>")

                    For Each dr As DataRow In dt.Rows

                        Dim phone As String = "1" + dr("phone").ToString.Replace(" ", "").Replace("(", "").Replace(")", "").Replace("-", "")

                        tbl.Append("<tr>")
                        tbl.AppendFormat("<td><a href=http://web1/clients/enrollment/newenrollment3.aspx?id={1}&p1=1&p2=1&s=''>{0}</a></td>", dr("fullname").ToString, dr("id").ToString)
                        'tbl.AppendFormat("<td><a onclick='return callout(""{1},{2}"");'>{0}</a></td>", dr("phone").ToString, phone, dr("id").ToString)
                        tbl.AppendFormat("<td><a onclick='return callout(""{1}"");'>{0}</a></td>", dr("phone").ToString, phone)
                        tbl.AppendFormat("<td>{0}</td>", dr("language").ToString)
                        tbl.AppendFormat("<td>{0}</td>", dr("status").ToString)
                        tbl.AppendFormat("<td>{0}</td>", dr("datecreated").ToString())
                        tbl.AppendFormat("<td class=""text-right"">{0}</td>", FormatCurrency(Val(dr("debt")), 0))
                        tbl.AppendFormat("<td>{0}</td>", dr("source").ToString)
                        tbl.AppendFormat("<td class=""text-right"">{0}</td>", dr("dialed").ToString)
                        tbl.AppendFormat("<td>{0}</td>", dr("state").ToString)
                        tbl.AppendFormat("<td>{0}</td>", dr("timezone").ToString.Split(New Char() {" "c})(0))

                        tbl.Append("</tr>")
                    Next

                    'tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No leads were found.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Sub updatedialed(ByVal id As String)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadapplicantid", id))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_updateLeadDialed", CommandType.StoredProcedure, params.ToArray)

    End Sub

    <WebMethod()> _
    Public Sub VerifyClient(ByVal ClientID As String)

        Dim query As String = String.Format("update tblGlobalClients set Verified = 1 where ClientId = {0}", ClientID)
        SqlHelper.ExecuteNonQuery(query, CommandType.Text)

    End Sub

    Public Function GetJson(ByVal dt As DataTable) As String
        Return New JavaScriptSerializer().Serialize(From dr As DataRow In dt.Rows Select dt.Columns.Cast(Of DataColumn)().ToDictionary(Function(col) col.ColumnName, Function(col) dr(col)))
    End Function

End Class
