<%@ Page Title="" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false" CodeFile="FeesDetail.aspx.vb" Inherits="Agency_FeesDetail" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" Runat="Server">

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
                                                <img id="Img1" runat="server" src="~/images/message.png" align="middle" border="0" alt="" />
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
                                            <img id="Img11" runat="server" src="~/images/grid_top_left.png" border="0" alt="" />
                                        </td>
                                        <td style="width: 100%;">
                                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                border="0">
                                                <tr>
                                                    <td nowrap="nowrap">
                                                        <asp:LinkButton ID="lnkShowFilter" class="gridButtonSel" runat="server">
                                                            <img id="Img2" runat="server" align="middle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_funnel.png" alt="" /></asp:LinkButton>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <img id="Img3" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" alt="" />
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:LinkButton ID="lnkClear" runat="server" class="gridButton">
                                                            <img id="Img4" runat="server" align="middle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_clear.png" alt="" />Clear Criteria</asp:LinkButton>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <img id="Img5" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" alt="" />
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:DropDownList ID="ddlQuickPickDate" runat="server" Style="font-family: Tahoma;
                                                            font-size: 11px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td nowrap="nowrap" style="width: 8;">
                                                        &nbsp;
                                                    </td>
                                                    <td nowrap="nowrap" style="width: 65; padding-right: 5;">
                                                        
                                                        <asp:TextBox runat="server" ID="txtTransDate1"></asp:TextBox>
                                                        <ajaxToolkit:MaskedEditExtender ID="txtTransDate1ex" runat="server" MaskType="Date" Mask="__/__/__" TargetControlID="txtTransDate1" />
                                                    </td>
                                                    <td nowrap="nowrap" style="width: 8;">
                                                        :
                                                    </td>
                                                    <td nowrap="nowrap" style="width: 65; padding-right: 5;">
                                                        <asp:TextBox runat="server" ID="txtTransDate2"></asp:TextBox>
                                                        <ajaxToolkit:MaskedEditExtender ID="txtTransDate2ex" runat="server" MaskType="Date" Mask="__/__/__" TargetControlID="txtTransDate2" />
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <img id="Img6" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" alt="" />
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:LinkButton ID="lnkRequery" runat="server"></asp:LinkButton>
                                                        <a href="javascript:Requery()" class="gridButton">
                                                            <img id="Img7" runat="server" align="middle" border="0" class="gridButtonImage"
                                                                src="~/images/16x16_exclamationpoint.png" alt="" />Refresh</a>
                                                    </td>
                                                    <td nowrap="nowrap" style="width: 100%;">
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
                                <asp:GridView ID="gvPayments" runat="server" Width="100%" GridLines="None" AutoGenerateColumns="False"
                                    ShowFooter="True" CellPadding="5" AllowPaging="False" AllowSorting="True" 
                                    Caption="Fees Paid" CaptionAlign="Top" >
                                    <Columns>
                                        
                                        <asp:BoundField HeaderText="BatchDate" DataField="BatchDate" DataFormatString="{0:d}"
                                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ItemStyle-CssClass="listItem4"
                                            HeaderStyle-CssClass="headItem" FooterStyle-CssClass="headItem" 
                                            ShowHeader="False" SortExpression="BatchDate" Visible="False" >
<FooterStyle CssClass="headItem"></FooterStyle>

<HeaderStyle HorizontalAlign="Right" CssClass="headItem"></HeaderStyle>

<ItemStyle HorizontalAlign="Right" CssClass="listItem4"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Company" DataField="Company"
                                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right" ItemStyle-CssClass="listItem4"
                                            HeaderStyle-CssClass="headItem" FooterStyle-CssClass="headItem" 
                                            FooterStyle-HorizontalAlign="Right" ReadOnly="True" SortExpression="Company" >
                                        <ControlStyle Width="150px" />

<FooterStyle HorizontalAlign="Right" CssClass="headItem"></FooterStyle>

<HeaderStyle HorizontalAlign="Left" CssClass="headItem"></HeaderStyle>

<ItemStyle HorizontalAlign="Left" CssClass="listItem4" Width="150px"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Month" HeaderText="Month" ReadOnly="True" 
                                            SortExpression="Month">
                                        <ControlStyle Width="10px" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="10px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Day" HeaderText="Day" ReadOnly="True" 
                                            SortExpression="Day">
                                        <ControlStyle Width="5px" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Width="5px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Year" HeaderText="Year" ReadOnly="True" 
                                            SortExpression="Year">
                                        <ControlStyle Width="10px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="10px" />
                                        <ItemStyle HorizontalAlign="Left" Width="10px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AccountNumber" HeaderText="Account #" 
                                            ReadOnly="True" SortExpression="AccountNumber">
                                        <ControlStyle Width="30px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="30px" Wrap="False" />
                                        <ItemStyle HorizontalAlign="Left" Width="30px" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Client" HeaderText="Client" ReadOnly="True" 
                                            SortExpression="Client">
                                        <ControlStyle Width="100px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="150px" />
                                        <ItemStyle HorizontalAlign="Left" Width="150px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ClientState" HeaderText="State" 
                                            ReadOnly="True" SortExpression="State">
                                        <ControlStyle Width="4px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="10px" />
                                        <ItemStyle HorizontalAlign="Left" Width="10px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="FeeType" HeaderText="FeeType" ReadOnly="True" 
                                            SortExpression="FeeType">
                                        <ControlStyle Width="100px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="150px" />
                                        <ItemStyle HorizontalAlign="Left" Width="150px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Fees" DataFormatString="{0:c}" HeaderText="Fees" 
                                            ReadOnly="True" SortExpression="Fees">
                                        <ControlStyle Width="12px" />
                                        <HeaderStyle HorizontalAlign="Right" Width="12px" />
                                        <ItemStyle HorizontalAlign="Right" Width="12px" Wrap="True" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Voided_Bounced" HeaderText="Voided_Bounced" 
                                            ReadOnly="True" SortExpression="Voided_Bounced">
                                        <ControlStyle Width="50px" />
                                        <HeaderStyle HorizontalAlign="Left" Width="100px" />
                                        <ItemStyle HorizontalAlign="Left" Width="100px" />
                                        </asp:BoundField>
                                    </Columns>
                                    <HeaderStyle HorizontalAlign="Center" Width="25px" Wrap="False" />
                                </asp:GridView>
<%--                                <asp:SqlDataSource ID="dbFeesPaid" runat="server" 
                                    ConnectionString="<%$Data Source=LEXSRVSQLPROD1\LEXSRVSQLPROD;Initial Catalog=DMS;Integrated Security=True  %>" 
                                    SelectCommand="stp_TKM_Fees_Paid" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="txtTransDate1" DefaultValue="01/01/1950" 
                                            Name="StartDate" PropertyName="Text" Type="DateTime" />
                                        <asp:ControlParameter ControlID="txtTransDate2" DefaultValue="01/01/2050" 
                                            Name="EndDate" PropertyName="Text" Type="DateTime" />
                                    </SelectParameters>
                                </asp:SqlDataSource>--%>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

