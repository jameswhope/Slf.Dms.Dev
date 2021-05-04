<%@ Page Language="VB" MasterPageFile="~/admin/users/user/user.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_user_history_default" title="DMP - Admin - User History" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
<script type="text/javascript">

var lnkDeleteConfirmVisits = null;
var txtSelectedVisits = null;
var lnkDeleteConfirmSearches = null;
var txtSelectedSearches = null;

var idsVisits = new Array();
var idsSearches = new Array();

function RowHover(td, on)
{
    if (on)
	    td.parentElement.style.backgroundColor = "#f3f3f3";
    else
	    td.parentElement.style.backgroundColor = "#ffffff";
}
function AddOrDropVisits(obj, id)
{
    if (obj.checked)
    {
	    AddString(id, idsVisits);
    }
    else
    {
	    RemoveString(id, idsVisits);
    }

    UpdateSelectedVisits();
}
function AddOrDropSearches(obj, id)
{
    if (obj.checked)
    {
	    AddString(id, idsSearches);
    }
    else
    {
	    RemoveString(id, idsSearches);
    }

    UpdateSelectedSearches();
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
function UpdateSelectedVisits()
{
    LoadControls();

    txtSelectedVisits.value = idsVisits.join(",");

    if (txtSelectedVisits.value.length > 0)
    {
        lnkDeleteConfirmVisits.disabled = false;
    }
    else
    {
        lnkDeleteConfirmVisits.disabled = true;
    }
}
function UpdateSelectedSearches()
{
    LoadControls();

    txtSelectedSearches.value = idsSearches.join(",");

    if (txtSelectedSearches.value.length > 0)
    {
        lnkDeleteConfirmSearches.disabled = false;
    }
    else
    {
        lnkDeleteConfirmSearches.disabled = true;
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
function ClearArrays()
{
    idsVisits = null;
    idsVisits = new Array();

    idsSearches = null;
    idsSearches = new Array();
}
function CheckAll(obj)
{
    ClearArrays();

    var table = obj.parentNode.parentNode.parentNode.parentNode;

    for (c = 1; c < table.rows.length; c++)
    {
	    var off = table.rows[c].cells[0].childNodes(0);
	    var on = table.rows[c].cells[0].childNodes(1);
	    var chk = table.rows[c].cells[0].childNodes(2);

	    off.style.display = "none";
	    on.style.display = "inline";
	    chk.checked = true;
    }
}
function UncheckAll(obj)
{
    var table = obj.parentNode.parentNode.parentNode.parentNode;

    for (u = 1; u < table.rows.length; u++)
    {
	    var off = table.rows[u].cells[0].childNodes(0);
	    var on = table.rows[u].cells[0].childNodes(1);
	    var chk = table.rows[u].cells[0].childNodes(2);

	    on.style.display = "none";
	    off.style.display = "inline";
	    chk.checked = false;
    }
}
function LoadControls()
{
    if (lnkDeleteConfirmVisits == null)
    {
        lnkDeleteConfirmVisits = document.getElementById("<%= lnkDeleteConfirmVisits.ClientID %>");
        txtSelectedVisits = document.getElementById("<%= txtSelectedVisits.ClientID %>");
        lnkDeleteConfirmSearches = document.getElementById("<%= lnkDeleteConfirmSearches.ClientID %>");
        txtSelectedSearches = document.getElementById("<%= txtSelectedSearches.ClientID %>");
    }
}
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
function Record_DeleteConfirmVisits()
{
    LoadControls();

    if (!lnkDeleteConfirmVisits.disabled)
    {
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteVisits&t=Delete Visits&m=Are you sure you want to delete this selection of visits?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Visits",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 300, width: 400, scrollable: false}); 
    }
}
function Record_DeleteVisits()
{
    // postback to delete visits
    <%= ClientScript.GetPostBackEventReference(lnkDeleteVisits, Nothing) %>;
}
function Record_DeleteConfirmSearches()
{
    LoadControls();

    if (!lnkDeleteConfirmSearches.disabled)
    {
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_DeleteSearches&t=Delete Searches&m=Are you sure you want to delete this selection of searches?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Searches",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 300, width: 400, scrollable: false});
    }
}
function Record_DeleteSearches()
{
    // postback to delete searches
    <%= ClientScript.GetPostBackEventReference(lnkDeleteSearches, Nothing) %>;
}
function Record_DeleteConfirm()
{
    window.dialogArguments = window;
    var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Clear All History&m=Are you sure you want to clear this users history?';
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Clear All History",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 300, width: 400, scrollable: false});
}
function Record_Delete()
{
    // postback to delete
    <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
}
function Record_ClearVisitsConfirm()
{
    window.dialogArguments = window;
    var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_ClearVisits&t=Clear All Visits&m=Are you sure you want to clear all visits for this user?';
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Clear All Visits",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 300, width: 400, scrollable: false});
}
function Record_ClearVisits()
{
    // postback to clear visits
    <%= ClientScript.GetPostBackEventReference(lnkClearVisits, Nothing) %>;
}
function Record_ClearSearchesConfirm()
{
    window.dialogArguments = window;
    var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_ClearSearches&t=Clear All Searches&m=Are you sure you want to clear all searches for this user?';
    currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Clear All Searches",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 300, width: 400, scrollable: false});
}
function Record_ClearSearches()
{
    // postback to clear searches
    <%= ClientScript.GetPostBackEventReference(lnkClearSearches, Nothing) %>;
}

</script>

<table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="15" cellpadding="0" border="0">
    <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">Users</a>&nbsp;>&nbsp;<a id="lnkUser" runat="server" style="color: #666666;" class="lnk"></a>&nbsp;>&nbsp;History</td></tr>
    <tr><td><asi:tabstrip runat="server" id="tsHistory"></asi:tabstrip></td></tr>
    <tr>
        <td>
            <div id="dvHistory0" runat="server" style="padding-top:10;">
                <asp:panel runat="server" id="pnlVisits">
                    <table style="background-color:#f1f1f1;font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                        <tr>
                            <td style="color:rgb(50,112,163);">All Visits</td>
                            <td align="right"><a class="lnk" id="lnkDeleteConfirmVisits" disabled="true" runat="server" href="javascript:Record_DeleteConfirmVisits();">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="lnk" id="lnkClearVisitsConfirm" runat="server" href="javascript:Record_ClearVisitsConfirm();">Clear Visits</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width:20;" class="headItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                            <td class="headItem" style="width:16;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                            <td class="headItem">Type</td>
                            <td class="headItem">Display</td>
                            <td class="headItem" style="width:125;">Visited<img style="margin-left:5;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td>
                        </tr>
                        <asp:repeater id="rpVisits" runat="server">
                            <itemtemplate>
                                <a href="<%= ResolveUrl("~/admin/users/user/history/visit.aspx?id=") %><%#DataBinder.Eval(Container.DataItem, "UserID")%>&uvid=<%#DataBinder.Eval(Container.DataItem, "UserVisitID")%>">
                                    <tr>
		                                <td style="width:20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"><img id="Img7" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img8" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="AddOrDropVisits(this, <%#DataBinder.Eval(Container.DataItem, "UserVisitID")%>);" style="display:none;" type="checkbox" /></td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center"><img src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconLarge")%>" border="0"/></td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Type")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Display")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Visit", "{0:MM/dd/yyyy hh:mm tt}")%>
                                        </td>
                                    </tr>
                                </a>
                            </itemtemplate>
                        </asp:repeater>
                    </table>
                    <br />
                    <asp:LinkButton ID="lnkFirstVisit" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_first2.png" border="0"/></asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="lnkPrevVisit" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png" border="0"/></asp:LinkButton>
                    &nbsp;<asp:Label ID="labLocationVisits" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="lnkNextVisit" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_next2.png" border="0"/></asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="lnkLastVisit" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_last2.png" border="0"/></asp:LinkButton>
                </asp:panel>
                <asp:panel runat="server" id="pnlNoVisits" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">This user has no visits</asp:panel>
                <input type="hidden" runat="server" id="txtSelectedVisits"/>
            </div>
            <div id="dvHistory1" runat="server" style="padding-top:10;">
                <asp:panel runat="server" id="pnlSearches">
                    <table style="background-color:#f1f1f1;font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                        <tr>
                            <td style="color:rgb(50,112,163);">All Searches</td>
                            <td align="right"><a class="lnk" id="lnkDeleteConfirmSearches" disabled="true" runat="server" href="javascript:Record_DeleteConfirmSearches();">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="lnk" id="lnkClearSearchesConfirm" runat="server" href="javascript:Record_ClearSearchesConfirm();">Clear Searches</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td align="center" style="width:20;" class="headItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img3" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                            <td class="headItem" style="width:16;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                            <td class="headItem" style="width:125;">Searched<img style="margin-left:5;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td>
                            <td class="headItem">Terms</td>
                            <td class="headItem" align="center">Total</td>
                            <td class="headItem" align="center">Clients</td>
                            <td class="headItem" align="center">Notes</td>
                            <td class="headItem" align="center">Calls</td>
                            <td class="headItem" align="center">Tasks</td>
                            <td class="headItem" align="center">Email</td>
                            <td class="headItem" align="center">Personnel</td>
                        </tr>
                        <asp:repeater id="rpSearches" runat="server">
                            <itemtemplate>
                                <a href="<%= ResolveUrl("~/admin/users/user/history/search.aspx?id=") %><%#DataBinder.Eval(Container.DataItem, "UserID")%>&usid=<%#DataBinder.Eval(Container.DataItem, "UserSearchID")%>">
                                    <tr>
		                                <td style="width:20;" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img9" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="AddOrDropSearches(this, <%#DataBinder.Eval(Container.DataItem, "UserSearchID")%>);" style="display:none;" type="checkbox" /></td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center"><img runat="server" src="~/images/16x16_search.png" border="0"/></td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Search", "{0:MM/dd/yyyy hh:mm tt}")%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Terms")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "Results")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsClients")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsNotes")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsCalls")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsTasks")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsEmail")%>
                                        </td>
                                        <td style="color:rgb(0,129,0)" align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#DataBinder.Eval(Container.DataItem, "ResultsPersonnel")%>
                                        </td>
                                    </tr>
                                </a>
                            </itemtemplate>
                        </asp:repeater>
                    </table>
                    <br />
                    <asp:LinkButton ID="lnkFirstSearch" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_first2.png" border="0"/></asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="lnkPrevSearch" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png" border="0"/></asp:LinkButton>
                    &nbsp;<asp:Label ID="labLocationSearches" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="lnkNextSearch" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_next2.png" border="0"/></asp:LinkButton>&nbsp;
                    <asp:LinkButton ID="lnkLastSearch" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_last2.png" border="0"/></asp:LinkButton>
                </asp:panel>
                <asp:panel runat="server" id="pnlNoSearches" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">This user has no searches</asp:panel>
                <input type="hidden" runat="server" id="txtSelectedSearches"/>
            </div>
        </td>
    </tr>
</table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDeleteVisits"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClearVisits"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDeleteSearches"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClearSearches"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>