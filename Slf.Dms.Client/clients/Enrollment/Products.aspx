<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Products.aspx.vb" Inherits="Clients_Enrollment_admin_products" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>    
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <!--#include file="mgrtoolbar.inc"-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .headerbg
        {
            background-color: #dcdcdc;
            font-weight: normal;
        }
        .itemStyle
        {
            border-bottom: dotted 1px #dcdcdc;
        }
        .effdate
        {
            border:none;
        	background-color:#dcdcdc;
        	font-size:9px;
        	width:52px;
        }
    </style>

    <script language="javascript" type="text/javascript">
        function toggleDocument(docName, gridviewID) {
            var rowName = 'tr_' + docName
            var gv = document.getElementById(gridviewID);
            var rows = gv.getElementsByTagName('tr');
            for (var row in rows) {
                var rowID = rows[row].id
                if (rowID != undefined) {
                    if (rowID.indexOf(rowName + '_child') != -1) {
                        rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                    } else if (rowID.indexOf(rowName + '_parent') != -1) {
                        var tree = rows[row].cells[0].children[0].src
                        rows[row].cells[0].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                    }
                }
            }
        }

        function RemoveNewCost(id) {
            if (confirm('Are you sure you want to remove this effective date?')) {
                document.getElementById('<%=hdnProductID.ClientID %>').value = id;
                document.getElementById('<%=lnkRemoveNewCost.ClientID %>').click();
            }

        }
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 235px; background-color: rgb(214,231,243); padding: 20px;" valign="top">
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Add Product
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    Vendor:
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlVendor" runat="server" CssClass="entry2" DataSourceID="dsVendors"
                                                        DataTextField="VendorCode" DataValueField="VendorID">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="dsVendors" runat="server" SelectCommand="select vendorcode, vendorid from tblleadvendors where active = 1 order by vendorcode"
                                                        SelectCommandType="Text" ConnectionString="<%$ appSettings:connectionstring %>">
                                                    </asp:SqlDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Code:
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCode" runat="server" CssClass="entry2"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtCode" Text="*"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Description:
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDesc" runat="server" CssClass="entry2"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtDesc" Text="*"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Cost:
                                                </td>
                                                <td align="right">
                                                    $
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCost" runat="server" CssClass="entry2" Text="0.00"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Rev Share:
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="chkRev" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <asp:Button ID="btnAdd" runat="server" Text="Add Product" CssClass="entry2" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Common Tasks
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="btnSave" runat="server" CssClass="lnk" CausesValidation="false">
                                                        <img id="Img3" src="~/images/16x16_save.png" runat="server" alt="Save" border="0"
                                                            style="vertical-align: middle" />&nbsp;&nbsp;Save Changes</asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                            DisplayAfter="0">
                            <ProgressTemplate>
                                <div style="padding: 3px; background-color: #fff">
                                    <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                    Loading..
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                        <div style="height: 20px;">
                            &nbsp;</div>
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <div class="box">
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <h2 style="border-bottom:solid 1px #cccccc; font-weight:normal">
                                                Products</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Total Marketing Budget Spent: 
                                            <asp:Label ID="lblSpent" runat="server" CssClass="entry2" ForeColor="Blue"></asp:Label></td>
                                        <td style="padding: 5" align="right">
                                            <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="true" DataSourceID="dsMonth"
                                                DataTextField="dmth" DataValueField="mthyr" CssClass="entry2">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="dsMonth" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                                SelectCommandType="Text" SelectCommand="select distinct datename(m,created) + ' ' + cast(year(created) as char(4)) [dmth], month(created) [mth], year(created) [yr], cast(month(created) as varchar(2)) + '/1/' + cast(year(created) as char(4)) [mthyr] from tblleadapplicant where created > '1/1/2010' order by [yr] desc, [mth] desc">
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            <b>Self-generated Internet</b>
                                        </td>
                                        <td style="background-color: #f5f5f5; padding: 5" align="right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvSelfGen" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="5" ShowFooter="true" CssClass="entry2" DataKeyNames="productid"
                                                Width="100%" DataSourceID="ds_SelfGen">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="16px">
                                                        <HeaderTemplate>
                                                            <img id="Img2" runat="server" src="~/images/16x16_icon.png" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headerbg" />
                                                        <ItemStyle CssClass="itemStyle" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="vendorcode" HeaderText="Vendor" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle" />
                                                    <asp:TemplateField ItemStyle-Width="16px">
                                                        <HeaderTemplate>
                                                            Rev
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="imgRev" runat="server" src="~/images/16x16_check.png" visible="false" alt="" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headerbg" />
                                                        <ItemStyle CssClass="itemStyle" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="productcode" HeaderText="Product Code" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" />
                                                    <asp:TemplateField HeaderText="Current Cost" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle"
                                                        HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            $<asp:TextBox ID="txtCurrentCost" runat="server" Text='<%# Eval("currentcost", "{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="55px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Lead Cost" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle"
                                                        HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            $<asp:TextBox ID="txtCost" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"cost","{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="55px"></asp:TextBox>
                                                            <asp:Image ID="imgEffectiveDate" runat="server" ImageUrl="~/images/16x16_calendar.png" ToolTip="Set Effective Date (optional)" ImageAlign="AbsMiddle" style="cursor:pointer" Visible="false" /><ajaxToolkit:CalendarExtender ID="CalendarExtender1"
                                                                    runat="server" PopupButtonID="imgEffectiveDate" TargetControlID="txtEffectiveDate">
                                                                </ajaxToolkit:CalendarExtender>
                                                            <a href="javascript:void 0" id="info_<%# Eval("productid")%>_<%# Eval("cost", "{0:#####0}")%>" onclick="setAttachTo(this)" title="Add cost date range (optional)"><asp:Image ID="imgAdd" runat="server" ImageUrl="~/images/16x16_adddep.png"/></a>
                                                            <div id="data_<%# Eval("productid")%>_<%# Eval("cost", "{0:#####0}")%>" style="display:none;" >
                                                                <table class="entry2">
                                                                    <tr>
                                                                        <td>Product:</td>
                                                                        <td></td>
                                                                        <td style="height:25px">
                                                                            <b><%#Eval("productcode")%></b>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>From:</td>
                                                                        <td></td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtFrom" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"firstlead","{0:d}")%>'></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>To:</td>
                                                                        <td></td>
                                                                        <td><asp:TextBox ID="txtTo" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"lastlead","{0:d}")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Cost:</td>
                                                                        <td>$</td>
                                                                        <td><asp:TextBox ID="txtNewCost" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"cost","{0:#####0.00}")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td></td>
                                                                        <td>
                                                                            <asp:Button ID="btnUpdateCost" runat="server" Text="Update" CssClass="entry2" CommandName="Update Cost" CommandArgument="<%# CType(Container,GridViewRow).RowIndex %>" CausesValidation="false" /></td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                            <div>
                                                                <asp:TextBox ID="txtEffectiveDate" runat="server" onchange="this.style.display='';" style="display:none" CssClass="effdate" ToolTip="Effective date"></asp:TextBox></div>    
                                                            <%#ShowEffectiveDate(Eval("ProductID"), Eval("EffectiveDate"), Eval("NewCost"))%>
                                                            <asp:HiddenField ID="hdnCost" runat="server" Value='<%# Eval("cost")%>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="noleads" HeaderText="Leads" HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="true" HeaderStyle-CssClass="headerbg"
                                                        ItemStyle-HorizontalAlign="Center" />
                                                    <asp:BoundField DataField="firstlead" HeaderText="First Lead" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:d}" />
                                                    <asp:BoundField DataField="lastlead" HeaderText="Last Lead" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:d}" />
                                                    <asp:BoundField DataField="spent" HeaderText="Spent" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:c0}" />    
                                                </Columns>
                                            </asp:GridView>
                                            <asp:SqlDataSource ID="ds_SelfGen" runat="server" SelectCommand="stp_enrollment_selfGenInternetProducts"
                                                SelectCommandType="StoredProcedure" ConnectionString="<%$ appSettings:connectionstring %>">
                                                <SelectParameters>
                                                    <asp:ControlParameter Name="Date" ControlID="ddlMonth" PropertyName="SelectedValue" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            <b>3rd Party Internet/Live Transfer/Radio</b>
                                        </td>
                                        <td style="background-color: #f5f5f5; padding: 5" align="right">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="5" ShowFooter="true" CssClass="entry2" DataKeyNames="productid"
                                                Width="750px" DataSourceID="ds_AllOtherProducts">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="16px">
                                                        <HeaderTemplate>
                                                            <img id="Img4" runat="server" src="~/images/16x16_icon.png" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headerbg" />
                                                        <ItemStyle CssClass="itemStyle" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="category" HeaderText="Category" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle" />
                                                    <asp:BoundField DataField="vendorcode" HeaderText="Vendor" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle" />
                                                    <asp:BoundField DataField="productcode" HeaderText="Product Code" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" />
                                                    <asp:TemplateField HeaderText="Current Cost" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle"
                                                        HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            $<asp:TextBox ID="txtCurrentCost" runat="server" Text='<%# Eval("currentcost", "{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="55px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Lead Cost" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemStyle"
                                                        HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                        <ItemTemplate>
                                                            $<asp:TextBox ID="txtCost" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"cost","{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="55px"></asp:TextBox>
                                                            <asp:Image ID="imgEffectiveDate" runat="server" ImageUrl="~/images/16x16_calendar.png" ToolTip="Set Effective Date (optional)" ImageAlign="AbsMiddle" style="cursor:pointer" Visible="false" /><ajaxToolkit:CalendarExtender ID="CalendarExtender1"
                                                                    runat="server" PopupButtonID="imgEffectiveDate" TargetControlID="txtEffectiveDate">
                                                                </ajaxToolkit:CalendarExtender>
                                                            <a href="javascript:void 0" id="info_<%# Eval("productid")%>_<%# Eval("cost", "{0:#####0}")%>" onclick="setAttachTo(this)" title="Add cost date range (optional)"><asp:Image ID="imgAdd" runat="server" ImageUrl="~/images/16x16_adddep.png"/></a>
                                                            <div id="data_<%# Eval("productid")%>_<%# Eval("cost", "{0:#####0}")%>" style="display:none;" >
                                                                <table class="entry2">
                                                                    <tr>
                                                                        <td>Product:</td>
                                                                        <td></td>
                                                                        <td style="height:25px">
                                                                            <b><%#Eval("productcode")%></b>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>From:</td>
                                                                        <td></td>
                                                                        <td>
                                                                            <asp:TextBox ID="txtFrom" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"firstlead","{0:d}")%>'></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>To:</td>
                                                                        <td></td>
                                                                        <td><asp:TextBox ID="txtTo" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"lastlead","{0:d}")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Cost:</td>
                                                                        <td>$</td>
                                                                        <td><asp:TextBox ID="txtNewCost" runat="server" CssClass="entry2" Width="60px" Text='<%# DataBinder.Eval(Container.DataItem,"cost","{0:#####0.00}")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td></td>
                                                                        <td>
                                                                            <asp:Button ID="btnUpdateCost" runat="server" Text="Update" CssClass="entry2" CommandName="Update Cost" CommandArgument="<%# CType(Container,GridViewRow).RowIndex %>" CausesValidation="false" /></td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                            <div>
                                                                <asp:TextBox ID="txtEffectiveDate" runat="server" onchange="this.style.display='';" style="display:none" CssClass="effdate" ToolTip="Effective date"></asp:TextBox></div>    
                                                            <%#ShowEffectiveDate(Eval("ProductID"), Eval("EffectiveDate"), Eval("NewCost"))%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="noleads" HeaderText="Leads" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        ItemStyle-HorizontalAlign="Center" />
                                                    <asp:BoundField DataField="firstlead" HeaderText="First Lead" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:d}" />
                                                    <asp:BoundField DataField="lastlead" HeaderText="Last Lead" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:d}" />
                                                    <asp:BoundField DataField="spent" HeaderText="Spent" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right"
                                                        ItemStyle-CssClass="itemStyle" ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg"
                                                        DataFormatString="{0:c0}" /> 
                                                </Columns>
                                            </asp:GridView>
                                            <asp:SqlDataSource ID="ds_AllOtherProducts" runat="server" SelectCommand="stp_enrollment_allnonselfGenProducts"
                                                SelectCommandType="StoredProcedure" ConnectionString="<%$ appSettings:connectionstring %>">
                                                <SelectParameters>
                                                    <asp:ControlParameter Name="Date" ControlID="ddlMonth" PropertyName="SelectedValue" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <obo:Flyout ID="Flyout1" runat="server" Position="MIDDLE_RIGHT" Align="TOP" OpenEvent="NONE" CloseEvent="NONE" FadingEffect="true">
                    <div id="dynamic_content" style="width:185px;height:120px;background-color:#f0f0f0; border-top:solid 1px #cccccc; border-left:solid 1px #cccccc; border-right:solid 1px #cccccc"></div>
                    <div id="Div1" style="width:185px;height:20px; text-align:right;background-color:#f0f0f0; border-bottom:solid 1px #cccccc; border-left:solid 1px #cccccc; border-right:solid 1px #cccccc">
                        <a href="javascript:void 0" onclick="<%=Flyout1.getClientID()%>.Close();" class="lnk">Cancel</a>&nbsp;
                    </div>                                
                </obo:Flyout>
                
                
            <script type="text/javascript">
                function setAttachTo(obj)
                {
                    var panel = document.getElementById("dynamic_content");
                    //Clone the Div that contain data
                    var newContent = document.getElementById(obj.id.replace("info","data")).cloneNode(true);
                    newContent.style.display="block";
                    
                    if (panel.firstChild)
                        panel.removeChild(panel.firstChild);
                    panel.appendChild(newContent);
                    
                    <%=Flyout1.getClientID()%>.AttachTo(obj.id);
                    
                    <%=Flyout1.getClientID()%>.Open();
                }
            </script>
            <asp:LinkButton ID="lnkRemoveNewCost" runat="server"></asp:LinkButton>
            <asp:HiddenField ID="hdnProductID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
