Imports System

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document
Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Public Class informationsheet
    Inherits ActiveReport3

	Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.25

    End Sub

#Region "ActiveReports Designer generated code"
    Private WithEvents ReportHeader As DataDynamics.ActiveReports.ReportHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents ReportFooter As DataDynamics.ActiveReports.ReportFooter = Nothing
	Private Picture As DataDynamics.ActiveReports.Picture
	Private TextBox As DataDynamics.ActiveReports.TextBox
	Private TextBox1 As DataDynamics.ActiveReports.TextBox
	Private TextBox2 As DataDynamics.ActiveReports.TextBox
	Private TextBox3 As DataDynamics.ActiveReports.TextBox
	Private TextBox4 As DataDynamics.ActiveReports.TextBox
	Private TextBox5 As DataDynamics.ActiveReports.TextBox
	Private TextBox6 As DataDynamics.ActiveReports.TextBox
	Private TextBox56 As DataDynamics.ActiveReports.TextBox
	Private TextBox7 As DataDynamics.ActiveReports.TextBox
	Private TextBox8 As DataDynamics.ActiveReports.TextBox
	Private TextBox9 As DataDynamics.ActiveReports.TextBox
	Private TextBox10 As DataDynamics.ActiveReports.TextBox
	Private TextBox11 As DataDynamics.ActiveReports.TextBox
	Private TextBox12 As DataDynamics.ActiveReports.TextBox
	Private TextBox13 As DataDynamics.ActiveReports.TextBox
	Private TextBox14 As DataDynamics.ActiveReports.TextBox
	Private TextBox15 As DataDynamics.ActiveReports.TextBox
	Private TextBox16 As DataDynamics.ActiveReports.TextBox
	Private TextBox17 As DataDynamics.ActiveReports.TextBox
	Private TextBox18 As DataDynamics.ActiveReports.TextBox
	Private TextBox19 As DataDynamics.ActiveReports.TextBox
	Private TextBox20 As DataDynamics.ActiveReports.TextBox
	Private txtName1 As DataDynamics.ActiveReports.TextBox
	Private txtStreet1 As DataDynamics.ActiveReports.TextBox
	Private txtStreet1b As DataDynamics.ActiveReports.TextBox
	Private txtCity1 As DataDynamics.ActiveReports.TextBox
	Private txtState1 As DataDynamics.ActiveReports.TextBox
	Private txtZip1 As DataDynamics.ActiveReports.TextBox
	Private txtDob1 As DataDynamics.ActiveReports.TextBox
	Private txtSsn1 As DataDynamics.ActiveReports.TextBox
	Private txtHomePhone1 As DataDynamics.ActiveReports.TextBox
	Private txtHomeFax1 As DataDynamics.ActiveReports.TextBox
	Private txtBusinessPhone1 As DataDynamics.ActiveReports.TextBox
	Private txtBusinessFax1 As DataDynamics.ActiveReports.TextBox
	Private txtCellPhone1 As DataDynamics.ActiveReports.TextBox
	Private txtEmail1 As DataDynamics.ActiveReports.TextBox
	Private txtName2 As DataDynamics.ActiveReports.TextBox
	Private txtStreet2 As DataDynamics.ActiveReports.TextBox
	Private txtStreet2b As DataDynamics.ActiveReports.TextBox
	Private txtCity2 As DataDynamics.ActiveReports.TextBox
	Private txtState2 As DataDynamics.ActiveReports.TextBox
	Private txtZip2 As DataDynamics.ActiveReports.TextBox
	Private txtDob2 As DataDynamics.ActiveReports.TextBox
	Private txtSsn2 As DataDynamics.ActiveReports.TextBox
	Private txtHomePhone2 As DataDynamics.ActiveReports.TextBox
	Private txtHomeFax2 As DataDynamics.ActiveReports.TextBox
	Private txtBusinessPhone2 As DataDynamics.ActiveReports.TextBox
	Private txtBusinessFax2 As DataDynamics.ActiveReports.TextBox
	Private txtCellPhone2 As DataDynamics.ActiveReports.TextBox
	Private txtEmail2 As DataDynamics.ActiveReports.TextBox
	Private TextBox63 As DataDynamics.ActiveReports.TextBox
	Private TextBox64 As DataDynamics.ActiveReports.TextBox
	Private TextBox65 As DataDynamics.ActiveReports.TextBox
	Private TextBox66 As DataDynamics.ActiveReports.TextBox
	Private TextBox67 As DataDynamics.ActiveReports.TextBox
	Private TextBox68 As DataDynamics.ActiveReports.TextBox
	Private TextBox69 As DataDynamics.ActiveReports.TextBox
	Private TextBox70 As DataDynamics.ActiveReports.TextBox
	Private TextBox71 As DataDynamics.ActiveReports.TextBox
	Private TextBox72 As DataDynamics.ActiveReports.TextBox
	Private TextBox73 As DataDynamics.ActiveReports.TextBox
	Private TextBox74 As DataDynamics.ActiveReports.TextBox
	Private TextBox75 As DataDynamics.ActiveReports.TextBox
	Private TextBox76 As DataDynamics.ActiveReports.TextBox
	Private TextBox38 As DataDynamics.ActiveReports.TextBox
	Private TextBox39 As DataDynamics.ActiveReports.TextBox
	Private TextBox40 As DataDynamics.ActiveReports.TextBox
	Private TextBox41 As DataDynamics.ActiveReports.TextBox
	Private txtLanguage As DataDynamics.ActiveReports.TextBox
	Private txtMonthlyPayment As DataDynamics.ActiveReports.TextBox
	Private txtMonthlyDeposit As DataDynamics.ActiveReports.TextBox
	Private txtDepositMethod As DataDynamics.ActiveReports.TextBox
	Private TextBox21 As DataDynamics.ActiveReports.TextBox
	Private TextBox22 As DataDynamics.ActiveReports.TextBox
	Private TextBox23 As DataDynamics.ActiveReports.TextBox
	Private TextBox24 As DataDynamics.ActiveReports.TextBox
	Private TextBox25 As DataDynamics.ActiveReports.TextBox
	Private TextBox26 As DataDynamics.ActiveReports.TextBox
	Private TextBox27 As DataDynamics.ActiveReports.TextBox
	Private TextBox28 As DataDynamics.ActiveReports.TextBox
	Private TextBox29 As DataDynamics.ActiveReports.TextBox
	Private TextBox30 As DataDynamics.ActiveReports.TextBox
	Private TextBox31 As DataDynamics.ActiveReports.TextBox
	Private TextBox32 As DataDynamics.ActiveReports.TextBox
	Private TextBox33 As DataDynamics.ActiveReports.TextBox
	Private TextBox34 As DataDynamics.ActiveReports.TextBox
	Private TextBox42 As DataDynamics.ActiveReports.TextBox
	Private TextBox43 As DataDynamics.ActiveReports.TextBox
	Private TextBox44 As DataDynamics.ActiveReports.TextBox
	Private TextBox45 As DataDynamics.ActiveReports.TextBox
	Private TextBox46 As DataDynamics.ActiveReports.TextBox
	Private TextBox47 As DataDynamics.ActiveReports.TextBox
	Private TextBox48 As DataDynamics.ActiveReports.TextBox
	Private TextBox49 As DataDynamics.ActiveReports.TextBox
	Private TextBox50 As DataDynamics.ActiveReports.TextBox
	Private TextBox51 As DataDynamics.ActiveReports.TextBox
	Private TextBox52 As DataDynamics.ActiveReports.TextBox
	Private TextBox53 As DataDynamics.ActiveReports.TextBox
	Private TextBox54 As DataDynamics.ActiveReports.TextBox
	Private TextBox55 As DataDynamics.ActiveReports.TextBox
	Private TextBox35 As DataDynamics.ActiveReports.TextBox
	Private TextBox36 As DataDynamics.ActiveReports.TextBox
	Private TextBox37 As DataDynamics.ActiveReports.TextBox
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.informationsheet.rpx")
		Me.ReportHeader = CType(Me.Sections("ReportHeader"),DataDynamics.ActiveReports.ReportHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.ReportFooter = CType(Me.Sections("ReportFooter"),DataDynamics.ActiveReports.ReportFooter)
		Me.Picture = CType(Me.ReportHeader.Controls(0),DataDynamics.ActiveReports.Picture)
		Me.TextBox = CType(Me.ReportHeader.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.TextBox1 = CType(Me.ReportHeader.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox2 = CType(Me.ReportHeader.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.TextBox3 = CType(Me.ReportHeader.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.TextBox4 = CType(Me.ReportHeader.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.TextBox5 = CType(Me.ReportHeader.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.TextBox6 = CType(Me.ReportHeader.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.TextBox56 = CType(Me.ReportHeader.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.TextBox7 = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.TextBox8 = CType(Me.Detail.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.TextBox9 = CType(Me.Detail.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.TextBox10 = CType(Me.Detail.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.TextBox11 = CType(Me.Detail.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.TextBox12 = CType(Me.Detail.Controls(5),DataDynamics.ActiveReports.TextBox)
		Me.TextBox13 = CType(Me.Detail.Controls(6),DataDynamics.ActiveReports.TextBox)
		Me.TextBox14 = CType(Me.Detail.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.TextBox15 = CType(Me.Detail.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.TextBox16 = CType(Me.Detail.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.TextBox17 = CType(Me.Detail.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.TextBox18 = CType(Me.Detail.Controls(11),DataDynamics.ActiveReports.TextBox)
		Me.TextBox19 = CType(Me.Detail.Controls(12),DataDynamics.ActiveReports.TextBox)
		Me.TextBox20 = CType(Me.Detail.Controls(13),DataDynamics.ActiveReports.TextBox)
		Me.txtName1 = CType(Me.Detail.Controls(14),DataDynamics.ActiveReports.TextBox)
		Me.txtStreet1 = CType(Me.Detail.Controls(15),DataDynamics.ActiveReports.TextBox)
		Me.txtStreet1b = CType(Me.Detail.Controls(16),DataDynamics.ActiveReports.TextBox)
		Me.txtCity1 = CType(Me.Detail.Controls(17),DataDynamics.ActiveReports.TextBox)
		Me.txtState1 = CType(Me.Detail.Controls(18),DataDynamics.ActiveReports.TextBox)
		Me.txtZip1 = CType(Me.Detail.Controls(19),DataDynamics.ActiveReports.TextBox)
		Me.txtDob1 = CType(Me.Detail.Controls(20),DataDynamics.ActiveReports.TextBox)
		Me.txtSsn1 = CType(Me.Detail.Controls(21),DataDynamics.ActiveReports.TextBox)
		Me.txtHomePhone1 = CType(Me.Detail.Controls(22),DataDynamics.ActiveReports.TextBox)
		Me.txtHomeFax1 = CType(Me.Detail.Controls(23),DataDynamics.ActiveReports.TextBox)
		Me.txtBusinessPhone1 = CType(Me.Detail.Controls(24),DataDynamics.ActiveReports.TextBox)
		Me.txtBusinessFax1 = CType(Me.Detail.Controls(25),DataDynamics.ActiveReports.TextBox)
		Me.txtCellPhone1 = CType(Me.Detail.Controls(26),DataDynamics.ActiveReports.TextBox)
		Me.txtEmail1 = CType(Me.Detail.Controls(27),DataDynamics.ActiveReports.TextBox)
		Me.txtName2 = CType(Me.Detail.Controls(28),DataDynamics.ActiveReports.TextBox)
		Me.txtStreet2 = CType(Me.Detail.Controls(29),DataDynamics.ActiveReports.TextBox)
		Me.txtStreet2b = CType(Me.Detail.Controls(30),DataDynamics.ActiveReports.TextBox)
		Me.txtCity2 = CType(Me.Detail.Controls(31),DataDynamics.ActiveReports.TextBox)
		Me.txtState2 = CType(Me.Detail.Controls(32),DataDynamics.ActiveReports.TextBox)
		Me.txtZip2 = CType(Me.Detail.Controls(33),DataDynamics.ActiveReports.TextBox)
		Me.txtDob2 = CType(Me.Detail.Controls(34),DataDynamics.ActiveReports.TextBox)
		Me.txtSsn2 = CType(Me.Detail.Controls(35),DataDynamics.ActiveReports.TextBox)
		Me.txtHomePhone2 = CType(Me.Detail.Controls(36),DataDynamics.ActiveReports.TextBox)
		Me.txtHomeFax2 = CType(Me.Detail.Controls(37),DataDynamics.ActiveReports.TextBox)
		Me.txtBusinessPhone2 = CType(Me.Detail.Controls(38),DataDynamics.ActiveReports.TextBox)
		Me.txtBusinessFax2 = CType(Me.Detail.Controls(39),DataDynamics.ActiveReports.TextBox)
		Me.txtCellPhone2 = CType(Me.Detail.Controls(40),DataDynamics.ActiveReports.TextBox)
		Me.txtEmail2 = CType(Me.Detail.Controls(41),DataDynamics.ActiveReports.TextBox)
		Me.TextBox63 = CType(Me.Detail.Controls(42),DataDynamics.ActiveReports.TextBox)
		Me.TextBox64 = CType(Me.Detail.Controls(43),DataDynamics.ActiveReports.TextBox)
		Me.TextBox65 = CType(Me.Detail.Controls(44),DataDynamics.ActiveReports.TextBox)
		Me.TextBox66 = CType(Me.Detail.Controls(45),DataDynamics.ActiveReports.TextBox)
		Me.TextBox67 = CType(Me.Detail.Controls(46),DataDynamics.ActiveReports.TextBox)
		Me.TextBox68 = CType(Me.Detail.Controls(47),DataDynamics.ActiveReports.TextBox)
		Me.TextBox69 = CType(Me.Detail.Controls(48),DataDynamics.ActiveReports.TextBox)
		Me.TextBox70 = CType(Me.Detail.Controls(49),DataDynamics.ActiveReports.TextBox)
		Me.TextBox71 = CType(Me.Detail.Controls(50),DataDynamics.ActiveReports.TextBox)
		Me.TextBox72 = CType(Me.Detail.Controls(51),DataDynamics.ActiveReports.TextBox)
		Me.TextBox73 = CType(Me.Detail.Controls(52),DataDynamics.ActiveReports.TextBox)
		Me.TextBox74 = CType(Me.Detail.Controls(53),DataDynamics.ActiveReports.TextBox)
		Me.TextBox75 = CType(Me.Detail.Controls(54),DataDynamics.ActiveReports.TextBox)
		Me.TextBox76 = CType(Me.Detail.Controls(55),DataDynamics.ActiveReports.TextBox)
		Me.TextBox38 = CType(Me.Detail.Controls(56),DataDynamics.ActiveReports.TextBox)
		Me.TextBox39 = CType(Me.Detail.Controls(57),DataDynamics.ActiveReports.TextBox)
		Me.TextBox40 = CType(Me.Detail.Controls(58),DataDynamics.ActiveReports.TextBox)
		Me.TextBox41 = CType(Me.Detail.Controls(59),DataDynamics.ActiveReports.TextBox)
		Me.txtLanguage = CType(Me.Detail.Controls(60),DataDynamics.ActiveReports.TextBox)
		Me.txtMonthlyPayment = CType(Me.Detail.Controls(61),DataDynamics.ActiveReports.TextBox)
		Me.txtMonthlyDeposit = CType(Me.Detail.Controls(62),DataDynamics.ActiveReports.TextBox)
		Me.txtDepositMethod = CType(Me.Detail.Controls(63),DataDynamics.ActiveReports.TextBox)
		Me.TextBox21 = CType(Me.Detail.Controls(64),DataDynamics.ActiveReports.TextBox)
		Me.TextBox22 = CType(Me.Detail.Controls(65),DataDynamics.ActiveReports.TextBox)
		Me.TextBox23 = CType(Me.Detail.Controls(66),DataDynamics.ActiveReports.TextBox)
		Me.TextBox24 = CType(Me.Detail.Controls(67),DataDynamics.ActiveReports.TextBox)
		Me.TextBox25 = CType(Me.Detail.Controls(68),DataDynamics.ActiveReports.TextBox)
		Me.TextBox26 = CType(Me.Detail.Controls(69),DataDynamics.ActiveReports.TextBox)
		Me.TextBox27 = CType(Me.Detail.Controls(70),DataDynamics.ActiveReports.TextBox)
		Me.TextBox28 = CType(Me.Detail.Controls(71),DataDynamics.ActiveReports.TextBox)
		Me.TextBox29 = CType(Me.Detail.Controls(72),DataDynamics.ActiveReports.TextBox)
		Me.TextBox30 = CType(Me.Detail.Controls(73),DataDynamics.ActiveReports.TextBox)
		Me.TextBox31 = CType(Me.Detail.Controls(74),DataDynamics.ActiveReports.TextBox)
		Me.TextBox32 = CType(Me.Detail.Controls(75),DataDynamics.ActiveReports.TextBox)
		Me.TextBox33 = CType(Me.Detail.Controls(76),DataDynamics.ActiveReports.TextBox)
		Me.TextBox34 = CType(Me.Detail.Controls(77),DataDynamics.ActiveReports.TextBox)
		Me.TextBox42 = CType(Me.Detail.Controls(78),DataDynamics.ActiveReports.TextBox)
		Me.TextBox43 = CType(Me.Detail.Controls(79),DataDynamics.ActiveReports.TextBox)
		Me.TextBox44 = CType(Me.Detail.Controls(80),DataDynamics.ActiveReports.TextBox)
		Me.TextBox45 = CType(Me.Detail.Controls(81),DataDynamics.ActiveReports.TextBox)
		Me.TextBox46 = CType(Me.Detail.Controls(82),DataDynamics.ActiveReports.TextBox)
		Me.TextBox47 = CType(Me.Detail.Controls(83),DataDynamics.ActiveReports.TextBox)
		Me.TextBox48 = CType(Me.Detail.Controls(84),DataDynamics.ActiveReports.TextBox)
		Me.TextBox49 = CType(Me.Detail.Controls(85),DataDynamics.ActiveReports.TextBox)
		Me.TextBox50 = CType(Me.Detail.Controls(86),DataDynamics.ActiveReports.TextBox)
		Me.TextBox51 = CType(Me.Detail.Controls(87),DataDynamics.ActiveReports.TextBox)
		Me.TextBox52 = CType(Me.Detail.Controls(88),DataDynamics.ActiveReports.TextBox)
		Me.TextBox53 = CType(Me.Detail.Controls(89),DataDynamics.ActiveReports.TextBox)
		Me.TextBox54 = CType(Me.Detail.Controls(90),DataDynamics.ActiveReports.TextBox)
		Me.TextBox55 = CType(Me.Detail.Controls(91),DataDynamics.ActiveReports.TextBox)
		Me.TextBox35 = CType(Me.ReportFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.TextBox36 = CType(Me.ReportFooter.Controls(1),DataDynamics.ActiveReports.TextBox)
		Me.TextBox37 = CType(Me.ReportFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
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

    Private Sub Validate(ByVal s As String, ByVal c As DataDynamics.ActiveReports.TextBox)
        If String.IsNullOrEmpty(DataHelper.Nz_string(Fields(s).Value)) Then
            c.Text = "PLEASE PROVIDE >>>>>>>"
        End If
    End Sub
    Private Sub FixPhone(ByVal s As String, ByVal c As DataDynamics.ActiveReports.TextBox)
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