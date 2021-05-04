<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CreditorInfoControl.ascx.vb"
    Inherits="negotiation_webparts_CreditorInfoControl" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>

<style type="text/css">
    .lorModalBackground
    {
        background-color: #808080;
        filter: alpha(opacity=70);
        opacity: 0.7;
        z-index: 10000;
    }
    .lorModalPopup
    {
        background-color: #F5FAFD;
        filter: progid:DXImageTransform.Microsoft.dropShadow(color=black,offX=5,offY=5, positive=true);
        border-width: 1px;
        border-style: ridge;
        border-color: Gray;
        padding: 0px;
        position: absolute;
        width: 600px;
    }
    .unverifLabel
    {
    	font-weight: normal;
    	color: Gray;
    	}
    .verifLabel
    {
    	font-weight: bold;
    	}
    .verifText
    {   border: solid 1px #bedce6;
        background-color: rgb(255, 255, 255);
        padding: 1px 1px 1px 4px;
    	}
    .verifHilite
    {
    	background-color: #009900;
    	cursor: pointer;
    	}
</style>

    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
 
 <script type="text/javascript" > 
 
          function make_call(phonenumber) {
                window.top.parent.MakeOutboundCall(phonenumber);    
          }   
                 
          function SwapImage(obj){
            var src;
            if (obj.children.length > 0){
                src = obj.children(0).src;
                obj = obj.children(0);
            }else{
                if (obj.src != null){
                    src = obj.src;
                }else{
                    return;
                }
            }
            
            if (src.indexOf('_off') == -1){
                obj.src = src.replace('_over', '_off');
            }else{
                obj.src = src.replace('_off', '_over');
            }
        }
    function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
    {
        var btnName = btn.id
        btnName = btnName.substring(btnName.lastIndexOf("_")+1);
        if (btnName == 'btnForCreditor'){
            var txt = document.getElementById('<% =txtEditForCreditorName.ClientID %>');
            txt.value = name.replace('&amp;','&');
            var hid = document.getElementById('<% =hdnforCreditorInfo.ClientID %>');
            hid.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
        }else{
            //curr cred
            var txt = document.getElementById('<% =txtEditCurrCreditorName.ClientID %>');
            txt.value = name.replace('&amp;','&');
            var hid = document.getElementById('<% =hdnCurrCreditorInfo.ClientID %>');
            hid.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
        }
        }
    function FindCreditor(btn)
    {
        var creditor = btn.creditor;
        var street = btn.street;
        var street2 = btn.street2;
        var city = btn.city;
        var stateid = btn.stateid;
        var zipcode = btn.zipcode;

        if (creditor==null)creditor="";
        if (street==null)street="";
        if (street2==null)street2="";
        if (city==null)city="";
        if (stateid==null)stateid="";
        if (zipcode==null)zipcode="";

        // open the find window
        var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?")%>' + 
                    'creditor=' + encodeURIComponent(creditor) + 
                    '&street=' + encodeURIComponent(street) + 
                    '&street2=' + encodeURIComponent(street2) + 
                    '&city=' + encodeURIComponent(city) + 
                    '&stateid=' + encodeURIComponent(stateid) + 
                    '&zipcode=' + encodeURIComponent(zipcode);
                    
        window.dialogArguments = new Array(window, btn, "CreditorFinderReturn");
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
            dialogArguments: window,
            resizable: false,
            scrollable: false,
            height: 700, width: 650
        });   
    } 
        
  function closeLORPopup() {
   
        var modalPopupBehavior = $find('mpeLORBehavior');
        modalPopupBehavior.hide();
        return false;
    }   
function sendForm(elem,sendType){

    var dv = elem.parentElement;
    var ctls = dv.getElementsByTagName('input');
    var emailAddr = '';
    for (i=0;i<=ctls.length;i++) {
        if (ctls[i].type='text'){
            emailAddr = ctls[i].value;
            break;
        }
    }
    var pdf = document.getElementById('<%=hdnLorPath.ClientID %>');
    var crID = document.getElementById('<%=hdnCreditorInstanceID.ClientID %>');
    var cid = document.getElementById('<%=hdndataClientID.ClientID %>');
    var uid = <%=UserID %>;
        
    //dataClientID , sendType, sendTo, LORPAth     
    PageMethods.PM_sendLOR(cid.value, crID.value, sendType, emailAddr,pdf.value,uid, EmailSentComplete,EmailSentError);             

    return false;
}
 function EmailSentError(error, userContext, methodName) {
    if (error != null) {
        alert(error.get_message());
    }
}
function EmailSentComplete(result, userContext, methodName) {
   alert(result);
   closeLORPopup();
}    
</script>



<asp:UpdatePanel ID="upCred" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
    <ContentTemplate>
        <div id="divCreditor" runat="server">
            <table style="width: 275px; display: block;" id="tblEdit" class="box" runat="server">
                <tr>
                    <td nowrap="nowrap" align="right" style="width: 85px;">
                        <asp:Label ID="Label1" Font-Bold="True" Text="Orig. Creditor:" runat="server" />
                    </td>
                    <td nowrap="nowrap" align="left">
                        <div>
                            <asp:TextBox ID="txtEditForCreditorName" Enabled="false" Width="140px" TabIndex="11"
                                runat="server" />
                            <asp:HiddenField ID="hdnforCreditorInfo" runat="server" />
                        </div>
                        <div>
                            <asp:ImageButton Style="display: none;" ID="btnForCreditor" ImageUrl="~/negotiation/images/ellipse_off.png"
                                OnClientClick="FindCreditor(this);" Text="..." runat="server" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label2" Font-Bold="True" Text="Curr. Creditor:" runat="server" /><br />
                        <asp:LinkButton ID="lnkViewTrends" runat="server" Text="View Trend" />
                    </td>
                    <td nowrap="nowrap" align="left">
                        <div>
                            <asp:TextBox ID="txtEditCurrCreditorName" Enabled="false" Width="140px" TabIndex="12"
                                runat="server" />
                            <asp:HiddenField ID="hdnCurrCreditorInfo" runat="server" />
                        </div>
                        <div>
                            <asp:ImageButton ID="btnCurrCreditorInfo" ImageUrl="~/negotiation/images/ellipse_off.png"
                                OnClientClick="FindCreditor(this);" Text="..." runat="server" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label10" Font-Bold="True" Text="Date Acquired:" runat="server" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <div>
                            <asp:TextBox ID="txtEditAcquired" Enabled="false" TabIndex="13" Width="75px" runat="server" />
                        </div>
                        <div>
                            <asp:ImageButton ID="Image1" AlternateText="Click to show calendar" ImageUrl="~/images/Calendar_scheduleHS.png"
                                runat="Server" />
                        </div>
                        <ajaxToolkit:CalendarExtender ID="txtEditAcquired_CalendarExtender" CssClass="MyCalendar"
                            PopupButtonID="image1" TargetControlID="txtEditAcquired" runat="server">
                        </ajaxToolkit:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label5" Font-Bold="True" Text="Orig. Bal:" runat="server" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditOrigAmt" TabIndex="14" Style="text-align: right" Width="60px"
                            runat="server"> </asp:TextBox>
                        <asp:Literal ID="ltrVerified" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label6" Font-Bold="True" Text="Curr. Bal:" runat="server" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditCurrAmt" TabIndex="15" Style="text-align: right" Width="60px"
                            runat="server"> </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label3" Font-Bold="True" Text="Acct #:" runat="server" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditAcctNum" ReadOnly="true" TabIndex="16" Width="100px" runat="server"> </asp:TextBox>
                        &nbsp;<asp:Image ID="ImgAcctNum" runat="server" ImageUrl="~/images/p_dialpad.png"
                            Style="cursor: hand;" ToolTip="Dial Account Number" />
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 85px;">
                        <asp:Label ID="Label4" Font-Bold="True" Text="Ref #:" runat="server" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditRefNum" TabIndex="17" Width="100px" runat="server"> </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                        <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Contact Name:" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditFirst" TabIndex="1" Width="75px" runat="server" ToolTip="First Name" />&nbsp;
                        <asp:TextBox ID="txtEditLast" TabIndex="2" Width="100px" runat="server" ToolTip="Last Name" />
                        <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender1" runat="server"
                            TargetControlID="txtEditFirst" WatermarkText="First Name">
                        </ajaxToolkit:TextBoxWatermarkExtender>
                        <ajaxToolkit:TextBoxWatermarkExtender ID="TextBoxWatermarkExtender2" runat="server"
                            TargetControlID="txtEditLast" WatermarkText="Last Name">
                        </ajaxToolkit:TextBoxWatermarkExtender>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Tel Number:" />
                    </td>
                    <td nowrap="nowrap" align="left">
                        <asp:TextBox ToolTip="Area Code" Width="30px" ID="txtEditArea" TabIndex="3" onkeyup="javascript:MoveToNext(this, 4);"
                            runat="server" />
                        <ajaxToolkit:MaskedEditExtender ID="meeArea" runat="server" TargetControlID="txtEditArea"
                            MaskType="Number" Mask="(999)" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                        <asp:TextBox ID="txtEditNumber" Width="55px" ToolTip="Phone Number" TabIndex="4"
                            onkeyup="javascript:MoveToNext(this, 8);" runat="server" />
                        <ajaxToolkit:MaskedEditExtender ID="meeNumber" runat="server" TargetControlID="txtEditNumber"
                            MaskType="Number" Mask="999-9999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                        <asp:Image ID="imgCredPH" runat="server" ImageUrl="~/images/phone2.png" Style="cursor: hand;"
                            ToolTip="Make Call" />
                        <asp:TextBox Width="35px" ID="txtEditExt" ToolTip="Extension if available." TabIndex="5"
                            onkeyup="javascript:MoveToNext(this, 5);" runat="server" />
                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtEditExt"
                            MaskType="None" Mask="99999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                        <asp:Image ID="imgCredExt" runat="server" ImageUrl="~/images/p_dialpad.png" Style="cursor: hand;"
                            ToolTip="Dial Extension" />
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Fax Number:" />
                    </td>
                    <td nowrap="nowrap" align="left">
                        <asp:TextBox ToolTip="Area Code" Width="30px" ID="txtEditFaxArea" TabIndex="6" onkeyup="javascript:MoveToNext(this, 4);"
                            runat="server" />
                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtEditFaxArea"
                            MaskType="Number" Mask="(999)" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                        <asp:TextBox Width="55px" ToolTip="Fax Number" ID="txtEditFax" TabIndex="7" onkeyup="javascript:MoveToNext(this, 8);"
                            runat="server" />
                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtEditFax"
                            MaskType="Number" Mask="999-9999" ClearMaskOnLostFocus="true" PromptCharacter="_" />
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Email:" />
                    </td>
                    <td align="left" nowrap="nowrap">
                        <asp:TextBox ID="txtEditEmail" Width="150px" TabIndex="8" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 85px;">
                        &nbsp;
                    </td>
                    <td>
                        <asp:ImageButton ID="ibtnUpdate" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);"
                            Style="float: left;" CausesValidation="true" CommandName="Update" ImageUrl="~/negotiation/images/save_off.png"
                            TabIndex="18" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
        <obo:Flyout ID="obTrends" runat="server" AttachTo="lnkViewTrends" Position="BOTTOM_RIGHT">
            <div style="border: 2px solid #3376AB; background-color: #C6DEF2;">
                <asp:GridView ID="gvTrends" runat="server" DataSourceID="dsTrends" AutoGenerateColumns="False"
                    CssClass="entry">
                    <Columns>
                        <asp:BoundField DataField="TimeFrame" HeaderText="" ReadOnly="True" SortExpression="TimeFrame"
                            ShowHeader="false" ItemStyle-HorizontalAlign="center">
                            <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Wrap="false" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TotalUnits" HeaderText="Total Units" ReadOnly="True" SortExpression="TotalUnits"
                            ItemStyle-HorizontalAlign="center">
                            <HeaderStyle HorizontalAlign="Center" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Center" Font-Names="tahoma" Font-Size="Small" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TotalSettlementAmt" HeaderText="Total Sett $" DataFormatString="{0:c2}"
                            ReadOnly="True" SortExpression="TotalSettlementAmt">
                            <HeaderStyle HorizontalAlign="Right" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                        </asp:BoundField>
                        <asp:BoundField DataField="MinSettlementPct" HeaderText="Low Sett %" DataFormatString="{0:p2}"
                            ReadOnly="True" SortExpression="MinSettlementPct">
                            <HeaderStyle HorizontalAlign="Right" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" CssClass="listItem" Wrap="false" />
                        </asp:BoundField>
                        <asp:BoundField DataField="MaxSettlementPct" HeaderText="High Sett %" DataFormatString="{0:p2}"
                            ReadOnly="True" SortExpression="MaxSettlementPct">
                            <HeaderStyle HorizontalAlign="Right" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Right" CssClass="listItem" Wrap="false" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AvgSettlementPct" HeaderText="Avg Sett %" DataFormatString="{0:p2}"
                            ReadOnly="True" SortExpression="AvgSettlementPct">
                            <HeaderStyle HorizontalAlign="Right" CssClass="headitem5" />
                            <ItemStyle HorizontalAlign="Right" CssClass="listItem" Wrap="false" />
                        </asp:BoundField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Trends Available!
                    </EmptyDataTemplate>
                    <HeaderStyle Font-Names="Tahoma" Font-Size="Large" />
                </asp:GridView>
                <asp:SqlDataSource ID="dsTrends" ConnectionString="<%$ AppSettings:connectionstring %>"
                    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_Report_CreditorTrendsByCreditor"
                    SelectCommandType="StoredProcedure" EnableCaching="true">
                    <SelectParameters>
                        <asp:Parameter Name="creditorName" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </obo:Flyout>
        <asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnAcctID" runat="server" />
        <asp:HiddenField ID="hdnCreditorInstanceID" runat="server" />
        <asp:HiddenField ID="hdnOriginalCreditorID" runat="server" />
        <asp:HiddenField ID="hdnCurrentCreditorName" runat="server" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ibtnUpdate" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnForCreditor" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCurrCreditorInfo" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
<asp:Button ID="btnDummy" runat="server" Style="display: none;" />
<ajaxToolkit:ModalPopupExtender ID="mpeLOR" BehaviorID="mpeLORBehavior" runat="server"
    BackgroundCssClass="lorModalBackground" PopupControlID="pnlLOR" PopupDragHandleControlID="pnlDrag"
    TargetControlID="btnDummy" Y="20">
</ajaxToolkit:ModalPopupExtender>
<asp:Panel ID="pnlLOR" runat="server" CssClass="lorModalPopup" Style="display: none">
    <asp:Panel ID="pnlDrag" runat="server" Style="display: block;" CssClass="PanelDragHeader"
        Width="100%">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr class="headerstyle">
                <td align="left" style="padding-left: 10px;">
                    <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="New Letter Of Representation Generated" />
                </td>
                <td align="right" style="padding-right: 5px;">
                    <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="return closePopup();"
                        ImageUrl="~/images/16x16_close.png" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlSettLORForm" Style="display: block; text-align: center;" runat="server"
        CssClass="entry">
        <table class="entry" border="0" style="width: 100%; background-color: #DCDCDC; border-top: solid 1px #3D3D3D;
            height: 500px">
            <tr valign="top">
                <td style="height: 50px; padding:5px;">
                    <div id="msg" runat="server" style="display:none;"></div>
                    <fieldset>
                        <legend>
                            Send form by Email
                        </legend>
                        <asp:TextBox ID="txtEmailAddr" runat="server" CssClass="entry" Width="75%"  />
                        <asp:Button ID="btnEmail" runat="server" Text="Email" OnClientClick="return sendForm(this,'e');"
                            CssClass="fakeButtonStyle" Width="50" />
                    </fieldset>
                    <fieldset style="display:none;">
                        <legend>
                            Send form by Fax
                        </legend>
                        <asp:TextBox ID="txtFaxNumber" runat="server" CssClass="entry" Width="75%"  />
                        <asp:Button ID="btnFax" runat="server" Text="Fax" OnClientClick="return sendForm(this,'f');"
                            CssClass="fakeButtonStyle" Width="50" />
                    </fieldset>
                </td>
            </tr>
            <tr valign="top">
                <td>
                    <asp:PlaceHolder ID="phDocuments" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="height: 30px;">
                    <div class="entry" style="text-align: right; padding-right: 3px; height: 15px; vertical-align: middle;">
                        <asp:Button ID="btnClose" runat="server" Text="Close" OnClientClick="return closeLORPopup();"
                            CssClass="fakeButtonStyle" />
                    </div>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Panel>
<asp:HiddenField ID="hdnLorPath" runat="server" />
<asp:HiddenField ID="hdnPOAPath" runat="server" />
<asp:HiddenField ID="hdnDataClientID" runat="server" />
