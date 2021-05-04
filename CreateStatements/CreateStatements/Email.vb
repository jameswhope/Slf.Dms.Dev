Imports System.Net.Mail

Public Class Email

   Private _fromAddress As String
   Private _toAddresses As String
   Private _subject As String
   Private _server As String
   Private _body As String = String.Empty
   Private _Attach As String
   Private _data As Attachment

   Public Property From() As String
      Get
         Return _fromAddress
      End Get
      Set(ByVal value As String)
         _fromAddress = value
      End Set
   End Property

   Public Property [To]() As String
      Get
         Return _toAddresses
      End Get
      Set(ByVal value As String)
         _toAddresses = value
      End Set
   End Property

   Public Property Subject() As String
      Get
         Return _subject
      End Get
      Set(ByVal value As String)
         _subject = value
      End Set
   End Property

   Public Property SmtpServer() As String
      Get
         Return _server
      End Get
      Set(ByVal value As String)
         _server = value
      End Set
   End Property

   Public Property Body() As String
      Get
         Return _body
      End Get
      Set(ByVal value As String)
         _body = value
      End Set
   End Property

   Public Property Attach() As String
      Get
         Return _Attach
      End Get
      Set(ByVal value As String)
         _Attach = value
      End Set
   End Property

   Public Sub Send()
      _data = New Attachment(_Attach, System.Net.Mime.MediaTypeNames.Text.Plain)
      Dim email As New SmtpClient(_server)
      Dim message As New MailMessage
      message.From = New MailAddress(_fromAddress)
      message.To.Add(_toAddresses)
      message.IsBodyHtml = True
      message.Subject = _subject
      message.Body = _body
      message.Attachments.Add(_data)
      email.Send(message)
   End Sub

   Public Sub Send(ByVal fileContent As String, ByVal fileName As String)
      Dim memoryStream As New System.IO.MemoryStream
      Dim memoryWriter As New System.IO.StreamWriter(memoryStream)
      Try
         Dim email As New SmtpClient(_server)
         Dim message As New MailMessage
         message.From = New MailAddress(_fromAddress)
         message.To.Add(_toAddresses)
         memoryWriter.Write(fileContent)
         memoryWriter.Flush()
         memoryStream.Seek(0, System.IO.SeekOrigin.Begin)
         'message.Attachments.Add(_data)
         message.IsBodyHtml = True
         message.Subject = _subject
         message.Body = _body
         email.Send(message)
      Finally
         memoryWriter.Close()
         memoryStream.Close()
      End Try
   End Sub

End Class
