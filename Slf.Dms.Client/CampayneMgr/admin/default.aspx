<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="admin_default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .grid-view tr.normal
        {
            background-color: #fff;
        }
        .grid-view tr.normal:hover
        {
            background-color: #d3d3d3;
        }
    </style>

    <script type="text/javascript">
        var chart1; // globally available
    
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqSaveButton")
                    .button({
                        icons: {
                            primary: "ui-icon-disk"
                        },
                        text: true
                    });
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
            });
        }


        
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    Verticals (Offers)
                </div>
                <div class="portlet-content">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <asp:GridView ID="gvOffers" runat="server" CssClass="grid-view" DataKeyNames="OfferID"
                                    DataSourceID="ds_Offers" AutoGenerateColumns="false" GridLines="None" BorderStyle="None"
                                    BorderWidth="0" Width="100%">
                                    <Columns>
                                        <asp:BoundField DataField="Offer" HeaderText="" >
                                        
                                        <HeaderStyle CssClass="ui-widget-header" />
                                        <ItemStyle  />
                                        </asp:boundfield>
                                        
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                Active
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkActive" runat="server" Checked='<%#Eval("Active") %>' />
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="ui-widget-header" />
                                            <ItemStyle HorizontalAlign="Center"  />
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                Data
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkData" runat="server" Checked='<%#Eval("TransferData") %>' />
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="ui-widget-header" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                    <hr />
                    <div style="clear: both; width: 100%; ">
                        <div style="float: right">
                            <asp:LinkButton ID="btnSaveOffers" runat="server" CssClass="jqSaveButton" Text="Save"  />
                        </div>
                    </div>
                </div>
            </div>
            <asp:SqlDataSource ID="ds_Offers" runat="server" ConnectionString="<%$connectionStrings:IDENTIFYLEDB %>"
                SelectCommand="select * from tbloffers where offerid not in (80) and callcenter = 1 order by offer"
                SelectCommandType="Text"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
