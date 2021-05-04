<%@ Page Title="" Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false"
    CodeFile="reports.aspx.vb" Inherits="admin_checkscan_reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.19/themes/redmond/jquery-ui.css"
        rel="stylesheet" />
    <style type="text/css">
        .sideRollupCellBodyScan
        {
            border-bottom: rgb(112,168,209) 1px solid;
            border-left: rgb(112,168,209) 1px solid;
            border-right: rgb(112,168,209) 1px solid;
            padding-bottom: 5px;
        }
        .navCell
        {
            padding: 0px 5px 0px 5px;
        }
        .cellHdr
        {
            background-color: #DCDCDC;
            padding: 3px;
            height: 25px;
            color: #000;
        }
        .cellCnt
        {
            background-color: #F0E68C;
            padding: 3px;
        }
        .cellCntError
        {
            background-color: #FA8072;
            padding: 3px;
        }
        .cellHdrChild
        {
            background-color: #4791C5;
            padding: 3px;
            width: 75px;
            color: #fff;
        }
        .cellCntChild
        {
            background-color: #F0E18C;
            padding: 3px;
        }
        .totHdr
        {
            width: 100%;
            background-color: #F0E68C;
            text-align: center;
            font-weight: bold;
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .totCnt
        {
            text-align: center;
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .footerRow
        {
            font-weight: bold;
            background-color: Gray;
            height: 25px;
        }
    </style>
    <script type="text/javascript">
        var loadingImg = '<img src="../../images/loading.gif" alt="Loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                loadDialogs();

                loadButtons();

            });
        }
        function loadDialogs() {
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-checks").dialog({
                autoOpen: false,
                height: 575,
                width: 600,
                modal: true,
                stack: true,
                buttons: {
                    "Close": function () {
                        $(this).dialog('close');
                    }
                }
            });
            $("#dialog-check").dialog({
                autoOpen: false,
                height: 575,
                width: 600,
                modal: true,
                stack: true,
                buttons: {
                    "Close": function () {
                        $(this).dialog('close');
                    }
                }
            });
        }
        function loadButtons() {
            $(".jqButton").button();
            $(".jqViewButton").button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: false
            });
            $(".jqViewWithTextButton").button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: true
            });
            $(".jqViewReportButton").button({
                icons: {
                    primary: "ui-icon-print"
                },
                text: true
            });
        }

        function showChild(id, elem) {
            var cid = 'tr_child_' + id;
            var chd = document.getElementById(cid)
            chd.style.display = (chd.style.display != 'none' ? 'none' : '');
            if (chd.style.display == '') {
                elem.src = '../../images/minus.png';
            } else {
                elem.src = '../../images/plus.png';
            }
        }
        function ViewChecks(fhid) {
            $("#dialog-checks").dialog('open');
            $("#dialog-checks").html(loadingImg);

            var dArray = "{";
            dArray += "'fileheaderid': '" + fhid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "reports.aspx/getChecks",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $("#dialog-checks").html(response.d);
                },
                error: function (response) {
                    $("#dialog-checks").html(response.d);
                }
            });
            return false;
        }
        function ViewCheck(chkid) {
            $("#dialog-check").dialog('open');
            $("#dialog-check").html(loadingImg);

            var dArray = "{";
            dArray += "'checkid': '" + chkid + "'";
            dArray += "}";

            $.ajax({
                type: "POST",
                url: "reports.aspx/getCheck",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $("#dialog-check").html(response.d);
                },
                error: function (response) {
                    $("#dialog-check").html(response.d);
                }
            });
            return false;
        }
        
    </script>
    <ajaxToolkit:ToolkitScriptManager ID="smCheckScan" runat="server" EnablePageMethods="true"
        AsyncPostBackTimeout="360000">
        <Scripts>
              <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js"
                ScriptMode="Release" />
            <asp:ScriptReference Path="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.19/jquery-ui.min.js"
                ScriptMode="Release" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="smReports" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 200px!important; background-color: rgb(214,231,243); padding-top: 35px;"
                        valign="top">
                        <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                            cellspacing="0" border="0">
                            <tr>
                                <td style="padding: 10 15 20 15;">
                                    <asp:Panel ID="Panel2" runat="server" CssClass="sideRollupCellHeader" Height="30px"
                                        Width="200px">
                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                            <div style="float: left;">
                                                Navigation</div>
                                            <div style="float: right; vertical-align: middle;">
                                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/expand.png"
                                                    AlternateText="(Show Links...)" />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="Panel1" runat="server" CssClass="sideRollupCellBodyScan" Width="200px">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="navCell">
                                                    <a href="checksready.aspx" class="lnk">View Checks Ready for Processing</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <a href="checksprocessed.aspx" class="lnk">View Checks Processed</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <a href="default.aspx" class="lnk">Scan Checks</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <br />
                                    <asp:Panel ID="pnlNavHdr" runat="server" CssClass="sideRollupCellHeader" Height="30px"
                                        Width="200px">
                                        <div style="padding: 5px; cursor: pointer; vertical-align: middle;">
                                            <div style="float: left;">
                                                Common Tasks</div>
                                            <div style="float: right; vertical-align: middle;">
                                                <asp:ImageButton ID="imgHeader" runat="server" ImageUrl="~/images/expand.png" AlternateText="(Show Links...)" />
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlNavContent" runat="server" CssClass="sideRollupCellBodyScan" Width="200px">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="navCell">
                                                    <span style="font-weight: bold; font-size: 12px;">Range:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:DropDownList ID="ddlRange" runat="server" AutoPostBack="true" CssClass="entry">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <span style="font-weight: bold; font-size: 12px;">From:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:TextBox ID="txtFrom" runat="server" CssClass="entry" />
                                                    <ajaxToolkit:CalendarExtender ID="txtFrom_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="txtFrom" CssClass="MyCalendar">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <span style="font-weight: bold; font-size: 12px;">To:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <asp:TextBox ID="txtTo" runat="server" CssClass="entry" />
                                                    <ajaxToolkit:CalendarExtender ID="txtTo_CalendarExtender1" runat="server" Enabled="True"
                                                        TargetControlID="txtTo" CssClass="MyCalendar">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px; text-align: center;">
                                                    <asp:LinkButton ID="lnkView" CssClass="jqViewWithTextButton" runat="server" Text="View Data" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <div style="padding: 10px;" class="entry" id="divCheckScan">
                            <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/">Admin</a>&nbsp>&nbsp;
                                        <a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/checkscan/default.aspx">
                                            Scan Checks</a>&nbsp>&nbsp;Reports
                                    </td>
                                </tr>
                                <tr valign="top">
                                    <td style="padding: 15px 0 0 0;">
                                        <ajaxToolkit:TabContainer ID="tcICL" runat="server" CssClass="tabContainer">
                                            <ajaxToolkit:TabPanel ID="tpDash" runat="server">
                                                <HeaderTemplate>
                                                    Dashboard</HeaderTemplate>
                                                <ContentTemplate>
                                                    <div class="entry" style="padding: 10px;">
                                                        <div class="ui-widget">
                                                            <div class="ui-widget-content">
                                                                <p>Acceptance Rate : <asp:Label ID="lblAcceptedPct" runat="server" /> </p>
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <asp:GridView ID="gvSummary" runat="server" AllowPaging="True" AllowSorting="True"
                                                                CssClass="entry" AutoGenerateColumns="False" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;padding:15px;'>Summary</div>"
                                                                DataSourceID="dsSummary" PageSize="25" ShowFooter="true" BorderStyle="None" EnableModelValidation="True">
                                                                <Columns>
                                                                    <asp:BoundField DataField="RECStatus" HeaderText="REC Status" SortExpression="RECStatus">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="left" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="left" />
                                                                        <FooterStyle CssClass="footerRow" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Total Files" HeaderText="Total Files" SortExpression="Total Files">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalRECItems" HeaderText="Total REC Items" SortExpression="TotalRECItems">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalRecAmount" HeaderText="Total REC Amount" ReadOnly="True"
                                                                        SortExpression="TotalRecAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="Right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="ACKStatus" HeaderText="ACK Status" SortExpression="ACKStatus">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="left" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="left" />
                                                                        <FooterStyle CssClass="footerRow" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAckItems" HeaderText="Total ACK Items" SortExpression="TotalAckItems">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAckAmount" HeaderText="Total ACK Amount" ReadOnly="True"
                                                                        SortExpression="TotalAckAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="Right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAdjusted" HeaderText="Total Adjusted Items" ReadOnly="True"
                                                                        SortExpression="TotalAdjusted">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAdjustedAmount" HeaderText="Total Adjusted Amount"
                                                                        ReadOnly="True" SortExpression="TotalAdjustedAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAccepted" HeaderText="Total Accepted Items" ReadOnly="True"
                                                                        SortExpression="TotalAccepted">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAcceptedAmount" HeaderText="Total Accepted Amount"
                                                                        ReadOnly="True" SortExpression="TotalAcceptedAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                </Columns>
                                                                <HeaderStyle Height="25px" />
                                                            </asp:GridView>
                                                            <asp:SqlDataSource ID="dsSummary" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                ProviderName="System.Data.SqlClient" SelectCommand="stp_Checkscan_Summary" SelectCommandType="StoredProcedure">
                                                            </asp:SqlDataSource>
                                                        </div>
                                                        <br />
                                                        <div>
                                                            <asp:GridView ID="gvDetail" runat="server" AllowPaging="True" AllowSorting="True"
                                                                CssClass="entry" AutoGenerateColumns="False" Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;padding:15px;'>Detail</div>"
                                                                DataSourceID="dsDetail" PageSize="10" ShowFooter="true" BorderStyle="None" EnableModelValidation="True">
                                                                <Columns>
                                                                    <asp:BoundField DataField="RECStatus" HeaderText="REC Status" SortExpression="RECStatus">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                        <FooterStyle CssClass="footerRow" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                                                        DataFormatString="{0:MM/dd/yyyy}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" Width="75" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" Width="75" />
                                                                        <FooterStyle CssClass="footerRow" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalRECItems" HeaderText="Total REC Items" ReadOnly="True"
                                                                        SortExpression="TotalRECItems">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalRECAmount" HeaderText="Total REC Amount" ReadOnly="True"
                                                                        SortExpression="TotalRECAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="ACKStatus" HeaderText="ACKStatus" SortExpression="ACKStatus">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                                        <FooterStyle CssClass="footerRow" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAckItems" HeaderText="Total ACK Items" ReadOnly="True"
                                                                        SortExpression="TotalAckItems">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAckAmount" HeaderText="Total ACK Amount" ReadOnly="True"
                                                                        SortExpression="TotalAckAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAdjusted" HeaderText="Total Adjusted Items" ReadOnly="True"
                                                                        SortExpression="TotalAdjusted">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAdjustedAmount" HeaderText="Total Adjusted Amount"
                                                                        ReadOnly="True" SortExpression="TotalAdjustedAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAccepted" HeaderText="Total Accepted Items" ReadOnly="True"
                                                                        SortExpression="TotalAccepted">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField DataField="TotalAcceptedAmount" HeaderText="Total Accepted Amount"
                                                                        ReadOnly="True" SortExpression="TotalAcceptedAmount" DataFormatString="{0:c2}">
                                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                                        <FooterStyle CssClass="footerRow" HorizontalAlign="right" />
                                                                    </asp:BoundField>
                                                                    
                                                                </Columns>
                                                                <HeaderStyle Height="25px" />
                                                            </asp:GridView>
                                                            <asp:SqlDataSource ID="dsDetail" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                ProviderName="System.Data.SqlClient" SelectCommand="stp_Checkscan_Detail" SelectCommandType="StoredProcedure">
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="tpicl" runat="server">
                                                <HeaderTemplate>
                                                    ICL Status</HeaderTemplate>
                                                <ContentTemplate>
                                                    <div id="tabicl">
                                                        <div id="reportholder" runat="server" style="padding: 5px;">
                                                            <div id="divNoICL" runat="server" class="info">
                                                                No ICL's Sent!</div>
                                                            <div id="tblICL" runat="server">
                                                                <table class="entry" cellpadding="0" cellspacing="0">
                                                                    <asp:Repeater ID="rptICL" runat="server" DataSourceID="dsICL">
                                                                        <HeaderTemplate>
                                                                            <tr>
                                                                                <th class="cellHdrChild" style="width: 15px;">
                                                                                    &nbsp;
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left" style="width: 50px; display: none">
                                                                                    File<br />
                                                                                    Header<br />
                                                                                    ID
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left">
                                                                                    Created
                                                                                </th>
                                                                                <th class="cellHdrChild" align="center">
                                                                                    Customer<br />ID
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left">
                                                                                    X9.37<br /> File Name
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left">
                                                                                    File<br />
                                                                                    Creation<br />
                                                                                    Date
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left">
                                                                                    File<br />
                                                                                    Creation<br />
                                                                                    Time
                                                                                </th>
                                                                                <th class="cellHdrChild" align="center">
                                                                                    Resend Indicator
                                                                                </th>
                                                                                <th class="cellHdrChild" align="center" style="display: none">
                                                                                    File ID Modifier
                                                                                </th>
                                                                                <th class="cellHdrChild" align="left">
                                                                                    File Validation Status
                                                                                </th>
                                                                            </tr>
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <tr>
                                                                                <td class="cellHdr" style="width: 15px;">
                                                                                    <img onmouseover="this.style.cursor='pointer';" src="../../images/plus.png" onclick="showChild('<%#Eval("FileHeaderId")%>',this);" />
                                                                                </td>
                                                                                <td class="cellCntChild" align="left" style="width: 50px; display: none">
                                                                                    <%#Eval("FileHeaderId")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="left">
                                                                                    <%#Eval("Created")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="center">
                                                                                    <%#Eval("CustomerID")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="left">
                                                                                    <%#Eval("FileName")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="left">
                                                                                    <%#Eval("FileCreationDate")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="left">
                                                                                    <%#Eval("FileCreationTime")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="center">
                                                                                    <%#Eval("ResendIndicator")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="center" style="display: none">
                                                                                    <%#Eval("FileIDModifier")%>
                                                                                </td>
                                                                                <td class="cellCntChild" align="left" id="tdStatus" runat="server">
                                                                                    <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("FileValidationStatus")%>'
                                                                                        Font-Bold="true" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr id="tr_child_<%#Eval("FileHeaderId")%>" style="display: none;">
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td colspan="9">
                                                                                    <div style="padding: 10px;">
                                                                                        <asp:GridView ID="gvRecDetail" runat="server" AutoGenerateColumns="False" DataKeyNames="FileDetailId"
                                                                                            DataSourceID="dsRecDetail" Style="width: 95%!important" CssClass="entry" Caption="<div style='font-weight: bold;background-color:#000;color:white;'>Receipt Detail</div>">
                                                                                            <Columns>
                                                                                                <asp:BoundField DataField="FileDetailId" HeaderText="File Detail Id" InsertVisible="False"
                                                                                                    ReadOnly="True" SortExpression="FileDetailId" Visible="false">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="center" Width="75" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="center" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileRejectReasonCatagories" HeaderText="File Reject Reason Catagories"
                                                                                                    SortExpression="FileRejectReasonCatagories">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" Width="175" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" Width="175" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileRejectReason" HeaderText="File Reject Reason" SortExpression="FileRejectReason">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                            </Columns>
                                                                                            <EmptyDataTemplate>
                                                                                                <div class="success">
                                                                                                    File received successfuly!</div>
                                                                                            </EmptyDataTemplate>
                                                                                        </asp:GridView>
                                                                                        <asp:SqlDataSource ID="dsRecDetail" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                                            ProviderName="System.Data.SqlClient" SelectCommand="SELECT fd.FileDetailId, fd.FileRejectReasonCatagories, da.FileRejectReason FROM [WA].dbo.tblICLRECFileDetail_06 fd inner JOIN [WA].dbo.tblICLRECDetailAddendum_07 da ON fd.FileDetailId = da.FileDetailID where FileHeaderId =@FileHeaderId and isnull(FileRejectReasonCatagories,'') <> ''">
                                                                                            <SelectParameters>
                                                                                                <asp:Parameter Name="FileHeaderId" />
                                                                                            </SelectParameters>
                                                                                        </asp:SqlDataSource>
                                                                                    </div>
                                                                                    <div style="padding: 10px;">
                                                                                        <asp:GridView ID="gvACKChild" runat="server" AutoGenerateColumns="False" DataKeyNames="FileHeaderId"
                                                                                            DataSourceID="dsAckChild" AllowPaging="false" AllowSorting="false" CssClass="entry"
                                                                                            OnRowDataBound="gvAck_RowDataBound" Style="width: 95%!important" Caption="<div style='font-weight: bold;background-color:#000;color:white;'>Acknowledgement File Detail</div>">
                                                                                            <EmptyDataTemplate>
                                                                                                <div class="error">
                                                                                                    No Acknowledgement File!</div>
                                                                                            </EmptyDataTemplate>
                                                                                            <Columns>
                                                                                                <asp:BoundField DataField="FileHeaderId" HeaderText="FileHeaderId" InsertVisible="False"
                                                                                                    ReadOnly="True" SortExpression="FileHeaderId" Visible="false">
                                                                                                    <HeaderStyle CssClass="cellHdr" />
                                                                                                    <ItemStyle CssClass="cellCnt" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="CustomerID" HeaderText="Customer ID" SortExpression="CustomerID"
                                                                                                    Visible="false">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileName" HeaderText="File Name" SortExpression="FileName">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileCreationDate" HeaderText="File Creation Date" SortExpression="FileCreationDate">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileCreationTime" HeaderText="File Creation Time" SortExpression="FileCreationTime">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="ResendIndicator" HeaderText="Resend Indicator" SortExpression="ResendIndicator">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Center" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Center" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileIDModifier" HeaderText="File ID Modifier" SortExpression="FileIDModifier"
                                                                                                    Visible="false">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Center" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="Center" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileValidationStatus" HeaderText="File Validation Status"
                                                                                                    SortExpression="FileValidationStatus">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="left" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:TemplateField>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:LinkButton ID="lnkViewChecks" runat="server" Text="View Checks" OnClientClick='<%# String.Format("javascript:return ViewChecks(""{0}"")", Eval("fileheaderid").ToString()) %>' />
                                                                                                    </ItemTemplate>
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="center" />
                                                                                                    <ItemStyle CssClass="cellCnt" HorizontalAlign="center" />
                                                                                                </asp:TemplateField>
                                                                                            </Columns>
                                                                                        </asp:GridView>
                                                                                        <asp:SqlDataSource ID="dsAckChild" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                                            ProviderName="System.Data.SqlClient" SelectCommand="SELECT FileHeaderId, Created, CustomerID, FileName, FileCreationDate, FileCreationTime,ResendIndicator, FileIDModifier, FileValidationStatus FROM WA.dbo.tblICLACKFileHeader_01 WHERE (filename = @FileName) ORDER BY Created DESC">
                                                                                            <SelectParameters>
                                                                                                <asp:Parameter Name="filename" />
                                                                                            </SelectParameters>
                                                                                        </asp:SqlDataSource>
                                                                                    </div>
                                                                                    <div style="padding: 10px;">
                                                                                        <asp:GridView ID="gvAckAdj" runat="server" AutoGenerateColumns="False" DataKeyNames="FileHeaderId"
                                                                                            DataSourceID="dsAckAdj" CssClass="entry" Style="width: 95%!important" Caption="<div style='font-weight: bold;background-color:#000;color:white;'>Acknowledgement File Adjustments</div>"
                                                                                            EnableModelValidation="True">
                                                                                            <EmptyDataTemplate>
                                                                                                <div class="success">
                                                                                                    All Checks Accepted, No Acknowledgement Adjustments!</div>
                                                                                            </EmptyDataTemplate>
                                                                                            <RowStyle BackColor="LightSalmon" />
                                                                                            <Columns>
                                                                                                <asp:BoundField DataField="FileHeaderId" HeaderText="FileHeaderId" InsertVisible="False"
                                                                                                    ReadOnly="True" SortExpression="FileHeaderId" Visible="false">
                                                                                                    <HeaderStyle CssClass="cellHdr" />
                                                                                                    <ItemStyle CssClass="cellCntError" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FileName" HeaderText="File Name" SortExpression="FileName">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCntError" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="ItemSequenceNumber" HeaderText="ItemSequenceNumber" SortExpression="ItemSequenceNumber">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCntError" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="ItemErrorReason" HeaderText="ItemErrorReason" SortExpression="ItemErrorReason">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="Left" />
                                                                                                    <ItemStyle CssClass="cellCntError" HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="AdjustmentReasonDetail" HeaderText="AdjustmentReasonDetail"
                                                                                                    SortExpression="AdjustmentReasonDetail">
                                                                                                    <HeaderStyle CssClass="cellHdr" HorizontalAlign="left" />
                                                                                                    <ItemStyle CssClass="cellCntError" HorizontalAlign="left" />
                                                                                                </asp:BoundField>
                                                                                            </Columns>
                                                                                        </asp:GridView>
                                                                                        <asp:SqlDataSource ID="dsAckAdj" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                                            ProviderName="System.Data.SqlClient" SelectCommand="SELECT fh.FileHeaderId, fh.FileName, ia.ItemSequenceNumber, ia.ItemErrorReason, ida.AdjustmentReasonDetail FROM WA.dbo.tblICLACKFileHeader_01 AS fh LEFT OUTER JOIN WA.dbo.tblICLACKCashLetterHeader_10 AS clh ON fh.FileHeaderId = clh.FileHeaderID LEFT OUTER JOIN WA.dbo.tblICLACKFileControl_99 AS fc ON fh.FileHeaderId = fc.FileHeaderID LEFT OUTER JOIN WA.dbo.tblICLACKCashLetterControl_90 AS clc ON clh.CashLetterHeaderId = clc.CashLetterHeaderID LEFT OUTER JOIN WA.dbo.tblICLACKItemAdjustmentDetail_25 AS ia ON clh.CashLetterHeaderId = ia.CashLetterHeaderID LEFT OUTER JOIN WA.dbo.tblICLACKItemDetailAddendum_26 AS ida ON ia.ItemAdjustmentDetailId = ida.ItemAdjustmentDetailID WHERE (fh.FileHeaderId = @FileHeaderId) and ItemSequenceNumber is not NULL ORDER BY fh.Created DESC">
                                                                                            <SelectParameters>
                                                                                                <asp:Parameter Name="fileheaderid" />
                                                                                            </SelectParameters>
                                                                                        </asp:SqlDataSource>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </table>
                                                                <asp:SqlDataSource ID="dsICL" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    ProviderName="System.Data.SqlClient" SelectCommand="SELECT distinct FileHeaderId, convert(varchar, Created, 100) [Created], CustomerID, FileName, FileCreationDate, FileCreationTime, ResendIndicator, FileIDModifier, FileValidationStatus FROM WA.dbo.tblICLRECFileHeader_05 WHERE (Created BETWEEN @start AND @end) ORDER BY convert(varchar, Created, 100)  DESC">
                                                                    <SelectParameters>
                                                                        <asp:Parameter Name="start" />
                                                                        <asp:Parameter Name="end" />
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                        </ajaxToolkit:TabContainer>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="hidLastTab" runat="server" Value="0" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-checks">
    </div>
    <div id="dialog-check">
    </div>
</asp:Content>
