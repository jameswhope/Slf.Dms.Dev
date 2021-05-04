<%@ Page Language="VB" AutoEventWireup="false" CodeFile="action.aspx.vb" Inherits="research_queries_financial_checkstoprint_action" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Research - Checks To Print</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>

<body onload="SetFocus('<%= imPrinted.ClientID() %>');">
<form id="frmBody" runat="server">
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" >
    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    }

    var optClearSetting = null;
    var optPrintWithoutSetting = null;
    var optSetWithoutPrinting = null;
    var optPrintAndSet = null;
    var imPrinted = null;
    var cboPrintedBy = null;
    var lnkSetToNow = null;
    var lnkSetToMe = null;
    var lnkSetChecks = null;

    function optClearSetting_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = opt.checked;
        cboPrintedBy.disabled = opt.checked;
        lnkSetToNow.disabled = opt.checked;
        lnkSetToMe.disabled = opt.checked;
    }
    function optPrintWithoutSetting_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = opt.checked;
        cboPrintedBy.disabled = opt.checked;
        lnkSetToNow.disabled = opt.checked;
        lnkSetToMe.disabled = opt.checked;
    }
    function optSetWithoutPrinting_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = !opt.checked;
        cboPrintedBy.disabled = !opt.checked;
        lnkSetToNow.disabled = !opt.checked;
        lnkSetToMe.disabled = !opt.checked;
    }
    function optPrintAndSet_OnPropertyChange(opt)
    {
        LoadControls();

        imPrinted.disabled = !opt.checked;
        cboPrintedBy.disabled = !opt.checked;
        lnkSetToNow.disabled = !opt.checked;
        lnkSetToMe.disabled = !opt.checked;
    }
    function SetToNow()
    {
        LoadControls();

        if (!lnkSetToNow.disabled)
        {
            imPrinted.value = Functoid_Date_GetNow("/", false);
        }
    }
    function SetToMe()
    {
        LoadControls();

        if (!lnkSetToMe.disabled)
        {
		    for (i = 0; i < cboPrintedBy.options.length; i++)
		    {
			    if (cboPrintedBy.options[i].value == <%= UserID.ToString() %>)
			    {
				    cboPrintedBy.selectedIndex = i;
				    break;
				}
		    }
        }
    }
	function LoadControls()
	{
	    if (optClearSetting == null)
	    {
	        optClearSetting = document.getElementById("<%= optClearSetting.ClientID() %>");
            optPrintWithoutSetting = document.getElementById("<%= optPrintWithoutSetting.ClientID() %>");
            optSetWithoutPrinting = document.getElementById("<%= optSetWithoutPrinting.ClientID() %>");
            optPrintAndSet = document.getElementById("<%= optPrintAndSet.ClientID() %>");
            imPrinted = document.getElementById("<%= imPrinted.ClientID() %>");
            cboPrintedBy = document.getElementById("<%= cboPrintedBy.ClientID() %>");
            lnkSetToNow = document.getElementById("<%= lnkSetToNow.ClientID() %>");
            lnkSetToMe = document.getElementById("<%= lnkSetToMe.ClientID() %>");
            lnkSetChecks = document.getElementById("<%= lnkSetChecks.ClientID() %>");
	    }
	}
	function PrintChecks()
	{
        if (Record_RequiredExist())
        {
	        if (optClearSetting.checked)
	        {
	            // post back to clear checks (which will also issue close)
                <%= ClientScript.GetPostBackEventReference(lnkClearChecks, Nothing) %>;
	        }
	        else if (optPrintWithoutSetting.checked)
	        {
	            // popup report
	            PrintResults();

	            // close
	            window.close();
	        }
	        else if (optSetWithoutPrinting.checked)
	        {
	            // post back to set checks (which will also issue close)
                <%= ClientScript.GetPostBackEventReference(lnkSetChecks, Nothing) %>;
	        }
	        else if (optPrintAndSet.checked)
	        {
	            // popup report
	            PrintResults();

	            // post back to set checks (which will also issue close)
                <%= ClientScript.GetPostBackEventReference(lnkSetChecks, Nothing) %>;
	        }
	        else
	        {
	            window.close();
	        }
	    }
	}
	function PrintResults()
	{
	    window.open('<%= ResolveUrl("~/reports/interface/frame.aspx?rpt=checkstoprintreal") %>','win_rptChecksToPrintReal','width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes');
    }
    function Record_RequiredExist()
    {
        LoadControls();

        RemoveBorder(imPrinted);
        RemoveBorder(cboPrintedBy);

        // validate fulfillment area
        if (optSetWithoutPrinting.checked || optPrintAndSet.checked)
        {
            if (imPrinted.value.length == 0)
            {
                ShowMessage("Since these checks will be set as printed, the Printed Date field is required.");
                AddBorder(imPrinted);
                return false;
            }
            else
            {
                if (!IsValidDateTime(imPrinted.value))
                {
                    ShowMessage("The value you entered for the Printed Date is invalid.  This field is only required because these check will be set as printed.");
                    AddBorder(imPrinted);
                    return false;
                }
            }

            if (cboPrintedBy.selectedIndex == -1 || cboPrintedBy.options[cboPrintedBy.selectedIndex].value <= 0)
            {
                ShowMessage("Since these checks will be set as printed, the Printed By field is required.");
                AddBorder(cboPrintedBy);
                return false;
            }
        }

        HideMessage()
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

    </script>
   
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                <td runat="server" id="tdError"></td>
                            </tr>
                        </table>
                        &nbsp;
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-left:10;height:100%;">
                    <div style="height:100%;overflow:auto;">
                        <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                            <tr>
                                <td style="background-color:#f1f1f1;">Fulfillment Options</td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                        <tr>
                                            <td><input runat="server" type="radio" name="optFulfillment" id="optClearSetting"></radio><label for="<%= optClearSetting.ClientID() %>">Clear printed fulfillment information for these checks.</label></td>
                                        </tr>
                                        <tr>
                                            <td><input runat="server" type="radio" name="optFulfillment" id="optPrintWithoutSetting"></radio><label for="<%= optPrintWithoutSetting.ClientID() %>">Print checks without setting them as printed.</label></td>
                                        </tr>
                                        <tr>
                                            <td><input runat="server" type="radio" name="optFulfillment" id="optSetWithoutPrinting"></radio><label for="<%= optSetWithoutPrinting.ClientID() %>">Set checks as printed with the below information, but do not actually print them.</label></td>
                                        </tr>
                                        <tr>
                                            <td><input runat="server" type="radio" name="optFulfillment" id="optPrintAndSet" checked="true"></radio><label for="<%= optPrintAndSet.ClientID() %>">Print checks and set them as printed with the below information.</label></td>
                                        </tr>
                                        <tr>
                                            <td style="padding-left:25;">
                                                <table style="font-family:tahoma;font-size:11px;width:275;" border="0" cellpadding="0" cellspacing="5">
                                                    <tr>
                                                        <td style="width:70;">Printed Date:</td>
                                                        <td><cc1:InputMask cssclass="entry" ID="imPrinted" runat="server" Mask="nn/nn/nnnn"></cc1:InputMask></td>
                                                        <td style="width:55;"><a class="lnk" runat="server" id="lnkSetToNow" href="javascript:SetToNow();">Set To Now</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width:70;">Printed By:</td>
                                                        <td><asp:dropdownlist cssclass="entry" runat="server" id="cboPrintedBy"></asp:dropdownlist></td>
                                                        <td style="width:55;"><a class="lnk" runat="server" id="lnkSetToMe" href="javascript:SetToMe();">Set To Me</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="3" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle"/>Cancel and Close</a></td>
                            <td align="right"><a tabindex="4" style="color:black" class="lnk" href="javascript:PrintChecks();">Resolve<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <asp:LinkButton style="display:none;" runat="server" id="lnkSetChecks"></asp:LinkButton>
        <asp:LinkButton style="display:none;" runat="server" id="lnkClearChecks"></asp:LinkButton>

    </form>
</body>
</html>