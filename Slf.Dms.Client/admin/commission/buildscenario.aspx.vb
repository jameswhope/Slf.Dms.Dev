Option Strict On

Imports System.Collections.Generic
Imports System.Data

Partial Class admin_commission_buildscenario
    Inherits System.Web.UI.Page

    Private objBusinessServ As Lexxiom.BusinessServices.Scenario
    Private userID As Integer

#Region "Page_Load"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNothing(objBusinessServ) Then
            objBusinessServ = New Lexxiom.BusinessServices.Scenario
        End If

        If rblFormat.SelectedItem.Text = "% of Total" Then
            objBusinessServ.format = Lexxiom.BusinessServices.Scenario.ScenarioFormat.PoT
        Else
            objBusinessServ.format = Lexxiom.BusinessServices.Scenario.ScenarioFormat.PoP
        End If

        If Not Page.IsPostBack Then
            SetAvailFeeTypes()
            InitPage()
            txtStartDate.Text = Format(DateAdd(DateInterval.Day, 1, Now), "M/d/yyyy")
            txtEndDate.Text = "1/1/2050"
        End If

        AddTasks()
    End Sub
#End Region

#Region "AddTasks"
    Private Sub AddTasks()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Assign();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Assign Scenario</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""comparescenario.aspx""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_scale.png") & """ align=""absmiddle""/>Compare Scenarios</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""../settings/references""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel</a>")
    End Sub
#End Region

#Region "InitPage"
    Private Sub InitPage()
        Dim objCompany As New Lexxiom.BusinessServices.Company

        ddlCompany.DataSource = objCompany.CompanyList(True)
        ddlCompany.DataTextField = "ShortCoName"
        ddlCompany.DataValueField = "CompanyID"
        ddlCompany.DataBind()

        ddlCommScenCompany.DataSource = objCompany.CompanyList
        ddlCommScenCompany.DataTextField = "ShortCoName"
        ddlCommScenCompany.DataValueField = "CompanyID"
        ddlCommScenCompany.DataBind()

        objCompany = Nothing
        LoadAgencys(-1)
    End Sub
#End Region

#Region "LoadAgencys"
    Private Sub LoadAgencys(ByVal intCompanyID As Integer)
        Dim objAgency As New Lexxiom.BusinessServices.Agency
        Dim tblAgencys As DataTable = objAgency.GetAgencyList(intCompanyID)
        Dim row As DataRow
        Dim li As ListItem

        cblAgency.Items.Clear()
        imgCheckAll.Alt = "Check All"
        imgCheckAll.Src = "~/images/11x11_checkall.png"

        For Each row In tblAgencys.Rows
            li = New ListItem
            li.Value = row("AgencyID").ToString
            If row("CommScenID") Is DBNull.Value Then
                li.Text = "<span style='padding-left: 5'>(" & row("AgencyID").ToString & ") " & Left(row("Name").ToString, 20) & "</span>"
            Else
                'Flag agencies that already have a scenario 
                li.Text = "<span style='color: blue; padding-left: 5'>(" & row("AgencyID").ToString & ") " & Left(row("Name").ToString, 20) & "</span>"
            End If
            cblAgency.Items.Add(li)
        Next

        objAgency = Nothing
    End Sub
#End Region

#Region "SetAvailFeeTypes"
    Private Sub SetAvailFeeTypes()
        Dim dsScenario As Data.DataSet
        Dim tblEntryTypes As Data.DataTable = objBusinessServ.EntryTypeList
        Dim row As Data.DataRow
        Dim rowsToDelete() As Data.DataRow
        Dim lstUsedFeeTypes As String = ""

        'Remove fee types that are already being used
        If Not IsNothing(Session("myScenario")) Then
            dsScenario = CType(Session("myScenario"), Data.DataSet)

            For Each row In dsScenario.Tables("tblTypes").Rows
                If lstUsedFeeTypes.Length = 0 Then
                    lstUsedFeeTypes = row("EntryTypeID").ToString
                Else
                    lstUsedFeeTypes &= "," & row("EntryTypeID").ToString
                End If
            Next

            If lstUsedFeeTypes.Length > 0 Then
                rowsToDelete = tblEntryTypes.Select("EntryTypeID in (" & lstUsedFeeTypes & ")")
                For Each row In rowsToDelete
                    row.Delete()
                Next
                tblEntryTypes.AcceptChanges()
            End If
        End If

        ddlFeeTypes.DataSource = tblEntryTypes
        ddlFeeTypes.DataTextField = "DisplayName"
        ddlFeeTypes.DataValueField = "EntryTypeID"
        ddlFeeTypes.DataBind()
    End Sub
#End Region

#Region "LoadScenario"
    Private Sub LoadScenario()
        Dim intCommScenID As Integer = CInt(ddlCommScen.SelectedItem.Value)
        Dim intCompanyID As Integer = CInt(ddlCommScenCompany.SelectedItem.Value)

        'If IsNumeric(Request.QueryString("s")) Then
        '    intCommScenID = CType(Request.QueryString("s"), Integer)
        'End If
        'If IsNumeric(Request.QueryString("c")) Then
        '    intCompanyID = CType(Request.QueryString("c"), Integer)
        'End If

        tdScenario.InnerHtml = objBusinessServ.LoadScenario(intCommScenID, intCompanyID)
        Session("myScenario") = objBusinessServ.dsScenario
    End Sub
#End Region

#Region "Click Events"

#Region "lnkAddRec_Click"
    Protected Sub lnkAddRec_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddRec.Click
        objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
        tdScenario.InnerHtml = objBusinessServ.BuildTreewAdd(hdnEntryTypeID.Value, hdnParentCommStructID.Value)
    End Sub
#End Region

#Region "lnkEditRec_Click"
    Protected Sub lnkEditRec_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEditRec.Click
        objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
        tdScenario.InnerHtml = objBusinessServ.BuildTreewEdit(hdnCommFeeID.Value)
    End Sub
#End Region

#Region "'lnkEditDeposit_Click"
    'Protected Sub lnkEditDeposit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEditDeposit.Click
    '    objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
    '    tdScenario.InnerHtml = objBusinessServ.BuildTreewEditDeposit()
    'End Sub
#End Region

#Region "'lnkEditMaster_Click"
    'Protected Sub lnkEditMaster_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEditMaster.Click
    '    objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
    '    tdScenario.InnerHtml = objBusinessServ.BuildTreewEditMaster()
    'End Sub
#End Region

#Region "lnkCancelAddEdit_Click"
    Protected Sub lnkCancelAddEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAddEdit.Click
        objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
        tdScenario.InnerHtml = objBusinessServ.BuildTree()
    End Sub
#End Region

#Region "'lnkSaveDeposit_Click"
    'Protected Sub lnkSaveDeposit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveDeposit.Click
    '    Dim dsScenario As Data.DataSet
    '    Dim row As DataRow

    '    If Not IsNothing(Session("myScenario")) Then
    '        dsScenario = CType(Session("myScenario"), Data.DataSet)

    '        row = dsScenario.Tables("tblRoot").Rows(0)
    '        row("ParentCommRecID") = hdnCommRecIDs.Value
    '        row("ParentCommRec") = hdnCommRec.Value
    '        row.AcceptChanges()

    '        objBusinessServ.dsScenario = dsScenario
    '        tdScenario.InnerHtml = objBusinessServ.BuildTree()
    '        trInfoBox.Visible = True
    '        lblInfoBox.Text = "Deposit account updated. [" & Now.ToString & "]"
    '    End If
    'End Sub
#End Region

#Region "'lnkSaveMaster_Click"
    'Protected Sub lnkSaveMaster_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveMaster.Click
    '    Dim dsScenario As Data.DataSet
    '    Dim row As DataRow
    '    Dim rowsToUpdate() As DataRow
    '    Dim commStructID As String

    '    If Not IsNothing(Session("myScenario")) Then
    '        dsScenario = CType(Session("myScenario"), Data.DataSet)

    '        row = dsScenario.Tables("tblRoot").Rows(0)
    '        row("CommRecID") = hdnCommRecIDs.Value
    '        row("CommRec") = hdnCommRec.Value
    '        commStructID = row("CommStructID").ToString
    '        row.AcceptChanges()

    '        'Updating the master account in the fees structure. Master account will only
    '        'exist in this table if they are also a fee recipient. Does not account for the
    '        'master account being nested, master account assumed to be top level.
    '        rowsToUpdate = dsScenario.Tables("tblFees").Select("CommStructID = " & commStructID)
    '        For Each row In rowsToUpdate
    '            row("CommRecID") = hdnCommRecIDs.Value
    '            row("CommRec") = hdnCommRec.Value
    '            row("CommRecFull") = hdnCommRec.Value
    '            row.AcceptChanges()
    '        Next

    '        objBusinessServ.dsScenario = dsScenario
    '        tdScenario.InnerHtml = objBusinessServ.BuildTree()
    '        trInfoBox.Visible = True
    '        lblInfoBox.Text = "Master account updated. [" & Now.ToString & "]"
    '    End If
    'End Sub
#End Region

#Region "lnkSaveRec_Click"
    Protected Sub lnkSaveRec_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveRec.Click
        Dim strCommRecIDs() As String = Split(hdnCommRecIDs.Value, "|")
        Dim strCommRec As String = hdnCommRec.Value
        Dim dsScenario As Data.DataSet
        Dim row As Data.DataRow
        Dim maxStructID As Integer = 1
        Dim maxFeeID As Integer = 1
        Dim found As Boolean

        If Not IsNothing(Session("myScenario")) Then
            If strCommRecIDs(1) <> "-1" And Val(hdnPercent.Value) > 0 Then
                dsScenario = CType(Session("myScenario"), Data.DataSet)

                For Each row In dsScenario.Tables("tblFees").Rows
                    If row("CommFeeID").ToString = hdnCommFeeID.Value Then
                        row("CommRecTypeID") = CType(strCommRecIDs(0), Integer)
                        row("CommRecID") = CType(strCommRecIDs(1), Integer)
                        row("CommRec") = hdnCommRec.Value
                        If rblFormat.SelectedItem.Text = "% of Total" Then
                            row("Percent") = (Val(hdnPercent.Value) / 100)
                        Else
                            row("PoP") = (Val(hdnPercent.Value) / 100)
                        End If
                        row("IsPercent") = 1 'will need to determine
                        row.AcceptChanges()
                        found = True
                        Exit For
                    End If

                    'Calculating in case we need to add a new row
                    If CType(row("CommStructID"), Integer) > maxStructID Then
                        maxStructID = CType(row("CommStructID"), Integer)
                    End If
                    If CType(row("CommFeeID"), Integer) > maxFeeID Then
                        maxFeeID = CType(row("CommFeeID"), Integer)
                    End If
                Next

                If Not found Then
                    'Add new fee recipient
                    row = dsScenario.Tables("tblFees").NewRow
                    row("EntryTypeID") = CType(hdnEntryTypeID.Value, Integer)
                    row("CommFeeID") = (maxFeeID + 1)
                    row("CommStructID") = (maxStructID + 1)
                    row("ParentCommStructID") = CType(hdnParentCommStructID.Value, Integer)
                    row("CommRecTypeID") = CType(strCommRecIDs(0), Integer)
                    row("CommRecID") = CType(strCommRecIDs(1), Integer)
                    row("CommRec") = hdnCommRec.Value
                    If rblFormat.SelectedItem.Text = "% of Total" Then
                        row("Percent") = (Val(hdnPercent.Value) / 100)
                    Else
                        row("PoP") = (Val(hdnPercent.Value) / 100)
                    End If
                    row("IsPercent") = 1 'will need to determine
                    dsScenario.Tables("tblFees").Rows.Add(row)
                End If

                objBusinessServ.dsScenario = dsScenario

                If rblFormat.SelectedItem.Text = "% of Total" Then
                    objBusinessServ.RecalcPoPs()
                Else
                    objBusinessServ.RecalcPoTs()
                End If

                tdScenario.InnerHtml = objBusinessServ.BuildTree()
            End If
        End If

    End Sub
#End Region

#Region "lnkCheckAll_Click"
    Protected Sub lnkCheckAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCheckAll.Click
        Dim li As ListItem
        Dim check As Boolean

        If imgCheckAll.Alt = "Check All" Then
            check = True
            imgCheckAll.Alt = "Uncheck All"
            imgCheckAll.Src = "~/images/11x11_uncheckall.png"
        Else
            imgCheckAll.Alt = "Check All"
            imgCheckAll.Src = "~/images/11x11_checkall.png"
        End If

        For Each li In cblAgency.Items
            li.Selected = check
        Next
    End Sub
#End Region

#Region "lnkRemoveFeeType_Click"
    Protected Sub lnkRemoveFeeType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveFeeType.Click
        Dim dsScenario As Data.DataSet
        Dim rowsToDelete() As DataRow
        Dim row As DataRow
        Dim strEntryType As String

        If Not IsNothing(Session("myScenario")) Then
            dsScenario = CType(Session("myScenario"), Data.DataSet)

            row = dsScenario.Tables("tblTypes").Rows.Find(hdnEntryTypeID.Value)
            strEntryType = row("EntryType").ToString
            row.Delete()

            rowsToDelete = dsScenario.Tables("tblFees").Select("EntryTypeID = " & hdnEntryTypeID.Value)
            For Each row In rowsToDelete
                row.Delete()
            Next

            dsScenario.Tables("tblTypes").AcceptChanges()
            dsScenario.Tables("tblFees").AcceptChanges()
            objBusinessServ.dsScenario = dsScenario
            tdScenario.InnerHtml = objBusinessServ.BuildTree()
            SetAvailFeeTypes()
            lblInfoBox.Text = strEntryType & " removed from commission scenario. [" & Now.ToString & "]"
            trInfoBox.Visible = True
        End If
    End Sub
#End Region

#Region "lnkRemoveRec_Click"
    Protected Sub lnkRemoveRec_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemoveRec.Click
        Dim dsScenario As Data.DataSet
        Dim rowsToDelete() As DataRow
        Dim row As DataRow
        Dim exists As Boolean = True

        If Not IsNothing(Session("myScenario")) Then
            dsScenario = CType(Session("myScenario"), Data.DataSet)

            rowsToDelete = dsScenario.Tables("tblFees").Select("CommFeeID = " & hdnCommFeeID.Value)
            For Each row In rowsToDelete
                RemoveRecs(dsScenario, row("EntryTypeID").ToString, row("CommStructID").ToString)
                row.Delete()
            Next

            dsScenario.Tables("tblFees").AcceptChanges()
            objBusinessServ.dsScenario = dsScenario
            tdScenario.InnerHtml = objBusinessServ.BuildTree()
            lblInfoBox.Text = "Fee recipient(s) removed. [" & Now.ToString & "]"
            trInfoBox.Visible = True
        End If
    End Sub

    Private Sub RemoveRecs(ByVal dsScenario As DataSet, ByVal entryTypeID As String, ByVal parentCommStructID As String)
        Dim childRow As DataRow
        Dim children() As DataRow

        children = dsScenario.Tables("tblFees").Select("EntryTypeID = " & entryTypeID & " and ParentCommStructID = " & parentCommStructID)
        For Each childRow In children
            RemoveRecs(dsScenario, childRow("EntryTypeID").ToString, childRow("CommStructID").ToString)
            childRow.Delete()
        Next
    End Sub
#End Region

#Region "lnkAssign_Click"
    Protected Sub lnkAssign_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAssign.Click
        Dim li As ListItem
        Dim intCompanyID As Integer
        Dim intAgencyID As Integer
        Dim intCount As Integer
        Dim intSelected As Integer

        If Not IsNothing(Session("myScenario")) Then
            objBusinessServ.dsScenario = CType(Session("myScenario"), DataSet)

            If objBusinessServ.ScenarioIsValid Then
                intCompanyID = CType(ddlCompany.SelectedItem.Value, Integer)

                'If CType(txtStartDate.Text, Date) > Now Then
                If intCompanyID > 0 Then
                    For Each li In cblAgency.Items
                        If li.Selected Then
                            intSelected += 1
                            intAgencyID = CType(li.Value, Integer)
                            If objBusinessServ.SaveScenario(intCompanyID, intAgencyID, userID, txtStartDate.Text, txtEndDate.Text, CInt(txtRetFrom.Text), CInt(txtRetTo.Text)) Then
                                intCount += 1
                            End If
                        End If
                    Next

                    If intCount > 0 Then
                        LoadAgencys(intCompanyID)
                        ScriptManager.RegisterStartupScript(Me, Me.GetType, "Message_Holder", "ShowMessageHolder('Assign Scenario', 'Assign scenario successful! " & intCount.ToString & " scenario(s) were saved.');", True)
                    ElseIf intSelected = 0 Then
                        trInfoBox.Visible = True
                        lblInfoBox.Text = "<span style='color: red'>Please select agency(s) to continue. No scenarios were created.</span>"
                    Else
                        trInfoBox.Visible = True
                        lblInfoBox.Text = "<span style='color: red'>No scenarios were created. Could not add new scenario(s) using the selected options.</span>"
                    End If
                Else
                    trInfoBox.Visible = True
                    lblInfoBox.Text = "<span style='color: red'>Please select a settlement attorney. Assign Scenario canceled.</span>"
                End If
                'Else
                '    trInfoBox.Visible = True
                '    lblInfoBox.Text = "<span style='color: red'>Start Date must be a future date. Assign scenario canceled.</span>"
                'End If
            Else
                trInfoBox.Visible = True
                lblInfoBox.Text = "<span style='color: red'>Please correct payouts for the fee types highlighted in red and make sure a deposit and master account are selected. Assign scenario canceled.</span>"
            End If
        Else
            trInfoBox.Visible = True
            lblInfoBox.Text = "<span style='color: red'>Session expired. Assign Scenario aborted.</span>"
        End If
    End Sub
#End Region

#End Region

#Region "SelectedIndexChanged Events"

#Region "rblFormat_SelectedIndexChanged"
    Protected Sub rblFormat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblFormat.SelectedIndexChanged
        If Not IsNothing(Session("myScenario")) Then
            If rblFormat.SelectedItem.Text = "% of Total" Then
                objBusinessServ.format = Lexxiom.BusinessServices.Scenario.ScenarioFormat.PoT
            Else
                objBusinessServ.format = Lexxiom.BusinessServices.Scenario.ScenarioFormat.PoP
            End If
            objBusinessServ.dsScenario = CType(Session("myScenario"), Data.DataSet)
            tdScenario.InnerHtml = objBusinessServ.BuildTree
        End If
    End Sub
#End Region

#Region "ddlCompany_SelectedIndexChanged"
    Protected Sub ddlCompany_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompany.SelectedIndexChanged
        'Step 1 - Assign deposit and master account
        If Not IsNothing(Session("myScenario")) And ddlCompany.SelectedIndex > 0 Then
            With objBusinessServ
                .dsScenario = CType(Session("myScenario"), Data.DataSet)
                .AssignDepositMaster(CInt(ddlCompany.SelectedItem.Value))
                tdScenario.InnerHtml = .BuildTree()
            End With
        End If

        'Step 2 - Highlight agencies with existing scenarios for the selected SA
        LoadAgencys(CType(ddlCompany.SelectedItem.Value, Integer))
    End Sub
#End Region

#Region "ddlFeeTypes_SelectedIndexChanged"
    Protected Sub ddlFeeTypes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFeeTypes.SelectedIndexChanged
        Dim dsScenario As Data.DataSet
        Dim row As Data.DataRow

        If Not IsNothing(Session("myScenario")) Then
            dsScenario = CType(Session("myScenario"), Data.DataSet)

            row = dsScenario.Tables("tblTypes").NewRow
            row("EntryTypeID") = ddlFeeTypes.SelectedItem.Value
            row("EntryType") = ddlFeeTypes.SelectedItem.Text
            dsScenario.Tables("tblTypes").Rows.Add(row)

            lblInfoBox.Text = ddlFeeTypes.SelectedItem.Text & " added to commission scenario. [" & Now.ToString & "]"
            trInfoBox.Visible = True
            objBusinessServ.dsScenario = dsScenario
            tdScenario.InnerHtml = objBusinessServ.BuildTree
            SetAvailFeeTypes()
        End If
    End Sub
#End Region

#End Region

    Protected Sub btnLoad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLoad.Click
        LoadScenario()
    End Sub
End Class
