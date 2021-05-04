Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Threading

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Lexxiom.X937.Creator
Imports System.Data.SqlClient

Partial Class admin_checkscan_Default
    Inherits PermissionPage

#Region "Fields"

    Public UserID As Integer

    Private _appList As New Hashtable 'keeps track of grid app/coapp groups
    Private chks As New List(Of ClientCheck)

#End Region 'Fields

#Region "Methods"
    Public Overrides Sub AddPermissionControls(c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pageContent, c, "Admin-Check Scan")
    End Sub
    Protected Sub ddlBatchType_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlBatchType.SelectedIndexChanged
        dsHistory.SelectParameters("batchstatus").DefaultValue = ddlBatchType.SelectedValue
    End Sub
    <Services.WebMethod()> _
    Public Shared Function ProcessBatches(ByVal batchids As String) As String
        Dim result As New StringBuilder

        Try
            Dim iProcessed As Integer = 0
            Dim totItems As Integer = 0
            Dim totAmt As Integer = 0
            Dim saveGuids As String() = batchids.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            For Each sg As String In saveGuids
                Dim ssql As String = "SELECT nc.Check21ID AS CheckID, nc.RegisterID, nc.ClientID, nc.CheckFrontPath AS frontimagepath, "
                ssql += "nc.CheckBackPath AS backimagepath, nc.CheckRouting AS routing, nc.CheckAccountNum[Account], nc.CheckAmount AS Amount, "
                ssql += "nc.CheckAuxOnus AS AuxOnUs, nc.CheckNumber, nc.CheckType, nc.CheckOnUs AS OnUs, nc.CheckRoutingCheckSum AS RoutingCheckSum, "
                ssql += "nc.CheckMicrLine AS MicrLine , verifiedby ,[verified] = cast(nc.verified as varchar)+ ' By ' + vu.firstname + ' ' + vu.lastname, "
                ssql += "[processed] = cast(nc.processed  as varchar)+ ' By ' + pu.firstname + ' ' + pu.lastname, nc.createdby, nc.epc  "
                ssql += "FROM tblICLChecks nc with(nolock) left join tbluser vu with(nolock) on vu.userid = nc.verifiedby "
                ssql += "left join tbluser pu with(nolock) on pu.userid = nc.verifiedby "
                ssql += "WHERE (nc.SaveGUID = @saveGUID) and (DeleteDate is null) and processed is null and CheckAmount > 0 and clientid <> -1"
                Dim params As New List(Of System.Data.SqlClient.SqlParameter)
                params.Add(New System.Data.SqlClient.SqlParameter("saveGUID", sg))

                Using dtChecks As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text, params.ToArray)
                    If dtChecks.Rows.Count > 0 Then
                        'result.Append(ProcessChecks(lst, sg))
                        Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                            For Each chk As DataRow In dtChecks.Rows
                                Dim dataClientID As Integer = chk("clientid").ToString
                                Dim checkIdToProcess As String = chk("checkID").ToString
                                Dim checkAmount As Double = chk("amount").ToString
                                Dim checkfrontpath As String = chk("frontimagepath").ToString
                                Dim checkbackpath As String = chk("backimagepath").ToString
                                Dim CheckRouting As String = chk("routing").ToString
                                Dim CheckAccountNum As String = chk("account").ToString
                                Dim CheckAuxOnus As String = chk("AuxOnUs").ToString
                                Dim CheckNumber As String = chk("CheckNumber").ToString
                                Dim CheckType As String = chk("CheckType").ToString
                                Dim CheckOnUs As String = chk("OnUs").ToString
                                Dim CheckRoutingCheckSum As String = chk("routingchecksum").ToString
                                Dim CheckMicrLine As String = chk("micrline").ToString
                                Dim verifiedByUserID As String = chk("verifiedby").ToString
                                Dim createdByUserID As String = chk("createdby").ToString
                                Dim regid As String = chk("registerid").ToString
                                Dim epc As String = chk("epc").ToString

                                If regid = -1 Then

                                    regid = RegisterHelper.InsertDeposit(dataClientID, Now, CheckNumber, "Check 21", checkAmount, 3, Now.AddDays(1), verifiedByUserID, verifiedByUserID)
                                    Dim chkID As Integer = icl.InsertCheck(regid, dataClientID, checkfrontpath, checkbackpath, CheckRouting, CheckAccountNum, checkAmount, CheckAuxOnus, CheckNumber, CheckType, CheckOnUs, CheckRoutingCheckSum, CheckMicrLine, verifiedByUserID, sg, epc, createdByUserID)

                                    Dim noteMSG As New StringBuilder
                                    noteMSG.AppendFormat("{0} #{1} Processed for {2} on {3}.", CheckType.ToString.ToUpper, CheckNumber, FormatCurrency(checkAmount, 2, TriState.False, TriState.False, TriState.True), Now.ToString)
                                    Dim nID As Integer = NoteHelper.InsertNote(noteMSG.ToString, verifiedByUserID, dataClientID)

                                    Try
                                        checkfrontpath = CopyToClientDocDirectory(dataClientID, checkfrontpath)
                                        checkbackpath = CopyToClientDocDirectory(dataClientID, checkbackpath)

                                        'attach check to client
                                        SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkfrontpath), verifiedByUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("client", dataClientID, Path.GetFileName(checkfrontpath), verifiedByUserID)
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkfrontpath), verifiedByUserID, Now)

                                        SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkbackpath), verifiedByUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("client", dataClientID, Path.GetFileName(checkbackpath), verifiedByUserID)
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkbackpath), verifiedByUserID, Now)

                                    Catch ex As Exception
                                        NoteHelper.InsertNote(String.Format("The following error occured attaching check to note : {0}", ex.Message.ToString), verifiedByUserID, dataClientID)
                                    End Try

                                    'remove check from batch so it wont get processed again
                                    icl.DeleteCheck(checkIdToProcess)
                                    totItems += 1
                                    totAmt += checkAmount
                                End If

                            Next

                            result.AppendFormat("<div class=""success"">Count : {0}<br/>Amount : {1}</div>", totItems, FormatCurrency(totAmt, 2))
                        End Using
                        iProcessed += 1

                    Else
                        result.Append("<div class=""warning"">No checks to process in this batch, possibly processed already!</div>")
                    End If
                End Using
                totItems = 0
                totAmt = 0
                iProcessed = 0
            Next
            If saveGuids.Length = 0 Then
                result.Append("<div class=""warning"">No Batch(es) Selected!</div>")
            End If
        Catch ex As Exception
            Return ex.Message.ToString
        End Try

        HttpContext.Current.Session("ProcessMsg") = result.ToString

        Return result.ToString
    End Function

    <Services.WebMethod()> _
    Public Shared Function AttachClientToCheck(ByVal dataclientid As String, ByVal currentcheckid As Integer) As String
        Try
            Dim sqlUp As New StringBuilder
            sqlUp.AppendFormat("UPDATE tblICLChecks SET clientid = {0} where check21id = {1}", dataclientid, currentcheckid)
            SharedFunctions.AsyncDB.executeScalar(sqlUp.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim lst As New List(Of String)
            lst.Add("Client Verified")
            lst.Add(ClientHelper.GetDefaultPersonName(dataclientid))

            Return jsonHelper.SerializeObjectIntoJson(lst)
        Catch ex As Exception
            Return ex.Message
        End Try
    End Function

    <Services.WebMethod()> _
    Public Shared Function CheckVerification(ByVal currentcheckid As Integer, routing As String, acctnum As String, amount As String, chknumber As String) As String
        Dim result As String = ""
        Try
            Dim sqlUpdate As String = "UPDATE tblICLChecks SET CheckRouting = @CheckRouting, CheckAccountNum = @CheckAccountNum, CheckAmount = @CheckAmount, "
            sqlUpdate += "CheckNumber = @CheckNumber, Verified = getdate(), VerifiedBy = @VerifiedBy "
            sqlUpdate += "WHERE (Check21ID = @checkid)"

            Dim uid As String = HttpContext.Current.User.Identity.Name.ToString

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("CheckRouting", routing))
            params.Add(New SqlParameter("CheckAccountNum", acctnum))
            params.Add(New SqlParameter("CheckAmount", amount))
            params.Add(New SqlParameter("CheckNumber", chknumber))
            params.Add(New SqlParameter("VerifiedBy", uid))
            params.Add(New SqlParameter("checkid", currentcheckid))
            SqlHelper.ExecuteNonQuery(sqlUpdate, CommandType.Text, params.ToArray)

            result = "Check Verified"

        Catch ex As Exception
            Return ex.Message
        End Try
        Return result
    End Function

    <Services.WebMethod()> _
    Public Shared Function PM_LoadChecks(ByVal userid As String) As String
        Dim result As String = "<div class=""info"">Checks loaded!!!<br/><a href=""Default.aspx"">Refresh History</a></div>"
        Dim dtNewChecks As DataTable = Nothing
        Dim newChecks As New List(Of ClientCheck)
        Dim folderRoot As String = ConfigurationManager.AppSettings("icl_DocumentPath").ToString.Replace("\", "\\")
        Dim tempFolder As String = String.Format("{0}\scanTemp\{1}\{2}\", folderRoot, Format(Now, "yyyyMMdd"), userid)
        Dim checksReady As New List(Of String)
        tempFolder = tempFolder.Replace("\\", "\")
        Try
            If Directory.Exists(tempFolder) = False Then
                Directory.CreateDirectory(tempFolder)
            End If
            Dim scannedChecks As String() = Directory.GetFiles(tempFolder, "PreFormat_ClientCheck_*.tif")

            For Each check As String In scannedChecks
                If Not BatchExists(check) Then
                    Dim fInfo As FileInfo = New FileInfo(check)
                    If (fInfo.Attributes And FileAttributes.Archive) = FileAttributes.Archive Then
                        checksReady.Add(check)
                    End If
                Else
                    File.Move(check, check.Replace("PreFormat", "Processed"))
                End If
            Next
            If checksReady.Count > 0 Then
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    For Each check As String In checksReady
                        Dim fInfo As FileInfo = New FileInfo(check)
                        newChecks.AddRange(icl.ExtractAllChecks(check))
                    Next
                    'SaveDeposit
                    If newChecks.Count > 0 Then
                        dtNewChecks = icl.ConvertList2DataTable(newChecks)
                        Dim saveID As String = Guid.NewGuid.ToString
                        For Each row As DataRow In dtNewChecks.Rows
                            'save deposit
                            icl.SaveCheck(-1, row("clientid").ToString, row("frontimagepath").ToString, row("backimagepath").ToString, row("routing").ToString, row("account").ToString, row("amount").ToString, row("AuxOnUs").ToString, row("CheckNumber").ToString, row("CheckType").ToString, row("OnUs").ToString, row("routingchecksum").ToString, row("micrline").ToString, userid, row("epc").ToString, saveID)
                        Next
                    End If

                End Using
            Else
                result = "<div class=""info"">No checks found!<br/><a href=""#"" onclick=""this.parentElement.style.display='none';"" style=""float:right; padding-top:10px"" >[close]</a></div>"
            End If

            For Each check As String In scannedChecks
                If Not BatchExists(check) Then
                    Try
                        File.Move(check, check.Replace("PreFormat", "Processed"))
                    Catch ex As Exception
                        Continue For
                    End Try
                End If
            Next

        Catch ex As Exception
            Dim errMsg As String = ex.Message.ToString
            If Not IsNothing(ex.InnerException) Then
                errMsg += vbCrLf & ex.InnerException.ToString
            End If
            errMsg += vbCrLf & ex.StackTrace
            result = String.Format("<div style=""width:200px!important;"" class=""error"">ProcessChecks:{0}</div>", errMsg)
        End Try

        Return result
    End Function
    Public Shared Function BatchExists(ByVal checkpath As String) As Boolean
        Dim checkName As String = Path.GetFileNameWithoutExtension(checkpath).Replace("PreFormat_", "")
        Dim ssql As String = String.Format("select count(*) from tblICLChecks where CheckFrontPath LIKE '%{0}%'", checkName)
        Dim iCnt As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)
        If iCnt > 0 Then
            BatchExists = True
        Else
            BatchExists = False
        End If
    End Function



    ''' <summary>
    ''' set gridview pager buttons
    ''' </summary>
    ''' <param name="gridView"></param>
    ''' <param name="gvPagerRow"></param>
    ''' <param name="page"></param>
    ''' <remarks></remarks>
    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                Select Case gv.ID.ToLower
                    Case "gvunverified"
                        'LoadChecks()
                        gv.DataBind()
                    Case "gvsearch"
                        gv.DataBind()

                End Select
            End If
        End Using
    End Sub

    Protected Sub admin_checkscan_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Drg.Util.DataAccess.DataHelper.Nz_int(Page.User.Identity.Name)

        'initiate ICL object
        If Not IsPostBack Then
            'get checks in clientstorage\scantemp\yyyymmdd\userid
            ClearMsgBoxes()
            Dim loadCheckScript As String = "showMsg(loadingImg);getChecks();"

            ClientScript.RegisterStartupScript(Me.GetType, "loadchecks", loadCheckScript, True)

            BuildHistoryGrid()

        End If



        If IsNothing(ViewState("searchTerm")) Then
            BuildSearchHistoryGrid(Nothing)
        Else
            BuildSearchHistoryGrid(ViewState("searchTerm").ToString)
        End If

        ComputeResults()

        SetRollups()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        'find client for check
        dsSearch.SelectParameters("searchTerm").DefaultValue = txtClient.Text
        dsSearch.DataBind()
        gvSearch.DataBind()
    End Sub

    Protected Sub dsUnverified_Updated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsUnverified.Updated
        ComputeResults()
    End Sub

    Protected Sub gvHistorySearch_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvHistorySearch.RowCommand
        Select Case e.CommandName.ToLower
            Case "selectclientcheck"
                LoadCheck(e.CommandArgument)
        End Select
    End Sub

    Protected Sub gvHistorySearch_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistorySearch.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End Select
    End Sub

    Protected Sub gvHistory_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvHistory.RowCommand
        Select Case e.CommandName.ToLower
            Case "delete"
                dsHistory.DeleteParameters("SaveID").DefaultValue = e.CommandArgument
                dsUnverified.DataBind()
                gvUnverified.DataBind()
            Case "select"
                Dim saveStr As String = gvHistory.DataKeys(e.CommandArgument).Item(0).ToString 'e.CommandArgument
                LoadChecks(saveStr)
                ClearMsgBoxes()

            Case "selectclientcheck"
                LoadCheck(e.CommandArgument)
        End Select
    End Sub

    Protected Sub gvHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistory.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim totProc As Integer = rowView("Total Processed").ToString
                Dim totItms As Integer = rowView("totalitems").ToString
                Dim totAmt As Integer = rowView("totalamt").ToString
                Dim totVer As Integer = rowView("Total Verified Clients").ToString
                Dim totVerCnt As Integer = rowView("Total Verified Count").ToString

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                For icell As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(icell).Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + e.Row.RowIndex.ToString))
                Next

                If totProc = totVer And totProc > 0 Then
                    e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#98FB98")
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#548B54';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#98FB98';")
                    e.Row.ToolTip = "Checks have been processed!"
                End If

                If totItms = totVer And totProc = 0 Then
                    EmailHelper.SendMessage("LexxCheck@lexxiom.com", "ccastelo@lexxiom.com", _
                                            "ICL CHECK(S) READY FOR PROCESSING", _
                                            String.Format("'{0}' has been processed and has {1} checks totalling {2} ready for the ICL process.", rowView("saveguid").ToString, totItms, FormatCurrency(totAmt, 2, TriState.False, TriState.False, TriState.True)))
                End If

        End Select
    End Sub

    Protected Sub gvSearch_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSearch.RowCreated
        If e.Row.RowType = DataControlRowType.Pager Then
            SetPagerButtonStates(gvSearch, e.Row, Me.Page)
        End If
    End Sub

    Protected Sub gvSearch_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSearch.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'add highlight/hand
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                'get row underlying data
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                'store acct number in link button
                Dim acctnum As String = rowView("accountnumber").ToString
                Using lnk As LinkButton = e.Row.FindControl("lnkAddToCheck")
                    lnk.Attributes.Add("clientLinkID", rowView("clientid").ToString)
                    If gvUnverified.DataKeys.Count > 0 Then
                        Dim chkID As String = gvUnverified.DataKeys(0).Value.ToString
                        lnk.OnClientClick = String.Format("return AttachClient({0},{1});", rowView("clientid").ToString, chkID)
                    End If
                End Using





                'format ssn
                Using lbl As Label = e.Row.FindControl("SSNLabel")
                    Dim theSSN As String = rowView("ssn").ToString
                    lbl.Text = String.Format("{0:000-00-0000}", theSSN)
                End Using

                ''show treeview image for expansion
                If _appList.Contains(acctnum) = True Then
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", acctnum, e.Row.RowIndex))
                    Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                    imgTree.Visible = False
                    e.Row.Style("display") = "none"
                    For Each tc As TableCell In e.Row.Cells
                        tc.BorderStyle = BorderStyle.None
                    Next
                    'e.Row.Cells(7).Controls.Clear()
                Else
                    _appList.Add(acctnum, Nothing)
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", acctnum))
                    Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                    If Val(rowView("NumCoApps").ToString) > 0 Then
                        imgTree.Attributes.Add("onclick", "toggleDocument('" & acctnum & "','" & gvSearch.ClientID & "');")
                        For Each tc As TableCell In e.Row.Cells
                            tc.BorderStyle = BorderStyle.None
                        Next
                    Else
                        imgTree.Visible = False
                    End If
                End If
            Case DataControlRowType.Header

        End Select
    End Sub

    Protected Sub gvUnverified_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvUnverified.PageIndexChanging
        gvUnverified.PageIndex = e.NewPageIndex
    End Sub

    Protected Sub gvUnverified_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles gvUnverified.RowCancelingEdit
        gvUnverified.EditIndex = -1
    End Sub

    Protected Sub gvUnverified_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvUnverified.RowCommand
        Select Case e.CommandName.ToLower
            Case "switch"
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                    AddHandler icl.ICL_Error, AddressOf icl_ICL_Error
                    Dim cID As Integer = e.CommandArgument
                    'swap images get new info
                    icl.SwapCheckImage(cID)
                End Using
                gvUnverified.DataBind()
            Case "deletecheck"
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    icl.DeleteCheck(e.CommandArgument)
                End Using
                gvUnverified.DataBind()
            Case "removecheck"
                Dim ssql As String = String.Format("update tbliclchecks set SaveGuid = '{0}' where check21id = {1}", Guid.NewGuid.ToString, e.CommandArgument)
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                gvUnverified.DataBind()
                dsHistory.DataBind()
                gvHistory.DataBind()
            Case "removecheckinfo".ToLower
                Dim ssql As String = String.Format("update tbliclchecks set clientid = -1, Verified = null,VerifiedBy = null, checkamount = 0 where check21id = {0}", e.CommandArgument)
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                gvUnverified.DataBind()
        End Select
    End Sub

    Protected Sub gvUnverified_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUnverified.RowCreated
        If e.Row.RowType = DataControlRowType.Pager Then
            SetPagerButtonStates(gvUnverified, e.Row, Me.Page)
        End If
    End Sub

    Protected Sub gvUnverified_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvUnverified.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim chkAmt As String = FormatNumber(rowView("amount").ToString.PadLeft(10, "0"), 2, TriState.True, TriState.False, TriState.True)
                Dim lblAmt As Label = e.Row.FindControl("lblAmount")
                Dim divChkVerified As HtmlGenericControl = e.Row.FindControl("dvCheckStatus")
                Dim divChkClientAdded As HtmlGenericControl = e.Row.FindControl("dvClientStatus")

                If Not IsNothing(lblAmt) Then
                    lblAmt.Text = chkAmt
                Else
                    Dim txtAmt As TextBox = e.Row.FindControl("txtAmount")
                    txtAmt.Text = chkAmt
                    txtAmt.Focus()
                    txtAmt.Attributes.Add("onfocusin", " select();")
                End If
                'display verified status
                If Val(chkAmt.Replace("$", "").Replace(",", "")) > 0 Then
                    e.Row.Attributes.Add("verified", "True")
                    divChkVerified.Attributes("class") = "success"
                    divChkVerified.InnerHtml = "Amount Verified"
                Else
                    divChkVerified.Attributes("class") = "error"
                    divChkVerified.InnerHtml = "Amount Not Verified"
                End If

                'get client name
                Dim cID As Integer = rowView("Clientid")
                Dim lblName As Label = e.Row.FindControl("lblClientName")
                If cID <> -1 Then
                    divChkClientAdded.Attributes("class") = "success"
                    divChkClientAdded.InnerHtml = "Client Verified"
                    lblName.Text = ClientHelper.GetDefaultPersonName(cID)
                Else
                    divChkClientAdded.Attributes("class") = "error"
                    divChkClientAdded.InnerHtml = "Client Not Verified"
                End If
        End Select
    End Sub

    Protected Sub gvUnverified_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles gvUnverified.RowEditing
        gvUnverified.EditIndex = e.NewEditIndex
    End Sub

    Protected Sub gvUnverified_RowUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdatedEventArgs) Handles gvUnverified.RowUpdated
        txtClient.Focus()
        txtClient.Attributes.Add("onfocusin", " select();")
    End Sub

    Protected Sub gvUnverified_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles gvUnverified.RowUpdating
        Try
            Dim dks As DataKeyArray = gvUnverified.DataKeys()
            Dim lblId As Label = gvUnverified.Rows(e.RowIndex).FindControl("lblCheckID")            'get check 21 id
            Dim txtAmt As TextBox = gvUnverified.Rows(e.RowIndex).FindControl("txtAmount")          'get amt
            Dim txtRouting As TextBox = gvUnverified.Rows(e.RowIndex).FindControl("txtRouting")     'get routing
            Dim txtAcct As TextBox = gvUnverified.Rows(e.RowIndex).FindControl("txtAccount")        'get acct
            Dim txtChkNo As TextBox = gvUnverified.Rows(e.RowIndex).FindControl("txtCheckNumber")        'get check number
            Dim lblVer As Label = gvUnverified.Rows(e.RowIndex).FindControl("lblVerified")        'get verified

            dsUnverified.UpdateParameters("checkid").DefaultValue = dks(e.RowIndex).Value.ToString
            dsUnverified.UpdateParameters("CheckRouting").DefaultValue = txtRouting.Text.Replace("*", "").ToString
            dsUnverified.UpdateParameters("CheckAccountNum").DefaultValue = txtAcct.Text.Replace("*", "").ToString
            dsUnverified.UpdateParameters("CheckNumber").DefaultValue = txtChkNo.Text.Replace("*", "").ToString
            Dim chkAmt As Double = txtAmt.Text.Replace("$", "").Replace(",", "").ToString
            dsUnverified.UpdateParameters("CheckAmount").DefaultValue = chkAmt
            If lblVer.Text = "" And chkAmt > 0 Then
                dsUnverified.UpdateParameters("Verified").DefaultValue = Now.ToString
                dsUnverified.UpdateParameters("VerifiedBy").DefaultValue = UserID
            End If

            dsUnverified.Update()

        Catch ex As Exception
            ShowError(ex)
        End Try

        gvUnverified.EditIndex = -1
        'LoadChecks()
    End Sub

    Protected Sub icl_ICL_Action(ByVal ActionSource As String, ByVal ActionMsg As String)
        ShowMsg(String.Format("{0} : {1}", ActionSource, ActionMsg), "warning")
    End Sub

    Protected Sub icl_ICL_Error(ByVal ErrorSource As String, ByVal ErrorMsg As String)
        ShowError(New Exception(String.Format("{0} : {1}", ErrorSource, ErrorMsg)))
    End Sub

    Protected Sub lnkAddClientToCheck_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Using lnk As LinkButton = TryCast(sender, LinkButton)
            Dim cID As Integer = gvUnverified.DataKeys(0).Value
            Dim dcID As Integer = lnk.Attributes("clientLinkID").ToString
            AddClientToCheck(dcID, cID)

            Dim lblName As Label = gvUnverified.Rows(0).FindControl("lblClientName")
            Dim divName As HtmlGenericControl = gvUnverified.Rows(0).FindControl("dvClientStatus")
            divName.InnerHtml = "Client Verified"
            'divName.Style("display") = "none"

            If dcID <> -1 Then
                lblName.Text = ClientHelper.GetDefaultPersonName(dcID)

                Dim lblAmt As Label = gvUnverified.Rows(0).FindControl("lblAmount")
                If Double.Parse(lblAmt.Text) > 0 Then
                    ShowMsg(String.Format("<br/>{0} attached to check!", lblName.Text), "info")
                    Dim iMoveNextPage As Integer = gvUnverified.PageIndex + 1
                    If iMoveNextPage < gvUnverified.PageCount Then
                        gvUnverified.PageIndex = gvUnverified.PageIndex + 1
                        gvUnverified.EditIndex = 0
                    End If

                End If
            End If

        End Using
    End Sub

    Protected Sub lnkClearHistorySearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearDepositHistorySearch.Click
        txtDepositSearch.Text = ""
        ViewState("searchTerm") = Nothing
        BuildSearchHistoryGrid(Nothing)
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        dsSearch.SelectParameters("searchTerm").DefaultValue = Nothing
        dsSearch.DataBind()
        gvSearch.DataBind()
    End Sub

    Protected Sub lnkSaveDeposit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveDeposit.Click
        SaveDeposit()
    End Sub

    Protected Sub lnkSearchHistory_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchDepositHistory.Click
        ViewState("searchTerm") = txtDepositSearch.Text
        BuildSearchHistoryGrid(txtDepositSearch.Text)
    End Sub

    Protected Sub lnkSwap_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    End Sub

    Private Sub AddClientToCheck(ByVal DataClientID As String, ByVal CurrentCheckID As Integer)
        Try
            Dim sqlUp As New StringBuilder
            sqlUp.AppendFormat("UPDATE tblICLChecks SET clientid = {0} where check21id = {1}", DataClientID, CurrentCheckID)
            SharedFunctions.AsyncDB.executeScalar(sqlUp.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)

        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub BuildHistoryGrid()
        'gvHistory.Columns.Clear
        Dim colList As String() = "SaveGUID,CreatedBy,Created,Total Verified Clients,Total Verified Count,Total Verified Amt,Total Processed,Total Processed Amt,Total ICL Processed,Total ICL Processed Amt,TotalItems,TotalAmt".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

        For Each col As String In colList
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "headItem5"
            bc.ItemStyle.CssClass = "listItem"
            bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
            Dim colName As String = col
            bc.DataField = col
            Select Case col.ToLower
                Case "CreatedBy".ToLower
                    colName = "Scanned By"
                    bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
                    bc.ItemStyle.HorizontalAlign = HorizontalAlign.Left
                    bc.ItemStyle.Width = 200
                Case "saveguid"
                    bc.Visible = False
                Case "totalamt"
                    colName = "Total Amt"
                    bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
                    bc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                Case "Total Verified Amt".ToLower, "Total Processed Amt".ToLower, "Total ICL Processed Amt".ToLower
                    bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Right
                    bc.ItemStyle.HorizontalAlign = HorizontalAlign.Right
                Case "totalitems"
                    colName = "Total Items"
            End Select
            If col.Contains("Amt") Then
                bc.DataFormatString = "{0:c2}"
            End If
            bc.HeaderStyle.Wrap = True
            bc.HtmlEncode = False
            bc.HeaderText = colName.Replace("Processed", "<br>Processed").Replace("Verified", "Verified<br>")
            'gvHistory.Columns.Add(bc)
        Next

        Dim tf As New TemplateField
        tf.ShowHeader = True
        tf.HeaderStyle.CssClass = "headItem5"
        tf.ItemStyle.CssClass = "listItem"
        tf.ItemStyle.HorizontalAlign = HorizontalAlign.Center
        tf.HeaderTemplate = New DepositHistoryTemplate(ListItemType.Header)
        tf.ItemTemplate = New DepositHistoryTemplate(ListItemType.Item)
        'gvHistory.Columns.Add(tf)

        'Dim sqlHistory As String = "stp_CheckScan_LoadHistory"
        'dsHistory.SelectCommand = sqlHistory
        dsHistory.DataBind()
        gvHistory.DataBind()
    End Sub

    Private Sub BuildSearchHistoryGrid(ByVal searchTerm As String)
        gvHistorySearch.Columns.Clear()
        Dim colList As String() = "Check21ID,Client Name,Check Amt,Verified,Verified By,Processed,Processed By".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

        For Each col As String In colList
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "headItem5"
            bc.ItemStyle.CssClass = "listItem"
            Dim colName As String = col
            bc.DataField = col
            Select Case col.ToLower
                Case "check21id"
                    bc.Visible = False
            End Select
            If col.Contains("Amount") Or col.Contains("Amt") Then
                bc.DataFormatString = "{0:c2}"
            End If
            bc.DataField = col
            bc.HeaderText = colName
            gvHistorySearch.Columns.Add(bc)
        Next

        Dim tf As New TemplateField
        tf.ShowHeader = True
        tf.HeaderStyle.CssClass = "headItem5"
        tf.ItemStyle.CssClass = "listItem"
        tf.ItemStyle.HorizontalAlign = HorizontalAlign.Center
        tf.HeaderTemplate = New DepositSearchHistoryTemplate(ListItemType.Header)
        tf.ItemTemplate = New DepositSearchHistoryTemplate(ListItemType.Item)
        gvHistorySearch.Columns.Add(tf)

        Dim sqlHistory As String = ""
        If Not IsNothing(searchTerm) Then
            sqlHistory = String.Format("stp_CheckScan_DepositHistorySearch '{0}'", searchTerm)
        Else
            sqlHistory = "stp_CheckScan_DepositHistorySearch '*'"

        End If
        dsHistorySearch.SelectCommand = sqlHistory
        dsHistorySearch.DataBind()
        gvHistorySearch.DataBind()
    End Sub

    Private Sub ClearMsgBoxes()
        dvMsg.Style("display") = "none"
        dvMsg.InnerHtml = ""
        'divError.Style("display") = "none"
        'divError.InnerHtml = ""
    End Sub

    Private Sub ComputeResults()
        Using dv As DataView = dsUnverified.Select(DataSourceSelectArguments.Empty)
            Dim dtChecks As DataTable = dv.Table

            Dim loadMSG As New StringBuilder
            Dim iTotalScannedChecks As Integer = dtChecks.Rows.Count
            Dim iTotalVerifiedItems As Integer = dtChecks.Compute("Count(CheckID)", "verified is not null")
            Dim sTotalVerifiedAmount As String = FormatCurrency(IIf(IsDBNull(dtChecks.Compute("Sum(amount)", "amount > 0 and verified is not null")), 0, dtChecks.Compute("Sum(amount)", "amount > 0 and verified is not null")), 2)
            Dim iTotalVerifiedItemsWithClient As Integer = IIf(IsDBNull(dtChecks.Compute("Count(CheckID)", "amount > 0 and clientid <> -1")), 0, dtChecks.Compute("Count(CheckID)", "amount > 0 and clientid <> -1 and verified is not null"))
            Dim sTotalVerifiedAmountWithClient As String = FormatCurrency(IIf(IsDBNull(dtChecks.Compute("Sum(amount)", "amount > 0 and clientid <> -1 and verified is not null")), 0, dtChecks.Compute("Sum(amount)", "amount > 0 and clientid <> -1 and verified is not null")), 2)
            Dim iTotalUnverifiedItems As Integer = dtChecks.Compute("Count(CheckID)", "verified is null")

            loadMSG.Append("<table class=""entry"" style=""border:solid 1px #4791C5;"" cellpadding=""0"" cellspacing=""0"">")

            loadMSG.Append("<tr><td class=""totHdr"">Total Scanned Checks</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", iTotalScannedChecks)

            loadMSG.Append("<tr><td class=""totHdr"">Total Verified Items</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", iTotalVerifiedItems)

            loadMSG.Append("<tr><td class=""totHdr"">Total Verified Amount</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", sTotalVerifiedAmount)

            loadMSG.Append("<tr><td class=""totHdr"">Total Verified Items w/ Client</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", iTotalVerifiedItemsWithClient)

            loadMSG.Append("<tr><td class=""totHdr"">Total Verified Amount w/ Client</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", sTotalVerifiedAmountWithClient)

            loadMSG.Append("<tr><td class=""totHdr"">Total Scanned Checks</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", iTotalScannedChecks)

            loadMSG.Append("<tr><td class=""totHdr"">Total Unverified Items</td></tr>")
            loadMSG.AppendFormat("<tr><td class=""totCnt"">{0}</td></tr>", iTotalUnverifiedItems)

            loadMSG.Append("</table>")

            Dim newLit As New LiteralControl(loadMSG.ToString)
            If pnlResultsContent.Controls.Count > 1 Then
                pnlResultsContent.Controls.RemoveAt(0)
            End If
            pnlResultsContent.Controls.AddAt(0, newLit)
        End Using
    End Sub

    Public Shared Function CopyToClientDocDirectory(ByVal dataClientID As Integer, ByVal fileToMovePath As String) As String
        Dim clientPath As String = SharedFunctions.DocumentAttachment.CreateDirForClient(dataClientID)
        Dim newPath As String = String.Format("{0}ClientDocs\{1}.tif", clientPath, Path.GetFileNameWithoutExtension(SharedFunctions.DocumentAttachment.GetUniqueDocumentName("C1001", dataClientID)))
        File.Copy(fileToMovePath, newPath, True)
        Return newPath
    End Function

    Private Function IsManager(ByVal UserID As Integer) As Boolean
        Dim ssql As String = String.Format("Select isnull(Manager,0)[IsManager] from tbluser where userid = {0}", UserID)
        Return SqlHelper.ExecuteScalar(ssql, CommandType.Text)
    End Function

    Private Sub LoadCheck(ByVal Check21ID As String)
        Try
            Dim sql As New StringBuilder
            sql.Append("SELECT nc.Check21ID AS CheckID, nc.RegisterID, nc.ClientID, nc.CheckFrontPath AS frontimagepath, ")
            sql.Append("nc.CheckBackPath AS backimagepath, nc.CheckRouting AS routing, nc.CheckAccountNum[Account], nc.CheckAmount AS Amount, nc.CheckAuxOnus AS AuxOnUs, ")
            sql.Append("nc.CheckNumber, nc.CheckType, nc.CheckOnUs AS OnUs, nc.CheckRoutingCheckSum AS RoutingCheckSum, nc.CheckMicrLine AS MicrLine ")
            sql.Append(",[verified] = cast(nc.verified as varchar)+ ' By ' + vu.firstname + ' ' + vu.lastname,[processed] = cast(nc.processed  as varchar)+ ' By ' + pu.firstname + ' ' + pu.lastname ")
            sql.Append("FROM tblICLChecks nc with(nolock) left join tbluser vu with(nolock) on vu.userid = nc.verifiedby left join tbluser pu with(nolock) on pu.userid = nc.verifiedby ")
            sql.AppendFormat("WHERE (nc.Check21ID = '{0}')", Check21ID)

            dsUnverified.SelectCommand = sql.ToString
            dsUnverified.DataBind()
            gvUnverified.DataBind()

        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub LoadChecks()
        Try
            Dim tempFolder As String = String.Format("\\Lex-dev-30\ClientStorage\scanTemp\{0}\{1}\", Format(Now, "yyyyMMdd"), UserID)
            If Directory.Exists(tempFolder) = False Then
                Directory.CreateDirectory(tempFolder)
            End If
            Dim scannedChecks As String() = Directory.GetFiles(tempFolder, "PreFormat_ClientCheck_*.tif")
            If scannedChecks.Length > 0 Then
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                    AddHandler icl.ICL_Error, AddressOf icl_ICL_Error
                    Dim dtChecks As DataTable = Nothing
                    For Each check As String In scannedChecks
                        chks.AddRange(icl.ExtractAllChecks(check))
                    Next
                    If chks.Count > 0 Then
                        dtChecks = icl.ConvertList2DataTable(chks)
                        ViewState("checkData") = dtChecks
                    End If
                    If tempFolder <> "" Then
                        'SaveDeposit()
                        For Each check As String In scannedChecks
                            File.Move(check, check.Replace("PreFormat", "processed_PreFormat"))
                            'File.Delete(check)
                        Next
                    End If
                    If Not IsNothing(dtChecks) Then
                        dtChecks.Dispose()
                        gvUnverified.DataSourceID = Nothing
                        gvUnverified.DataSource = TryCast(ViewState("checkData"), DataTable)
                        gvUnverified.DataBind()
                        ComputeResults()
                    End If

                End Using
            End If

        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub LoadChecks(ByVal saveID As String)
        Try
            dsUnverified.SelectParameters("saveguid").DefaultValue = saveID
            dsUnverified.SelectParameters("bunverifiedonly").DefaultValue = IIf(chkOnlyUnverified.Checked = True, 1, 0)
            dsUnverified.DataBind()
            gvUnverified.DataBind()

            ComputeResults()

        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub LoadChecks(ByVal checksPath As String, ByVal filterType As String)
        Try
            Dim scannedChecks As String() = Directory.GetFiles(checksPath, filterType)
            If scannedChecks.Length > 0 Then
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                    AddHandler icl.ICL_Error, AddressOf icl_ICL_Error
                    Dim dtChecks As DataTable = Nothing
                    For Each check As String In scannedChecks
                        'chks.AddRange(icl.ExtractAllChecks(check))
                        chks.Add(icl.ExtractSingleCheckInfo(check, check.Replace("f0", "b0")))
                    Next
                    If chks.Count > 0 Then
                        dtChecks = icl.ConvertList2DataTable(chks)
                        ViewState("checkData") = dtChecks
                    End If

                    Dim importedPath As String = String.Format("{0}\imported", Path.GetDirectoryName(checksPath))
                    If Not Directory.Exists(importedPath) Then
                        Directory.CreateDirectory(importedPath)
                    End If

                    'SaveDeposit()
                    'For Each check As String In scannedChecks
                    '    File.Move(check, String.Format("{0}\{1}", importedPath, check.Replace(".tif", "_processed.tif")))
                    '    File.Move(check.Replace("f0", "b0"), String.Format("{0}\{1}", importedPath, Path.GetFileName(check.Replace("f0", "b0").Replace(".tif", "_processed.tif"))))
                    'Next

                    If Not IsNothing(dtChecks) Then
                        dtChecks.Dispose()
                        gvUnverified.DataSourceID = Nothing
                        gvUnverified.DataSource = TryCast(ViewState("checkData"), DataTable)
                        gvUnverified.DataBind()
                        ComputeResults()
                    End If

                End Using
                SaveDeposit()
            End If

        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Function ProcessChecks(ByVal checkList As IEnumerable(Of DataRow), ByVal BatchID As String) As String
        Try
            Dim statusString As New StringBuilder
            Dim totItems As Integer = 0
            Dim totAmt As Integer = 0

            statusString.Append("Successful Batch Info<br/>")

            Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                AddHandler icl.ICL_Error, AddressOf icl_ICL_Error

                For Each chk As DataRow In checkList
                    Dim dataClientID As Integer = chk("clientid").ToString
                    Dim checkIdToProcess As String = chk("checkID").ToString
                    Dim checkAmount As Double = chk("amount").ToString
                    Dim checkfrontpath As String = chk("frontimagepath").ToString
                    Dim checkbackpath As String = chk("backimagepath").ToString
                    Dim CheckRouting As String = chk("routing").ToString
                    Dim CheckAccountNum As String = chk("account").ToString
                    Dim CheckAuxOnus As String = chk("AuxOnUs").ToString
                    Dim CheckNumber As String = chk("CheckNumber").ToString
                    Dim CheckType As String = chk("CheckType").ToString
                    Dim CheckOnUs As String = chk("OnUs").ToString
                    Dim CheckRoutingCheckSum As String = chk("routingchecksum").ToString
                    Dim CheckMicrLine As String = chk("micrline").ToString
                    Dim verifiedByUserID As String = chk("verifiedby").ToString
                    Dim createdByUserID As String = chk("createdby").ToString
                    Dim regid As String = chk("registerid").ToString
                    Dim epc As String = chk("epc").ToString

                    If regid = -1 Then
                        regid = RegisterHelper.InsertDeposit(dataClientID, Now, CheckNumber, "Check 21", checkAmount, 3, Now.AddDays(1), verifiedByUserID, verifiedByUserID)
                        Dim chkID As Integer = icl.InsertCheck(regid, dataClientID, checkfrontpath, checkbackpath, CheckRouting, CheckAccountNum, checkAmount, CheckAuxOnus, CheckNumber, CheckType, CheckOnUs, CheckRoutingCheckSum, CheckMicrLine, verifiedByUserID, BatchID, EPC, createdByUserID)

                        Dim noteMSG As New StringBuilder
                        noteMSG.AppendFormat("{0} #{1} Processed for {2} on {3}.", CheckType.ToString.ToUpper, CheckNumber, FormatCurrency(checkAmount, 2, TriState.False, TriState.False, TriState.True), Now.ToString)
                        Dim nID As Integer = NoteHelper.InsertNote(noteMSG.ToString, verifiedByUserID, dataClientID)

                        checkfrontpath = CopyToClientDocDirectory(dataClientID, checkfrontpath)
                        checkbackpath = CopyToClientDocDirectory(dataClientID, checkbackpath)

                        'attach check to client
                        SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkfrontpath), verifiedByUserID)
                        SharedFunctions.DocumentAttachment.AttachDocument("client", dataClientID, Path.GetFileName(checkfrontpath), verifiedByUserID)
                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkfrontpath), verifiedByUserID, Now)

                        SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkbackpath), verifiedByUserID)
                        SharedFunctions.DocumentAttachment.AttachDocument("client", dataClientID, Path.GetFileName(checkbackpath), verifiedByUserID)
                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkbackpath), verifiedByUserID, Now)

                        'remove check from batch so it wont get processed again
                        icl.DeleteCheck(checkIdToProcess)
                        totItems += 1
                        totAmt += checkAmount
                    End If

                Next

                statusString.AppendFormat("{0} Check(s)<br/>", totItems)
                statusString.AppendFormat("{0} Total Amount<br/>", FormatCurrency(totAmt, 2))

            End Using
            Return statusString.ToString
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
    End Function

    Private Sub ProcessChecks(ByVal DataClientID As Integer, ByVal checkIdToProcess As Integer, ByVal checkAmount As Double, _
        ByVal checkFrontPath As String, ByVal checkBackPath As String, ByVal CheckRouting As String, ByVal CheckAccountNum As String, _
        ByVal CheckAuxOnus As String, ByVal CheckNumber As String, ByVal CheckType As String, ByVal CheckOnUs As String, _
        ByVal CheckRoutingCheckSum As String, ByVal CheckMicrLine As String, ByVal EPC As String, ByVal BatchID As String)
        Try
            Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                AddHandler icl.ICL_Error, AddressOf icl_ICL_Error

                Dim regid As Integer = RegisterHelper.InsertDeposit(DataClientID, Now, CheckNumber, "Check 21", checkAmount, 3, Now.AddDays(1), UserID, UserID)
                Dim chkID As Integer = icl.InsertCheck(regid, DataClientID, checkFrontPath, checkBackPath, CheckRouting, CheckAccountNum, checkAmount, CheckAuxOnus, CheckNumber, CheckType, CheckOnUs, CheckRoutingCheckSum, CheckMicrLine, UserID, EPC, BatchID)

                Dim noteMSG As New StringBuilder
                noteMSG.AppendFormat("{0} #{1} Processed for {2} on {3}", CheckType, CheckNumber, checkAmount, Now.ToString)
                Dim nID As Integer = NoteHelper.InsertNote(noteMSG.ToString, UserID, DataClientID)

                checkFrontPath = CopyToClientDocDirectory(DataClientID, checkFrontPath)
                checkBackPath = CopyToClientDocDirectory(DataClientID, checkBackPath)

                'attach check to client
                SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkFrontPath), UserID, "ClientDocs")
                SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientID, Path.GetFileName(checkFrontPath), UserID, "ClientDocs")
                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkFrontPath), UserID, Now)

                SharedFunctions.DocumentAttachment.AttachDocument("note", nID, Path.GetFileName(checkBackPath), UserID, "ClientDocs")
                SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientID, Path.GetFileName(checkBackPath), UserID, "ClientDocs")
                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(checkBackPath), UserID, Now)

                icl.DeleteCheck(checkIdToProcess)
                'ShowMsg(String.Format("Process Check {0}", checkIdToProcess), "info")
            End Using
        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub SaveDeposit()
        Try
            dsUnverified.Update()
            'ShowMsg("Deposit Saved!", "success")
            If Not IsNothing(ViewState("checkData")) Then
                Dim saveid As String = ""
                If Not IsNothing(gvUnverified.Attributes("SaveGUID")) Then
                    saveid = gvUnverified.Attributes("SaveGUID").ToString
                    If saveid.ToString = "" Then
                        saveid = Guid.NewGuid.ToString
                        gvUnverified.Attributes.Add("SaveGUID", saveid.ToString)
                    End If
                Else
                    saveid = Guid.NewGuid.ToString
                    gvUnverified.Attributes.Add("SaveGUID", saveid.ToString)
                End If
                Using icl As New ImageCashLetterFile(ConfigurationManager.AppSettings("Connectionstring").ToString)
                    AddHandler icl.ICL_Action, AddressOf icl_ICL_Action
                    AddHandler icl.ICL_Error, AddressOf icl_ICL_Error

                    icl.DeleteSavedBatch(saveid)
                    Using dtChecks As DataTable = TryCast(ViewState("checkData"), DataTable)
                        For Each row As DataRow In dtChecks.Rows
                            'save deposit
                            icl.SaveCheck(-1, row("clientid").ToString, row("frontimagepath").ToString, row("backimagepath").ToString, row("routing").ToString, row("account").ToString, row("amount").ToString, row("AuxOnUs").ToString, row("CheckNumber").ToString, row("CheckType").ToString, row("OnUs").ToString, row("routingchecksum").ToString, row("micrline").ToString, UserID, row("epc"), saveid)
                        Next
                    End Using
                End Using
                LoadChecks(saveid)
                ShowMsg("Deposit Saved!", "success")
            Else
                ShowMsg("No Deposit Selected!", "info")
            End If
        Catch ex As Exception
            ShowError(ex)
        End Try
    End Sub

    Private Sub SetRollups()
        Dim roleId As Integer = UserHelper.GetUserRole(UserID)
        Select Case roleId
            Case 11
                lnkProcessBatches.Style("display") = "block"
                lnkDeleteBatches.Style("display") = "block"
            Case Else
                If IsManager(UserID) Then
                    lnkProcessBatches.Style("display") = "block"
                    lnkDeleteBatches.Style("display") = "block"
                Else
                    lnkProcessBatches.Style("display") = "none"
                    lnkDeleteBatches.Style("display") = "none"
                End If
        End Select


    End Sub

    Private Sub ShowError(ByVal errorEx As Exception)
        Dim errMSG As String = String.Format("{0}<br/>", errorEx.Message.ToString)
        If Not IsNothing(errorEx.InnerException) Then
            errMSG += String.Format("{0}<br/>", errorEx.InnerException.ToString)
        End If
        errMSG += String.Format("{0}<br/>", errorEx.StackTrace)

        dvMsg.InnerHtml = errMSG

        dvMsg.Style("display") = "block"
        dvMsg.Attributes("class") = "error"
    End Sub

    Private Sub ShowMsg(ByVal msgText As String, ByVal MsgType As String)

        Dim closeLink As String = "<br/><a href=""#"" onclick=""this.parentElement.style.display='none';"" style=""float:right; padding-top:10px"" >[close]</a>"
        Dim msgHTML As String = String.Format("<div>{0}</div><br/>", msgText)
        msgHTML += closeLink
        dvMsg.InnerHtml = msgHTML
        dvMsg.Style("display") = "block"
        dvMsg.Style("padding-left") = "45px"
        dvMsg.Attributes("class") = MsgType
    End Sub

#End Region 'Methods

#Region "Nested Types"

    Public Class DepositHistoryTemplate
        Implements ITemplate

#Region "Fields"

        Private _ctlName As String
        Private _lit As ListItemType

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal TypeOfList As ListItemType)
            _lit = TypeOfList
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn
            Select Case _lit
                Case DataControlRowType.Header
                    Dim lc As New Literal()
                    lc.Text = "Deposit Actions"
                    container.Controls.Add(lc)
                    Exit Select
                Case ListItemType.Item
                    Dim lnk As New LinkButton
                    lnk.ID = "lnkSelectBatch"
                    lnk.Text = "Select"
                    lnk.CommandName = "select"
                    AddHandler lnk.DataBinding, AddressOf LinkDataBinding
                    container.Controls.Add(lnk)

                    lnk = New LinkButton
                    lnk.ID = "lnkDeleteBatch"
                    lnk.Text = " | Delete"
                    lnk.CommandName = "delete"
                    AddHandler lnk.DataBinding, AddressOf LinkDataBinding
                    container.Controls.Add(lnk)

            End Select
        End Sub

        Private Sub LinkDataBinding(ByVal sender As Object, ByVal e As EventArgs)
            Dim lnk As LinkButton = TryCast(sender, LinkButton)
            Dim container As GridViewRow = DirectCast(lnk.NamingContainer, GridViewRow)
            lnk.CommandArgument = DirectCast(container.DataItem, DataRowView)("SaveGuid").ToString()
        End Sub

#End Region 'Methods

    End Class

    Public Class DepositSearchHistoryTemplate
        Implements ITemplate

#Region "Fields"

        Private _lit As ListItemType

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal TypeOfList As ListItemType)
            _lit = TypeOfList
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn
            Select Case _lit
                Case DataControlRowType.Header
                    Dim lc As New Literal()
                    lc.Text = "Search Actions"
                    container.Controls.Add(lc)
                    Exit Select
                Case ListItemType.Item
                    Dim lnk As New LinkButton
                    lnk.ID = "lnkSelectClientCheck"
                    lnk.Text = "Select Check"
                    lnk.CommandName = "selectclientcheck"
                    AddHandler lnk.DataBinding, AddressOf LinkDataBinding
                    container.Controls.Add(lnk)

            End Select
        End Sub

        Private Sub LinkDataBinding(ByVal sender As Object, ByVal e As EventArgs)
            Dim lnk As LinkButton = TryCast(sender, LinkButton)
            Dim container As GridViewRow = DirectCast(lnk.NamingContainer, GridViewRow)
            lnk.CommandArgument = DirectCast(container.DataItem, DataRowView)("Check21ID").ToString()
        End Sub

#End Region 'Methods

    End Class

#End Region 'Nested Types

    Protected Sub lnkICLReports_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkICLReports.Click
        Response.Redirect("reports.aspx")
    End Sub
    Protected Sub lnkProcessBatches_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkProcessBatches.Click
        ProcessBatches()
        BuildHistoryGrid()
    End Sub
    Protected Sub lnkMergeBatches_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkMergeBatches.Click
        MergeBatches()
        BuildHistoryGrid()
    End Sub
    Protected Sub lnkDeleteBatches_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteBatches.Click
        DeleteBatches()
        BuildHistoryGrid()
    End Sub
    Private Sub ProcessBatches()
        Dim iProcessed As Integer = 0
        SaveDeposit()

        For index As Integer = 0 To gvHistory.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvHistory.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)
            If cb.Checked Then
                Dim actionid As String = gvHistory.DataKeys(index).Item(0).ToString

                Try
                    Dim msgText As New StringBuilder
                    Dim msgType As String = ""
                    Dim ssql As String = "SELECT nc.Check21ID AS CheckID, nc.RegisterID, nc.ClientID, nc.CheckFrontPath AS frontimagepath, "
                    ssql += "nc.CheckBackPath AS backimagepath, nc.CheckRouting AS routing, nc.CheckAccountNum[Account], nc.CheckAmount AS Amount, "
                    ssql += "nc.CheckAuxOnus AS AuxOnUs, nc.CheckNumber, nc.CheckType, nc.CheckOnUs AS OnUs, nc.CheckRoutingCheckSum AS RoutingCheckSum, "
                    ssql += "nc.CheckMicrLine AS MicrLine , verifiedby ,[verified] = cast(nc.verified as varchar)+ ' By ' + vu.firstname + ' ' + vu.lastname, "
                    ssql += "[processed] = cast(nc.processed  as varchar)+ ' By ' + pu.firstname + ' ' + pu.lastname, nc.createdby  "
                    ssql += "FROM tblICLChecks nc with(nolock) left join tbluser vu with(nolock) on vu.userid = nc.verifiedby "
                    ssql += "left join tbluser pu with(nolock) on pu.userid = nc.verifiedby "
                    ssql += "WHERE (nc.SaveGUID = @saveGUID) and (DeleteDate is null) and processed is null"
                    Dim params As New List(Of System.Data.SqlClient.SqlParameter)
                    params.Add(New System.Data.SqlClient.SqlParameter("saveGUID", actionid))

                    Using dtChecks As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text, params.ToArray)
                        If dtChecks.Rows.Count > 0 Then
                            Dim lst As IEnumerable(Of DataRow) = dtChecks.Select("amount > 0 and clientid <> -1")
                            Dim checktoProcessCnt As Integer = lst.CopyToDataTable.Rows.Count
                            If checktoProcessCnt > 0 Then
                                msgText.Append(ProcessChecks(lst, actionid))
                                msgType = "success"
                                iProcessed += 1
                            Else
                                msgText.Append("No checks verified to process!")
                                msgType = "warning"
                            End If
                        Else
                            msgText.Append("This batch has been processed already!")
                            msgType = "warning"
                        End If

                    End Using

                    ShowMsg(msgText.ToString, msgType)
                Catch ex As Exception
                    ShowError(ex)
                End Try
            End If
        Next

        EmailHelper.SendMessage("LexxCheck@lexxiom.com", "ccastelo@lexxiom.com", "ICL CHECK(S) READY FOR PROCESSING", String.Format("{0} Batch(es) have been processed and have checks ready for the ICL process.", iProcessed))

        BuildHistoryGrid()

        Try
            NonDepositHelper.MapChecks()
        Catch ex As Exception
            ShowError(New Exception("Matching check with non-deposits failed!"))
        End Try
    End Sub

    Private Sub MergeBatches()
        Dim mainBatch As String = String.Empty
        Dim imerge As Integer = 0
        For index As Integer = 0 To gvHistory.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvHistory.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)
            If cb.Checked Then
                Dim actionid As String = gvHistory.DataKeys(index).Item(0).ToString
                If String.IsNullOrEmpty(mainBatch) Then
                    mainBatch = actionid
                End If

                If mainBatch <> actionid Then
                    Dim ssql As String = String.Format("update tblICLChecks SET SaveGUID = '{0}', created = (select max(created) from tbliclchecks where saveguid = '{0}') where SaveGUID = '{1}'", mainBatch, actionid)
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                    imerge += 1
                End If
            End If
        Next
        If imerge = 0 Then
            ShowMsg("No Batch(es) selected to merge!", "warning")
        Else
            ShowMsg(String.Format("{0} Batch(es) have been merged!", imerge), "success")
        End If
    End Sub
    Private Sub DeleteBatches()
        Dim isaved As Integer = 0
        Dim ierror As Integer = 0
        For index As Integer = 0 To gvHistory.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvHistory.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)
            If cb.Checked Then
                Dim actionid As String = gvHistory.DataKeys(index).Item(0).ToString
                Dim totItms As Double = gvHistory.Rows(index).Cells(11).Text
                Dim totVer As Double = 0
                Dim totVerCnt As Double = 0
                Dim totProc As Double = 0

                Double.TryParse(gvHistory.Rows(index).Cells(4).Text, totVer)
                Double.TryParse(gvHistory.Rows(index).Cells(5).Text, totVerCnt)
                Double.TryParse(gvHistory.Rows(index).Cells(7).Text, totProc)


                If totProc = 0 Then
                    Dim ssql As String = "UPDATE tblICLChecks SET DeleteDate = Getdate() WHERE (SaveGUID = @SaveID)"
                    Dim params As New List(Of System.Data.SqlClient.SqlParameter)
                    params.Add(New System.Data.SqlClient.SqlParameter("SaveID", actionid))
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text, params.ToArray)
                    isaved += 1
                Else
                    ierror += 1
                End If

            End If
        Next

        If isaved = 0 Then
            ShowMsg(String.Format("{0} Batch(es) have been processed and cannot be deleted!", ierror), "warning")
        Else
            ShowMsg(String.Format("Deleted {0} Batch(es)!", isaved), "success")
        End If

    End Sub

    Protected Sub lnkFilterHistory_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFilterHistory.Click
        dsHistory.SelectParameters("filterdate").DefaultValue = txtScanDate.Text
        BuildHistoryGrid()
    End Sub

    Protected Sub lnkClearFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearFilter.Click
        dsHistory.SelectParameters("filterdate").DefaultValue = DBNull.Value.ToString
        BuildHistoryGrid()
    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        'dsHistory.DataBind()
        If Not IsNothing(Session("ProcessMsg")) Then
            Dim closeLink As String = "<br/><a href=""#"" onclick=""this.parentElement.style.display='none';"" style=""float:right; padding-top:10px"" >[close]</a>"
            dvMsg.InnerHtml = String.Format("{0}{1}", Session("ProcessMsg").ToString, closeLink)
            dvMsg.Style("display") = "block"
            dvMsg.Attributes("class") = ""
            Session("ProcessMsg") = Nothing
        End If
        gvHistory.DataBind()
    End Sub
End Class