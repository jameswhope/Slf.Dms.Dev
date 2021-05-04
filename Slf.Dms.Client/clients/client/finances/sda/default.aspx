﻿<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="clients_client_finances_sda_default" Title="DMP - Client - SDA Structure" %>

<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="server">
    <style>
        .voidTran {color:rgb(160,160,160);}
        .ConfirmTable{border: #969696 1px solid; font-size: 11px; color: red; font-family: Tahoma;background-color: #ffffda)
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var lblTrustName = null;
    var cboTrustID = null;
    var txtTrustID = null;
    var lblAccountNumber = null;
    var txtAccountNumber = null;

    var pnlEdit = null;
    var pnlSave = null;
    var dvError = null;
    var tdError = null;

    var cbos = new Array();

    function Record_AddTransaction()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
    }
    function LoadControls()
    {
        if (pnlEdit == null)
        {
            lblTrustName = document.getElementById("<%= lblTrustName.ClientID %>");
            txtTrustID = document.getElementById("<%= txtTrustID.ClientID %>");
            lblAccountNumber = document.getElementById("<%= lblAccountNumber.ClientID %>");
            pnlEdit = document.getElementById("<%= pnlEdit.ClientID %>");
            pnlSave = document.getElementById("<%= pnlSave.ClientID %>");
            dvError = document.getElementById("<%= dvError.ClientID %>");
            tdError = document.getElementById("<%= tdError.ClientID %>");

            cbos[0] = cboTrustID;
        }
    }
    function Edit()
    {
        LoadControls();

        lblTrustName.style.display = "none";
        lblAccountNumber.style.display = "none";

        pnlEdit.style.display = "none";
        pnlSave.style.display = "inline";
    }
    function Save()
    {
        LoadControls();

        if (RequiredExist())
        {
            // save cboTrustID into txtTrustID for postback
            txtTrustID.value = cboTrustID.options[cboTrustID.selectedIndex].value;

            // postback to save
            <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Cancel()
    {
        LoadControls();

        lblTrustName.style.display = "inline";
        lblAccountNumber.style.display = "inline";

        pnlSave.style.display = "none";
        pnlEdit.style.display = "inline";
        dvError.style.display = "none";
    }
    function ShowMessage(Value)
    {
        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage()
    {
        tdError.innerHTML = "";
        dvError.style.display = "none";
    }
    function RequiredExist()
    {
        HideMessage()
        return true;
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
        obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
    }
    function Record_AssignNewConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_AssignNew&t=Assign New Account Number&m=Are you sure you want to assign this client a new Account Number in the 6000 range?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Assign New Account Number",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});  
	}
    function Record_AssignNew()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkAssignNew, Nothing) %>;
    }
    
    function Convert_Trust()
    {
        var ddl = document.getElementById('<%= ddlToCompany.ClientId%>');
        if  (ddl.options[ddl.selectedIndex].value == 0){
            alert('Please, select a settlement attorney.') ;
            return false;
        }  
        if (confirm("Are you sure you want to move this client's Trust Location and change the settlement attorney to " + ddl.options[ddl.selectedIndex].innerText + " ?"))
            <%= Page.ClientScript.GetPostBackEventReference(lnkConvert, Nothing) %>;
    }
    
    function Reverse_Trust()
    {
        var ddl = document.getElementById('<%= ddlToCompany.ClientId%>');
        if  (ddl.options[ddl.selectedIndex].value == 0){
            alert('Please, select a settlement attorney.') ;
            return false;
        }  
        if (confirm("Are you sure you want to move this client's Trust Location and change the settlement attorney to " + ddl.options[ddl.selectedIndex].innerText + " ?"))
            <%= Page.ClientScript.GetPostBackEventReference(lnkReverse, Nothing) %>;
    }

    </script>

    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
        cellspacing="15">
        <tr>
            <td style="font-size: 11px; color: #666666;" valign="top">
                <a id="lnkClient" runat="server" class="lnk" style="font-size: 11px; color: #666666;">
                </a>&nbsp;>&nbsp;SDA Structure</td>
        </tr>
        <tr>
            <td>
                <br />
                <table style="width: 300; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                    cellspacing="0">
                    <tr>
                        <td>
                            <div runat="server" id="dvError" style="display: none;">
                                <table style="border: #969696 1px solid; font-size: 11px; color: red; font-family: Tahoma;
                                    background-color: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
                                    <tr>
                                        <td valign="top" width="20">
                                            <img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                        <td runat="server" id="tdError">
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="background-color: #f1f1f1; padding: 5 5 5 5;">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        SDA Structure</td>
                                    <td align="right">
                                        <asp:Panel runat="server" ID="pnlEdit">
                                            <%--<a class="lnk" runat="server" href="javascript:Edit()"><img id="Img9" style="margin-right:3;" runat="server" src="~/images/16x16_dataentry.png" border="0" align="absmiddle" />Edit</a>--%>
                                        </asp:Panel>
                                        <asp:Panel Style="display: none;" runat="server" ID="pnlSave">
                                            <a id="A4" class="lnk" runat="server" href="javascript:Save()">
                                                <img id="Img10" style="margin-right: 3;" runat="server" src="~/images/16x16_save.png"
                                                    border="0" align="absmiddle" />Save</a>&nbsp;|&nbsp;<a id="A5" class="lnk" runat="server"
                                                        href="javascript:Cancel()"><img id="Img11" style="margin-right: 3;" runat="server"
                                                            src="~/images/16x16_cancel.png" border="0" align="absmiddle" />Cancel</a></asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top: 5;">
                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                cellspacing="5">
                                <tr>
                                    <td nowrap="true" style="width: 130;" align="right">
                                        Trust Location :</td>
                                    <td nowrap="true">
                                        <asp:Label runat="server" ID="lblTrustName" Font-Bold="true"></asp:Label>
                                        <asp:HiddenField runat="server" ID="txtTrustID"></asp:HiddenField>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="true" style="width: 130;" align="right">
                                        Account Number :</td>
                                    <td nowrap="true">
                                        <asp:Label runat="server" ID="lblAccountNumber"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td nowrap="true" style="width: 130;" align="right">
                                        Client State :</td>
                                    <td nowrap="true">
                                        <asp:Label ID="lblState" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="true" style="width: 130;" align="right">
                                        SDA Balance :</td>
                                    <td nowrap="true">
                                        <asp:Label ID="lblSDABalance" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="true" style="width: 130;" align="right">
                                        Agency :</td>
                                    <td nowrap="true">
                                        <asp:Label ID="lblAgency" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr id="trCurrentCompany" runat="server" >
                                    <td nowrap="true" style="width: 130;" align="right">
                                        Current Settl. Attorney :</td>
                                    <td nowrap="true">
                                        <asp:Label ID="lblSettlAttorney" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr id="trCompany" runat="server" style="display: none;"  >
                                    <td style="width: 130;" align="right">
                                        New Settl. Attorney :</td>
                                    <td nowrap="true">
                                        <asp:DropDownList ID="ddlToCompany" runat="server" Height="16px" Width="222px" 
                                            CssClass="entry" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr id="trConfirm" runat="server" style="display: none; border: #969696 1px solid;
            font-size: 11px; color: red; font-family: Tahoma;">
            <td colspan="2" align="left" style="padding:10px;">
                <asp:Panel ID="pnlConfirm" Width="60%" BackColor="#ffffda" 
                BorderColor="silver" BorderStyle="Ridge" BorderWidth="1px" 
                runat="server" HorizontalAlign="center" style="padding:10px;">
                    <br />
                    <br />
                </asp:Panel>
            </td>
        </tr>
        
    </table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkAssignNew"></asp:LinkButton>
    <asp:LinkButton ID="lnkConvert" runat="server"></asp:LinkButton>
    <asp:LinkButton ID="lnkReverse" runat="server"></asp:LinkButton>
    
	<asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none" />
	<ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
		TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
		BackgroundCssClass="modalBackgroundNeg" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle">
	</ajaxToolkit:ModalPopupExtender>
	<asp:Panel runat="server" CssClass="modalPopupNeg" ID="programmaticPopup" Style="display: none;
		width: 725px; padding: 10px">
		<asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #DDDDDD;
			border: solid 1px Gray; color: Black; text-align: center;width: 725px">
			<div id="dvCloseMenu" runat="server" style="width: 100%; height: 25px; background-color: white;
				z-index: 51">
				<asp:LinkButton runat="server" Font-Bold="true" Font-Size="Medium" ID="hideModalPopupViaServer"
					Text="Close" OnClick="hideModalPopupViaServer_Click" />
			</div>
		</asp:Panel>
		<asp:Panel runat="Server" ID="pnlRpt">
			<div id="dvReport" runat="server" style="width: 725px; height: 550px; z-index: 51;
				visibility: visible; background-color: Transparent;">
				<iframe id="frmReport" runat="server" src="../../Clients/client/reports/report.aspx"
					style="width: 100%; height: 95%;" frameborder="0" />
			</div>
		</asp:Panel>
	</asp:Panel>
</asp:Content>
