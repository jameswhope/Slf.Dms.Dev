Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Nullable
Imports System.Net.Mail

Public Class BulkNegotiationHelper
    Inherits CriteriaBuilder
   Public Structure FileAttachment
      Public Name As String
      Public Description As String
      Public Content As String

      Public Sub Email(ByVal FileName As String, ByVal FileDescription As String, ByVal FileContent As String)
         Name = FileName
         Description = FileDescription
         Content = FileContent
      End Sub
   End Structure

    Public Function GetDashBoard(ByVal intFilterId As Integer) As DataTable
        Dim dsDashboard As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationDashBoardSummary")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", intFilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsDashboard)
            Return dsDashboard.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsDashboard)
        End Try
    End Function

    Public Function GetMyBulkLists(ByVal UserId As Integer) As DataTable
        Dim dsBulkLists As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationGetMyBulkLists")
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsBulkLists)
            Return dsBulkLists.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsBulkLists)
        End Try
    End Function

    Public Function GetDefaultColumns() As DataTable
        Dim dsListColumns As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationGetDefaultColumns")
            DatabaseHelper.ExecuteDataset(cmdObj, dsListColumns)
            Return dsListColumns.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsListColumns)
        End Try
    End Function

    Public Function GetListColumns(ByVal BulkListId As Integer) As DataTable
        Dim dsListColumns As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationGetListColumns")
            DatabaseHelper.AddParameter(cmdObj, "BulkListId", BulkListId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsListColumns)
            Return dsListColumns.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsListColumns)
        End Try
    End Function

    Public Function GetAssignmentsByFilterId(ByVal FilterId As Integer) As DataTable
        Dim dsAssignments As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationAssignmentsByFilterID")
            DatabaseHelper.AddParameter(cmdObj, "FilterId", FilterId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsAssignments)
            Return dsAssignments.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsAssignments)
        End Try
    End Function

    Public Function GetAssignmentsByListId(ByVal BulkListId As Integer) As DataTable
        Dim dsAssignments As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationAssignmentsByListID")
            DatabaseHelper.AddParameter(cmdObj, "BulkListId", BulkListId)
            DatabaseHelper.ExecuteDataset(cmdObj, dsAssignments)
            Return dsAssignments.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsAssignments)
        End Try
    End Function

    Public Function GetAvailableCols(ByVal intBulkListID As Integer) As DataTable
        Dim dsAssignments As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationAvailCols")
            DatabaseHelper.AddParameter(cmdObj, "BulkListID", intBulkListID)
            'DatabaseHelper.AddParameter(cmdObj, "Hidden", ) 'Optional, returns Hidden=0 by default
            DatabaseHelper.ExecuteDataset(cmdObj, dsAssignments)
            Return dsAssignments.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsAssignments)
        End Try
    End Function

    Public Function GetAllColumns() As DataTable
        Dim dsAssignments As Data.DataSet = New Data.DataSet
        Try
            cmdObj = GetCommand("stp_BulkNegotiationGetAllColumns")
            DatabaseHelper.ExecuteDataset(cmdObj, dsAssignments)
            Return dsAssignments.Tables(0)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmdObj.Connection)
            Dispose(cmdObj)
            Dispose(dsAssignments)
        End Try
    End Function

    Public Function AddBulkList(ByVal strListName As String, ByVal intCreatedBy As Integer, ByVal intOwnedBy As Integer) As Integer
        Dim intBulkListID As Integer

        Try
            cmdObj = GetCommand("stp_BulkNegotiationAddList")
            DatabaseHelper.AddParameter(cmdObj, "ListName", strListName)
            DatabaseHelper.AddParameter(cmdObj, "CreatedBy", intCreatedBy)
            DatabaseHelper.AddParameter(cmdObj, "OwnedBy", intOwnedBy)
            intBulkListID = CType(DatabaseHelper.ExecuteScalar(cmdObj), Integer)
        Catch ex As Exception
            Throw ex
        End Try

        Return intBulkListID
    End Function

    Public Sub AddToBulkList(ByVal intBulkListID As Integer, ByVal intAccountID As Integer)
        Try
            cmdObj = GetCommand("stp_BulkNegotiationAddToList")
            DatabaseHelper.AddParameter(cmdObj, "BulkListID", intBulkListID)
            DatabaseHelper.AddParameter(cmdObj, "AccountID", intAccountID)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub RemoveFromBulkList(ByVal intBulkListID As Integer, ByVal intAccountID As Integer)
        Try
            cmdObj = GetCommand("stp_BulkNegotiationRemoveFromList")
            DatabaseHelper.AddParameter(cmdObj, "BulkListID", intBulkListID)
            DatabaseHelper.AddParameter(cmdObj, "AccountID", intAccountID)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub AddToListTemplate(ByVal intBulkListID As Integer, ByVal intBulkFieldID As Integer, ByVal Position As Nullable(Of Integer))
        Try
            cmdObj = GetCommand("stp_BulkNegotiationAddToTemplate")
            DatabaseHelper.AddParameter(cmdObj, "BulkListID", intBulkListID)
            DatabaseHelper.AddParameter(cmdObj, "BulkFieldID", intBulkFieldID)
            If Position.HasValue Then
                DatabaseHelper.AddParameter(cmdObj, "Sequence", Position)
            End If
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub DeleteFromListTemplate(ByVal intBulkListID As Integer, ByVal intBulkFieldID As Integer)
        Try
            cmdObj = GetCommand("stp_BulkNegotiationDeleteFromTemplate")
            DatabaseHelper.AddParameter(cmdObj, "BulkListID", intBulkListID)
            DatabaseHelper.AddParameter(cmdObj, "BulkFieldID", intBulkFieldID)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub ChangeAccountCurrentAmount(ByVal AccountId As Integer, ByVal Amount As Double, ByVal UserId As Integer)
        Try
            cmdObj = GetCommand("stp_BulkNegotiationChangeCurrentAmount")
            DatabaseHelper.AddParameter(cmdObj, "AccountID", AccountId)
            DatabaseHelper.AddParameter(cmdObj, "Amount", Amount)
            DatabaseHelper.AddParameter(cmdObj, "UserId", UserId)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub SaveBulkList(ByVal BulkListId As Integer, ByVal AccountId As Integer, ByVal LastOfferMade As String, ByVal LastOfferReceived As String, ByVal LastNote As String, ByVal intUserID As Integer)
        Try
            cmdObj = GetCommand("stp_BulkNegotiationUpdateBulkList")
            DatabaseHelper.AddParameter(cmdObj, "BulkListId", BulkListId)
            DatabaseHelper.AddParameter(cmdObj, "AccountID", AccountId)
            DatabaseHelper.AddParameter(cmdObj, "LastOfferMade", LastOfferMade)
            DatabaseHelper.AddParameter(cmdObj, "LastOfferReceived", LastOfferReceived)
            DatabaseHelper.AddParameter(cmdObj, "LastNote", LastNote)
            DatabaseHelper.AddParameter(cmdObj, "LastModifiedDate", Now)
            DatabaseHelper.AddParameter(cmdObj, "LastModifiedBy", intUserID)
            DatabaseHelper.ExecuteNonQuery(cmdObj)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

   Public Sub SendEmail(ByVal Eaddress As String, ByVal Sender As String, ByVal CC As String, ByVal subject1 As String, ByVal Copies As Integer, ByVal Attachment As String)

      Try

         Dim Copy(1) As String
         Dim x As Integer

         If Copies > 0 Then
            Copy(0) = Eaddress
            Copy(1) = "ITGroup@Lexxiom.com"
         Else
            ReDim Preserve Copy(0)
            Copy(0) = Eaddress
         End If

         For x = 0 To Copy.Length - 1
            From = Sender
            [To] = Copy(x)
            Subject = subject1
            Body = "<table width=""100%"" cols=""1"" style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            & "<tr style=""font-size:14; font-family:Tahoma"">" _
            & "Attached is a list of accounts we would like to settle." _
            & "</tr>" _
            '& "<br/>" _
            '& "<br/>" _
            '& "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            '& "<b>Results:</b>" _
            '& "</tr>" _
            '& "<br/>" _
            '& "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma; color:red"">" _
            '& "" _
            '& "</tr>" _
            '& "<br/>" _
            '& "<br/>" _
            '& "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            '& "<b>End of summary.</b>" _
            '& "</tr>"
            If Attachment.Trim.Length > 0 Then
               Body += "<br/>" _
               & "<br/>" _
               & "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma"">" _
               & "For details please open the attached Excel page." _
               & "</tr>" _
               & "</table>"
            Else
               Body += "</table>"
            End If
            SmtpServer = System.Configuration.ConfigurationManager.AppSettings("EmailSMTP")
            Send(Attachment, Attachment)
         Next x
      Catch ex As Exception
         'Error sending email
      End Try
   End Sub

   Private _fromAddress As String
   Private _toAddresses As String
   Private _subject As String
   Private _server As String
   Private _body As String = String.Empty
   Private _CopyTo As String

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

   Public Property Cc() As String
      Get
         Return _CopyTo
      End Get
      Set(ByVal value As String)
         _CopyTo = value
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

   Public Sub Send()
      Dim email As New SmtpClient(_server)
      Dim message As New MailMessage
      message.From = New MailAddress(_fromAddress)
      message.To.Add(_toAddresses)
      message.IsBodyHtml = True
      message.Subject = _subject
      message.Body = _body
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
         'memoryWriter.Write(fileContent)
         'memoryWriter.Flush()
         'memoryStream.Seek(0, System.IO.SeekOrigin.Begin)
         message.Attachments.Add(New Attachment(fileName))
         message.IsBodyHtml = True
         message.Subject = _subject
         message.Body = _body
         email.Send(message)
      Finally
         memoryWriter.Close()
         memoryStream.Close()
      End Try
   End Sub

   Public Sub Send(ByVal fileAttachements As FileAttachment())
      Dim streams As New List(Of System.IO.MemoryStream)
      Dim writers As New List(Of System.IO.StreamWriter)
      Dim objStream As System.IO.MemoryStream
      Dim objWriter As System.IO.StreamWriter
      Try
         Dim email As New SmtpClient(_server)
         Dim message As New MailMessage
         message.From = New MailAddress(_fromAddress)
         message.To.Add(_toAddresses)
         'Initialize 
         For i As Integer = 0 To fileAttachements.Length - 1
            Try
               objStream = New System.IO.MemoryStream
               streams.Add(objStream)
               objWriter = New System.IO.StreamWriter(objStream)
               writers.Add(objWriter)
               objWriter.Write(fileAttachements(i).Content)
               objWriter.Flush()
               objStream.Seek(0, System.IO.SeekOrigin.Begin)
               message.Attachments.Add(New Attachment(objStream, fileAttachements(i).Name, System.Net.Mime.MediaTypeNames.Text.Html))
               _body = _body & String.Format("<br/>{0} is attached.", fileAttachements(i).Description)
            Catch ex As Exception
               _body = _body & String.Format("<br/>{0} was not attached because {1}.", fileAttachements(i).Name, ex.Message)
            End Try
         Next
         message.IsBodyHtml = True
         message.Subject = _subject
         message.Body = _body
         email.Send(message)
      Finally
         For Each objWriter In writers
            objWriter.Close()
         Next
         For Each objStream In streams
            objStream.Close()
         Next
      End Try
   End Sub
End Class
