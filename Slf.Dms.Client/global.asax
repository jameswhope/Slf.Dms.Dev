<%@ Application Inherits="System.Web.HttpApplication" %>
<%@Import Namespace="Drg.Util.DataAccess" %>
<%@Import Namespace="System.Data" %>
<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace="System.Collections.Generic" %>
<%@Import Namespace="System.IO" %>
<%@Import Namespace="System.Net" %>
<%@Import Namespace="System.Net.Mail" %>
<%@Import Namespace="System.Text" %>
<%@Import Namespace="System.Web" %>
<%@Import Namespace="System.Web.SessionState" %>

<script language="VB" runat="server">
    'Protected Sub Application_Error(ByVal sender As Object, ByVal e As System.EventArgs)
    '    Try
    '        If ErrorValid() Then
    '            Using msg As New MailMessage("interfaceerrors@lexxiom.com", "interfaceerrors@lexxiom.com,ITGroup@lexxiom.com", "Error: " & Request.Url.AbsoluteUri, BuildMessage())
    '                Dim mail As New SmtpClient("dc02.dmsi.local")

    '                msg.Priority = MailPriority.High
    '                msg.IsBodyHtml = True

    '                mail.Send(msg)
    '            End Using
    '        End If

    '        If Server.GetLastError().InnerException.ToString().Contains("Timeout") Then
    '            Response.Redirect("~/userfriendlytimeout.aspx")
    '        Else
    '            Response.Redirect("~/userfriendly.aspx")
    '        End If
    '    Catch ex As Exception
    '        Response.Redirect("~/error.aspx?err=" & Server.UrlEncode(DataHelper.Nz(ex.TargetSite, "").ToString() & " - " & DataHelper.Nz(ex.Message, "No Message").ToString() & " - " & DataHelper.Nz(ex.StackTrace, "No Stack Trace").ToString()))
    '    End Try
    'End Sub

    'Private Function ErrorValid() As Boolean
    '    Dim err As Exception = Server.GetLastError()

    '    Using cmd As New SqlCommand("SELECT count(*) FROM tblErrorLog WHERE Details = '" + DataHelper.Nz(err.Message, "").Replace("'", "''") + _
    '    "' and InnerException = '" + DataHelper.Nz(err.InnerException, "").Replace("'", "''") + "' and StackTrace = '" + DataHelper.Nz(err.StackTrace, "").Replace("'", "''") + _
    '    "' and datediff(mi, ErrorDate, getdate()) < 10", New SqlConnection(ConfigurationSettings.AppSettings.Item("connectionstringlogging").ToString()))
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            If Integer.Parse(cmd.ExecuteScalar()) > 0 Then
    '                cmd.CommandText = "UPDATE tblErrorLog SET Itterations = Itterations + 1 WHERE  Details = '" + _
    '                DataHelper.Nz(err.Message, "").Replace("'", "''") + "' and InnerException = '" + DataHelper.Nz(err.InnerException, "").Replace("'", "''") + _
    '                "' and StackTrace = '" + DataHelper.Nz(err.StackTrace, "").Replace("'", "''") + "' and datediff(mi, ErrorDate, getdate()) < 10"

    '                cmd.ExecuteNonQuery()

    '                Return False
    '            Else
    '                cmd.CommandText = "INSERT INTO tblErrorLog VALUES (getdate(), '" + DataHelper.Nz(err.Message, "").Replace("'", "''") + "', '" + _
    '                DataHelper.Nz(err.InnerException, "").Replace("'", "''") + "', '" + DataHelper.Nz(err.StackTrace, "").Replace("'", "''") + "', 1)"

    '                cmd.ExecuteNonQuery()
    '            End If
    '        End Using
    '    End Using

    '    Return True
    'End Function

    'Private Function BuildMessage() As String
    '    Dim err As Exception = Server.GetLastError()
    '    Dim strMessage As New StringBuilder()

    '    strMessage.Append("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
    '    strMessage.Append("<html>")
    '    strMessage.Append("<head>")
    '    strMessage.Append("<title>Page Error</title>")
    '    strMessage.Append("<meta http-equiv=""Content-Type"" content=""text/html; charset=iso-8859-1"">")
    '    strMessage.Append("<style type=""text/css"">")
    '    strMessage.Append("<!--")
    '    strMessage.Append(".basic {")
    '    strMessage.Append("font-family: Verdana, Arial, Helvetica, sans-serif;")
    '    strMessage.Append("font-size: 12px;")
    '    strMessage.Append("}")
    '    strMessage.Append(".header1 {")
    '    strMessage.Append("font-family: Verdana, Arial, Helvetica, sans-serif;")
    '    strMessage.Append("font-size: 12px;")
    '    strMessage.Append("font-weight: bold;")
    '    strMessage.Append("color: #000099;")
    '    strMessage.Append("}")
    '    strMessage.Append(".tlbbkground1 {")
    '    strMessage.Append("background-color:  #000099;")
    '    strMessage.Append("}")
    '    strMessage.Append("a {")
    '    strMessage.Append("text-decoration: none;")
    '    strMessage.Append("}")
    '    strMessage.Append("-->")
    '    strMessage.Append("</style>")
    '    strMessage.Append("</head>")
    '    strMessage.Append("<body>")
    '    strMessage.Append("<table width=""90%"" border=""0"" align=""center"" cellpadding=""5"" cellspacing=""1"" class=""tlbbkground1"">")
    '    strMessage.Append("<tr bgcolor=""#eeeeee"">")
    '    strMessage.Append("<td colspan=""2"" class=""header1"">Page Error</td>")
    '    strMessage.Append("</tr>")
    '    strMessage.Append("<tr>")
    '    strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>IP Address</td>")
    '    strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & Request.ServerVariables("REMOTE_ADDR") & "</td>")
    '    strMessage.Append("</tr>")
    '    strMessage.Append("<tr>")
    '    strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>User</td>")
    '    strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic""><a href=""mailto:" & DataHelper.FieldLookup("tblUser", "UserName", "UserID = " & Request.ServerVariables("AUTH_USER")) & "@lexxiom.com?subject=In regards to the recent error you encountered on " & Request.Url.AbsoluteUri & """>" & DataHelper.FieldLookup("tblUser", "UserName", "UserID = " & Request.ServerVariables("AUTH_USER")) & "</a></td>")
    '    strMessage.Append("</tr>")
    '    strMessage.Append("<tr>")
    '    strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>Page</td>")
    '    strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & Request.Url.AbsoluteUri & "</td>")
    '    strMessage.Append("</tr>")
    '    strMessage.Append("<tr>")
    '    strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>Time</td>")
    '    strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & DateTime.Now & "</td>")
    '    strMessage.Append("</tr>")
    '    strMessage.Append("<tr>")
    '    strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>Details</td>")
    '    strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & err.Message.ToString() & "</td>")
    '    strMessage.Append("</tr>")

    '    If Not Server.GetLastError().InnerException Is Nothing Then
    '        If TypeOf Server.GetLastError().InnerException Is SqlException Then
    '            Dim sqlEx As SqlException = TryCast(Server.GetLastError.InnerException, SqlException)
    '            strMessage.Append("<tr>")
    '            strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>SQL Exception</td>")
    '            strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">")
    '            For i As Integer = 0 To sqlEx.Errors.Count - 1
    '                strMessage.Append("Error Code: " & sqlEx.Errors(i).Number & "<br/>")
    '                strMessage.Append("Line Number: " & sqlEx.Errors(i).LineNumber & "<br/>")
    '                strMessage.Append("Procedure: " & sqlEx.Errors(i).Procedure & "<br/>")
    '                strMessage.Append("Source: " & sqlEx.Errors(i).Source & "<br/>")
    '                strMessage.Append("Message: " & sqlEx.Errors(i).Message & "<br/>")
    '            Next
    '            strMessage.Append("</td>")
    '            strMessage.Append("</tr>")
    '        End If

    '        strMessage.Append("<tr>")
    '        strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>Inner Exception</td>")
    '        strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & err.InnerException.ToString() & "</td>")
    '        strMessage.Append("</tr>")
    '    End If

    '    If Not Server.GetLastError().StackTrace Is Nothing Then
    '        strMessage.Append("<tr>")
    '        strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>Stack Trace</td>")
    '        strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & err.StackTrace.ToString() & "</td>")
    '        strMessage.Append("</tr>")
    '    End If

    '    If err.Data.Count > 0 Then
    '        strMessage.Append("<tr bgcolor=""#eeeeee"">")
    '        strMessage.Append("<td colspan=""2"" class=""header1"">Error Data</td>")
    '        strMessage.Append("</tr>")

    '        For Each k As DictionaryEntry In err.Data
    '            strMessage.Append("<tr>")
    '            strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>" & k.Key.ToString() & "</td>")
    '            strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & GetContents(k.Value) & "</td>")
    '            strMessage.Append("</tr>")
    '        Next
    '    End If

    '    If Session.Count > 0 Then
    '        strMessage.Append("<tr bgcolor=""#eeeeee"">")
    '        strMessage.Append("<td colspan=""2"" class=""header1"">Sessions</td>")
    '        strMessage.Append("</tr>")

    '        strMessage.Append("<tr>")
    '        strMessage.Append("<td colspan=""2"">")
    '        strMessage.Append("<table width=""100% border=""0"" class=""tlbbkground1"">")

    '        For Each k As String In Session.Keys
    '            If Not k.ToString() = "Permission_PagesList" And Not k.ToString() = "Permission_List" Then
    '                strMessage.Append("<tr width=""100%"">")
    '                strMessage.Append("<td align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" style=""width:300;word-break:break-all;"">" & k.ToString() & "</td>")
    '                strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"" style=""word-break:break-all;"">" & GetContents(Session(k)) & "</td>")
    '                strMessage.Append("</tr>")
    '            End If
    '        Next

    '        strMessage.Append("</table>")
    '        strMessage.Append("</td>")
    '        strMessage.Append("</tr>")
    '    End If

    '    If Application.Count > 0 Then
    '        strMessage.Append("<tr bgcolor=""#eeeeee"">")
    '        strMessage.Append("<td colspan=""2"" class=""header1"">Application States</td>")
    '        strMessage.Append("</tr>")
    '    End If

    '    For Each k As String In Application.Keys
    '        strMessage.Append("<tr>")
    '        strMessage.Append("<td width=""100"" align=""right"" bgcolor=""#eeeeee"" class=""header1"" valign=""top"" nowrap>" & k.ToString() & "</td>")
    '        strMessage.Append("<td bgcolor=""#FFFFFF"" class=""basic"">" & Application(k).ToString() & "</td>")
    '        strMessage.Append("</tr>")
    '    Next

    '    strMessage.Append("</table>")
    '    strMessage.Append("</body>")
    '    strMessage.Append("</html>")

    '    Return strMessage.ToString()
    'End Function

    'Private Function GetContents(ByVal obj As Object) As String
    '    Dim ret As String = obj.ToString()

    '    Select Case obj.GetType().Name
    '        Case "Panel"
    '            Dim str As New StringBuilder()
    '            Using output As TextWriter = New StringWriter(str)
    '                Using writer As New HtmlTextWriter(output)
    '                    obj.RenderControl(writer)
    '                    ret = str.ToString().Replace("<", "&#60;").Replace(">", "&#62;").Substring(0, IIf(ret.Length < 50000, ret.Length, 50000))
    '                End Using
    '            End Using
    '        Case "Dictionary`2"
    '            ret = "<table style=""border:1px solid black"" colpadding=""0"" colspacing=""0"">"

    '            For Each k As Object In obj.Keys
    '                ret += "<tr style=""border:1px solid black"">"
    '                ret += "<td style=""border:1px solid black"">" & GetContents(k) & "</td>"
    '                ret += "<td style=""border:1px solid black"">" & GetContents(obj(k)) & "</td>"
    '                ret += "</tr>"
    '            Next

    '            ret += "</table>"
    '        Case "List`1"
    '            ret = "<table style=""border:1px solid black"" colpadding=""0"" colspacing=""0"">"

    '            For Each item As Object In obj
    '                ret += "<tr style=""border:1px solid black""><td style=""border:1px solid black"">" & GetContents(item) & "</td></tr>"
    '            Next

    '            ret += "</table>"
    '        Case "DataTable"
    '            ret = "<table style=""border:1px solid black"" colpadding=""0"" colspacing=""0"">"

    '            For Each col As DataColumn In obj.Columns
    '                ret += "<th style=""border:1px solid black"">" & col.ColumnName & "</th>"
    '            Next

    '            For Each row As DataRow In obj.Rows
    '                ret += "<tr style=""border:1px solid black"">"

    '                For Each col As DataColumn In obj.Columns
    '                    ret += "<td style=""border:1px solid black"">" & row(col) & "</td>"
    '                Next

    '                ret += "</tr>"
    '            Next

    '            ret += "</table>"
    '        Case "SqlCommand"
    '            ret = IIf(obj.Connection.ConnectionString.Length = 0, "", "<i>Connection String: " & obj.Connection.ConnectionString & "</i> - ") & """" & obj.CommandText & """"
    '        Case "SqlConnection"
    '            ret = "<i>Connection: " & obj.ConnectionString & "</i>"
    '    End Select

    '    Return ret
    'End Function

    Sub Session_End(ByVal sender As Object, ByVal e As System.EventArgs)
        
        Dim _iceSession As ININ.IceLib.Connection.Session = Session("IceSession")
        
        If _iceSession IsNot Nothing AndAlso _iceSession.ConnectionState = ININ.IceLib.Connection.ConnectionState.Up Then
            Try
                _iceSession.Disconnect()
                _iceSession.Dispose()
            Catch ex As Exception
                'LogException("[SM]Disconnect Error:  " & ex.Message)
            End Try
        End If

        Session("IceSession") = Nothing
        Session("IceUserInfo") = Nothing
        Session("InteractionQueue") = Nothing
        Session("InteractionList") = Nothing
        Session("IcePeopleMan") = Nothing
        Session("IceUserStatusList") = Nothing
        Session("IceUserStatus") = Nothing
    End Sub
</script>