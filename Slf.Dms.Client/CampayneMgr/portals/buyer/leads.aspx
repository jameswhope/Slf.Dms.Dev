<%@ Page Title="" Language="VB" MasterPageFile="~/portals/buyer/buyer.master" AutoEventWireup="false"
    CodeFile="leads.aspx.vb" Inherits="portals_buyer_leads" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalhead" runat="Server">
    <script type="text/javascript">


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
				        .prepend("<span class='ui-icon ui-icon-minusthick'></span>")
				        .end()
			        .find(".portlet-content");

                $(".portlet-header .ui-icon").click(function () {
                    $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
                    $(this).parents(".portlet:first").find(".portlet-content").toggle();

                });
                loadButtons();
                loadJQGridviewButtons();
                $("#<%= txtFrom.ClientID %>,#<%= txtTo.ClientID %>").datepicker();

                $(".wide").css('width', $(window).width() - 370);
                $("#pageDiv").css('width', $(window).width() - 50);
                $("#gvManual").css('width', $(window).width() - 470);
                $(".column").disableSelection();

                $(window).bind('resize', function () {
                    $(".wide").css('width', $(window).width() - 370);
                    $("#pageDiv").css('width', $(window).width() - 50);
                    $("#gvManual").css('width', $(window).width() - 470);
                }).trigger('resize');
            });
        }
        function loadButtons() {
            $(".jqButton").button();
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
         function CreateCSV(csvtype) {

             var tst = $().toastmessage('showToast', {
                 text: 'Generating file...<img src="../../images/loader3.gif" alt="Loading..."/>',
                 sticky: true,
                 type: 'notice'
             });

             var dArray = "{";
             dArray += "'userid': '" + <%= Userid %> + "',";
             dArray += "'fromdate': '" + $("#<%= txtFrom.ClientID %>").val() + "',";
             dArray += "'todate': '" + $("#<%= txtTo.ClientID %>").val() + "'";
             dArray += "}";

             var da = new Object();
             da.DownloadType = csvtype;
             
             var arr = new Array;
             arr.push(<%= Page.User.Identity.Name %>);
             arr.push($("#<%= txtFrom.ClientID %>").val());
             arr.push($("#<%= txtTo.ClientID %>").val());
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
    <style type="text/css">
        .style1
        {
            width: 500px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphPortalBody" runat="Server">
    <div>
        <ul class="breadcrumb">
            <li><a href="Default.aspx">Buyer Home</a></li>
            <li>Lead Report</li>
        </ul>
    </div>
    <div style="clear: both;" />
    <asp:UpdatePanel ID="upLeads" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    Lead Report
                    <asp:Label ID="lblLeadCnt" runat="server" /></div>
                <div class="portlet-content">
                    <table style="width: 100%;" class="filterBox" border="0">
                        <tr>
                            <td align="left" class="style1">
                                Range:
                                <asp:DropDownList ID="ddlQuickPickDate" runat="server" >
                                </asp:DropDownList>
                                From:
                                <asp:TextBox ID="txtFrom" runat="server" />
                                To:
                                <asp:TextBox ID="txtTo" runat="server" />
                            </td>
                            <td align="right"  width="30px">
                                <small>
                                    <asp:LinkButton CssClass="jqButton" ID="lnkGetCounts" runat="server" Text="Filter"
                                        Style="float: right!important" Font-Size="10pt" />
                                </small>
                            </td>
                            
                            <td align="right">
                                <div id="updateDiv" style="display: none;">
                                    <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                        alt="" />
                                    Loading ...</div>
                            </td>
                            <td align="right">
                                Contract :
                                <asp:DropDownList ID="ddlContracts" runat="server"  AppendDataBoundItems="True" AutoPostBack="true"
                                    DataSourceID="dsContracts" DataTextField="ContractName" DataValueField="BuyerOfferXrefID">
                                    <asp:ListItem Text="ALL" Value="" />
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="dsContracts" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="SELECT BuyerOfferXrefID,ContractName from  tblBuyerOfferXref where BuyerID = (select UserTypeUniqueID from tbluser where userid = @userid)"
                                    CancelSelectOnNullParameter="False">
                                    <SelectParameters>
                                        <asp:Parameter Name="UserID" ConvertEmptyStringToNull="true" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                        </tr>
                    </table>
                    <asp:GridView ID="gvLeadReport" runat="server" DataSourceID="dsLeadReport" Width="100%"
                        AllowSorting="True" AutoGenerateColumns="False" CssClass="GridView" AllowPaging="True"
                        PageSize="25">
                        <HeaderStyle Height="30" />
                        <Columns>
                            <asp:BoundField DataField="ReturnedReason" HeaderText="Returned Reason" SortExpression="ReturnedReason">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ContractName" HeaderText="Contract Name" SortExpression="ContractName">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="leadid" HeaderText="Lead ID" SortExpression="leadid">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="firstname" HeaderText="First Name" SortExpression="firstname">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="lastname" HeaderText="Last Name" SortExpression="lastname">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="StateCode" HeaderText="State" SortExpression="StateCode">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Phone" HeaderText="Home Phone" SortExpression="Phone">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:c2}"
                                SortExpression="Price">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Right" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DateSold" HeaderText="Date Sold" SortExpression="DateSold">
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Left" />
                            </asp:BoundField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                No Leads Found
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
                                                <asp:LinkButton CssClass="jqButton" ID="lnkExport" runat="server" Text="Export Excel"
                                                    Style="float: right!important" Font-Size="10pt" OnClientClick="CreateCSV(5);" />
                                            </small>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsLeadReport" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_buyer_getLeadReport" 
                        SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="False">
                        <SelectParameters>
                            <asp:Parameter Name="userid" />
                            <asp:Parameter Name="from" />
                            <asp:Parameter Name="to" />
                            <asp:ControlParameter ControlID="ddlContracts" Name="contractid" 
                                PropertyName="SelectedValue" />
                        </SelectParameters>
                    </asp:SqlDataSource>
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
    <ajaxtoolkit:UpdatePanelAnimationExtender ID="upLeads_UpdatePanelAnimationExtender"
        BehaviorID="Returnsanimation" runat="server" TargetControlID="upLeads">
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
