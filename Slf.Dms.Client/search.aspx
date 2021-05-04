<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="search.aspx.vb" Inherits="search" title="DMP - Search" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Import Namespace="Drg.Util.DataHelpers" %>

<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" Runat="Server"><asp:Panel ID="pnlMenu" runat="server">

    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
                <td nowrap="true">
                    <a class="menuButton" href="~/" runat="server">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_web_home.png" />Home Page</a></td>
                <td class="menuSeparator">|</td>
                <asp:PlaceHolder ID="pnlEnrollNewClient" runat="server">
                <td nowrap="true">
                    <a class="menuButton" href="~/clients/new" runat="server">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_person.png" />Screen New Client</a></td>
                </asp:PlaceHolder>
                <!--<td class="menuSeparator">|</td>
                <td nowrap="true">
                    <a class="menuButton" runat="server" href="~/tasks/task/new.aspx">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar_add.png" />Add New Task</a></td>-->
                <td style="width:100%;">&nbsp;</td>
                <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            </tr>
        </table>
    </asp:Panel>

</asp:Panel></asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel id="pnlBody" runat="server">

<body onload="SetFocus('<%= txtSearch.ClientID %>');">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
<script type="text/javascript">

var SearchPanes = new Array();

function RowHover(td, on)
{
    if (on)
	    td.parentElement.style.backgroundColor = "#f5f5f5";
    else
	    td.parentElement.style.backgroundColor = "";
}
function TaskClick(TaskID)
{
    window.navigate("<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);
}
function ClientHover(td, on)
{
    if (on)
	    td.parentElement.style.backgroundColor = "#f5f5f5";
    else
	    td.parentElement.style.backgroundColor = "";
}
function ClientClick(ClientID)
{
    window.navigate("<%= ResolveUrl("~/clients/client/?id=") %>" + ClientID);

    window.event.cancelBubble = true;

    return false;
}
function NoteHover(td, on)
{
    if (on)
	    td.parentElement.style.backgroundColor = "rgb(255,255,210)";
    else
	    td.parentElement.style.backgroundColor = "rgb(255,255,234)";
}
function NoteClick(NoteID)
{
    window.navigate("<%= ResolveUrl("~/clients/client/?id=") %>" + NoteID);

    window.event.cancelBubble = true;

    return false;
}
</script>

    <asp:Panel runat="server" ID="pnlBodyDefault">
        <table style="font-family:tahoma;font-size:11px;width: 100%; height: 100%;" cellpadding="0" cellspacing="20" border="0">
            <tr>
                <td valign="top" style="width:75%;">
                    <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0" border="0">
                        <tr>
                            <td><a runat="server" id="lnkSimple">Simple Search</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" id="lnkAdvanced">Advanced Search</a></td>
                        </tr>
                        <tr>
                            <td>
                                <table style="font-family:tahoma;font-size:11px;width:350;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><asp:TextBox runat="server" ID="txtSearch" CssClass="entry"></asp:TextBox></td>
                                        <td style="padding-left:5;width:16;"><asp:linkbutton runat="server" ID="lnkSearch"><img id="Img4" src="~/images/16x16_arrowright_clear.png" runat="server" align="absmiddle" border="0" /></asp:linkbutton></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 5 10 5;color:#a1a1a1;font-style:italic;"><br /></td>
                        </tr>
                        <tr>
                            <td style="padding:0 0 15 0;"><asi:tabstrip runat="server" id="tsSearch"></asi:tabstrip></td>
                        </tr>
                    </table>
                    <div id="dvSearch0" runat="server" style="padding-top:10;">
                        <asp:panel runat="server" id="pnlSearchClients">
                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
	                            <tr>
		                            <td class="headItem3" style="width:16;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
		                            <td class="headItem3">Account</td>
		                            <td class="headItem3">Name<img style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td>
		                            <td class="headItem3">SSN</td>
		                            <td class="headItem3">Addresses</td>
		                            <td class="headItem3" align="right">Contact Number</td>
	                            </tr>
	                            <asp:repeater id="rpSearchClients" runat="server">
		                            <itemtemplate>
			                            <tr>
			                                <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center"><img runat="server" src="~/images/16x16_person.png" border="0"/></td>
			                                <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
			                                    <%#DataBinder.Eval(Container.DataItem, "AccountNumberDisplay")%>&nbsp;
			                                </td>
			                                <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
			                                    <%#DataBinder.Eval(Container.DataItem, "NameDisplay")%>
			                                </td>
			                                <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
			                                    <%#DataBinder.Eval(Container.DataItem, "SSNDisplay")%>&nbsp;
			                                </td>
			                                <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
			                                    <%#DataBinder.Eval(Container.DataItem, "AddressDisplay")%>&nbsp;
			                                </td>
				                            <td style="padding-top:6;" onclick="ClientClick(<%#DataBinder.Eval(Container.DataItem, "ClientID")%>);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true" valign="top" align="right">
				                                <%#DataBinder.Eval(Container.DataItem, "ContactNumberDisplay")%>
				                            </td>
			                            </tr>
		                            </itemtemplate>
	                            </asp:repeater>
                            </table>
                            <br />
                            <asp:LinkButton ID="lnkSearchFirstClients" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_first2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchPrevClients" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png" border="0"/></asp:LinkButton>
                            &nbsp;<asp:Label ID="labSearchClientsLocation" runat="server"></asp:Label>&nbsp;
                            <asp:LinkButton ID="lnkSearchNextClients" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_next2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchLastClients" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_last2.png" border="0"/></asp:LinkButton>
                        </asp:panel>
                        <asp:panel runat="server" id="pnlNoSearchClients" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">No clients were found for those search terms</asp:panel>
                    </div>
                    <div id="dvSearch1" runat="server" style="padding-top:10;">
                        <asp:panel runat="server" id="pnlSearchNotes">
                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
	                            <tr>
		                            <td class="headItem3" style="width:16;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
		                            <td class="headItem3" style="width:65;">Date<img style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png" border="0" align="absmiddle"/></td>
		                            <td class="headItem3">Associations</td>
		                            <td class="headItem3">Body</td>
	                            </tr>
	                            <asp:repeater id="rpSearchNotes" runat="server">
		                            <itemtemplate>
								        <a href="<%# ResolveUrl("~/clients/client/communication/note.aspx?id=") + DataBinder.Eval(Container.DataItem, "ClientId").ToString() + "&nid=" + DataBinder.Eval(Container.DataItem, "NoteID").ToString()  %>">
			                            <tr>
			                                <td style="padding-top:6;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" align="center"><img runat="server" src="~/images/16x16_note.png" border="0"/></td>
			                                <td style="padding-top:6;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
			                                    <%#DataBinder.Eval(Container.DataItem, "Created", "{0:MM/dd/yyyy}")%>
			                                </td>
			                                <td style="padding-top:6;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top" nowrap="true">
			                                    <%#DataBinder.Eval(Container.DataItem, "CreatedByName")%>&nbsp;
			                                </td>
				                            <td style="padding-top:6;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" valign="top">
				                                <%#NoteHelper.TruncateMessage(DataBinder.Eval(Container.DataItem, "Value"))%>
				                            </td>
			                            </tr>
			                            </a>
		                            </itemtemplate>
	                            </asp:repeater>
                            </table>
                            <br />
                            <asp:LinkButton ID="lnkSearchFirstNotes" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_first2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchPrevNotes" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png" border="0"/></asp:LinkButton>
                            &nbsp;<asp:Label ID="labSearchNotesLocation" runat="server"></asp:Label>&nbsp;
                            <asp:LinkButton ID="lnkSearchNextNotes" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_next2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchLastNotes" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_last2.png" border="0"/></asp:LinkButton>
                        </asp:panel>
                        <asp:panel runat="server" id="pnlNoSearchNotes" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">No notes were found for those search terms</asp:panel>
                    </div>
                    <div id="dvSearch2" runat="server" style="padding-top:10;">
                        <asp:panel runat="server" id="pnlSearchCalls">
                            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
	                            <tr>
		                            <td class="headItem3" style="width:16;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
		                            <td class="headItem3" style="width:55;">Date</td>
		                            <td class="headItem3" style="width:40;" align="center">DIR</td>
		                            <td class="headItem3">Person</td>
		                            <td class="headItem3">Duration</td>
		                            <td class="headItem3">Subject</td>
	                            </tr>
	                            <asp:repeater id="rpSearchCalls" runat="server">
		                            <itemtemplate>
								        <a href="<%# ResolveUrl("~/clients/client/communication/phonecall.aspx?id=") + DataBinder.Eval(Container.DataItem, "ClientId").ToString() + "&pcid=" + DataBinder.Eval(Container.DataItem, "PhoneCallID").ToString()  %>">
			                            <tr>
			                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="center"><img runat="server" src="~/images/16x16_phone2.png" border="0"/></td>
			                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
			                                    <%#DataBinder.Eval(Container.DataItem, "StartTime", "{0:M/d/yyyy}")%>&nbsp;
			                                </td>
			                                <td align="center" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
			                                    <%#DataBinder.Eval(Container.DataItem, "DirectionFormatted")%>
			                                </td>
			                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
			                                    <%#DataBinder.Eval(Container.DataItem, "PersonName")%>
			                                </td>
			                                <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
			                                    <%#DataBinder.Eval(Container.DataItem, "DurationFormatted")%>&nbsp;
			                                </td>
				                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
				                                <%#DataBinder.Eval(Container.DataItem, "Subject")%>
				                            </td>
			                            </tr>
			                            </a>
		                            </itemtemplate>
	                            </asp:repeater>
                            </table>
                            <br />
                            <asp:LinkButton ID="lnkSearchFirstCalls" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_first2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchPrevCalls" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_previous2.png" border="0"/></asp:LinkButton>
                            &nbsp;<asp:Label ID="labSearchCallsLocation" runat="server"></asp:Label>&nbsp;
                            <asp:LinkButton ID="lnkSearchNextCalls" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_next2.png" border="0"/></asp:LinkButton>&nbsp;
                            <asp:LinkButton ID="lnkSearchLastCalls" runat="server" class="lnk"><img align="absmiddle" runat="server" src="~/images/16x16_results_last2.png" border="0"/></asp:LinkButton>
                        </asp:panel>
                        <asp:panel runat="server" id="pnlNoSearchCalls" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">No notes were found for those search terms</asp:panel>
                    </div>
                    <div id="dvSearch3" runat="server" style="padding-top:10;"></div>
                    <div id="dvSearch4" runat="server" style="padding-top:10;"></div>
                    <div id="dvSearch5" runat="server" style="padding-top:10;"></div>
                </td>
                <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-y;background-position:center top;"><img width="3" height="1" runat="server" src="~/images/spacer.gif" /></td>
                <td valign="top" style="width:20%;">
                    <table style="width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClear"></asp:LinkButton>

</body>

</asp:Panel></asp:Content>