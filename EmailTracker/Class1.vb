Imports System
Imports System.Net.Mail
Imports System.Text.RegularExpressions
Imports System.Web
Imports System.Data.SqlClient

Namespace EmailTracker

    ' Currently hosted on lexscd.com
    ' Tracks only emails saved in tblClientEmails
    ' To use add to email msg <img src='http://lexscd.com/tracker/{ClientEmailID}.aspx' />
    ' Add to web.config <httpModules><add type="EmailTracker.TrackRequest1,EmailTracker" name="EmailTracker"/>

    Public Class TrackRequest1
        Implements IHttpModule

        Private pattern As String = "/tracker/(?<key>.*)\.aspx"
        Private imgSpacer As String = "~/tracker/spacer.gif"
        Private dbConnectionString As String = "server=Lexsrvsqlprod1\lexsrvsqlprod;uid=dms_sql2;pwd=j@ckp0t!;database=dms;connect timeout=180;max pool size = 150"
        'Private dbConnectionString As String = "server=sql2;uid=dms_sql;pwd=sql1login;database=dms_restored_daily;connect timeout=60;max pool size = 150"

        Public Sub New()
        End Sub

        Public Sub Dispose() Implements System.Web.IHttpModule.Dispose
        End Sub

        Public Sub Init(ByVal Appl As System.Web.HttpApplication) Implements System.Web.IHttpModule.Init
            AddHandler Appl.BeginRequest, AddressOf GetImage_BeginRequest
        End Sub

        Public Sub GetImage_BeginRequest(ByVal sender As Object, ByVal args As System.EventArgs)
            'cast the sender to a HttpApplication object
            Dim application As System.Web.HttpApplication = CType(sender, System.Web.HttpApplication)
            Dim url As String = application.Request.Path 'get the url path
            'create the regex to match for becon images
            Dim r As New Regex(pattern, RegexOptions.Compiled Or RegexOptions.IgnoreCase)
            If r.IsMatch(url) Then
                Dim mc As MatchCollection = r.Matches(url)
                If Not (mc Is Nothing) And mc.Count > 0 Then
                    Dim key As String = mc(0).Groups("key").Value
                    SaveToDB(key)
                End If

                'now send the image to the client
                application.Response.ContentType = "image/gif"
                application.Response.WriteFile(application.Request.MapPath(imgSpacer))
                application.Response.End()
            End If
        End Sub

        Private Sub SaveToDB(ByVal key As String)
            If key Is Nothing Or key.Trim().Length = 0 Then
                Return
            End If
            Dim sqlText As String = String.Format("update tblclientemails set dateread = getdate() where clientemailid = {0} and dateread is null", key)
            Dim cmd As New SqlCommand(sqlText, New SqlConnection(dbConnectionString))
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
        End Sub

    End Class

End Namespace