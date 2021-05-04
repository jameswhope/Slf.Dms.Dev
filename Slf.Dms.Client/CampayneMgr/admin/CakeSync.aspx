<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="CakeSync.aspx.vb" Inherits="admin_CakeSync" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $(".jqSaveButton")
                    .button({
                        icons: {
                            primary: "ui-icon-disk"
                        },
                        text: true
                    });
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <div class="portlet">
        <div class="portlet-header">
         Cake Post Keys
        </div>
        <div class="portlet-content">
            <asp:GridView ID="grdCakeCampaigns" runat="server" runat="server" AllowPaging="True"
                    AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="CampaignId,BuyerId,OfferId"
                    Width="100%" GridLines="None" PageSize="10" CssClass="ui-widget-container" HeaderStyle-CssClass="ui-widget-header"
                    RowStyle-CssClass="ui-widget-content" ShowFooter="True">
                    <Columns>
                        <asp:TemplateField HeaderText="Affiliate">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblCampaign" runat="server" Text='<%#Eval("Campaign")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlCampaign" runat="server" DataSourceID="dsCampaigns" DataTextField="Campaign"
                                    DataValueField="CampaignId">
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Buyer">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblBuyer" runat="server" Text='<%#Eval("Buyer")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlBuyer" runat="server" DataSourceID="dsBuyers" DataTextField="Buyer"
                                    DataValueField="BuyerId">
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Offer">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblOffer" runat="server" Text='<%#Eval("Offer")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:DropDownList ID="ddlOffer" runat="server" DataSourceID="dsOffers" DataTextField="Offer"
                                    DataValueField="OfferId">
                                </asp:DropDownList>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cake Id">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtCakeId" runat="server" Width="80px"></asp:TextBox>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtCakeId" runat="server" Width="80px"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post Key">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtPostKey" runat="server"></asp:TextBox>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtPostKey" runat="server"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Add">
                            <ItemTemplate>
                                <asp:ImageButton ID="ImgAdd" runat="server" ImageUrl="~/images/16x16_add.png" CommandName="Select" />
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="ImgAdd" runat="server" ImageUrl="~/images/16x16_add.png" CommandName="Add" />
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle CssClass="ui-widget-header" />
                </asp:GridView>
                <asp:SqlDataSource ID="dsCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                    SelectCommand="Select 0 as CampaignId, '  Select' as Campaign Union Select CampaignId, Campaign From tblCampaigns Order By Campaign">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsBuyers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                    SelectCommand="Select 0 as BuyerId, '  Select' as Buyer Union Select BuyerId, Buyer From tblBuyers Order By Buyer">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                    SelectCommand="Select 0 as OfferId, '  Select' as Offer Union Select OfferId, Offer From tblOffers Order By Offer">
                </asp:SqlDataSource>
        </div>
    </div>
        
        
            <h2 style="padding-left: 5px">
               </h2>
            <div class="portlet-content">
            
            </div>
            <div style="clear: both; height: 20px">
            </div>
            <h2>
                Messages:
            </h2>
            <div id="msgs" runat="server" class="msgs">
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
