<%@ Page Title="" Language="VB" MasterPageFile="~/portals/affiliate/affiliate.master" AutoEventWireup="false"
    CodeFile="offers.aspx.vb" Inherits="portals_affiliate_offers" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalHead" runat="Server">
 
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                $(".column").sortable({
                    connectWith: ".column"
                });
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");


                loadButtons();
                loadJQGridviewButtons();
                $(".wide").css('width', $(window).width() - 400);
                $(window).bind('resize', function () {
                    $(".wide").css('width', $(window).width() - 400);
                }).trigger('resize');
            });
        }
        function loadButtons() {
            $(".jqButton").button();
            $(".jqSearchButton")
                .button({
                    icons: {
                        primary: "ui-icon-search"
                    },
                    text: true
                });
        }
        function popup(data) {
            $("body").append('<form id="exportform" action="../../Handlers/CsvExport.ashx?f=AffiliateOffers" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvOffers']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphPortalBody" runat="Server">
    <div>
        <ul class="breadcrumb">
            <li><a href="Default.aspx">Affiliate Home</a></li>
            <li>Offers</li>
        </ul>
    </div>
    <div style="clear: both;" />
    <asp:UpdatePanel ID="upMain" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    ::: Offers</div>
                <div class="portlet-content">
                    <div class="portlet">
                        <div class="portlet-header">
                            ::: Filter</div>
                        <div class="portlet-content">
                            <div>
                                <table style="width: 100%" class="filterBox">
                                    <tr>
                                        <td style="width: 250px">
                                            <asp:TextBox ID="txtSearch" runat="server" Width="99%" />
                                            <ajaxtoolkit:TextBoxWatermarkExtender ID="txtSearch_TextBoxWatermarkExtender" runat="server"
                                                Enabled="True" TargetControlID="txtSearch" WatermarkText="Search Here For Offers...">
                                            </ajaxtoolkit:TextBoxWatermarkExtender>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <asp:DropDownList ID="ddlStatus" runat="server" Width="125px">
                                                <asp:ListItem Text="All Statuses" Value="" />
                                                <asp:ListItem Text="Active" Value="1" />
                                                <asp:ListItem Text="Inactive" Value="0" />
                                            </asp:DropDownList>
                                            <asp:DropDownList ID="ddlVerticals" runat="server" AppendDataBoundItems="True" DataSourceID="dsVerticals"
                                                DataTextField="vertical" DataValueField="VerticalID" Width="150px">
                                                <asp:ListItem Text="All Verticals" Value="" />
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="dsVerticals" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="SELECT distinct VerticalID,Vertical from vw_Campaigns where AffiliateID = (SELECT UserTypeUniqueID from tblUser where UserId = @userid) order by vertical">
                                                <SelectParameters>
                                                    <asp:Parameter Name="userid" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </td>
                                        <td align="right" style="width: 100px">
                                            <div id="updateDiv" style="display: none;">
                                                <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                                    alt="" />
                                                Loading ...</div>
                                        </td>
                                        <td style="width: 185px">
                                            <small>
                                                <asp:LinkButton ID="lnkFilter" runat="server" CssClass="jqSearchButton" Style="float: right!important"
                                                    Text="Filter" />
                                                <asp:LinkButton ID="lnkReset" runat="server" CssClass="jqButton" Style="float: right!important"
                                                    Text="Reset" />
                                            </small>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <asp:GridView ID="gvOffers" runat="server" AllowPaging="True" AllowSorting="True"
                        AutoGenerateColumns="False" DataSourceID="dsOffers" Width="100%" PageSize="20"
                        ShowHeaderWhenEmpty="True">
                        <RowStyle CssClass="ui-widget-content" />
                        <HeaderStyle CssClass="ui-widget-header" Height="30" />
                        <Columns>
                            <asp:BoundField DataField="OfferID" HeaderText="OfferID" ReadOnly="True" SortExpression="OfferID"
                                Visible="False" />
                            <asp:BoundField DataField="OfferName" HeaderText="Name" ReadOnly="True" SortExpression="OfferName">
                                <HeaderStyle HorizontalAlign="Left"  Wrap="false"/>
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PriceFormat" HeaderText="Price Format" ReadOnly="True"
                                SortExpression="PriceFormat">
                                <HeaderStyle HorizontalAlign="Left" Width="100px" Wrap="false" />
                                <ItemStyle Wrap="False" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="OfferPrice" HeaderText="Price" ReadOnly="True" SortExpression="OfferPrice"
                                DataFormatString="{0:c2}">
                                <HeaderStyle HorizontalAlign="Right" Width="75px"  Wrap="false"/>
                                <ItemStyle HorizontalAlign="Right" Width="75px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True" SortExpression="Status">
                                <HeaderStyle HorizontalAlign="Left" Width="150px"  Wrap="false"/>
                                <ItemStyle Wrap="False" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Vertical" HeaderText="Vertical" ReadOnly="True" SortExpression="Vertical">
                                <HeaderStyle HorizontalAlign="Left"  Wrap="false"/>
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>
                             <asp:BoundField DataField="MediaType" HeaderText="Media Type" ReadOnly="True" SortExpression="MediaType">
                                <HeaderStyle HorizontalAlign="Left" Width="50px"  Wrap="false"/>
                                <ItemStyle Wrap="False" Width="50px" />
                            </asp:BoundField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="ui-widget">
                                <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
                                    <p>
                                        <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                                        No Results!</p>
                                </div>
                            </div>
                        </EmptyDataTemplate>
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
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true" />
                                            of
                                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                ID="btnNext" CssClass="jqNextButton" />
                                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                ID="btnLast" CssClass="jqLastButton" />
                                        </td>
                                        <td>
                                            <small>
                                                <asp:LinkButton ID="lnkExport" runat="server" CssClass="jqButton" OnClientClick="ExportExcel();"
                                                    Style="float: right!important" Text="Export" />
                                            </small>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsOffers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_affiliate_getOffers" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="False">
                        <SelectParameters>
                            <asp:Parameter Name="UserID" Type="Int32" />
                            <asp:Parameter Name="OfferName" Type="String" ConvertEmptyStringToNull="true" />
                            <asp:Parameter Name="OfferStatus" Type="Int32" ConvertEmptyStringToNull="true" />
                            <asp:Parameter Name="OfferVertical" Type="Int32" ConvertEmptyStringToNull="true" />
                            <asp:Parameter Name="OfferMediaType" Type="Int32" ConvertEmptyStringToNull="true"
                                DefaultValue="56" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvOffers" EventName="Sorting" />
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateDiv');
            // make it visible
            updateProgressDiv.style.display = '';
        }

        function onUpdated() {
            // get the update progress div
            var updateProgressDiv = $get('updateDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>
    <ajaxtoolkit:UpdatePanelAnimationExtender ID="upMain_UpdatePanelAnimationExtender"
        BehaviorID="upMainanimation" runat="server" TargetControlID="upMain">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxtoolkit:UpdatePanelAnimationExtender>
</asp:Content>
