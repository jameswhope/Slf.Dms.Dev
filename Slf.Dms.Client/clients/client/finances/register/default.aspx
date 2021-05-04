<%@ Page Language="VB" EnableEventValidation="false" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_finances_register_default" title="DMP - Client - Register" %>
<%@ MasterType TypeName="clients_client" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="server">

    <style>
        .voidTran {color:rgb(160,160,160);}
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var lnkVoidConfirm = null;
    var lnkDeleteConfirm = null;
    var txtSelected = null;
    
    var hdnReason = null;
    var hdnVoidDate = null;

    var ids = new Array();
    
    function printResults()
    {
        window:print()
    }
    
    function ViewStatements()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/Statements/default.aspx?id=" & ClientID) %>");
    }

    function Record_VoidConfirm()
    {
        LoadControls();

        if (!lnkVoidConfirm.disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Void&t=Void Confirmation&m=<strong>Are you sure you want to void these transactions?</strong><br><br>All transaction associations will be voided as well.';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Void Confirmation",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});        
         }
    }
    function Record_Void(VoidDate, Reason)
    {
        LoadControls();
        
        hdnVoidDate.value = VoidDate;
        hdnReason.value = Reason;
        
        // postback to void
        <%= Page.ClientScript.GetPostBackEventReference(lnkVoid, Nothing) %>;
    }
    function Record_DeleteConfirm()
    {
        LoadControls();

        if (!lnkDeleteConfirm.disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Confirmation&m=<strong>Are you sure you want to delete these transactions?</strong><br><br>All transaction associations will be deleted as well.<br><br>Any transaction that cannot be deleted will be voided.';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Confirmation",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400}); 
        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function RowHover(td, on)
    {
        var tr = td.parentElement;
        var trOther = null;
        
        var HotColor = "";
        var ColdColor = "";

        if (tr.getAttribute("MainRow") != null)
        {
            if (tr.nextSibling != null && tr.nextSibling.getAttribute("MainRow") == null)
            {
                trOther = tr.nextSibling;
            }
        }
        else
        {
            trOther = tr.previousSibling;
        }

        if (IsNullOrEmpty(tr.style.backgroundColor))
        {
            tr.style.backgroundColor = "#ffffff";
        }

        if (IsNullOrEmpty(tr.getAttribute("coldColor")))
        {
            tr.setAttribute("coldColor", tr.style.backgroundColor);

            //set the highlighted color for this row
            var color = new RGBColor(tr.style.backgroundColor);

            var r = color.r - 15;
            var g = color.g - 15;
            var b = color.b - 15;

            if (r < 0) r = 0;
            if (g < 0) g = 0;
            if (b < 0) b = 0;

            tr.setAttribute("hotColor", "rgb(" + r + "," + g + "," + b + ")");
        }

        HotColor = tr.getAttribute("hotColor");
        ColdColor = tr.getAttribute("coldColor");

        if (on)
            tr.style.backgroundColor = HotColor;
        else
            tr.style.backgroundColor = ColdColor;

        if (trOther != null)
        {
            if (on)
                trOther.style.backgroundColor = HotColor;
            else
                trOther.style.backgroundColor = ColdColor;
        }
    }
    function IsNullOrEmpty(s)
    {
        return s == null || s == "";
    }
    function Record_AddTransaction()
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
    }
    function LoadControls()
    {
        if (lnkVoidConfirm == null)
        {
            lnkVoidConfirm = document.getElementById("<%=lnkVoidConfirm.ClientID %>");
            lnkDeleteConfirm = document.getElementById("<%=lnkDeleteConfirm.ClientID %>");
            txtSelected = document.getElementById("<%=txtSelected.ClientID %>");
            hdnReason = document.getElementById("<%=hdnReason.ClientID %>");
            hdnVoidDate = document.getElementById("<%=hdnVoidDate.ClientID %>");
        }
    }
    function AddOrDrop(obj, id, reg)
    {
        var Prefix = (reg == "1") ? "p" : "";

	    if (obj.checked)
	    {
		    AddString(Prefix + id, ids);
	    }
	    else
	    {
		    RemoveString(Prefix + id, ids);
	    }

        UpdateSelected();
    }
    function AddString(string, array)
    {
	    array[array.length] = string;
    }
    function RemoveString(string, array)
    {
	    var index = StringExists(string, array);

	    if (index >= 0 && index < array.length)
	    {
		    array.splice(index, 1);
	    }

	    return array;
    }
    function UpdateSelected()
    {
        LoadControls();

        txtSelected.value = ids.join(",");

        if (txtSelected.value.length > 0)
        {
            lnkVoidConfirm.disabled = false;
            lnkDeleteConfirm.disabled = false;
        }
        else
        {
            lnkVoidConfirm.disabled = true;
            lnkDeleteConfirm.disabled = true;
        }
    }
    function StringExists(string, array)
    {
	    for (i = 0; i < array.length; i++)
	    {
		    if (array[i] == string)
			    return i;
	    }

	    return -1;
    }
    function ClearArray()
    {
	    ids = null;
	    ids = new Array();
    }
    function CheckAll(obj)
    {
        ClearArray();

	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (c = 1; c < table.rows.length; c++)
	    {
	        var td = table.rows[c].cells[0];

            if (td.childNodes.length >= 3 && td.childNodes[2].tagName.toLowerCase() == "input")
            {
		        var off = td.childNodes[0];
		        var on = td.childNodes[1];
		        var chk = td.childNodes[2];

	            off.style.display = "none";
	            on.style.display = "inline";
	            chk.checked = true;
	        }
	    }
    }
    function UncheckAll(obj)
    {
	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (u = 1; u < table.rows.length; u++)
	    {
	        var td = table.rows[u].cells[0];

            if (td.childNodes.length >= 3 && td.childNodes[2].tagName.toLowerCase() == "input")
            {
		        var off = td.childNodes[0];
		        var on = td.childNodes[1];
		        var chk = td.childNodes[2];

		        on.style.display = "none";
		        off.style.display = "inline";
		        chk.checked = false;
		    }
	    }
    }
    function VoidTransactions()
    {
        LoadControls();
        
        if (txtSelected.value.length == 0)
        {
            alert('Please select transactions to void!');
            return;
        }
        
         var url = '<%= ResolveUrl("~/clients/client/finances/bytype/action/void.aspx?id=" & ClientID & "&t=Issue A Void") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Issue A Void",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 550, width: 400
                   });
    }
    </script>
    
    <asp:Label ID="lblNote" runat="server" />

    <table id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="15">
        <tr>
            <td valign="top">
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="font-size:11px;color:#666666;" valign="top"><a id="lnkClient" runat="server" class="lnk" style="font-size:11px;color:#666666;"></a>&nbsp;>&nbsp;Finances</td>
                    </tr>
                    <tr>
                        <td valign="top"><br />
                            <table style="width:100%;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color:rgb(244,242,232);">
                                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                                <td style="width:100%;">
                                                    <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td nowrap="true"><asp:DropDownList AutoPostBack="true" style="font-size:11px;font-family:tahoma;" runat="server" id="ddlType"><asp:ListItem value="0" text="Group Adjustments"></asp:ListItem><asp:ListItem value="1" text="View Chronology"></asp:ListItem></asp:DropDownList></td>
                                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="true"><asp:CheckBox AutoPostBack="true"  runat="server" id="chkHideBouncedVoided" text="Hide Bounced/Voided"></asp:CheckBox></td>
                                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="true"><asp:LinkButton id="lnkFilter" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" />Apply Filter</asp:LinkButton></td>
                                                            <td nowrap="true" style="width:100%;">&nbsp;</td>
                                                            <td runat="server" style="display:none;" id="tdVoidConfirm" nowrap="true"><a id="lnkVoidConfirm" disabled="true" runat="server" class="gridButton" href="javascript:Record_VoidConfirm();">Void</a></td>
                                                            <td runat="server" style="display:none;" id="tdSeparator" nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td runat="server" style="display:none;" id="tdDeleteConfirm" nowrap="true"><a id="lnkDeleteConfirm" disabled="true" runat="server" class="gridButton" href="javascript:Record_DeleteConfirm();">Delete</a></td>
                                                            <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:printResults()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_Print.png" /></a></td>
                                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table onselectstart="return false;" style="width:100%;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="center" style="width:25;" class="headItem4"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);" style="cursor: pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);" style="cursor: pointer; display: none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                                                <td align="center" style="width:22;" class="headItem4"><img runat="server" src="~/images/16x16_icon.png" border="0" /></td>
                                                <td align="center" style="width:17;" class="headItem4"><img runat="server" src="~/images/12x16_paperclip.png" border="0" /></td>
                                                <td nowrap="true" class="headItem4">Transaction Date</td>
                                                <td nowrap="true" class="headItem4" style="padding:3 10 3 3">UID</td>
                                                <td class="headItem4">Type</td>
                                                <td class="headItem4">Associated To</td>
                                                <td nowrap="true" class="headItem4" align="right" style="width:80;padding-right:7;">Amount</td>
                                                <td nowrap="true" class="headItem4" style="padding-right:7;" align="right" style="width:80;font-weight:bold;">SDA Balance</td>
                                                <td nowrap="true" class="headItem4" style="padding-right:7;" align="right" style="width:80;font-weight:bold;">PFO Balance</td>
                                            </tr>
                                            <asp:Repeater runat="server" id="rpTransactions">
                                                <ItemTemplate>
                                                    <a href="<%#rpTransactions_Redirect(CType(Container.DataItem, RegisterTransaction))%>">
                                                    <tr MainRow="true" <%#rpTransactions_RowStyle(CType(Container.DataItem, RegisterTransaction))%>>
                                                        <td runat="server" id="tdSelect" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem4" style="width:25;" align="center"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display: none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="AddOrDrop(this, '<%#String.Join("|",CType(Container.DataItem, RegisterTransaction).RelatedIDs.toArray())%>', '<%#CType(Container.DataItem, RegisterTransaction).RegisterFirst%>');" style="display: none;" type="checkbox" /></td>
                                                        <td runat="server" id="tdIcon" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" align="center" style="width:22;" class="listItem4"><img runat="server" src="~/images/16x16_cheque.png" border="0" /></td>
                                                        <td runat="server" id="tdAttachments" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" align="center" style="width:17;" class="listItem4"><%#GetAttachmentText(Integer.Parse(CType(Container.DataItem, RegisterTransaction).ID), IIf(Integer.Parse(CType(Container.DataItem, RegisterTransaction).EntryTypeID) = -1 And CType(Container.DataItem, RegisterTransaction).EntryTypeName = "Payment", "registerpayment", "register"))%></td>
                                                        <td runat="server" id="tdDate" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" nowrap="true" class="listItem4" style="padding-right:10"><%#CType(Container.DataItem, RegisterTransaction).Date.ToString("MM/dd/yyyy hh:mm tt")%></td>
                                                        <td runat="server" id="tdID" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" nowrap="true" class="listItem4" style="padding:3 10 3 3;" ><%#CType(Container.DataItem, RegisterTransaction).ID%></td>
                                                        <td runat="server" id="tdType" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem4" style="padding-right:10"><%#CType(Container.DataItem, RegisterTransaction).EntryTypeName%></td>
                                                        <td runat="server" id="tdAssociatedTo" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem4" style="font-style:italic;color:#757575;"><%#rpTransactions_Associations(CType(Container.DataItem, RegisterTransaction))%>&nbsp;</td>
                                                        <td runat="server" id="tdAmount" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" nowrap="true" class="listItem4" align="right" style="padding-right:7;"><%#rpTransactions_Amount(CType(Container.DataItem, RegisterTransaction).OriginalAmount, CType(Container.DataItem, RegisterTransaction).Amount)%></td>
                                                        <td runat="server" id="tdSDABalance" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" nowrap="true" class="listItem4" align="right" style="padding-right:7;border-left:solid 2px rgb(112,168,209);"><%#rpTransactions_SDABalance(CType(Container.DataItem, RegisterTransaction).SDABalance)%></td>
                                                        <td runat="server" id="tdPFOBalance" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" nowrap="true" class="listItem4" align="right" style="padding-right:7;border-left:solid 1px #d3d3d3;"><%#rpTransactions_PFOBalance(CType(Container.DataItem, RegisterTransaction).PFOBalance)%></td>
                                                    </tr>
                                                    <tr runat="server" id="trFeeAdjustments" Visible="false">
                                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" colspan="8" class="listItem4" align="right">
                                                            <table style="width:300;font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="0">
                                                                <asp:Repeater runat="server" id="rpFeeAdjustments">
                                                                    <ItemTemplate>
                                                                        <a href="<%#rpFeeAdjustments_Redirect(CType(Container, RepeaterItem))%>">
                                                                        <tr>
                                                                            <td class="listItem6"><%#CType(DataBinder.Eval(Container.DataItem, "TransactionDate"), DateTime).ToString("MM/dd/yyyy hh:mm tt")%></td>
                                                                            <td class="listItem6">Fee Adjustment</td>
                                                                            <td class="listItem6" style="width:18;"><%#rpFeeAdjustments_ArrowDirection(DataBinder.Eval(Container.DataItem, "Amount"))%></td>
                                                                            <td class="listItem6" align="right"><%#rpFeeAdjustments_Amount(DataBinder.Eval(Container.DataItem, "Amount"))%></td>
                                                                        </tr>
                                                                        </a>
                                                                    </ItemTemplate>
                                                                </asp:Repeater>
                                                                <tr>
                                                                    <td class="listItem7" colspan="3" align="right">Total</td>
                                                                    <td class="listItem7" align="right"><%#Math.Abs(CType(CType(Container.DataItem, RegisterTransaction).Amount, Double)).ToString("$#,##0.00")%></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    </a>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </table>
                                        <input type="hidden" runat="server" id="txtSelected" />
                                    </td>
                                </tr>
                            </table>
                            <img width="450" height="1" runat="server" src="~/images/spacer.gif" border="0" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:LinkButton runat="server" ID="lnkVoid" />
    <asp:LinkButton runat="server" ID="lnkRebalance" />
    
    <asp:HiddenField ID="hdnReason" runat="server" />
    <asp:HiddenField ID="hdnVoidDate" runat="server" />

</asp:Content>