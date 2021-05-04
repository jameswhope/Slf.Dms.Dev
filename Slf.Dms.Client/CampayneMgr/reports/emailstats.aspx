<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="emailstats.aspx.vb" Inherits="reports_emailstats" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .column
        {
            width: 20%;
            float: left;
            padding-bottom: 10px;
        }
        .wide
        {
            min-width: 50%;
        }
        .rightcol
        {
            min-width: 30%;
        }
    </style>
    <script type="text/javascript">
        //initial jquery stuff
        var chart_sent;
        var chart_returned;
        var chart_stats;
        var chart_hist;
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                $(".jqButton").button();
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
                loadStatChart();
                getDailyBreakDown();
                getDailyBySite();
                $("#<%= txtDate1.ClientID %>").datepicker({
                    showOn: "button",
                    buttonImage: '<%=resolveurl("../images/16x16_calendar.png") %>',
                    buttonImageOnly: true
                });
            });
        }
        function reloadCharts() {
            loadStatChart();
            getDailyBreakDown();
            getDailyBySite();
            return false;
        }
        function getDailyBySite() {
            $("#bysite-grid").html(loadingImg);
            var rdate = $("*[id$='txtDate1']").val();
            $.ajax({
                type: "POST",
                dataType: "json",
                data: "{'reportingdate': '" + rdate + "'}",
                contentType: "application/json; charset=utf-8",
                url: "emailstats.aspx/GetDailyBySite",
                success: function (response) {
                    $("#bysite-grid").html(response.d);
                },
                cache: false,
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });

        }
        function getDailyBreakDown() {
            $("#stat-grid").html(loadingImg);
            var rdate = $("*[id$='txtDate1']").val();
            $.ajax({
                type: "POST",
                dataType: "json",
                data: "{'reportingdate': '" + rdate + "'}",
                contentType: "application/json; charset=utf-8",
                url: "emailstats.aspx/GetDailyBreakDown",
                success: function (response) {
                    $("#stat-grid").html(response.d);
                },
                cache: false,
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });

        }
        function loadStatChart() {

            $("#pie_sent").html(loadingImg);
            $("#pie_returned").html(loadingImg);
            $("#stat_bar").html(loadingImg);

            var sentOptions = {
                chart: {
                    renderTo: 'pie_sent',
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: null
                },
                tooltip: {
                    formatter: function () {
                        return '<b>' + this.point.name + '</b><br/>Sent: ' + this.y;
                    }
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: []
            };
            var returnOptions = {
                chart: {
                    renderTo: 'pie_returned',
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false
                },
                title: {
                    text: null
                },
                tooltip: {
                    formatter: function () {
                        return '<b>' + this.point.name + '</b><br/>Returned: ' + this.y;
                    }
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: []
            };
            var options = {
                chart: {
                    renderTo: 'stat_bar',
                    type: 'column'
                },
                title: {
                    text: 'Email Statistics'
                },
                xAxis: {

                    labels: {
                        rotation: -45,
                        align: 'right',
                        style: {
                            font: 'normal 13px Verdana, sans-serif'
                        }
                    },
                    categories: []
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: 'Total emails sent'
                    },
                    stackLabels: {
                        enabled: true,
                        style: {
                            fontWeight: 'bold',
                            color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                        }
                    }
                },
                legend: {
                    align: 'right',
                    x: -100,
                    verticalAlign: 'top',
                    y: 20,
                    floating: true,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
                    borderColor: '#CCC',
                    borderWidth: 1,
                    shadow: false
                },
                tooltip: {
                    formatter: function () {
                        return '<b>' + this.x + '</b><br/>' +
					this.series.name + ': ' + this.y + '<br/>';
                    }
                },
                plotOptions: {
                    column: {
                        dataLabels: {
                            enabled: true,
                            color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                        }
                    }

                },
                series: []
            };

            var rdate = $("*[id$='txtDate1']").val();

            $.ajax({
                type: "POST",
                dataType: "json",
                data: "{'reportingdate': '" + rdate + "'}",
                contentType: "application/json; charset=utf-8",
                url: "emailstats.aspx/GetEmailStatisticsChartData",
                success: function (response) {
                    var obj = eval('(' + response.d + ')');
                    var cats = obj[0].replace('Categories:', '');
                    var cat = cats.split(',');
                    for (od in cat) {
                        options.xAxis.categories.push(cat[od]);
                    }

                    var series = { data: [] };
                    series.name = 'Total Sent';
                    series.type = 'column';
                    var totSent = obj[1].replace('TotalSent:', '');
                    var totS = totSent.split(',');
                    for (od in totS) {
                        series.data.push(parseFloat(totS[od]));
                    }
                    options.series.push(series);

                    var series = { data: [] };
                    series.type = 'pie';
                    series.name = 'Total Sent';
                    for (od in totS) {
                        series.data.push(new Array(cat[od], parseFloat(totS[od])));
                    }
                    sentOptions.series.push(series);

                    var series = { data: [] };
                    series.name = 'Total Returned';
                    series.type = 'column';
                    var totReturned = obj[2].replace('TotalReturned:', '');
                    var totR = totReturned.split(',');
                    for (od in totR) {
                        series.data.push(parseFloat(totR[od]));
                    }
                    options.series.push(series);

                    var series = { data: [] };
                    series.type = 'pie';
                    series.name = 'Total Returned';
                    for (od in totR) {
                        series.data.push(new Array(cat[od], parseFloat(totR[od])));
                    }
                    returnOptions.series.push(series);


                    //                    var series = { data: [] };
                    //                    series.type = 'spline';
                    //                    series.name = 'Return %';
                    //                    series.yaxis = 1;
                    //                    var totPer = obj[3].replace('ReturnPct:', '');
                    //                    var totP = totPer.split(',');
                    //                    for (od in totP) {
                    //                        series.data.push(new Array(cat[od], parseFloat(totP[od])));
                    //                    }
                    //                    options.series.push(series);


                    chart_stats = new Highcharts.Chart(options);
                    chart_sent = new Highcharts.Chart(sentOptions);
                    chart_returned = new Highcharts.Chart(returnOptions);
                },
                cache: false,
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });

        }

        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

  <div style="float: left; padding: 0px 3px 3px 3px">
        Reports > Email Stats
    </div>

<br style="clear: both" />
<div class="portlet">
<div class="portlet-content">
    <table style="width: 100%">
        <tr>
            <td>
               
            </td>
            <td align="right">
                
            </td>
        </tr>
    </table>
    <div style="margin: 5px;">

        <div class="column">
            <div class="portlet">
                <div class="portlet-header">
                    Emails Sent By Site</div>
                <div class="portlet-content">
                    <div id="pie_sent" style="width: 100%; height: 275px">
                    </div>
                </div>
            </div>
            <div class="portlet">
                <div class="portlet-header">
                    Emails Returned By Site</div>
                <div class="portlet-content">
                    <div id="pie_returned" style="width: 100%; height: 275px">
                    </div>
                </div>
            </div>
        </div>
        <div class="wide column">
            <div class="portlet">
                <div class="portlet-header">
                    Statistics</div>
                <div class="portlet-content">
                    <div id="stat_bar" style="width: 100%; height: 400px">
                    </div>
                </div>
            </div>
        </div>
        <div class="rightcol column">
        <div class="portlet">
                <div class="portlet-header">
                    Date Selection</div>
                <div class="portlet-content">
                    <table style="width:100%;"  border="0">
                    <tr>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="5" MaxLength="10" Width="90%"></asp:TextBox>
                        </td>
                        <td style="width:75px;">
                            <small>
                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" Font-Size="8pt" CssClass="jqButton"
                                    OnClientClick="return reloadCharts();" />
                            </small>
                        </td>
                    </tr>
                </table>
                </div>
            </div>
            <div class="portlet">
                <div class="portlet-header">
                    Today By Site</div>
                <div class="portlet-content">
                    <div id="bysite-grid" style="width: 100%;">
                    </div>
                </div>
            </div>
            <div class="portlet">
                <div class="portlet-header">
                    Past 7-Days</div>
                <div class="portlet-content">
                    <div id="stat-grid" style="width: 100%;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnStartDate" runat="server" />
    </div>
</div>
</asp:Content>
