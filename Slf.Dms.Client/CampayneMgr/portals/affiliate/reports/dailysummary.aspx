<%@ Page Title="" Language="VB" MasterPageFile="~/portals/affiliate/affiliate.master" AutoEventWireup="false"
    CodeFile="dailysummary.aspx.vb" Inherits="portals_affiliate_reports_dailysummary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalHead" runat="Server">
    <script type="text/javascript">
        var loadingImg = '<img src="../../../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
                    .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".filter")
				        .prepend("<span class='ui-icon ui-icon-minusthick'></span>")
				        .end()
			        .find(".portlet-content");

                $(".filter .ui-icon").click(function () {
                    $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
                    $(this).parents(".portlet:first").find(".portlet-content").toggle();

                });

                loadButtons();
                loadJQGridviewButtons();
                var $tabs = $("#report-tabs").tabs({
                    show: function () {
                        var sel = $('#report-tabs').tabs('option', 'selected');
                        $("#<%= hidLastTab.ClientID %>").val(sel);
                    },
                    selected: $("#<%= hidLastTab.ClientID %>").val()
                });

                $("#<%= txtFrom.ClientID %>,#<%= txtTo.ClientID %>").datepicker();

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
    </script>
    <script type="text/javascript">
         function CreateCSV(typeid) {

             var tst = $().toastmessage('showToast', {
                 text: 'Generating file...<img src="../../../images/loader3.gif" alt="Loading..."/>',
                 sticky: true,
                 type: 'notice'
             });

             var da = new Object();
             da.DownloadType = typeid;
             
             var arr = new Array;
             arr.push(<%=UserID %>);
             arr.push(null);
             arr.push( $("#<%= ddlCampaigns.ClientID %>").val());
             arr.push($("#<%= txtFrom.ClientID %>").val() + ' 12:00 AM');
             arr.push($("#<%= txtTo.ClientID %>").val() + ' 11:59 PM');
             da.DataArguments = arr;
                          
             var DTO = { 'csvargs': da };

             $.ajax({
                 type: "POST",
                 url: "<%=resolveurl("~/Service/PortalService.asmx") %>/CreateCSVForDownload",
                 data: JSON.stringify(DTO),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: true,
                 success: function (response) {
                     $().toastmessage('removeToast', tst);
                     $().toastmessage('showToast', {
                         text: response.d,
                         sticky: true,
                         type: 'success',
                         close: function () {
                             cleanDocs();
                         }
                     });
                 },
                 error: function (response) {
                     alert(response.responseText);
                 }
             });
             return false;
         }

         function cleanDocs() {
             var tf = $(".downFile").attr('href');
             var dArray = "{";
             dArray += "'tempfile': '" + tf + "'";
             dArray += "}";
             $.ajax({
                 type: "POST",
                 url: "<%=resolveurl("~/Service/PortalService.asmx") %>/DeleteTempFiles",
                 data: dArray,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: true
             });
         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphPortalBody" runat="Server">
    <div>
        <ul class="breadcrumb">
            <li><a href="../Default.aspx">Affiliate Home</a></li>
            <li><a href="#">Reports</a></li>
            <li>Daily Summary</li>
        </ul>
    </div>
    <div style="clear: both;" />
    <asp:UpdatePanel ID="upReports" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    ::: Daily Summary<asp:Label ID="lblViewDaily" runat="server" Text="" /></div>
                <div class="portlet-content">
                    <div class="portlet">
                        <div class="portlet-header filter">
                            ::: Filter</div>
                        <div class="portlet-content">
                            <table style="width: 100%;" class="filterBox">
                                <tr valign="middle">
                                    <td align="left">
                                        <asp:DropDownList ID="ddlCampaigns" runat="server" AppendDataBoundItems="True" DataSourceID="dsCampaigns"
                                            DataTextField="Campaign" DataValueField="CampaignID" Width="99%">
                                            <asp:ListItem Text="All Campaigns" Value="" />
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="dsCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                            SelectCommand="SELECT CampaignID, Campaign FROM vw_Campaigns WHERE (AffiliateID = @AffiliateID)">
                                            <SelectParameters>
                                                <asp:Parameter Name="AffiliateID" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </td>
                                    <td align="left" style="width: 200px">
                                        <table>
                                            <tr>
                                                <td align="left">
                                                    Range:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlQuickPickDate" runat="server" />
                                                </td>
                                                <td align="right">
                                                    Start:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtFrom" runat="server" Width="100" />
                                                </td>
                                                <td align="right">
                                                    End:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtTo" runat="server" Width="100" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" style="width: 100px">
                                        <div id="updateDiv" style="display: none;">
                                            <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                                alt="" />
                                            Loading ...</div>
                                    </td>
                                    <td style="width: 60px;">
                                        <small>
                                            <asp:LinkButton ID="lnkSearch" runat="server" CssClass="jqSearchButton" Text="Filter" />
                                        </small>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <asp:GridView ID="gvDailySummary" runat="server" OnRowCreated="gv_RowCreated" Width="100%"
                    AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="dsDailySummary"
                    OnPreRender="gv_PreRender" ShowFooter="True">
                    <HeaderStyle CssClass="ui-widget-header" Height="30" />
                    <RowStyle CssClass="ui-widget-content" />
                    <FooterStyle CssClass="footerRow" />
                    <Columns>
                        <asp:BoundField DataField="ClickDate" HeaderText="Date" ReadOnly="True" SortExpression="ClickDate">
                            <HeaderStyle HorizontalAlign="Left" Width="165" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Conversions" HeaderText="Conversions" ReadOnly="True"
                            SortExpression="Conversions">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Revenue" HeaderText="Revenue" ReadOnly="True" SortExpression="Revenue"
                            DataFormatString="{0:c2}">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="ui-widget">
                            <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
                                <p>
                                    <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
                                    No Traffic!</p>
                            </div>
                        </div>
                    </EmptyDataTemplate>
                    <PagerTemplate>
                        <div id="pager" style="background-color: #DCDCDC">
                            <small>
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
                                            <asp:LinkButton CssClass="jqButton" ID="lnkExport" runat="server" Text="Export" Style="float: right!important"
                                                OnClientClick="return CreateCSV(0);" />
                                        </td>
                                    </tr>
                                </table>
                            </small>
                        </div>
                    </PagerTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="dsDailySummary" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                    SelectCommand="stp_affiliate_getDailySummaryReport" CancelSelectOnNullParameter="False"
                    SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Name="UserID" Type="Int32" />
                        <asp:Parameter Name="Offer" Type="Int32" ConvertEmptyStringToNull="true" />
                        <asp:Parameter Name="Campaign" Type="Int32" ConvertEmptyStringToNull="true" />
                        <asp:Parameter Name="from" Type="DateTime" />
                        <asp:Parameter Name="to" Type="DateTime" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            </div>
            <asp:HiddenField ID="hidLastTab" runat="server" Value="0" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkSearch" EventName="Click" />
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
        BehaviorID="upMainanimation" runat="server" TargetControlID="upreports">
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
