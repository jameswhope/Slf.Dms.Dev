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

Partial Class admin_settings_references_Agencys
   Inherits System.Web.UI.Page

#Region "Variables"
   Private objAgency As Lexxiom.BusinessServices.Agency
   Private UserID As Integer
    Private AgencyID As Integer
#End Region

#Region "Page_Load"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'ScriptManager.GetCurrent(Me.Page).EnablePageMethods = True
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                          GlobalFiles.JQuery.UI, _
                                                          "~/jquery/jquery.modaldialog.js"})

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNumeric(Request.QueryString("id")) Then
            AgencyID = DataHelper.Nz_int(Request.QueryString("id"), 0) 'edit
        Else
            AgencyID = -1 'add
        End If

        'Save agencyid value to access via javascript
        Me.hdnAgencyId.Value = AgencyID

        If IsNothing(objAgency) Then
            objAgency = New Lexxiom.BusinessServices.Agency(AgencyID)
        End If

        If Not IsPostBack Then
            LoadDropDownListOptions()

            If AgencyID > 0 Then
                LoadAgencyDetail()
            Else
                lblTitle.Text = "New"
                Me.pnlBank.Attributes.Add("style", "display: none")
                Me.pnlChildAgency.Attributes.Add("style", "display: none")
                Me.txtUserName.Visible = True
                'AddAddressRow("", "", "", "", "", False)
                'AddPhoneRow("-1", "", False)
                'AddAgentRow("", "")
            End If
        End If

        AddTasks()
        ApplySecurity()
    End Sub
#End Region

#Region "ApplySecurity"
    Private Sub ApplySecurity()
        Dim intUserRole As Integer = Drg.Util.DataHelpers.UserHelper.GetUserRole(UserID)

        Select Case intUserRole
            Case 6, 11 'Admin, Sys Admin
                'do nothing
            Case Else
                'rowFTP.Visible = False
        End Select
    End Sub
#End Region

#Region "AddTasks"
   Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        If IsNumeric(Request.QueryString("id")) Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Changes</a>")
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Agency</a>")
        End If
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""multi.aspx?id=8""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel</a>")

        'If AgencyID > 0 Then
        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this agency</a>")
        'End If
    End Sub
#End Region

#Region "Click Routines"
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save()
        Response.Redirect("~/admin/settings/references/Agencys.aspx?id=" & objAgency.AgencyID.ToString)
    End Sub

    Protected Sub lnkStructure_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkStructure.Click
        Response.Redirect("~/admin/commission/default.aspx") '?id=" & objAgency.AgencyID.ToString)
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        ReturnToMenu()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        If AgencyID > 0 Then
            objAgency.DeleteAgency()
            ReturnToMenu()
        End If
    End Sub

    'Private Function GetAgencyUserId() As Integer
    '    Dim AgencyUserId = 0
    '    If AgencyID > 0 Then
    '        'Get current Agency User Id
    '        AgencyUserId = Int32.Parse(txtUserName.Value)
    '    Else
    '        'Create User
    '        Dim tmpPassword As String = "1234"
    '        Dim emailDomain As String = "@lexxiom.com"
    '        AgencyUserId = UserHelper.InsertUser(txtFirmName.Value, "Agency", txtUserName.Value & emailDomain, False, False, True, Me.txtUserName.Value, tmpPassword, 2, 16, 0, UserID)
    '    End If
    '    Return AgencyUserId
    'End Function

    Private Sub Save()
        Dim strContact1 As String = txtContactFName.Value.Trim & " " & txtContactLName.Value.Trim
        Dim intIsCommRec As Integer = 0
        Dim intAgencyUserId As Integer = -1 'GetAgencyUserId()
        If ckIsCommRec.Checked Then intIsCommRec = 1
        objAgency.SaveAgency(txtFirmName.Value, txtShortName.Value, intIsCommRec, intAgencyUserId, UserID, strContact1, txtAddresses.Value, txtPhones.Value, txtOwnedAgencys.Value, hdnBankInfo.Value, hdnAgents.Value)
    End Sub

    Private Sub ReturnToMenu()
        Response.Redirect("~/admin/settings/default.aspx")
    End Sub

#End Region

#Region "LoadDropDownListOptions"
    Private Sub LoadDropDownListOptions()
        With ddlAgencies
            Dim vw As New DataView(objAgency.GetAllAgencies)
            If AgencyID > 0 Then
                vw.RowFilter = "AgencyId <> " & AgencyID
            End If
            .DataSource = vw
            .DataTextField = "Name"
            .DataValueField = "AgencyID"
            .DataBind()
        End With

        With ddlStates
            .DataSource = objAgency.GetStates
            .DataTextField = "Abbreviation"
            .DataValueField = "Abbreviation" '"StateID"
            .DataBind()
            .Items.Insert(0, New ListItem("Select", "0"))
        End With

        With ddlPhoneTypes
            .DataSource = Drg.Util.DataHelpers.PhoneHelper.GetPhoneTypes
            .DataTextField = "Name"
            .DataValueField = "PhoneTypeID"
            .DataBind()
        End With

        With ddlAccountType
            .DataSource = objAgency.AccountTypeList
            .DataTextField = "AccountType"
            .DataValueField = "AccountTypeID"
            .DataBind()
        End With

      
    End Sub
#End Region

#Region "LoadAgencyDetail"
    Private Sub LoadAgencyDetail()
        Dim intCommRecAddressID As Integer = -1
        Dim intCommRecPhoneID As Integer = -1
        Dim intCommRecID As Integer = -1
        Dim strAbbrev As String = ""
        Dim strDisplay As String = ""
        Dim strAddress1 As String = ""
        Dim strAddress2 As String = ""
        Dim strCity As String = ""
        Dim strState As String = ""
        Dim strZipcode As String = ""
        Dim strContact1 As String = ""
        Dim strPhone As String = ""
        Dim strBankName As String = ""
        Dim strRoutingNumber As String = ""
        Dim strAccountNumber As String = ""
        Dim strAcctType As String = ""
        Dim strMethod As String = ""
        Dim dsAgency As Lexxiom.BusinessData.AgencyDetail
        Dim rowAgency As Lexxiom.BusinessData.AgencyDetail.AgencyRow
        Dim rowAgent As Lexxiom.BusinessData.AgencyDetail.AgentRow
        Dim rowAddress As Lexxiom.BusinessData.AgencyDetail.AgencyAddressesRow
        Dim rowAgencyPhone As Lexxiom.BusinessData.AgencyDetail.AgencyPhoneRow
        Dim rowPhone As Lexxiom.BusinessData.AgencyDetail.PhoneRow
        Dim rowBank As Lexxiom.BusinessData.AgencyDetail.CommRecRow
        Dim rowChildAgency As Lexxiom.BusinessData.AgencyDetail.ChildAgencyRow
        Dim Addresses() As Lexxiom.BusinessData.AgencyDetail.CommRecAddressRow
        Dim rowRecAddress As Lexxiom.BusinessData.AgencyDetail.CommRecAddressRow
        Dim Phones() As Lexxiom.BusinessData.AgencyDetail.CommRecPhoneRow
        Dim rowRecPhone As Lexxiom.BusinessData.AgencyDetail.CommRecPhoneRow
        Dim row As HtmlTableRow
        Dim cell As HtmlTableCell
        Dim Contact1() As String

        dsAgency = objAgency.AgencyDetail()

        'SA and Audit Information
        If dsAgency.Agency.Rows.Count = 1 Then
            rowAgency = dsAgency.Agency.Rows(0)
            lblTitle.Text = rowAgency.Name
            txtFirmName.Value = rowAgency.Name
            txtShortName.Value = rowAgency.ImportAbbr
            Contact1 = Split(rowAgency.Contact1, " ")
            txtContactFName.Value = Contact1(0)
            If Contact1(0) <> "" Then
                txtContactLName.Value = Contact1(1)
            End If

            'jhernandez 2/29/08
            'User accounts will need to be created from the Users interface. Setting up 
            'an agency user account requires several user selections not currently on
            'this page. If we decide to create user accounts from this page, we should
            'move it into it's own section.

            'Dim LoginName As String = ""

            'If Not rowAgency.IsUserIdNull Then LoginName = UserHelper.GetLoginName(rowAgency.UserId)

            'If LoginName.Trim.Length > 0 Then
            '    Me.lnkUserId.Visible = True
            '    Me.lnkUserId.NavigateUrl = ResolveUrl("~/admin/users/user/default.aspx?id=" & rowAgency.UserId)
            '    Me.lnkUserId.Text = LoginName
            '    Me.txtUserName.Value = rowAgency.UserId
            'Else
            '    'User record not assigned or deleted
            '    Dim lbl As New Label
            '    lbl.ID = "lblUserId"
            '    lbl.CssClass = "labelddlExtender"
            '    lbl.Text = IIf(rowAgency.IsUserIdNull, " Unassigned ", " Not found")
            '    pnlUser.Controls.Add(lbl)
            '    Me.txtUserName.Value = 0
            'End If

            lblCreated.Text = rowAgency.Created
            lblCreatedBy.Text = rowAgency.CreatedBy
            lblLastModified.Text = rowAgency.LastModified
            lblLastModifiedBy.Text = rowAgency.LastModifiedBy
            Me.ckIsCommRec.Checked = rowAgency.IsCommRec

            BuildPayFeesToInfo(rowAgency)

            Dim strAttr As String = "none"
            If rowAgency.IsCommRec Then strAttr = "block"
            Me.pnlBank.Attributes.Add("style", "display: " & strAttr)
            Me.pnlChildAgency.Attributes.Add("style", "display: " & strAttr)
        End If

        'Agents
        If dsAgency.Agent.Rows.Count > 0 Then
            For Each rowAgent In dsAgency.Agent
                AddAgentRow(rowAgent.FirstName, rowAgent.LastName, rowAgent.AgentID)
            Next
        Else
            'AddAgentRow("", "")
        End If

        'Addresses
        If dsAgency.AgencyAddresses.Rows.Count > 0 Then
            For Each rowAddress In dsAgency.AgencyAddresses
                AddAddressRow(rowAddress.Address1, rowAddress.Address2, rowAddress.City, rowAddress.State, rowAddress.ZipCode, False, rowAddress.AgencyAddressID)
            Next
        Else
            'AddAddressRow("", "", "", "", "", False)
        End If

        'Phones
        If dsAgency.AgencyPhone.Rows.Count > 0 Then
            For Each rowAgencyPhone In dsAgency.AgencyPhone
                If rowAgencyPhone.GetChildRows("AgencyPhone_Phone").Length > 0 Then
                    rowPhone = CType(rowAgencyPhone.GetChildRows("AgencyPhone_Phone")(0), Lexxiom.BusinessData.AgencyDetail.PhoneRow)
                    If Not rowPhone Is Nothing Then AddPhoneRow(rowPhone.PhoneTypeID.ToString, rowPhone.AreaCode & rowPhone.Number, False, rowPhone.PhoneID)
                End If
            Next
        Else
            'AddPhoneRow("", "", False)
        End If

        'Child Agency Information
        If dsAgency.ChildAgency.Rows.Count > 0 Then
            For Each rowChildAgency In dsAgency.ChildAgency
                AddChildAgencyRow(rowChildAgency.Name, rowChildAgency.AgencyID)
            Next
        Else
            'AddChildAgencyRow("")
        End If

        '   'Bank Information
        If dsAgency.CommRec.Rows.Count > 0 Then
            For Each rowBank In dsAgency.CommRec
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
                Else
                    intCommRecAddressID = 0
                    strAddress1 = ""
                    strAddress2 = ""
                    strCity = ""
                    strState = ""
                    strZipcode = ""
                    strContact1 = ""
                End If

                Phones = rowBank.GetChildRows("CommRec_CommRecPhone")

                If Phones.Length > 0 Then
                    For Each rowRecPhone In Phones
                        intCommRecPhoneID = rowRecPhone.CommRecPhoneID
                        strPhone = rowRecPhone.PhoneNumber
                        Exit For 'UI currently only accounts for 1 phone per bank
                    Next
                Else
                    intCommRecPhoneID = 0
                    strPhone = ""
                End If

                If rowBank.IsBankNameNull() Then
                    strBankName = ""
                Else
                    strBankName = rowBank.BankName
                End If

                If rowBank.IsTypeNull() Then
                    strAcctType = ""
                Else
                    strAcctType = rowBank.Type
                End If

                If rowBank.IsRoutingNumberNull() Then
                    strRoutingNumber = ""
                Else
                    strRoutingNumber = rowBank.RoutingNumber
                End If

                If rowBank.IsAccountNumberNull() Then
                    strAccountNumber = ""
                Else
                    strAccountNumber = rowBank.AccountNumber
                End If


                If rowBank.Method Is Nothing Then
                    strMethod = ""
                Else
                    strMethod = rowBank.Method
                End If

                If rowBank.CommRecID < 0 Then
                    intCommRecID = 0
                Else
                    intCommRecID = rowBank.CommRecID
                End If

                Dim DisableCommRec As Boolean = objAgency.CommissionDependencies(intCommRecID)

                If DisableCommRec Then Me.ckIsCommRec.Enabled = False

                strAbbrev = rowBank.Abbreviation
                strDisplay = rowBank.Display

                AddAgencyBankingRow(strBankName, strAddress1, strAddress2, strCity, strState, strZipcode, strPhone, strAbbrev, strDisplay, strContact1, strRoutingNumber, strAccountNumber, strAcctType, strMethod, intCommRecID, intCommRecAddressID, intCommRecPhoneID, DisableCommRec)
            Next
        Else
            'AddAgencyBankingRow("", "", "", "", "", "", "", -1, "", "", "", "", "", -1, -1, -1, False)
        End If

    End Sub
#End Region

#Region "Add Rows"

#Region "AddAgentRow"
    Private Sub AddAgentRow(ByVal strFirstName As String, ByVal strLastName As String, Optional ByVal intAgentID As Integer = -1)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell
        Dim input As HtmlInputControl

        'Delete
        cell = New HtmlTableCell
        cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteAgent(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'FirstName
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strFirstName
        input.Style("width") = "150"
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Last Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strLastName
        input.Style("width") = "150"
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Hidden Fields
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "auto"
        cell.InnerHtml = "<input type='hidden' value='" & intAgentID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        tblAgent.Rows.Add(row)
    End Sub
#End Region

#Region "AddAddressRow"
    Private Sub AddAddressRow(ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strCity As String, ByVal strState As String, ByVal strZipcode As String, ByVal blnRequired As Boolean, Optional ByVal intAddressID As Integer = -1)
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

        'Address 1
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress1
        input.Style("width") = "150"
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Address 2
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress2
        input.Style("width") = "150"
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'City
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strCity
        input.Style("width") = "150"
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("width") = "150"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("width") = "55"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 50))
        row.Cells.Add(cell)

        'Zip
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Attributes("width") = "75"
        cell.Controls.Add(GetNewInputMask(strZipcode, "nnnnn-nnnn", 75))
        row.Cells.Add(cell)

        'Hidden Fields
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "auto"
        cell.InnerHtml = "<input type='hidden' value='" & intAddressID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        tblAddresses.Rows.Add(row)
    End Sub
#End Region

#Region "AddChildAgencyRow"
    Private Sub AddChildAgencyRow(ByVal strAgencyName As String, Optional ByVal intAgencyID As Integer = -1)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell

        'Delete
        cell = New HtmlTableCell
        cell.InnerHtml = "<a href=""#"" onclick=""Record_DeleteChildAgency(this);return false;""><img src=""" & ResolveUrl("~/images/16x16_delete.png") & """ border=""0"" align=""absmiddle""/></a>"
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'Name
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewDDL(ddlAgencies, intAgencyID.ToString, True))
        row.Cells.Add(cell)

        'Hidden Fields
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "<input type='hidden' value='" & intAgencyID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        tblChildAgency.Rows.Add(row)
    End Sub
#End Region

#Region "AddPhoneRow"
    Private Sub AddPhoneRow(ByVal strPhoneTypeID As String, ByVal strPhoneNo As String, ByVal blnRequired As Boolean, Optional ByVal intPhoneID As Integer = -1)
        Dim row As New HtmlTableRow
        Dim cell As HtmlTableCell

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
        cell.Controls.Add(GetNewDDL(ddlPhoneTypes, strPhoneTypeID, Not blnRequired))
        row.Cells.Add(cell)

        'Phone No
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(GetNewInputMask(strPhoneNo, "(nnn) nnn-nnnn", 85))
        row.Cells.Add(cell)

        'Hidden Fields
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "auto"
        cell.InnerHtml = "<input type='hidden' value='" & intPhoneID.ToString & "'><input type='hidden' value='N'>&nbsp;"
        row.Cells.Add(cell)

        tblPhones.Rows.Add(row)
    End Sub
#End Region

#Region "AddAgencyBankingRow"
    Private Sub AddAgencyBankingRow(ByVal strBankName As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strCity As String, ByVal strState As String, ByVal strZipcode As String, ByVal strPhone As String, ByVal strAbbrev As String, ByVal strDisplay As String, Optional ByVal strContact1 As String = "", Optional ByVal strRouting As String = "", Optional ByVal strAccountNo As String = "", Optional ByVal strType As String = "C", Optional ByVal strMethod As String = "ACH", Optional ByVal intCommRecID As Integer = -1, Optional ByVal intCommRecAddressID As Integer = -1, Optional ByVal intCommRecPhoneID As Integer = -1, Optional ByVal blnRequired As Boolean = True)
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
        cell.Style("width") = "16"
        row.Cells.Add(cell)

        'Bank Name
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strBankName
        cell = New HtmlTableCell
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Address 1
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strAddress1
        cell = New HtmlTableCell
        cell.Style("width") = "195"
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
        cell.Style("width") = "200"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'City
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strCity
        cell = New HtmlTableCell
        cell.Style("width") = "170"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'State
        cell = New HtmlTableCell
        cell.Width = "50"
        cell.Controls.Add(GetNewDDL(ddlStates, strState, 50))
        row.Cells.Add(cell)

        'Zip
        input = New HtmlControls.HtmlInputText("text")
        input.Style("width") = "75"
        input.Attributes("class") = "entry"
        input.Value = strZipcode
        cell = New HtmlTableCell
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Phone
        cell = New HtmlTableCell
        cell.Controls.Add(GetNewInputMask(strPhone, "(nnn) nnn-nnnn", 85))
        row.Cells.Add(cell)

        tblBanks.Rows.Add(row)

        '  **** ROW 2 ****

        row = New HtmlTableRow

        'Delete Flag & CommRecPhoneID
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "<input type='hidden' value='N'><input type='hidden' value='" & intCommRecPhoneID.ToString & "'>&nbsp;"
        row.Cells.Add(cell)

        'Display
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strDisplay
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Contact
        input = New HtmlControls.HtmlInputText("text")
        input.Attributes("class") = "entry"
        input.Value = strContact1
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "180"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Routing Number
        input = New HtmlControls.HtmlInputText("password")
        input.Attributes("class") = "entry"
        input.Value = strRouting
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "200"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Account Number
        input = New HtmlControls.HtmlInputText("password")
        input.Attributes("class") = "entry"
        input.Value = strAccountNo
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Style("width") = "170"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Checking?
        input = New HtmlControls.HtmlInputText("checkbox")
        input.Attributes("class") = "entry"
        If strType = "C" Then
            input.Attributes("checked") = "checked"
        End If
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'ACH?
        input = New HtmlControls.HtmlInputText("checkbox")
        input.Attributes("class") = "entry"
        If strMethod = "ACH" Then
            input.Attributes("checked") = "checked"
        End If
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.Controls.Add(input)
        row.Cells.Add(cell)

        'Abbreviation and ID
        cell = New HtmlTableCell
        cell.Attributes("class") = "listItem2"
        cell.InnerHtml = "<input type='text' class='entry' value='" & strAbbrev & "'/>" & "<input type='hidden' value='" & intCommRecID.ToString & "' />"
        row.Cells.Add(cell)

        tblBanks.Rows.Add(row)


    End Sub
#End Region

#End Region

#Region "GetNewDDL"
    Private Function GetNewDDL(ByVal ddlSource As DropDownList, ByVal SelectedValue As String, ByVal blnEnabled As Boolean) As DropDownList
        Dim ddl As New DropDownList
        Dim li, li2 As ListItem

        ddl.CssClass = "entry"
        ddl.Enabled = blnEnabled
        'ddl.Width = UI.WebControls.Unit.Pixel(Width)

        For Each li In ddlSource.Items
            li2 = New ListItem(li.Text, li.Value)
            ddl.Items.Add(li2)
        Next

        ListHelper.SetSelected(ddl, SelectedValue)

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

    
    Private Sub BuildPayFeesToInfo(ByVal rowAgency As Lexxiom.BusinessData.AgencyDetail.AgencyRow)
        Dim Agency As New Lexxiom.BusinessServices.Agency(AgencyID)
        Dim dtParents As DataTable = Agency.GetParents()
        If rowAgency.IsCommRec() Then
            If dtParents.Rows.Count > 0 Then
                Me.lblMultiFeesPaidTo.Text = rowAgency.Name & " (more...)"
                ShowMultiFeesPaidTo(True)
                PopulateFeesPaidToPanel(dtParents)
            Else
                Me.lblFeesPaidTo.Text = rowAgency.Name
                ShowMultiFeesPaidTo(False)
            End If
        Else
            If dtParents.Rows.Count = 0 Then
                ShowMultiFeesPaidTo(False)
                Me.lblFeesPaidTo.Text = "Not provided"
            Else
                If dtParents.Rows.Count = 1 Then
                    ShowMultiFeesPaidTo(False)
                    Me.lblFeesPaidTo.Text = dtParents.Rows(0)("Name")
                Else
                    ShowMultiFeesPaidTo(True)
                    Me.lblMultiFeesPaidTo.Text = dtParents.Rows(0)("Name") & " (more ...)"
                    dtParents.Rows.RemoveAt(0)
                    PopulateFeesPaidToPanel(dtParents)
                End If
            End If
        End If
    End Sub

    Private Sub PopulateFeesPaidToPanel(ByVal dt As DataTable)
        Dim dv As New DataView(dt)
        dv.Sort = "[Name] Asc"
        Dim ParentHtml As String = String.Empty
        For Each drv As DataRowView In dv
            ParentHtml &= Server.HtmlEncode(drv("Name")) & "<BR />"
        Next
        Me.DivFeesPaidTo.InnerHtml = ParentHtml
    End Sub

    Private Sub ShowMultiFeesPaidTo(ByVal show As Boolean)
        Me.lblFeesPaidTo.Visible = Not show
        Me.lblMultiFeesPaidTo.Visible = show
    End Sub

    <WebMethod()> _
    Public Shared Function GetCircularReference(ByVal AgencyId As Integer, ByVal ChildAgencyIdList As String) As String
        Dim Agency As New Lexxiom.BusinessServices.Agency(AgencyId)
        Dim Ids As String() = ChildAgencyIdList.Split("|")
        For Each s As String In Ids
            If Agency.IsCircularReference(Int32.Parse(s)) Then
                Return s
            End If
        Next
        Return String.Empty
    End Function

    <WebMethod()> _
    Public Shared Function UserNameExists(ByVal UserName As String) As Boolean
        Return UserHelper.Exists(UserName)
    End Function

End Class
