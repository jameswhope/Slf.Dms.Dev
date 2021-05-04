<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master"
    AutoEventWireup="false" CodeFile="batchpaymentssummary-new.aspx.vb" Inherits="research_reports_financial_commission_batchpaymentssummary_new" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>

    <script type="text/javascript">
        function Requery()
        {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
            
            var date1 = txtTransDate1.value.substring(0, 6) + "20" + txtTransDate1.value.substr(6,2);
            var date2 = txtTransDate2.value.substring(0, 6) + "20" + txtTransDate2.value.substr(6,2);
            
            if (!IsValidDateTime(date1))
            {
                ShowMessage("You entered an invalid date in the begin range selector.")
            }
            else if (!IsValidDateTime(date2))
            {
                ShowMessage("You entered an invalid date in the end range selector.")
            }
            else
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
            }
            
        }
        function SetDates(ddl)
        {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom")
            {
                var parts = str.split(",");
                txtTransDate1.value=parts[0];
                txtTransDate2.value=parts[1];
            }
        }
    </script>

    <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%" border="0"
        cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" id="tdFilter" runat="server">
                <div style="padding: 15 15 15 15; overflow: auto; height: 100%; width: 175;">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                        cellspacing="0">
                        <tr>
                            <td>
                                <b>Company</b><br />
                                <br />
                                <asp:DropDownList ID="ddlCompany" AccessKey="1" runat="server" Style="font-family: tahoma;
                                    font-size: 11px; width: 100%;" />
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
            <td valign="top" style="width: 100%; height: 100%; border-left: solid 1px rgb(172,168,153);">
                <div style="overflow: auto">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%; table-layout: fixed"
                        border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top">
                                <div runat="server" id="dvError" style="display: none;">
                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                        width="100%" border="0">
                                        <tr>
                                            <td valign="top" width="20">
                                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                            </td>
                                            <td runat="server" id="tdError">
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="background-color: rgb(244,242,232);">
                                <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                                    border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <img id="Img11" runat="server" src="~/images/grid_top_left.png" border="0" />
                                        </td>
                                        <td style="width: 100%;">
                                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                border="0">
                                                <tr>
                                                    <td nowrap="true">
                                                        <asp:LinkButton ID="lnkShowFilter" class="gridButtonSel" runat="server">
                                                            <img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_funnel.png" /></asp:LinkButton>
                                                    </td>
                                                    <td nowrap="true">
                                                        <img id="Img3" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                    </td>
                                                    <td nowrap="true">
                                                        <asp:LinkButton ID="lnkClear" runat="server" class="gridButton">
                                                            <img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton>
                                                    </td>
                                                    <td nowrap="true">
                                                        <img id="Img5" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                    </td>
                                                    <td nowrap="true">
                                                        <asp:DropDownList ID="ddlQuickPickDate" runat="server" Style="font-family: Tahoma;
                                                            font-size: 11px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td nowrap="true" style="width: 8;">
                                                        &nbsp;
                                                    </td>
                                                    <td nowrap="true" style="width: 65; padding-right: 5;">
                                                        <cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask>
                                                    </td>
                                                    <td nowrap="true" style="width: 8;">
                                                        :
                                                    </td>
                                                    <td nowrap="true" style="width: 65; padding-right: 5;">
                                                        <cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask>
                                                    </td>
                                                    <td nowrap="true">
                                                        <img id="Img6" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                    </td>
                                                    <td nowrap="true">
                                                        <asp:LinkButton ID="lnkRequery" runat="server"></asp:LinkButton>
                                                        <a href="javascript:Requery()" class="gridButton">
                                                            <img id="Img7" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                                    </td>
                                                    <td nowrap="true" style="width: 100%;">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%; width: 100%">
                                <asp:GridView ID="gvPayments" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="false"
                                    ShowFooter="true" CellPadding="5">
                                    <Columns>
                                        
                                        <asp:TemplateField HeaderText="">
                                            <ItemTemplate>
                                                <asp:Image ID="imgNode" runat="server" ImageUrl="~/images/spacer.gif" /><asp:Image ID="imgLeaf" runat="server" ImageUrl="~/images/spacer.gif" /><asp:Label ID="Label1" runat="server" Text='<%#Bind("commrec")%>'></asp:Label>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                &nbsp;
                                            </FooterTemplate>
                                            <HeaderStyle CssClass="headItem" />
                                            <ItemStyle CssClass="listItem4" Width="80%" />
                                            <FooterStyle CssClass="headItem" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Gross Deposits" DataField="gross" DataFormatString="{0:c}"
                                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ItemStyle-CssClass="listItem4"
                                            HeaderStyle-CssClass="headItem" FooterStyle-CssClass="headItem" />
                                        <asp:BoundField HeaderText="Net Payments" DataField="net" DataFormatString="{0:c}"
                                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ItemStyle-CssClass="listItem4"
                                            HeaderStyle-CssClass="headItem" FooterStyle-CssClass="headItem" FooterStyle-HorizontalAlign="Right" />
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
