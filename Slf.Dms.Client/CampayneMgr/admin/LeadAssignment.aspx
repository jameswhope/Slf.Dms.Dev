<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="LeadAssignment.aspx.vb" Inherits="admin_LeadAssignment" %>

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
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			    .find(".portlet-header")
				    .addClass("ui-widget-header ui-corner-all")
				    .prepend("<span class='ui-icon ui-icon-circle-triangle-s'></span>")
				    .end()
			    .find(".portlet-content");
                $(".portlet-header .ui-icon").click(function () {
                    $(this).toggleClass("ui-icon-circle-triangle-s").toggleClass("ui-icon-circle-triangle-n");
                    $(this).parents(".portlet:first").find(".portlet-content").toggle();
                });
            });
        }

        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float:left; width:250px">
            <div class="portlet">
                <div class="portlet-header">
                    Lookup
                </div>
                <div class="portlet-content">
                    <table>
                        <tr>
                            <td>
                                Phone:
                            </td>
                            <td>
                                <asp:TextBox ID="txtPhoneNumber" runat="server" MaxLength="10" Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:ImageButton ID="btnGetInfo" runat="server" ImageUrl="~/images/btn-SoldTo.jpg" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="portlet">
                <div class="portlet-header">
                    Add
                </div>
                <div class="portlet-content">
                    <table>
                        <tr>
                            <td align="right">
                                Agent:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlUsers" runat="server" DataTextField="UserName" DataValueField="UserID"
                                    Width="160px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Offer:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlOffers" runat="server" DataTextField="Offer" DataValueField="OfferID"
                                    AutoPostBack="true" AppendDataBoundItems="true" Width="160px">
                                    <asp:ListItem Text="-- Select --" Value="-1"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Buyer:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlBuyers" runat="server" DataTextField="Buyer" DataValueField="BuyerID"
                                    Width="160px">
                                    <asp:ListItem Text="-- Select Offer --"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:ImageButton ID="btnPostAssignment" runat="server" ImageUrl="~/images/btn-Assign.jpg" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </div>
            <div style="float: left; width:800px">
            <div class="portlet">
                <div class="portlet-header">
                    Valid Submissions
                </div>
                <div class="portlet-content" style="min-height:210px">
                    <asp:GridView runat="server" ID="gvSoldTo" AutoGenerateColumns="false" CellPadding="3" AlternatingRowStyle-CssClass="altrow" GridLines="None" Width="100%" DataKeyNames="submittedofferid">
                        <Columns>
                            <asp:BoundField DataField="fullname" HeaderText="Name" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="phone" HeaderText="Phone" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="email" HeaderText="Email" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="buyer" HeaderText="Buyer" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="offer" HeaderText="Offer" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="submitted" DataFormatString="{0:d}" HeaderText="Submitted" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="submittedby" HeaderText="Agent" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="pointvalue" HeaderText="Points" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:BoundField DataField="price" DataFormatString="{0:c}" HeaderText="Price" HeaderStyle-CssClass="ui-widget-header" HeaderStyle-HorizontalAlign="Left" ItemStyle-CssClass="griditem2" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnRemove" runat="server" Font-Underline="true" CommandName="remove" OnClientClick="return confirm('Are you sure you want to remove this entry?');">remove</asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditem2" />
                                <HeaderStyle CssClass="ui-widget-header" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            </div>
            <div style="clear: both; height: 100px">
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="upnlJsRunner" UpdateMode="Always" runat="server">
		<ContentTemplate>
			<asp:PlaceHolder ID="phrJsRunner" runat="server"></asp:PlaceHolder>
		</ContentTemplate>
	</asp:UpdatePanel>
</asp:Content>
