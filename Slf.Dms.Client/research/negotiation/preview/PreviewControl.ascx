<%@ Control Language="VB" AutoEventWireup="false" CodeFile="PreviewControl.ascx.vb"
    Inherits="PreviewControl"  %>

<link href="preview.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
    function ShowGroup(source){
        var rows = document.getElementsByTagName('tr');
        for (var x in rows){
            if (x.indexOf('_') != -1){
                var strRow = x;
                strRow = strRow.substring(strRow.lastIndexOf('_')+1);
                if (strRow.indexOf(source) != -1){
                    
                    if (x.indexOf('hdr') == -1){
                    
                        var childRows = document.getElementsByName(x);
                        for (i=0;i<=childRows.length-1;i++){
                            if (childRows(i).style.display == ''){
                                childRows(i).style.display = 'none';
                            }else{
                                childRows(i).style.display = '';
                            }
                        }
                        break;
                    }else{
                        var hdr = $get(x);
                        var cell = hdr.children[0];
                        var img = cell.children[0];
                        var tmpSrc = img.src;
                        if (tmpSrc.indexOf('expand') != -1){
                            tmpSrc = tmpSrc.replace('expand','collapse');
                        }else{
                            tmpSrc = tmpSrc.replace('collapse','expand');
                        }
                        
                        img.src = tmpSrc;
                    }
                }
            }
        }
    }
  
</script>

<div>
    <asp:ScriptManagerProxy ID="ScriptManager1" runat="server">
    </asp:ScriptManagerProxy>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="updPreview">
        <ProgressTemplate>
            <div class="AjaxProgressMessage">
                <br />
                <img id="Img2" alt="" src="../../../images/loading.gif" runat="server" /><asp:Label
                    ID="ajaxLabel" name="ajaxLabel" runat="server" Text="Loading Data..." />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="updPreview" ChildrenAsTriggers="false" UpdateMode="Conditional"
        runat="server">
        <ContentTemplate>
            <table>
                <tr valign="top">
                    <td>
                        <asp:Panel runat="server" ID="Panel1" Width="175px" CssClass="cssbox">
                            <div class="cssbox_head">
                                <h3>
                                    Actions</h3>
                            </div>
                            <div class="cssbox_body">
                                <div style="width: 100%; height: 150px;">
                                    <asp:LinkButton ID="btnView" runat="server" Text="View" CssClass="actionButton"></asp:LinkButton><br />
                                    <asp:LinkButton ID="btnExcel" OnClick="btnExcel_Click" runat="server" Text="Export to Excel"
                                        CssClass="actionButton"></asp:LinkButton><br />
                                    <asp:LinkButton ID="btnPDF" OnClick="btnPDF_Click" runat="server" Text="Export to PDF"
                                        CssClass="actionButton"></asp:LinkButton><br />
                                    <asp:LinkButton ID="btnInsertNotes" runat="server" Text="Insert Auto Note" CssClass="actionButton"></asp:LinkButton><br />
                                    <asp:Label ID="lblOptions" runat="server" Text="Options" CssClass="actionButton"></asp:Label><br />
                                </div>
                                <br />
                            </div>
                        </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel runat="server" Width="200px" ID="pnlC" CssClass="cssbox">
                            <div class="cssbox_head">
                                <h3>
                                    1. Select Criteria</h3>
                            </div>
                            <div class="cssbox_body">
                                <div style="width: 100%; height: 150px;">
                                    <asp:RadioButtonList ID="rblType" ForeColor="#1080BF" runat="server" AppendDataBoundItems="true"
                                        OnSelectedIndexChanged="rblType_SelectedIndexChanged" AutoPostBack="True">
                                        <asp:ListItem>Master List</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <br />
                            </div>
                        </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel runat="server" ID="pnlE" Width="300px" CssClass="cssbox">
                            <div class="cssbox_head">
                                <h3>
                                    2. Select Entity</h3>
                            </div>
                            <div class="cssbox_body">
                                <div style="width: 100%; height: 150px;">
                                    <asp:ListBox ForeColor="#1080BF" Height="150px" ID="lstEntity" AutoPostBack="true"
                                        Width="85%" runat="server" OnSelectedIndexChanged="lstEntity_SelectedIndexChanged" />
                                    <ajaxToolkit:ListSearchExtender ID="ListSearchExtender1" runat="server" TargetControlID="lstEntity"
                                        PromptCssClass="ListSearchExtenderPrompt" PromptPosition="Bottom">
                                    </ajaxToolkit:ListSearchExtender>
                                </div>
                                <br />
                            </div>
                        </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel runat="server" ID="pnlF" Width="500px" CssClass="cssbox">
                            <div class="cssbox_head">
                                <h3>
                                    3. Available Filters</h3>
                            </div>
                            <div class="cssbox_body">
                                <div style="overflow-y: auto; width: 100%; height: 150px;">
                                    <asp:CheckBoxList ForeColor="#1080BF" ID="chkFilters" runat="server" BorderColor="#b0c4de"
                                        Height="75px" Font-Size="8pt">
                                    </asp:CheckBoxList>
                                </div>
                                <p>
                                </p>
                            </div>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <asp:GridView ID="gridData" runat="server" AllowSorting="True" AllowPaging="True"
                PagerSettings-Position="TopAndBottom" DataSourceID="dsData" Width="100%" AutoGenerateColumns="false"
                OnSorting="gridData_Sorting" EnableViewState="true">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <asp:Label ID="lblGroupName" runat="server"></asp:Label>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:Panel ID="pnlGroup" runat="server" BackColor="LightGray" Height="30px">
                                <div class="GridHeaderstyle" style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                    <div style="float: left;">
                                        <asp:Label ID="lblGroup" Font-Size="12pt" Font-Bold="true" Text='<%# Bind("GroupHdr") %>'
                                            runat="server" />
                                    </div>
                                    <div style="float: right; vertical-align: middle;">
                                        <asp:ImageButton ID="Image1" runat="server" ImageUrl="~/images/expand.jpg" />
                                    </div>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlgrid" runat="server" Width="100%">
                                <asp:GridView ID="gvChild"  runat="server" AutoGenerateColumns="False" PagerSettings-Mode="NextPreviousFirstLast"
                                    Width="100%" OnRowCreated="gvChild_RowCreated" OnRowCommand="gvChild_RowCommand"
                                    PageSize="50" OnRowDataBound="gvChild_RowDataBound" OnPageIndexChanging="gvChild_PageIndexChanging"
                                    OnSorting="gvChild_Sorting" BackColor="White" BorderColor="#999999" BorderStyle="None"
                                    BorderWidth="1px" CellPadding="3" GridLines="Vertical">
                                    <RowStyle CssClass="rowstyle"></RowStyle>
                                    <AlternatingRowStyle CssClass="alternatingrowstyle" />
                                    <PagerStyle CssClass="pagerstyle"></PagerStyle>
                                    <HeaderStyle CssClass="headerstyle"></HeaderStyle>
                                    <Columns>
                    
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div>
                                            No records to display.</div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </asp:Panel>
                            <ajaxToolkit:CollapsiblePanelExtender CollapsedSize="1" ID="cpeGrid" TargetControlID="pnlGrid"
                                ExpandControlID="pnlGroup" CollapseControlID="pnlGroup"  runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerTemplate>
                    <table width="100%">
                        <tbody>
                            <tr style="font-family: Tahoma; font-size: 8pt">
                                <td align="left">
                                    Group By
                                    <asp:DropDownList ID="ddlGroupBy" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroupBy_SelectedIndexChanged"
                                        Width="150px">
                                        <asp:ListItem>NONE</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td align="left">
                                    <asp:Label ID="Label1" runat="server" Text="Page Size "></asp:Label>
                                    <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged"
                                        Width="59px">
                                        <asp:ListItem>25</asp:ListItem>
                                        <asp:ListItem>50</asp:ListItem>
                                        <asp:ListItem>100</asp:ListItem>
                                        <asp:ListItem>200</asp:ListItem>
                                    </asp:DropDownList>
                                <td align="right">
                                    &nbsp;
                                    <asp:Label ID="Label2" runat="server" Text="Page "></asp:Label>
                                    <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged"
                                        Width="45px">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label3" runat="server" Text="of"></asp:Label>
                                    <asp:Label ID="lblPageCount" runat="server" Text="000"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </PagerTemplate>
                <RowStyle CssClass="gridrowstyle"></RowStyle>
                <AlternatingRowStyle CssClass="gridalternatingrowstyle" />
                <PagerStyle CssClass="gridpagerstyle"></PagerStyle>
                <HeaderStyle CssClass="gridheaderstyle"></HeaderStyle>
                <PagerSettings Position="TopAndBottom" />
            </asp:GridView>
            <asp:SqlDataSource ID="dsData" runat="server" SelectCommand="" ConnectionString="<%$ Appsettings:ConnectionString %>">
            </asp:SqlDataSource>

            <asp:Panel ID="PopupOptions" runat="server" CssClass="popupMenu">
                <div>
                    <ajaxToolkit:Accordion ID="accOptions" runat="server" HeaderCssClass="accordionHeader"
                        HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent"
                        AutoSize="Limit" Height="300px" Width="400px" RequireOpenedPane="false" SuppressHeaderPostbacks="true">
                        <Panes>
                            <ajaxToolkit:AccordionPane runat="server" ID="paneCols">
                                <Header>
                                    Columns To Display</Header>
                                <Content>
                                    <asp:CheckBoxList ID="chkColumns" runat="server">
                                    </asp:CheckBoxList></Content>
                            </ajaxToolkit:AccordionPane>
                            <ajaxToolkit:AccordionPane runat="server" ID="paneGroups">
                                <Header>
                                    Group By Column</Header>
                                <Content>
                                    <asp:RadioButtonList ID="radGroups" runat="server">
                                    </asp:RadioButtonList></Content>
                            </ajaxToolkit:AccordionPane>
                            <ajaxToolkit:AccordionPane runat="server" ID="paneShow">
                                <Header>
                                    How to Show Group</Header>
                                <Content>
                                    <asp:RadioButtonList ID="radGroupShow" runat="server">
                                        <asp:ListItem>Show Collapsed</asp:ListItem>
                                        <asp:ListItem Selected="True">Show Expanded</asp:ListItem>
                                    </asp:RadioButtonList></Content>
                            </ajaxToolkit:AccordionPane>
                        </Panes>
                    </ajaxToolkit:Accordion>
                </div>
            </asp:Panel>
            <ajaxToolkit:HoverMenuExtender ID="hme2" runat="Server" TargetControlID="lblOptions"
                PopDelay="25" PopupPosition="Center" PopupControlID="PopupOptions" HoverCssClass="popupHover">
            </ajaxToolkit:HoverMenuExtender>
            <asp:Label ID="lblError" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExcel"></asp:PostBackTrigger>
            <asp:PostBackTrigger ControlID="btnPDF"></asp:PostBackTrigger>
            <%--<asp:AsyncPostBackTrigger ControlID="btnView" EventName="Click"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="rblType" EventName="SelectedIndexChanged"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="gridData" EventName="RowCreated"></asp:AsyncPostBackTrigger>
            
            <asp:AsyncPostBackTrigger ControlID="gridData" EventName="PreRender"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="gridData" EventName="PageIndexChanging"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="gridData" EventName="Sorting"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="sc" EventName="PostBack" />
            <asp:AsyncPostBackTrigger ControlID="lstEntity" EventName="SelectedIndexChanged" />--%>
        </Triggers>
    </asp:UpdatePanel>
</div>

<script type="text/javascript">
    var manager = Sys.WebForms.PageRequestManager.getInstance();
    manager.add_beginRequest(BeginRequest);

    function BeginRequest(sender, args) {
        var postBackElement = args.get_postBackElement();
        var eID = postBackElement.id;

      
        //changes progress status label message    -     
        if (eID.indexOf("btnView") != -1){
            $get('ctl00_ctl00_cphBody_cphBody_pvg1_ajaxLabel').innerHTML = "Loading Data..."
        }else if (eID.indexOf("ddlPageSize") != -1){
            $get('ctl00_ctl00_cphBody_cphBody_pvg1_ajaxLabel').innerHTML = "Recalculating Grid Data..."
        }else if (eID.indexOf("ddlPage") != -1){
            $get('ctl00_ctl00_cphBody_cphBody_pvg1_ajaxLabel').innerHTML = "Changing Pages..."
        }else if (eID.indexOf("gridData") != -1 && eID.indexOf("lnkNegotiate") == -1){
            $get('ctl00_ctl00_cphBody_cphBody_pvg1_ajaxLabel').innerHTML = "Sorting Data..."
        }
    }
</script>

