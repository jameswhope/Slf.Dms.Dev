Imports System.Data
Imports System.Data.SqlClient

Public Class CampayneHelper
    Public Shared Sub SaveSendResults(ByVal leadID As Integer, ByVal repID As Integer)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", leadID))
        params.Add(New SqlParameter("repid", repID))
        SqlHelper.ExecuteScalar("stp_InsertEmailResultSent", CommandType.StoredProcedure, params.ToArray)

    End Sub
    Public Shared Function GetEmailResultSettingsForSite(ByVal siteURL As String) As DataTable
        Dim dt As DataTable = SqlHelper.GetDataTable(String.Format("select top 1 * from tblEmailResultSettings where siteurl = '{0}'", siteURL), CommandType.Text)
        Return dt
    End Function

    Public Shared Function RelativeDate(ByVal postedOn As DateTime) As String
        Dim currentDate As DateTime = DateTime.Now
        Dim postDate As DateTime = Convert.ToDateTime(postedOn)

        Dim timegap As TimeSpan = currentDate.Subtract(postDate)

        If timegap.Days > 1 Then
            Return String.Concat(timegap.Days, " days ago")
        ElseIf timegap.Days = 1 Then
            Return "Yesterday"
        ElseIf timegap.Hours >= 2 Then
            Return String.Concat(timegap.Hours, " hours ago")
        ElseIf timegap.Hours >= 1 Then
            Return "An hour ago"
        ElseIf timegap.Minutes >= 60 Then
            Return "More than an hour ago"
        ElseIf timegap.Minutes >= 5 Then
            Return String.Concat(timegap.Minutes, " minutes ago")
        ElseIf timegap.Minutes >= 1 Then
            Return "A few minutes ago"
        Else
            Return "Less than a minute ago"
        End If
    End Function

    Public Shared Function GetVersion() As String
        Dim tbl As DataTable = SqlHelper.GetDataTable("select top 1 * from tblreleasehistory order by releasedate desc")
        Dim row As DataRow = tbl.Rows(0)
        Return String.Concat("Build v", row("major").ToString, ".", row("minor").ToString, ".", row("revision").ToString)
    End Function

    Public Shared Function GetMenu(ByVal UserID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("userid", UserID))
        Return SqlHelper.GetDataTable("stp_GetMenu", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function FirstNameLastInitial(ByVal UserID As Integer) As String
        Dim name As String = "NA"
        Try
            name = CStr(SqlHelper.ExecuteScalar("select firstname + ' ' + left(lastname,1) + '.' from tbluser where userid = " & UserID, CommandType.Text))
        Catch ex As Exception
            LeadHelper.LogError("FirstNameLastInitial", ex.Message, ex.StackTrace)
        End Try
        Return name
    End Function

    Public Shared Function GetConfigValue(ByVal key As String) As String
        Dim cmdText As String = String.Format("select datavalue from tblconfig where keyname = '{0}'", key)
        Return CStr(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

End Class
