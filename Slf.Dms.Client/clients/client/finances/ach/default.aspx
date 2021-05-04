﻿<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="clients_client_finances_ach_default" Title="DMP - Client - ACH & Fee Structure"
    EnableEventValidation="false" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>
<%@ Register Src="~/Clients/client/MultipleDeposit.ascx" TagName="MultipleDeposit"
    TagPrefix="uc1" %>
<%@ MasterType TypeName="clients_client" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="cc1" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function Record_AddCheckToPrint()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/ach/checktoprint.aspx?id=" & ClientID & "&a=a") %>");
    }
    function Record_AddACHRule()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/ach/achrule.aspx?id=" & ClientID & "&a=a") %>");
    }
    function Record_AddCheckRule()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/ach/checkrule.aspx?id=" & ClientID & "&a=a") %>");
    }
    function Record_AddAdHocACH()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/ach/adhocach.aspx?id=" & ClientID & "&a=a") %>");
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

    function ACH_IsValid()
    {
        var depositStartDate = document.getElementById("<%=depositStartDate.ClientId %>");
        var depositAmount = document.getElementById("<%=depositAmount.ClientId %>");
        var routingNumber = document.getElementById("<%=routingNumber.ClientId %>");

        if (!ValidateDate(depositStartDate, "Deposit To Start"))
            return false;
            
        if (!ValidateFloat(depositAmount, "Deposit Amount"))
            return false;

        if (routingNumber.value.length > 0 && !ValidateTextLength(routingNumber, "Routing Number", 9, 9))
            return false;

        return true;
    }

    function Fee_IsValid()
    {
        //if (!ValidateFloat(document.getElementById("<%=monthlyFee.ClientId %>"), "Monthly Fee")) //whew
          //  return true;
        if (!ValidateFloat(document.getElementById("<%=settlementFeePercentage.ClientId %>"), "Settlement Fee Percentage"))
            return false;
        if (!ValidateFloat(document.getElementById("<%=additionalAccountFee.ClientId %>"), "Additional Account Fee"))
            return false;
        if (!ValidateFloat(document.getElementById("<%=returnedCheckFee.ClientId %>"), "Returned Check Fee"))
            return false;
        if (!ValidateFloat(document.getElementById("<%=overnightDeliveryFee.ClientId %>"), "Overnight Delivery Fee"))
            return false;

        return true;
    }
    
    var dvError = null;
    var tdError = null;

    function ValidateDate(input, name)
    {
        if (dvError == null)
            dvError = document.getElementById("<%=dvError.ClientId %>");

        if (tdError == null)
            tdError = document.getElementById("<%=tdError.ClientId %>");

        if (input.value.length > 0 && !IsValidDateTime(input.value))
        {
            ShowMessage("The value you entered is invalid.  Please enter a new date value.");
            AddBorder(input);
            return false;
        }
        else
        {
            RemoveBorder(input);
            return true;
        }
    }
    
    
    function ValidateMulti()
    {
         if (dvError == null)
            dvError = document.getElementById("<%=dvError.ClientId %>");

        if (tdError == null)
            tdError = document.getElementById("<%=tdError.ClientId %>");
        
        var msg = ValidateDepositList();
        if (msg.length!=0){
            ShowMessage(msg);
            return false;
        }
        else{
            return true;
        }
        
    }
    
    
    function ValidateTextLength(input, name, min, max)
    {
        if (dvError == null)
            dvError = document.getElementById("<%=dvError.ClientId %>");

        if (tdError == null)
            tdError = document.getElementById("<%=tdError.ClientId %>");

        if (input.value.length >= min && input.value.length <= max)
        {
            RemoveBorder(input);
            return true;
        }
        else
        {
            ShowMessage("The value you entered is not the correct length.  Please enter a new value.");
            AddBorder(input);
            return false;
        }
    }
    function ValidateFloat(input, name)
    {
        if (dvError == null)
            dvError = document.getElementById("<%=dvError.ClientId %>");
        
        if (tdError == null)
            tdError = document.getElementById("<%=tdError.ClientId %>");

        if (input.value.length == 0)
        {
            ShowMessage(name + " is a required field.");
            AddBorder(input);
            return false;
        }
        else
        {
            var value = new String(input.value);

            value = value.replace("$", "").replace(",", "");

            if (isNaN(parseFloat(value)) || parseFloat(value) == 0)
            {
                ShowMessage("The value you entered is invalid.  Please enter a new value.  The value must be numeric and greater than 0.");
                AddBorder(input);
                return false;
            }
            else
            {
                input.value = parseFloat(value);
                RemoveBorder(input);
                return true;
            }
        }
    }

    var achControls = new Array(
                                "<%=depositMethod.ClientId %>",
                                "<%=cboDepositDay.ClientId %>",
                                "<%=accountNumber.ClientId %>",
                                "<%=depositStartDate.ClientId %>",
                                "<%=routingNumber.ClientId %>",
                                "<%=cboBankType.ClientId %>",
                                "<%=depositAmount.ClientId %>"
                               );

    var feeControls = new Array(
                                "<%=monthlyFee.ClientId %>",
                                "<%=settlementFeePercentage.ClientId %>",
                                "<%=additionalAccountFee.ClientId %>",
                                "<%=returnedCheckFee.ClientId %>",
                                "<%=overnightDeliveryFee.ClientId %>"
                               );
                               
    var MTD;

    function EditACH()
    {
        for (var i = 0; i < achControls.length; i++)
        {
            var editControl = document.getElementById(achControls[i])
            var displayControl = document.getElementById(achControls[i] + "ReadOnly");

            if (editControl.tagName.toLowerCase()=="select")
            {
                DDL_Select(editControl,displayControl.innerHTML,true)
            }
            else
                editControl.value = displayControl.innerHTML;

            editControl.style.display = "inline";
            displayControl.style.display = "none";
        }
        
        document.getElementById("<%=achSaveButtons.ClientId %>").style.display = "inline";
        document.getElementById("<%=achEditButton.ClientId %>").style.display = "none";
    }
    
    function ConvertToMulti()
    { 
        if (confirm(" You are about to add multideposit functionality to this client.\n Once the client is converted to multideposit mode, he cannot be converted back to single deposit mode.\n Are you sure you want to convert this client?") == true){ 
            <%= Page.ClientScript.GetPostBackEventReference(lnkConvertToMulti, Nothing) %>;
        }
    }
    
    function ConvertToBofA()
    { 
        if (confirm(" You are changing this clients Bank processing account.\n\n Has the client agreed to this in writing?") == true){ 
            <%= Page.ClientScript.GetPostBackEventReference(lnkConvertToBofA, Nothing) %>;
        }
    }
    
    function ConvertToServiceFeeCap()
      { 
        if (confirm(" You are about to convert this client to the new fee structure: Service fee per account with a maximum cap.\n Once the client is converted, he cannot be converted back to the current fee structure.\n Are you sure you want to convert this client?") == true){ 
            <%= Page.ClientScript.GetPostBackEventReference(lnkConvertFeeStruct, Nothing) %>;
        }
    }
    
    function EditMulti()
    { 
        MTD = GetMTD();
        document.getElementById("<%=multidepositStartDate.ClientID %>").style.display = "inline";
        document.getElementById("<%=multidepositStartDate.ClientID %>").value = document.getElementById("<%=multidepositStartDateReadOnly.ClientID %>").innerHTML;
        document.getElementById("<%=multidepositStartDateReadOnly.ClientID %>").style.display = "none";
        
        document.getElementById("<%=achSaveButtons.ClientId %>").style.display = "inline";
        document.getElementById("<%=achEditButton.ClientId %>").style.display = "none";
        
        document.getElementById("<%=aSave.ClientID %>").href = "javascript:SaveMulti();";
        document.getElementById("<%=aCancel.ClientID %>").href = "javascript:CancelMulti();";
        
        <%=Flyout1.getClientID()%>.Open(); 
    }
    
    function DDL_Select(ddl, value, compareText)
    {
        var o = 0;

        var found = false;

        for (o = 0; o < ddl.options.length; o++)
        {
            if (ddl.options[o].value == value)
            {
                ddl.selectedIndex = o;
                found = true;
                break;
            }
            if (compareText)
            {
                if (ddl.options[o].innerHTML == value)
                {
                    ddl.selectedIndex = o;
                    found = true;
                    break;
                }
            }
        }

        if (!found)
        {
            ddl.selectedIndex = -1;
        }
    }
    function SaveACH()
    {
        if (ACH_IsValid())
        {
            RemoveBorder(document.getElementById("<%=depositStartDate.ClientId %>"));
            RemoveBorder(document.getElementById("<%=depositAmount.ClientId %>"));
            RemoveBorder(document.getElementById("<%=routingNumber.ClientId %>"));

            document.getElementById("<%=dvError.ClientId %>").style.display = "none";

            <%= Page.ClientScript.GetPostBackEventReference(lnkSaveACH, Nothing) %>;
        }
    }
    function SaveMulti()
    {
        var depositStartDate = document.getElementById("<%=multidepositStartDate.ClientID %>");

        if (ValidateDate(depositStartDate, "Deposit To Start") && ValidateMulti())
        {
            RemoveBorder(document.getElementById("<%=multidepositStartDate.ClientID %>"));
            
            document.getElementById("<%=dvError.ClientId %>").style.display = "none";
            
            //<%=Flyout1.getClientID()%>.Close(); 
            <%= Page.ClientScript.GetPostBackEventReference(lnkSaveMulti, Nothing) %>;
        } else {
            <%=Flyout1.getClientID()%>.setPosition("ABSOLUTE",""); 
            <%=Flyout1.getClientID()%>.setRelativePosition(10,20);
        }
    }
    function CancelACH()
    {
        for (var i = 0; i < achControls.length; i++)
        {
            var editControl = document.getElementById(achControls[i])
            var displayControl = document.getElementById(achControls[i] + "ReadOnly");

            editControl.style.display = "none";
            displayControl.style.display = "inline";
        }
        
        document.getElementById("<%=achSaveButtons.ClientId %>").style.display = "none";
        document.getElementById("<%=achEditButton.ClientId %>").style.display = "inline";    
    }
    function CancelMulti()
    {   
        RestoreMTD(MTD);

        document.getElementById("<%=multidepositStartDate.ClientID %>").style.display = "none";
        document.getElementById("<%=multidepositStartDateReadOnly.ClientID %>").style.display = "inline";
        
        document.getElementById("<%=achSaveButtons.ClientId %>").style.display = "none";
        document.getElementById("<%=achEditButton.ClientId %>").style.display = "inline"; 
        
        //<%=Flyout1.getClientID()%>.Close(); 
        
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancelMulti, Nothing) %>;
    }
    function EditFees()
    {
        for (var i = 0; i < feeControls.length; i++)
        {
            var editControl = document.getElementById(feeControls[i])
            var displayControl = document.getElementById(feeControls[i] + "ReadOnly");

            editControl.value = displayControl.innerHTML;
            
            editControl.style.display = "inline";
            displayControl.style.display = "none";
        }
        
        document.getElementById("<%=feeSaveButtons.ClientId %>").style.display = "inline";
        document.getElementById("<%=feeEditButton.ClientId %>").style.display = "none";
        
        document.getElementById("<%=setupFeePercentage.ClientId %>").style.display = "inline";
        document.getElementById("<%=setupFeePercentageReadOnly.ClientId %>").style.display = "none";
    }

    function SaveFees()
    {
        if (Fee_IsValid())
            <%= Page.ClientScript.GetPostBackEventReference(lnkSaveFees, Nothing) %>;
    }

    function CancelFees()
    {
        for (var i = 0; i < feeControls.length; i++)
        {
            var editControl = document.getElementById(feeControls[i])
            var displayControl = document.getElementById(feeControls[i] + "ReadOnly");

            editControl.style.display = "none";
            displayControl.style.display = "inline";
        }

        document.getElementById("<%=feeSaveButtons.ClientId %>").style.display = "none";
        document.getElementById("<%=feeEditButton.ClientId %>").style.display = "inline";
        document.getElementById("<%=setupFeePercentage.clientid %>").style.display="none"; 
        document.getElementById("<%=setupFeePercentageReadOnly.ClientID %>").style.display = "inline"; 
    }
    function Record_DeleteConfirm(obj)
    {
        if (!document.getElementById("<%= lnkDeleteConfirm.ClientID() %>").disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Checks To Print&m=Are you sure you want to delete this selection of checks to print?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Checks To Print",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});        
        }
    }
    function Record_DeleteConfirmACHRules(obj)
    {
        if (!document.getElementById("<%= lnkDeleteConfirmACHRule.ClientID() %>").disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteACHRules&t=Delete Rules&m=Are you sure you want to delete this selection of ACH Rules?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Rules",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});  
        }
    }
    function Record_DeleteConfirmCheckRules(obj)
    {
        if (!document.getElementById("<%= lnkDeleteConfirmCheckRule.ClientID() %>").disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteCheckRules&t=Delete Rules&m=Are you sure you want to delete this selection of Check Rules?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Rules",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});  
        }
    }
    function Record_DeleteConfirmAdHocACH(obj)
    {
        if (!document.getElementById("<%= lnkDeleteConfirmAdHocACH.ClientID() %>").disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteAdHocACH&t=Delete Additional ACHs&m=Are you sure you want to delete this selection of Additional ACHs?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Additional ACHs",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});  
        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_DeleteACHRules()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDeleteACHRules, Nothing) %>;
    }
    function Record_DeleteCheckRules()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDeleteCheckRules, Nothing) %>;
    }
    function Record_DeleteAdHocACH()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDeleteAdHocACH, Nothing) %>;
    }
    function hideCalendar(oCalendar)
    {
        oCalendar.hide();
        oCalendar.get_element().blur();
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;"
        border="0" cellspacing="15">
        <tr>
            <td valign="top" style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/clients/default.aspx">
                    Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Finances&nbsp;>&nbsp;ACH
                & Fee Structure
            </td>
        </tr>
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                    &nbsp;
                </div>
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                    cellspacing="0">
                    <tr>
                        <td valign="top" width="50%">
                            <asp:UpdatePanel ID="upDepositInfo" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                        cellspacing="0">
                                        <tr>
                                            <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                                    cellspacing="0">
                                                    <tr>
                                                        <td nowrap="nowrap">
                                                            Default Deposit Info
                                                        </td>
                                                        <td nowrap="nowrap" align="right">
                                                            <a href="javascript:EditACH()" class="lnk" id="achEditButton" runat="server">
                                                                <img width="16" height="16" border="0" align="absmiddle" style="margin-top: 1px;
                                                                    margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_dataentry.png") %>" />Edit</a><span
                                                                        id="achSaveButtons" style="display: none" runat="server"><a id="aSave" href="javascript:SaveACH()"
                                                                            class="lnk" runat="server"><img width="16" height="16" border="0" align="absmiddle" style="margin-top: 1px;
                                                                                margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_save.png") %>" />Save</a>&nbsp;|&nbsp;<a
                                                                                    id="aCancel" href="javascript:CancelACH()" class="lnk" runat="server"><img width="16" height="16" border="0"
                                                                                        align="absmiddle" style="margin-top: 1px; margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_cancel.png") %>" />Cancel</a></span>
                                                            <asp:LinkButton ID="lnkEditMulti" runat="server"></asp:LinkButton>                                                                                
                                                        </td>
                                                    </tr>
                                                </table>
                                                <cc1:Flyout ID="Flyout1" runat="server" Align="LEFT" Position="BOTTOM_CENTER" CloseEvent="NONE" OpenEvent="ONCLICK">
                                                    <div style="width: 315px; border: solid 1px #70A8D1; background-color: #F0F5FB;">
                                                        <h1 class="entry" style="background-image: url(<%=ResolveUrl("~/images/menubacksmall.bmp") %>); background-repeat:repeat-x; margin:0; text-align:center; padding:5px; font-weight:normal;">Deposit Schedule</h1>
                                                        <uc1:MultipleDeposit ID="multipleDepositList" runat="server" />
                                                    </div>
                                                </cc1:Flyout>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table id="tblDepositInfo" runat="server" style="font-family: tahoma; font-size: 11px;
                                                    width: 100%;" border="0" cellpadding="0" cellspacing="3">
                                                    <tr>
                                                        <td style="width: 90; height: 23;">
                                                            Deposit Method:
                                                        </td>
                                                        <td>
                                                            <select class="entry" id="depositMethod" runat="server" style="display: none; font-size: 11px">
                                                                <option>ACH</option>
                                                                <option>Check</option>
                                                            </select>
                                                            <span id="depositMethodReadOnly" runat="server" />
                                                        </td>
                                                        <td style="padding-left: 10; width: 90; height: 23;">
                                                            Bank Name:
                                                        </td>
                                                        <td>
                                                            <span id="bankNameReadOnly" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 90; height: 23;">
                                                            Deposit Day:
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList class="entry" ID="cboDepositDay" runat="server" Style="display: none;
                                                                font-size: 11px">
                                                                <asp:ListItem Value="0" Text=""></asp:ListItem>
                                                                <asp:ListItem Value="1" Text="Day 1"></asp:ListItem>
                                                                <asp:ListItem Value="2" Text="Day 2"></asp:ListItem>
                                                                <asp:ListItem Value="3" Text="Day 3"></asp:ListItem>
                                                                <asp:ListItem Value="4" Text="Day 4"></asp:ListItem>
                                                                <asp:ListItem Value="5" Text="Day 5"></asp:ListItem>
                                                                <asp:ListItem Value="6" Text="Day 6"></asp:ListItem>
                                                                <asp:ListItem Value="7" Text="Day 7"></asp:ListItem>
                                                                <asp:ListItem Value="8" Text="Day 8"></asp:ListItem>
                                                                <asp:ListItem Value="9" Text="Day 9"></asp:ListItem>
                                                                <asp:ListItem Value="10" Text="Day 10"></asp:ListItem>
                                                                <asp:ListItem Value="11" Text="Day 11"></asp:ListItem>
                                                                <asp:ListItem Value="12" Text="Day 12"></asp:ListItem>
                                                                <asp:ListItem Value="13" Text="Day 13"></asp:ListItem>
                                                                <asp:ListItem Value="14" Text="Day 14"></asp:ListItem>
                                                                <asp:ListItem Value="15" Text="Day 15"></asp:ListItem>
                                                                <asp:ListItem Value="16" Text="Day 16"></asp:ListItem>
                                                                <asp:ListItem Value="17" Text="Day 17"></asp:ListItem>
                                                                <asp:ListItem Value="18" Text="Day 18"></asp:ListItem>
                                                                <asp:ListItem Value="19" Text="Day 19"></asp:ListItem>
                                                                <asp:ListItem Value="20" Text="Day 20"></asp:ListItem>
                                                                <asp:ListItem Value="21" Text="Day 21"></asp:ListItem>
                                                                <asp:ListItem Value="22" Text="Day 22"></asp:ListItem>
                                                                <asp:ListItem Value="23" Text="Day 23"></asp:ListItem>
                                                                <asp:ListItem Value="24" Text="Day 24"></asp:ListItem>
                                                                <asp:ListItem Value="25" Text="Day 25"></asp:ListItem>
                                                                <asp:ListItem Value="26" Text="Day 26"></asp:ListItem>
                                                                <asp:ListItem Value="27" Text="Day 27"></asp:ListItem>
                                                                <asp:ListItem Value="28" Text="Day 28"></asp:ListItem>
                                                                <asp:ListItem Value="29" Text="Day 29"></asp:ListItem>
                                                                <asp:ListItem Value="30" Text="Day 30"></asp:ListItem>
                                                            </asp:DropDownList>
                                                            <span id="cboDepositDayReadOnly" runat="server" />
                                                        </td>
                                                        <td style="padding-left: 10; width: 90; height: 23;">
                                                            Routing Number:
                                                        </td>
                                                        <td>
                                                            <input onkeypress="onlyDigits()" maxlength="9" class="entry" id="routingNumber" runat="server"
                                                                style="display: none; font-size: 11px" /><span id="routingNumberReadOnly" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 90; height: 23;">
                                                            Deposit Amount:
                                                        </td>
                                                        <td style="width: 50%;">
                                                            <input class="entry" style="display: none; font-size: 11px" id="depositAmount" runat="server"
                                                                onkeypress="onlyDigits()" /><span id="depositAmountReadOnly" runat="server"></span>
                                                        </td>
                                                        <td style="padding-left: 10; width: 90; height: 23;">
                                                            Account Number:
                                                        </td>
                                                        <td style="width: 50%;">
                                                            <input onkeypress="onlyDigits()" class="entry" id="accountNumber" runat="server"
                                                                style="display: none; font-size: 11px" /><span id="accountNumberReadOnly" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 90; height: 23;">
                                                            Deposit To Start:
                                                        </td>
                                                        <td style="width: 50%;">
                                                            <cc1:InputMask class="entry" ID="depositStartDate" runat="server" Style="display: none;
                                                                font-size: 11px" Mask="nn/nn/nnnn"></cc1:InputMask><span id="depositStartDateReadOnly"
                                                                    runat="server" />
                                                        </td>
                                                        <td style="padding-left: 10; width: 90; height: 23;">
                                                            Account Type:
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList class="entry" ID="cboBankType" runat="server" Style="display: none;
                                                                font-size: 11px">
                                                                <asp:ListItem Value="0" Text=""></asp:ListItem>
                                                                <asp:ListItem Value="C" Text="Checking"></asp:ListItem>
                                                                <asp:ListItem Value="S" Text="Savings"></asp:ListItem>
                                                            </asp:DropDownList>
                                                            <span id="cboBankTypeReadOnly" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 90; height: 23;">
                                                            <img id="Img2" height="1" width="90" runat="server" border="0" src="~/images/spacer.gif" />
                                                        </td>
                                                        <td style="width: 50%;">
                                                        </td>
                                                        <td style="padding-left: 10; width: 90; height: 23;">
                                                            <img id="Img3" height="1" width="90" runat="server" border="0" src="~/images/spacer.gif" />
                                                        </td>
                                                        <td style="width: 50%;">
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table id="tblMultiDepositInfo" runat="server" style="font-family: tahoma; font-size: 11px;
                                                    width: 100%;" border="0" cellpadding="0" cellspacing="3" visible="false">
                                                    <tr>
                                                        <td style="width: 90px; height: 23; white-space:nowrap">
                                                            Deposit&nbsp;To&nbsp;Start:
                                                        </td>
                                                        <td style="width: 90px">
                                                            <cc1:InputMask class="entry" ID="multidepositStartDate" runat="server" Style="display: none;
                                                                font-size: 11px" Mask="nn/nn/nnnn"></cc1:InputMask><span id="multidepositStartDateReadOnly"
                                                                    runat="server" /><ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" Format="M/d/yyyy"
                                                                        OnClientDateSelectionChanged="hideCalendar" TargetControlID="multidepositStartDate">
                                                                    </ajaxToolkit:CalendarExtender>
                                                        </td>
                                                        <td style="width: 50%">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <span id="multiDepositListReadOnly" runat="server"></span>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:LinkButton runat="server" ID="lnkSaveMulti"></asp:LinkButton>
                                    <asp:LinkButton runat="server" ID="lnkCancelMulti"></asp:LinkButton>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                        <td style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-repeat: repeat-y;
                            background-position: center top;">
                            <img id="Img4" runat="server" width="30" height="1" src="~/images/spacer.gif" border="0" />
                        </td>
                        <td width="50%" valign="top">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td style="background-color: #f3f3f3; padding: 5 5 5 5;">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td nowrap="nowrap">
                                                    Fees & Rates
                                                </td>
                                                <td nowrap="nowrap" align="right">
                                                    <a href="javascript:EditFees()" class="lnk" id="feeEditButton" runat="server">
                                                        <img width="16" height="16" border="0" align="absmiddle" style="margin-top: 1px;
                                                            margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_dataentry.png") %>" />Edit</a><span
                                                                id="feeSaveButtons" style="display: none" runat="server"><a href="javascript:SaveFees()"
                                                                    class="lnk"><img width="16" height="16" border="0" align="absmiddle" style="margin-top: 1px;
                                                                        margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_save.png") %>" />Save</a>&nbsp;|&nbsp;<a
                                                                            href="javascript:CancelFees()" class="lnk"><img width="16" height="16" border="0"
                                                                                align="absmiddle" style="margin-top: 1px; margin-right: 4px" src="<%=ResolveUrl("~/images/16x16_cancel.png") %>" />Cancel</a></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="3">
                                            <tr>
                                                <td style="width: 100; height: 23;">
                                                    Monthly Fee:
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    $
                                                </td>
                                                <td>
                                                    <div id="dvMonthlyFee" runat="server"   >
                                                    <asp:DropDownList CssClass="entry" ID="monthlyFee" runat="server" Style="display: none;
                                                        font-size: 11px">
                                                        <asp:ListItem Value="0.00" Text="">0.00</asp:ListItem>
                                                        <asp:ListItem Value="55.00" Text="">55.00</asp:ListItem>
                                                        <asp:ListItem Value="65.00" Text="">65.00</asp:ListItem>
                                                        <asp:ListItem Value="100.00" Text="">100.00</asp:ListItem>
                                                        <asp:ListItem Value="130.00" Text="">130.00</asp:ListItem>
                                                        <asp:ListItem Value="150.00" Text="">150.00</asp:ListItem>
                                                        <asp:ListItem Value="200.00" Text="">200.00</asp:ListItem>
                                                        <asp:ListItem Value="225.00" Text="">225.00</asp:ListItem>
                                                        <asp:ListItem Value="250.00" Text="Checking">250.00</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <span id="monthlyFeeReadOnly" runat="server" />
                                                    </div>
                                                    <div id="dvMonthlyFeeCap" runat="server"  >
                                                        <asp:Label ID="lblMonthlyFeeWithCap" runat="server" Text=""></asp:Label>
                                                    </div> 
                                                    <asp:HiddenField ID="hdnUseMonthlyFeeType" runat="server" />
                                                </td>
                                                <td style="padding-left: 10; width: 100; height: 23;">
                                                    Overnight Fee:
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    $
                                                </td>
                                                <td>
                                                    <input class="entry" id="overnightDeliveryFee" runat="server" style="display: none;
                                                        font-size: 11px" onkeypress="onlyDigits()" /><span id="overnightDeliveryFeeReadOnly"
                                                            runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100; height: 23;">
                                                    Add Account Fee:
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    $
                                                </td>
                                                <td>
                                                    <input class="entry" id="additionalAccountFee" runat="server" style="display: none;
                                                        font-size: 11px" onkeypress="onlyDigits()" /><span id="additionalAccountFeeReadOnly"
                                                            runat="server" />
                                                </td>
                                                <td style="padding-left: 10; width: 100; height: 23;">
                                                    Retainer Fee % :
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    %
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="setupFeePercentage" CssClass="entry" Font-Size="11px" Style="display: none;"
                                                        runat="server">
                                                        <asp:ListItem Text="0" Value="0.00" />
                                                        <asp:ListItem Text="5" Value="5.00" />
                                                        <asp:ListItem Text="8" Value="8.00" />
                                                        <asp:ListItem Text="10" Value="10.00" />
                                                    </asp:DropDownList>
                                                    <span id="setupFeePercentageReadOnly" runat="server" />
                                                </td>                                                
                                            </tr>
                                            <tr>
                                                <td style="width: 100; height: 23;">
                                                    Returned Check:
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    $
                                                </td>
                                                <td>
                                                    <input class="entry" id="returnedCheckFee" runat="server" style="display: none; font-size: 11px"
                                                        onkeypress="onlyDigits()" /><span id="returnedCheckFeeReadOnly" runat="server" />
                                                </td>
                                                <td style="padding-left: 10; width: 100; height: 23;">
                                                    Settlement Fee % :
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    %
                                                </td>
                                                <td>
                                                    <input class="entry" id="settlementFeePercentage" runat="server" style="display: none;
                                                        font-size: 11px" /><span id="settlementFeePercentageReadOnly" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10; width: 100; height: 23;">  <%--CHolt - 2/11/2020--%>
                                                    Fixed Fee % :
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    
                                                </td>
                                                <td>
                                                    <span id="fixedFeePercentageReadOnly" runat="server" /> %
                                                </td>
                                                <td style="padding-left: 10; width: 100; height: 23;">  <%--CHolt - 2/11/2020--%>
                                                    Fixed Fee Collection Type :
                                                </td>
                                                <td style="width: 10;" align="center">
                                                    
                                                </td>
                                                <td>
                                                    <span id="fixedFeeCollectionType" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 100%;" valign="top">
                <asi:TabStrip runat="server" ID="tsMain">
                </asi:TabStrip>
                <div id="dvPanel0" runat="server">
                <asp:UpdatePanel ID="updAdHocPanel" runat="server" UpdateMode="Conditional">
                     <ContentTemplate>
                    <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                        width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                Additional ACHs
                            </td>
                            <td style="padding-right: 7;" align="right">
                                <a class="lnk" id="lnkDeleteConfirmAdHocACH" disabled="disabled" runat="server" href="#"
                                    onmouseup="javascript:Record_DeleteConfirmAdHocACH(this);">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:CheckBox
                                        runat="server" ID="chkOnlyNotDeposited" Text="Only Not Deposited" AutoPostBack="true"
                                        Checked="true"></asp:CheckBox>
                            </td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size: 11px; font-family: tahoma;"
                        cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width: 20;" class="headItem">
                                <img id="Img5" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"
                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                    border="0" /><img id="Img6" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"
                                        style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                        border="0" />
                            </td>
                            <td class="headItem" style="width: 22;" align="center">
                                <img id="Img7" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                            </td>
                            <td class="headItem" align="center">
                                Status
                            </td>
                            <td class="headItem">
                                Dep. Date
                            </td>
                            <td class="headItem" align="right">
                                Dep. Amount
                            </td>
                            <td class="headItem" style="padding-left: 10;">
                                Bank Name
                            </td>
                            <td class="headItem">
                                Routing No.
                            </td>
                            <td class="headItem">
                                Account No.
                            </td>
<%--                            <td class="headItem">
                                Created:
                            </td>
                            <td class="headItem">
                                Created By:
                            </td>
                            <td class="headItem">
                                Modified:
                            </td>
                            <td class="headItem">
                                Modified By:
                            </td>--%>
                        </tr>
                        <asp:Repeater ID="rpAdHocACH" runat="server">
                            <ItemTemplate>
                                <a href="<%# ResolveUrl("~/clients/client/finances/ach/adhocach.aspx?id=") + ClientID.ToString() + "&ahachid=" + CType(Container.DataItem, AdHocACH).AdHocAchID.ToString() %>"
                                    accesskey="a">
                                    <tr>
                                        <td style="width: 20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <img id="Img8" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                    id="Img9" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                    style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                    align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#CType(Container.DataItem, AdHocACH).AdHocAchID.ToString()%>);"
                                                        style="display: none;" type="checkbox" />
                                        </td>
                                        <td style="width: 22;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="center">
                                            <img id="Img10" runat="server" src="~/images/16x16_tools.png" border="0" />
                                        </td>
                                        <td style="color: <%#IIf(CType(Container.DataItem, AdHocACH).Status.ToLower() = "deposited", "rgb(0,139,0)", "red")%>;"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap" align="center">
                                            <%#CType(Container.DataItem, AdHocACH).Status%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#CType(Container.DataItem, AdHocACH).DepositDate.ToString("MMM dd, yyyy")%>&nbsp;
                                        </td>
                                        <td style="color: rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="right">
                                            <%#CType(Container.DataItem, AdHocACH).DepositAmount.ToString("c")%>&nbsp;
                                        </td>
                                        <td style="padding-left: 10;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <%#CType(Container.DataItem, AdHocACH).BankName%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, AdHocACH).BankRoutingNumber%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, AdHocACH).BankAccountNumber%>&nbsp;
                                        </td>
                                    </tr>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                    <input type="hidden" runat="server" id="txtSelectedAdHocACH" /><input type="hidden"
                        value="<%= lnkDeleteConfirmAdHocACH.ClientId%>" />
                    <asp:Panel runat="server" ID="pnlAdHocACH">
                        <br />
                        <asp:LinkButton ID="lnkFirstAdHocACH" runat="server" class="lnk">
                            <img id="Img11" align="absmiddle" runat="server" src="~/images/16x16_results_first2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkPrevAdHocACH" runat="server" class="lnk">
                            <img id="Img12" align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png"
                                border="0" /></asp:LinkButton>
                        &nbsp;<asp:Label ID="labLocationAdHocACH" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="lnkNextAdHocACH" runat="server" class="lnk">
                            <img id="Img13" align="absmiddle" runat="server" src="~/images/16x16_results_next2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkLastAdHocACH" runat="server" class="lnk">
                            <img id="Img14" align="absmiddle" runat="server" src="~/images/16x16_results_last2.png"
                                border="0" /></asp:LinkButton>
                    </asp:Panel>
                    <div runat="server" id="pnlNoAdHocACH" style="text-align: center; padding: 20 5 5 5;">
                        This client has no Additional ACHs.</div>
                        </ContentTemplate> 
                    </asp:UpdatePanel> 
                </div>
                <div id="dvPanel1" runat="server">
                     <asp:UpdatePanel ID="UpdAchRules" runat="server" UpdateMode="Conditional">
                     <ContentTemplate>

                    <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                        width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                ACH Rules
                            </td>
                            <td style="padding-right: 7;" align="right">
                                <a class="lnk" id="lnkDeleteConfirmACHRule" disabled="disabled" runat="server" href="#"
                                    onmouseup="javascript:Record_DeleteConfirmACHRules(this);">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:CheckBox
                                        runat="server" ID="chkOnlyCurrent" Text="Only Current" AutoPostBack="true" Checked="true">
                                    </asp:CheckBox>
                            </td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size: 11px; font-family: tahoma;"
                        cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width: 20;" class="headItem">
                                <img id="Img15" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"
                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                    border="0" /><img id="Img16" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"
                                        style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                        border="0" />
                            </td>
                            <td class="headItem" style="width: 22;" align="center">
                                <img id="Img17" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                            </td>
                            <td class="headItem" align="center">
                                Status
                            </td>
                            <td class="headItem">
                                Start Date
                            </td>
                            <td class="headItem">
                                End Date
                            </td>
                            <td class="headItem">
                                Dep. Day
                            </td>
                             <td class="headItem" style='display: <%=iif(IsMultiDeposit(), "block", "none" )%>;'>
                                Original Dep. Day
                            </td>
                            <td class="headItem" align="right">
                                Dep. Amount
                            </td>
                            <td class="headItem" style="padding-left: 10;">
                                Bank Name
                            </td>
                            <td class="headItem">
                                Routing No.
                            </td>
                            <td class="headItem">
                                Account No.
                            </td>
                        </tr>
                        <asp:Repeater ID="rpACHRules" runat="server">
                            <ItemTemplate>
                                <a href="<%# ResolveUrl("~/clients/client/finances/ach/achrule.aspx?id=") + ClientID.ToString() + "&ruleachid=" + CType(Container.DataItem, ACHRule).RuleACHID.ToString() %>" onclick='<%# iif(CType(Container.DataItem, ACHRule).Locked, "return false;", "return true;") %>'>
                                    <tr>
                                        <td style="width: 20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <img id="Img18" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                    id="Img19" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                    style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                    align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#CType(Container.DataItem, ACHRule).RuleACHID.ToString()%>);"
                                                        style="display: none;" type="checkbox" />
                                        </td>
                                        <td style="width: 22;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="center">
                                            <img id="Img20" runat="server" src="~/images/16x16_tools.png" border="0" />
                                        </td>
                                        <td style="color: <%#IIf(CType(Container.DataItem, ACHRule).Status.ToLower() = "active", "rgb(0,139,0)", IIf(CType(Container.DataItem, ACHRule).Status.ToLower() = "future", "blue","red"))%>;"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap" align="center">
                                            <%#CType(Container.DataItem, ACHRule).Status%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#CType(Container.DataItem, ACHRule).StartDate.ToString("MMM yyyy")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#GetDateString(CType(Container.DataItem, ACHRule).EndDate,"MMM yyyy")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            Day&nbsp;<%#CType(Container.DataItem, ACHRule).DepositDay%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style='display: <%=iif(IsMultiDeposit(), "block", "none" )%>;'>
                                            Day&nbsp;<%#CType(Container.DataItem, ACHRule).OriginalDepositDay%>&nbsp;
                                        </td>
                                        <td style="color: rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="right">
                                            <%#CType(Container.DataItem, ACHRule).DepositAmount.ToString("c")%>&nbsp;
                                        </td>
                                        <td style="padding-left: 10;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <%#CType(Container.DataItem, ACHRule).BankName%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, ACHRule).BankRoutingNumber%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, ACHRule).BankAccountNumber%>&nbsp;
                                        </td>
                                    </tr>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                    <input type="hidden" runat="server" id="txtSelectedACHRules" /><input type="hidden"
                        value="<%= lnkDeleteConfirmACHRule.ClientId%>" />
                    <asp:Panel runat="server" ID="pnlACHRules">
                        <br />
                        <asp:LinkButton ID="lnkFirstACHRule" runat="server" class="lnk">
                            <img id="Img21" align="absmiddle" runat="server" src="~/images/16x16_results_first2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkPrevACHRule" runat="server" class="lnk">
                            <img id="Img22" align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png"
                                border="0" /></asp:LinkButton>
                        &nbsp;<asp:Label ID="labLocationACHRule" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="lnkNextACHRule" runat="server" class="lnk">
                            <img id="Img23" align="absmiddle" runat="server" src="~/images/16x16_results_next2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkLastACHRule" runat="server" class="lnk">
                            <img id="Img24" align="absmiddle" runat="server" src="~/images/16x16_results_last2.png"
                                border="0" /></asp:LinkButton>
                    </asp:Panel>
                    <div runat="server" id="pnlNoACHRules" style="text-align: center; padding: 20 5 5 5;">
                        This client has no ACH Rules.</div>
                     </ContentTemplate>
                    </asp:UpdatePanel>        
                </div>
                <div id="dvPanel3" runat="server" style="display: none">
                <asp:UpdatePanel ID="UpdCheckRules" runat="server" UpdateMode="Conditional">
                     <ContentTemplate>

                    <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                        width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                Check Rules
                            </td>
                            <td style="padding-right: 7;" align="right">
                                <a class="lnk" id="lnkDeleteConfirmCheckRule" disabled="disabled" runat="server" href="#"
                                    onmouseup="javascript:Record_DeleteConfirmCheckRules(this);">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:CheckBox
                                        runat="server" ID="chkOnlyCurrentCheck" Text="Only Current" AutoPostBack="true" Checked="true">
                                    </asp:CheckBox>
                            </td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size: 11px; font-family: tahoma;"
                        cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width: 20;" class="headItem">
                                <img id="Img36" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"
                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                    border="0" /><img id="Img37" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"
                                        style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                        border="0" />
                            </td>
                            <td class="headItem" style="width: 22;" align="center">
                                <img id="Img38" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                            </td>
                            <td class="headItem" align="center">
                                Status
                            </td>
                            <td class="headItem">
                                Start Date
                            </td>
                            <td class="headItem">
                                End Date
                            </td>
                            <td class="headItem">
                                Dep. Day
                            </td>
                             <td class="headItem" style='display: <%=iif(IsMultiDeposit(), "block", "none" )%>;'>
                                Original Dep. Day
                            </td>
                            <td class="headItem" align="right">
                                Dep. Amount
                            </td>
                        </tr>
                        <asp:Repeater ID="rpCheckRules" runat="server">
                            <ItemTemplate>
                                <a href="<%# ResolveUrl("~/clients/client/finances/ach/checkrule.aspx?id=") + ClientID.ToString() + "&rulecheckid=" + CType(Container.DataItem, CheckRule).RuleCheckID.ToString() %>" onclick='<%# iif(CType(Container.DataItem, CheckRule).Locked, "return false;", "return true;") %>'>
                                    <tr>
                                        <td style="width: 20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <img id="Img18" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                    id="Img19" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                    style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                    align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#CType(Container.DataItem, CheckRule).RuleCheckID.ToString()%>);"
                                                        style="display: none;" type="checkbox" />
                                        </td>
                                        <td style="width: 22;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="center">
                                            <img id="Img20" runat="server" src="~/images/16x16_tools.png" border="0" />
                                        </td>
                                        <td style="color: <%#IIf(CType(Container.DataItem, CheckRule).Status.ToLower() = "active", "rgb(0,139,0)", IIf(CType(Container.DataItem, CheckRule).Status.ToLower() = "future", "blue","red"))%>;"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap" align="center">
                                            <%#CType(Container.DataItem, CheckRule).Status%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#CType(Container.DataItem, CheckRule).StartDate.ToString("MMM yyyy")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#GetDateString(CType(Container.DataItem, CheckRule).EndDate, "MMM yyyy")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            Day&nbsp;<%#CType(Container.DataItem, CheckRule).DepositDay%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" style='display: <%=iif(IsMultiDeposit(), "block", "none" )%>;'>
                                            Day&nbsp;<%#CType(Container.DataItem, CheckRule).OriginalDepositDay%>&nbsp;
                                        </td>
                                        <td style="color: rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="right">
                                            <%#CType(Container.DataItem, CheckRule).DepositAmount.ToString("c")%>&nbsp;
                                        </td>
                                    </tr>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                    <input type="hidden" runat="server" id="txtSelectedCheckRules" /><input type="hidden"
                        value="<%= lnkDeleteConfirmCheckRule.ClientId%>" />
                    <asp:Panel runat="server" ID="pnlCheckRules">
                        <br />
                        <asp:LinkButton ID="lnkFirstCheckRule" runat="server" class="lnk">
                            <img id="Img39" align="absmiddle" runat="server" src="~/images/16x16_results_first2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkPrevCheckRule" runat="server" class="lnk">
                            <img id="Img40" align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png"
                                border="0" /></asp:LinkButton>
                        &nbsp;<asp:Label ID="labLocationCheckRule" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="lnkNextCheckRule" runat="server" class="lnk">
                            <img id="Img41" align="absmiddle" runat="server" src="~/images/16x16_results_next2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkLastCheckRule" runat="server" class="lnk">
                            <img id="Img42" align="absmiddle" runat="server" src="~/images/16x16_results_last2.png"
                                border="0" /></asp:LinkButton>
                    </asp:Panel>
                    <div runat="server" id="pnlNoCheckRules" style="text-align: center; padding: 20 5 5 5;">
                        This client has no check rules.</div>
                     </ContentTemplate>
                    </asp:UpdatePanel>     
                 </div> 
                <div id="dvPanel2" runat="server" style="display: none">
                    <table style="margin-top: 15; background-color: #f3f3f3; font-family: tahoma; font-size: 11px;
                        width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding: 5 7 5 7; color: rgb(50,112,163);">
                                Checks
                            </td>
                            <td style="padding-right: 7;" align="right">
                                <a class="lnk" id="lnkDeleteConfirm" disabled="disabled" runat="server" href="#"
                                    onmouseup="javascript:Record_DeleteConfirm(this);">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<asp:CheckBox
                                        runat="server" ID="chkOnlyNotPrinted" Text="Only Not Printed" AutoPostBack="true">
                                    </asp:CheckBox>
                            </td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size: 11px; font-family: tahoma;"
                        cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width: 20;" class="headItem">
                                <img id="Img25" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"
                                    style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png"
                                    border="0" /><img id="Img26" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"
                                        style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png"
                                        border="0" />
                            </td>
                            <td class="headItem" style="width: 22;" align="center">
                                <img id="Img27" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                            </td>
                            <td class="headItem">
                                Bank
                            </td>
                            <td class="headItem">
                                Routing No.
                            </td>
                            <td class="headItem">
                                Acct No.
                            </td>
                            <td class="headItem" align="right">
                                Amount
                            </td>
                            <td class="headItem" style="padding-left: 10;">
                                Check No.
                            </td>
                            <td class="headItem">
                                Status
                            </td>
                            <td class="headItem" style="width: 75;">
                                Entered<img id="Img28" align="absmiddle" style="margin-left: 5;" runat="server" border="0"
                                    src="~/images/sort-asc.png" />
                            </td>
                        </tr>
                        <asp:Repeater ID="rpChecksToPrint" runat="server">
                            <ItemTemplate>
                                <a href="<%# ResolveUrl("~/clients/client/finances/ach/checktoprint.aspx?id=") + ClientID.ToString() + "&ctpid=" + DataBinder.Eval(Container.DataItem, "CheckToPrintID").ToString() %>">
                                    <tr>
                                        <td style="width: 20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem">
                                            <img id="Img29" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"
                                                runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img
                                                    id="Img30" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"
                                                    style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0"
                                                    align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "CheckToPrintID")%>);"
                                                        style="display: none;" type="checkbox" />
                                        </td>
                                        <td style="width: 22;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="center">
                                            <img id="Img31" runat="server" src="~/images/16x16_cheque.png" border="0" />
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "BankName")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "BankRoutingNumber")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "BankAccountNumber")%>&nbsp;
                                        </td>
                                        <td style="color: rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" align="right">
                                            <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>
                                        </td>
                                        <td style="padding-left: 10;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);"
                                            class="listItem" nowrap="nowrap">
                                            <%#DataBinder.Eval(Container.DataItem, "CheckNumber")%>&nbsp;
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#DataBinder.Eval(Container.DataItem, "StatusFormatted")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="nowrap">
                                            <%#DataBinder.Eval(Container.DataItem, "Created", "{0:MMM d, yyyy}")%>
                                        </td>
                                    </tr>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                    <input type="hidden" runat="server" id="txtSelectedChecksToPrint" /><input type="hidden"
                        value="<%= lnkDeleteConfirm.ClientId%>" />
                    <asp:Panel runat="server" ID="pnlChecksToPrint">
                        <br />
                        <asp:LinkButton ID="lnkFirstCheckToPrint" runat="server" class="lnk">
                            <img id="Img32" align="absmiddle" runat="server" src="~/images/16x16_results_first2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkPrevCheckToPrint" runat="server" class="lnk">
                            <img id="Img33" align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png"
                                border="0" /></asp:LinkButton>
                        &nbsp;<asp:Label ID="labLocationChecksToPrint" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="lnkNextCheckToPrint" runat="server" class="lnk">
                            <img id="Img34" align="absmiddle" runat="server" src="~/images/16x16_results_next2.png"
                                border="0" /></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="lnkLastCheckToPrint" runat="server" class="lnk">
                            <img id="Img35" align="absmiddle" runat="server" src="~/images/16x16_results_last2.png"
                                border="0" /></asp:LinkButton>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="pnlNoChecksToPrint" Style="text-align: center; padding: 20 5 5 5;">
                        This client has no checks to print.</asp:Panel>
                </div>
            </td>
        </tr>
    </table>
    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
    <asp:TextBox ID="txtOldPct" runat="server" Style="display: None" />
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDeleteACHRules"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDeleteCheckRules"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDeleteAdHocACH"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveACH"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveFees"></asp:LinkButton>
    <asp:UpdatePanel id="updConvertoMulti" runat="server"   ChildrenAsTriggers="true" UpdateMode="Conditional"   >
        <ContentTemplate>
            <asp:LinkButton runat="server" ID="lnkConvertToMulti"></asp:LinkButton>
            <asp:LinkButton ID="lnkConvertFeeStruct" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkConvertToBofA" runat="server"></asp:LinkButton>
        </ContentTemplate> 
    </asp:UpdatePanel>
</asp:Content>
