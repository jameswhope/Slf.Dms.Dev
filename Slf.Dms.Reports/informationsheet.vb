Imports GrapeCity.ActiveReports.Document
Imports GrapeCity.ActiveReports.Document.Section
Imports GrapeCity.ActiveReports.SectionReportModel
Imports GrapeCity.ActiveReports.Controls
Imports GrapeCity.ActiveReports
Imports System



Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Public Class informationsheet
    Inherits GrapeCity.ActiveReports.SectionReport

    Public Sub New()
        MyBase.New()

        InitializeComponent()

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.25

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As GrapeCity.ActiveReports.SectionReportModel.ReportHeader = Nothing
    Private WithEvents Detail As GrapeCity.ActiveReports.SectionReportModel.Detail = Nothing
    Private WithEvents ReportFooter As GrapeCity.ActiveReports.SectionReportModel.ReportFooter = Nothing
    Private Picture As GrapeCity.ActiveReports.SectionReportModel.Picture
    Private TextBox As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox3 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox4 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox5 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox6 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox56 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox7 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox8 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox9 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox10 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox11 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox12 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox13 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox14 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox15 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox16 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox17 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox18 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox19 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox20 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtName1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtStreet1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtStreet1b As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtCity1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtState1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtZip1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtDob1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtSsn1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtHomePhone1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtHomeFax1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtBusinessPhone1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtBusinessFax1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtCellPhone1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtEmail1 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtName2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtStreet2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtStreet2b As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtCity2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtState2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtZip2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtDob2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtSsn2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtHomePhone2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtHomeFax2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtBusinessPhone2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtBusinessFax2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtCellPhone2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtEmail2 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox63 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox64 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox65 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox66 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox67 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox68 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox69 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox70 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox71 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox72 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox73 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox74 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox75 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox76 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox38 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox39 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox40 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox41 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtLanguage As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtMonthlyPayment As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtMonthlyDeposit As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private txtDepositMethod As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox21 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox22 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox23 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox24 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox25 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox26 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox27 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox28 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox29 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox30 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox31 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox32 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox33 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox34 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox42 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox43 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox44 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox45 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox46 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox47 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox48 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox49 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox50 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox51 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox52 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox53 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox54 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox55 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox35 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox36 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private TextBox37 As GrapeCity.ActiveReports.SectionReportModel.TextBox
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(informationsheet))
        Me.Detail = New GrapeCity.ActiveReports.SectionReportModel.Detail()
        Me.ReportHeader = New GrapeCity.ActiveReports.SectionReportModel.ReportHeader()
        Me.ReportFooter = New GrapeCity.ActiveReports.SectionReportModel.ReportFooter()
        Me.Picture = New GrapeCity.ActiveReports.SectionReportModel.Picture()
        Me.TextBox = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox3 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox4 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox5 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox6 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox56 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox7 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox8 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox9 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox10 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox11 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox12 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox13 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox14 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox15 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox16 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox17 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox18 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox19 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox20 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtName1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtStreet1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtStreet1b = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtCity1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtState1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtZip1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtDob1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtSsn1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtHomePhone1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtHomeFax1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtBusinessPhone1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtBusinessFax1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtCellPhone1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtEmail1 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtName2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtStreet2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtStreet2b = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtCity2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtState2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtZip2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtDob2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtSsn2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtHomePhone2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtHomeFax2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtBusinessPhone2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtBusinessFax2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtCellPhone2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtEmail2 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox63 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox64 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox65 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox66 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox67 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox68 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox69 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox70 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox71 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox72 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox73 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox74 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox75 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox76 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox38 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox39 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox40 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox41 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtLanguage = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtMonthlyPayment = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtMonthlyDeposit = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.txtDepositMethod = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox21 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox22 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox23 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox24 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox25 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox26 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox27 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox28 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox29 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox30 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox31 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox32 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox33 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox34 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox42 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox43 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox44 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox45 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox46 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox47 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox48 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox49 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox50 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox51 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox52 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox53 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox54 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox55 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox35 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox36 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        Me.TextBox37 = New GrapeCity.ActiveReports.SectionReportModel.TextBox()
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox3, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox5, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox6, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox56, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox7, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox9, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox10, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox11, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox12, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox13, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox14, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox15, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox16, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox17, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox18, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox19, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox20, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtName1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtStreet1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtStreet1b, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtCity1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtState1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtZip1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtDob1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtSsn1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtHomePhone1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtHomeFax1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtBusinessPhone1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtBusinessFax1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtCellPhone1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtEmail1, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtName2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtStreet2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtStreet2b, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtCity2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtState2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtZip2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtDob2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtSsn2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtHomePhone2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtHomeFax2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtBusinessPhone2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtBusinessFax2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtCellPhone2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtEmail2, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox63, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox64, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox65, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox66, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox67, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox68, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox69, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox70, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox71, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox72, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox73, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox74, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox75, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox76, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox38, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox39, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox40, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox41, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtLanguage, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtMonthlyPayment, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtMonthlyDeposit, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.txtDepositMethod, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox21, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox22, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox23, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox24, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox25, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox26, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox27, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox28, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox29, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox30, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox31, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox32, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox33, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox34, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox42, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox43, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox44, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox45, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox46, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox47, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox48, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox49, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox50, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox51, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox52, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox53, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox54, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox55, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox35, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox36, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me.TextBox37, System.ComponentModel.ISupportInitialize).BeginInit
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit
        '
        'Detail
        '
        Me.Detail.CanGrow = false
        Me.Detail.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox7, Me.TextBox8, Me.TextBox9, Me.TextBox10, Me.TextBox11, Me.TextBox12, Me.TextBox13, Me.TextBox14, Me.TextBox15, Me.TextBox16, Me.TextBox17, Me.TextBox18, Me.TextBox19, Me.TextBox20, Me.txtName1, Me.txtStreet1, Me.txtStreet1b, Me.txtCity1, Me.txtState1, Me.txtZip1, Me.txtDob1, Me.txtSsn1, Me.txtHomePhone1, Me.txtHomeFax1, Me.txtBusinessPhone1, Me.txtBusinessFax1, Me.txtCellPhone1, Me.txtEmail1, Me.txtName2, Me.txtStreet2, Me.txtStreet2b, Me.txtCity2, Me.txtState2, Me.txtZip2, Me.txtDob2, Me.txtSsn2, Me.txtHomePhone2, Me.txtHomeFax2, Me.txtBusinessPhone2, Me.txtBusinessFax2, Me.txtCellPhone2, Me.txtEmail2, Me.TextBox63, Me.TextBox64, Me.TextBox65, Me.TextBox66, Me.TextBox67, Me.TextBox68, Me.TextBox69, Me.TextBox70, Me.TextBox71, Me.TextBox72, Me.TextBox73, Me.TextBox74, Me.TextBox75, Me.TextBox76, Me.TextBox38, Me.TextBox39, Me.TextBox40, Me.TextBox41, Me.txtLanguage, Me.txtMonthlyPayment, Me.txtMonthlyDeposit, Me.txtDepositMethod, Me.TextBox21, Me.TextBox22, Me.TextBox23, Me.TextBox24, Me.TextBox25, Me.TextBox26, Me.TextBox27, Me.TextBox28, Me.TextBox29, Me.TextBox30, Me.TextBox31, Me.TextBox32, Me.TextBox33, Me.TextBox34, Me.TextBox42, Me.TextBox43, Me.TextBox44, Me.TextBox45, Me.TextBox46, Me.TextBox47, Me.TextBox48, Me.TextBox49, Me.TextBox50, Me.TextBox51, Me.TextBox52, Me.TextBox53, Me.TextBox54, Me.TextBox55})
        Me.Detail.Height = 6.34375!
        Me.Detail.Name = "Detail"
        '
        'ReportHeader
        '
        Me.ReportHeader.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.Picture, Me.TextBox, Me.TextBox1, Me.TextBox2, Me.TextBox3, Me.TextBox4, Me.TextBox5, Me.TextBox6, Me.TextBox56})
        Me.ReportHeader.Height = 3.332639!
        Me.ReportHeader.Name = "ReportHeader"
        '
        'ReportFooter
        '
        Me.ReportFooter.Controls.AddRange(New GrapeCity.ActiveReports.SectionReportModel.ARControl() {Me.TextBox35, Me.TextBox36, Me.TextBox37})
        Me.ReportFooter.Height = 0.6041667!
        Me.ReportFooter.Name = "ReportFooter"
        '
        'Picture
        '
        Me.Picture.Height = 0.875!
        Me.Picture.ImageData = Nothing
        Me.Picture.Left = 0.0625!
        Me.Picture.LineColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.Picture.Name = "Picture"
        Me.Picture.SizeMode = GrapeCity.ActiveReports.SectionReportModel.SizeModes.Zoom
        Me.Picture.Top = 0!
        Me.Picture.Width = 3.1875!
        '
        'TextBox
        '
        Me.TextBox.Height = 0.25!
        Me.TextBox.Left = 0.125!
        Me.TextBox.Name = "TextBox"
        Me.TextBox.Style = "font-size: 14.25pt; font-weight: bold; text-align: center"
        Me.TextBox.Text = "Information Sheet"
        Me.TextBox.Top = 1.1875!
        Me.TextBox.Width = 7.25!
        '
        'TextBox1
        '
        Me.TextBox1.Height = 0.5!
        Me.TextBox1.Left = 1.1875!
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Style = "font-size: 14.25pt; font-weight: bold; text-align: center"
        Me.TextBox1.Text = "***RETURN TODAY WITH YOUR CREDITOR STATEMENTS AND SATISFACTION SURVEY***"
        Me.TextBox1.Top = 1.5!
        Me.TextBox1.Width = 5!
        '
        'TextBox2
        '
        Me.TextBox2.Height = 0.1875!
        Me.TextBox2.Left = 0!
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Text = "It is very important that you return:"
        Me.TextBox2.Top = 2.125!
        Me.TextBox2.Width = 7.1875!
        '
        'TextBox3
        '
        Me.TextBox3.Height = 0.1875!
        Me.TextBox3.Left = 0.125!
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Style = "font-size: 9.75pt; font-weight: bold"
        Me.TextBox3.Text = "1.   This verified and completed Information Sheet"
        Me.TextBox3.Top = 2.375!
        Me.TextBox3.Width = 7.0625!
        '
        'TextBox4
        '
        Me.TextBox4.Height = 0.1875!
        Me.TextBox4.Left = 0.125!
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.Style = "font-size: 9.75pt; font-weight: bold"
        Me.TextBox4.Text = "2.   A copy of a statement for each of your creditors.  "
        Me.TextBox4.Top = 2.5625!
        Me.TextBox4.Width = 7.0625!
        '
        'TextBox5
        '
        Me.TextBox5.Height = 0.1875!
        Me.TextBox5.Left = 0.125!
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.Style = "font-size: 9.75pt; font-weight: bold"
        Me.TextBox5.Text = "3.   Our Firms Client satisfactory survey."
        Me.TextBox5.Top = 3.125!
        Me.TextBox5.Width = 3.4375!
        '
        'TextBox6
        '
        Me.TextBox6.Height = 0.375!
        Me.TextBox6.Left = 0.375!
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.Text = "(If you do not have a statement for one of your credit card accounts, please prov" & _
            "ide the Name, Account number, Client Services Address and Phone Number on a sepa" & _
            "rate sheet of paper.)"
        Me.TextBox6.Top = 2.75!
        Me.TextBox6.Width = 6.8125!
        '
        'TextBox56
        '
        Me.TextBox56.Height = 0.1875!
        Me.TextBox56.Left = 4.5!
        Me.TextBox56.Name = "TextBox56"
        Me.TextBox56.Style = "font-size: 9.75pt; font-weight: bold"
        Me.TextBox56.Text = "Provide/Change to"
        Me.TextBox56.Top = 3.125!
        Me.TextBox56.Width = 2.9375!
        '
        'TextBox7
        '
        Me.TextBox7.CanGrow = false
        Me.TextBox7.Height = 0.18!
        Me.TextBox7.Left = 0.0625!
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.Text = "Primary Applicant Name:"
        Me.TextBox7.Top = 0.0625!
        Me.TextBox7.Width = 2!
        '
        'TextBox8
        '
        Me.TextBox8.CanGrow = false
        Me.TextBox8.Height = 0.18!
        Me.TextBox8.Left = 0.0625!
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.Text = "Address Street:"
        Me.TextBox8.Top = 0.25!
        Me.TextBox8.Width = 2!
        '
        'TextBox9
        '
        Me.TextBox9.CanGrow = false
        Me.TextBox9.Height = 0.18!
        Me.TextBox9.Left = 0.0625!
        Me.TextBox9.Name = "TextBox9"
        Me.TextBox9.Text = "Address 2:"
        Me.TextBox9.Top = 0.4375!
        Me.TextBox9.Width = 2!
        '
        'TextBox10
        '
        Me.TextBox10.CanGrow = false
        Me.TextBox10.Height = 0.18!
        Me.TextBox10.Left = 0.0625!
        Me.TextBox10.Name = "TextBox10"
        Me.TextBox10.Text = "Address City:"
        Me.TextBox10.Top = 0.625!
        Me.TextBox10.Width = 2!
        '
        'TextBox11
        '
        Me.TextBox11.CanGrow = false
        Me.TextBox11.Height = 0.18!
        Me.TextBox11.Left = 0.0625!
        Me.TextBox11.Name = "TextBox11"
        Me.TextBox11.Text = "State:"
        Me.TextBox11.Top = 0.8125!
        Me.TextBox11.Width = 2!
        '
        'TextBox12
        '
        Me.TextBox12.CanGrow = false
        Me.TextBox12.Height = 0.18!
        Me.TextBox12.Left = 0.0625!
        Me.TextBox12.Name = "TextBox12"
        Me.TextBox12.Text = "Zip Code:"
        Me.TextBox12.Top = 1!
        Me.TextBox12.Width = 2!
        '
        'TextBox13
        '
        Me.TextBox13.CanGrow = false
        Me.TextBox13.Height = 0.18!
        Me.TextBox13.Left = 0.0625!
        Me.TextBox13.Name = "TextBox13"
        Me.TextBox13.Text = "Date of Birth:"
        Me.TextBox13.Top = 1.1875!
        Me.TextBox13.Width = 2!
        '
        'TextBox14
        '
        Me.TextBox14.CanGrow = false
        Me.TextBox14.Height = 0.18!
        Me.TextBox14.Left = 0.0625!
        Me.TextBox14.Name = "TextBox14"
        Me.TextBox14.Text = "Social Security Number:"
        Me.TextBox14.Top = 1.375!
        Me.TextBox14.Width = 2!
        '
        'TextBox15
        '
        Me.TextBox15.CanGrow = false
        Me.TextBox15.Height = 0.18!
        Me.TextBox15.Left = 0.0625!
        Me.TextBox15.Name = "TextBox15"
        Me.TextBox15.Text = "Home Phone:"
        Me.TextBox15.Top = 1.5625!
        Me.TextBox15.Width = 2!
        '
        'TextBox16
        '
        Me.TextBox16.CanGrow = false
        Me.TextBox16.Height = 0.18!
        Me.TextBox16.Left = 0.0625!
        Me.TextBox16.Name = "TextBox16"
        Me.TextBox16.Text = "Home Fax:"
        Me.TextBox16.Top = 1.75!
        Me.TextBox16.Width = 2!
        '
        'TextBox17
        '
        Me.TextBox17.CanGrow = false
        Me.TextBox17.Height = 0.18!
        Me.TextBox17.Left = 0.0625!
        Me.TextBox17.Name = "TextBox17"
        Me.TextBox17.Text = "Business Phone:"
        Me.TextBox17.Top = 1.9375!
        Me.TextBox17.Width = 2!
        '
        'TextBox18
        '
        Me.TextBox18.CanGrow = false
        Me.TextBox18.Height = 0.18!
        Me.TextBox18.Left = 0.0625!
        Me.TextBox18.Name = "TextBox18"
        Me.TextBox18.Text = "Business Fax:"
        Me.TextBox18.Top = 2.125!
        Me.TextBox18.Width = 2!
        '
        'TextBox19
        '
        Me.TextBox19.CanGrow = false
        Me.TextBox19.Height = 0.18!
        Me.TextBox19.Left = 0.0625!
        Me.TextBox19.Name = "TextBox19"
        Me.TextBox19.Text = "Cell Phone:"
        Me.TextBox19.Top = 2.3125!
        Me.TextBox19.Width = 2!
        '
        'TextBox20
        '
        Me.TextBox20.CanGrow = false
        Me.TextBox20.Height = 0.18!
        Me.TextBox20.Left = 0.0625!
        Me.TextBox20.Name = "TextBox20"
        Me.TextBox20.Text = "Email Address:"
        Me.TextBox20.Top = 2.5!
        Me.TextBox20.Width = 2!
        '
        'txtName1
        '
        Me.txtName1.CanGrow = false
        Me.txtName1.DataField = "Name1"
        Me.txtName1.Height = 0.18!
        Me.txtName1.Left = 2.25!
        Me.txtName1.Name = "txtName1"
        Me.txtName1.Text = "Primary Applicant Name:"
        Me.txtName1.Top = 0.0625!
        Me.txtName1.Width = 2!
        '
        'txtStreet1
        '
        Me.txtStreet1.CanGrow = false
        Me.txtStreet1.DataField = "Street1"
        Me.txtStreet1.Height = 0.18!
        Me.txtStreet1.Left = 2.25!
        Me.txtStreet1.Name = "txtStreet1"
        Me.txtStreet1.Text = "Address Street:"
        Me.txtStreet1.Top = 0.25!
        Me.txtStreet1.Width = 2!
        '
        'txtStreet1b
        '
        Me.txtStreet1b.CanGrow = false
        Me.txtStreet1b.DataField = "Street1b"
        Me.txtStreet1b.Height = 0.18!
        Me.txtStreet1b.Left = 2.25!
        Me.txtStreet1b.Name = "txtStreet1b"
        Me.txtStreet1b.Text = "Address 2:"
        Me.txtStreet1b.Top = 0.4375!
        Me.txtStreet1b.Width = 2!
        '
        'txtCity1
        '
        Me.txtCity1.CanGrow = false
        Me.txtCity1.DataField = "City1"
        Me.txtCity1.Height = 0.18!
        Me.txtCity1.Left = 2.25!
        Me.txtCity1.Name = "txtCity1"
        Me.txtCity1.Text = "Address City:"
        Me.txtCity1.Top = 0.625!
        Me.txtCity1.Width = 2!
        '
        'txtState1
        '
        Me.txtState1.CanGrow = false
        Me.txtState1.DataField = "State1"
        Me.txtState1.Height = 0.18!
        Me.txtState1.Left = 2.25!
        Me.txtState1.Name = "txtState1"
        Me.txtState1.Text = "State:"
        Me.txtState1.Top = 0.8125!
        Me.txtState1.Width = 2!
        '
        'txtZip1
        '
        Me.txtZip1.CanGrow = false
        Me.txtZip1.DataField = "Zip1"
        Me.txtZip1.Height = 0.18!
        Me.txtZip1.Left = 2.25!
        Me.txtZip1.Name = "txtZip1"
        Me.txtZip1.Text = "Zip Code:"
        Me.txtZip1.Top = 1!
        Me.txtZip1.Width = 2!
        '
        'txtDob1
        '
        Me.txtDob1.CanGrow = false
        Me.txtDob1.DataField = "Dob1"
        Me.txtDob1.Height = 0.18!
        Me.txtDob1.Left = 2.25!
        Me.txtDob1.Name = "txtDob1"
        Me.txtDob1.OutputFormat = resources.GetString("txtDob1.OutputFormat")
        Me.txtDob1.Text = "Date of Birth:"
        Me.txtDob1.Top = 1.1875!
        Me.txtDob1.Width = 2!
        '
        'txtSsn1
        '
        Me.txtSsn1.CanGrow = false
        Me.txtSsn1.DataField = "Ssn1"
        Me.txtSsn1.Height = 0.18!
        Me.txtSsn1.Left = 2.25!
        Me.txtSsn1.Name = "txtSsn1"
        Me.txtSsn1.OutputFormat = resources.GetString("txtSsn1.OutputFormat")
        Me.txtSsn1.Text = "Social Security Number:"
        Me.txtSsn1.Top = 1.375!
        Me.txtSsn1.Width = 2!
        '
        'txtHomePhone1
        '
        Me.txtHomePhone1.CanGrow = false
        Me.txtHomePhone1.DataField = "HomePhone1"
        Me.txtHomePhone1.Height = 0.18!
        Me.txtHomePhone1.Left = 2.25!
        Me.txtHomePhone1.Name = "txtHomePhone1"
        Me.txtHomePhone1.Text = "Home Phone:"
        Me.txtHomePhone1.Top = 1.5625!
        Me.txtHomePhone1.Width = 2!
        '
        'txtHomeFax1
        '
        Me.txtHomeFax1.CanGrow = false
        Me.txtHomeFax1.DataField = "HomeFax1"
        Me.txtHomeFax1.Height = 0.18!
        Me.txtHomeFax1.Left = 2.25!
        Me.txtHomeFax1.Name = "txtHomeFax1"
        Me.txtHomeFax1.Text = "Home Fax:"
        Me.txtHomeFax1.Top = 1.75!
        Me.txtHomeFax1.Width = 2!
        '
        'txtBusinessPhone1
        '
        Me.txtBusinessPhone1.CanGrow = false
        Me.txtBusinessPhone1.DataField = "BusinessPhone1"
        Me.txtBusinessPhone1.Height = 0.18!
        Me.txtBusinessPhone1.Left = 2.25!
        Me.txtBusinessPhone1.Name = "txtBusinessPhone1"
        Me.txtBusinessPhone1.Text = "Business Phone:"
        Me.txtBusinessPhone1.Top = 1.9375!
        Me.txtBusinessPhone1.Width = 2!
        '
        'txtBusinessFax1
        '
        Me.txtBusinessFax1.CanGrow = false
        Me.txtBusinessFax1.DataField = "BusinessFax1"
        Me.txtBusinessFax1.Height = 0.18!
        Me.txtBusinessFax1.Left = 2.25!
        Me.txtBusinessFax1.Name = "txtBusinessFax1"
        Me.txtBusinessFax1.Text = "Business Fax:"
        Me.txtBusinessFax1.Top = 2.125!
        Me.txtBusinessFax1.Width = 2!
        '
        'txtCellPhone1
        '
        Me.txtCellPhone1.CanGrow = false
        Me.txtCellPhone1.DataField = "CellPhone1"
        Me.txtCellPhone1.Height = 0.18!
        Me.txtCellPhone1.Left = 2.25!
        Me.txtCellPhone1.Name = "txtCellPhone1"
        Me.txtCellPhone1.Text = "Cell Phone:"
        Me.txtCellPhone1.Top = 2.3125!
        Me.txtCellPhone1.Width = 2!
        '
        'txtEmail1
        '
        Me.txtEmail1.CanGrow = false
        Me.txtEmail1.DataField = "CellFax1"
        Me.txtEmail1.Height = 0.18!
        Me.txtEmail1.Left = 2.25!
        Me.txtEmail1.Name = "txtEmail1"
        Me.txtEmail1.Text = "Email Address:"
        Me.txtEmail1.Top = 2.5!
        Me.txtEmail1.Width = 2!
        '
        'txtName2
        '
        Me.txtName2.CanGrow = false
        Me.txtName2.DataField = "Name2"
        Me.txtName2.Height = 0.18!
        Me.txtName2.Left = 2.25!
        Me.txtName2.Name = "txtName2"
        Me.txtName2.Text = "Secondary Applicant Name:"
        Me.txtName2.Top = 2.8125!
        Me.txtName2.Width = 2!
        '
        'txtStreet2
        '
        Me.txtStreet2.CanGrow = false
        Me.txtStreet2.DataField = "Street2"
        Me.txtStreet2.Height = 0.18!
        Me.txtStreet2.Left = 2.25!
        Me.txtStreet2.Name = "txtStreet2"
        Me.txtStreet2.Text = "Address Street:"
        Me.txtStreet2.Top = 3!
        Me.txtStreet2.Width = 2!
        '
        'txtStreet2b
        '
        Me.txtStreet2b.CanGrow = false
        Me.txtStreet2b.DataField = "Street2b"
        Me.txtStreet2b.Height = 0.18!
        Me.txtStreet2b.Left = 2.25!
        Me.txtStreet2b.Name = "txtStreet2b"
        Me.txtStreet2b.Text = "Address 2:"
        Me.txtStreet2b.Top = 3.1875!
        Me.txtStreet2b.Width = 2!
        '
        'txtCity2
        '
        Me.txtCity2.CanGrow = false
        Me.txtCity2.DataField = "City2"
        Me.txtCity2.Height = 0.18!
        Me.txtCity2.Left = 2.25!
        Me.txtCity2.Name = "txtCity2"
        Me.txtCity2.Text = "Address City:"
        Me.txtCity2.Top = 3.375!
        Me.txtCity2.Width = 2!
        '
        'txtState2
        '
        Me.txtState2.CanGrow = false
        Me.txtState2.DataField = "State2"
        Me.txtState2.Height = 0.18!
        Me.txtState2.Left = 2.25!
        Me.txtState2.Name = "txtState2"
        Me.txtState2.Text = "State:"
        Me.txtState2.Top = 3.5625!
        Me.txtState2.Width = 2!
        '
        'txtZip2
        '
        Me.txtZip2.CanGrow = false
        Me.txtZip2.DataField = "Zip2"
        Me.txtZip2.Height = 0.18!
        Me.txtZip2.Left = 2.25!
        Me.txtZip2.Name = "txtZip2"
        Me.txtZip2.Text = "Zip Code:"
        Me.txtZip2.Top = 3.75!
        Me.txtZip2.Width = 2!
        '
        'txtDob2
        '
        Me.txtDob2.CanGrow = false
        Me.txtDob2.DataField = "Dob2"
        Me.txtDob2.Height = 0.18!
        Me.txtDob2.Left = 2.25!
        Me.txtDob2.Name = "txtDob2"
        Me.txtDob2.OutputFormat = resources.GetString("txtDob2.OutputFormat")
        Me.txtDob2.Text = "Date of Birth:"
        Me.txtDob2.Top = 3.9375!
        Me.txtDob2.Width = 2!
        '
        'txtSsn2
        '
        Me.txtSsn2.CanGrow = false
        Me.txtSsn2.DataField = "Ssn2"
        Me.txtSsn2.Height = 0.18!
        Me.txtSsn2.Left = 2.25!
        Me.txtSsn2.Name = "txtSsn2"
        Me.txtSsn2.OutputFormat = resources.GetString("txtSsn2.OutputFormat")
        Me.txtSsn2.Text = "Social Security Number:"
        Me.txtSsn2.Top = 4.125!
        Me.txtSsn2.Width = 2!
        '
        'txtHomePhone2
        '
        Me.txtHomePhone2.CanGrow = false
        Me.txtHomePhone2.DataField = "HomePhone2"
        Me.txtHomePhone2.Height = 0.18!
        Me.txtHomePhone2.Left = 2.25!
        Me.txtHomePhone2.Name = "txtHomePhone2"
        Me.txtHomePhone2.Text = "Home Phone:"
        Me.txtHomePhone2.Top = 4.3125!
        Me.txtHomePhone2.Width = 2!
        '
        'txtHomeFax2
        '
        Me.txtHomeFax2.CanGrow = false
        Me.txtHomeFax2.DataField = "HomeFax2"
        Me.txtHomeFax2.Height = 0.18!
        Me.txtHomeFax2.Left = 2.25!
        Me.txtHomeFax2.Name = "txtHomeFax2"
        Me.txtHomeFax2.Text = "Home Fax:"
        Me.txtHomeFax2.Top = 4.5!
        Me.txtHomeFax2.Width = 2!
        '
        'txtBusinessPhone2
        '
        Me.txtBusinessPhone2.CanGrow = false
        Me.txtBusinessPhone2.DataField = "BusinessPhone2"
        Me.txtBusinessPhone2.Height = 0.18!
        Me.txtBusinessPhone2.Left = 2.25!
        Me.txtBusinessPhone2.Name = "txtBusinessPhone2"
        Me.txtBusinessPhone2.Text = "Business Phone:"
        Me.txtBusinessPhone2.Top = 4.6875!
        Me.txtBusinessPhone2.Width = 2!
        '
        'txtBusinessFax2
        '
        Me.txtBusinessFax2.CanGrow = false
        Me.txtBusinessFax2.DataField = "BusinessFax2"
        Me.txtBusinessFax2.Height = 0.18!
        Me.txtBusinessFax2.Left = 2.25!
        Me.txtBusinessFax2.Name = "txtBusinessFax2"
        Me.txtBusinessFax2.Text = "Business Fax:"
        Me.txtBusinessFax2.Top = 4.875!
        Me.txtBusinessFax2.Width = 2!
        '
        'txtCellPhone2
        '
        Me.txtCellPhone2.CanGrow = false
        Me.txtCellPhone2.DataField = "CellPhone2"
        Me.txtCellPhone2.Height = 0.18!
        Me.txtCellPhone2.Left = 2.25!
        Me.txtCellPhone2.Name = "txtCellPhone2"
        Me.txtCellPhone2.Text = "Cell Phone:"
        Me.txtCellPhone2.Top = 5.0625!
        Me.txtCellPhone2.Width = 2!
        '
        'txtEmail2
        '
        Me.txtEmail2.CanGrow = false
        Me.txtEmail2.DataField = "Email2"
        Me.txtEmail2.Height = 0.18!
        Me.txtEmail2.Left = 2.25!
        Me.txtEmail2.Name = "txtEmail2"
        Me.txtEmail2.Text = "Email Address:"
        Me.txtEmail2.Top = 5.25!
        Me.txtEmail2.Width = 2!
        '
        'TextBox63
        '
        Me.TextBox63.CanGrow = false
        Me.TextBox63.Height = 0.1875!
        Me.TextBox63.Left = 4.5!
        Me.TextBox63.Name = "TextBox63"
        Me.TextBox63.Style = "white-space: nowrap"
        Me.TextBox63.Text = "____________________________________________"
        Me.TextBox63.Top = 0.0625!
        Me.TextBox63.Width = 2.9375!
        '
        'TextBox64
        '
        Me.TextBox64.CanGrow = false
        Me.TextBox64.Height = 0.1875!
        Me.TextBox64.Left = 4.5!
        Me.TextBox64.Name = "TextBox64"
        Me.TextBox64.Style = "white-space: nowrap"
        Me.TextBox64.Text = "____________________________________________"
        Me.TextBox64.Top = 0.25!
        Me.TextBox64.Width = 2.9375!
        '
        'TextBox65
        '
        Me.TextBox65.CanGrow = false
        Me.TextBox65.Height = 0.1875!
        Me.TextBox65.Left = 4.5!
        Me.TextBox65.Name = "TextBox65"
        Me.TextBox65.Style = "white-space: nowrap"
        Me.TextBox65.Text = "____________________________________________"
        Me.TextBox65.Top = 0.4375!
        Me.TextBox65.Width = 2.9375!
        '
        'TextBox66
        '
        Me.TextBox66.CanGrow = false
        Me.TextBox66.Height = 0.1875!
        Me.TextBox66.Left = 4.5!
        Me.TextBox66.Name = "TextBox66"
        Me.TextBox66.Style = "white-space: nowrap"
        Me.TextBox66.Text = "____________________________________________"
        Me.TextBox66.Top = 0.625!
        Me.TextBox66.Width = 2.9375!
        '
        'TextBox67
        '
        Me.TextBox67.CanGrow = false
        Me.TextBox67.Height = 0.1875!
        Me.TextBox67.Left = 4.5!
        Me.TextBox67.Name = "TextBox67"
        Me.TextBox67.Style = "white-space: nowrap"
        Me.TextBox67.Text = "____________________________________________"
        Me.TextBox67.Top = 0.8125!
        Me.TextBox67.Width = 2.9375!
        '
        'TextBox68
        '
        Me.TextBox68.CanGrow = false
        Me.TextBox68.Height = 0.1875!
        Me.TextBox68.Left = 4.5!
        Me.TextBox68.Name = "TextBox68"
        Me.TextBox68.Style = "white-space: nowrap"
        Me.TextBox68.Text = "____________________________________________"
        Me.TextBox68.Top = 1!
        Me.TextBox68.Width = 2.9375!
        '
        'TextBox69
        '
        Me.TextBox69.CanGrow = false
        Me.TextBox69.Height = 0.1875!
        Me.TextBox69.Left = 4.5!
        Me.TextBox69.Name = "TextBox69"
        Me.TextBox69.Style = "white-space: nowrap"
        Me.TextBox69.Text = "____________________________________________"
        Me.TextBox69.Top = 1.1875!
        Me.TextBox69.Width = 2.9375!
        '
        'TextBox70
        '
        Me.TextBox70.CanGrow = false
        Me.TextBox70.Height = 0.1875!
        Me.TextBox70.Left = 4.5!
        Me.TextBox70.Name = "TextBox70"
        Me.TextBox70.Style = "white-space: nowrap"
        Me.TextBox70.Text = "____________________________________________"
        Me.TextBox70.Top = 1.375!
        Me.TextBox70.Width = 2.9375!
        '
        'TextBox71
        '
        Me.TextBox71.CanGrow = false
        Me.TextBox71.Height = 0.1875!
        Me.TextBox71.Left = 4.5!
        Me.TextBox71.Name = "TextBox71"
        Me.TextBox71.Style = "white-space: nowrap"
        Me.TextBox71.Text = "____________________________________________"
        Me.TextBox71.Top = 1.5625!
        Me.TextBox71.Width = 2.9375!
        '
        'TextBox72
        '
        Me.TextBox72.CanGrow = false
        Me.TextBox72.Height = 0.1875!
        Me.TextBox72.Left = 4.5!
        Me.TextBox72.Name = "TextBox72"
        Me.TextBox72.Style = "white-space: nowrap"
        Me.TextBox72.Text = "____________________________________________"
        Me.TextBox72.Top = 1.75!
        Me.TextBox72.Width = 2.9375!
        '
        'TextBox73
        '
        Me.TextBox73.CanGrow = false
        Me.TextBox73.Height = 0.1875!
        Me.TextBox73.Left = 4.5!
        Me.TextBox73.Name = "TextBox73"
        Me.TextBox73.Style = "white-space: nowrap"
        Me.TextBox73.Text = "____________________________________________"
        Me.TextBox73.Top = 1.9375!
        Me.TextBox73.Width = 2.9375!
        '
        'TextBox74
        '
        Me.TextBox74.CanGrow = false
        Me.TextBox74.Height = 0.1875!
        Me.TextBox74.Left = 4.5!
        Me.TextBox74.Name = "TextBox74"
        Me.TextBox74.Style = "white-space: nowrap"
        Me.TextBox74.Text = "____________________________________________"
        Me.TextBox74.Top = 2.125!
        Me.TextBox74.Width = 2.9375!
        '
        'TextBox75
        '
        Me.TextBox75.CanGrow = false
        Me.TextBox75.Height = 0.1875!
        Me.TextBox75.Left = 4.5!
        Me.TextBox75.Name = "TextBox75"
        Me.TextBox75.Style = "white-space: nowrap"
        Me.TextBox75.Text = "____________________________________________"
        Me.TextBox75.Top = 2.3125!
        Me.TextBox75.Width = 2.9375!
        '
        'TextBox76
        '
        Me.TextBox76.CanGrow = false
        Me.TextBox76.Height = 0.1875!
        Me.TextBox76.Left = 4.5!
        Me.TextBox76.Name = "TextBox76"
        Me.TextBox76.Style = "white-space: nowrap"
        Me.TextBox76.Text = "____________________________________________"
        Me.TextBox76.Top = 2.5!
        Me.TextBox76.Width = 2.9375!
        '
        'TextBox38
        '
        Me.TextBox38.CanGrow = false
        Me.TextBox38.Height = 0.18!
        Me.TextBox38.Left = 0.0625!
        Me.TextBox38.Name = "TextBox38"
        Me.TextBox38.Text = "Preferred Language:"
        Me.TextBox38.Top = 5.5625!
        Me.TextBox38.Width = 2.75!
        '
        'TextBox39
        '
        Me.TextBox39.CanGrow = false
        Me.TextBox39.Height = 0.18!
        Me.TextBox39.Left = 0.0625!
        Me.TextBox39.Name = "TextBox39"
        Me.TextBox39.Text = "Your Monthly Deposit Commitment Amount:"
        Me.TextBox39.Top = 5.75!
        Me.TextBox39.Width = 2.75!
        '
        'TextBox40
        '
        Me.TextBox40.CanGrow = false
        Me.TextBox40.Height = 0.18!
        Me.TextBox40.Left = 0.0625!
        Me.TextBox40.Name = "TextBox40"
        Me.TextBox40.Text = "Monthly Deposit Commitment Due Date:"
        Me.TextBox40.Top = 5.9375!
        Me.TextBox40.Width = 2.75!
        '
        'TextBox41
        '
        Me.TextBox41.CanGrow = false
        Me.TextBox41.Height = 0.18!
        Me.TextBox41.Left = 0.0625!
        Me.TextBox41.Name = "TextBox41"
        Me.TextBox41.Text = "Method of Deposit:"
        Me.TextBox41.Top = 6.125!
        Me.TextBox41.Width = 2.75!
        '
        'txtLanguage
        '
        Me.txtLanguage.CanGrow = false
        Me.txtLanguage.DataField = "Lang"
        Me.txtLanguage.Height = 0.18!
        Me.txtLanguage.Left = 2.875!
        Me.txtLanguage.Name = "txtLanguage"
        Me.txtLanguage.Text = "txtLanguage"
        Me.txtLanguage.Top = 5.5625!
        Me.txtLanguage.Width = 2!
        '
        'txtMonthlyPayment
        '
        Me.txtMonthlyPayment.CanGrow = false
        Me.txtMonthlyPayment.DataField = "DepositAmount"
        Me.txtMonthlyPayment.Height = 0.18!
        Me.txtMonthlyPayment.Left = 2.875!
        Me.txtMonthlyPayment.Name = "txtMonthlyPayment"
        Me.txtMonthlyPayment.OutputFormat = resources.GetString("txtMonthlyPayment.OutputFormat")
        Me.txtMonthlyPayment.Text = "txtMonthlyPayment"
        Me.txtMonthlyPayment.Top = 5.75!
        Me.txtMonthlyPayment.Width = 2!
        '
        'txtMonthlyDeposit
        '
        Me.txtMonthlyDeposit.CanGrow = false
        Me.txtMonthlyDeposit.DataField = "DepositDay"
        Me.txtMonthlyDeposit.Height = 0.18!
        Me.txtMonthlyDeposit.Left = 2.875!
        Me.txtMonthlyDeposit.Name = "txtMonthlyDeposit"
        Me.txtMonthlyDeposit.Text = "txtMonthlyDeposit"
        Me.txtMonthlyDeposit.Top = 5.9375!
        Me.txtMonthlyDeposit.Width = 2!
        '
        'txtDepositMethod
        '
        Me.txtDepositMethod.CanGrow = false
        Me.txtDepositMethod.DataField = "DepositMethod"
        Me.txtDepositMethod.Height = 0.18!
        Me.txtDepositMethod.Left = 2.875!
        Me.txtDepositMethod.Name = "txtDepositMethod"
        Me.txtDepositMethod.Text = "txtDepositMethod"
        Me.txtDepositMethod.Top = 6.125!
        Me.txtDepositMethod.Width = 2!
        '
        'TextBox21
        '
        Me.TextBox21.CanGrow = false
        Me.TextBox21.Height = 0.18!
        Me.TextBox21.Left = 0.0625!
        Me.TextBox21.Name = "TextBox21"
        Me.TextBox21.Text = "Secondary Applicant Name:"
        Me.TextBox21.Top = 2.8125!
        Me.TextBox21.Width = 2!
        '
        'TextBox22
        '
        Me.TextBox22.CanGrow = false
        Me.TextBox22.Height = 0.18!
        Me.TextBox22.Left = 0.0625!
        Me.TextBox22.Name = "TextBox22"
        Me.TextBox22.Text = "Address Street:"
        Me.TextBox22.Top = 3!
        Me.TextBox22.Width = 2!
        '
        'TextBox23
        '
        Me.TextBox23.CanGrow = false
        Me.TextBox23.Height = 0.18!
        Me.TextBox23.Left = 0.0625!
        Me.TextBox23.Name = "TextBox23"
        Me.TextBox23.Text = "Address 2:"
        Me.TextBox23.Top = 3.1875!
        Me.TextBox23.Width = 2!
        '
        'TextBox24
        '
        Me.TextBox24.CanGrow = false
        Me.TextBox24.Height = 0.18!
        Me.TextBox24.Left = 0.0625!
        Me.TextBox24.Name = "TextBox24"
        Me.TextBox24.Text = "Address City:"
        Me.TextBox24.Top = 3.375!
        Me.TextBox24.Width = 2!
        '
        'TextBox25
        '
        Me.TextBox25.CanGrow = false
        Me.TextBox25.Height = 0.18!
        Me.TextBox25.Left = 0.0625!
        Me.TextBox25.Name = "TextBox25"
        Me.TextBox25.Text = "State:"
        Me.TextBox25.Top = 3.5625!
        Me.TextBox25.Width = 2!
        '
        'TextBox26
        '
        Me.TextBox26.CanGrow = false
        Me.TextBox26.Height = 0.18!
        Me.TextBox26.Left = 0.0625!
        Me.TextBox26.Name = "TextBox26"
        Me.TextBox26.Text = "Zip Code:"
        Me.TextBox26.Top = 3.75!
        Me.TextBox26.Width = 2!
        '
        'TextBox27
        '
        Me.TextBox27.CanGrow = false
        Me.TextBox27.Height = 0.18!
        Me.TextBox27.Left = 0.0625!
        Me.TextBox27.Name = "TextBox27"
        Me.TextBox27.Text = "Date of Birth:"
        Me.TextBox27.Top = 3.9375!
        Me.TextBox27.Width = 2!
        '
        'TextBox28
        '
        Me.TextBox28.CanGrow = false
        Me.TextBox28.Height = 0.18!
        Me.TextBox28.Left = 0.0625!
        Me.TextBox28.Name = "TextBox28"
        Me.TextBox28.Text = "Social Security Number:"
        Me.TextBox28.Top = 4.125!
        Me.TextBox28.Width = 2!
        '
        'TextBox29
        '
        Me.TextBox29.CanGrow = false
        Me.TextBox29.Height = 0.18!
        Me.TextBox29.Left = 0.0625!
        Me.TextBox29.Name = "TextBox29"
        Me.TextBox29.Text = "Home Phone:"
        Me.TextBox29.Top = 4.3125!
        Me.TextBox29.Width = 2!
        '
        'TextBox30
        '
        Me.TextBox30.CanGrow = false
        Me.TextBox30.Height = 0.18!
        Me.TextBox30.Left = 0.0625!
        Me.TextBox30.Name = "TextBox30"
        Me.TextBox30.Text = "Home Fax:"
        Me.TextBox30.Top = 4.5!
        Me.TextBox30.Width = 2!
        '
        'TextBox31
        '
        Me.TextBox31.CanGrow = false
        Me.TextBox31.Height = 0.18!
        Me.TextBox31.Left = 0.0625!
        Me.TextBox31.Name = "TextBox31"
        Me.TextBox31.Text = "Business Phone:"
        Me.TextBox31.Top = 4.6875!
        Me.TextBox31.Width = 2!
        '
        'TextBox32
        '
        Me.TextBox32.CanGrow = false
        Me.TextBox32.Height = 0.18!
        Me.TextBox32.Left = 0.0625!
        Me.TextBox32.Name = "TextBox32"
        Me.TextBox32.Text = "Business Fax:"
        Me.TextBox32.Top = 4.875!
        Me.TextBox32.Width = 2!
        '
        'TextBox33
        '
        Me.TextBox33.CanGrow = false
        Me.TextBox33.Height = 0.18!
        Me.TextBox33.Left = 0.0625!
        Me.TextBox33.Name = "TextBox33"
        Me.TextBox33.Text = "Cell Phone:"
        Me.TextBox33.Top = 5.0625!
        Me.TextBox33.Width = 2!
        '
        'TextBox34
        '
        Me.TextBox34.CanGrow = false
        Me.TextBox34.Height = 0.18!
        Me.TextBox34.Left = 0.0625!
        Me.TextBox34.Name = "TextBox34"
        Me.TextBox34.Text = "Email Address:"
        Me.TextBox34.Top = 5.25!
        Me.TextBox34.Width = 2!
        '
        'TextBox42
        '
        Me.TextBox42.CanGrow = false
        Me.TextBox42.Height = 0.1875!
        Me.TextBox42.Left = 4.5!
        Me.TextBox42.Name = "TextBox42"
        Me.TextBox42.Style = "white-space: nowrap"
        Me.TextBox42.Text = "____________________________________________"
        Me.TextBox42.Top = 2.8125!
        Me.TextBox42.Width = 2.9375!
        '
        'TextBox43
        '
        Me.TextBox43.CanGrow = false
        Me.TextBox43.Height = 0.1875!
        Me.TextBox43.Left = 4.5!
        Me.TextBox43.Name = "TextBox43"
        Me.TextBox43.Style = "white-space: nowrap"
        Me.TextBox43.Text = "____________________________________________"
        Me.TextBox43.Top = 3!
        Me.TextBox43.Width = 2.9375!
        '
        'TextBox44
        '
        Me.TextBox44.CanGrow = false
        Me.TextBox44.Height = 0.1875!
        Me.TextBox44.Left = 4.5!
        Me.TextBox44.Name = "TextBox44"
        Me.TextBox44.Style = "white-space: nowrap"
        Me.TextBox44.Text = "____________________________________________"
        Me.TextBox44.Top = 3.1875!
        Me.TextBox44.Width = 2.9375!
        '
        'TextBox45
        '
        Me.TextBox45.CanGrow = false
        Me.TextBox45.Height = 0.1875!
        Me.TextBox45.Left = 4.5!
        Me.TextBox45.Name = "TextBox45"
        Me.TextBox45.Style = "white-space: nowrap"
        Me.TextBox45.Text = "____________________________________________"
        Me.TextBox45.Top = 3.375!
        Me.TextBox45.Width = 2.9375!
        '
        'TextBox46
        '
        Me.TextBox46.CanGrow = false
        Me.TextBox46.Height = 0.1875!
        Me.TextBox46.Left = 4.5!
        Me.TextBox46.Name = "TextBox46"
        Me.TextBox46.Style = "white-space: nowrap"
        Me.TextBox46.Text = "____________________________________________"
        Me.TextBox46.Top = 3.5625!
        Me.TextBox46.Width = 2.9375!
        '
        'TextBox47
        '
        Me.TextBox47.CanGrow = false
        Me.TextBox47.Height = 0.1875!
        Me.TextBox47.Left = 4.5!
        Me.TextBox47.Name = "TextBox47"
        Me.TextBox47.Style = "white-space: nowrap"
        Me.TextBox47.Text = "____________________________________________"
        Me.TextBox47.Top = 3.75!
        Me.TextBox47.Width = 2.9375!
        '
        'TextBox48
        '
        Me.TextBox48.CanGrow = false
        Me.TextBox48.Height = 0.1875!
        Me.TextBox48.Left = 4.5!
        Me.TextBox48.Name = "TextBox48"
        Me.TextBox48.Style = "white-space: nowrap"
        Me.TextBox48.Text = "____________________________________________"
        Me.TextBox48.Top = 3.9375!
        Me.TextBox48.Width = 2.9375!
        '
        'TextBox49
        '
        Me.TextBox49.CanGrow = false
        Me.TextBox49.Height = 0.1875!
        Me.TextBox49.Left = 4.5!
        Me.TextBox49.Name = "TextBox49"
        Me.TextBox49.Style = "white-space: nowrap"
        Me.TextBox49.Text = "____________________________________________"
        Me.TextBox49.Top = 4.125!
        Me.TextBox49.Width = 2.9375!
        '
        'TextBox50
        '
        Me.TextBox50.CanGrow = false
        Me.TextBox50.Height = 0.1875!
        Me.TextBox50.Left = 4.5!
        Me.TextBox50.Name = "TextBox50"
        Me.TextBox50.Style = "white-space: nowrap"
        Me.TextBox50.Text = "____________________________________________"
        Me.TextBox50.Top = 4.3125!
        Me.TextBox50.Width = 2.9375!
        '
        'TextBox51
        '
        Me.TextBox51.CanGrow = false
        Me.TextBox51.Height = 0.1875!
        Me.TextBox51.Left = 4.5!
        Me.TextBox51.Name = "TextBox51"
        Me.TextBox51.Style = "white-space: nowrap"
        Me.TextBox51.Text = "____________________________________________"
        Me.TextBox51.Top = 4.5!
        Me.TextBox51.Width = 2.9375!
        '
        'TextBox52
        '
        Me.TextBox52.CanGrow = false
        Me.TextBox52.Height = 0.1875!
        Me.TextBox52.Left = 4.5!
        Me.TextBox52.Name = "TextBox52"
        Me.TextBox52.Style = "white-space: nowrap"
        Me.TextBox52.Text = "____________________________________________"
        Me.TextBox52.Top = 4.6875!
        Me.TextBox52.Width = 2.9375!
        '
        'TextBox53
        '
        Me.TextBox53.CanGrow = false
        Me.TextBox53.Height = 0.1875!
        Me.TextBox53.Left = 4.5!
        Me.TextBox53.Name = "TextBox53"
        Me.TextBox53.Style = "white-space: nowrap"
        Me.TextBox53.Text = "____________________________________________"
        Me.TextBox53.Top = 4.875!
        Me.TextBox53.Width = 2.9375!
        '
        'TextBox54
        '
        Me.TextBox54.CanGrow = false
        Me.TextBox54.Height = 0.1875!
        Me.TextBox54.Left = 4.5!
        Me.TextBox54.Name = "TextBox54"
        Me.TextBox54.Style = "white-space: nowrap"
        Me.TextBox54.Text = "____________________________________________"
        Me.TextBox54.Top = 5.0625!
        Me.TextBox54.Width = 2.9375!
        '
        'TextBox55
        '
        Me.TextBox55.CanGrow = false
        Me.TextBox55.Height = 0.1875!
        Me.TextBox55.Left = 4.5!
        Me.TextBox55.Name = "TextBox55"
        Me.TextBox55.Style = "white-space: nowrap"
        Me.TextBox55.Text = "____________________________________________"
        Me.TextBox55.Top = 5.25!
        Me.TextBox55.Width = 2.9375!
        '
        'TextBox35
        '
        Me.TextBox35.Height = 0.2!
        Me.TextBox35.Left = 0!
        Me.TextBox35.Name = "TextBox35"
        Me.TextBox35.Style = "font-size: 12pt; font-weight: bold"
        Me.TextBox35.Text = "Please return to:  "
        Me.TextBox35.Top = 0.125!
        Me.TextBox35.Width = 2.75!
        '
        'TextBox36
        '
        Me.TextBox36.Height = 0.2!
        Me.TextBox36.Left = 1.375!
        Me.TextBox36.Name = "TextBox36"
        Me.TextBox36.Style = "font-size: 12pt"
        Me.TextBox36.Text = "Fax:  909-581-7501 or Mail:  P.O.Box 1800 Rancho Cucamonga, Ca. 91729-1800"
        Me.TextBox36.Top = 0.125!
        Me.TextBox36.Width = 6.125!
        '
        'TextBox37
        '
        Me.TextBox37.Height = 0.2!
        Me.TextBox37.Left = 0!
        Me.TextBox37.Name = "TextBox37"
        Me.TextBox37.Style = "font-size: 12pt; font-weight: bold; text-align: center"
        Me.TextBox37.Text = "Questions?  Please call our Client Services Dept. at 1-800-914-4832"
        Me.TextBox37.Top = 0.4!
        Me.TextBox37.Width = 7.375!
        '
        'SectionReport1
        '
        Me.MasterReport = false
        Me.PageSettings.PaperHeight = 11!
        Me.PageSettings.PaperWidth = 8.5!
        Me.PrintWidth = 7.5!
        Me.Sections.Add(Me.ReportHeader)
        Me.Sections.Add(Me.Detail)
        Me.Sections.Add(Me.ReportFooter)
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule(resources.GetString("$this.StyleSheet"), "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 16pt; font-size-adjust: inherit; font-stretch: inherit", "Heading1", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: Times New Roman; font-style: italic; font-variant: inherit; font-wei" & _
                    "ght: bold; font-size: 14pt; font-size-adjust: inherit; font-stretch: inherit", "Heading2", "Normal"))
        Me.StyleSheet.Add(New DDCssLib.StyleSheetRule("font-family: inherit; font-style: inherit; font-variant: inherit; font-weight: bo" & _
                    "ld; font-size: 13pt; font-size-adjust: inherit; font-stretch: inherit", "Heading3", "Normal"))
        CType(Me.Picture, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox3, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox4, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox5, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox6, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox56, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox7, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox8, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox9, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox10, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox11, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox12, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox13, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox14, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox15, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox16, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox17, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox18, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox19, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox20, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtName1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtStreet1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtStreet1b, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtCity1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtState1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtZip1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtDob1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtSsn1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtHomePhone1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtHomeFax1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtBusinessPhone1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtBusinessFax1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtCellPhone1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtEmail1, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtName2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtStreet2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtStreet2b, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtCity2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtState2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtZip2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtDob2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtSsn2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtHomePhone2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtHomeFax2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtBusinessPhone2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtBusinessFax2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtCellPhone2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtEmail2, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox63, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox64, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox65, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox66, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox67, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox68, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox69, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox70, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox71, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox72, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox73, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox74, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox75, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox76, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox38, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox39, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox40, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox41, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtLanguage, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtMonthlyPayment, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtMonthlyDeposit, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.txtDepositMethod, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox21, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox22, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox23, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox24, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox25, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox26, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox27, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox28, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox29, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox30, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox31, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox32, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox33, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox34, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox42, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox43, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox44, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox45, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox46, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox47, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox48, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox49, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox50, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox51, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox52, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox53, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox54, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox55, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox35, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox36, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me.TextBox37, System.ComponentModel.ISupportInitialize).EndInit
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit

    End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        FixPhone("HomePhone1", txtHomePhone1)
        FixPhone("HomePhone2", txtHomePhone2)
        FixPhone("HomeFax1", txtHomeFax1)
        FixPhone("HomeFax2", txtHomeFax2)
        FixPhone("BusinessPhone1", txtBusinessPhone1)
        FixPhone("BusinessPhone2", txtBusinessPhone2)
        FixPhone("BusinessFax1", txtBusinessFax1)
        FixPhone("BusinessFax2", txtBusinessFax2)
        FixPhone("CellPhone1", txtCellPhone1)
        FixPhone("CellPhone2", txtCellPhone2)


        Validate("Name1", txtName1)
        Validate("HomePhone1", txtHomePhone1)
        Validate("HomeFax1", txtHomeFax1)
        Validate("BusinessPhone1", txtBusinessPhone1)
        Validate("BusinessFax1", txtBusinessFax1)
        Validate("CellPhone1", txtCellPhone1)
        Validate("Email1", txtEmail1)
        Validate("SSN1", txtSsn1)
        Validate("Dob1", txtDob1)
        Validate("Street1", txtStreet1)
        Validate("Street1b", txtStreet1b)
        Validate("City1", txtCity1)
        Validate("State1", txtState1)
        Validate("Zip1", txtZip1)
        Validate("Dob1", txtDob1)

        Validate("Name2", txtName2)
        Validate("HomePhone2", txtHomePhone2)
        Validate("HomeFax2", txtHomeFax2)
        Validate("BusinessPhone2", txtBusinessPhone2)
        Validate("BusinessFax2", txtBusinessFax2)
        Validate("CellPhone2", txtCellPhone2)
        Validate("Email2", txtEmail2)
        Validate("SSN2", txtSsn2)
        Validate("Dob2", txtDob2)
        Validate("Street2", txtStreet2)
        Validate("Street2b", txtStreet2b)
        Validate("City2", txtCity2)
        Validate("State2", txtState2)
        Validate("Zip2", txtZip2)
        Validate("Dob2", txtDob2)
    End Sub

    Private Sub Validate(ByVal s As String, ByVal c As GrapeCity.ActiveReports.SectionReportModel.TextBox)
        If String.IsNullOrEmpty(DataHelper.Nz_string(Fields(s).Value)) Then
            c.Text = "PLEASE PROVIDE >>>>>>>"
        End If
    End Sub
    Private Sub FixPhone(ByVal s As String, ByVal c As GrapeCity.ActiveReports.SectionReportModel.TextBox)
        Dim value As String = DataHelper.Nz_string(Fields(s).Value)
        If Not String.IsNullOrEmpty(value) Then
            Dim parts As String() = value.Split(" ")
            c.Text = StringHelper.PlaceInMask(parts(0), "(___) ___-____", "_", _
            StringHelper.Filter.AphaNumericOnly, False)
            If parts.Length > 1 AndAlso Not String.IsNullOrEmpty(parts(0)) Then
                c.Text += " x" & parts(1)
            End If
        End If
    End Sub
End Class