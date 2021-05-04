<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_finances_mediation_default" title="DMP - Client - Negotiation" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var lblAvailableAmount = null;
    var lblUsedAmount = null;
    var lblUsedPercentageTotal = null;
    var lblUsedPercentageCurrent = null;
    var lnkDeleteConfirm = null;

    function RowHover(td, on)
    {
	    if (on)
		    td.parentElement.style.backgroundColor = "#f3f3f3";
	    else
		    td.parentElement.style.backgroundColor = "#ffffff";
    }
    function RowClick(MediationID, AccountID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/creditors/mediation/calculator.aspx?id=") %>" + MediationID + "&aid=" + AccountID);
    }
    function Record_ResetMatrix()
    {
        // postback to reset matrix
        <%= ClientScript.GetPostBackEventReference(lnkResetMatrix, Nothing) %>;
    }
    function Record_DeleteConfirm()
    {
        LoadControls();

        if (!lnkDeleteConfirm.disabled)
        {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Negotiations&m=Are you sure you want to delete this selection of negotiations?';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Delete Negotiations",
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
    function LoadControls()
    {
        if (lnkDeleteConfirm == null)
        {
            lnkDeleteConfirm = document.getElementById("<%= lnkDeleteConfirm.ClientID %>");
            lblAvailableAmount = document.getElementById("<%= lblAvailableAmount.ClientID %>");
            lblUsedAmount = document.getElementById("<%= lblUsedAmount.ClientID %>");
            lblUsedPercentageTotal = document.getElementById("<%= lblUsedPercentageTotal.ClientID %>");
            lblUsedPercentageCurrent = document.getElementById("<%= lblUsedPercentageCurrent.ClientID %>");
        }
    }
    function txtAmount_OnBlur(txt)
    {
        LoadControls();

        var CurrentRow = txt.parentElement.parentElement;
        var CurrentRowIndex = CurrentRow.rowIndex;

        var txtPercentageTotal = CurrentRow.cells[6].childNodes[0];
        var txtPercentageCurrent = CurrentRow.cells[8].childNodes[0];

        var AvailableAmount = parseFloat(lblAvailableAmount.innerHTML);
        var CurrentAmount = parseFloat(CurrentRow.cells[2].innerHTML.replace("$", "").replace(",", ""));

        txtPercentageTotal.value = FormatNumber(Math.round((parseFloat(txt.value) / AvailableAmount) * 10000) / 100, false, 2);
        txtPercentageCurrent.value = FormatNumber(Math.round((parseFloat(txt.value) / CurrentAmount) * 10000) / 100, false, 2);

        RetotalMatrix(CurrentRow.parentElement.parentElement);
    }
    function txtPercentageTotal_OnBlur(txt)
    {
        LoadControls();

        var CurrentRow = txt.parentElement.parentElement;
        var CurrentRowIndex = CurrentRow.rowIndex;

        var txtAmount = CurrentRow.cells[5].childNodes[0];
        var txtPercentageCurrent = CurrentRow.cells[8].childNodes[0];

        var AvailableAmount = parseFloat(lblAvailableAmount.innerHTML);
        var CurrentAmount = parseFloat(CurrentRow.cells[2].innerHTML.replace("$", "").replace(",", ""));

        txtAmount.value = FormatNumber(Math.round(AvailableAmount * parseFloat(txt.value)) / 100, false, 2);
        txtPercentageCurrent.value = FormatNumber(Math.round((parseFloat(txtAmount.value) / CurrentAmount) * 10000) / 100, false, 2);

        RetotalMatrix(CurrentRow.parentElement.parentElement);
    }
    function txtPercentageCurrent_OnBlur(txt)
    {
        LoadControls();

        var CurrentRow = txt.parentElement.parentElement;
        var CurrentRowIndex = CurrentRow.rowIndex;

        var txtAmount = CurrentRow.cells[5].childNodes[0];
        var txtPercentageTotal = CurrentRow.cells[6].childNodes[0];

        var AvailableAmount = parseFloat(lblAvailableAmount.innerHTML);
        var CurrentAmount = parseFloat(CurrentRow.cells[2].innerHTML.replace("$", "").replace(",", ""));

        txtAmount.value = FormatNumber(Math.round(CurrentAmount * parseFloat(txt.value)) / 100, false, 2);
        txtPercentageTotal.value = FormatNumber(Math.round((parseFloat(txtAmount.value) / AvailableAmount) * 10000) / 100, false, 2);

        RetotalMatrix(CurrentRow.parentElement.parentElement);
    }
    function RetotalMatrix(tbl)
    {
        var UsedAmount = 0.0;
        var UsedPercentageTotal = 0.0;
        var UsedPercentageCurrent = 0.0;

        for (i = 1; i < tbl.rows.length - 1; i++)
        {
            UsedAmount += parseFloat(tbl.rows[i].cells[5].childNodes[0].value);
            UsedPercentageTotal += parseFloat(tbl.rows[i].cells[6].childNodes[0].value);
            UsedPercentageCurrent += parseFloat(tbl.rows[i].cells[8].childNodes[0].value);
        }

        lblUsedAmount.innerHTML = FormatNumber(UsedAmount, true, 2);
        lblUsedPercentageTotal.innerHTML = FormatNumber(UsedPercentageTotal, true, 2);
        lblUsedPercentageCurrent.innerHTML = FormatNumber(UsedPercentageCurrent, true, 2);
    }
    function Mediate(lnk, AccountID)
    {
        var CurrentRow = lnk.parentElement.parentElement;
        var CurrentRowIndex = CurrentRow.rowIndex;
        var Table = CurrentRow.parentElement.parentElement;

        var Amount = parseFloat(Table.rows[CurrentRowIndex].cells[3].childNodes[0].value);

        window.navigate("<%= ResolveUrl("~/clients/client/creditors/mediation/calculator.aspx?a=a&aid=") %>" + AccountID + "&sa=" + Amount);
    }

    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Creditors&nbsp;>&nbsp;Negotiation Preparation</td></tr>
        <tr>
            <td valign="top">
                <asi:TabStrip runat="server" id="tsMain"></asi:TabStrip>
                <div runat="server" id="dvPage0">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr id="trInfoBoxNewMediations" runat="server">
                            <td style="padding:15 15 0 15;">
                                <div class="iboxDiv">
                                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                        <tr>
                                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                            <td>
                                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformationNewMediations"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="iboxMessageCell">The client's available SDA balance is&nbsp;<asp:Label runat="server" id="lblSDAAccountBalanceNewMediations"></asp:Label>&nbsp;of which&nbsp;<asp:Label runat="server" id="lblFrozenAmountNewMediations"></asp:Label>&nbsp;is frozen.&nbsp;&nbsp;<asp:Label id="lblInfoBoxNewMediations" runat="server"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top:20;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td colspan="3">&nbsp;</td>
                                        <td colspan="2" valign="top" style="padding:0;text-align:center;font-weight:bold;background-image:url(<%=ResolveUrl("~/images/fill_gray_top_left.bmp")%>);background-position:left top;background-repeat:no-repeat;background-color:#f1f1f1;" align="center"><div style="padding:5 0 0 0;background-image:url(<%=ResolveUrl("~/images/fill_gray_top_right.bmp")%>);background-position:right top;background-repeat:no-repeat;">Threshold Required</div></td>
                                        <td>&nbsp;</td>
                                        <td colspan="2" valign="top" style="padding:0;text-align:center;font-weight:bold;background-image:url(<%=ResolveUrl("~/images/fill_gray_top_left.bmp")%>);background-position:left top;background-repeat:no-repeat;background-color:#f1f1f1;" align="center"><div style="padding:5 0 0 0;background-image:url(<%=ResolveUrl("~/images/fill_gray_top_right.bmp")%>);background-position:right top;background-repeat:no-repeat;">Current</div></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="listItem5">Creditor</td>
                                        <td class="listItem5" align="right">Originally Owed</td>
                                        <td class="listItem5" align="right">Currently Owed</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;width:50;" align="right">Percent</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;width:60;" align="right">Amount</td>
                                        <td class="listItem5" style="width:40;" align="center">Avail.</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;width:40;" align="right">Has</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;width:40;" align="right">Needs</td>
                                        <td class="listItem5">&nbsp;</td>
                                    </tr>
                                    <asp:Repeater ID="rpAccountsNewMediations" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="listItem5"><%#DataBinder.Eval(Container.DataItem, "CreditorName")%></td>
                                                <td style="color:rgb(220,0,0);" class="listItem5" align="right"><%#CType(DataBinder.Eval(Container.DataItem, "OriginalAmount"), Double).ToString("c")%></td>
                                                <td style="color:rgb(220,0,0);" class="listItem5" align="right"><%#CType(DataBinder.Eval(Container.DataItem, "CurrentAmount"), Double).ToString("c")%></td>
                                                <td style="background-color:#f1f1f1;" class="listItem5" align="right"><asp:Label runat="server" id="lblPercentRequired"></asp:Label></td>
                                                <td style="background-color:#f1f1f1;color:rgb(0,129,0);" class="listItem5" align="right"><asp:Label runat="server" id="lblAmountRequired"></asp:Label></td>
                                                <td class="listItem5" align="center"><img runat="server" id="imgAvailable" border="0" align="absmiddle"/></td>
                                                <td style="background-color:#f1f1f1;" class="listItem5" align="right"><asp:Label runat="server" id="lblPercentCurrentHas"></asp:Label></td>
                                                <td style="background-color:#f1f1f1;" class="listItem5" align="right"><asp:Label runat="server" id="lblPercentCurrentNeeds"></asp:Label></td>
                                                <td class="listItem5"><a id="lnkMediateNewMediations" runat="server" href="#" class="lnk">Negotiate</a></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <tr id="trNoAccountsNewMediations" runat="server"><td class="listItem5" colspan="9" style="text-align:center;font-style:italic;padding:10 5 10 5;">This client has no accounts</td></tr>
                                    <tr>
                                        <td style="padding:5 10 10 10;font-weight:bold;">Total</td>
                                        <td style="padding:5 10 10 10;font-weight:bold;color:rgb(220,0,0);" align="right"><asp:Label runat="server" id="lblOriginalAmountTotal"></asp:Label></td>
                                        <td style="padding:5 10 10 10;font-weight:bold;color:rgb(220,0,0);" align="right"><asp:Label runat="server" id="lblCurrentAmountTotal"></asp:Label></td>
                                        <td style="padding:5 10 10 10;background-color:#f1f1f1;background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_left.bmp")%>);background-position:left bottom;background-repeat:no-repeat;" align="right"><asp:Label runat="server" id="lblPercentRequiredTotal"></asp:Label></td>
                                        <td style="padding:5 10 10 10;background-color:#f1f1f1;background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_right.bmp")%>);background-position:right bottom;background-repeat:no-repeat;color:rgb(0,129,0);" align="right"><asp:Label runat="server" id="lblAmountRequiredTotal"></asp:Label></td>
                                        <td style="padding:5 10 10 10;width:40;" align="center">&nbsp;</td>
                                        <td style="padding:5 10 10 10;background-color:#f1f1f1;background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_left.bmp")%>);background-position:left bottom;background-repeat:no-repeat;" align="right"><asp:Label runat="server" id="lblPercentCurrentHasTotal"></asp:Label></td>
                                        <td style="padding:5 10 10 10;background-color:#f1f1f1;background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_right.bmp")%>);background-position:right bottom;background-repeat:no-repeat;" align="right"><asp:Label runat="server" id="lblPercentCurrentNeedsTotal"></asp:Label></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                <img width="650" height="1" src="~/images/spacer.gif" runat="server" border="0"/>
                            </td>
                        </tr>
                    </table>
                </div>
                <div runat="server" id="dvPage1">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr id="trInfoBoxDisbursementGrid" runat="server">
                            <td style="padding:15 15 0 15;">
                                <div class="iboxDiv">
                                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                        <tr>
                                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                            <td>
                                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformationDisbursementGrid"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="iboxMessageCell">The client's available SDA balance is&nbsp;<asp:Label runat="server" id="lblSDAAccountBalanceDisbursementGrid"></asp:Label>&nbsp;of which&nbsp;<asp:Label runat="server" id="lblFrozenAmountDisbursementGrid"></asp:Label>&nbsp;is frozen.&nbsp;&nbsp;<asp:Label id="lblInfoBoxDisbursementGrid" runat="server"></asp:Label></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top:20;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="listItem5">Creditor</td>
                                        <td class="listItem5" align="right">Originally Owed</td>
                                        <td class="listItem5" align="right">Currently Owed</td>
                                        <td class="listItem5" style="font-weight:bold;" align="right">Available:</td>
                                        <td class="listItem5" style="background-image:url(<%=ResolveUrl("~/images/fill_gray_top_left.bmp")%>);background-position:left top;background-repeat:no-repeat;background-color:#f1f1f1;padding:0 0 0 5;width:10;" align="center">$</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;padding:5 5 5 3;width:50;" align="right"><asp:Label runat="server" id="lblAvailableAmount"></asp:Label></td>
                                        <td class="listItem5" style="background-color:#f1f1f1;padding:5 3 5 3;width:40;"><img id="Img4" width="25" height="1" src="~/images/spacer.gif" runat="server" border="0"/></td>
                                        <td class="listItem5" style="background-color:#f1f1f1;padding:0 0 0 0;width:6;">&nbsp;</td>
                                        <td class="listItem5" style="background-color:#f1f1f1;padding:5 3 5 3;width:40;"><img id="Img5" width="25" height="1" src="~/images/spacer.gif" runat="server" border="0"/></td>
                                        <td class="listItem5" style="background-image:url(<%=ResolveUrl("~/images/fill_gray_top_right.bmp")%>);background-position:right top;background-repeat:no-repeat;background-color:#f1f1f1;padding:0 5 0 0;width:10;">&nbsp;</td>
                                        <td class="listItem5">&nbsp;</td>
                                    </tr>
                                    <asp:Repeater ID="rpAccountsDisbursementGrid" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="listItem5"><%#DataBinder.Eval(Container.DataItem, "CreditorName")%></td>
                                                <td style="color:rgb(220,0,0);" class="listItem5" align="right"><%#CType(DataBinder.Eval(Container.DataItem, "OriginalAmount"), Double).ToString("c")%></td>
                                                <td style="color:rgb(220,0,0);" class="listItem5" align="right"><%#CType(DataBinder.Eval(Container.DataItem, "CurrentAmount"), Double).ToString("c")%></td>
                                                <td style="color:gray;" class="listItem5" align="right">Modify:</td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:0 0 0 5;width:10;" align="center">$</td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:5 5 5 3;width:50;"><asp:TextBox style="text-align:right;" CssClass="entry" runat="server" id="txtAmount"></asp:TextBox></td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:5 3 5 3;width:40;"><asp:TextBox style="text-align:right;" CssClass="entry" runat="server" id="txtPercentageTotal"></asp:TextBox></td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:0 0 0 0;width:6;" align="center">%</td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:5 3 5 3;width:40;"><asp:TextBox style="text-align:right;" CssClass="entry" runat="server" id="txtPercentageCurrent"></asp:TextBox></td>
                                                <td class="listItem5" style="background-color:#f1f1f1;padding:0 5 0 0;width:10;" align="center">%</td>
                                                <td class="listItem5"><a href="#" onclick="Mediate(this,<%#DataBinder.Eval(Container.DataItem, "AccountID")%>);return false;" class="lnk">Negotiate</a></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <tr id="trNoAccountsDisbursementGrid" runat="server"><td class="listItem5" colspan="11" style="text-align:center;font-style:italic;padding:10 5 10 5;">This client has no accounts</td></tr>
                                    <tr>
                                        <td style="font-weight:bold;padding:5 10 5 10;" colspan="4" align="right">Used:</td>
                                        <td style="background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_left.bmp")%>);background-position:left bottom;background-repeat:no-repeat;background-color:#f1f1f1;padding:5 0 8 5;width:10;" align="center">$</td>
                                        <td style="background-color:#f1f1f1;padding:5 5 8 3;width:50;" align="right"><asp:Label runat="server" id="lblUsedAmount">&nbsp;</asp:Label></td>
                                        <td style="background-color:#f1f1f1;padding:5 3 8 3;width:40;" align="right"><asp:Label runat="server" id="lblUsedPercentageTotal">&nbsp;</asp:Label></td>
                                        <td style="background-color:#f1f1f1;padding:5 0 8 0;width:6;" align="center">%</td>
                                        <td style="background-color:#f1f1f1;padding:5 5 8 3;width:40;" align="right"><asp:Label runat="server" id="lblUsedPercentageCurrent">&nbsp;</asp:Label></td>
                                        <td style="background-image:url(<%=ResolveUrl("~/images/fill_gray_bottom_right.bmp")%>);background-position:right bottom;background-repeat:no-repeat;background-color:#f1f1f1;padding:5 5 8 0;width:10;" align="center">%</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                <img width="650" height="1" src="~/images/spacer.gif" runat="server" border="0"/>
                            </td>
                        </tr>
                    </table>
                </div>
                <div runat="server" id="dvPage2">
                    <table style="margin-top:15px;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="background-color:#f3f3f3;padding: 5 5 5 5;">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="color:rgb(50,112,163);">Existing Negotiations</td>
                                        <td align="right"><a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="javascript:Record_DeleteConfirm();">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A1" runat="server" href="javascript:window.print();"><img id="Img2" runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                    <tr>
                                        <td align="center" style="width:20;" class="headItem"><img id="Img6" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img7" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                                        <td class="headItem" style="width:22;" align="center"><img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                                        <td class="headItem">Negotiator</td>
                                        <td class="headItem">Creditor</td>
                                        <td class="headItem" align="right">Settle Amount</td>
                                        <td class="headItem" align="right">Settle Percent</td>
                                        <td class="headItem" align="right">Savings</td>
                                        <td class="headItem" align="right">Cost</td>
                                        <td class="headItem" align="right">Holds</td>
                                        <td class="headItem" style="padding-left:10;width:125;">Created</td>
                                    </tr>
                                    <asp:repeater id="rpMediations" runat="server">
                                        <itemtemplate>
                                            <a href="<%# ResolveUrl("~/clients/client/creditors/mediation/calculator.aspx?id=") & DataBinder.Eval(Container.DataItem, "MediationID") & "&aid=" & DataBinder.Eval(Container.DataItem, "AccountID") %>">
                                                <tr>
	                                                <td style="padding-top:7;width:20;" valign="top" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"><img id="Img9" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img10" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "MediationID")%>);" style="display:none;" type="checkbox" /></td>
                                                    <td style="padding-top:6;width:22;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center"><img id="Img11" runat="server" src="~/images/16x16_form_red.png" border="0"/></td>
                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                        <%#DataBinder.Eval(Container.DataItem, "CreatedByName")%>
                                                    </td>
                                                    <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                        <%#DataBinder.Eval(Container.DataItem, "CurrentCreditorName")%>
                                                    </td>
                                                    <td style="color:rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                        <%#DataBinder.Eval(Container.DataItem, "SettlementAmount", "{0:c}")%>
                                                    </td>
                                                    <td style="color:rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                        <%#DataBinder.Eval(Container.DataItem, "SettlementPercentage", "{0:#,##0.00}")%>%
                                                    </td>
                                                    <td style="color:rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                        <%#DataBinder.Eval(Container.DataItem, "Savings", "{0:c}")%>
                                                    </td>
                                                    <td style="color:rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                        <%#DataBinder.Eval(Container.DataItem, "SettlementCost", "{0:c}")%>
                                                    </td>
                                                    <td style="color:rgb(0,129,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                        <%#DataBinder.Eval(Container.DataItem, "FrozenAmount", "{0:c}")%>
                                                    </td>
                                                    <td style="padding-left:10;width:125;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                        <%#DataBinder.Eval(Container.DataItem, "Created", "{0:MMM d, yyyy h:mm tt}")%>
                                                    </td>
                                                </tr>
                                            </a>
                                        </itemtemplate>
                                    </asp:repeater>
                                </table><input type="hidden" runat="server" id="txtSelectedMediations"/><input type="hidden" runat="server" id="txtSelectedControlsClientIDs"/>
                                <asp:panel runat="server" id="pnlNoMediations" style="text-align:center;font-style:italic;padding: 10 5 5 5;">This client has no negotiations</asp:panel>
                                <img id="Img12" height="1" width="275" runat="server" src="~/images/spacer.gif" border="0" />
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkResetMatrix"></asp:LinkButton>

</asp:Content>