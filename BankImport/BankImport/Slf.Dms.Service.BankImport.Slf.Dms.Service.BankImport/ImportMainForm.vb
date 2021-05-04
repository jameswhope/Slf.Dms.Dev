Imports Slf.Dms.Service
Imports System
Imports System.Collections
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Windows.Forms

Namespace Slf.Dms.Service.BankImport.Slf.Dms.Service.BankImport
    Public Class ImportMainForm
        Inherits Form
        ' Methods
        Public Sub New()
            Dim list As ArrayList = ImportMainForm.__ENCList_
            SyncLock list
                ImportMainForm.__ENCList_.Add(New WeakReference(Me))
            End SyncLock
            Me.InitializeComponent()
        End Sub

        Private Sub browseButton_Click(ByVal sender As Object, ByVal e As EventArgs)
            Using dialog As OpenFileDialog = New OpenFileDialog
                dialog.InitialDirectory = ImportMain.FileLocation
                If (dialog.ShowDialog(Me) = DialogResult.OK) Then
                    Me.dataFileTextBox.Text = dialog.FileName
                End If
            End Using
        End Sub

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (IIf((disposing AndAlso (Not Me.components Is Nothing)), 1, 0) <> 0) Then
                Me.components.Dispose()
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Sub importButton_Click(ByVal sender As Object, ByVal e As EventArgs)
            ImportMain.ImportFile(Me.dataFileTextBox.Text, Me.databaseTextBox.Text)
        End Sub

        Private Sub ImportMainForm_Load(ByVal sender As Object, ByVal e As EventArgs)
            Me.databaseTextBox.Text = ImportMain.ConnectionString
            Trace.Listeners.Add(New Drg.Util.TextBoxTraceListener(Me.logTextBox))
        End Sub

        Private Sub InitializeComponent()
            Me.label3 = New Label
            Me.label2 = New Label
            Me.label1 = New Label
            Me.importButton = New Button
            Me.logTextBox = New TextBox
            Me.databaseTextBox = New TextBox
            Me.browseButton = New Button
            Me.dataFileTextBox = New TextBox
            Me.runStoredProcCheckBox = New CheckBox
            MyBase.SuspendLayout()
            Me.label3.AutoSize = True
            Dim point As New Point(&H10, &H88)
            Me.label3.Location = point
            Me.label3.Name = "label3"
            Dim size As New Size(&H1A, &H10)
            Me.label3.Size = size
            Me.label3.TabIndex = 5
            Me.label3.Text = "&Log:"
            Me.label2.AutoSize = True
            point = New Point(&H10, &H30)
            Me.label2.Location = point
            Me.label2.Name = "label2"
            size = New Size(&H61, &H10)
            Me.label2.Size = size
            Me.label2.TabIndex = 2
            Me.label2.Text = "&Connection String:"
            Me.label1.AutoSize = True
            point = New Point(&H10, &H10)
            Me.label1.Location = point
            Me.label1.Name = "label1"
            size = New Size(&H37, &H10)
            Me.label1.Size = size
            Me.label1.TabIndex = 0
            Me.label1.Text = "Bank &File:"
            point = New Point(&HC0, &H70)
            Me.importButton.Location = point
            Me.importButton.Name = "importButton"
            size = New Size(&H4F, &H17)
            Me.importButton.Size = size
            Me.importButton.TabIndex = 4
            Me.importButton.Text = "&Import"
            AddHandler Me.importButton.Click, New EventHandler(AddressOf Me.importButton_Click)
            Me.logTextBox.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.logTextBox.BackColor = SystemColors.Window
            point = New Point(&H10, &H98)
            Me.logTextBox.Location = point
            Me.logTextBox.Multiline = True
            Me.logTextBox.Name = "logTextBox"
            Me.logTextBox.ReadOnly = True
            Me.logTextBox.ScrollBars = ScrollBars.Both
            size = New Size(420, &HD1)
            Me.logTextBox.Size = size
            Me.logTextBox.TabIndex = 6
            Me.logTextBox.Text = ""
            Me.databaseTextBox.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or AnchorStyles.Top))
            point = New Point(120, &H30)
            Me.databaseTextBox.Location = point
            Me.databaseTextBox.Name = "databaseTextBox"
            size = New Size(&H13C, 20)
            Me.databaseTextBox.Size = size
            Me.databaseTextBox.TabIndex = 3
            Me.databaseTextBox.Text = ""
            Me.browseButton.Anchor = (AnchorStyles.Right Or AnchorStyles.Top)
            point = New Point(&H198, &H10)
            Me.browseButton.Location = point
            Me.browseButton.Name = "browseButton"
            size = New Size(&H1C, &H17)
            Me.browseButton.Size = size
            Me.browseButton.TabIndex = 9
            Me.browseButton.Text = "..."
            AddHandler Me.browseButton.Click, New EventHandler(AddressOf Me.browseButton_Click)
            Me.dataFileTextBox.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or AnchorStyles.Top))
            point = New Point(120, &H10)
            Me.dataFileTextBox.Location = point
            Me.dataFileTextBox.Name = "dataFileTextBox"
            size = New Size(&H11C, 20)
            Me.dataFileTextBox.Size = size
            Me.dataFileTextBox.TabIndex = 1
            Me.dataFileTextBox.Text = ""
            Me.runStoredProcCheckBox.Checked = True
            Me.runStoredProcCheckBox.CheckState = CheckState.Checked
            point = New Point(120, &H48)
            Me.runStoredProcCheckBox.Location = point
            Me.runStoredProcCheckBox.Name = "runStoredProcCheckBox"
            size = New Size(&H138, &H18)
            Me.runStoredProcCheckBox.Size = size
            Me.runStoredProcCheckBox.TabIndex = 10
            Me.runStoredProcCheckBox.Text = "&Update transactions"
            size = New Size(5, 13)
            Me.AutoScaleBaseSize = size
            size = New Size(&H1C4, &H176)
            MyBase.ClientSize = size
            MyBase.Controls.Add(Me.runStoredProcCheckBox)
            MyBase.Controls.Add(Me.label3)
            MyBase.Controls.Add(Me.label2)
            MyBase.Controls.Add(Me.label1)
            MyBase.Controls.Add(Me.logTextBox)
            MyBase.Controls.Add(Me.databaseTextBox)
            MyBase.Controls.Add(Me.dataFileTextBox)
            MyBase.Controls.Add(Me.importButton)
            MyBase.Controls.Add(Me.browseButton)
            MyBase.Name = "ImportMainForm"
            Me.Text = "Manual Import"
            AddHandler MyBase.Load, New EventHandler(AddressOf Me.ImportMainForm_Load)
            MyBase.ResumeLayout(False)
        End Sub


        ' Fields
        Private Shared __ENCList_ As ArrayList = New ArrayList
        Private browseButton As Button
        Private components As Container
        Private databaseTextBox As TextBox
        Private dataFileTextBox As TextBox
        Private importButton As Button
        Private label1 As Label
        Private label2 As Label
        Private label3 As Label
        Private logTextBox As TextBox
        Private runStoredProcCheckBox As CheckBox
    End Class
End Namespace

