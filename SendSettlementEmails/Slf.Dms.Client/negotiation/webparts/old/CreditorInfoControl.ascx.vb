Imports LexxiomWebPartsControls
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class negotiation_webparts_CreditorInfoControl
    Inherits System.Web.UI.UserControl

#Region "Declares"
    Public DataClientid As String
    Public CreditorAccountID As String
    Public Event LoadCreditorFilter(ByVal CreditorName As String)


    ''' <summary>
    ''' event when a edit is complete
    ''' </summary>
    ''' <param name="EditClientID"></param>
    ''' <param name="EditCreditorAcctID"></param>
    ''' <remarks></remarks>
    Public Event EditComplete(ByVal EditClientID As String, ByVal EditCreditorAcctID As String)
    Public Property CurrentCreditorName() As String
        Get
            Return hdnCurrentCreditorName.Value
        End Get
        Set(ByVal value As String)
            hdnCurrentCreditorName.Value = value
        End Set
    End Property

    Public Property noteID() As String
        Get
            Return Me.hdnNoteID.Value
        End Get
        Set(ByVal value As String)
            Me.hdnNoteID.Value = value
        End Set
    End Property
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            DataClientid = Request.QueryString("cid")
            CreditorAccountID = Request.QueryString("crid")
            If CreditorAccountID Is Nothing And DataClientid Is Nothing Then
                Me.ibtnUpdate.Enabled = False
                Exit Sub
            End If
            LoadCreditorInfo(CreditorAccountID, DataClientid, True)

        End If
    End Sub
    Protected Sub ibtnUpdate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibtnUpdate.Click

        Try
            Dim ids As String() = Me.hiddenIDs.Value.Split(":")

            UpdateCreditorContact()

            If Me.IsFormDirty Then
                UpdateCreditor()
                InsertAction(ids(0), ids(1))
                RaiseEvent EditComplete(ids(0), Me.hdnAcctID.Value)
                Me.LoadCreditorInfo(Me.hdnAcctID.Value, ids(0), True)
            End If


            Me.tblEdit.Style("display") = "block"
        Catch ex As Exception

        End Try
    End Sub
#End Region

#Region "Subs/Funcs"
    Private Sub GetOriginalCreditorID(ByVal accountID As String)

        Me.hdnOriginalCreditorID.Value = AccountHelper.GetOriginalCreditorID(accountID)

    End Sub

    ''' <summary>
    ''' loads creditor info
    ''' </summary>
    ''' <param name="strCreditorID"></param>
    ''' <remarks></remarks>
    Public Sub LoadCreditorInfo(ByVal accountID As String, ByVal dataClientID As String, Optional ByVal bFilterAssignments As Boolean = True)

        Me.hiddenIDs.Value = dataClientID & ":" & accountID

        Me.tblEdit.Style("display") = "block"

        Dim dtCreditor As New Data.DataTable
        Using saTemp = New Data.SqlClient.SqlDataAdapter("stp_GetSettlementCreditorInfo " & accountID, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            saTemp.Fill(dtCreditor)
        End Using

        If dtCreditor.Rows.Count > 0 Then
            ClearForm()
            For Each dRow As Data.DataRow In dtCreditor.Rows
                Me.txtEditForCreditorName.Text = dRow("forcreditorname").ToString
                Me.txtEditCurrCreditorName.Text = dRow("creditorname").ToString
                Me.txtEditAcctNum.Text = dRow("accountnumber").ToString
                Me.txtEditRefNum.Text = dRow("referencenumber").ToString
                Me.txtEditOrigAmt.Text = FormatCurrency(dRow("originalamount").ToString, 2)
                Me.txtEditCurrAmt.Text = FormatCurrency(dRow("currentamount").ToString, 2)
                Me.txtEditAcquired.Text = FormatDateTime(dRow("Acquired"), DateFormat.ShortDate)

                Me.CurrentCreditorName = dRow("creditorname").ToString
                Me.hdnCreditorInstanceID.Value = dRow("creditorinstanceID").ToString
                Me.hdnAcctID.Value = dRow("accountid").ToString
                Me.hdnforCreditorInfo.Value = dRow("ForCreditorID").ToString
                Me.hdnCurrCreditorInfo.Value = dRow("CreditorID").ToString

                GetOriginalCreditorID(Me.hdnAcctID.Value)
                If bFilterAssignments = True Then
                    RaiseEvent LoadCreditorFilter(dRow("creditorname").ToString)
                End If

                LoadContactData(dataClientID, accountID)

                SaveOldValues()
                Exit For
            Next
        End If




    End Sub
    Private Sub SaveOldValues()
        Dim dOld As New Dictionary(Of String, String)
        For Each c As Control In Me.tblEdit.Controls
            For Each r As Control In c.Controls
                For Each rc As Control In r.Controls
                    Dim cellID As String = rc.ClientID
                    If cellID.Contains("txtEdit") Then
                        Dim lblName As String = cellID.Substring(cellID.LastIndexOf("_") + 1).Replace("txtEdit", "")
                        If TypeOf rc Is Label Then
                            dOld.Add(lblName, DirectCast(rc, Label).Text)
                        ElseIf TypeOf rc Is TextBox Then
                            dOld.Add(lblName, DirectCast(rc, TextBox).Text)
                        End If
                    End If
                Next
            Next
        Next
        ViewState("CreditorInfoOldVal") = dOld
    End Sub

    ''' <summary>
    ''' inserts a new creditor
    ''' </summary>
    ''' <param name="Creditor"></param>
    ''' <param name="Street"></param>
    ''' <param name="Street2"></param>
    ''' <param name="City"></param>
    ''' <param name="StateID"></param>
    ''' <param name="ZipCode"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function InsertNewCreditor(ByVal Creditor As String, ByVal Street As String, ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String) As Integer
        Dim CreditorId As Integer
        Using cmd As Data.IDbCommand = ConnectionFactory.Create().CreateCommand()
            DatabaseHelper.AddParameter(cmd, "Name", Creditor)
            DatabaseHelper.AddParameter(cmd, "Street", Street)
            If Not String.IsNullOrEmpty(Street2) Then
                DatabaseHelper.AddParameter(cmd, "Street2", Street2)
            End If
            DatabaseHelper.AddParameter(cmd, "City", City)
            DatabaseHelper.AddParameter(cmd, "StateId", Integer.Parse(StateID))
            DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode)

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", Session("UserID"))
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", Session("UserID"))

            DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditor", "CreditorId", Data.SqlDbType.Int)

            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                CreditorId = DataHelper.Nz_int(cmd.Parameters("@CreditorId").Value)
            End Using
        End Using
        Return CreditorId
    End Function

    ''' <summary>
    ''' update creditor info
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub UpdateCreditor()
        Try
            Dim acctID As String = Me.hdnAcctID.Value
            Dim forCreditor As String() = Me.hdnforCreditorInfo.Value.Split("|")
            Dim currCreditor As String() = Me.hdnCurrCreditorInfo.Value.Split("|")
            Dim contactID As Integer = 0
            Dim phoneID As Integer = 0
            Dim CurrCreditorID As String

            If currCreditor(0) = "-1" Then 'have to create a new creditor
                CurrCreditorID = InsertNewCreditor(currCreditor(1), currCreditor(2), currCreditor(3), currCreditor(4), Integer.Parse(currCreditor(5)), currCreditor(6))
            Else
                CurrCreditorID = currCreditor(0)
            End If

            If Me.hdnOriginalCreditorID.Value = "" Then
                forCreditor(0) = "NULL"
            Else
                forCreditor(0) = Me.hdnOriginalCreditorID.Value
            End If


            'insert new creditor instance
            Dim sqlInsert As String = "INSERT INTO tblCreditorInstance "
            sqlInsert += "([AccountID],[CreditorID],[ForCreditorID],[Acquired],[Amount],[OriginalAmount],[AccountNumber],[ReferenceNumber],[Created],[CreatedBy],[LastModified],[LastModifiedBy]) "
            sqlInsert += " OUTPUT Inserted.CreditorInstanceID "
            sqlInsert += "VALUES "
            sqlInsert += "([@AccountID],[@CreditorID],[@ForCreditorID],'[@Acquired]',[@Amount],[@OriginalAmount],'[@AccountNumber]','[@ReferenceNumber]','[@Created]',[@CreatedBy],'[@LastModified]',[@LastModifiedBy])"
            sqlInsert = sqlInsert.Replace("[@AccountID]", acctID)
            sqlInsert = sqlInsert.Replace("[@CreditorID]", CurrCreditorID)
            sqlInsert = sqlInsert.Replace("[@ForCreditorID]", forCreditor(0))
            sqlInsert = sqlInsert.Replace("[@Acquired]", FormatDateTime(Me.txtEditAcquired.Text, DateFormat.ShortDate))
            sqlInsert = sqlInsert.Replace("[@Amount]", System.Double.Parse(Me.txtEditCurrAmt.Text, System.Globalization.NumberStyles.Currency))
            sqlInsert = sqlInsert.Replace("[@OriginalAmount]", System.Double.Parse(Me.txtEditOrigAmt.Text, System.Globalization.NumberStyles.Currency))
            sqlInsert = sqlInsert.Replace("[@AccountNumber]", Me.txtEditAcctNum.Text)
            sqlInsert = sqlInsert.Replace("[@ReferenceNumber]", Me.txtEditRefNum.Text)
            sqlInsert = sqlInsert.Replace("[@Created]", Now)
            sqlInsert = sqlInsert.Replace("[@CreatedBy]", Session("UserID"))
            sqlInsert = sqlInsert.Replace("[@LastModified]", Now)
            sqlInsert = sqlInsert.Replace("[@LastModifiedBy]", Session("UserID"))

            Using sqlcmd = New Data.SqlClient.SqlCommand(sqlInsert, New Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
                sqlcmd.Connection.Open()
                Dim credinstanceid As String = sqlcmd.ExecuteScalar()

                'update tblaccount with new instance info
                Dim sqlUpdate As String = "update tblAccount set "
                sqlUpdate += "CurrentCreditorInstanceID = " & credinstanceid
                'sqlUpdate += ",OriginalCreditorInstanceID = " & Me.hdnCreditorInstanceID.Value
                sqlUpdate += ",CurrentAmount = " & System.Double.Parse(Me.txtEditCurrAmt.Text, System.Globalization.NumberStyles.Currency)
                sqlUpdate += " where (accountid = " & acctID & ")"
                sqlcmd.CommandText = sqlUpdate
                sqlcmd.ExecuteNonQuery()

                Me.hdnAcctID.Value = acctID
            End Using
        Catch ex As Exception

        End Try
    End Sub

    ''' <summary>
    ''' insert action to session log
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub InsertAction(ByVal sClientID As String, ByVal sCreditorAcctID As String)
        Dim strLogText As String = "[@OrigCreditorName]/[@CurrCreditorName] #[@AcctLast4],  Updated the following creditor account information:" & vbCrLf
        Dim sqlInsert As String = ""
        Try
            'load old values
            Dim dOld As Dictionary(Of String, String) = DirectCast(ViewState("CreditorInfoOldVal"), Dictionary(Of String, String))

            'load new values
            Dim dNew As New Dictionary(Of String, String)
            For Each c As Control In Me.tblEdit.Controls
                For Each r As Control In c.Controls
                    For Each rc As Control In r.Controls
                        Dim cellID As String = rc.ClientID
                        If cellID.Contains("txtEdit") Then
                            Dim lblName As String = cellID.Substring(cellID.LastIndexOf("_") + 1).Replace("txtEdit", "")
                            dNew.Add(lblName, DirectCast(rc, TextBox).Text)
                        End If
                    Next
                Next

            Next

            'insert session note about offer
            Dim CreditorID As Integer = 0
            Dim CurrCreditorName As String = ""
            Dim OrigCreditorName As String = ""
            Dim CreditorAcctLast4 As String = ""
            Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & sCreditorAcctID
            Dim rdrNote As SqlClient.SqlDataReader = Me.executeReader(sqlNote)
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

            strLogText = strLogText.Replace("[@OrigCreditorName]", OrigCreditorName)
            strLogText = strLogText.Replace("[@CurrCreditorName]", CurrCreditorName)
            strLogText = strLogText.Replace("[@AcctLast4]", CreditorAcctLast4)
            'compare
            For Each d As KeyValuePair(Of String, String) In dOld
                If dNew.Item(d.Key) <> d.Value Then
                    Dim fieldName As String = d.Key.ToString
                    fieldName = InsertSpaceAfterCap(fieldName)
                    strLogText += "Changed " & fieldName & " from " & d.Value & " to " & dNew.Item(d.Key) & vbCrLf
                End If
            Next
        Catch ex As Exception
            Trace.Write(ex.Message)
        End Try


        If noteID.ToString = "" Then
            noteID = NoteHelper.InsertNote(strLogText, Session("userid"), sClientID)
        Else
            NoteHelper.AppendNote(noteID, strLogText, Session("userid"))
        End If
        NoteHelper.RelateNote(noteID, 2, sCreditorAcctID)

    End Sub

    ''' <summary>
    ''' check if text was changed
    ''' </summary>
    ''' <returns>boolean</returns>
    ''' <remarks></remarks>
    Private Function IsFormDirty() As Boolean

        Dim IsDirty As Boolean = False

        Try
            'load old values
            Dim dOld As Dictionary(Of String, String) = DirectCast(ViewState("CreditorInfoOldVal"), Dictionary(Of String, String))
            
            'load new values
            Dim dNew As New Dictionary(Of String, String)
            For Each c As Control In Me.tblEdit.Controls
                For Each r As Control In c.Controls
                    For Each rc As Control In r.Controls
                        Dim cellID As String = rc.ClientID
                        If cellID.Contains("txtEdit") Then
                            Dim lblName As String = cellID.Substring(cellID.LastIndexOf("_") + 1).Replace("txtEdit", "")
                            dNew.Add(lblName, DirectCast(rc, TextBox).Text)
                        End If
                    Next
                Next

            Next

            'compare
            For Each d As KeyValuePair(Of String, String) In dOld
                If dNew.Item(d.Key) <> d.Value Then
                    IsDirty = True
                End If
            Next

            Return IsDirty
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub ClearForm()
        'Me.lblViewForCreditorName.Text = ""
        'Me.lblViewCurrCreditorName.Text = ""
        'Me.lblViewAcctNum.Text = ""
        'Me.lblViewRefNum.Text = ""
        'Me.lblViewOrigAmt.Text = ""
        'Me.lblViewCurrAmt.Text = ""
        'Me.lblViewAcquired.Text = ""

        Me.txtEditForCreditorName.Text = ""
        Me.txtEditCurrCreditorName.Text = ""
        Me.txtEditAcctNum.Text = ""
        Me.txtEditRefNum.Text = ""
        Me.txtEditOrigAmt.Text = ""
        Me.txtEditCurrAmt.Text = ""
        Me.txtEditAcquired.Text = ""

        Me.hdnCreditorInstanceID.Value = ""
        Me.hdnAcctID.Value = ""
        Me.hdnforCreditorInfo.Value = ""
        Me.hdnCurrCreditorInfo.Value = ""
    End Sub
    Private Function executeReader(ByVal sqlText As String) As SqlClient.SqlDataReader
        Try
            Dim cmd As New SqlClient.SqlCommand(sqlText, New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString))
            cmd.Connection.Open()
            Return cmd.ExecuteReader
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
#End Region

#Region "Creditor Contact"
    Private Sub LoadContactData(ByVal DataClientID As String, ByVal creditorAccoutID As String)
        Dim dtContact As DataTable = ContactInfoHelper.GetContactInfo(creditorAccoutID, ContactInfoHelper.ContactPhoneType.Telephone)
        Dim dRow As DataRow

        If Not dtContact Is Nothing Then
            If dtContact.Rows.Count = 1 Then
                dRow = dtContact.Rows(0)
                Me.txtEditFirst.Text = dRow("FirstName").ToString
                Me.txtEditLast.Text = dRow("LastName").ToString
                Me.txtEditEmail.Text = dRow("EmailAddress").ToString
                Me.txtEditArea.Text = dRow("AreaCode").ToString
                Me.txtEditNumber.Text = dRow("Number").ToString
                Me.txtEditExt.Text = dRow("Extension").ToString
            End If
        End If

        dtContact = ContactInfoHelper.GetContactInfo(creditorAccoutID, ContactInfoHelper.ContactPhoneType.Fax)
        If Not dtContact Is Nothing Then
            If dtContact.Rows.Count = 1 Then
                dRow = dtContact.Rows(0)
                Me.txtEditFaxArea.Text = dRow("AreaCode").ToString
                Me.txtEditFax.Text = dRow("Number").ToString
            End If
        End If

        Me.ibtnUpdate.Enabled = True
    End Sub
    Private Sub UpdateCreditorContact()
        Dim contactID As Integer = 0
        Dim phoneID As Integer = 0
        Dim IDs As String() = Me.hiddenIDs.Value.ToString.Split(":")

        'insert contact, insert instead of update to keep trail
        If Me.txtEditFirst.Text.ToString <> "" Or Me.txtEditLast.Text.ToString <> "" Then

            '1.17.09.ug:  Padding creditorid when it should be the accountid
            contactID = ContactHelper.InsertContact(IDs(1), Me.txtEditFirst.Text, Me.txtEditLast.Text, Me.txtEditEmail.Text, Session("UserID"), Me.noteID)

            If Me.txtEditArea.Text.ToString <> "" And Me.txtEditNumber.Text.ToString <> "" Then
                phoneID = PhoneHelper.InsertPhone(57, txtEditArea.Text, txtEditNumber.Text, txtEditExt.Text, Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
            End If
            If Me.txtEditFaxArea.Text.ToString <> "" And Me.txtEditFax.Text.ToString <> "" Then
                phoneID = PhoneHelper.InsertPhone(58, txtEditFaxArea.Text, txtEditFax.Text, "", Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
                Drg.Util.DataHelpers.CreditorPhoneHelper.Insert(IDs(1), phoneID, Session("UserID"))
            End If

        End If
    End Sub
#End Region

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String

        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

        Dim sChars() As Char = strToChange.ToCharArray()
        Dim strNew As String = ""

        For Each c As Char In sChars
            Select Case Asc(c)
                Case 65 To 95, 49 To 57   'upper caps or numbers
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
                Case Else
                    strNew += Space(1) & c.ToString
            End Select
        Next

        strNew = strNew.Replace("I D", "ID")
        Return strNew.Trim
    End Function
End Class