<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="TeamTasks.aspx.vb" Inherits="tasks_TeamTasks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

    <script language="javascript">
    
    function Sort(obj)
    {
        document.getElementById("<%=txtSortField.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    
    function AssignTask()
    {
        <%= ClientScript.GetPostBackEventReference(lnkUpdateTaskUsers, Nothing) %>;
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
              
    function RowHover(td, on)
    {
    
        if (on)
            td.parentElement.style.backgroundColor = "#f3f3f3";
        else
            td.parentElement.style.backgroundColor = "#ffffff";
    }
    </script>

    <asp:Panel runat="server" ID="pnlMenu">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false"
            border="0">
            <tr>
                <td>
                    <img id="Img1" runat="server" width="8" height="28" src="~/images/spacer.gif" />
                </td>
                <asp:PlaceHolder ID="pnlAddNewTask" runat="server">
                    <td nowrap="true">
                        <a id="A1" runat="server" style="display: none" class="menuButton" href="~/tasks/task/new.aspx">
                            <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_calendar_add.png" />Add New Task</a>
                    </td>
                    <td class="menuSeparator">
                        &nbsp;
                    </td>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="pnlTasksAnalysis" runat="server">
                    <td nowrap="true">
                        <a id="A2" runat="server" style="display: none" cdlass="menuButton" href="~/tasks/analysis">
                            <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_chart_bar.png" />Analysis</a>
                    </td>
                    <td style="width: 100%;">
                        &nbsp;
                    </td>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="pnlAssignTask" runat="server">
                    <td nowrap="true">
                        <a id="A5" runat="server" class="menuButton" href="javascript:AssignTask();">
                            <img id="Img7" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                                src="~/images/16x16_calendar_add.png" />Assign Task</a>
                        <asp:LinkButton ID="lnkUpdateTaskUsers" src="~/images/16x16_calendar_add.png" CssClass="lnk"
                            runat="server" Text="" Visible="false"></asp:LinkButton>
                    </td>
                    <td class="menuSeparator">
                        &nbsp;
                    </td>
                </asp:PlaceHolder>
                <td nowrap="true" align="right">
                    <a id="A4" class="menuButton" runat="server" href="~/tasks">
                        <img id="Img6" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_calendar.png" />Back to Calendar</a>
                </td>
                <td nowrap="true" id="tdSearch" runat="server">
                    <a id="A3" runat="server" class="menuButton" href="~/search.aspx">
                        <img id="Img4" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                            src="~/images/16x16_search.png" />Search</a>
                </td>
                <td>
                    <img id="Img5" runat="server" width="8" height="28" src="~/images/spacer.gif" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:Panel runat="server" ID="pnlBody">
        <table style="width: 100%;" cellpadding="0" cellspacing="15" border="0">
            <tr style="display:none">
                <td>
                    &nbsp;
                </td>
                <td align="right">
                    <asp:CheckBox AutoPostBack="true" runat="server" ID="chkTeamOpenOnly" Text=" Open Only"
                        Visible="false" /><asp:PlaceHolder ID="pnlSearchTeamTasks" runat="server">&nbsp;&nbsp;
                            &nbsp;&nbsp;<a id="A15" runat="server" href="~/search.aspx"><img id="Img71" runat="server"
                                src="~/images/16x16_find.png" visible="false" border="0" align="absmiddle" /></a></asp:PlaceHolder>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <div id="dvTeamTasks" runat="server">
                        <table onselectstart="return false;" style="table-layout: fixed; font-size: 11px;
                            font-family: tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td class="headItem" style="width: 25;" align="center">
                                    <img id="Img13" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThDueDate" class="headItem" style="width: 50">
                                    Due
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThClientAccNum" class="headItem" style="width: 50;">
                                    Client&nbsp;Acc&nbsp;#
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThClientName" class="headItem" style="width: 60;">
                                    Client
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThAccNum" class="headItem" style="width: 50;">
                                    Acc&nbsp;#
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThPrefLang" class="headItem" style="width: 50;">
                                    Language
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThTaskDesc" class="headItem" style="width: 130;">
                                    Task
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThCreatedBy" class="headItem" style="width: 90;">
                                    Created By
                                </td>
                                <td onclick="Sort(this)" runat="server" id="ThAssignedGroupName" class="headItem" style="width: 70;">
                                    Assigned&nbsp;To Group
                                </td>
                                <td class="headItem" style="width: 120;" id="tdAssignHeader" runat="server">
                                    Assigned To
                                </td>
                                <td class="headItem" onclick="Sort(this)" runat="server" id="ThStatus" style="width: 60;">
                                    Status
                                </td>
                            </tr>
                            <asp:Repeater ID="rpTeamTasks" runat="server">
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
                                            <%#CType(Container.DataItem, GridTask).AccountNumber%>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <a class="lnk" href="#" onclick="ClientClick(<%#CType(Container.DataItem, GridTask).ClientId%>);">
                                                <%#CType(Container.DataItem, GridTask).Client%>
                                            </a>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, GridTask).CIAccountNumber%>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" nowrap="true"
                                            onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, GridTask).Language%>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                            onmouseout="RowHover(this, false);" class="listItem">
                                            <%#CType(Container.DataItem, GridTask).TaskDescription%>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                            <%#CType(Container.DataItem, GridTask).CreatedBy%>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                            <%#CType(Container.DataItem, GridTask).AssignedToGroupName%>
                                        </td>
                                        <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem"
                                            nowrap="true" id="tdAssignItem" runat="server">
                                            <input type="hidden" id="hdnTaskID" runat="server" value='<%#CType(Container.DataItem, GridTask).TaskID%>' />
                                            <asp:DropDownList CssClass="entry" ID="ddlGroupUsers" Width="130px" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                        <td onclick="TaskClick(<%#CType(Container.DataItem, GridTask).TaskID%>);" onmouseover="RowHover(this, true);"
                                            onmouseout="RowHover(this, false);" class="listItem" nowrap="true">
                                            <%#CType(Container.DataItem, GridTask).Status%>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                    <asp:Panel runat="server" ID="pnlNoTeamTasks" Style="text-align: center; font-style: italic;
                        padding: 10 5 5 5;">
                        You have no tasks to assign</asp:Panel>
                    <input type="hidden" runat="server" id="hdnTeamTasksCount" />
                </td>
            </tr>
        </table>
        <input type="hidden" runat="server" id="txtSortField" />
        <asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
    </asp:Panel>
</asp:Content>
