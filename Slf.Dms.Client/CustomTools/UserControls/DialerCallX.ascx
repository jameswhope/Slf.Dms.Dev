<%@ Control Language="VB" AutoEventWireup="false" CodeFile="DialerCallX.ascx.vb"
    Inherits="CustomTools_UserControls_DialerCallX" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>


<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>

<script type="text/javascript">
    function submitSettAuth(matterid, resoid, settid) {
        var ret = window.showModalDialog('<%= ResolveUrl("~/CallControls/SettlementVerbalAuth.aspx")%>' + '?matterid=' + matterid + '&resoid=' + resoid + '&settid=' + settid + '&rand=' + Math.floor(Math.random() * 99999), window, "dialogWidth: 620px; dialogHeight:320px; center:yes; status: no; scrollbars: no; resizable: no;");
        try {
            if ((ret == undefined) || (ret == '')) {
                window.parent.stopRecording();
            }
            var btn = document.getElementById('<%=lnkReloadSett.ClientId %>');
            btn.click();
        }
        catch (e) {
            //ignore
        }
        return false;
    }
       
    function ShowReject(obj, settId) {
        var f = <%=DialFlyout.getClientID()%>;
        f.AttachTo(obj.id);
        f.Open();
        document.getElementById('<%=hdnCurrentSettId.ClientId %>').value = settId;
        return false;
    }
    
    function ShowResNonDeposit(matterId) {
        var ret = window.showModalDialog('<%= ResolveUrl("~/util/pop/ResolveNonDeposit.aspx")%>?mid=' + matterId + '&rand=' + Math.floor(Math.random() * 99999), null,"dialogWidth:420px; dialogHeight:460px; center:yes; status: no; scrollbars: no;");
        if (ret==1){
            var btn = document.getElementById('<%=lnkReloadNonDep.ClientId %>');
            btn.click();
        }
        return false;
    }
           
    function EditSeetFees(id){
        document.getElementById("lnk_EditF_" + id).style.display = 'none';
        document.getElementById("lnk_SaveF_" + id).style.display = 'inline';
        document.getElementById("lnk_CancelF_" + id).style.display = 'inline';
        document.getElementById("lblSettlementFee_" + id).style.display = 'none';
        document.getElementById("lblSettlementFeeDollar_" + id).style.display = 'inline';
        document.getElementById("txtSettlementFee_" + id).style.display = 'inline';
        document.getElementById("lblDeliveryAmount_" + id).style.display = 'none';
        document.getElementById("lblDeliveryAmountDollar_" + id).style.display = 'inline';
        document.getElementById("txtDeliveryAmount_" + id).style.display = 'inline';
        document.getElementById("lblAdjSettlementFee_" + id).style.display = 'none';
        document.getElementById("lblAdjSettlementFeeC_" + id).style.display = 'inline';
        document.getElementById("lblSettlementTotalCost_" + id).style.display = 'none';
        document.getElementById("lblSettlementTotalCostC_" + id).style.display = 'inline';
        document.getElementById("txtSettlementFee_" + id).value = document.getElementById("lblSettlementFee_" + id).innerText.replace('$','').replace(',','');
        document.getElementById("txtDeliveryAmount_" + id).value = document.getElementById("lblDeliveryAmount_" + id).innerText.replace('$','').replace(',','');
        document.getElementById("lblAdjSettlementFeeC_" + id).value = document.getElementById("lblAdjSettlementFee_" + id).innerText;
        document.getElementById("lblSettlementTotalCostC_" + id).value = document.getElementById("lblSettlementTotalCost_" + id).innerText;
        return false;
    }
    
    function CancelSeetFees(id){
        document.getElementById("lnk_EditF_" + id).style.display = 'inline';
        document.getElementById("lnk_SaveF_" + id).style.display = 'none';
        document.getElementById("lnk_CancelF_" + id).style.display = 'none'
        document.getElementById("lblSettlementFee_" + id).style.display = 'inline';
        document.getElementById("lblSettlementFeeDollar_" + id).style.display = 'none';
        document.getElementById("txtSettlementFee_" + id).style.display = 'none';
        document.getElementById("lblDeliveryAmount_" + id).style.display = 'inline';
        document.getElementById("lblDeliveryAmountDollar_" + id).style.display = 'none';
        document.getElementById("txtDeliveryAmount_" + id).style.display = 'none';
        document.getElementById("lblAdjSettlementFee_" + id).style.display = 'inline';
        document.getElementById("lblAdjSettlementFeeC_" + id).style.display = 'none';
        document.getElementById("lblSettlementTotalCost_" + id).style.display = 'inline';
        document.getElementById("lblSettlementTotalCostC_" + id).style.display = 'none';
        return false;
    }
    
    function RecalcSettFees(id){
        var oldfee = document.getElementById("lblSettlementFee_" + id).innerText.replace('$','').replace('(','-').replace(')','').replace(',','');
        oldfee = parseFloat(oldfee);
        
        var settfee = getFloatValue(document.getElementById("txtSettlementFee_" + id).value);
        var credfee = getFloatValue(document.getElementById("lblSettlementFeeCredit_" + id).innerText);
        var delivfee = getFloatValue(document.getElementById("txtDeliveryAmount_" + id).value);

        var adjsettfee = document.getElementById("lblAdjSettlementFeeC_" + id);
        var adjfeevalue = settfee-oldfee;
        adjsettfee.innerText =  "$" + FormatNumber(adjfeevalue,true,2).replace(',','');
         
        var totalfee = document.getElementById("lblSettlementTotalCostC_" + id);
        var totalfeevalue =  oldfee  + adjfeevalue - credfee + delivfee;
        totalfee.innerText = "$" +  FormatNumber(totalfeevalue,true,2).replace(',','');
    }
    
    function getFloatValue(strValue){
        return parseFloat(strValue.replace('$','').replace('(','-').replace(')','').replace(',','')); 
    }
     
    function IsSpecialKey(keyCode) {
        if (keyCode == 190 || keyCode == 110 || keyCode == 8 || keyCode == 9 || keyCode == 13 || keyCode == 45 || keyCode == 46 || (keyCode > 16 && keyCode < 21) || (keyCode > 34 && keyCode < 41) || (keyCode > 95 && keyCode < 106))
            return true;
        else
            return false;
    }
    
    function singleDot(txt, e) {
        var digits = '0123456789';
        var cmds = 'acxvz';
        if ((e.shiftKey == true) ||
                (txt.value.indexOf('.') != -1 && (e.keyCode == 190 || e.keyCode == 110)) ||
                (digits.indexOf(String.fromCharCode(e.keyCode)) == -1 && IsSpecialKey(e.keyCode) == false && e.ctrlKey == false))
            return false;
        else
            return true;
    }
       
    function ShowManAppr(obj, settId) {
        var f = <%=ManAppFlyout.getClientID()%>;
        document.getElementById('<%=txtManagerPwd.ClientId %>').value = '';
        document.getElementById('<%=hdnCurrentSettId.ClientId %>').value = settId;
        document.getElementById('<%=hdnSettlementFee.ClientId %>').value = document.getElementById("txtSettlementFee_" + settId).value 
        document.getElementById('<%=hdnDeliveryFee.ClientId %>').value = document.getElementById("txtDeliveryAmount_" + settId).value;
        f.AttachTo(obj.id);
        f.Open();
        return false;
    } 
    
    function ClearNotes(){
         document.getElementById('<%=txtNote.ClientId %>').value = '';
    }
    
    function changeperson(sel){
        var personid = sel.options[sel.selectedIndex].value;
        document.getElementById('<%= hdnPersonId.ClientId%>').value = personid;
        var btn = document.getElementById('<%= lnkChangePerson.ClientId%>');
        btn.click();
    }
       
</script>

<asp:ScriptManagerProxy ID="ScriptManagerProxyP" runat="server">
</asp:ScriptManagerProxy>
<ajaxToolkit:Accordion ID="AcClientInfo" runat="Server" SelectedIndex="0" HeaderCssClass="accordionHeader"
    HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent"
    AutoSize="None" FadeTransitions="true" TransitionDuration="250" FramesPerSecond="40"
    RequireOpenedPane="false" SuppressHeaderPostbacks="true">
    <Panes>
        <ajaxToolkit:AccordionPane ID="AccordionPaneClientInfo" HeaderCssClass="accordionHeader"
            HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent"
            runat="server">
            <Header>
                <div>
                    <img src="<%=resolveurl("~/images/16x16_arrowright_clearlight.png")%>" align="absmiddle" />&nbsp;&nbsp;Client
                    Called with Dialer
                </div>
            </Header>
            <Content>
                <div>
                    <table>
                        <tr>
                            <td valign="top" style="white-space: nowrap">
                                <table cellpadding="2" cellspacing="0">
                                    <tr>
                                        <td style="padding-bottom: 15px; white-space: nowrap;">
                                         <asp:Label ID="lblCoApp" runat="server" style="vertical-align: super; font-size: xx-small;" ToolTip="View all Applicants"></asp:Label>
                                            <asp:Label ID="lblClientName" runat="server" Font-Size="12px" Font-Bold="true"></asp:Label>
                                            <a href="<%=ResolveUrl("~/clients/client/?id=") & GetClientId() %>"><font style="font-size: 12px;
                                                font-weight: bold">(</font><asp:Label ID="lblClientAccountNumber" runat="server"
                                                    Font-Size="12px" Font-Bold="true"></asp:Label><font style="font-size: 12px; font-weight: bold">)</font></a>
                                           <br />
                                            <asp:Label ID="lblLawFirm" runat="server"></asp:Label><br />
                                            <asp:Label ID="lblPhoneNumber" runat="server"></asp:Label>
                                            <asp:HiddenField ID="hdnDPhoneId" runat="server" />
                                            <asp:HiddenField ID="hdnDPhoneNumber" runat="server" />
                                            <asp:HiddenField ID="hdnDAnsweredDate" runat="server" />
                                            <asp:HiddenField ID="hdnDCallReasonId" runat="server" />
                                            <img id="imgClientPhone" src="~/images/phone2.png" style="cursor: hand; text-align: right;
                                                vertical-align: bottom" runat="server" title="Make Call" alt="Call" />
                                        </td>
                                        <td valign="top" align="right" style="width: 100px; white-space: nowrap;" >
                                            DOB:
                                            <asp:Label ID="lblDateOfBirth" runat="server"></asp:Label><br />
                                            SSN:
                                            <asp:Label ID="lblSSN" runat="server"></asp:Label><br />
                                            Status:
                                            <asp:Label ID="lblClientStatus" runat="server"></asp:Label><br />
                                            Hardship:
                                            <asp:Literal ID="ltrHardShip" runat="server"></asp:Literal>
                                            <asp:HiddenField ID="hdnHardship" runat="server" />
                                            <br />
                                            <asp:Label ID="lblCIDRep" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" >
                                        
                                        </td> 
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="border-top: 1px dotted #999999;">
                                            <asp:GridView ID="grdClientBanking" runat="server" AutoGenerateColumns="false" BorderStyle="None"
                                                CellPadding="2" BorderWidth="0">
                                                <Columns>
                                                    <asp:BoundField HeaderText="Bank" DataField="BankName" HeaderStyle-HorizontalAlign="Left" />
                                                    <asp:BoundField HeaderText="Routing" DataField="BankRoutingNumber" HeaderStyle-HorizontalAlign="Left" />
                                                    <asp:BoundField HeaderText="Account" DataField="BankAccountNumber" HeaderStyle-HorizontalAlign="Left" />
                                                    <asp:BoundField HeaderText="Type" DataField="BankType" HeaderStyle-HorizontalAlign="Left" />
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" style="padding-left: 20px">
                                <table cellpadding="2" cellspacing="0" width="200px">
                                    <tr>
                                        <td>
                                            PFO Balance:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblPFO" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            SDA Balance:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblSDA" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Bank Reserve:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblBankRes" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Funds On Hold:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblFundsOnHold" runat="server" Text="$0.00"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="border-top: solid 1px #000">
                                            Available SDA:
                                        </td>
                                        <td align="right" style="border-top: solid 1px #000">
                                            <asp:Label ID="lblAvailableSDA" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    
                                </table>
                                 <table cellpadding="2" cellspacing="0" width="200px">
                                 <tr>
                                        <td cospan = "2" nowrap="nowrap" align="left"  >
                                            <br/>Select the result of this call:&nbsp;<asp:Label ID="lblCustomAni" runat="server"></asp:Label><br/>
                                            <asp:RadioButton GroupName ="RdCallResult" ID="RdPerson" runat="server"  Text="Client" AutoPostBack="True"  ToolTip="The Client" />
                                            <asp:RadioButton GroupName ="RdCallResult" ID="RdMessage" runat="server"  Text="Message" AutoPostBack="True" ToolTip="An Answering Machine or Voice Mail. Message Left" />
                                            <asp:RadioButton GroupName ="RdCallResult" ID="RdAM" runat="server"  Text="A. Machine" AutoPostBack="True" ToolTip="An Answering Machine or Voice Mail. No message Left." /><br />
                                            <asp:RadioButton GroupName ="RdCallResult" ID="RdNoAnswer" runat="server" Text="No Answer" AutoPostBack="True" ToolTip="No Answer" />
                                            <asp:RadioButton GroupName ="RdCallResult" ID="RdBadNumber" runat="server" Text="Bad #" AutoPostBack="True" ToolTip="Bad/Disconnected Number" />
                                            <asp:RadioButton GroupName ="RdCallResult" ID="rdBusy" runat="server" Text="Busy" AutoPostBack="True" ToolTip="Busy Line" />
                                        </td>
                                    </tr>
                                 </table>
                            </td>
                            <td valign="top" style="padding-left: 20px">
                                <table cellpadding="2">
                                    <tr>
                                        <td>
                                            Next Deposit Date:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblNextDepositDate" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Next Deposit Amount:
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="lblNextDepositAmount" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Monthly Legal Fees:</td>
                                        <td align="right">
                                            <asp:Label ID="lblLegalFees" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="border-top: 1px dotted #999999;">
                                            <table>
                                                <tr>
                                                    <td colspan="5">
                                                        Suspend Dialer Until:
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <igsch:WebDateChooser ID="txtNextContactDate" runat="server" Width="70px" Value=""
                                                            EnableAppStyling="True" StyleSetName="" Font-Names="Tahoma" Font-Size="10px">
                                                            <DropButton ImageUrl1="~/images/Calendar_scheduleHS.png" />
                                                            <CalendarLayout ChangeMonthToDateClicked="True">
                                                            </CalendarLayout>
                                                        </igsch:WebDateChooser>
                                                    </td>
                                                    <td>
                                                        <igtxt:WebDateTimeEdit ID="txtNextContactTime" runat="server" EditModeFormat="hh:mm tt"
                                                            Font-Names="Tahoma" Font-Size="10px" Width="50px">
                                                        </igtxt:WebDateTimeEdit>
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnSaveCallMade" runat="server" Text="Save" CssClass="btn" />
                                                    </td>
                                                    <td>
                                                        or
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnSuspend" runat="server" Text="24 hrs" CssClass="btn" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="padding-left: 20px;">
                                <div>
                                    <table class="sideRollupTable" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="sideRollupCellHeader">
                                                    Links
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="sideRollupCellBody">
                                                    <table class="sideRollupCellBodyTable" border="0" cellspacing="7" cellpadding="0">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <a href="<%=ResolveUrl("~/clients/client/finances/ach/achrule.aspx")%>?id=<%=GetClientId()%>&a=a">
                                                                        Add ACH Rule</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <a href="<%=ResolveUrl("~/clients/client/finances/ach/adhocach.aspx")%>?id=<%=GetClientId()%>&a=a">
                                                                        Add Additional ACH</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <a href="#" id="lnkAddNote" >Add Note</a>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </Content>
        </ajaxToolkit:AccordionPane>
    </Panes>
</ajaxToolkit:Accordion>
<asp:UpdatePanel ID="UpdateSetts" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
    <ContentTemplate>
        <ajaxToolkit:Accordion ID="AcClientIssues" runat="Server" SelectedIndex="0" HeaderCssClass="accordionHeader"
            HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent"
            AutoSize="None" FadeTransitions="true" TransitionDuration="250" FramesPerSecond="40"
            RequireOpenedPane="false" SuppressHeaderPostbacks="false">
            <Panes>
                <ajaxToolkit:AccordionPane ID="apPendingSettl" HeaderCssClass="accordionHeader" HeaderSelectedCssClass="accordionHeaderSelected"
                    ContentCssClass="accordionContent" runat="server">
                    <Header>
                        <div>
                            <img src="<%=ResolveUrl("~/images/16x16_arrowright_clearlight.png") %>" align="absmiddle" />&nbsp;&nbsp;Pending
                            Settlements
                            <asp:Literal ID="ltrSettCount" runat="server"></asp:Literal>
                        </div>
                    </Header>
                    <Content>
                        <div>
                            <table width="100%" cellpadding="5">
                                <tr>
                                    <td height="10px;">
                                        <asp:LinkButton ID="lnkSettEN" runat="server">English</asp:LinkButton>
                                        <asp:LinkButton ID="lnkSettSP" runat="server">Spanish</asp:LinkButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-family: Tahoma; font-size: 11px; padding: 10px; border: solid 1px #999999;
                                        background-color: #FDF5E6">
                                        <asp:Literal ID="ltrSettlementIntro" runat="server"></asp:Literal>
                                        <asp:Literal ID="ltrSettlementIntroSP" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                            <table width="100%" cellpadding="3" cellspacing="0" style="margin-top: 5px;">
                                <asp:Repeater ID="rpSettlements" runat="server">
                                    <HeaderTemplate>
                                        <tr>
                                            <td style="width: 20px" class="gridviewHeader">
                                                &nbsp;
                                            </td>
                                            <td style="width: 60px" class="gridviewHeader">
                                                Acct.#
                                            </td>
                                            <td style="width: 250px" class="gridviewHeader">
                                                Creditor
                                            </td>
                                            <td style="width: 80px; text-align: right" class="gridviewHeader">
                                                Current Balance
                                            </td>
                                            <td style="width: 80px; text-align: right" class="gridviewHeader">
                                                Sett. Amount
                                            </td>
                                            <td style="width: 80px; text-align: right" class="gridviewHeader">
                                                Sett.%
                                            </td>
                                            <td style="width: 80px; text-align: right" class="gridviewHeader">
                                                Savings
                                            </td>
                                            <td style="width: 80px; text-align: right" class="gridviewHeader">
                                                Sett. Cost
                                            </td>
                                            <td style="width: 100px; text-align: center" class="gridviewHeader">
                                                Due Date
                                            </td>
                                            <td style="width: 120px" align="center" class="gridviewHeader">
                                                Approval Status
                                            </td>
                                            <td style="width: 120px" align="center" class="gridviewHeader">
                                                Rec
                                            </td>
                                            <td style="width: 120px" align="center" class="gridviewHeader">
                                                Task Status
                                            </td>
                                            <td style="width: 120px" align="center" class="gridviewHeader">
                                                Resolved
                                            </td>
                                            <td style="width: 120px" align="center" class="gridviewHeader">
                                                Resolved By
                                            </td>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td class="gridviewItem" align="center">
                                                <img src="<%= ResolveUrl("~/images/tree_plus.bmp")%>" onclick="toggle(this,<%#Eval("SettlementID")%>);"
                                                    alt="" style="cursor: pointer;" />
                                            </td>
                                            <td class="gridviewItem" style="white-space: nowrap;">
                                                <!--***<a href="<%=ResolveUrl("~/processing/TaskSummary/default.aspx")%>?id=<%#Eval("TaskId") %>&type=v&resoid=<%#Eval("CallResolutionId")%>"
                                                    title="<%#Eval("CreditorAccountNumber")%>" style="text-decoration: none;">
                                                    <%#GetLast4(Eval("CreditorAccountNumber"))%>
                                                </a>-->
                                                ***<span title="<%#Eval("CreditorAccountNumber")%>" style="text-decoration: none;">
                                                    <%#GetLast4(Eval("CreditorAccountNumber"))%>
                                                </span>&nbsp;
                                            </td>
                                            <td class="gridviewItem" nowrap="nowrap">
                                                <%#rpNR_CreditorName(Container)%>
                                            </td>
                                            <td style="text-align: right" class="gridviewItem">
                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.CreditorAccountBalance)%>
                                            </td>
                                            <td style="text-align: right" class="gridviewItem">
                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementAmount)%>
                                            </td>
                                            <td style="text-align: right" class="gridviewItem">
                                                <%#CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementPercent%>
                                            </td>
                                            <td style="text-align: right" class="gridviewItem">
                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementSavings)%>
                                            </td>
                                            <td style="text-align: right" class="gridviewItem">
                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementCost)%>
                                            </td>
                                            <td style="text-align: center" class="gridviewItem">
                                                <%#String.Format("{0:d}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementDueDate)%>
                                            </td>
                                            <td style="text-align: center" class="gridviewItem" nowrap="nowrap">
                                                <%#IIf(Eval("TaskResolution").Length = 0, "", Eval("MatterSubStatus"))%>
                                                <input id="btnClientAuth" type="button" value="Accept" onclick="return submitSettAuth('<%#CType(Container.DataItem, SettlementCallResolution).Settlement.MatterId%>', '<%#Eval("CallResolutionId")%>', '<%#Eval("SettlementId")%>');"
                                                    class="btn" style="display: <%#IIf(Eval("TaskResolution").Length = 0, "inline", "none")%>;" />
                                                <input id="btnReject" type="button" value="Reject" onclick="return ShowReject(this, '<%#Eval("SettlementID")%>');"
                                                    class="btn" style="display: <%#IIf(Eval("TaskResolution").Length = 0, "inline", "none")%>;" />
                                            </td>
                                            <td style="text-align: center" class="gridviewItem" align="center">
                                                <a href="<%# iif(Eval("RecFile").Trim.Length=0, "#", Eval("RecFile"))%>" style="border-style: none;">
                                                    <img src="<%#ResolveUrl(String.Format("~/images/wav_{0}.png", iif(Eval("RecFile").Trim.Length=0, "dis", "rec"))) %>"
                                                        style="border-style: none; cursor: hand; display: <%#IIf(Eval("RecId") <> 0, "inline", "none")%>;"
                                                        alt="wav" title="Listen" />
                                                </a>
                                            </td>
                                            <td style="text-align: center" class="gridviewItem">
                                                <%#Eval("TaskResolution")%>
                                            </td>
                                            <td style="text-align: center" class="gridviewItem">
                                                <%#Eval("ResolvedF")%>
                                            </td>
                                            <td style="text-align: center" class="gridviewItem">
                                                <%#Eval("ResolvedByUser")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td id="td_<%#Eval("settlementid")%>" colspan="14" style="display: none;" align="left">
                                                <div class="accordionContent">
                                                    <table>
                                                        <tr>
                                                            <td valign="top">
                                                                <table>
                                                                    <tr>
                                                                        <td width="0px">
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                        </td>
                                                                        <td class="subitem">
                                                                        </td>
                                                                        <td class="subitem">
                                                                        </td>
                                                                        <td nowrap="nowrap">
                                                                            <a href="javascript: void 0" id="lnk_EditF_<%#Eval("settlementid")%>" style="display: <%#IIf(Eval("TaskResolution").Length = 0, "inline", "none")%>;"
                                                                                onclick="EditSeetFees('<%#Eval("settlementid")%>');">Edit Fees</a> <a href="javascript: void 0"
                                                                                    id="lnk_SaveF_<%#Eval("settlementid")%>" style="display: none;" onclick="ShowManAppr(this, '<%#Eval("settlementid")%>');">
                                                                                    Save</a> <a href="javascript: void 0" id="lnk_CancelF_<%#Eval("settlementid")%>"
                                                                                        style="display: none;" onclick="CancelSeetFees('<%#Eval("settlementid")%>');">Cancel</a>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Avail. SDA for Settl.:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.RegisterBalance)%>
                                                                        </td>
                                                                        <td rowspan="5" width="30px" class="tdSep">
                                                                            <img id="Img3" width="1" height="1" runat="server" src="~/images/spacer.gif" border="0" />
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Settlement Fee:
                                                                        </td>
                                                                        <td class="subitem" align="right" nowrap="nowrap">
                                                                            <span id="lblSettlementFee_<%#Eval("settlementid")%>" style="display: inline;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFee)%></span>
                                                                            <span id="lblSettlementFeeDollar_<%#Eval("settlementid")%>" style="display: none;">$</span>
                                                                            <input type="text" id="txtSettlementFee_<%#Eval("settlementid")%>" runat="server"
                                                                                style="display: none; width: 50px; text-align: right; background-color: yellow;"
                                                                                value='<%#CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFee%>'
                                                                                onkeydown="return singleDot(this, event);" onkeyup="RecalcSettFees('<%#Eval("settlementid")%>');" />
                                                                        </td>
                                                                        <td rowspan="5" width="30px" class="tdSep">
                                                                            <img id="Img6" width="1" height="1" runat="server" src="~/images/spacer.gif" border="0" />
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Avail. SDA for Fees:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFeeAmountAvailable)%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Settlement Amount:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementAmount)%>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Adj. Settl. Fee:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <span id="lblAdjSettlementFee_<%#Eval("settlementid")%>" style="display: inline;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.AdjustedSettlementFee)%></span>
                                                                            <span id="lblAdjSettlementFeeC_<%#Eval("settlementid")%>" style="display: none;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.AdjustedSettlementFee)%></span>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Amount Being Paid:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFeeAmountBeingPaid)%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Avail. Sett. Amount:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementAmountAvailable)%>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Settl. Fee Credit:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <span id="lblSettlementFeeCredit_<%#Eval("settlementid")%>" style="display: inline;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFeeCredit)%></span>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Amount still owed:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementFeeAmountOwed)%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Amount Being Sent:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementAmountSent)%>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Delivery Fee:
                                                                        </td>
                                                                        <td class="subitem" align="right" nowrap="nowrap">
                                                                            <span id="lblDeliveryAmount_<%#Eval("settlementid")%>" style="display: inline;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.DeliveryAmount)%></span>
                                                                            <span id="lblDeliveryAmountDollar_<%#Eval("settlementid")%>" style="display: none;">
                                                                                $</span>
                                                                            <input type="text" id="txtDeliveryAmount_<%#Eval("settlementid")%>" runat="server"
                                                                                style="display: none; width: 50px; text-align: right; background-color: yellow;"
                                                                                value='<%#CType(Container.DataItem, SettlementCallResolution).Settlement.DeliveryAmount%>'
                                                                                onkeydown="return singleDot(this, event);" onkeyup="RecalcSettFees('<%#Eval("settlementid")%>');" />
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Delivery Method:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#CType(Container.DataItem, SettlementCallResolution).Settlement.DeliveryMethod%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Sett. Amount Owed:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementAmountOwed)%>
                                                                        </td>
                                                                        <td class="subitemHeader">
                                                                            Total Cost:
                                                                        </td>
                                                                        <td class="subitem" align="right">
                                                                            <span id="lblSettlementTotalCost_<%#Eval("settlementid")%>" style="display: inline;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementCost)%></span>
                                                                            <span id="lblSettlementTotalCostC_<%#Eval("settlementid")%>" style="display: none;">
                                                                                <%#String.Format("{0:c}", CType(Container.DataItem, SettlementCallResolution).Settlement.SettlementCost)%></span>
                                                                        </td>
                                                                        <td colspan="2">
                                                                            <asp:GridView ID="grdDeposits" runat="server" AutoGenerateColumns="False" EmptyDataText="No expected deposits before due date" EmptyDataRowStyle-BorderStyle="None" BorderStyle="None">
                                                                                <Columns>
                                                                                    <asp:BoundField DataField="depositdate" HeaderText="Date" DataFormatString="{0:MMM/d}"
                                                                                        ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headItem"
                                                                                        ItemStyle-CssClass="listItem" />
                                                                                    <asp:BoundField DataField="depositamount" HeaderText="Amount" DataFormatString="{0:c}"
                                                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                                                                                    <asp:BoundField DataField="depositmethod" HeaderText="Method" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                                                                                    <asp:BoundField DataField="deposittype" HeaderText="Type" ItemStyle-HorizontalAlign="Center"
                                                                                        HeaderStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headItem" ItemStyle-CssClass="listItem" />
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td rowspan="6" width="5px" class="tdSep">
                                                                <img id="Img1" width="1" height="1" runat="server" src="~/images/spacer.gif" border="0" />
                                                            </td>
                                                            <td>
                                                                <%#GetSettlementScript(CType(Container.DataItem, SettlementCallResolution)) %>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="14" class="tdHSep">
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>

                                <script language="javascript" type="text/javascript">
                                    function toggle(img, settlementid) {
                                        var td = 'td_' + settlementid;

                                        if (img.src.indexOf('plus') > 0) {
                                            img.src = '<%=ResolveUrl("~/images/tree_minus.bmp") %>';
                                            document.getElementById(td).style.display = '';
                                        }
                                        else {
                                            img.src = '<%=ResolveUrl("~/images/tree_plus.bmp") %>';
                                            document.getElementById(td).style.display = 'none';
                                        }
                                    }
                                </script>

                            </table>
                            <table width="100%" cellpadding="5" style="margin-top: 5px;">
                                <tr>
                                    <td style="font-family: Tahoma; font-size: 11px; padding: 10px; border: solid 1px #999999;
                                        background-color: #FDF5E6">
                                        <asp:Literal ID="ltrSettlementAfterIntro" runat="server"></asp:Literal>
                                        <asp:Literal ID="ltrSettlementAfterIntroSP" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-family: Tahoma; font-size: 11px; padding: 10px; border: solid 1px #999999;
                                        background-color: #FDF5E6">
                                        <asp:Literal ID="ltrSettlementClosing" runat="server"></asp:Literal>
                                        <asp:Literal ID="ltrSettlementClosingSP" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </Content>
                </ajaxToolkit:AccordionPane>
                 <ajaxToolkit:AccordionPane ID="apNonDeposits" HeaderCssClass="accordionHeader" HeaderSelectedCssClass="accordionHeaderSelected"
                    ContentCssClass="accordionContent" runat="server">
                    <Header>
                        <div>
                            <img src="<%=ResolveUrl("~/images/16x16_arrowright_clearlight.png") %>" align="absmiddle" />&nbsp;&nbsp;Pending
                            Non Deposits
                            <asp:Literal ID="ltrNonDepositCount" runat="server"></asp:Literal>
                        </div>
                    </Header> 
                    <Content>
                        <table width="100%" cellpadding="3" cellspacing="0" style="margin-top: 5px;">
                            <asp:Repeater ID="rpNonDeposits" runat="server">
                                    <HeaderTemplate>
                                        <tr>
                                            <td style="width: 60px; text-align: left" class="gridviewHeader">
                                                Matter #
                                            </td>
                                            <td style="width: 80px; text-align: left" class="gridviewHeader">
                                                Non Deposit Type
                                            </td>
                                            <td style="width: 80px; text-align: left" class="gridviewHeader">
                                                Deposit Date
                                            </td>
                                            <td style="width: 80px; text-align: left" class="gridviewHeader">
                                                Amount
                                            </td>
                                            <td style="width: 80px; text-align: left" class="gridviewHeader">
                                                Bounced Date
                                            </td>
                                            <td style="width: 120px; text-align: left" class="gridviewHeader">
                                                Bounced Reason
                                            </td>
                                            <td style="width: 120px; text-align: left" class="gridviewHeader">
                                                Matter Substatus
                                            </td>
                                            <td style="width: 80px; text-align: left" class="gridviewHeader">
                                                Task Resolution
                                            </td>
                                            <td style="width: 120px" align="left" class="gridviewHeader">
                                                Resolved
                                            </td>
                                            <td style="width: 120px" align="left" class="gridviewHeader">
                                                Resolved By
                                            </td>
                                        </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="text-align: left"  class="gridviewItem" nowrap="nowrap">
                                                 <%#CType(Container.DataItem, NonDepositCallResolution).MatterNumber%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#CType(Container.DataItem, NonDepositCallResolution).NonDepositType%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#CType(Container.DataItem, NonDepositCallResolution).DepositDate%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#String.Format("{0:c}", CType(Container.DataItem, NonDepositCallResolution).DepositAmount)%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#CType(Container.DataItem, NonDepositCallResolution).BouncedDate%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#CType(Container.DataItem, NonDepositCallResolution).BouncedReasonDescription%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem" nowrap="nowrap">
                                                <%#CType(Container.DataItem, NonDepositCallResolution).MatterSubStatus%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem" align="center">
                                                <%#IIf(Eval("TaskResolution").Length = 0, "", Eval("TaskResolution"))%>
                                                <input id="btnResolve" type="button" value="Resolve" onclick="return ShowResNonDeposit('<%#CType(Container.DataItem, NonDepositCallResolution).MatterId%>');"
                                                    class="btn" style="display: <%#IIf(Eval("TaskResolution").Length = 0, "inline", "none")%>;" />
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#Eval("ResolvedF")%>
                                            </td>
                                            <td style="text-align: left" class="gridviewItem">
                                                <%#Eval("ResolvedByUser")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="14" class="tdHSep">
                                            </td>
                                        </tr>
                                        </ItemTemplate>
                             </asp:Repeater>
                        </table>
                    </Content> 
                 </ajaxToolkit:AccordionPane>  
            </Panes>
        </ajaxToolkit:Accordion>
        <asp:LinkButton ID="lnkReloadSett" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkReloadNonDep" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkUpdateSettFees" runat="server"></asp:LinkButton>
        <obo:Flyout ID="DialFlyout" runat="server" Align="LEFT" Position="BOTTOM_CENTER"
            OpenTime="100" OpenEvent="NONE" CloseEvent="NONE">
            <div style="background-color: #D6E7F3; border: solid 1px Navy; width: 240px;">
                <table cellpadding="5" width="100%">
                    <tr>
                        <td>
                            Reason:
                        </td>
                        <td align="right">
                            <a href="javascript: void 0" onclick="<%=DialFlyout.getClientID()%>.Close();">
                                <img id="imgCloseReject" src='<%=ResolveUrl("~/images/16x16_close.png") %>' title="Close"
                                    alt="Close" />
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:DropDownList ID="ddlRejectReason" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdProgressReject" runat="server" DisplayAfter="0" AssociatedUpdatePanelID="updReject"
                                DynamicLayout="false">
                                <ProgressTemplate>
                                    <img src="<%=ResolveUrl("~/images/loading.gif") %>" alt="loading ..." />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:UpdatePanel ID="UpdReject" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true"
                                RenderMode="Inline">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lnkRejectOK" runat="server">OK</asp:LinkButton>&nbsp; <a href="javascript: void 0"
                                        onclick="<%=DialFlyout.getClientID()%>.Close();">Cancel</a>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </div>
        </obo:Flyout>
        <obo:Flyout ID="ManAppFlyout" runat="server" Align="LEFT" Position="TOP_RIGHT" OpenTime="100"
            OpenEvent="NONE" CloseEvent="NONE" EnableViewState="true" IsModal="true">
            <div style="background-color: #D6E7F3; border: solid 1px Navy; width: 240px;">
                <table cellpadding="4" width="100%" cellspacing="0">
                    <tr style="background-color: #4791c5;">
                        <th align="left">
                            Authorize
                        </th>
                        <th align="right">
                            <a href="javascript: void 0" onclick="<%=ManAppFlyout.getClientID()%>.Close();">
                                <img id="img2" src='<%=ResolveUrl("~/images/16x16_close.png") %>' title="Close" alt="Close" />
                            </a>
                        </th>
                    </tr>
                    <tr>
                        <td style="padding">
                            Manager:
                        </td>
                        <td>
                            <asp:TextBox ID="txtManager" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Password:
                        </td>
                        <td>
                            <asp:TextBox ID="txtManagerPwd" runat="server" TextMode="Password"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="updProgressFees" runat="server" DisplayAfter="0" AssociatedUpdatePanelID="updFees"
                                DynamicLayout="false">
                                <ProgressTemplate>
                                    <img src="<%=ResolveUrl("~/images/loading.gif") %>" alt="loading ..." />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updFees" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true"
                                RenderMode="Inline">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lnkEditFeeAppr" runat="server">OK</asp:LinkButton>&nbsp;
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <a href="javascript: void 0" onclick="<%=ManAppFlyout.getClientID()%>.Close();">Cancel</a>
                        </td>
                    </tr>
                </table>
            </div>
        </obo:Flyout>
        <obo:Flyout ID="FlyoutNote" runat="server" Align="LEFT" Position="BOTTOM_LEFT" OpenTime="100"
            OpenEvent="ONCLICK" CloseEvent="NONE" EnableViewState="true" IsModal="true" AttachTo="lnkAddNote">
            <div style="background-color: #D6E7F3; border: solid 1px Navy; width: 410px; height: 160px;">
                <table cellpadding="4" width="100%" cellspacing="0">
                    <tr style="background-color: #4791c5;">
                        <td style="text-align: left; font-weight: bold; ">
                            Add Note
                        </td>
                        <td  style="text-align: right;" >
                            <a href="javascript: void 0" onclick="<%=FlyoutNote.getClientID()%>.Close();ClearNotes();" >
                                <img id="imgFOClose" src='<%=ResolveUrl("~/images/16x16_close.png") %>' title="Close" alt="Close" />
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Style="width: 395px;
                                height: 100px; font-family: Tahoma; font-size: 11px;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30px">
                            <asp:UpdateProgress ID="UpdateProgressNote" runat="server" DisplayAfter="0" AssociatedUpdatePanelID="UpdateAddNote"
                                DynamicLayout="false">
                                <ProgressTemplate>
                                    <img src="<%=ResolveUrl("~/images/loading.gif") %>" alt="loading ..." />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td >
                            <asp:UpdatePanel ID="UpdateAddNote" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true"
                                RenderMode="Inline">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lnkSaveNote" runat="server">Save</asp:LinkButton>&nbsp;
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <a href="javascript: void 0" onclick="<%=FlyoutNote.getClientID()%>.Close();ClearNotes();">
                                Cancel</a>
                        </td>
                    </tr>
                </table>
            </div>
        </obo:Flyout>
        <obo:Flyout ID="FlyoutApplicants" runat="server" Align="LEFT" Position="BOTTOM_RIGHT" OpenTime="100"
            OpenEvent="ONCLICK" CloseEvent="ONMOUSEOUT"  EnableViewState="true" IsModal="true" AttachTo="lblCoApp">
            <div style="padding: 3px; background-color: #FFFFFF; border: solid 1px #000000; overflow:scroll;  ">
                 <table  style="font-size:11px; font-family:tahoma;" cellspacing="0" cellpadding="3" width="800px" >
                    <tr>
                        <td class="gridviewHeader" style="width:15px;" align="center">3rd</td>
                        <td class="gridviewHeader" style="width:25px;">Type</td>
                        <td class="gridviewHeader" style="width:55px;">First Name</td>
                        <td class="gridviewHeader" style="width:55px;">Last Name</td>
                        <td class="gridviewHeader" style="width:60px;" nowrap="nowrap">(Age) DOB</td>
                        <td class="gridviewHeader" style="width:150px;">Address</td>
                        <td class="gridviewHeader" style="width:75px;">Contact Type</td>
                        <td class="gridviewHeader" style="width:180px;">Number</td>
                    </tr>
                    <asp:repeater id="rpApplicants" runat="server">
                        <itemtemplate>
	                        <tr>
	                            <td style="padding-top:6;width:25;"  class="gridviewItem" valign="top" align="center">
	                                <%#IIf(DataBinder.Eval(Container.DataItem, "ThirdParty"), "Yes", "No")%>
	                            </td>
	                            <td style="padding-top:6;" class="gridviewItem" valign="top" align="left" >
	                                <%#DataBinder.Eval(Container.DataItem, "Relationship")%>
	                            </td>
	                            <td style="padding-top:6;" class="gridviewItem" valign="top" align="left">
	                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
	                            </td>
	                            <td style="padding-top:6;" class="gridviewItem" valign="top" align="left" >
	                                <%#DataBinder.Eval(Container.DataItem, "LastName")%>
	                            </td>
	                            <td style="padding-top:6;" class="gridviewItem" valign="top" align="left">
	                                <%#DataBinder.Eval(Container.DataItem, "AgeAndDateOfBirth")%>
	                            </td>
		                        <td style="padding-top:6;" class="gridviewItem" nowrap="true" valign="top" align="left">
		                            <%#DataBinder.Eval(Container.DataItem, "Address").ToString.Replace(vbCrLf, "<br>")%>&nbsp;
		                        </td>
		                        <td style="padding-top:0; white-space: nowrap;" class="gridviewItem" colspan="2" valign="top" align="left">
		                            <asp:Literal runat="server" id="lblPhones"></asp:Literal>
		                        </td>
	                        </tr>
                        </itemtemplate>
                     </asp:repeater>
                </table>
            </div>
        </obo:Flyout>
        <asp:HiddenField ID="hdnCurrentSettId" runat="server" />
        <asp:HiddenField ID="hdnSettlementFee" runat="server" />
        <asp:HiddenField ID="hdnDeliveryFee" runat="server" />
        <asp:HiddenField ID="hdnPersonId" runat="server" />
        <asp:HiddenField ID="hdnSettCount" runat="server" />
        <asp:LinkButton ID="lnkChangePerson" runat="server" />
        <asp:DropDownList ID="ddlPerson" runat="server" Visible="false">
        </asp:DropDownList>
    </ContentTemplate>
</asp:UpdatePanel>

