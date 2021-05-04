<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientApprovalTask.ascx.vb"
    Inherits="processing_webparts_ClientApprovalTask" %>
<%@ Register Src="../../CustomTools/UserControls/DialerSchedule.ascx" TagName="DialerSchedule"
    TagPrefix="uc1" %>
<link id="Link1" href="<%= ResolveUrl("~/css/default.css")%>" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

<script language="javascript" type="text/javascript">
     var ddlApprovalType = null;
    var txtNotes = null;
    var rdAccept = null;
     var rdReject = null;
    var ddlReason=null;
    var currSettFee=null;
    var adjSettFee=null;
    var currDelFee=null;
    var adjDelFee=null;
    var btnSave = null;
    var btnCancel = null;
    
    function LoadControls() {
        ddlApprovalType = document.getElementById("<%= ddlApprovalType.ClientID %>");
        txtNotes = document.getElementById("<%=txtNotes.ClientID %>");
        rdAccept = document.getElementById("<%=radAccept.ClientID %>")
        rdReject = document.getElementById("<%=radReject.ClientID %>")
        ddlReason = document.getElementById("<%=ddlReason.ClientID %>")
        currSettFee = document.getElementById("<%=hdnSettlementFee.ClientID %>")
        adjSettFee = document.getElementById("<%=txtSettlementFee.ClientID %>")
        currDelFee = document.getElementById("<%=hdnDeliveryAmount.ClientID %>")
        adjDelFee = document.getElementById("<%=txtDeliveryAmount.ClientID %>")
    }

     function ChangeStatus(i) {
        //dvReason
       LoadControls()
        if (i == 1) {
            document.getElementById("trReason").style.display = "";
            document.getElementById("<%=trSave.ClientID %>").style.display = "";
        }
        else {
            document.getElementById("trReason").style.display = "none";
            
            if (ddlApprovalType.value == "Verbal"){
                document.getElementById("<%=trSave.ClientID %>").style.display = "none";
            }
        }
    }
    
    function lnkSave_OnClick()
    {    
     LoadControls();
     HideMessage();
     
        if (rdReject.checked)
        {
           RemoveBorder(ddlReason);
        }
        if (txtNotes!=null) RemoveBorder(txtNotes);
        RemoveBorder(rdAccept);
        RemoveBorder(rdReject);
        RemoveBorder(ddlApprovalType);

        if (ddlApprovalType.value == "") {
                ShowMessage("Please select Approval type");
                AddBorder(ddlApprovalType);
                return false;
            }
        if (rdReject.checked ) {
            if (txtNotes != null){
                if (txtNotes.value == ""){
                    ShowMessage("Please enter the notes");
                    AddBorder(txtNotes);
                    return false;
                }
            }
        }
        
        if (!(rdReject.checked || rdAccept.checked)) {
            ShowMessage("Please select status");
            AddBorder(rdAccept);
            AddBorder(rdReject);
            return false;
        }

        if (rdReject.checked) {
            if (ddlReason.value == "") {
                ShowMessage("Please select reason for rejection");
                AddBorder(ddlReason);
                return false;
            }
        }
        
        
    }
    
    function ApplyFee(){
    		LoadControls();
            var url = '<%= ResolveUrl("~/processing/popups/FeeAdjustment.aspx") %>?t=Fee Adjustments&sid=<%=SettlementID %>&delfee=' +adjDelFee.value +'&settfee='+ adjSettFee.value;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Fee Adjustments",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 650, width: 600,
                       onClose: function(){
                                    if ($(this).modaldialog("returnValue") == -1){
                                        window.location =window.location.href.replace(/#/g,"") ;     
                                    }
                                }
                       });   
           
    }
    
    function lnkCancel_OnClick()
    {
        <%=Page.ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;
    }   
    
     function AddBorder(obj) {
        obj.style.border = "solid 2px red";
        obj.focus();
    }
    function RemoveBorder(obj) {
        obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
    }

    function ShowMessage(Value) {

        var dvError = document.getElementById("<%= dvError.ClientID %>");
        var tdError = document.getElementById("<%= tdError.ClientID %>");

        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage() {
        var dvError = document.getElementById("<%= dvError.ClientID %>");
        var tdError = document.getElementById("<%= tdError.ClientID %>");

        tdError.innerHTML = "";
        dvError.style.display = "none";
    }
    
</script>

<table style="width: 98%;" cellpadding="4" cellspacing="0">
    <tbody>
        <tr>
            <td colspan="3" align="left" style="background-color: #DCDCDC; border-bottom: solid 1px #d3d3d3;
                font-weight: bold; color: Black; font-size: 11px; font-family: tahoma; padding: 4px">
                Client Approval Information
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="400px" border="0">
                        <tr>
                            <td valign="top" style="width: 20;">
                                <img id="Img5" alt="" runat="server" src="~/images/message.png" align="absmiddle"
                                    border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
            </td>
        </tr>
        <tr>
            <td class="entryFormat">
                Settlement Fee:
            </td>
            <td>
                $<asp:TextBox ID="txtSettlementFee" runat="server" CssClass="entry2" Width="100px"></asp:TextBox>
                <asp:HiddenField ID="hdnSettlementFee" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="entryFormat">
                Delivery Cost:
            </td>
            <td>
                $<asp:TextBox ID="txtDeliveryAmount" runat="server" CssClass="entry2" Width="100px"></asp:TextBox>
                &nbsp;<a href="javascript:ApplyFee();">Update Fee</a>
                <asp:HiddenField ID="hdnDeliveryAmount" runat="server" />
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap" class="entryFormat">
                Approval Type:
            </td>
            <td>
                <asp:Label ID="lblApprovalType" runat="server" CssClass="entryFormat" />
                <asp:DropDownList ID="ddlApprovalType" Width="100" runat="server" AutoPostBack="true"
                    CssClass="entryFormat">
                    <asp:ListItem Text="Written">Written</asp:ListItem>
                    <asp:ListItem Text="Verbal">Verbal</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <div id="dvWritten" runat="server">
            <tr>
                <td style="vertical-align: top" class="entryFormat">
                    Notes:
                </td>
                <td>
                    <asp:Label ID="lblNotes" runat="server" CssClass="entryFormat" />
                    <asp:TextBox ID="txtNotes" CssClass="entry2" Style="overflow: auto;" Rows="5" TextMode="MultiLine"
                        Width="300px" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblSuspendDialer" runat="server" CssClass="entryFormat" Text="Suspend Settl. Dialer Until:" />
                </td>
                <td>
                    <uc1:DialerSchedule ID="DialerScheduler" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblStatusHeader" Text="Status:" runat="server" CssClass="entryFormat" />
                </td>
                <td>
                    <asp:Label ID="lblStatus" runat="server" CssClass="entryFormat" />
                    <asp:RadioButton ID="radAccept" GroupName="radStatus" Text="Accept" runat="server"
                        CssClass="entryFormat" />
                    <asp:RadioButton ID="radReject" GroupName="radStatus" Text="Reject" runat="server"
                        CssClass="entryFormat" />
                </td>
            </tr>
            <tr id="trReason" style="display: none">
                <td>
                    <asp:Label ID="lblReasonText" CssClass="entryFormat" Text="Rejection Reason:" runat="server" />
                    <asp:Label ID="lblReason" CssClass="entryFormat" runat="server" Text="Rejection Reason:"
                        Visible="true" />
                </td>
                <td>
                    <asp:DropDownList ID="ddlReason" CssClass="entryFormat" Width="250px" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td width="90px">
                    &nbsp;
                </td>
                <td id="trSave" runat="server" style="padding-top: 5px">
                    <asp:ImageButton ID="lnkSave" ImageUrl="~/processing/images/Save_off.png" OnClientClick="javascript:return lnkSave_OnClick();"
                        onmouseout="javascript:SwapImage(this);" onmouseover="javascript:SwapImage(this);"
                        AlternateText="" runat="server" />
                    <asp:ImageButton ID="lnkCancel" ImageUrl="~/processing/images/Cancel_off.png" OnClientClick="javascript:return lnkCancel_OnClick();"
                        onmouseout="javascript:SwapImage(this);" onmouseover="javascript:SwapImage(this);"
                        AlternateText="" runat="server" />
                </td>
            </tr>
        </div>
    </tbody>
</table>
