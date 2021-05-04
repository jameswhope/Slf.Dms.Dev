Option Explicit On

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection
Imports System.Collections.Generic
Imports System.Web.Services

Partial Class admin_settings_references_settlementatty
    Inherits PermissionPage

#Region "Variables"
    Private objCompany As Lexxiom.BusinessServices.Company
    Private UserID As Integer
    Private CompanyID As Integer
#End Region

#Region "Page_Load"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNumeric(Request.QueryString("id")) Then
            CompanyID = DataHelper.Nz_int(Request.QueryString("id"), 0) 'edit
        Else
         CompanyID = -1 'add
         Me.txtUserName.Visible = True
      End If

      'Save companyid value to access via javascript
      Me.hdnCompanyID.Value = CompanyID

        If IsNothing(objCompany) Then
            objCompany = New Lexxiom.BusinessServices.Company(CompanyID)
        End If

        If Not IsPostBack Then
            LoadDropDownListOptions()

            If CompanyID > 0 Then
                LoadCompanyDetail()
            Else
                SetupFormForNewEntry()
            End If
        End If

        AddTasks()
        ApplySecurity()
    End Sub
#End Region

#Region "AddPermissionControls"
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(rowBanking, c, "Admin-Settings-Structural-Settlement Attorneys-Banking Information")
        AddControl(rowFTP, c, "Admin-Settings-Structural-Settlement Attorneys-FTP Information")
        AddControl(aShowBankingFields, c, "Admin-Settings-Structural-Settlement Attorneys-Banking Information-Show Fields")
        AddControl(aShowFTPFields, c, "Admin-Settings-Structural-Settlement Attorneys-FTP Information-Show Fields")
    End Sub
#End Region

#Region "Security"
    Private Sub ApplySecurity()
        Dim intUserRole As Integer = Drg.Util.DataHelpers.UserHelper.GetUserRole(UserID)

        Select Case intUserRole
            Case 6, 11 'Admin, Sys Admin
                'do nothing
            Case Else
                rowFTP.Visible = False
        End Select
    End Sub
#End Region

#Region "AddTasks"
    Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        If IsNumeric(Request.QueryString("id")) Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Changes</a>")
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Attorney</a>")
        End If
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel</a>")
    End Sub
#End Region

#Region "SetupFormForNewEntry"
    Private Sub SetupFormForNewEntry()
        Dim RequiredPhoneTypes As String() = {"46", "47", "50", "51"}
        Dim li As ListItem
        Dim i As Integer
        Dim bgColor As String

        'All address types are required
        For Each li In ddlAddressTypes.Items
            AddAddressRow(li.Value, "", "", "", "", "")
        Next

        'All bank account types are required
        For i = 0 To ddlAccountType.Items.Count - 1
            If (i + 1) Mod 2 Then
                bgColor = "#ffffff" 'odd row
            Else
                bgColor = "#e6e6e6" 'even row
            End If
            AddBankingRow(bgColor, "", "", "", "", "", "", "", ddlAccountType.Items(i).Value, "", "", "", , , , , , , "text")
        Next

        'Required phone types
        For Each type As String In RequiredPhoneTypes
            AddPhoneRow(type, "")
        Next

        AddAttorneysRow("", "", "", "", "", 0, -1)
        AddStateBarRow("", "")
        AddFTPRow("", "", "", "", "", "", "", "", "", "", , "text")

        lblTitle.Text = "New Settlement Attorney"
    End Sub
#End Region

#Region "LoadCompanyDetail"
    Private Sub LoadCompanyDetail()
        Dim intCommRecAddressID As Integer = -1
        Dim intCommRecPhoneID As Integer = -1
        Dim strAddress1 As String = ""
        Dim strAddress2 As String = ""
        Dim strCity As String = ""
        Dim strState As String = ""
        Dim strZipcode As String = ""
        Dim strContact1 As String = ""
        Dim strPhone As String = ""
        Dim dsCompany As Lexxiom.BusinessData.CompanyDetailDS
        Dim rowCompany As Lexxiom.BusinessData.CompanyDetailDS.CompanyRow
        Dim rowAttorney As Lexxiom.BusinessData.CompanyDetailDS.AttorneyRow
        Dim rowAddress As Lexxiom.BusinessData.CompanyDetailDS.AddressRow
        Dim rowPhone As Lexxiom.BusinessData.CompanyDetailDS.PhoneRow
        Dim rowBank As Lexxiom.BusinessData.CompanyDetailDS.CommRecRow
        Dim rowBar As Lexxiom.BusinessData.CompanyDetailDS.StateBarRow
        Dim Addresses() As Lexxiom.BusinessData.CompanyDetailDS.CommRecAddressRow
        Dim rowRecAddress As Lexxiom.BusinessData.CompanyDetailDS.CommRecAddressRow
        Dim Phones() As Lexxiom.BusinessData.CompanyDetailDS.CommRecPhoneRow
        Dim rowRecPhone As Lexxiom.BusinessData.CompanyDetailDS.CommRecPhoneRow
        Dim rowFTP As Lexxiom.BusinessData.CompanyDetailDS.NachaRootRow
        Dim Contact1() As String
        Dim i As Integer
        Dim bgColor As String
        Dim required As Boolean

        dsCompany = objCompany.CompanyDetail()

        'SA and Audit Information
        If dsCompany.Company.Rows.Count = 1 Then
            rowCompany = dsCompany.Company.Rows(0)
            txtFirmName.Value = rowCompany.Name
            lblTitle.Text = rowCompany.Name
            txtShortName.Value = rowCompany.ShortCoName
            Contact1 = Split(rowCompany.Contact1, " ")
            txtWebsite.Text = rowCompany.Website
            txtContactFName.Value = Contact1(0)
            txtContactLName.Value = Contact1(1)
            lblCreated.Text = rowCompany.Created
            lblCreatedBy.Text = rowCompany.CreatedBy
            lblLastModified.Text = rowCompany.LastModified
            lblLastModifiedBy.Text = rowCompany.LastModifiedBy
            If Not rowCompany.SigPath Is String.Empty Then
                lblSig.Text = "<a class='lnk' target='_blank' href='" & rowCompany.SigPath & "'>Signature:</a>"
            End If
        End If

        If dsCompany.Tables(9).Rows.Count = 1 Then
            Me.lnkUserId.Visible = True
            Me.lnkUserId.NavigateUrl = ResolveUrl("~/admin/users/user/default.aspx?id=" & dsCompany.Tables(9).Rows(0)("UserID").ToString)
            Me.lnkUserId.Text = dsCompany.Tables(9).Rows(0)("Username").ToString
            Me.txtUserName.Value = dsCompany.Tables(9).Rows(0)("UserID").ToString
        Else
            lnkUserId.Visible = True
            lnkUserId.NavigateUrl = "#"
            lnkUserId.Text = "Unassigned"
            lnkUserId.ForeColor = System.Drawing.Color.Red
            lnkUserId.Font.Underline = False
            lnkUserId.Style("cursor") = "text"
            Me.txtUserName.Value = 0
        End If

        'Attorneys
        If dsCompany.Attorney.Rows.Count > 0 Then
            For Each rowAttorney In dsCompany.Attorney
                AddAttorneysRow(rowAttorney.FirstName, rowAttorney.MiddleName, rowAttorney.LastName, rowAttorney.State, rowAttorney.StateBarNum, rowAttorney("IsPrimary"), rowAttorney.AttorneyID)
            Next
        Else
            AddAttorneysRow("", "", "", "", "", 0, -1)
        End If

        'Addresses
        For Each rowAddress In dsCompany.Address
            AddAddressRow(rowAddress.AddressTypeID.ToString, rowAddress.Address1, rowAddress.Address2, rowAddress.City, rowAddress.State, rowAddress.Zipcode)
        Next

        'Phones
        For Each rowPhone In dsCompany.Phone
            AddPhoneRow(rowPhone.PhoneTypeID.ToString, rowPhone.PhoneNumber)
        Next

        'State Bar Information
        If dsCompany.StateBar.Rows.Count > 0 Then
            For Each rowBar In dsCompany.StateBar
                AddStateBarRow(rowBar.State, rowBar.StateBarNum)
            Next
        Else
            AddStateBarRow("", "")
        End If

        'Bank Information
        i = 1
        For Each rowBank In dsCompany.CommRec
            Addresses = rowBank.GetChildRows("CommRec_CommRecAddress")

            If Addresses.Length > 0 Then
                For Each rowRecAddress In Addresses
                    intCommRecAddressID = rowRecAddress.CommRecAddressID
                    strAddress1 = rowRecAddress.Address1
                    strAddress2 = rowRecAddress.Address2
                    strCity = rowRecAddress.City
                    strState = rowRecAddress.State
                    strZipcode = rowRecAddress.Zipcode
                    strContact1 = rowRecAddress.Contact1
                    Exit For 'UI currently only accounts for 1 address per bank
                Next
            End If

            Phones = rowBank.GetChildRows("CommRec_CommRecPhone")

            If Phones.Length > 0 Then
                For Each rowRecPhone In Phones
                    intCommRecPhoneID = rowRecPhone.CommRecPhoneID
                    strPhone = rowRecPhone.PhoneNumber
                    Exit For 'UI currently only accounts for 1 phone per bank
                Next
            End If

            If (i Mod 2) Then
                bgColor = "#ffffff" 'odd row
            Else
                bgColor = "#e6e6e6" 'even row
            End If

            required = (dsCompany.CommRec.Rows.Count < 4) 'if additional banking information was added, allow user to delete 
            AddBankingRow(bgColor, rowBank.BankName, strAddress1, strAddress2, strCity, strState, strZipcode, strPhone, rowBank.AccountTypeID, strContact1, rowBank.RoutingNumber, rowBank.AccountNumber, rowBank.Type, rowBank.Method, rowBank.CommRecID, intCommRecAddressID, intCommRecPhoneID, required)
            i += 1
        Next

        'FTP Information
        If dsCompany.NachaRoot.Rows.Count > 0 Then
            For Each rowFTP In dsCompany.NachaRoot
                AddFTPRow(rowFTP.ftpServer, rowFTP.ftpUsername, rowFTP.ftpPassword, rowFTP.ftpFolder, rowFTP.ftpControlPort, rowFTP.Passphrase, rowFTP.PublicKeyring, rowFTP.PrivateKeyring, rowFTP.FileLocation, rowFTP.LogPath, rowFTP.tblNachaRoot)
            Next
        Else
            AddFTPRow("", "", "", "", "", "", "", "", "", "", , "text")
        End If

    End Sub
#End Region

#Region "AddFTPRow"
    Private Sub AddFTPRow(ByVal server As String, ByVal username As String, ByVal password As String, ByVal folder As String, ByVal port As String, ByVal passphrase As String, ByVal publickey As String, ByVal privatekey As String, ByVal fileloc As String, ByVal logpath As String, Optional ByVal NachaRootID As Integer = -1, Optional ByVal type As String = "password")
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell

        'Delete
        cell = New HtmlTableCell
        cell.InnerHtml = "<img src=""" & ResolveUrl("~/images/16x16_empty.png") & """ border=""0"" align=""absmiddle""/>" '"<a href=""#"" onclick=""Record_DeleteFTP(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        cell.Style("width") = "16"
        cell.Attributes("valign") = "top"
        row.Cells.Add(cell)

        'Server
        cell = New HtmlTableCell
        cell.InnerHtml = "FTP Server<br /><input type='" & type & "' style='width:175' class='entry' value='" & server & "'>"
        row.Cells.Add(cell)

        'Username
        cell = New HtmlTableCell
        cell.InnerHtml = "FTP Username<br /><input type='" & type & "' style='width:190' class='entry' value='" & username & "'>"
        row.Cells.Add(cell)

        'Password
        cell = New HtmlTableCell
        cell.InnerHtml = "FTP Password<br /><input type='" & type & "' style='width:190' class='entry' value='" & password & "'>"
        row.Cells.Add(cell)

        'Folder
        cell = New HtmlTableCell
        cell.InnerHtml = "FTP Folder<br /><input type='" & type & "' style='width:190' class='entry' value='" & folder & "'>"
        row.Cells.Add(cell)

        'Port
        cell = New HtmlTableCell
        cell.InnerHtml = "FTP Port<br /><input type='" & type & "' style='width:190' class='entry' value='" & port & "'>"
        row.Cells.Add(cell)

        tblFTP.Rows.Add(row)

        '  **** ROW 2 ****

        row = New HtmlTableRow

        'Row ID & Delete Flag
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "<input type='hidden' value='" & NachaRootID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        'Passphrase
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "Passphrase<br /><input type='" & type & "' style='width:175' class='entry' value='" & passphrase & "'>"
        row.Cells.Add(cell)

        'Public Key
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "Public Key<br /><input type='" & type & "' style='width:190' class='entry' value='" & publickey & "'>"
        row.Cells.Add(cell)

        'Private Key
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "Private Key<br /><input type='" & type & "' style='width:190' class='entry' value='" & privatekey & "'>"
        row.Cells.Add(cell)

        'File Loc
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "File Location<br /><input type='" & type & "' style='width:190' class='entry' value='" & fileloc & "'>"
        row.Cells.Add(cell)

        'Log Path
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "Log Path<br /><input type='" & type & "' style='width:190' class='entry' value='" & logpath & "'>"
        row.Cells.Add(cell)

        tblFTP.Rows.Add(row)
    End Sub
#End Region

#Region "AddAttorneysRow"
    Private Sub AddAttorneysRow(ByVal strFirstName As String, ByVal strMI As String, ByVal strLastName As String, ByVal strState As String, ByVal strStateBarNum As String, ByVal isPrimary As Integer, ByVal intAttorneyID As Integer)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        'Delete
        cell = New HtmlTableCell
        cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteEA(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'First Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strFirstName
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Middle Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strMI
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "30"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Last Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strLastName
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "50"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 50))
        row.Cells.Add(cell)

        'State Bar Num
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "150"
        cell.InnerHtml = "<input type='text' class='entry' value='" & strStateBarNum & "'>"
        row.Cells.Add(cell)

        'Primary Employed Attorney
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "50"
        cell.InnerHtml = "<input type='checkbox' class='entry'" & IIf(isPrimary, " checked", "") & ">"
        row.Cells.Add(cell)

        'AttorneyID, Delete Flag
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "auto"
        cell.InnerHtml = "<input type='hidden' value='" & intAttorneyID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        tblEAtty.Rows.Add(row)
    End Sub
#End Region

#Region "AddStateBarRow"
    Private Sub AddStateBarRow(ByVal strState As String, ByVal strStateBarNum As String)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        'Delete
        cell = New HtmlTableCell
        cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteBar(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 170))
        row.Cells.Add(cell)

        'State Bar Number
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Style("width") = "175"
        input.Value = strStateBarNum
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        tblStateBar.Rows.Add(row)
    End Sub
#End Region

#Region "AddAddressRow"
    Private Sub AddAddressRow(ByVal strAddressTypeID As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strCity As String, ByVal strState As String, ByVal strZipcode As String, Optional ByVal blnRequired As Boolean = True)
        Dim row As HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        row = New HtmlTableRow

        'Delete
        cell = New HtmlTableCell
        If blnRequired Then
            'cannot delete a required address type
            cell.InnerHtml = "<img src='" & ResolveUrl("~/images/16x16_empty.png") & "' border='0' align='absmiddle' />"
        Else
            cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteAddress(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        End If
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'Address Type
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlAddressTypes, strAddressTypeID, 170, Not blnRequired))
        row.Cells.Add(cell)

        'Address 1
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress1
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Address 2
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress2
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'City
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strCity
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 50))
        row.Cells.Add(cell)

        'Zip
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewInputMask(strZipcode, "nnnnn-nnnn", 75))
        row.Cells.Add(cell)

        tblAddresses.Rows.Add(row)
    End Sub
#End Region

#Region "AddPhoneRow"
    Private Sub AddPhoneRow(ByVal strPhoneTypeID As String, ByVal strPhoneNo As String)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell
        Dim blnRequired As Boolean

        Select Case strPhoneTypeID
            Case "46", "47", "50", "51"
                blnRequired = True
            Case Else
                blnRequired = False
        End Select

        'Delete
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        If blnRequired Then
            'cannot delete a required phone type
            cell.InnerHtml = "<img src='" & ResolveUrl("~/images/16x16_empty.png") & "' border='0' align='absmiddle' />"
        Else
            cell.InnerHtml = "<a href=""#"" onclick=""Record_DeletePhone(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        End If
        row.Cells.Add(cell)

        'Phone Type
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlPhoneTypes, strPhoneTypeID, 170, Not blnRequired))
        row.Cells.Add(cell)

        'Phone No
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewInputMask(strPhoneNo, "(nnn) nnn-nnnn", 85))
        row.Cells.Add(cell)

        tblPhones.Rows.Add(row)
    End Sub
#End Region

#Region "AddBankingRow"
    Private Sub AddBankingRow(ByVal bgColor As String, ByVal strBankName As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strCity As String, ByVal strState As String, ByVal strZipcode As String, ByVal strPhone As String, ByVal intAccountTypeID As Integer, ByVal strContact1 As String, ByVal strRouting As String, ByVal strAccountNo As String, Optional ByVal strType As String = "C", Optional ByVal strMethod As String = "ACH", Optional ByVal intCommRecID As Integer = -1, Optional ByVal intCommRecAddressID As Integer = -1, Optional ByVal intCommRecPhoneID As Integer = -1, Optional ByVal blnRequired As Boolean = True, Optional ByVal type As String = "password")
        Dim row As HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        '  **** ROW 1 ****

        row = New HtmlTableRow

        'Delete
        cell = New HtmlTableCell
        If blnRequired Then
            'cannot delete a required account type
            cell.InnerHtml = "<img src=""" & ResolveUrl("~/images/16x16_empty.png") & """ border=""0"" align=""absmiddle""/>"
        Else
            cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteBank(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        End If
        cell.Style.Add("width", "16")
        cell.Style.Add("background-color", bgColor)
        row.Cells.Add(cell)

        'Account Type
        cell = New HtmlTableCell
        cell.Style.Add("background-color", bgColor)
        cell.Style.Add("width", "170")
        cell.InnerHtml = "Account Type<br />"
        cell.Controls.Add(GetNewDDL(ddlAccountType, intAccountTypeID.ToString, 170, Not blnRequired))
        row.Cells.Add(cell)

        'Address 1
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress1
        cell = New HtmlTableCell
        cell.Style.Add("width", "195")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Street Address 1<br />"
        cell.Controls.Add(input)

        input = New HtmlControls.HtmlInputText("hidden")
        input.Value = intCommRecAddressID
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Address 2
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress2
        cell = New HtmlTableCell
        cell.Style.Add("width", "170")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Street Address 2<br />"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'City
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strCity
        cell = New HtmlTableCell
        cell.Style.Add("width", "170")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "City<br />"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Style.Add("width", "50")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "State<br />"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 50))
        row.Cells.Add(cell)

        'Zip
        cell = New HtmlTableCell
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Zip Code<br />"
        cell.Controls.Add(GetNewInputMask(strZipcode, "nnnnn-nnnn", 75))
        row.Cells.Add(cell)

        'Phone
        cell = New HtmlTableCell
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Phone<br />"
        cell.Controls.Add(GetNewInputMask(strPhone, "(nnn) nnn-nnnn", 85))
        row.Cells.Add(cell)

        tblBanks.Rows.Add(row)

        '  **** ROW 2 ****

        row = New HtmlTableRow

        'Delete Flag & CommRecPhoneID
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "<input type='hidden' value='N'><input type='hidden' value='" & intCommRecPhoneID.ToString & "'>&nbsp;"
        row.Cells.Add(cell)

        'Bank Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strBankName
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Bank Name<br />"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Contact
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("width", "195")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Contact<br /><input type='text' style='width:195' class='entry' value='" & strContact1 & "'>"
        row.Cells.Add(cell)

        'Routing Number
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("width", "170")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Routing Number<br />"
        'If type = "text" Then
        '    cell.Controls.Add(GetNewInputMask(strRouting, "nnnnnnnnn", 170))
        'Else
        input = New HtmlControls.HtmlInputText(type)
        input.Attributes("class") = "entry"
        input.Attributes("maxlength") = "9"
        input.Value = strRouting
        cell.Controls.Add(input)
        'End If
        row.Cells.Add(cell)

        'Account Number
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("width", "170")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Account Number<br />"
        'If type = "text" Then
        '    cell.Controls.Add(GetNewInputMask(strAccountNo, "nnnnnnnnn", 170))
        'Else
        input = New HtmlControls.HtmlInputText(type)
        input.Attributes("class") = "entry"
        input.Attributes("maxlength") = "9"
        input.Value = strAccountNo
        cell.Controls.Add(input)
        'End If
        row.Cells.Add(cell)

        'Checking
        input = New HtmlControls.HtmlInputText("checkbox")
        input.Attributes("class") = "entry"
        If strType = "C" Then
            input.Attributes("checked") = "checked"
        End If
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("align") = "center"
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "Checking<br />"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'ACH
        input = New HtmlControls.HtmlInputText("checkbox")
        input.Attributes("class") = "entry"
        If strMethod = "ACH" Then
            input.Attributes("checked") = "checked"
        End If
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("align") = "center"
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "ACH<br />"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'ID
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style.Add("width", "auto")
        cell.Style.Add("background-color", bgColor)
        cell.InnerHtml = "<input type='hidden' value='" & intCommRecID.ToString & "'>&nbsp;"
        row.Cells.Add(cell)

        tblBanks.Rows.Add(row)
    End Sub
#End Region

#Region "GetNewDDL"
    Private Function GetNewDDL(ByVal ddlSource As DropDownList, ByVal SelectedValue As String, ByVal Width As Integer, Optional ByVal blnEnabled As Boolean = True) As DropDownList
        Dim ddl As New DropDownList
        Dim li, li2 As ListItem

        ddl.CssClass = "entry"
        ddl.Enabled = blnEnabled
        'ddl.Width = UI.WebControls.Unit.Pixel(Width)

        For Each li In ddlSource.Items
            li2 = New ListItem(li.Text, li.Value)
            ddl.Items.Add(li2)
        Next

        ListHelper.SetSelected(ddl, SelectedValue.Trim)

        Return ddl
    End Function
#End Region

#Region "GetNewInputMask"
    Private Function GetNewInputMask(ByVal Value As String, ByVal mask As String, ByVal width As Integer) As AssistedSolutions.WebControls.InputMask
        Dim im As New AssistedSolutions.WebControls.InputMask

        im.CssClass = "entry"
        im.Mask = mask
        im.Width = UI.WebControls.Unit.Pixel(width)
        im.Text = Value

        Return im
    End Function
#End Region

#Region "LoadDropDownListOptions"
    Private Sub LoadDropDownListOptions()
        'Dim objAgency As New Lexxiom.BusinessServices.Agency

        'With ddlAgencies
        '    .DataSource = objAgency.GetAgencyList
        '    .DataTextField = "Name"
        '    .DataValueField = "AgencyID"
        '    .DataBind()
        'End With
        'objAgency = Nothing

        With ddlStates
            .DataSource = objCompany.GetStates
            .DataTextField = "Abbreviation"
            .DataValueField = "Abbreviation" '"StateID"
            .DataBind()
        End With

        'hidden: used for add/editing addresses
        With ddlAddressTypes
            .DataSource = objCompany.CompanyAddressTypes
            .DataTextField = "AddressTypeName"
            .DataValueField = "AddressTypeID"
            .DataBind()
        End With

        'hidden: used for add/editing phone numbers
        With ddlPhoneTypes
            .DataSource = Drg.Util.DataHelpers.PhoneHelper.GetPhoneTypes
            .DataTextField = "Name"
            .DataValueField = "PhoneTypeID"
            .DataBind()
        End With

        'hidden: used for add/editing bank information
        With ddlAccountType
            .DataSource = objCompany.AccountTypeList
            .DataTextField = "AccountType"
            .DataValueField = "AccountTypeID"
            .DataBind()
        End With

    End Sub
#End Region

#Region "Click Events"

#Region "lnkCancelAndClose"
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Response.Redirect("multi.aspx?id=10")
    End Sub
#End Region

#Region "GetAssocAttys"
    Protected Sub GetAssocAttys_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGetAssocAttys.Click
        Response.Redirect("..\..\multi.aspx?id=10")
        'Response.Redirect("..\..\attorneys.aspx")
    End Sub
#End Region

    '#Region "GetAttyList"
    '   Protected Sub lnkGetAttyList_Click(byval sender as object, byval e as System.EventArgs) handles lnkGetAssocAttys
    '      Response.Redirect("..\..\multi.aspx?id=10")
    '   End Sub
    '#End Region

#Region "lnkSave"
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim strContact1 As String = txtContactFName.Value.Trim & " " & txtContactLName.Value.Trim
        Dim strSigPath As String = ""
        Dim lstFTPInfo As String = ""
        Dim intNewUserID As Integer

        'Only update FTP info if user had access
        If rowFTP.Visible Then
            lstFTPInfo = hdnFTPInfo.Value
        End If

        If SigUpload.HasFile Then
            If Left(SigUpload.PostedFile.ContentType, 6) = "image/" Then
                strSigPath = System.Configuration.ConfigurationManager.AppSettings("SigPath")
                If Right(strSigPath, 1) <> "\" Then
                    strSigPath &= "\"
                End If
                strSigPath &= SigUpload.FileName
                SigUpload.SaveAs(strSigPath)
            End If
        End If

        objCompany.SaveCompany(txtFirmName.Value, txtShortName.Value, UserID, strContact1, txtAddresses.Value, txtPhones.Value, txtStateBars.Value, hdnBankInfo.Value, lstFTPInfo, hdnAttorneys.Value, , , txtWebsite.Text, strSigPath)

        If objCompany.CompanyID > 0 AndAlso CompanyID = -1 Then
            intNewUserID = Drg.Util.DataHelpers.UserHelper.InsertUser(txtContactFName.Value.Trim, txtContactLName.Value.Trim, "", False, False, True, txtUserName.Value.Trim, "12345", 6, 20, 0, UserID)
            'Drg.Util.DataHelpers.UserHelper.SaveUserCompany(intNewUserID, objCompany.CompanyID.ToString)
            'todo: set default user permissions
        End If

        Response.Redirect("~/admin/settings/attorneys.aspx?id=" & objCompany.CompanyID.ToString)
    End Sub
#End Region

#Region "lnkDelete"
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

    End Sub
#End Region

#End Region

    <WebMethod()> _
     Public Shared Function UserNameExists(ByVal UserName As String) As Boolean
        Return UserHelper.Exists(UserName)
    End Function
End Class
