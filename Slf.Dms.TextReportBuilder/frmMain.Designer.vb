<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMain
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmMain))
        Me.txtOutput = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.cboConnString = New System.Windows.Forms.ComboBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtStatusLog = New System.Windows.Forms.TextBox
        Me.fbdFolder = New System.Windows.Forms.FolderBrowserDialog
        Me.btnBrowse = New System.Windows.Forms.Button
        Me.txtSpName = New System.Windows.Forms.TextBox
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.btnBuild = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.btnClear = New System.Windows.Forms.ToolStripButton
        Me.txtMessage = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.Button1 = New System.Windows.Forms.Button
        Me.txtDateFormatPersonal = New System.Windows.Forms.TextBox
        Me.txtDateFormatCreditor = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label10 = New System.Windows.Forms.Label
        Me.txtDateFormatTransaction = New System.Windows.Forms.TextBox
        Me.cboMonth = New System.Windows.Forms.ComboBox
        Me.txtYear = New System.Windows.Forms.TextBox
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'txtOutput
        '
        Me.txtOutput.Location = New System.Drawing.Point(99, 240)
        Me.txtOutput.Name = "txtOutput"
        Me.txtOutput.Size = New System.Drawing.Size(350, 20)
        Me.txtOutput.TabIndex = 6
        Me.txtOutput.Text = "\\dc01\process\ClientStatements"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(2, 36)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(91, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Connection String"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(2, 63)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(90, 13)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Stored Procedure"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(2, 243)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(84, 13)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Output Directory"
        '
        'cboConnString
        '
        Me.cboConnString.FormattingEnabled = True
        Me.cboConnString.ImeMode = System.Windows.Forms.ImeMode.[On]
        Me.cboConnString.Items.AddRange(New Object() {"server=drg-sql-01;uid=slf_dms;pwd=dms12#45!;database=slf_dms", "server=sqldb1;uid=slf_dms;pwd=dms12#45!;database=slf_dms"})
        Me.cboConnString.Location = New System.Drawing.Point(99, 33)
        Me.cboConnString.Name = "cboConnString"
        Me.cboConnString.Size = New System.Drawing.Size(406, 21)
        Me.cboConnString.TabIndex = 1
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(2, 90)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(65, 13)
        Me.Label4.TabIndex = 9
        Me.Label4.Text = "Date Range"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(2, 268)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(58, 13)
        Me.Label5.TabIndex = 10
        Me.Label5.Text = "Status Log"
        '
        'txtStatusLog
        '
        Me.txtStatusLog.BackColor = System.Drawing.Color.White
        Me.txtStatusLog.Location = New System.Drawing.Point(99, 268)
        Me.txtStatusLog.Multiline = True
        Me.txtStatusLog.Name = "txtStatusLog"
        Me.txtStatusLog.ReadOnly = True
        Me.txtStatusLog.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtStatusLog.Size = New System.Drawing.Size(406, 203)
        Me.txtStatusLog.TabIndex = 8
        '
        'btnBrowse
        '
        Me.btnBrowse.Location = New System.Drawing.Point(455, 240)
        Me.btnBrowse.Name = "btnBrowse"
        Me.btnBrowse.Size = New System.Drawing.Size(50, 22)
        Me.btnBrowse.TabIndex = 13
        Me.btnBrowse.Text = "Browse"
        Me.btnBrowse.UseVisualStyleBackColor = True
        '
        'txtSpName
        '
        Me.txtSpName.Location = New System.Drawing.Point(99, 60)
        Me.txtSpName.Name = "txtSpName"
        Me.txtSpName.Size = New System.Drawing.Size(406, 20)
        Me.txtSpName.TabIndex = 2
        Me.txtSpName.Text = "stp_ClientStatementBuilder"
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.btnBuild, Me.ToolStripSeparator1, Me.btnClear})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(516, 25)
        Me.ToolStrip1.TabIndex = 17
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'btnBuild
        '
        Me.btnBuild.Image = CType(resources.GetObject("btnBuild.Image"), System.Drawing.Image)
        Me.btnBuild.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnBuild.Name = "btnBuild"
        Me.btnBuild.Size = New System.Drawing.Size(66, 22)
        Me.btnBuild.Text = "Execute"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'btnClear
        '
        Me.btnClear.Image = CType(resources.GetObject("btnClear.Image"), System.Drawing.Image)
        Me.btnClear.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(72, 22)
        Me.btnClear.Text = "Clear Log"
        '
        'txtMessage
        '
        Me.txtMessage.Location = New System.Drawing.Point(99, 190)
        Me.txtMessage.MaxLength = 255
        Me.txtMessage.Multiline = True
        Me.txtMessage.Name = "txtMessage"
        Me.txtMessage.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtMessage.Size = New System.Drawing.Size(406, 44)
        Me.txtMessage.TabIndex = 5
        Me.txtMessage.Text = "Please update your contact information with client services by calling 1-800-555" & _
            "-1212."
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(2, 193)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(90, 13)
        Me.Label6.TabIndex = 19
        Me.Label6.Text = "Message Content"
        '
        'Button1
        '
        Me.Button1.Location = New System.Drawing.Point(454, 240)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(50, 22)
        Me.Button1.TabIndex = 7
        Me.Button1.Text = "Browse"
        Me.Button1.UseVisualStyleBackColor = True
        '
        'txtDateFormatPersonal
        '
        Me.txtDateFormatPersonal.Location = New System.Drawing.Point(187, 112)
        Me.txtDateFormatPersonal.Name = "txtDateFormatPersonal"
        Me.txtDateFormatPersonal.Size = New System.Drawing.Size(130, 20)
        Me.txtDateFormatPersonal.TabIndex = 20
        Me.txtDateFormatPersonal.Text = "MMM dd, yyyy"
        '
        'txtDateFormatCreditor
        '
        Me.txtDateFormatCreditor.Location = New System.Drawing.Point(187, 138)
        Me.txtDateFormatCreditor.Name = "txtDateFormatCreditor"
        Me.txtDateFormatCreditor.Size = New System.Drawing.Size(130, 20)
        Me.txtDateFormatCreditor.TabIndex = 21
        Me.txtDateFormatCreditor.Text = "MMM dd, yyyy"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(2, 115)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(81, 13)
        Me.Label7.TabIndex = 23
        Me.Label7.Text = "File DT Formats"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(96, 115)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(85, 13)
        Me.Label8.TabIndex = 24
        Me.Label8.Text = "(1) Personal File:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(96, 141)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(80, 13)
        Me.Label9.TabIndex = 25
        Me.Label9.Text = "(2) Creditor File:"
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(96, 167)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(89, 13)
        Me.Label10.TabIndex = 27
        Me.Label10.Text = "(3) Transact. File:"
        '
        'txtDateFormatTransaction
        '
        Me.txtDateFormatTransaction.Location = New System.Drawing.Point(187, 164)
        Me.txtDateFormatTransaction.Name = "txtDateFormatTransaction"
        Me.txtDateFormatTransaction.Size = New System.Drawing.Size(130, 20)
        Me.txtDateFormatTransaction.TabIndex = 26
        Me.txtDateFormatTransaction.Text = "MM/dd/yyyy"
        '
        'cboMonth
        '
        Me.cboMonth.FormattingEnabled = True
        Me.cboMonth.Items.AddRange(New Object() {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"})
        Me.cboMonth.Location = New System.Drawing.Point(99, 86)
        Me.cboMonth.Name = "cboMonth"
        Me.cboMonth.Size = New System.Drawing.Size(137, 21)
        Me.cboMonth.TabIndex = 28
        '
        'txtYear
        '
        Me.txtYear.Location = New System.Drawing.Point(242, 87)
        Me.txtYear.Name = "txtYear"
        Me.txtYear.Size = New System.Drawing.Size(75, 20)
        Me.txtYear.TabIndex = 29
        '
        'frmMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(516, 483)
        Me.Controls.Add(Me.txtYear)
        Me.Controls.Add(Me.cboMonth)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.txtDateFormatTransaction)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.txtDateFormatCreditor)
        Me.Controls.Add(Me.txtDateFormatPersonal)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.txtMessage)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.txtSpName)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.btnBrowse)
        Me.Controls.Add(Me.txtStatusLog)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.cboConnString)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtOutput)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "frmMain"
        Me.Text = "DMS Statement Builder"
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents txtOutput As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents cboConnString As System.Windows.Forms.ComboBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtStatusLog As System.Windows.Forms.TextBox
    Friend WithEvents fbdFolder As System.Windows.Forms.FolderBrowserDialog
    Friend WithEvents btnBrowse As System.Windows.Forms.Button
    Friend WithEvents txtSpName As System.Windows.Forms.TextBox
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents btnClear As System.Windows.Forms.ToolStripButton
    Friend WithEvents btnBuild As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents txtMessage As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents txtDateFormatPersonal As System.Windows.Forms.TextBox
    Friend WithEvents txtDateFormatCreditor As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents txtDateFormatTransaction As System.Windows.Forms.TextBox
    Friend WithEvents cboMonth As System.Windows.Forms.ComboBox
    Friend WithEvents txtYear As System.Windows.Forms.TextBox

End Class
