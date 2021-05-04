<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="offers.aspx.vb" Inherits="admin_offers" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-offer").dialog({
                    autoOpen: false,
                    height: 400,
                    width: 600,
                    modal: true,
                    position: [300, 50],
                    stack: true,
                    close: function() {
                        refresh();
                    }
                });
                $(".jqButton").button();
                $(".jqSaveButton")
                    .button({
                        icons: {
                            primary: "ui-icon-disk"
                        },
                        text: true
                    });
                $(".jqEditButton").button({
                    icons: {
                        primary: "ui-icon-pencil"
                    },
                    text: false
                });
                $(".jqFirstButton").button({
                    icons: {
                        primary: "ui-icon-seek-first"
                    },
                    text: false
                });
                $(".jqPrevButton").button({
                    icons: {
                        primary: "ui-icon-seek-prev"
                    },
                    text: false
                });
                $(".jqNextButton").button({
                    icons: {
                        primary: "ui-icon-seek-next"
                    },
                    text: false
                });
                $(".jqLastButton").button({
                    icons: {
                        primary: "ui-icon-seek-end"
                    },
                    text: false
                });
            });
        }
    </script>

    <script type="text/javascript">
function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
    }
        function ShowOffer(offerid, offername, offerlink, callcenter, transferdata, active, advertiserID, verticalID, received, tag) {
            $("*[id$='txtOfferName']").val(offername);
            $("*[id$='txtOfferLink']").val(offerlink);
            $("*[id$='ddlAdvertiser']").val(advertiserID);
            $("*[id$='ddlVertical']").val(verticalID);
            $("*[id$='txtReceived']").val(received);
            $("*[id$='ddlTag']").val(tag);

            if (callcenter.toLowerCase() == 'true') {
                $("*[id$='chkCallCtr']").attr('checked', true);
            } else {
                $("*[id$='chkCallCtr']").attr('checked', false);
            }
            if (transferdata.toLowerCase() == 'true') {
                $("*[id$='chkTransData']").attr('checked', true);
            } else {
                $("*[id$='chkTransData']").attr('checked', false);
            }

            if (active == undefined) {
                active = 'false';
            } else {
                active = 'true';
            }

            if (active.toLowerCase() == 'true') {
                $("*[id$='chkActive']").attr('checked', true);
            } else {
                $("*[id$='chkActive']").attr('checked', false);
            }

            $("#dialog-offer")
                .data('offerid', offerid)
                .dialog("open");
            
            if (offerid > 0)
                offername = 'Offer #' + offerid + ' - ' + offername;
            else 
                offername = 'New Offer';
            
            $("#dialog-offer").dialog("option", "title", offername);
        }
        function SaveOffer() {
            var newoffer = new Object();
            newoffer.OfferID = $("#dialog-offer").data('offerid');
            newoffer.Offer = $("*[id$='txtOfferName']").val();
            newoffer.OfferLink = $("*[id$='txtOfferLink']").val();
            newoffer.Active = getCheckboxValue($("*[id$='chkActive']").attr("checked"));
            newoffer.CallCenter = getCheckboxValue($("*[id$='chkCallCtr']").attr("checked"));
            newoffer.AdvertiserID = $("*[id$='ddlAdvertiser']").val();
            newoffer.VerticalID = $("*[id$='ddlVertical']").val();
            newoffer.Tag = $("*[id$='ddlTag']").val();
            newoffer.Received = $("*[id$='txtReceived']").val();
            
            var DTO = { 'newoffer': newoffer };

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/InsertUpdateOffer",
                data:  JSON.stringify(DTO),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                },
                error: function(response) {
                    $().toastmessage('showErrorToast', response.d);
                }
            });
            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float:left">
        <h2>Offers</h2>
    </div>
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: right; padding: 0px 0px 5px 5px">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlVertical1" runat="server" AppendDataBoundItems="true" Style="margin-right: 5px"
                                DataSourceID="dsVerticals" DataTextField="Name" DataValueField="VerticalID">
                                <asp:ListItem Text="All Verticals" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlAdvertiser1" runat="server" AppendDataBoundItems="true"
                                Style="margin-right: 5px" DataSourceID="dsAdvertisers" DataTextField="Name"
                                DataValueField="AdvertiserID">
                                <asp:ListItem Text="All Advertisers" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTag1" runat="server" AppendDataBoundItems="true" Style="margin-right: 5px"
                                DataSourceID="dsTags" DataTextField="Tag" DataValueField="Tag">
                                <asp:ListItem Text="All Tags" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlActive" runat="server" Style="margin-right: 5px">
                                <asp:ListItem Text="Active Only" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Show All" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                        <td style="padding-left:5px">
                            <small>
                                <input type="submit" class="jqButton" onclick="return ShowOffer(-1,'New','','false','false','false');" value="Create Offer" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvOffers" runat="server" DataSourceID="odsOffers" AutoGenerateColumns="False"
                        Width="100%" AllowPaging="true" AllowSorting="true" PageSize="22" AlternatingRowStyle-CssClass="altrow" GridLines="None">
                        <RowStyle VerticalAlign="Top" />
                        <Columns>
                            <asp:BoundField DataField="OfferID" HeaderText="ID" SortExpression="OfferID" ItemStyle-Width="30px">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AdvertiserID" HeaderText="AdvertiserID" SortExpression="AdvertiserID"
                                Visible="False" />
                            <asp:BoundField DataField="VerticalID" HeaderText="VerticalID" SortExpression="VerticalID"
                                Visible="False" />
                            <asp:TemplateField HeaderText="Offer" SortExpression="Offer">
                                <ItemTemplate>
                                    <asp:Image ID="imgBuyerActive" runat="server" ImageUrl="" />
                                    <asp:LinkButton ID="lnkEdit" runat="server" Text='<%# eval("Offer") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" Width="300px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VerticalName" HeaderText="Vertical" SortExpression="VerticalName">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AdvertiserName" HeaderText="Advertiser" SortExpression="AdvertiserName">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Received" HeaderText="Recieved" SortExpression="Recieved"
                                DataFormatString="{0:c}">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created" Visible="false">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:BoundField>
                        </Columns>
                        <PagerTemplate>
                            <div id="pager" style="background-color: #DCDCDC">
                                <table style="width: 100%">
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                ID="btnFirst" CssClass="jqFirstButton" />
                                            <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                ID="btnPrevious" CssClass="jqPrevButton" />
                                            Page
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" />
                                            of
                                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                ID="btnNext" CssClass="jqNextButton" />
                                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                ID="btnLast" CssClass="jqLastButton" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="odsOffers" runat="server" SelectMethod="getOffers" TypeName="AdminHelper+OfferObject"
                        OldValuesParameterFormatString="original_{0}">
                        <SelectParameters>
                            <asp:Parameter Name="sortField" Direction="Input" Type="String" />
                            <asp:Parameter Name="sortOrder" Direction="Input" Type="String" />
                            <asp:Parameter Name="offerid" Direction="Input" Type="Int32" DefaultValue="-1" />
                            <asp:ControlParameter Name="VerticalID" ControlID="ddlVertical1" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="AdvertiserID" ControlID="ddlAdvertiser1" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="Tag" ControlID="ddlTag1" PropertyName="SelectedValue" />
                            <asp:ControlParameter Name="Active" ControlID="ddlActive" PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </div>
            </div>
            <div style="clear: both">
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-offer" title="Offer">
        <table style="width: 100%">
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Offer:
                </td>
                <td>
                    <asp:TextBox ID="txtOfferName" runat="server" Width="98%" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right; vertical-align:top">
                    Offer Link:
                </td>
                <td>
                    <asp:TextBox ID="txtOfferLink" runat="server" TextMode="MultiLine" Rows="5" Width="98%" />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Advertiser:
                </td>
                <td>
                    <asp:DropDownList ID="ddlAdvertiser" runat="server" Width="98%" DataSourceID="dsAdvertisers"
                        DataTextField="Name" DataValueField="AdvertiserID" />
                    <asp:SqlDataSource ID="dsAdvertisers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT [AdvertiserID], [Name] FROM [tblAdvertiser] ORDER BY [Name]">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Category-Vertical:
                </td>
                <td>
                    <asp:DropDownList ID="ddlVertical" runat="server" Width="98%" DataSourceID="dsVerticals"
                        DataTextField="Name" DataValueField="VerticalID" />
                    <asp:SqlDataSource ID="dsVerticals" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT VerticalID, c.Category + ' - ' + Name [Name] FROM tblVertical v JOIN tblCategory c on c.CategoryID = v.CategoryID ORDER BY [Name]">
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Tag:
                </td>
                <td>
                    <asp:DropDownList ID="ddlTag" runat="server" Width="98%" DataSourceID="dsTags" DataTextField="Tag"
                        DataValueField="Tag" AppendDataBoundItems="true">
                        <asp:ListItem Text="" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="dsTags" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="SELECT TagID, Tag from tblTags order by Tag"></asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Recieved:
                </td>
                <td>
                    <asp:TextBox ID="txtReceived" runat="server"></asp:TextBox>
                    <asp:Image ID="img1" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="The price received from the Advertiser for an approved conversion." />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Call Center:
                </td>
                <td>
                    <asp:CheckBox ID="chkCallCtr" runat="server" />
                    <asp:Image ID="imgCallCtr" runat="server" ImageUrl="../images/tooltip.gif" ToolTip="Flags this offer as a call center offer." />
                </td>
            </tr>
            <tr>
                <td class="tdHdr" style="width: 115px; text-align: right;">
                    Active:
                </td>
                <td>
                    <asp:CheckBox ID="chkActive" runat="server" />
                </td>
            </tr>
        </table>
        <hr />
        <div style="text-align: right;">
            <button id="btnSaveOffer" class="jqSaveButton" onclick="return SaveOffer();">
                Save Offer
            </button>
        </div>
    </div>
</asp:Content>