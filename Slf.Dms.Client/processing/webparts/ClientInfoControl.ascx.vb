Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Partial Class negotiation_webparts_ClientInfoControl
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer
    Public DataclientID As Integer
    Public SettlementID As Integer
    Public TaskID As Integer = 0
#End Region

#Region "Page Events"
    ''' <summary>
    ''' Loads the page with approval form
    ''' </summary>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Session("UserID") = UserID

        If Not Request.QueryString("id") Is Nothing Then
            SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))
            DataclientID = SettlementMatterHelper.GetSettlementInformation(SettlementID).ClientID
        End If

        If Not IsPostBack Then
            Me.LoadClientInfo(DataclientID)
        End If

        Page.ClientScript.GetPostBackEventReference(lnkSavePhoneNote, "click")
    End Sub

    Protected Sub lnkSavePhoneNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSavePhoneNote.Click
        If txtPhoneNote.Value.Length > 0 Then
            Dim PropagationsList() As String = txtPhoneNote.Value.Split("|")
            Dim blnOutgoing As Boolean = Convert.ToBoolean(PropagationsList(0))
            Dim blnIncoming As Boolean = Convert.ToBoolean(PropagationsList(1))
            Dim intInternal As Integer = PropagationsList(2)
            Dim intExternal As Integer = PropagationsList(3)
            Dim PhoneCallEntry As Integer = PropagationsList(4)
            Dim strMessage As String = PropagationsList(5)
            Dim strSubject As String = PropagationsList(6)
            Dim strPhoneNumber As String = PropagationsList(7)
            Dim strStarted As String = PropagationsList(8)
            Dim strEnded As String = PropagationsList(9)
            Dim MatterId As Integer = DataHelper.FieldLookupIDs("tblSettlements", "MatterId", "SettlementId = " & SettlementID)(0)

            Dim PhoneCallID As Integer = PhoneCallHelper.InsertPhoneCall(DataclientID, UserID, intInternal, intExternal, blnOutgoing, strPhoneNumber, strMessage, strSubject, DateTime.Parse(strStarted), DateTime.Parse(strEnded))

            PhoneCallHelper.RelatePhoneCall(PhoneCallID, 1, DataclientID)
            PhoneCallHelper.RelatePhoneCall(PhoneCallID, 19, MatterId)

        End If

    End Sub
#End Region

#Region "Utilities"
    ''' <summary>
    ''' Formats the string to SSN xxx-xx-xxxx
    ''' </summary>
    ''' <param name="SSN">The string to be formatted</param>
    ''' <returns>Formatted string</returns>
    ''' <remarks></remarks>
    Private Function FormatSSN(ByVal SSN As String) As String
        Dim strTemp As String
        Try
            strTemp = SSN.Substring(0, 3) & "-" & SSN.Substring(3, 2) & "-" & SSN.Substring(5, 4)
            Return strTemp
        Catch ex As Exception
            Return ""
        End Try
    End Function

    ''' <summary>
    ''' loads the client info
    ''' </summary>
    ''' <param name="_ClientID">integer to Uniquely identify the Client</param>
    ''' <remarks></remarks>
    Public Sub LoadClientInfo(ByVal _ClientID As Integer)
        DataclientID = _ClientID

        Dim dtClient As New Data.DataTable

        Using saTemp = New Data.SqlClient.SqlDataAdapter("stp_GetSettlementClientInfo " & _ClientID, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            saTemp.Fill(dtClient)
        End Using

        If dtClient.Rows.Count > 0 Then
            Dim dRow As Data.DataRow = dtClient.Rows(0)
            Me.lnkClientName.InnerText = dRow("FirstName").ToString & " " & dRow("LastName").ToString & " (" & dRow("Accountnumber").ToString & ")"
            Me.lblClientStreet.Text = dRow("street").ToString
            Me.lnkPhone.Text = String.Format("({0})", dRow("AreaCode").ToString())
            Dim phone As String = dRow("PhoneNumber").ToString()

            If phone.Length > 3 Then
                Me.lnkPhone.Text += String.Format("-{0}-{1}", phone.Substring(0, 3), phone.Substring(3))
            Else
                Me.lnkPhone.Text += IIf(String.IsNullOrEmpty(phone), "", String.Format("-{0}", phone))
            End If

            Me.lblClientCity.Text = dRow("city").ToString
            Me.SSNLabel.Text = Me.FormatSSN(dRow("SSN").ToString)
            Me.lblClientAge.Text = dRow("ClientAge").ToString
            Me.stateabbreviationLabel.Text = dRow("stateabbreviation").ToString
            Me.lblSettAtty.Text = dRow("SettlementAttorney").ToString
            Me.lblZipCode.Text = dRow("ZipCode").ToString
            Me.lblClientStatus.Text = Drg.Util.DataHelpers.ClientHelper.GetStatus(_ClientID).ToString()

            Me.lnkPhone.Attributes.Add("onClick", "javascript:OpenPhoneCalls()")
            Me.lnkClientName.HRef = "~/clients/client/?id=" & _ClientID

            If lblClientStatus.Text = "Active" Then
                Img1.ImageUrl = "~/images/16x16_greenball_small.png"
            Else
                Img1.ImageUrl = "~/images/16x16_redball_small.png"
            End If

            If FormatDateTime(dRow("DateOfBirth").ToString, DateFormat.ShortDate) = "1/1/1900" Then
                Me.lblDOB.Text = ""
            Else
                Me.lblDOB.Text = FormatDateTime(dRow("DateOfBirth").ToString, DateFormat.ShortDate)
            End If

            If dtClient.Rows.Count > 1 AndAlso dtClient.Rows(1)("isprime") <> 1 Then
                Me.coAppRow1.Style("display") = ""

                For i As Integer = 1 To dtClient.Rows.Count - 1
                    Dim cRow As Data.DataRow = dtClient.Rows(i)
                    Me.lblCoAppHdr.Text = cRow("LabelHdr").ToString & ": "
                    Me.lnkCoAppName.InnerText = cRow("FirstName").ToString & " " & cRow("LastName").ToString
                    Me.lblCoAppSSN.Text = Me.FormatSSN(cRow("SSN").ToString)
                    Me.lblCoAppAge.Text = cRow("ClientAge").ToString
                    Me.lblCoAppState.Text = cRow("stateabbreviation").ToString
                    Me.lnkClientName.HRef = "~/clients/client/?id=" & _ClientID
                Next
            Else
                Me.ClearForm()
            End If
        End If
    End Sub
    ''' <summary>
    ''' Clears the data applicable to Co-applicant
    ''' </summary>
    Private Sub ClearForm()
        Me.coAppRow1.Style("display") = "none"
        Me.lblCoAppHdr.Text = ""
        Me.lnkCoAppName.InnerText = ""
        Me.lblCoAppSSN.Text = ""
        Me.lblCoAppAge.Text = ""
        Me.lblCoAppState.Text = ""
    End Sub
#End Region


End Class