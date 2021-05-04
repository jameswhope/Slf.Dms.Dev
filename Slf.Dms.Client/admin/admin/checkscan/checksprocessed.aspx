<%@ Page Title="" Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false"
    CodeFile="checksprocessed.aspx.vb" Inherits="admin_checkscan_checksprocessed" %>

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
            $(".btnBar").buttonset();
            $(".jqButton").button();
            $(".jqViewButton").button({
                icons: {
                    primary: "ui-icon-search"
                },
                text: false
            });
            $(".jqRejectButton").button({
                icons: {
                    primary: "ui-icon-cancel"
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
        function ReturnCheck(chkid,reason) {

            if (confirm('Are you sure you want to reverse the charges?')){
                var dArray = "{";
                dArray += "'checkid': '" + chkid + "',";
                dArray += "'reason': '" + reason + "'";
                dArray += "}";

                $.ajax({
                    type: "POST",
                    url: "checksprocessed.aspx/ReturnCheck",
                    data: dArray,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: true,
                    success: function (response) {
                        showMsg(response.d,false);
                    },
                    error: function (response) {
                        showMsg(response.responseText, true);
                    }
                });
            }
            return false;
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
        function showMsg(msgtext, bSticky) {
            var dv = document.getElementById('<%=dvMsg.ClientID %>');
            dv.style.display = 'block';
            dv.innerHTML = msgtext;

            bSticky = (typeof bSticky === "undefined") ? true : bSticky;
            if (bSticky == false) {
                $('#<%=dvMsg.ClientID %>').delay(5000).fadeOut(1000)
            }

        }
    </script>
    <ajaxToolkit:ToolkitScriptManager ID="smCheckScan" runat="server" EnablePageMethods="true"
        AsyncPostBackTimeout="360000">
        <Scripts>
            <asp:ScriptReference Path="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.2.min.js"
                ScriptMode="Release" />
            <asp:ScriptReference Path="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.19/jquery-ui.min.js"
                ScriptMode="Release" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="smReports" runat="server">
        <ContentTemplate>
            <div id="pageMSG" runat="server" style="padding:50px;"></div>
            <table id="pageCNT" runat="server" style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
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
                                                    <a href="reports.aspx" class="lnk">View ICL Reports</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="navCell">
                                                    <a href="checksready.aspx" class="lnk">View Checks Ready for Processing</a>
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
                                     <div id="dvMsg" runat="server" style="display: none; vertical-align: top; padding: 5px;
                                            width: 100%!important; min-height: 50px">
                                        </div>
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
                                            Scan Checks</a>&nbsp>&nbsp;Checks Processed
                                    </td>
                                </tr>
                                <tr valign="top">
                                    <td style="padding: 15px 0 0 0;">
                                        <div id="taball">
                                            <asp:GridView ID="gvAllChecks" runat="server" AllowPaging="True" AllowSorting="True"
                                                CssClass="entry" AutoGenerateColumns="False" DataSourceID="dsAllChecks" PageSize="20"
                                                BorderStyle="None" EnableModelValidation="True">
                                                <HeaderStyle Height="25" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="No">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblRowNum" runat="server" Text='<%# Container.DataItemIndex + 1 %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="20px" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="20px"/>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="ProcessingRegisterId" HeaderText="ProcessingRegisterId"
                                                        InsertVisible="False" ReadOnly="True" SortExpression="ProcessingRegisterId" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="RegisterID" HeaderText="RegisterID" SortExpression="RegisterID"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Check21ID" HeaderText="Check21ID" InsertVisible="False"
                                                        ReadOnly="True" SortExpression="Check21ID" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ClientID" HeaderText="ClientID" InsertVisible="False"
                                                        ReadOnly="True" SortExpression="ClientID" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Client Name" SortExpression="ClientName">
                                                        <ItemTemplate>
                                                        <asp:LinkButton ID="lnkClientName" runat="server" OnClick="lnkClientName_Click"
                                                         Text='<%# Bind("ClientName") %>' />
                                                        </ItemTemplate>
                                                       
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="175" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="175" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="CheckType" HeaderText="Check Type" SortExpression="CheckType"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckRouting" HeaderText="Routing" SortExpression="CheckRouting">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckAccountNum" HeaderText="Account #" SortExpression="CheckAccountNum">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckNumber" HeaderText="Check #" SortExpression="CheckNumber"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckAmount" HeaderText="Amount" SortExpression="CheckAmount"
                                                        DataFormatString="{0:c2}">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="right" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="right" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Verified" HeaderText="Verified" SortExpression="Verified"
                                                        DataFormatString="{0:d}" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="VerifiedBy" HeaderText="VerifiedBy" SortExpression="VerifiedBy"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="VerifiedByName" HeaderText="Verified By" ReadOnly="True"
                                                        SortExpression="VerifiedByName" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Processed" HeaderText="Processed" SortExpression="Processed"
                                                        DataFormatString="{0:d}">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ProcessedBy" HeaderText="ProcessedBy" SortExpression="ProcessedBy"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ProcessedByName" HeaderText="Processed By" ReadOnly="True"
                                                        SortExpression="ProcessedByName">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ICLFileName" HeaderText="ICLFileName" SortExpression="ICLFileName"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckFrontPath" HeaderText="CheckFrontPath" SortExpression="CheckFrontPath"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CheckBackPath" HeaderText="CheckBackPath" SortExpression="CheckBackPath"
                                                        Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ProcessStatus" HeaderText="Process Status" SortExpression="ProcessStatus">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="250" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="250" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="MissingProcessingRegisterID" HeaderText="MissingProcessingRegisterID"
                                                        ReadOnly="True" SortExpression="MissingProcessingRegisterID" Visible="false">
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Missing Register ID" SortExpression="MissingProcessingRegisterID">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkMissing" runat="server" Enabled="false" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <div class="btnBar">
                                                            <small>
                                                                <asp:LinkButton style="float:right" ID="lnkViewCheck" CssClass="jqViewButton" runat="server" Text="View Check"
                                                                    OnClientClick='<%# String.Format("javascript:return ViewCheck(""{0}"")", Eval("check21id").ToString()) %>' />
                                                                <asp:LinkButton style="float:right"  ID="lnkRejectCheck" CssClass="jqRejectButton" runat="server" Text="Reject Check"
                                                                    OnClientClick='<%# String.Format("javascript:return ReturnCheck(""{0}"")", Eval("check21id").ToString()) %>' ToolTip="Reverse charges to client account." />

                                                            </small>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem5" HorizontalAlign="center" Width="50" />
                                                        <ItemStyle CssClass="listItem" HorizontalAlign="center" Width="50"/>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <div class="info">
                                                        No Checks Processed!</div>
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                            <asp:SqlDataSource ID="dsAllChecks" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                ProviderName="System.Data.SqlClient" SelectCommand="stp_Checkscan_getAllChecksProcessed"
                                                SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:Parameter Name="from" />
                                                    <asp:Parameter Name="to" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
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
