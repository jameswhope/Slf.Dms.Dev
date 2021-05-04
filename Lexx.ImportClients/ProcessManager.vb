Public Enum ProcessStatus
    exporting = 0
    succeeded = 1
    failed = 2
End Enum

Public Class ImportReport
    Private _failed As New List(Of ClientInfo)
    Private _succeded As New List(Of ClientInfo)
    Private _exception As ExceptionInfo
    Private _status As ProcessStatus = 0

    Public ReadOnly Property FailedClients() As List(Of ClientInfo)
        Get
            Return _failed
        End Get
    End Property

    Public ReadOnly Property SuccededClients() As List(Of ClientInfo)
        Get
            Return _succeded
        End Get
    End Property

    Public Property Status() As ProcessStatus
        Get
            Return _status
        End Get
        Set(ByVal value As ProcessStatus)
            _status = value
        End Set
    End Property


    Public Property ProcessException() As ExceptionInfo
        Get
            Return _exception
        End Get
        Set(ByVal value As ExceptionInfo)
            _exception = value
        End Set
    End Property

End Class

Public Class ProcessManager
    Public Shared Function ImportClients(ByVal clients As List(Of ClientInfo), ByVal SourceId As Integer) As ImportReport
        Dim report As New ImportReport
        Try

            If clients Is Nothing Then
                'return error here
                Throw New Exception("There are no clients to import")
            Else
                'import 
                Dim catalogs As New CatalogInfo
                Dim UserId As Integer = 26 'User Id for client import service
                Dim ImportJobId As Integer = CreateImportJob(SourceId)
                For Each client As ClientInfo In clients
                    client.JobId = ImportJobId
                    client.SourceId = SourceId
                    If client.Import(catalogs, UserId) Then
                        report.SuccededClients.Add(client)
                    Else
                        report.FailedClients.Add(client)
                    End If
                Next
            End If
            report.Status = ProcessStatus.succeeded
        Catch ex As Exception
            report.Status = ProcessStatus.failed
            report.ProcessException = New ExceptionInfo(ex.Message)
        End Try
        Return report
    End Function

    Private Shared Function CreateImportJob(ByVal SourceId As Integer) As Integer
        Dim dh As New DataHelper
        Return dh.InsertImportJob(SourceId)
    End Function

End Class
