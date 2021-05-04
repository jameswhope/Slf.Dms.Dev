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
Imports System.Text
Imports System.Data.SqlClient
Imports System.IO
Imports System.Threading

Imports Microsoft.VisualBasic
Imports Microsoft.Win32
Imports System.Diagnostics
Imports PdfSharp.Pdf.Printing

Partial Class admin_ClientStatements_Default
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer
    Private Month As String
    Private Year As String
    Private DocPath As String
    Private Shadows ClientID As Integer
    Private AccountNumber As String
    Private qs As QueryStringCollection
    Private vMonth As String = ""
    Private vYear As String = ""
    Private Period As String

#End Region

    Protected Sub lnkPrintStmts_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrintStmts.Click
        Dim dr As SqlDataReader
        Dim AccountNumber As String
        Dim ClientID As Integer
        Dim strSQL As String = ""
        Dim x As Integer = 0
        Dim y As Integer = 0
        Dim cmdUpdate As SqlCommand = Nothing
        Dim cnUpdate As SqlConnection = Nothing
        Dim FileList(1000) As String
        Dim prn As New System.Drawing.Printing.PrinterSettings
        Dim Errors As Boolean = False
        Dim process As Process
        Dim rk As RegistryKey = Registry.LocalMachine.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\App Paths\AcroRd32.exe", False)
        Dim valueName As String = "Path"
        Dim o As Object = rk.GetValue(valueName)
        Dim printerName As String = "" '"\\DMF-APP-0001\Xerox WorkCentre 7665" '"192.168.1.203"
        Dim AdobePDF As String = o.ToString & "AcroRd32.exe"
        Dim ProcID As Integer = 0
        Dim PDFFilePrinter As PdfSharp.Pdf.Printing.PdfFilePrinter = Nothing

        If Me.txtNumToPrint.Text <> "" Then
            x = CInt(txtNumToPrint.Text.ToString)
        Else
            x = 0
        End If
        y = 0

        If x > 0 Then
            'for printing
            strSQL = "SELECT AccountNumber, StmtPeriod, ClientID  " _
            & "FROM tblStatementPersonal " _
            & "WHERE 1 = 1 " _
            & "AND ElectronicStatement = 0 " _
            & "AND StmtCreated = 1 " _
            & "AND StmtPrinted = 0 " _
            & "ORDER BY AccountNumber"
        Else
            Alert.Show("You  need to enter a number to print.")
            Exit Sub
        End If

        Dim cn As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
        cn.Open()
        Dim cmd As New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader()

        If Not dr.HasRows Then
            Alert.Show("There are no statements in the queue to print!")
            Exit Sub
        End If

        Do While dr.Read
            Try
                If x > 0 Then
                    If y = x Then
                        Exit Do
                    End If
                End If
                AccountNumber = dr.Item("AccountNumber").ToString
                ClientID = dr.Item("ClientID")
                Period = dr.Item("StmtPeriod").ToString()
                ClientID = dr.Item("ClientID")
                DocPath = "\\NAS02\" & DataHelper.FieldLookup("tblClient", "StorageRoot", "AccountNumber = " & AccountNumber) & "\" & AccountNumber.ToString & "\ClientDocs\" & AccountNumber & "_Statement_" & Period & ".pdf"
                If Not File.Exists(DocPath) Then
                    GoTo GetTheNextOne
                End If

                Try
                    pdffileprinter = New PdfSharp.Pdf.Printing.PdfFilePrinter(DocPath)
                    pdffileprinter.AdobeReaderPath = AdobePDF
                    pdffileprinter.DefaultPrinterName = printerName
                    pdffileprinter.Print()

                    'ProcID = Shell(AdobePDF & " /t /h " & DocPath, AppWinStyle.Hide)

                    'process = New Process
                    'process.StartInfo.FileName = AdobePDF
                    'process.StartInfo.Arguments = "/t /h " & DocPath & " " & printerName
                    'process.StartInfo.CreateNoWindow = True
                    'process.StartInfo.Verb = "print"
                    'process.StartInfo.UseShellExecute = True
                    'process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden
                    'process.Start()
                    'process.WaitForExit(180)
                    'process.Kill()

                Catch ex As Exception
                    Errors = True
                    Alert.Show("An error has occured at the printer. ERROR: " & ex.Message)
                End Try

                cnUpdate = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
                cnUpdate.Open()
                strSQL = "UPDATE tblStatementPersonal SET StmtPrinted = 1 SET PrintedDate = getdate() WHERE AccountNumber = " & AccountNumber
                cmdUpdate = New SqlCommand(strSQL, cnUpdate)
                cmdUpdate.ExecuteNonQuery()

GetTheNextOne:

            Catch ex As Exception
                Errors = True
                Alert.Show("An error has occured: " & ex.Message & " processing Client No: " & ClientID)
            Finally
                If Not cnUpdate Is Nothing Then
                    If cnUpdate.State <> ConnectionState.Closed Then
                        cnUpdate.Close()
                    End If
                End If
                cmdUpdate = Nothing
                y += 1
                If Not Errors And y <> x Then
                    Me.txtInQueue.Text = CStr(CInt(Me.txtInQueue.Text) - 1)
                End If
            End Try
        Loop
        dr.Close()
        cn.Close()
        cmd.Dispose()

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        StillInQueue()
    End Sub

    Protected Sub StillInQueue()
        Dim strSQL As String = "SELECT count(accountnumber) from tblstatementpersonal WHERE ElectronicStatement = 0 AND StmtPrinted = 0 AND StmtCreated = 1"
        Dim Queue As Integer
        Dim cn As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        cn.Open()
        Dim cmd As New SqlCommand(strSQL, cn)
        Queue = cmd.ExecuteScalar
        Me.txtInQueue.Text = Queue.ToString
    End Sub
End Class
