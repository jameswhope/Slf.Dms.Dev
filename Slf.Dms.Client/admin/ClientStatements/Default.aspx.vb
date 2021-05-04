Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports System
Imports System.Data.SqlClient

Imports LexxiomLetterTemplates
Imports GrapeCity.ActiveReports.Export.Pdf
Imports Microsoft.VisualBasic

Partial Class admin_ClientStatements_Default
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private Month As String
    Private Year As String
    Private Shadows ClientID As Integer
    Private AccountNumber As String
    Private qs As QueryStringCollection
    Private vMonth As String = "01"
    Private vYear As String = "2014"

#End Region

    Protected Sub lnkCreateStatements_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCreateStatements.Click
        Dim iMonth As String
        iMonth = CDate(String.Format("{0} 1, {1}", vMonth, vYear)).Month
        Dim cRpt As GrapeCity.ActiveReports.SectionReport = Nothing
        Dim dr As SqlDataReader
        Dim AccountNumber As String
        Dim ClientID As Integer
        Dim DocPath As String
        Dim Period As String
        Dim strSQL As String = "SELECT AccountNumber, StmtPeriod, ClientID  FROM tblStatementPersonal where (ElectronicStatement IS NULL OR ElectronicStatement = 0)"
        Dim cn As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        cn.Open()
        Dim cmd As New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader()

        Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
            Do While dr.HasRows
                dr.Read()
                Period = dr.Item("StmtPeriod").ToString()
                AccountNumber = dr.Item("AccountNumber").ToString
                ClientID = dr.Item("ClientID")
                DocPath = "\\NAS02\" & DataHelper.FieldLookup("tblClient", "StorageRoot", "AccountNumber = " & AccountNumber) & "\" & AccountNumber.ToString & "\ClientDocs\" & AccountNumber & "_Stmt" & Period & ".pdf"
                cRpt = New GrapeCity.ActiveReports.SectionReport
                cRpt = New LexxiomLetterTemplates.ClientStatement(ClientID, iMonth, vYear)
                cRpt.Run()
                Dim rs As New IO.MemoryStream
                Using pdf As New PdfExport()
                    pdf.Export(cRpt.Document, rs)
                    pdf.Export(cRpt.Document, DocPath)
                End Using
            Loop
            'rs.Seek(0, IO.SeekOrigin.Begin)

            'Session("statement") = rs.ToArray

            'Dim _sb As New System.Text.StringBuilder()
            '_sb.Append("window.open('../../reports/viewPDFStream.aspx?type=statement','',")
            '_sb.Append("'toolbar=0,menubar=0,resizable=yes');")
            'ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

        End Using
    End Sub

    Protected Sub lnkPrintStmts_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrintStmts.Click
        Dim iMonth As String
        iMonth = CDate(String.Format("{0} 1, {1}", vMonth, vYear)).Month
        Dim cRpt As GrapeCity.ActiveReports.SectionReport = Nothing
        Dim dr As SqlDataReader
        Dim AccountNumber As String
        Dim ClientID As Integer
        Dim DocPath As String
        Dim Period As String
        Dim strSQL As String = ""
        Dim x As Integer = 0
        Dim y As Integer = 0
        Dim cmdUpdate As SqlCommand
        Dim cnUpdate As SqlConnection

        If Me.txtNumToPrint.Text <> "" Then
            x = CInt(txtNumToPrint.Text.ToString)
        Else
            x = 0
        End If
        y = 0

        If x > 0 Then
            'for printing
            strSQL = "SELECT AccountNumber, StmtPeriod, ClientID  FROM tblStatementPersonal where (ElectronicStatement IS NULL OR ElectronicStatement = 0 AND stmtCreated IS NOT NULL and Printed IS NULL)"
        Else
            'for creating for the files
            strSQL = "SELECT AccountNumber, StmtPeriod, ClientID  FROM tblStatementPersonal where (ElectronicStatement IS NULL OR ElectronicStatement = 0 AND stmtCreated IS NULL)"
        End If

        Dim cn As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        cn.Open()
        Dim cmd As New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader()

        Try
            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                Do While dr.HasRows
                    Try
                        If x > 0 Then
                            If y = x Then
                                Exit Do
                            End If
                        End If
                        dr.Read()
                        Period = dr.Item("StmtPeriod").ToString()
                        AccountNumber = dr.Item("AccountNumber").ToString
                        ClientID = dr.Item("ClientID")
                        DocPath = "\\NAS02\" & DataHelper.FieldLookup("tblClient", "StorageRoot", "AccountNumber = " & AccountNumber) & "\" & AccountNumber.ToString & "\ClientDocs\" & AccountNumber & "_Stmt" & Period & ".pdf"
                        cRpt = New GrapeCity.ActiveReports.SectionReport
                        cRpt = New LexxiomLetterTemplates.ClientStatement(ClientID, iMonth, vYear)
                        cRpt.Run()
                        cRpt.Document.Printer.PrinterSettings.Duplex = Printing.Duplex.Vertical
                        cRpt.Document.Print(False, True, True)

                        cnUpdate = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                        cnUpdate.Open()
                        strSQL = "UPDATE tblStatementPersonal SET Printed = 1 WHERE AccountNumber = " & AccountNumber
                        cmdUpdate = New SqlCommand(strSQL, cnUpdate)
                        cmdUpdate.ExecuteNonQuery()

                        y += 1

                    Catch ex As Exception

                    Finally
                        If Not cnUpdate Is Nothing Then
                            If cnUpdate.State <> ConnectionState.Closed Then
                                cnUpdate.Close()
                            End If
                        End If
                        cmdUpdate = Nothing
                    End Try
                Loop
                dr.Close()
            End Using
        Catch ex1 As Exception

        Finally
            cn.Close()
            cmd.Dispose()
        End Try
    End Sub
End Class
