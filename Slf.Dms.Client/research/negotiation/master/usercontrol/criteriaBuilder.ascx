<%@ Control Language="VB" AutoEventWireup="false" CodeFile="criteriaBuilder.ascx.vb"
    Inherits="Clients_client_creditors_mediation_usercontrol_criteriaBuilder" %>
<asp:ScriptManagerProxy ID="ScriptManager1" runat="server">
</asp:ScriptManagerProxy>
<link href="<%=ResolveURL("~/research/negotiation/master/css/criteriabuilder.css") %>" rel="stylesheet" type="text/css" />
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/research/negotiation/master/usercontrol/js/wz_tooltip.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/research/negotiation/master/usercontrol/js/tip_balloon.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
    function SetInfo(ControlId, ListValue)
    {
        var txtInputCntrl = document.getElementById(ControlId);
        txtInputCntrl.value = ListValue;
    }
    
    function tCriteria(InputControlId,fieldNameValue)
    {
        var txtValue;
        //var sRedirectString;
        var txtInputCntrl = document.getElementById(InputControlId.id);
        txtValue = txtInputCntrl.value; 
        if( txtValue.length > 1000){txtValue = txtValue.substring(0,1000) + "...";}
        var url = '<%= ResolveUrl("~/util/pop/negotiationfield.aspx") %>?fieldNameValue=' + fieldNameValue + '&ControlID=' + InputControlId.id + '&CurrentValue=' + txtValue;
        window.dialogArguments = window;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Negotiation Field Lookup",
            dialogArguments: window,
            resizable: false,
            scrollable: true,
            height: 800, width: 900
        });       
    }
</script>

<asp:UpdateProgress ID="updProgress" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="updrpt">
    <ProgressTemplate>
        <div class="AjaxProgressMessage">
            <asp:Image ID="imgLoading" Style="font-family: tahoma; font-size: 11px;" runat="server"
                ImageAlign="middle" ImageUrl="~/images/Loading.gif" />&nbsp;&nbsp;<span style="font-family: tahoma;
                    font-size: 11px;">Loading Please wait ...</span>
        </div>        
    </ProgressTemplate>
</asp:UpdateProgress>
<br />
<asp:UpdatePanel ID="updrpt" runat="server">
    <ContentTemplate>
        <table width="750px" cellpadding="0" cellspacing="0" border="0" style="font-family: tahoma;
            font-size: 11px; width: 100%;">
            <tr>
                <td valign="top">
                    <span style="font-family: tahoma; font-size: 11px;">Show all clients who meet the following
                        conditions:
                    </span>
                    <table width="750px" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <asp:RadioButtonList AutoPostBack="false" Visible="false" Style="font-size: x-small;
                                    font-family: Verdana; color: Black;" ID="rdList" runat="server" RepeatDirection="horizontal">
                                    <asp:ListItem Value="root" Selected="true" Text="criteria"></asp:ListItem>
                                    <asp:ListItem Value="stem" Text="Filters" Enabled="false"></asp:ListItem>
                                </asp:RadioButtonList><asp:TextBox ID="txtIndx" Width="10px" Visible="false" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" width="100%">
                                <asp:Panel runat="server" ID="PnlCrWiz" Style="width: 100%; height: auto;" CssClass="cssbox">
                                    <div class="cssbox_head">
                                        <h3 style="padding: 9px 0 15px 10px;">
                                            Criteria Builder</h3>
                                    </div>
                                    <div class="cssbox_body">
                                        <div style="width: 100%;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td valign="top" width="100%">
                                                        <table cellpadding="1" cellspacing="0" border="0" width="100%" style="font-family: tahoma;
                                                            font-size: 11px; width: 100%;">
                                                            <asp:Repeater ID="rptFilters" runat="server">
                                                                <HeaderTemplate>
                                                                    <tr class="GridHeaderStyle" style="height: 20px;">
                                                                        <td width="16px">
                                                                            <asp:ImageButton Visible="false" OnClick="btnImgAdd_AddNew" ImageAlign="textTop"
                                                                                ID="btnImgAdd" ImageUrl="~/images/16x16_transaction_add.png" runat="server" BorderStyle="none"
                                                                                AlternateText="add new" /></td>
                                                                        <td width="170px">
                                                                            Field Name</td>
                                                                        <td width="145px" align="center">
                                                                            Comparision&nbsp;Choice</td>
                                                                        <td width="165px" align="center">
                                                                            Values</td>
                                                                        <td width="80px">
                                                                            &nbsp;</td>
                                                                        <td width="150px">
                                                                            &nbsp;</td>
                                                                        <td width="30px">
                                                                            and/or&nbsp;&nbsp;</td>
                                                                    </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr>
                                                                        <td width="16px">
                                                                            <asp:ImageButton OnClick="btnImgRemove_RemoveRow" ID="btnImgRemove" Width="16px"
                                                                                ImageAlign="textTop" ImageUrl="~/images/16x16_delete.png" runat="server" BorderStyle="none"
                                                                                AlternateText="remove new" /></td>
                                                                        <td valign="middle" align="left">
                                                                            <asp:DropDownList ID="drpName" Style="font-family: Tahoma; font-size: 11" runat="server"
                                                                                AutoPostBack="true" OnSelectedIndexChanged="drpName_SelectedIndexChange" Width="170px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td valign="middle" align="left">
                                                                            <asp:DropDownList ID="drpFilter" Style="font-family: Tahoma; font-size: 11" runat="server"
                                                                                OnSelectedIndexChanged="drpFilter_SelectedIndexChange" Visible="false" Width="145px"
                                                                                AutoPostBack="true">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td align="left" valign="middle">
                                                                            <asp:TextBox ID="txtInputvalue1" Style="font-family: Tahoma; font-size: 11" runat="server"
                                                                                Visible="false" Width="165px"></asp:TextBox>&nbsp;<a href="#" id="lnkPop" runat="server"><img
                                                                                    id="imgLookup" visible="false" runat="server" src="~/images/16x16_find.png" border="0"
                                                                                    align="absmiddle" /></a>
                                                                        </td>
                                                                        <td align="left" valign="middle">
                                                                            <asp:DropDownList ID="drpOperation" runat="server" Visible="false" Style="font-family: Tahoma;
                                                                                font-size: 11" AutoPostBack="false">
                                                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                                                <asp:ListItem Value="%" Text="Percent Of"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td valign="middle" align="left">
                                                                            <asp:DropDownList ID="drpField" Style="font-family: Tahoma; font-size: 11" runat="server"
                                                                                Visible="false" AutoPostBack="false">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td valign="middle" align="left">
                                                                            <asp:DropDownList ID="drpClause" Style="font-family: Tahoma; font-size: 11" runat="server"
                                                                                Width="50px" Visible="false" CssClass="UIControls" AutoPostBack="true" OnSelectedIndexChanged="drpClause_SelectedIndexChange">
                                                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                                                <asp:ListItem Value="and" Text="and"></asp:ListItem>
                                                                                <asp:ListItem Value="or" Text="or"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td align="right" valign="middle" width="750px">
                                                        <table align="right" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:TextBox ID="txtEditId" Visible="false" runat="server" Width="10px"></asp:TextBox></td>
                                                                <td align="right">
                                                                    <img src='<% =ResolveUrl("~/images/16x16_transaction_add.png")%>' /></td>
                                                                <td align="left">
                                                                    &nbsp;<asp:LinkButton ID="lnkAddCriteria" Style="font-family: tahoma; font-size: 11px;"
                                                                        CssClass="lnk" Height="16px" Width="70px" runat="server" Text="Add Criteria"></asp:LinkButton></td>
                                                                <td align="right">
                                                                    <img src='<% =ResolveUrl("~/images/16x16_clear.png")%>' /></td>
                                                                <td align="left">
                                                                    &nbsp;<asp:LinkButton ID="lnkbtnReset" Style="font-family: tahoma; font-size: 11px;"
                                                                        CssClass="lnk" Height="16px" runat="server" Text="Reset  " OnClick="lnkbtnReset_Click"></asp:LinkButton></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td width="750px" height="15px">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <img id="imgMsg" runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
                                                                <td>
                                                                    &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" Style="font-family: tahoma; font-size: 11px;"
                                                                        Width="100%" ForeColor="Red" Font-Bold="false"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Image ID="imgFind" Visible="False" runat="server" ImageUrl="~/images/16x16_Find.png"
                                                            ImageAlign="AbsMiddle" />&nbsp;<asp:LinkButton ID="btnShowPreview" Visible="false"
                                                                Style="font-family: tahoma; font-size: 11px;" Text="Show Preview" runat="server"
                                                                CssClass="lnk"></asp:LinkButton>&nbsp; &nbsp;<asp:Label ID="lblFriendlyDisplay" Style="font-family: tahoma;
                                                                    font-size: 11px;" runat="server" Font-Size="Small"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 22px" valign="middle">
                                                        <asp:Label ID="lblDashBoard" Style="font-family: tahoma; font-size: 11px;" runat="server"
                                                            Font-Size="Small"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table align="left" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label Visible="False" ID="lblFilter" Style="font-family: tahoma; font-size: 11px;"
                                                                        runat="server" Width="100%"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <span id="spnId" visible="false" runat="server" style="font-family: tahoma; font-size: 11px;">
                                                                        Filter Name:</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:TextBox ID="txtfilterName" Visible="false" Style="font-family: tahoma; font-size: 11px;"
                                                                        runat="server" Width="232px"></asp:TextBox></td>
                                                                <td align="right">
                                                                    &nbsp;&nbsp;
                                                                    <asp:Image Visible="false" runat="server" ID="imgSave" ImageAlign="AbsMiddle" ImageUrl="~/images/16x16_save.png" /></td>
                                                                <td align="left">
                                                                    &nbsp;<asp:LinkButton Visible="false" ID="lnkbtnSave" Style="font-family: tahoma;
                                                                        font-size: 11px;" CssClass="lnk" Height="16px" Width="70px" runat="server" Text="Save Criteria"></asp:LinkButton></td>
                                                                <td align="right">
                                                                    <asp:Image ImageUrl="~/images/16x16_cancel.png" Visible="false" ImageAlign="AbsMiddle"
                                                                        ID="imgCancel" runat="server" /></td>
                                                                <td align="left">
                                                                    &nbsp;<asp:LinkButton ID="lnkbtnCancel" Visible="false" Style="font-family: tahoma;
                                                                        font-size: 11px;" CssClass="lnk" Height="16px" runat="server" Text="Cancel  "
                                                                        OnClick="lnkbtnReset_Click"></asp:LinkButton></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <br />
                                    </div>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" width="100%">
                                <asp:Panel runat="server" ID="Panel1" Style="width: 100%; height: auto;" CssClass="cssbox">
                                    <div class="cssbox_head">
                                        <h3 style="padding: 9px 0 15px 10px;">
                                            Criteria Dashboard</h3>
                                    </div>
                                    <div class="cssbox_body" style="height: auto;">
                                        <div style="width: 100%; height: auto;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td valign="top" width="750px">
                                                        <asp:GridView ID="grdView" BorderStyle="none" BorderColor="transparent" BackColor="transparent"
                                                            runat="server" Width="100%" AutoGenerateColumns="False" DataKeyNames="FilterId"
                                                            GridLines="horizontal" HorizontalAlign="center" HeaderStyle-Height="20px" AllowPaging="false">
                                                            <RowStyle CssClass="GridViewItems" Font-Bold="false"></RowStyle>
                                                            <HeaderStyle CssClass="GridHeaderStyle" Font-Bold="false"></HeaderStyle>
                                                            <Columns>
                                                                <asp:BoundField DataField="FilterId" ShowHeader="False" Visible="False" />
                                                                <asp:TemplateField>
                                                                    <ItemStyle Width="16px" />
                                                                    <HeaderStyle Width="16px" />
                                                                    <ItemTemplate>
                                                                        <asp:ImageButton ID="btnDelete" runat="server" AlternateText="Delete Criteria" CommandName="deleteRow"
                                                                            ImageUrl="~/images/16x16_delete.png" OnCommand="DeleteRow" CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>'
                                                                            Width="16px" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <ItemStyle Width="16px" />
                                                                    <HeaderStyle Width="16px" />
                                                                    <ItemTemplate>
                                                                        <asp:ImageButton ID="btnPreview" runat="server" AlternateText="Preview Results" CommandName="preview"
                                                                            ImageUrl="~/images/16x16_search.png" OnCommand="Preview" CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>'
                                                                            Width="16px" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <ItemStyle Width="16px" />
                                                                    <HeaderStyle Width="16px" />
                                                                    <ItemTemplate>
                                                                        <asp:ImageButton ID="btnEdit" runat="server" AlternateText="Edit Criteria" CommandName="editRow"
                                                                            ImageUrl="~/images/16x16_dataentry.png" OnCommand="EditRow" CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>'
                                                                            Width="16px" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField>
                                                                    <ItemStyle Width="16px" />
                                                                    <HeaderStyle Width="16px" />
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="chkExclusion" runat="server" AutoPostBack="true" Visible="false"
                                                                            OnCheckedChanged="RebuildRow" Width="16px" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Filter Name">
                                                                    <HeaderStyle HorizontalAlign="left" Width="157px" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Left" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:HyperLink ID="lnkbtnFilterName" Text='<%# DataBinder.Eval(Container.DataItem,"Description") %>'
                                                                            CssClass="lnk" runat="server" Width="157px"></asp:HyperLink>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="FilterText" HeaderText="Filter Clause">
                                                                    <HeaderStyle HorizontalAlign="Left" Font-Bold="false" Width="157px" />
                                                                    <ItemStyle HorizontalAlign="Left" Font-Bold="false" Width="157px" />
                                                                </asp:BoundField>
                                                                <asp:TemplateField HeaderText="Clients&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Accounts&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Status&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkbtnAccountType" CssClass="GridViewItems" OnCommand="ShowAccountTypeSummary"
                                                                            CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>' runat="server"
                                                                            Text=''></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="States&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkbtnState" CssClass="GridViewItems" OnCommand="ShowStateSummary"
                                                                            CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>' runat="server"
                                                                            Text=''></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Zip&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Creditors&#160;&#160;">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnkbtnCreditors" CssClass="GridViewItems" OnCommand="ShowCreditorsSummary"
                                                                            CommandArgument='<%# DataBinder.Eval(Container,"RowIndex") %>' runat="server"
                                                                            Text=''></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Available&#160;&#160;">
                                                                    <HeaderStyle HorizontalAlign="Right" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="right" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Filter Clause" Visible="false">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Left" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblFilterClause" Text='<%# DataBinder.Eval(Container.DataItem,"FilterClause") %>'
                                                                            runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="" Visible="false">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Left" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="txtFilterText" Text='<%# DataBinder.Eval(Container.DataItem,"FilterText") %>'
                                                                            runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="" Visible="false">
                                                                    <HeaderStyle HorizontalAlign="Center" Font-Bold="false" />
                                                                    <ItemStyle HorizontalAlign="Left" Font-Bold="false" />
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblFilterType" Text='<%# DataBinder.Eval(Container.DataItem,"FilterType") %>'
                                                                            runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                        <br />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <br />
                                    </div>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" valign="top">
                                <table width="95%" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="font-family: tahoma; font-size: 11px;">
                                            <img src="~/images/16x16_cancel.png" visible="false" runat="server" id="imgDetail"
                                                align="absmiddle">&nbsp;&nbsp;<asp:LinkButton ID="btnHide" Visible="false" Style="font-family: tahoma;
                                                    font-size: 11px;" Text="Hide Preview" CssClass="lnk" runat="server"></asp:LinkButton>&nbsp;&nbsp<asp:CheckBox
                                                        ID="ExpandAll" runat="server" Style="font-family: tahoma; font-size: 11px;" CssClass="lnk"
                                                        Text="Expand/Collaps All" AutoPostBack="true" Visible="false" OnCheckedChanged="ExpandAll_CheckedChanged" /></td>
                                    </tr>
                                    <tr>
                                        <td width="100%">
                                            <span id="spnShowPreview" runat="server" style="font-family: tahoma; font-size: 11px;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="750px">
                                                    <asp:Repeater ID="rptPreview" runat="Server" Visible="true">
                                                        <HeaderTemplate>
                                                            <tr class="GridHeaderStyle" style="height: 20px">
                                                                <td align="left">
                                                                    &nbsp;</td>
                                                                <td align="left">
                                                                    Client Id</td>
                                                                <td align="left">
                                                                    SSN #</td>
                                                                <td align="left">
                                                                    Client Name</td>
                                                                <td align="left">
                                                                    City</td>
                                                                <td align="left">
                                                                    State</td>
                                                                <td align="left">
                                                                    Zip</td>
                                                                <td align="right">
                                                                    Available</td>
                                                                <td align="right">
                                                                    Least Debt</td>
                                                            </tr>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td style="font-family: tahoma; font-size: 11px;">
                                                                    <asp:ImageButton ID="imgExpand" runat="server" OnClick="ExpandCollaps" ImageAlign="AbsMiddle"
                                                                        ImageUrl="~/images/tree_plus.bmp" /></td>
                                                                <td class="GridViewItems">
                                                                    <asp:Label ID="lblClientID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ClientId") %>'
                                                                        CssClass="GridViewItems"></asp:Label></td>
                                                                <td class="GridViewItems">
                                                                    <%# DataBinder.Eval(Container.DataItem,"SSN") %>
                                                                </td>
                                                                <td class="GridViewItems">
                                                                    <%# DataBinder.Eval(Container.DataItem,"ApplicantFullName") %>
                                                                </td>
                                                                <td class="GridViewItems">
                                                                    <%# DataBinder.Eval(Container.DataItem,"ApplicantCity") %>
                                                                </td>
                                                                <td class="GridViewItems">
                                                                    <%# DataBinder.Eval(Container.DataItem,"ApplicantState") %>
                                                                </td>
                                                                <td class="GridViewItems">
                                                                    <%# DataBinder.Eval(Container.DataItem,"ApplicantZipCode") %>
                                                                </td>
                                                                <td class="GridViewItems" align="right">
                                                                    <%# DataBinder.Eval(Container.DataItem,"FundsAvailable","{0:c}") %>
                                                                </td>
                                                                <td class="GridViewItems" align="right">
                                                                    <%# DataBinder.Eval(Container.DataItem,"LeastDebtAmount","{0:c}") %>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="9">
                                                                    <asp:Literal ID="tblDrill" runat="server" Visible="false"></asp:Literal></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </table>
                                                <br />
                                                <br />
                                                <asp:Label ID="lblNotFound" runat="server" Visible="false" Text="No Matching records"
                                                    Style="font-family: tahoma; font-size: 11px;"></asp:Label>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" valign="top">
                                <table width="375px" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td width="50%" style="font-size: x-small; font-family: Verdana; color: Black;">
                                            <div id="dvDashBoard" visible="false" runat="server" style="overflow: auto; height: 250px;
                                                width: 100%;">
                                                <img src='<%=Resolveurl("~/images/16x16_cancel.png") %>' align="absmiddle">&nbsp;<asp:LinkButton
                                                    CssClass="lnk" ID="lnkHid" runat="server" Style="font-family: tahoma; font-size: 11px;">Hide Detail</asp:LinkButton>
                                                <br />
                                                <table border="0" cellspacing="0" cellpadding="4" width="98%" style="font-family: tahoma;
                                                    font-size: 11px;">
                                                    <asp:Repeater ID="rptDashBoard" runat="server" Visible="false">
                                                        <HeaderTemplate>
                                                            <tr class="GridHeaderStyle" style="height: 20px;text-align:left" width="22px">
                                                                <td>
                                                                    Description</td>
                                                                <td align="right">
                                                                    Count&nbsp;</td>
                                                            </tr>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td style="border-bottom: solid 1px #d1d1d1;">
                                                                    <%# DataBinder.Eval(Container.DataItem,"Description") %>
                                                                    &nbsp;</td>
                                                                <td style="border-bottom: solid 1px #d1d1d1;" align="right">
                                                                    <%#DataBinder.Eval(Container.DataItem, "Count")%>
                                                                    &nbsp;</td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
