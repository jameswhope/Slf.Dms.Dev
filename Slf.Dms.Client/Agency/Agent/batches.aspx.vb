Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic
Imports System.Threading
Imports System.ComponentModel

Partial Class _Agent_Batches
    Inherits System.Web.UI.Page

    Public Structure BatchEntry
        Public CommBatchId As Integer
        Public BatchDate As Date
        Public Amount As Single
    End Structure

    Structure CommissionBatchEntry
        Public ClientID As Integer
        Public Name As String
        Public Amount As Single
    End Structure

    Structure CommissionPersonEntry
        Public EntryType As String
        Public Percent As String
        Public Amount As Single
    End Structure

    Public UserID As Integer
    Public UserTypeID As Integer
    Public CommRecID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        CommRecID = Request.QueryString("commrec")

        trvBatches.Nodes.Clear()

        Requery()
    End Sub

    Public Sub Requery()
        Dim batches As List(Of BatchEntry) = PopulateBatches()
        Dim details As List(Of CommissionBatchEntry)
        Dim persons As New List(Of CommissionPersonEntry)
        Dim idxbatch As Integer = 0
        Dim idxdetail As Integer = 0
        Dim idxperson As Integer = 0

        For Each batch As BatchEntry In batches
            trvBatches.Nodes.Add(New TreeNode("<td><img src=""" + ResolveUrl("~\images\16x16_folder2.png") + """ width=""16"" height=""16"">&nbsp;</td><td align=""left"" width=""25%"" style=""font-family:Arial;font-size:14px;"">" + batch.CommBatchId.ToString() + "</td><td align=""left"" width=""50%"" style=""font-family:Arial;font-size:14px;"">" + batch.BatchDate.ToString() + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:14px;"">" + batch.Amount.ToString("c") + "</td>", idxbatch))
            details = PopulateDetails(batch.CommBatchId)

            idxdetail = 0
            For Each detail As CommissionBatchEntry In details
                trvBatches.Nodes(idxbatch).ChildNodes.Add(New TreeNode("<td><img src=""" + ResolveUrl("~\images\16x16_person.png") + """ width=""16"" height=""16""></td><td align=""left"" width=""20%"" style=""font-family:Arial;font-size:12px;"">" + detail.ClientID.ToString() + "</td><td align=""left"" width=""50%"" style=""font-family:Arial;font-size:12px;"">" + detail.Name.ToString() + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + detail.Amount.ToString("c") + "</td>", idxdetail))

                persons = PopulatePerson(batch.CommBatchId, detail.ClientID)

                idxperson = 0
                For Each info As CommissionPersonEntry In persons
                    trvBatches.Nodes(idxbatch).ChildNodes(idxdetail).ChildNodes.Add(New TreeNode("<td align=""left"" width=""50%"" style=""font-family:Arial;font-size:12px;"">" + info.EntryType.ToString() + "</td><td align=""left"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + info.Percent.ToString() + "</td><td align=""right"" width=""25%"" style=""font-family:Arial;font-size:12px;"">" + info.Amount.ToString("c") + "</td>", idxperson))
                    idxperson += 1
                Next

                idxdetail += 1
            Next

            idxbatch += 1
        Next

        tblLoading.Visible = False

        If idxbatch = 0 Then
            tblNone.Visible = True
        Else
            tblHeaders.Visible = True
            trvBatches.Visible = True
        End If
    End Sub

    Public Function PopulateBatches() As List(Of BatchEntry)
        Dim batches As New List(Of BatchEntry)
        Dim b As BatchEntry

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetAgencyBatches_" + Request.QueryString("company"))
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Date1", Request.QueryString("begin"))
                DatabaseHelper.AddParameter(cmd, "Date2", Request.QueryString("end"))

                DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        b = New BatchEntry
                        b.CommBatchId = DatabaseHelper.Peel_int(rd, "CommBatchId")
                        b.BatchDate = DatabaseHelper.Peel_date(rd, "BatchDate")
                        b.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                        batches.Add(b)
                    End While
                End Using
            End Using
        End Using

        Return batches
    End Function

    Public Function PopulateDetails(ByVal batchid As Integer) As List(Of CommissionBatchEntry)
        Dim tempEntry As CommissionBatchEntry
        Dim CommissionBatch As New List(Of CommissionBatchEntry)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatchTransfers")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CommBatchIDs", batchid)
                DatabaseHelper.AddParameter(cmd, "CommRecID", CommRecID)
                Session("rptcmd_report_commission_batchpayments") = cmd

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        tempEntry = New CommissionBatchEntry
                        tempEntry.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                        tempEntry.Name = DatabaseHelper.Peel_string(rd, "ClientName").Trim()
                        tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                        CommissionBatch.Add(tempEntry)
                    End While
                End Using
            End Using
        End Using

        Return CommissionBatch
    End Function

    Public Function PopulatePerson(ByVal batchid As Integer, ByVal clientid As String) As List(Of CommissionPersonEntry)
        Dim tempEntry As CommissionPersonEntry
        Dim CommissionPerson As New List(Of CommissionPersonEntry)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionBatchTransfersByClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CommBatchIDs", batchid)
                DatabaseHelper.AddParameter(cmd, "CommRecID", CommRecID)
                DatabaseHelper.AddParameter(cmd, "ClientID", clientid)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        tempEntry = New CommissionPersonEntry
                        tempEntry.EntryType = DatabaseHelper.Peel_string(rd, "EntryType")
                        tempEntry.Percent = Math.Round(DatabaseHelper.Peel_float(rd, "Percent") * 100, 2).ToString() + "%"
                        tempEntry.Amount = DatabaseHelper.Peel_float(rd, "Amount")

                        CommissionPerson.Add(tempEntry)
                    End While
                End Using
            End Using
        End Using

        Return CommissionPerson
    End Function

End Class