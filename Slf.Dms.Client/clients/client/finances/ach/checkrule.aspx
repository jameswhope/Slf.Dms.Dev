<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="checkrule.aspx.vb" Inherits="clients_client_finances_ach_checkrule" Title="DMP - Client - ACH & Fee Structure" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <body id="bdMain" runat="server">
        <style type="text/css">
            .entrycell
            {
            }
            .entrytitlecell
            {
                width: 85;
            }
        </style>
        <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
        <script type="text/javascript">

    var txtStartDate = null;
    var ddlDepositDay = null;
    var txtDepositAmount = null;
    
    var Inputs = null;

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
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
	function LoadControls()
	{
	    //if (txtStartDate == null)
	    //{
	        txtStartDate = document.getElementById("<%= txtStartDate.ClientID() %>");
            ddlDepositDay = document.getElementById("<%= ddlDepositDay.ClientID() %>");
            txtDepositAmount = document.getElementById("<%= txtDepositAmount.ClientID() %>");
            
            Inputs = new Array();
            Inputs.push(txtStartDate);
            Inputs.push(ddlDepositDay);
            Inputs.push(txtDepositAmount);
	    //}
	}
    function Record_RequiredExist()
    {
        LoadControls();

        // remove all display residue
        for (i = 0; i < Inputs.length; i++)
        {
            RemoveBorder(Inputs[i]);
        }

        // validate inputs
        for (i = 0; i < Inputs.length; i++)
        {
            var Input = Inputs[i];

            var Caption = Input.getAttribute("caption");
            var Required = Input.getAttribute("required");
            var Validate = Input.getAttribute("validate");

            if (Required == null)
                Required = "false";

            // check, if required, that content exists
            if (Required.toLowerCase() == "true")
            {
                if (Input.tagName.toLowerCase() == "select")
                {
                    // control is a dropdownlist
                    if (Input.selectedIndex == -1 || Input.options[Input.selectedIndex].value <= 0)
                    {
	                    ShowMessage("The " + Caption + " field is required.");
	                    AddBorderExt(Input);
                        return false;
                    }
                }
                else if (Input.tagName.toLowerCase() == "input")
                {
                    if (Input.type == "text") // textbox
                    {
                        if (Input.value.length == 0)
                        {
	                        ShowMessage("The " + Caption + " field is required.");
	                        AddBorderExt(Input);
                            return false;
                        }
                    }
                    else if (Input.type == "checkbox") // checkbox
                    {
                    }
                }
            }

            // check, if control is textbox and content exists, that it is valid
            if (Input.tagName.toLowerCase() == "input" && Input.value.length > 0 && Validate.length > 0)
            {
                if (!(eval(Validate)))
                {
                    ShowMessage("The value you entered for " + Caption + " is invalid.");
                    AddBorderExt(Input);
                    return false;
                }
            }
        }

        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Rule&m=Are you sure you want to delete this Rule?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Rule",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400});
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function SetToNow(obj)
    {
        var str = Functoid_Date_GetNow("/", false);
        var parts = str.split("/");
        obj.value = parts[0] + "/" + parts[2];
    }
    
    function IsValidDateTimeMY(str)
    {
        var parts = str.split("/");
        return IsValidDateTime(parts[0] + "/01/" + parts[1]);
    }
   
    function AddBorderExt(ctl)
    {
        try{
            AddBorder(ctl);
        }            
        catch(e) {
        //Do nothing
        }
        
    }
    
      
        </script>

        <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
            border="0" cellpadding="0" cellspacing="15">
            <tr>
                <td style="color: #666666;">
                    <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a
                        id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a
                            id="lnkFinances" runat="server" class="lnk" style="color: #666666;">Finances</a>&nbsp;>&nbsp;<a
                                id="lnkcheck" runat="server" class="lnk" style="color: #666666;">check</a>&nbsp;>&nbsp;<asp:Label
                                    runat="server" ID="lblcheckRule"></asp:Label>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="3">
                                <div runat="server" id="dvError" style="display: none;">
                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                        width="100%" border="0">
                                        <tr>
                                            <td valign="top" style="width: 20;">
                                                <img runat="server" src="~/images/message.png" align="absmiddle" border="0">
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
                            <td valign="top">
                                <asp:UpdatePanel ID="upRule" runat="server">
                                    <ContentTemplate>
                                        <div id="divInfo" style="width: 100%;">
                                            <table style="margin: 0 30 30 0; float: left; font-family: tahoma; font-size: 11px;
                                                width: 300;" border="0" cellpadding="5" cellspacing="0">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;">
                                                        General Information
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                                            cellspacing="5">
                                                            <tr>
                                                                <td class="entrytitlecell">
                                                                    Month/Year:
                                                                </td>
                                                                <td>
                                                                    <cc1:InputMask validate="IsValidDateTimeMY(Input.value);" caption="Start Date" required="true"
                                                                        TabIndex="18" CssClass="entry" ID="txtStartDate" runat="server" Mask="nn/nnnn"  c></cc1:InputMask>
                                                                </td>
                                                                <td style="width: 55;">
                                                                    <a id="lnkSetToNowStart" href="javascript:void(0)" onclick="javascript:SetToNow(this.parentElement.previousSibling.childNodes(0));">
                                                                        Set To Current</a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td style="font-style: italic; color: Silver">
                                                                    MM/yyyy
                                                                </td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:Label ID="lblLastUsed" runat="server" Text=""></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                 <!-- My stuff -->
                                 <tr>
                                    <td style="background-color:#f1f1f1;">Created and Modified</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
											<tr>
                                                <td class="entrytitlecell">Created Date:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblCreated" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Created By:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblCreatedBy" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                           <tr>
                                                <td class="entrytitlecell">Modified Date:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblModified" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Modified By:</td>
                                                <td style="height:23px">
                                                   <asp:Label ID="lblModifiedBy" runat="server" CssClass="entry"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <!-- End of my stuff -->
                                            </table>
                                            <table style="margin: 0 30 30 0; float: left; font-family: tahoma; font-size: 11px;
                                                width: 300;" border="0" cellpadding="5" cellspacing="0">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;">
                                                        Collection Information
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table style="table-layout: fixed; font-family: tahoma; font-size: 11px; width: 100%;"
                                                            border="0" cellpadding="0" cellspacing="5">
                                                            <tr id="trMultiOverride" runat="server" style="display: none;">
                                                                <td class="entrytitlecell">
                                                                    Override Deposit:
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList class="entry" ID="ddlClientDepositID" runat="server" Style="font-size: 11px" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="entrytitlecell">
                                                                    Deposit Day:
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList class="entry" ID="ddlDepositDay" runat="server" Style="font-size: 11px">
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="entrytitlecell">
                                                                    Deposit Amount:
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox MaxLength="50" validate="IsValidNumberFloat(Input.value, false, Input);"
                                                                        caption="Deposit Amount" required="true" TabIndex="17" CssClass="entry" ID="txtDepositAmount"
                                                                        runat="server" onkeypress="return onlyDigits(event);"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="entrytitlecell" style="height: 35;">
                                                                    &nbsp;
                                                                </td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table style="margin: 0 30 30 0; float: left; font-family: tahoma; font-size: 11px;
                                                width: 300;" border="0" cellpadding="5" cellspacing="0" style="display: none">
                                                <tr>
                                                    <td style="background-color: #f1f1f1;">
                                                        Available Days for Rules
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Calendar ID="Calendar1" runat="server" Font-Names="Tahoma" Font-Size="12px"
                                                         NextMonthText="Next" PrevMonthText="Prev" SelectionMode="DayWeek" ShowNextPrevMonth="true"
                                                         NextPrevStyle-Font-Bold="true">
                                                         </asp:Calendar>
                                                    </td>
                                                </tr>
                                            
                                            </table>
                                        </div>
                                        <div id="updateRuleProgressDiv" style="display: none; height: 40px; width: 40px">
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                                        </div>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:PostBackTrigger ControlID="lnkSave" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="trRuleOverlap" runat="server">
                <td>
                    <asp:PlaceHolder ID="phRuleOverlaps" runat="server" EnableViewState="true" />
                </td>
            </tr>
        </table>
        <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->
        <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
        <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
        <asp:HiddenField ID="hdnLastUsed" runat="server" /> 
        <script type="text/javascript">
            function onUpdating() {
                // get the update progress div
                var updateProgressDiv = $get('updateRuleProgressDiv');
                // make it visible
                updateProgressDiv.style.display = '';

                //  get the gridview element
                var gridView = $get('divInfo');

                // get the bounds of both the gridview and the progress div
                var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
                var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

                //    do the math to figure out where to position the element (the center of the gridview)
                var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
                var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

                //    set the progress element to this position
                Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
            }

            function onUpdated() {
                // get the update progress div
                var updateProgressDiv = $get('updateRuleProgressDiv');
                // make it invisible
                updateProgressDiv.style.display = 'none';
            }


        </script>

        <ajaxToolkit:UpdatePanelAnimationExtender ID="upaerule" BehaviorID="ruleanimation"
            runat="server" TargetControlID="upRule">
            <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <%-- disable the search button 
                            <EnableAction AnimationTarget="btnSearch" Enabled="false" />
                            --%>                       
                            <%-- fade-out the GridView --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the GridView --%>
                            <FadeIn minimumOpacity=".5" />
                            <%-- re-enable the search button 
                            <EnableAction AnimationTarget="btnSearch" Enabled="true" />
                            --%>  
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
            </Animations>
        </ajaxToolkit:UpdatePanelAnimationExtender>
    </body>
</asp:Content>
