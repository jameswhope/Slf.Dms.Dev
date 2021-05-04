<%@ Page AutoEventWireup="false" CodeFile="SettlementExceptions.aspx.vb" Inherits="negotiation.SettlementExceptions.negotiation_SettlementExceptions_SettlementExceptions" Language="VB" MasterPageFile="~/negotiation/Negotiation.master" %>

    <asp:content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">

     <script type="text/javascript">
        
    </script>

    <style type="text/css">
        .footerItem
        {
            font-weight: bold;
            background-color: #DCDCDC;
        }
        .headItem5
        {
            background-color: #DCDCDC;
            border-bottom: solid 1px #d3d3d3;
            font-weight: normal;
            color: Black;
            font-size: 11px;
            font-family: Arial;
        }
        .headItem5 a
        {
            text-decoration: none;
            display: block;
            color: Black;
            font-weight: 200;
        }
        .listItem
        {
            cursor: pointer;
            border-bottom: solid 1px #d3d3d3;
        }
        .entry
        {
            font-family: Arial;
            font-size: 11px;
            width: 100%;
        }
        .entry2
        {
            font-family: Arial;
            font-size: 11px;
        }
        .RndGridBox
        {
            display: block;
        }
        .RndGridBox *
        {
            display: block;
            height: 1px;
            overflow: hidden;
            font-size: .01em;
            background: #3376AB;
        }
        .RndGridBox1
        {
            margin-left: 3px;
            margin-right: 3px;
            padding-left: 1px;
            padding-right: 1px;
            border-left: 1px solid #a7c4da;
            border-right: 1px solid #a7c4da;
            background: #6698c0;
        }
        .RndGridBox2
        {
            margin-left: 1px;
            margin-right: 1px;
            padding-right: 1px;
            padding-left: 1px;
            border-left: 1px solid #eaf1f6;
            border-right: 1px solid #eaf1f6;
            background: #5990ba;
        }
        .RndGridBox3
        {
            margin-left: 1px;
            margin-right: 1px;
            border-left: 1px solid #5990ba;
            border-right: 1px solid #5990ba;
        }
        .RndGridBox4
        {
            border-left: 1px solid #a7c4da;
            border-right: 1px solid #a7c4da;
        }
        .RndGridBox5
        {
            border-left: 1px solid #6698c0;
            border-right: 1px solid #6698c0;
        }
        .RndGridBoxfg
        {
            background: #3376AB;
        }
    </style>

    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td>
                            <div class="entry" style="text-align: center; font-weight: bold; background-color: #3376AB;
                                color: white; padding:5px; border-bottom:solid 1px white">
                                Expired Settlement Details
                            </div>
                            <div class="entry" style="text-align: right; font-weight: bold; background-color: #3376AB;
                                color: white;padding:5px;">
                                <asp:Label ID="lblFilterByDay" runat="server" Text="Days since settlements expired : " />
                                <asp:DropDownList ID="ddlDayFilter" runat="server" AutoPostBack="True" >
                                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
<%--                                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                    <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                    <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                    <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                    <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                    <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                    <asp:ListItem Text="11" Value="11"></asp:ListItem>
                                    <asp:ListItem Text="12" Value="12"></asp:ListItem>
                                    <asp:ListItem Text="13" Value="13"></asp:ListItem>
                                    <asp:ListItem Text="14" Value="14"></asp:ListItem>
                                    <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                    <asp:ListItem Text="16" Value="16"></asp:ListItem>
                                    <asp:ListItem Text="17" Value="17"></asp:ListItem>
                                    <asp:ListItem Text="18" Value="18"></asp:ListItem>
                                    <asp:ListItem Text="19" Value="19"></asp:ListItem>
                                    <asp:ListItem Text="20" Value="20"></asp:ListItem>
                                    <asp:ListItem Text="21" Value="21"></asp:ListItem>
                                    <asp:ListItem Text="22" Value="22"></asp:ListItem>
                                    <asp:ListItem Text="23" Value="23"></asp:ListItem>
                                    <asp:ListItem Text="24" Value="24"></asp:ListItem>
                                    <asp:ListItem Text="25" Value="25"></asp:ListItem>
                                    <asp:ListItem Text="26" Value="26"></asp:ListItem>
                                    <asp:ListItem Text="27" Value="27"></asp:ListItem>
                                    <asp:ListItem Text="28" Value="28"></asp:ListItem>
                                    <asp:ListItem Text="29" Value="29"></asp:ListItem>
                                     <asp:ListItem Text="30" Value="30"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </div>
                            <asp:GridView AllowSorting="True" AutoGenerateColumns="False" CssClass="entry" DataSourceID="dsExpired" ID="gvExpiredReport" runat="server">
                                <Columns>
                                    <asp:BoundField DataField="SettlementDueDate" HeaderText="Settlement&nbsp;Expired&nbsp;On"
                                        DataFormatString="{0:MM/dd/yyyy}" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Attorney" HeaderText="Firm" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:HyperLinkField HeaderText="Client" DataTextField="clientname"
                                        DataNavigateUrlFields="clientid" 
                                        DataNavigateUrlFormatString="~/clients/client/?id={0}" >
                                    <ControlStyle CssClass="lnk" />
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:HyperLinkField>
                                    <asp:HyperLinkField HeaderText="Creditor" DataTextField="creditor"
                                        DataNavigateUrlFields="clientid,AccountID" 
                                        DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}" >
                                    <ControlStyle CssClass="lnk" />
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:HyperLinkField>
                                    <asp:BoundField DataField="SettlementAmount" HeaderText="Settlement&nbsp;Amount"
                                        DataFormatString="{0:c2}" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SDABal" HeaderText="Available&nbsp;SDA" 
                                        DataFormatString="{0:c2}" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NegotiationTeam" HeaderText="Negotiation&nbsp;Team" 
                                        DataFormatString="{0:c2}" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RepName" HeaderText="Negotiator&nbsp;Name" 
                                        DataFormatString="{0:c2}" >
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:TemplateField Visible="False">
                                        <ItemTemplate>
                                            <input type="hidden" id="hdnRejectedSettlementID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementId")%>' />
                                            <input type="hidden" id="hdnClientID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                            <input type="hidden" id="hdnAccountID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AccountId")%>' />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    No Data.
                                    <asp:LinkButton ID="lnkClearFilter" runat="server" Text="Clear Filter" OnClick="lnkClear_Click" />
                                </EmptyDataTemplate>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsExpired" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure">
                            </asp:SqlDataSource>
            </td>
        </tr>
       
    </table>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />

</asp:Content>