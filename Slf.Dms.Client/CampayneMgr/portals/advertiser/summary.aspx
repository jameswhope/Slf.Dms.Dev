<%@ Page Title="" Language="VB" MasterPageFile="~/portals/advertiser/advertiser.master" AutoEventWireup="false"
    CodeFile="summary.aspx.vb" Inherits="portals_advertiser_Summary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalHead" runat="Server">
    <style type="text/css">
        .header
        {
            padding-bottom: 20px;
        }
        .column
        {
            width: 300px;
            float: left;
            padding-bottom: 10px;
        }
        .wide
        {
            width: 65%;
        }
    </style>
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
                $("#<%= txtFrom.ClientID %>,#<%= txtTo.ClientID %>").datepicker();

                loadButtons();
                loadJQGridviewButtons();
                $("#divSummary").css('width', $(window).width() - 400);
                $(window).bind('resize', function () {
                    $("#divSummary").css('width', $(window).width() - 400);

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
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtFrom.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtTo.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
        function popup(data) {
            $("body").append('<form id="exportform" action="../../Handlers/CsvExport.ashx?f=AdvertiserSummary" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvTraffic']").table2CSV({ delivery: 'value' });
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
            <li><a href="Default.aspx">Advertiser Home</a></li>
            <li>Offer Summary</li>
        </ul>
    </div>
    <div style="clear: both;" />
    <asp:UpdatePanel ID="upDefault" runat="server">
        <ContentTemplate>
            <div class="body">
               
                    <div class="portlet">
                        <div class="portlet-header">
                            ::: Offer Summary</div>
                        <div class="portlet-content">
                            <div>
                                <table style="width: 100%" class="filterBox" >
                                    <tr>
                                        <td align="left">
                                            Range:
                                            <asp:DropDownList ID="ddlQuickPickDate" runat="server" />
                                            Start:
                                            <asp:TextBox ID="txtFrom" runat="server" Width="120" />
                                            End:
                                            <asp:TextBox ID="txtTo" runat="server" Width="120" />
                                        </td>
                                        <td align="right" style="width: 100px">
                                                <div id="updateDiv" style="display:none;">
                                                    <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                                        alt="" />
                                                    Loading ...</div>
                                            </td>
                                        <td>
                                            <small>
                                                 <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="jqSearchButton"
                                                        Style="float: right!important" />
                                                    
                                            </small>
                                        </td>
                                    </tr>
                                </table>
                                <asp:GridView ID="gvTraffic" runat="server" Width="100%" ShowHeaderWhenEmpty="True"
                                    DataSourceID="dsTraffic" AutoGenerateColumns="False" GridLines="Vertical" AllowPaging="True"
                                    AllowSorting="True" PageSize="20" ShowFooter="true" >
                                    <HeaderStyle Height="25px" />
                                    <FooterStyle CssClass="footerRow" />
                                    <Columns>
                                        <asp:BoundField DataField="offerid" SortExpression="offerid" HeaderText="offerid"
                                            Visible="false">
                                            <HeaderStyle CssClass="ui-widget-header" />
                                            <ItemStyle CssClass="ui-widget-content" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="offer" SortExpression="offer" HeaderText="Offer">
                                            <HeaderStyle CssClass="ui-widget-header"  HorizontalAlign="Left"/>
                                            <ItemStyle CssClass="ui-widget-content"  HorizontalAlign="Left"/>
                                            <FooterStyle  />
                                        </asp:BoundField>
                                       
                                        <asp:BoundField DataField="PriceReceived" SortExpression="PriceReceived" HeaderText="Price Received" DataFormatString="{0:c2}">
                                            <HeaderStyle CssClass="ui-widget-header"  HorizontalAlign="right" Width="110" Wrap="false"/>
                                            <ItemStyle CssClass="ui-widget-content" HorizontalAlign="right" Width="110"/>
                                            <FooterStyle  HorizontalAlign="Right" Width="100"/>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Clicks" SortExpression="Clicks" HeaderText="Clicks">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="right" Width="75"/>
                                            <ItemStyle CssClass="ui-widget-content" HorizontalAlign="right" Width="75"/>
                                            <FooterStyle  HorizontalAlign="Right"  Width="100"/>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Conversions" HeaderText="Conversions" SortExpression="Conversions">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="right" Width="100"/>
                                            <ItemStyle CssClass="ui-widget-content" HorizontalAlign="right" Width="100"/>
                                            <FooterStyle  HorizontalAlign="Right"  Width="100"/>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" SortExpression="Revenue" DataFormatString="{0:c2}">
                                            <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="right" Width="100"/>
                                            <ItemStyle CssClass="ui-widget-content" HorizontalAlign="right" Width="100"/>
                                            <FooterStyle  HorizontalAlign="Right" Width="100"/>
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
                                                    <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="jqExportButton"
                                                        Style="float: right!important" OnClientClick="ExportExcel();" />
                                                        </small>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </PagerTemplate>
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsTraffic" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="stp_advertiser_getTraffic " SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:Parameter Name="userid" Type="Int32" />
                                         <asp:Parameter Name="from" Type="DateTime" />
                                          <asp:Parameter Name="to" Type="DateTime" />
                                        
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
              
            </div>
        </ContentTemplate>
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
    <ajaxtoolkit:UpdatePanelAnimationExtender ID="upDefault_UpdatePanelAnimationExtender"
        BehaviorID="Returnsanimation" runat="server" TargetControlID="upDefault">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="tblFilter" Enabled="false" />
                           
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                      
                            <EnableAction AnimationTarget="tblFilter" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxtoolkit:UpdatePanelAnimationExtender>


</asp:Content>
