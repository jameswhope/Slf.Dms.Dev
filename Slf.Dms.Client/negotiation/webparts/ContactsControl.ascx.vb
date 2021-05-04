Imports System.Data
Imports System.Data.SqlClient
Imports LexxiomWebPartsControls
Imports Drg.Util.DataHelpers
Partial Class negotiation_webparts_ContactsControl
    Inherits System.Web.UI.UserControl

#Region "declares"
    Public DataClientid As String
    Public accountID As String
    Public Event ContactAction(ByVal dataClientID As String, ByVal accountID As String)

    ''' <summary>
    ''' Holds the session guid
    ''' </summary>
    ''' <value></value>
    ''' <returns>session guid for the cal session</returns>
    ''' <remarks></remarks>
    Public Property noteID() As String
        Get
            Return Me.hdnNoteID.Value
        End Get
        Set(ByVal value As String)
            Me.hdnNoteID.Value = value
        End Set
    End Property
#End Region

    Protected Sub ibtnUpdate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibtnUpdate.Click
        Dim sLogText As String = "[@OrigCreditorName]/[@CurrCreditorName] #[@AcctLast4],  Updated the following creditor contact information:" & vbCrLf
        Dim contactID As Integer = 0
        Dim phoneID As Integer = 0
        Dim CreditorID As Integer = 0
        Dim CurrCreditorName As String = ""
        Dim OrigCreditorName As String = ""
        Dim CreditorAcctLast4 As String = ""
        Dim IDs As String() = Me.hiddenIDs.Value.ToString.Split(":")

        'insert contact, insert instead of update to keep trail
        If Me.txtEditFirst.Text.ToString <> "" Or Me.txtEditLast.Text.ToString <> "" Then

            'insert session note about offer
            Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & IDs(1)
            Dim rdrNote As SqlDataReader = Me.executeReader(sqlNote)
            If rdrNote.HasRows Then
                Do While rdrNote.Read
                    CreditorID = CInt(rdrNote("currcreditorid").ToString)
                    CurrCreditorName = rdrNote("CurrentCreditorName").ToString
                    OrigCreditorName = rdrNote("OriginalCreditorName").ToString
                    CreditorAcctLast4 = rdrNote("CreditorAcctLast4").ToString
                    Exit Do
                Loop
            End If
            rdrNote.Close()

            sLogText = sLogText.Replace("[@OrigCreditorName]", OrigCreditorName)
            sLogText = sLogText.Replace("[@CurrCreditorName]", CurrCreditorName)
            sLogText = sLogText.Replace("[@AcctLast4]", CreditorAcctLast4)

            '1.17.09.ug:  Padding creditorid when it should be the accountid
            contactID = ContactHelper.InsertContact(IDs(1), Me.txtEditFirst.Text, Me.txtEditLast.Text, Me.txtEditEmail.Text, Session("UserID"), Me.noteID)

            If Me.txtEditArea.Text.ToString <> "(###)" And Me.txtEditNumber.Text.ToString <> "###-####" Then
                phoneID = PhoneHelper.InsertPhone(57, txtEditArea.Text, txtEditNumber.Text, txtEditExt.Text, Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
            End If
            If Me.txtEditFaxArea.Text.ToString <> "(###)" And Me.txtEditFax.Text.ToString <> "###-####" Then
                phoneID = PhoneHelper.InsertPhone(58, txtEditFaxArea.Text, txtEditFax.Text, "", Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
                Drg.Util.DataHelpers.CreditorPhoneHelper.Insert(CreditorID, phoneID, Session("UserID"))
            End If

            RaiseEvent ContactAction(IDs(0), IDs(1))

            sLogText += BuildLogText()

            If noteID.ToString <> "" Then
                NoteHelper.AppendNote(noteID, sLogText, Session("userid"))
            Else
                noteID = NoteHelper.InsertNote(sLogText, Session("userid"), IDs(0))
            End If
            NoteHelper.RelateNote(noteID, 2, IDs(1))


        End If
    End Sub
    Private Function BuildLogText() As String
        Dim strTemp As String = ""

        If Me.txtEditFirst.Text.ToString <> "" Then
            strTemp += "Contact Name: " & Me.txtEditFirst.Text & Space(1)
        End If
        If Me.txtEditLast.Text.ToString <> "" Then
            strTemp += Me.txtEditLast.Text & vbCrLf
        End If
        If Me.txtEditEmail.Text.ToString <> "" Then
            strTemp += "Email Address: " & Me.txtEditEmail.Text & vbCrLf
        End If

        If Me.txtEditArea.Text.ToString <> "" Then
            strTemp += "Tel #: (" & Me.txtEditArea.Text & ")"
        End If
        If Me.txtEditNumber.Text.ToString <> "" And Me.txtEditNumber.Text.Length > 6 Then
            strTemp += Left(Me.txtEditNumber.Text, 3) & "-" & Right(Me.txtEditNumber.Text, 4) & Space(1)
        End If
        If Me.txtEditExt.Text.ToString <> "" Then
            strTemp += " x" & Me.txtEditExt.Text & vbCrLf
        End If
        If Me.txtEditFaxArea.Text.ToString <> "" And Me.txtEditNumber.Text.Length > 6 Then
            strTemp += Left(Me.txtEditFaxArea.Text, 3) & "-" & Right(Me.txtEditFaxArea.Text, 4) & Space(1)
        End If
        If Me.txtEditFax.Text.ToString <> "" Then
            strTemp += Me.txtEditFax.Text & vbCrLf
        End If
        Return strTemp
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            DataClientid = Request.QueryString("cid")
            accountID = Request.QueryString("crid")
            If accountID Is Nothing And DataClientid Is Nothing Then
                Me.ibtnUpdate.Enabled = False
                Exit Sub
            End If
            Me.hiddenIDs.Value = DataClientid & ":" & accountID
            LoadContactData(DataClientid, accountID)
        End If
    End Sub
    Public Sub LoadContactData(ByVal DataClientID As String, ByVal creditorAccoutID As String)
        Dim CreditorID As Integer = AccountHelper.GetCurrentCreditorID(creditorAccoutID)

        Me.hiddenIDs.Value = DataClientID & ":" & creditorAccoutID

        Dim dtContact As DataTable = ContactHelper.GetContactInfo(creditorAccoutID)

        If dtContact.Rows.Count >= 1 Then
            For Each dRow As DataRow In dtContact.Rows
                Select Case dRow("PhoneTypeID").ToString
                    Case "57"
                        Me.txtEditFirst.Text = dRow("FirstName").ToString
                        Me.txtEditLast.Text = dRow("LastName").ToString
                        Me.txtEditEmail.Text = dRow("EmailAddress").ToString
                        Me.txtEditArea.Text = dRow("AreaCode").ToString
                        Me.txtEditNumber.Text = dRow("Number").ToString
                        Me.txtEditExt.Text = dRow("Extension").ToString
                    Case "58"
                        Me.txtEditFaxArea.Text = dRow("AreaCode").ToString
                        Me.txtEditFax.Text = dRow("Number").ToString
                End Select
            Next
            dtContact.Dispose()
            dtContact = Nothing
        Else
            ClearForm()
        End If

        Me.ibtnUpdate.Enabled = True
    End Sub

    Private Sub ClearForm()
        Me.txtEditFirst.Text = ""
        Me.txtEditLast.Text = ""
        Me.txtEditEmail.Text = ""

        Me.txtEditArea.Text = ""
        Me.txtEditNumber.Text = ""
        Me.txtEditExt.Text = ""

        Me.txtEditfaxArea.Text = ""
        Me.txtEditfax.Text = ""
    End Sub
    Private Function executeReader(ByVal sqlText As String) As SqlDataReader
        Try
            Dim cmd As New SqlCommand(sqlText, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString))
            cmd.Connection.Open()
            Return cmd.ExecuteReader
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class
