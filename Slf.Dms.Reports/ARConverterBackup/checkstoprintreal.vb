Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Document

Imports System

Public Class checkstoprintreal
    Inherits ActiveReport3

#Region "Constructor"

    Public Sub New()
        MyBase.New()

        InitializeReport()

        PageSettings.Orientation = PageOrientation.Portrait

        PageSettings.Margins.Top = 0.25
        PageSettings.Margins.Left = 0.5
        PageSettings.Margins.Right = 0.5
        PageSettings.Margins.Bottom = 0.25

    End Sub

#End Region

#Region "Variables"

    Private _checktoprintid As Integer
    Private _clientid As Integer
    Private _firstname As String
    Private _lastname As String
    Private _spousefirstname As String
    Private _spouselastname As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateabbreviation As String
    Private _statename As String
    Private _zipcode As String
    Private _accountnumber As String
    Private _bankname As String
    Private _bankcity As String
    Private _bankstateabbreviation As String
    Private _bankstatename As String
    Private _bankzipcode As String
    Private _bankroutingnumber As String
    Private _bankaccountnumber As String
    Private _amount As Double
    Private _checknumber As String
    Private _checkdate As Nullable(Of DateTime)
    Private _fraction As String
    Private _printed As Nullable(Of DateTime)
    Private _printedby As Integer
    Private _printedbyname As String
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String

#End Region

#Region "ActiveReports Designer generated code"
    Private WithEvents PageHeader As DataDynamics.ActiveReports.PageHeader = Nothing
    Private WithEvents Detail As DataDynamics.ActiveReports.Detail = Nothing
    Private WithEvents PageFooter As DataDynamics.ActiveReports.PageFooter = Nothing
	Private CheckToPrintID As DataDynamics.ActiveReports.TextBox = Nothing
	Private Bottom As DataDynamics.ActiveReports.TextBox = Nothing
	Private RichTextBox As DataDynamics.ActiveReports.RichTextBox = Nothing
	Private BankName2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankAddress2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private ClientID2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private Label As DataDynamics.ActiveReports.Label = Nothing
	Private Label1 As DataDynamics.ActiveReports.Label = Nothing
	Private ClientName3 As DataDynamics.ActiveReports.TextBox = Nothing
	Private Amount2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private CheckDate2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private ClientAddress2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private ClientName2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private Fraction2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private CheckNumber2 As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankName As DataDynamics.ActiveReports.TextBox = Nothing
	Private BankAddress As DataDynamics.ActiveReports.TextBox = Nothing
	Private ClientID As DataDynamics.ActiveReports.TextBox = Nothing
	Private Label2 As DataDynamics.ActiveReports.Label = Nothing
	Private ClientAddress As DataDynamics.ActiveReports.TextBox = Nothing
	Private ClientName As DataDynamics.ActiveReports.TextBox = Nothing
	Private Label3 As DataDynamics.ActiveReports.Label = Nothing
	Private Amount As DataDynamics.ActiveReports.TextBox = Nothing
	Private CheckDate As DataDynamics.ActiveReports.TextBox = Nothing
	Private Fraction As DataDynamics.ActiveReports.TextBox = Nothing
	Private CheckNumber As DataDynamics.ActiveReports.TextBox = Nothing
	Public Sub InitializeReport()
		Me.LoadLayout(Me.GetType, "Slf.Dms.Reports.checkstoprintreal.rpx")
		Me.PageHeader = CType(Me.Sections("PageHeader"),DataDynamics.ActiveReports.PageHeader)
		Me.Detail = CType(Me.Sections("Detail"),DataDynamics.ActiveReports.Detail)
		Me.PageFooter = CType(Me.Sections("PageFooter"),DataDynamics.ActiveReports.PageFooter)
		Me.CheckToPrintID = CType(Me.Detail.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.Bottom = CType(Me.PageFooter.Controls(0),DataDynamics.ActiveReports.TextBox)
		Me.RichTextBox = CType(Me.PageFooter.Controls(1),DataDynamics.ActiveReports.RichTextBox)
		Me.BankName2 = CType(Me.PageFooter.Controls(2),DataDynamics.ActiveReports.TextBox)
		Me.BankAddress2 = CType(Me.PageFooter.Controls(3),DataDynamics.ActiveReports.TextBox)
		Me.ClientID2 = CType(Me.PageFooter.Controls(4),DataDynamics.ActiveReports.TextBox)
		Me.Label = CType(Me.PageFooter.Controls(5),DataDynamics.ActiveReports.Label)
		Me.Label1 = CType(Me.PageFooter.Controls(6),DataDynamics.ActiveReports.Label)
		Me.ClientName3 = CType(Me.PageFooter.Controls(7),DataDynamics.ActiveReports.TextBox)
		Me.Amount2 = CType(Me.PageFooter.Controls(8),DataDynamics.ActiveReports.TextBox)
		Me.CheckDate2 = CType(Me.PageFooter.Controls(9),DataDynamics.ActiveReports.TextBox)
		Me.ClientAddress2 = CType(Me.PageFooter.Controls(10),DataDynamics.ActiveReports.TextBox)
		Me.ClientName2 = CType(Me.PageFooter.Controls(11),DataDynamics.ActiveReports.TextBox)
		Me.Fraction2 = CType(Me.PageFooter.Controls(12),DataDynamics.ActiveReports.TextBox)
		Me.CheckNumber2 = CType(Me.PageFooter.Controls(13),DataDynamics.ActiveReports.TextBox)
		Me.BankName = CType(Me.PageFooter.Controls(14),DataDynamics.ActiveReports.TextBox)
		Me.BankAddress = CType(Me.PageFooter.Controls(15),DataDynamics.ActiveReports.TextBox)
		Me.ClientID = CType(Me.PageFooter.Controls(16),DataDynamics.ActiveReports.TextBox)
		Me.Label2 = CType(Me.PageFooter.Controls(17),DataDynamics.ActiveReports.Label)
		Me.ClientAddress = CType(Me.PageFooter.Controls(18),DataDynamics.ActiveReports.TextBox)
		Me.ClientName = CType(Me.PageFooter.Controls(19),DataDynamics.ActiveReports.TextBox)
		Me.Label3 = CType(Me.PageFooter.Controls(20),DataDynamics.ActiveReports.Label)
		Me.Amount = CType(Me.PageFooter.Controls(21),DataDynamics.ActiveReports.TextBox)
		Me.CheckDate = CType(Me.PageFooter.Controls(22),DataDynamics.ActiveReports.TextBox)
		Me.Fraction = CType(Me.PageFooter.Controls(23),DataDynamics.ActiveReports.TextBox)
		Me.CheckNumber = CType(Me.PageFooter.Controls(24),DataDynamics.ActiveReports.TextBox)
	End Sub

#End Region

    Private Sub Detail_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles Detail.Format

        _checktoprintid = DataHelper.Nz_int(Fields("CheckToPrintID").Value)
        _clientid = DataHelper.Nz_int(Fields("ClientID").Value)
        _firstname = DataHelper.Nz_string(Fields("FirstName").Value)
        _lastname = DataHelper.Nz_string(Fields("LastName").Value)
        _spousefirstname = DataHelper.Nz_string(Fields("SpouseFirstName").Value)
        _spouselastname = DataHelper.Nz_string(Fields("SpouseLastName").Value)
        _street = DataHelper.Nz_string(Fields("Street").Value)
        _street2 = DataHelper.Nz_string(Fields("Street2").Value)
        _city = DataHelper.Nz_string(Fields("City").Value)
        _stateabbreviation = DataHelper.Nz_string(Fields("StateAbbreviation").Value)
        _statename = DataHelper.Nz_string(Fields("StateName").Value)
        _zipcode = DataHelper.Nz_string(Fields("ZipCode").Value)
        _accountnumber = DataHelper.Nz_string(Fields("AccountNumber").Value)
        _bankname = DataHelper.Nz_string(Fields("BankName").Value)
        _bankcity = DataHelper.Nz_string(Fields("BankCity").Value)
        _bankstateabbreviation = DataHelper.Nz_string(Fields("BankStateAbbreviation").Value)
        _bankstatename = DataHelper.Nz_string(Fields("BankStateName").Value)
        _bankzipcode = DataHelper.Nz_string(Fields("BankZipCode").Value)
        _bankroutingnumber = DataHelper.Nz_string(Fields("BankRoutingNumber").Value)
        _bankaccountnumber = DataHelper.Nz_string(Fields("BankAccountNumber").Value)
        _amount = DataHelper.Nz_double(Fields("Amount").Value)
        _checknumber = DataHelper.Nz_string(Fields("CheckNumber").Value)
        _checkdate = DataHelper.Nz_ndate(Fields("CheckDate").Value)
        _fraction = DataHelper.Nz_string(Fields("Fraction").Value)
        _printed = DataHelper.Nz_ndate(Fields("Printed").Value)
        _printedby = DataHelper.Nz_int(Fields("PrintedBy").Value)
        _printedbyname = DataHelper.Nz_string(Fields("PrintedByName").Value)
        _created = DataHelper.Nz_date(Fields("Created").Value)
        _createdby = DataHelper.Nz_int(Fields("CreatedBy").Value)
        _createdbyname = DataHelper.Nz_string(Fields("CreatedByName").Value)

    End Sub
    Private Sub PageFooter_Format(ByVal sender As Object, ByVal e As System.EventArgs) Handles PageFooter.Format

        ClientName.Text = (_firstname & " " & _lastname & vbCrLf & _spousefirstname & " " & _spouselastname).Trim
        ClientAddress.Text = AddressHelper.GetProper(_street, _street2, _city, _stateabbreviation, _zipcode)
        CheckNumber.Text = _checknumber
        Fraction.Text = _fraction

        If _checkdate.HasValue Then
            CheckDate.Text = _checkdate.Value.ToString("M/d/yyyy")
        End If

        Amount.Text = _amount.ToString("$  #,##0.00")
        BankName.Text = _bankname
        BankAddress.Text = _bankcity & ", " & _bankstateabbreviation & " " & _bankzipcode
        ClientID.Text = _clientid

        ClientName2.Text = ClientName.Text
        ClientAddress2.Text = ClientAddress.Text
        CheckNumber2.Text = CheckNumber.Text
        Fraction2.Text = Fraction.Text
        CheckDate2.Text = CheckDate.Text
        ClientName3.Text = _firstname & " " & _lastname
        Amount2.Text = Amount.Text
        BankName2.Text = BankName.Text
        BankAddress2.Text = BankAddress.Text
        ClientID2.Text = ClientID.Text

        Bottom.Text = "O000" & _checknumber & "   T" & _bankroutingnumber & "T   " _
            & _bankaccountnumber & "O"

    End Sub
End Class