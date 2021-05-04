<%@ Page Title="" Language="VB" MasterPageFile="~/portals/buyer/buyer.master" AutoEventWireup="false"
    CodeFile="summary.aspx.vb" Inherits="portals_buyer_Summary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalhead" runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
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
                
                loadChart();

                $("*[id$='ddlContracts']").change(function () {
                    loadChart();
                });
            });
        }
        function loadButtons() {
            $(".jqButton").button();
        }
        function popup(data) {
            $("body").append('<form id="exportform" action="../../Handlers/CsvExport.ashx?f=buyerleadsummary" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvLeadSummary']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
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
        var leadchart;
        function loadChart() {
            $("#container").html('<div id="loadingDiv" style="width:100%; text-align:center;display:block;"><div style="width:40%;padding:10px; margin-top: 20px; text-align:center;" class="ui-state-highlight ui-corner-all"><strong>Loading...</strong><br/><img src="../../images/ajax-loader2.gif" alt="loading..." /></div></div>');
            var chartOptions = {
                chart: {
                    renderTo: 'container',
                    type: 'column',
                    margin: [50, 50, 100, 80]
                },
                title: {
                    text: null
                },
                xAxis: {
                    categories: [],
                    labels: {
                        rotation: -25,
                        align: 'right',
                        style: {
                            font: 'normal 13px Verdana, sans-serif'
                        }
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: 'Leads'
                    }
                },
                legend: {
                    enabled: true
                },
                tooltip: {
                    formatter: function () {
                        return '<b>' + this.x + '</b><br/>' +
					Highcharts.numberFormat(this.y, 0) +
					' lead(s)';
                    }
                },
                series: []
            };
            
            var dArray = "{";
            dArray += "'userid': '" + <%= Userid %> + "',";
            dArray += "'contractid': '" + $("#<%= ddlContracts.ClientID %>").val() + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "summary.aspx/getChartData",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                   
                    var obj = eval('(' + response.d + ')');
                    var series = { data: [] };
                    series.name = 'Leads';
                    series.type = 'column';
                    for (ld in obj){
                        var tdata = obj[ld];
                        chartOptions.xAxis.categories.push(tdata[0]);
                        series.data.push(parseFloat(tdata[1]));
                    }
                    chartOptions.series.push(series);
                    chart = new Highcharts.Chart(chartOptions);

                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
    
        }

    </script>
    <style type="text/css">
        .style1
        {
            text-align: right;
            width: 68px;
        }
        .style2
        {
            width: 175px;
        }
        .style3
        {
            width: 70px;
        }
        .style4
        {
            width: 100px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphPortalBody" runat="Server">
    <div>
        <ul class="breadcrumb">
            <li><a href="Default.aspx">Buyer Home</a></li>
            <li>Lead Summary</li>
        </ul>
    </div>
    <div style="clear:both;" />


    <div style="float:left; width:55%; position:relative">
    <div class="portlet">
        <div class="portlet-header">
            Lead Summary</div>
        <div class="portlet-content">
            <asp:UpdatePanel ID="upDefault" runat="server">
                <ContentTemplate>
                    <table style="width: 100%;;" border="0" class="filterBox">
                        <tr>
                            <td class="style1">
                                Range:</td>
                            <td align="left" class="style2">
                                <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                                </asp:DropDownList>
                            </td>
                            <td align="right" class="style4">
                                <div id="updateDiv" style="display: none;">
                                    <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                        alt="" />
                                    Loading ...</div>
                            </td>
                            <td align="right" style="width: 175px">
                                <small>
                                    <asp:LinkButton CssClass="jqButton" ID="lnkGetCounts" runat="server" Text="Filter"
                                        Style="float: right!important"  />
                             
                                </small>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                From:</td>
                            <td align="left" class="style2">
                                <asp:TextBox ID="txtFrom" runat="server" />
                            </td>
                            <td align="right" class="style4">
                                &nbsp;</td>
                            <td align="right" style="width: 175px">
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style1">
                                To:</td>
                            <td align="left" class="style2">
                                <asp:TextBox ID="txtTo" runat="server" />
                            </td>
                            <td align="right" class="style4">
                                &nbsp;</td>
                            <td align="right" style="width: 175px">
                                &nbsp;</td>
                        </tr>
                    </table>
                    <asp:GridView ID="gvLeadSummary" runat="server" DataSourceID="dsLeadSummary" Width="100%"
                        AllowSorting="True" AutoGenerateColumns="False" PageSize="15" CssClass="GridView"
                        AllowPaging="True" ShowFooter="true">
                        <HeaderStyle Height="30" />
                        <FooterStyle CssClass="footerRow" />
                        <Columns>
                            <asp:BoundField DataField="VerticalID" HeaderText="VerticalID" ReadOnly="True" SortExpression="VerticalID"
                                Visible="false" />
                            <asp:BoundField DataField="Offer" HeaderText="Offer" ReadOnly="True" SortExpression="Offer">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ContractName" HeaderText="Contract" ReadOnly="True" SortExpression="ContractName">
                                <HeaderStyle HorizontalAlign="Left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Left" CssClass="ui-widget-content" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Delivered" HeaderText="Delivered" ReadOnly="True" SortExpression="Delivered">
                                <HeaderStyle HorizontalAlign="Right" CssClass="ui-widget-header" />
                                <ItemStyle CssClass="ui-widget-content" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Total" HeaderText="Total" ReadOnly="True" SortExpression="Total" DataFormatString="{0:c2}">
                                <HeaderStyle HorizontalAlign="Right" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Right" CssClass="ui-widget-content" />
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
                                        Style="float: right!important"  OnClientClick="ExportExcel();" />
                                        </small>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsLeadSummary" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                        SelectCommand="stp_buyer_getLeadSummaryReport" SelectCommandType="StoredProcedure"
                        CancelSelectOnNullParameter="false">
                        <SelectParameters>
                            <asp:Parameter Name="userid" />
                            <asp:Parameter Name="from" />
                            <asp:Parameter Name="to" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    </div>
    <div style="float:left; width:45%; position:relative">
    <div class="portlet">
        <div class="portlet-header">
            Leads Per Day</div>
        <div class="portlet-content">
            <div style="padding: 3px;">
                <asp:DropDownList ID="ddlContracts" runat="server" DataSourceID="dsContracts" AppendDataBoundItems="true"
                    DataTextField="ContractName" DataValueField="BuyerOfferXrefID" Width="100%">
                    <asp:ListItem Text="All Contracts" Value="" />
                </asp:DropDownList>
                <asp:SqlDataSource ID="dsContracts" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                    SelectCommand="select BuyerOfferXrefID,ContractName  from tblBuyerOfferXref where (BuyerID = (SELECT UserTypeUniqueID from tblUser where UserId = @userid) OR (SELECT UserTypeid from tblUser where UserId = @userid)=1) order by ContractName">
                    <SelectParameters>
                        <asp:Parameter Name="userid" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div id="container" style="min-width: 400px; height: 350px; margin: 0 auto; text-align:center">
            </div>
        </div>
    </div>
    </div>

    
    
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
