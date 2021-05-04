<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="selection.aspx.vb" Inherits="admin_settings_negotiation_selection" title="DMP - Admin Settings - Rules" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript">
function Record_Save()
{
    if (RequiredExist())
    {
        <%=ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
}
function Record_SaveAndClose()
{
    if (RequiredExist())
    {
        <%=ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
    }
}
function Record_Cancel(){<%=ClientScript.GetPostBackEventReference(lnkCancel, Nothing) %>;}

function RequiredExist()
{
    var txtHireDate1 = document.getElementById("<%=txtHireDate1.ClientID %>");
    var txtHireDate2 = document.getElementById("<%=txtHireDate2.ClientID %>");
    var date1 = txtHireDate1.value.substring(0, 6) + "20" + txtHireDate1.value.substr(6,2);
    var date2 = txtHireDate2.value.substring(0, 6) + "20" + txtHireDate2.value.substr(6,2);
    
    if (txtHireDate2.value.length > 0 && !IsValidDateTime(date1))
    {
        ShowMessage("Hire Date Period beginning date is invalid");
        AddBorder(txtHireDate1);
        return false;
    }
    else
    {
        RemoveBorder(txtHireDate1);
    }
    
    if (txtHireDate2.value.length > 0 && !IsValidDateTime(date2))
    {
        ShowMessage("Hire Date Period ending date is invalid");
        AddBorder(txtHireDate2);
        return false;
    }
    else
    {
        RemoveBorder(txtHireDate2);
    }
    HideMessage();
    return true;
}
function ShowMessage(Value)
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    dvError.style.display = "inline";
    tdError.innerHTML = Value;
}
function HideMessage()
{
    var dvError = document.getElementById("<%= dvError.ClientID %>");
    var tdError = document.getElementById("<%= tdError.ClientID %>");

    tdError.innerHTML = "";
    dvError.style.display = "none";
}

function AddBorder(obj)
{
    obj.style.border = "solid 2px red";
    obj.focus();
}
function RemoveBorder(obj)
{
    obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
    obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
}
</script>
<style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
</style>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
    <tr>
        <td style="color: #666666;">
            <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/rules/">Rules</a>&nbsp;>&nbsp;Negotiation: Client Selection</td>
    </tr>
    <tr id="trInfoBox" runat="server">
        <td>
            <div class="iboxDiv">
                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img id="Img3" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td>
                            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="iboxHeaderCell">INFORMATION:</td>
                                    <td class="iboxCloseCell" valign="top" align="right"><!--<asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img4" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>--></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="iboxMessageCell">
                                        The selection criteria below determine what clients qualify 
                                        to be auto-assigned to negotiators.  Only clients which meet 
                                        ALL of the following criteria qualify.  These criteria correspond 
                                        to the criteria in the "Accounts Over Percentage" report; 
                                        identical criteria will render identical selection results.
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr runat="server" id="dvError" style="display:none;">
        <td valign="top">
            <div >
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		            <tr>
			            <td valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
			            <td runat="server" id="tdError"></TD>
		            </TR>
	            </table>
	        </div>
        </td>
    </tr>
    <tr>
        <td>
            <table style="margin:0 20 20 0;float:left;font-family:tahoma;font-size:11px;width:200;" border="0" cellpadding="0" cellspacing="5">
                <tr>
                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Client Criteria</td>
                </tr>
                <tr>
                    <td style="padding-top:10;">Hire Date Period</td>
                </tr>
                <tr>
                    <td>
                        <table style="font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                            <tr>
                                <td nowrap="true" style="width:15;">1:</td>
                                <td nowrap="true" style="width:60px;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtHireDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                <td nowrap="true" style="width:15;">2:</td>
                                <td nowrap="true" style="width:60px;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtHireDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-top:10;">
                        <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optClientStatusChoice">
                            <asp:ListItem value="False" text="Exclude Statuses"/>
                            <asp:ListItem value="True" text="Include Statuses" selected="true"/>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csClientStatusID" SelectedRows="3"></asi:SmartCriteriaSelector>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optAgencyChoice">
                            <asp:ListItem value="False" text="Exclude Agencies"/>
                            <asp:ListItem value="True" text="Include Agencies" selected="true"/>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csAgencyID" SelectedRows="3"></asi:SmartCriteriaSelector>
                    </td>
                </tr>
                
            </table>
            <table style="margin:0 20 20 0;float:left;font-family:tahoma;font-size:11px;width:200;" border="0" cellpadding="0" cellspacing="5">
                <tr>
                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Account Criteria</td>
                </tr>
                <tr>
					<td style="padding-top:10;">Account Bal. Range:</td>
				</tr>
                <tr>
                    <td>
                        <table style="font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                            <tr>
                                <td nowrap="true" >$&nbsp;<input type="text" style="font-size: 11px; font-family: Tahoma;width:50" runat="server" id="txtAccountBal1" onkeypress="AllowOnlyNumbers()"/></td>
                                <td nowrap="true" >&nbsp;to&nbsp;</td>
                                <td nowrap="true" >$&nbsp;<input type="text" style="font-size: 11px; font-family: Tahoma;width:50" runat="server" id="txtAccountBal2" onkeypress="AllowOnlyNumbers()" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-top:10;">
                        <asp:RadioButtonList CssClass="entry" cellpadding="0" cellspacing="0" runat="server" id="optAccountStatusChoice">
                            <asp:ListItem value="False" text="Exclude Acct. Statuses"/>
                            <asp:ListItem value="True" text="Include Acct. Statuses" selected="true"/>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;" selectorstyle="font-family:tahoma;font-size:11px;width:100%;" runat="server" id="csAccountStatusID" SelectedRows="3"></asi:SmartCriteriaSelector>
                    </td>
                </tr>
            </table>
            <table style="margin:0 20 20 0;float:left;font-family:tahoma;font-size:11px;width:200;" border="0" cellpadding="0" cellspacing="5">
                <tr>
                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">General Criteria</td>
                </tr>
                <tr>
                    <td style="padding-top:10;">
                        <table style="font-family:tahoma;font-size:11;" cellpadding="0" border="0" cellspacing="0">
                            <tr>
                                <td nowrap>Threshold %:&nbsp;</td>
                                <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtThresholdPercent1" onkeypress="AllowOnlyNumbers()"/></td>
                                <td nowrap="true" >&nbsp;to&nbsp;</td>
                                <td nowrap="true" style=""><input type="text" style="font-size: 11px; font-family: Tahoma;width:25" runat="server" id="txtThresholdPercent2" onkeypress="AllowOnlyNumbers()" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:CheckBox id="chkUnassignedOnly" runat="server" checked="true" text="Unassigned Only"></asp:CheckBox>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
    <asp:linkbutton id="lnkCancel" runat="server"></asp:linkbutton>
   <asp:linkbutton id="lnkSave" runat="server"></asp:linkbutton>
   <asp:linkbutton id="lnkSaveAndClose" runat="server"></asp:linkbutton>
</body>
</asp:PlaceHolder></asp:Content>
