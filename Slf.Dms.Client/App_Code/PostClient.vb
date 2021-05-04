Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Lexxiom.ImportClients
Imports System.Collections.Generic

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class PostClient
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function CreateClients(ByVal LeadApplicantIds As Integer(), ByVal SourceId As Integer, ByVal UserId As Integer) As Integer
        Dim LeadIds As List(Of Integer) = New List(Of Integer)
        LeadIds.AddRange(LeadApplicantIds)
        Dim ToShip As New List(Of ClientInfo)
        Dim JobId As Integer = 0
        Dim client As ClientInfo
        Try
            'Create Export Job
            JobId = SmartDebtorHelper.CreateExportJob(UserId)
            SmartDebtorHelper.CreateExportDetails(JobId, LeadIds)
            SmartDebtorHelper.LockClients(JobId)
            'Load the list of Applicant IDs selected for transfer to Lexxiom
            For Each LeadId As Integer In LeadIds
                Try
                    SmartDebtorHelper.ValidateRequiredDocuments(LeadId, New Integer() {SmartDebtorHelper.DocType.LSA, SmartDebtorHelper.DocType.VerificationRecorded})
                    client = SmartDebtorHelper.CreateClient(LeadId)
                    ToShip.Add(client)
                Catch ex As Exception
                    SmartDebtorHelper.UpdateLeadStatusForExport(JobId, LeadId, ClientImportStatus.failed, ex.Message)
                End Try
            Next
            If ToShip.Count = 0 Then Throw New Exception("There are no applicants with valid information to import.")
            Dim report As ImportReport = ProcessManager.ImportClients(ToShip, SourceId)
            SmartDebtorHelper.SaveReport(JobId, report, UserId)
            SmartDebtorHelper.UnLockClients(JobId)
        Catch ex As Exception
            SmartDebtorHelper.UnLockClients(JobId)
            SmartDebtorHelper.UpdateReportStatus(JobId, Lexxiom.ImportClients.ProcessStatus.failed, ex.Message)
        End Try

        Return JobId
    End Function

End Class
