<%@ Page Language="VB" MasterPageFile="~/research/negotiation/negotiation.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="project_assignment_Default" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <link href="CriteriaAssignment.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" language="javascript">
        var entityHandler = new Array();
        var timer;
        
        document.body.onload = function()
        {
            document.getElementById('<%=uppLoadingProgress.ClientID %>').style.display = 'block';
            AssignBy('<%=GroupBy %>', true);
        }
        
        function UnassignAll()
        {
            var pm = Sys.WebForms.PageRequestManager.getInstance();
            pm.add_endRequest(EndRequestHandler);
            pm.add_beginRequest(BeginRequestHandler);
            
            <%=Page.ClientScript.GetPostBackEventReference(lnkUnassignAll, Nothing) %>;
        }
        
        function DistributeEvenly()
        {
            var pm = Sys.WebForms.PageRequestManager.getInstance();
            pm.add_endRequest(EndRequestHandler);
            pm.add_beginRequest(BeginRequestHandler);
            
            var ids = new Array();
            
            for (var i = 0; i < entityHandler.length; i++)
            {
                if (entityHandler[i]._entityID == 'unassigned')
                {
                    for (var j = 0; j < entityHandler[i]._items.length; j++)
                    {
                        if (entityHandler[i]._items[j]._checkBox.checked)
                        {
                            ids[ids.length] = entityHandler[i]._items[j]._parentID;
                        }
                    }
                }
            }
            
            if (ids.length > 0)
            {
                document.getElementById('<%=hdnDistributeFilterID.ClientID %>').value = ids.join(',');
                
                SaveCriteria();
                
                <%=Page.ClientScript.GetPostBackEventReference(lnkDistributeEvenly, Nothing) %>;
            }
        }
        
        function AssignByEntity(entityID)
        {
            AssignBy(document.getElementById('<%=hdnAssignBy.ClientID %>').value, true, entityID);
        }
        
        function AssignBy(type, canGroup, entityID)
        {
            if (entityID)
            {
                document.getElementById('<%=hdnEntityID.ClientID %>').value = entityID;
            }
            
            if (canGroup)
            {
                document.getElementById('<%=hdnAssignBy.ClientID %>').value = type;
                
                var pm = Sys.WebForms.PageRequestManager.getInstance();
                pm.add_endRequest(EndRequestHandler);
                pm.add_beginRequest(BeginRequestHandler);
                
                SaveCriteria();
                
                <%=ClientScript.GetPostBackEventReference(lnkAssignBy, Nothing) %>;
            }
        }
        
        function EndRequestHandler(sender, args)
        {
            Sys.WebForms.PageRequestManager.getInstance().remove_endRequest(EndRequestHandler);
            
            var as = document.getElementById('dvAssignScroll');
            
            var asu = new Custom.UI.ScrollButton(document.getElementById('dvAssignScrollUp'), as, 'up');
            var asd = new Custom.UI.ScrollButton(document.getElementById('dvAssignScrollDown'), as, 'down');
            
            var us = document.getElementById('dvUnassignScroll');
            
            var usu = new Custom.UI.ScrollButton(document.getElementById('dvUnassignScrollUp'), us, 'up');
            var usd = new Custom.UI.ScrollButton(document.getElementById('dvUnassignScrollDown'), us, 'down');
            
            Resize();
            
            entityHandler = new Array();
            
            LoadInterface(entityHandler);
            
            SetupHeaders();
        }
        
        function SetupHeaders()
        {
            var temp = document.getElementById('dvAssignHeaders').children[0];
            
            if (temp)
            {
                temp.parentElement.removeChild(temp);
            }
            
            var tbl = document.getElementById('tblAssignments');
            var header = tbl.cloneNode(true);
            header.className = 'ListTableHide';
            
            var thead = document.createElement('thead');
            
            for (var i = 0; i < header.children[0].children.length; i++)
            {
                thead.appendChild(header.children[0].children[i].cloneNode(true));
            }
            
            header.removeChild(header.children[0]);
            header.appendChild(thead);
            
            var dv = document.getElementById('dvAssignHeaders');
            dv.appendChild(header);
            dv.style.height = thead.offsetHeight;
            
            var temp2 = document.getElementById('dvUnassignHeaders').children[0];
            
            if (temp2)
            {
                temp2.parentElement.removeChild(temp2);
            }
            
            var tbl2 = document.getElementById('tblUnassigned');
            var header2 = tbl2.cloneNode(true);
            header2.className = 'ListTableHide';
            
            var thead2 = document.createElement('thead');
            
            for (var i = 0; i < header2.children[0].children.length; i++)
            {
                thead2.appendChild(header2.children[0].children[i].cloneNode(true));
            }
            
            header2.removeChild(header2.children[0]);
            header2.appendChild(thead2);
            
            var dv2 = document.getElementById('dvUnassignHeaders');
            dv2.appendChild(header2);
            dv2.style.height = thead2.offsetHeight;
            
            if (thead.offsetHeight > thead2.offsetHeight)
            {
                dv2.style.height = dv.style.height;
            }
            else
            {
                dv.style.height = dv2.style.height;
            }
        }
        
        function SaveCriteria()
        {
            var saveStr = new Array();
            var tempArr;
            
            for (var i = 0; i < entityHandler.length; i++)
            {
                for (var j = 0; j < entityHandler[i]._items.length; j++)
                {
                    tempArr = new Array();
                    
                    for (var k = 0; k < entityHandler[i]._items[j]._items.length; k++)
                    {
                        tempArr[tempArr.length] = entityHandler[i]._items[j]._items[k].sqlStr;
                    }
                    
                    saveStr[saveStr.length] = entityHandler[i]._entityID + '|' + entityHandler[i]._items[j]._parentID + '|' + entityHandler[i]._items[j]._groupBy + '|' + tempArr.join('|');
                }
            }
            
            document.getElementById('<%=hdnSaveCriteria.ClientID %>').value = saveStr.join(';');
        }
        
        function Save()
        {
            SaveCriteria();
            
            <%=ClientScript.GetPostBackEventReference(lnkSaveCriteria, Nothing) %>;
        }
        
        function BeginRequestHandler(sender, args)
        {
            if (args.get_postBackElement().id && args.get_postBackElement().id != '<%=lnkSaveCriteria.ClientID %>' && args.get_postBackElement().id != '<%=lnkAssignBy.ClientID %>' && args.get_postBackElement().id != '<%=lnkDistributeEvenly.ClientID %>' && args.get_postBackElement().id != '<%=lnkUnassignAll.ClientID %>')
            {
                Save();
            }
        }
        
        document.body.onunload = function()
        {
            Save();
        }
        
        window.onresize = function(ev)
        {
            clearTimeout(timer);
            timer = setTimeout(Resize, 100);
        }
        
        function Resize()
        {
            var as = document.getElementById('dvAssignScroll');
            
            if (as)
            {
                as.style.height = document.body.clientHeight - 324;
            }
            
            var us = document.getElementById('dvUnassignScroll');
            
            if (us)
            {
                us.style.height = document.body.clientHeight - 324;
            }
        }
    </script>
    
    <asp:ScriptManagerProxy ID="smrScriptManager"  runat="server">
        <Scripts>
            <asp:ScriptReference Assembly="Microsoft.Web.Preview" Name="PreviewScript.js" />
            <asp:ScriptReference Assembly="Microsoft.Web.Preview" Name="PreviewDragDrop.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/Criteria.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ListCriteriaContainer.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ListCriteriaContainerDrop.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ListCriteriaItem.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ListEntityContainer.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ListUnassignedContainer.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/ScrollButton.js" />
            <asp:ScriptReference path="~/research/negotiation/assignment/Utilities.js" />
        </Scripts>
    </asp:ScriptManagerProxy>
    <table>
        <tbody>
            <tr>
                <td style="vertical-align:baseline;font-weight:bold;">
                    Group By:
                </td>
                <td>
                    <asp:Panel ID="pnlGroups" runat="server" />
                </td>
                <td style="width:5px;">
                    &nbsp;
                </td>
                <td style="vertical-align:baseline;">
                    <a href="javascript:DistributeEvenly();" class="lnk">Distribute Evenly</a>
                </td>
                <td style="width:5px;">
                    &nbsp;
                </td>
                <td style="vertical-align:baseline;">
                    <a href="javascript:UnassignAll();" class="lnk" style="visibility:hidden;">Unassign All</a>
                </td>
            </tr>
        </tbody>
    </table>
    <asp:UpdatePanel ID="udpSavePanel" UpdateMode="Conditional" runat="server">
        <ContentTemplate>
            <asp:LinkButton ID="lnkSaveCriteria" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkSaveCriteria" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="udpMainPanel" UpdateMode="Conditional" runat="server">
        <ContentTemplate>
            <table style="width:850px;" cols="2">
                <tbody>
                    <tr>
                        <td style="vertical-align:top;">
                            <div id="dvAssignScrollUp" class="ScrollButton" style="width:400px;background-image:url('<%=ResolveUrl("~/images/ScrollButtonUp.gif") %>');">
                                &nbsp;
                            </div>
                            <div id="dvAssignHeaders" class="HeaderDiv"></div>
                            <div style="height:3px;">&nbsp;</div>
                            <asp:Panel ID="pnlTrail" style="height:12px;overflow:hidden;" runat="server" />
                            <div id="dvAssignScroll" style="height:10px;" class="Scrollable">
                                <table id="tblAssignments" class="ListTable" cellpadding="2px" cellspacing="0px">
                                    <tfoot>
                                        <tr class="menuTable">
                                            <td class="ListTitle" colspan="<%=GlobalHeaders.Count + 1 %>">
                                                Assignments
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ListHeaderFirst">
                                                <asp:Label ID="lblAssignHeaderEntity" runat="server" />
                                            </td>
                                            <asp:Repeater ID="rptAssignHeaders" runat="server">
                                                <ItemTemplate>
                                                    <td class="ListHeader">
                                                        <%#CType(Container.DataItem, NegotiationHeader).Name %>
                                                    </td>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div id="dvAssignScrollDown" class="ScrollButton" style="width:400px;background-image:url('<%=ResolveUrl("~/images/ScrollButtonDown.gif") %>');">
                                &nbsp;
                            </div>
                        </td>
                        <td style="vertical-align:top;">
                            <div id="dvUnassignScrollUp" class="ScrollButton" style="width:400px;background-image:url('<%=ResolveUrl("~/images/ScrollButtonUp.gif") %>');">
                                &nbsp;
                            </div>
                            <div id="dvUnassignHeaders" class="HeaderDiv"></div>
                            <div style="height:25px;">&nbsp;</div>
                            <div id="dvUnassignScroll" style="height:10px;" class="Scrollable">
                                <table id="tblUnassigned" class="ListTable" cellpadding="2px" cellspacing="0px">
                                    <tfoot>
                                        <tr class="menuTable">
                                            <td class="ListTitle" colspan="<%=GlobalHeaders.Count + 1 %>">
                                                Unassigned
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ListHeaderFirst">
                                                <asp:Label ID="lblUnassignHeaderEntity" runat="server" />
                                            </td>
                                            <asp:Repeater ID="rptUnassignHeaders" runat="server">
                                                <ItemTemplate>
                                                    <td class="ListHeader">
                                                        <%#CType(Container.DataItem, NegotiationHeader).Name %>
                                                    </td>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div id="dvUnassignScrollDown" class="ScrollButton" style="width:400px;background-image:url('<%=ResolveUrl("~/images/ScrollButtonDown.gif") %>');">
                                &nbsp;
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <asp:LinkButton ID="lnkAssignBy" runat="server" />
            <asp:LinkButton ID="lnkDistributeEvenly" runat="server" />
            <asp:LinkButton ID="lnkUnassignAll" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkAssignBy" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lnkDistributeEvenly" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="uppLoadingProgress" AssociatedUpdatePanelID="udpMainPanel" runat="server">
        <ProgressTemplate>
            <div class="ProgressMessage"><img src="~/images/loading.gif" alt="" runat="server" />Loading...</div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    
    <asp:HiddenField ID="hdnAssignBy" runat="server" />
    <asp:HiddenField ID="hdnSaveCriteria" runat="server" />
    <asp:HiddenField ID="hdnDistributeFilterID" runat="server" />
    <asp:HiddenField ID="hdnEntityID" runat="server" />
</asp:Content>