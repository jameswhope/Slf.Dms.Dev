Option Explicit On

Imports System.Threading
Imports System.Windows.Forms

Public Class Program

    <STAThread()> _
    Shared Sub Main()
        Try
            Application.EnableVisualStyles()
            Application.SetCompatibleTextRenderingDefault(False)

            AddHandler Application.ThreadException, New ThreadExceptionEventHandler(AddressOf Application_ThreadException)

            'Dim frm As New frmBackup()

            'frm.Show()
            'frm.Backup()

        Catch ex As Exception
            MessageBox.Show(ex.ToString())
        End Try

    End Sub
    Shared Sub Application_ThreadException(ByVal sender As Object, ByVal e As ThreadExceptionEventArgs)
        MessageBox.Show(e.Exception.ToString())
    End Sub
End Class