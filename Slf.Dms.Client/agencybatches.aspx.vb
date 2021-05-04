Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Collections.Generic

Partial Class agencybatches
    Inherits System.Web.UI.Page

    Public Structure BatchEntry
        Public CommBatchId As Integer
        Public BatchDate As Date
        Public Amount As Single
    End Structure

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim batches As New List(Of BatchEntry)
        Dim SumAmount As Single

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetAgencyBatches_" + Request.QueryString("company"))
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "range", "top 5")
                DatabaseHelper.AddParameter(cmd, "CommRecId", Request.QueryString("commrecid"))

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        Dim b As New BatchEntry
                        b.CommBatchId = DatabaseHelper.Peel_int(rd, "CommBatchId")
                        b.BatchDate = DatabaseHelper.Peel_date(rd, "BatchDate")
                        b.Amount = DatabaseHelper.Peel_float(rd, "Amount")
                        SumAmount += b.Amount

                        batches.Add(b)
                    End While
                End Using

                tdTotal.InnerHtml = "Total: " & SumAmount.ToString("c")
                rpBatches.DataSource = batches
                rpBatches.DataBind()

                rpBatches.Visible = batches.Count > 0
                tdTotal.Visible = batches.Count > 0
                pnlNone.Visible = batches.Count = 0
            End Using
        End Using
    End Sub
End Class