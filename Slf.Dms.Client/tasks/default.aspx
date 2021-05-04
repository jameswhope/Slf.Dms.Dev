<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="tasks_default" title="DMP - Tasks" %>
<%@ Register TagPrefix="asi" Namespace="AssistedSolutions.WebControls" Assembly="AssistedSolutions.WebControls.DateRanger" %>

<asp:Content ID="cntMenu" ContentPlaceHolderID="cphMenu" runat="server"><asp:Panel runat="server" ID="pnlMenu">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td><img runat="server" width="8" height="28" src="~/images/spacer.gif" /></td>
            <asp:PlaceHolder id="pnlAddNewTask" runat="server"><td nowrap="true">
                <a runat="server" class="menuButton" href="~/tasks/task/new.aspx"><img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar_add.png" />Add New Task</a></td>
            <td class="menuSeparator">|</td></asp:PlaceHolder>
            <asp:PlaceHolder ID="pnlTasksAnalysis" runat="server">
            <td nowrap="true">
                <a runat="server" cdlass="menuButton" href="~/tasks/analysis"><img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_chart_bar.png" />Analysis</a></td>
            <td style="width: 100%;">&nbsp;</td>
            </asp:PlaceHolder>
            <asp:PlaceHolder id="pnlTeamTask" runat="server"><td nowrap="true">
                <a id="A1" runat="server" class="menuButton" href="~/tasks/teamtasks.aspx"><img id="Img1" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_calendar_add.png" />Team Tasks</a></td>
            <td class="menuSeparator">|</td></asp:PlaceHolder>
            <td nowrap="true" id="tdSearch" runat="server">
                <a runat="server" class="menuButton" href="~/search.aspx"><img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_search.png" />Search</a></td>
            <td><img runat="server" width="8" height="28" src="~/images/spacer.gif" /></td>
        </tr>
    </table>
</asp:Panel></asp:Content>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/dateranger.js") %>"></SCRIPT>
    <script type="text/javascript">


  function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }

    function ASI_TC_Task_OnDblClick(TaskID)
    {
        window.location.href = "<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID;
	    //window.navigate("<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);

	    //ASI_TC_StopEventPropogation();
    }
    function ASI_TC_Task_AddNew(Time)
    {
	    window.navigate("<%= ResolveUrl("~/tasks/task/new.aspx?dt=") %>" + Time);
    }
    function ASI_TC_StopEventPropogation(e)
    {
	    if (!e)
	    {
		    var e = window.event;
	    }

	    e.cancelBubble = true;

	    if (e.stopPropagation)
	    {
		    e.stopPropagation();
	    }
    }
    
    function RowHover(td, on)
    {
        if (on)
            td.parentElement.style.backgroundColor = "#f3f3f3";
        else
            td.parentElement.style.backgroundColor = "#ffffff";
    }
    function TaskClick(TaskID)
    {
        window.navigate("<%= ResolveUrl("~/tasks/task/resolve.aspx?id=") %>" + TaskID);
    }
  function ClientClick(ClientID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/?id=") %>" + ClientID);

        window.event.cancelBubble = true;

        return false;
    }
    </script>

    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td style="width:150;" valign="top" align="center">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td><asi:dateranger id="drMain" runat="server" Columns="1" Rows="2" NavigatorStyle="Image"
							NavigatorImageLeft="../images/arrow_left.png" NavigatorImageRight="../images/arrow_right.png" DayPadding="1" CalendarSpacing="0"
							CalendarTitleSpacing="1" CalendarTitlePadding="1" DayStyle="width:15px;background-color:white;color:black"
							DayHoverStyle="width:15px;background-color:rgb(252,238,182);color:#888888;" DaySelectedStyle="width:15px;background-color:rgb(251,230,148);color:black"
							DayHeaderStyle="font-family:tahoma;font-size:11px;background-color:white;color:#666666;padding:1 1 1 1;border-bottom:solid 1px #d3d3d3;"
							CalendarHeaderStyle="font-family:tahoma;font-size:11px;background-color:rgb(214,231,243);color:black;" CalendarHolderStyle="padding-bottom:10px;padding-left:15px;padding-right:15px"
							ControlStyle=" " AutoPostBack="True"></asi:dateranger></td>
                    </tr>
                    <tr><td></td></tr>
                </table>
            </td>
            <td style="background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-y;background-position:center top;"><img width="5" height="1" runat="server" src="~/images/spacer.gif"/></td>
            <td valign="top">
                <table style="width: 100%; height: 100%" cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td style="height: 25px">
                            <table style="background-color:#f1f1f1;height: 25px" cellspacing="2" cellpadding="1" width="100%" border="0">
                                <tr>
                                    <td nowrap="true" id="tdModeDay" runat="server">
                                        <asp:LinkButton ID="lnkModeDay" runat="server"><img runat="server" class="TCModeButtonImage" align="absmiddle" src="~/images/16x16_table2.png" border="0">Day Mode</asp:LinkButton></td>
                                    <td nowrap="true" id="tdModeWeek" runat="server">
                                        <asp:LinkButton ID="lnkModeWeek" runat="server"><img runat="server" class="TCModeButtonImage" align="absmiddle" src="~/images/16x16_table2.png" border="0">Week Mode</asp:LinkButton></td>
                                    <td nowrap="true" id="tdModeMonth" runat="server">
                                        <asp:LinkButton ID="lnkModeMonth" runat="server"><img runat="server" class="TCModeButtonImage" align="absmiddle" src="~/images/16x16_table2.png" border="0">Month Mode</asp:LinkButton></td>
                                    <td nowrap="true" id="tdTaskList" runat="server">
                                        <asp:LinkButton ID="lnkTaskList" runat="server"><img runat="server" class="TCModeButtonImage" align="absmiddle" src="~/images/16x16_table2.png" border="0">Task List</asp:LinkButton></td>
                                    <td class="TCModebuttonHolder" style="width:100%;font-size: 11px; color: #a1a1a1; font-family: tahoma" align="right">Double-Click A Cell To Add&nbsp;&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <asp:Panel ID="pnlCalendar" runat="server" Height="100%"></asp:Panel>
                            
                            <asp:PlaceHolder ID="phTasks" runat="server">
                                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                                            <tr>
                                                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                                        cellspacing="0" border="0">
                                                        <tr>
                                                             <td style="padding:5 7 5 7;color:rgb(50,112,163);">Task List</td>
                                                            <td align="right">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <div id="dvUpcomingTasks" runat="server">
                                                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                                                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                            <tr>
                                                                <td class="headItem" style="width: 25;" align="center">
                                                                    <img id="Img17" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" /></td>
                                                                <td onclick="Sort(this)" runat="server" id="td1"  class="headItem" style="width: 75">
                                                                    Due<%--<img id="Img18" style="margin-left: 5px;" runat="server" src="~/images/sort-desc.png"
                                                                        border="0" align="absmiddle" />--%></td>
                                                                <td onclick="Sort(this)" runat="server" id="td2" class="headItem" style="width: 95;">
                                                                    Client</td>
                                                                <td onclick="Sort(this)" runat="server" id="td3" class="headItem" style="width: 250;">
                                                                    Task</td>
                                                                <td  runat="server" id="td4" class="headItem" style="width: 75">
                                                                    Status</td>
                                                                <td onclick="Sort(this)" runat="server" id="td5" class="headItem">
                                                                    Created Date</td>    
                                                                <td onclick="Sort(this)" runat="server" id="td6" class="headItem">
                                                                    Resolved Date</td>    
                                                            </tr>
                                                            <asp:Repeater ID="rpUpcomingTasks" runat="server">
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <img id="Img19" runat="server" src="~/images/16x16_calendar.png" border="0" />
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).DueDate.ToString("MMM d, yy")%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                                            <a class="lnk" href="#" onclick="ClientClick(<%#CType(Container.DataItem, GridTask).ClientId%>);">
                                                                                <%#CType(Container.DataItem, GridTask).Client%>
                                                                            </a>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem">
                                                                            <%#CType(Container.DataItem, GridTask).TaskDescription%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                                                            <%#CType(Container.DataItem, GridTask).Status%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">&nbsp;
                                                                            <%#CType(Container.DataItem, GridTask).StartDate.ToString()%>
                                                                        </td>
                                                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">&nbsp;
                                                                            <%#CType(Container.DataItem, GridTask).ResolvedDate.ToString()%>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </table>
                                                    </div>
                                                    <asp:Panel runat="server" ID="pnlNoUpcomingTasks" Style="text-align: center; font-style: italic;
                                                        padding: 10 5 5 5;">
                                                        You have no upcoming tasks</asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:PlaceHolder>
                                    
                                      <input type="hidden" runat="server" id="txtSortField" />    <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr><td style="height:30;"><img width="1" height="30" runat="server" src="~/images/spacer.gif"/></td></tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Panel></asp:Content>