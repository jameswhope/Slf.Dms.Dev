Imports System.Collections.Generic
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.IO
Imports System.Net.Mail
Imports System.Security.Cryptography

Imports GrapeCity.ActiveReports.Export.Pdf

Imports LexxiomLetterTemplates

Public Class EmailHelper

    #Region "Methods"
    Public Shared Function GetEmailTemplateByUniqueCallingID(ByVal emailType As String, ByVal UniqueCallingID As Integer) As EmailTemplate
        GetEmailTemplateByUniqueCallingID = New EmailTemplate
        Dim ssql As String = "SELECT [TemplateID],[TemplateText],[Created],[Type],[Seq],[UniqueCallingID] "
        ssql += "FROM tblEmailTemplates "
        ssql += String.Format("WHERE UniqueCallingID = {0} and [Type] = '{1}'", UniqueCallingID, emailType)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                With GetEmailTemplateByUniqueCallingID
                    .TemplateID = dr("TemplateID").ToString
                    .TemplateText = dr("TemplateText").ToString
                    .Created = dr("Created").ToString
                    .Type = IIf(IsDBNull(dr("Type")), Nothing, dr("Type").ToString)
                    .Seq = IIf(IsDBNull(dr("Seq")), Nothing, dr("Seq").ToString)
                    .UniqueCallingID = IIf(IsDBNull(dr("UniqueCallingID")), Nothing, dr("UniqueCallingID").ToString)
                End With

                Exit For
            Next
        End Using
    End Function
    Public Shared Function GetEmailTemplateByID(ByVal emailTemplateID As Integer) As EmailTemplate
        GetEmailTemplateByID = New EmailTemplate
        Dim ssql As String = "SELECT [TemplateID],[TemplateText],[Created],[Type],[Seq],[UniqueCallingID] "
        ssql += "FROM tblEmailTemplates "
        ssql += String.Format("WHERE TemplateID = {0}", emailTemplateID)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                With GetEmailTemplateByID
                    .TemplateID = dr("TemplateID").ToString
                    .TemplateText = dr("TemplateText").ToString
                    .Created = dr("Created").ToString
                    .Type = IIf(IsDBNull(dr("Type")), Nothing, dr("Type").ToString)
                    .Seq = IIf(IsDBNull(dr("Seq")), Nothing, dr("Seq").ToString)
                    .UniqueCallingID = IIf(IsDBNull(dr("UniqueCallingID")), Nothing, dr("UniqueCallingID").ToString)
                End With

                Exit For
            Next
        End Using
    End Function

    Public Shared Sub SendMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String)
        Dim email As New SmtpClient(AppSettings("EmailSMTP"))
        Dim recips As String() = [to].Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)

        Dim message As New MailMessage()
        message.From = New MailAddress(from)
        For Each rec As String In recips
            message.To.Add(New MailAddress(rec))
        Next
        message.Subject = subject
        message.Body = body


        message.IsBodyHtml = True

        Try
            email.Send(message)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Public Shared Sub SendMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String, ByVal attachments As List(Of String))
        Dim email As New SmtpClient(AppSettings("EmailSMTP"))
        Dim message As New MailMessage(from, [to], subject, body)

        message.IsBodyHtml = True

        'create the mail message
        Dim mail As New MailMessage()

        For Each att As String In attachments
            message.Attachments.Add(New Attachment(att))
        Next

        Try
            email.Send(message)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Public Shared Function GetUserEmailAddress(ByVal userid As Integer) As String
        Try
            Return SqlHelper.ExecuteScalar("Select emailaddress from tbluser where userid = " & userid, CommandType.Text).ToString
        Catch ex As Exception
            Return ""
        End Try
    End Function


#End Region 'Methods

#Region "Nested Types"

    Public Class EmailTemplate

#Region "Fields"

        Private _Created As String
        Private _Seq As String
        Private _TemplateID As String
        Private _TemplateText As String
        Private _Type As String
        Private _UniqueCallingID As String

#End Region 'Fields

#Region "Properties"

        Public Property Created() As String
            Get
                Return _Created
            End Get
            Set(ByVal value As String)
                _Created = value
            End Set
        End Property

        Public Property Seq() As String
            Get
                Return _Seq
            End Get
            Set(ByVal value As String)
                _Seq = value
            End Set
        End Property

        Public Property TemplateID() As String
            Get
                Return _TemplateID
            End Get
            Set(ByVal value As String)
                _TemplateID = value
            End Set
        End Property

        Public Property TemplateText() As String
            Get
                Return _TemplateText
            End Get
            Set(ByVal value As String)
                _TemplateText = value
            End Set
        End Property

        Public Property Type() As String
            Get
                Return _Type
            End Get
            Set(ByVal value As String)
                _Type = value
            End Set
        End Property

        Public Property UniqueCallingID() As String
            Get
                Return _UniqueCallingID
            End Get
            Set(ByVal value As String)
                _UniqueCallingID = value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class