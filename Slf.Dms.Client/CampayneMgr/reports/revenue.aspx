<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="revenue.aspx.vb" Inherits="reports_revenue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
                $(".jqButton").button();
                $(".jqRefreshButton").button({
                    icons: {
                        primary: "ui-icon-refresh"
                    },
                    text: false
                });
                $(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: false
                });
                $(".jqCloseButton").button({
                    icons: {
                        primary: "ui-icon-close"
                    },
                    text: false
                });
                $("#dialog-campaigns").dialog({
                    autoOpen: false,
                    width: 750,
                    modal: true,
                    position: [30, 30]
                });
                $("#dialog-subids").dialog({
                    autoOpen: false,
                    width: 800,
                    modal: true,
                    position: [45, 45]
                });
                $("#dialog-online").dialog({
                    autoOpen: false,
                    width: 750,
                    modal: true,
                    position: [30, 30]
                });
                $("#dialog-onlinesrc").dialog({
                    autoOpen: false,
                    width: 750,
                    modal: true,
                    position: [45, 45]
                });
                $("#dialog-corporate").dialog({
                    autoOpen: false,
                    width: 750,
                    modal: true,
                    position: [30, 30]
                });
                $("#btnSaveCampaigns").click(function () {
                     $("*[id$='gvCampaigns'] tr").not(':first').not(':last').each(function (index, row) {
                        var campaignid = row.cells(0).innerText;
                        var ppc = $(this).find('#txtPPC')[0].value;
                        var curppc = $(this).find('#hdnCurPPC')[0].value;

                        if (ppc != curppc) {
                            var dArray = "{'CampaignID': '" + campaignid + "',";
                            dArray += "'Paid': '" + ppc + "',";
                            dArray += "'RevDate': '" + $("*[id$='txtDate1']").val() +"'}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/UpdateCampaignPrice",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true
                            });
                        }
                    });
                    $().toastmessage('showSuccessToast', 'Changes saved.');
                    $("#dialog-corporate").dialog("close");
                });
                $("#btnSaveSubIds").click(function() {
                    $("*[id$='gvSubIds'] tr").not(':first').not(':last').each(function (index, row) {
                        var campaignid = row.cells(0).innerText;
                        var subid = row.cells(2).innerText;
                        var addclicks = $(this).find('#txtAddClick')[0].value;
                        var addconv = $(this).find('#txtAddConv')[0].value;
                        var paid = row.cells(8).innerText;

                        if (addclicks != 0 || addconv != 0) {
                            var dArray = "{'CampaignID': '" + campaignid + "',";
                            dArray += "'SrcCampaignID': '100',";
                            dArray += "'RevDate': '" + $("*[id$='txtDate1']").val() +"',";
                            dArray += "'NumClicks': '" + addclicks + "',";
                            dArray += "'NumConversions': '" + addconv + "',";
                            dArray += "'Paid': '" + paid + "',";
                            dArray += "'SubID1': '" + subid + "'}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/UpdateClicksConversions",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true
                            });
                        }
                    });
                    $().toastmessage('showSuccessToast', 'Changes saved.');
                    RefreshSubIds();
                });
                $("#btnSaveOnlineSrc").click(function() {
                    $("*[id$='gvOnlineSrc'] tr").not(':first').not(':last').each(function (index, row) {
                        var srccampaignid = row.cells(0).innerText;
                        var campaignid = $("#dialog-onlinesrc").data('campaignid');
                        var addclicks = $(this).find('#txtAddClick')[0].value;
                        var addconv = $(this).find('#txtAddConv')[0].value;
                        var paid = 0; //row.cells(6).innerText;

                        if (addclicks != 0 || addconv != 0) {
                            var dArray = "{'CampaignID': '" + campaignid + "',";
                            dArray += "'SrcCampaignID': '" + srccampaignid + "',";
                            dArray += "'RevDate': '" + $("*[id$='txtDate1']").val() +"',";
                            dArray += "'NumClicks': '" + addclicks + "',";
                            dArray += "'NumConversions': '" + addconv + "',";
                            dArray += "'Paid': '" + paid + "',";
                            dArray += "'SubID1': '[None]'}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/UpdateClicksConversions",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true,
                                success: function(response) {
                                    $().toastmessage('showSuccessToast', 'Changes saved.');
                                    RefreshOnlineSrc();
                                },
                                error: function(response) {
                                    $().toastmessage('showErrorToast', response.responseText);
                                }
                            });
                        }
                    });
                });
                $("#btnSaveCorporateTotals").click(function () {
                    var corporateCost = $("#<%= tbCorpCost.ClientID %>").val();
                    var additionacost = $(this).find('#tbCorpCost').value;

                    var date = $("#<%= txtDate1.ClientID %>").val();
                    var parts = date.split("/");
                    var month = parts[0];
                    var year = parts[2];
                    
                    var dArray = "{'_corpCost': '" + corporateCost + "',";
                    dArray += "'Year': '" + year + "',";
                    dArray += "'Month': '" + month + "'}";

                    $.ajax({
                        type: "POST",
                        url: "../service/cmService.asmx/SaveRevTotals",
                        data: dArray,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true
                    });
                    $().toastmessage('showSuccessToast', 'Changes saved.');
                    document.location.reload(true);
                });
                $("#btnRefreshSubIds").click(function() {
                    RefreshSubIds();
                });
                $("#btnCloseSubIds").click(function() {
                    $("#dialog-subids").dialog("close");
                    RefreshCampaigns();
                });
                $("#btnRefreshOnline").click(function() {
                    RefreshOnline();
                });
                $("#btnCloseOnline").click(function() {
                    $("#dialog-online").dialog("close");
                    RefreshRev();
                });
                $("#btnRefreshOnlineSrc").click(function() {
                    RefreshOnlineSrc();
                });
                $("#btnCloseOnlineSrc").click(function() {
                    $("#dialog-onlinesrc").dialog("close");
                    RefreshOnline();
                });
                $("#btnEmail").click(function() {
                    if (confirm('Are you sure you want to email the Rev Report to all recipients?')) {
                        $(".portlet").html(function(index, oldhtml) {
                            var dArray = "{'html': '" + escape(oldhtml) + "'}";

                            $.ajax({
                                type: "POST",
                                url: "../service/cmService.asmx/EmailRevReport",
                                data: dArray,
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                async: true,
                                success: function(response) {
                                    $().toastmessage('showSuccessToast', 'Rev report emailed!');
                                },
                                error: function(response) {
                                    $().toastmessage('showErrorToast', response.responseText);
                                }
                            });
                        });
                    }
                });
                $("#<%= txtDate1.ClientID %>,#<%= txtDate2.ClientID %>").datepicker({
                    showOn: "button",
                    buttonImage: '<%=resolveurl("../images/16x16_calendar_orange.png") %>',
                    buttonImageOnly: true
                });
            });
        }

        function ShowCampaigns(category, type, date) {
            $("#dialog-campaigns").dialog("open");
            $("#dialog-campaigns").dialog("option", "title", category + ' ' + type + ' Cost Breakdown for ' + date);
        }

        function ShowOnline(category, date) {
            $("#dialog-online").dialog("open");
            $("#dialog-online").dialog("option", "title", category + ' Online Revenue for ' + date);
        }

        function showCorporate() {
            var date = $("#<%= txtDate1.ClientID %>").val();
            var parts = date.split("/");
            var month = parts[0];
            var year = parts[2];
            $("#dialog-corporate").dialog("open");
            $("#dialog-corporate").dialog("option", "title", 'Corporate Costs for the Month of ' + month + '/' +year);
        }

        function ShowSubIdDialog() {
            $("#dialog-subids").dialog("open");
        }

        function ShowOnlineSrc(offer,campaignid) {
            $("#dialog-onlinesrc").data('campaignid', campaignid);
            $("#dialog-onlinesrc").dialog("open");
            $("#dialog-onlinesrc").dialog("option", "title", 'Source Campaigns for ' + offer);
        }

        function SaveCampaigns() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkSaveCampaigns, Nothing) %>;
        }

        function CloseCampaigns() {
            $("#dialog-campaigns").dialog("close");
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }

        function RefreshRev() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }

        function RefreshCampaigns() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRefreshCampaigns, Nothing) %>;
        }

        function RefreshSubIds() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRefreshSubIds, Nothing) %>;
        }

        function RefreshOnline() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRefreshOnline, Nothing) %>;
        }

        function RefreshOnlineSrc() {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRefreshOnlineSrc, Nothing) %>;
        }
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
    </script>
    <style type="text/css">
        .revcat td { background-color:#fff; border-bottom: 1px solid }
        .revcat th { background-color:#999077; color:#fff; text-align:left; padding-left:5px; }
        .sub td { background-color: #FFBD60; border-bottom: 1px solid }
        .sub2 td { background-color: #FFEBD0; border-bottom: 1px solid }
        .sub3 td { background-color: #FFEBD0; border-bottom: 2px solid }
        .sub4 td { background-color: #E8D7B2; border-bottom: 1px solid }
        .leads td { background-color: #D0F5FF }
        .ttlHeader {text-align:center; font-size:1em;background-color:#818185; color:#fff;}
        .ttlTitle {padding-left:5px; font-size:.9em;background-color:#fff; color:#818185;}
        .ttlTxbx {width:80px; height:14px;}
        .ttlLabel {}
        .dateSelection td{ vertical-align:bottom;}
        .dateSelection td img{ vertical-align:bottom;}
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float:left; padding: 0px 3px 3px 3px; width:250px">
                <h2>Revenue Snapshot</h2>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table class="dateSelection">
                    <tr>
                        <td>

                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7"></asp:TextBox>&nbsp;-&nbsp;
                            <asp:TextBox ID="txtDate2" runat="server" Size="7"></asp:TextBox>&nbsp;&nbsp;
                            <asp:TextBox ID="txtTime1" runat="server" Size="7" MaxLength="8" Text="12:00 AM"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                ID="txtTime2" runat="server" Size="7" MaxLength="8" Text="11:59 PM"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="btnView" runat="server" Text="View" style="float:right;" Font-Size="8pt" CssClass="jqButton" />
                        </td>
                        <td>
                            <asp:Button ID="btnSave" runat="server" Text="Save" style="float:right;" Font-Size="8pt" CssClass="jqButton" />
                        </td>
                        <td>
                            <input id="btnEmail" type="button" style="float:right!important; font-size:8pt" class="jqButton" value="Email" />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <table>
                <!-- Additional Total-->
                <tr>
                    <asp:Repeater ID="RptTotals" runat="server">
                        <ItemTemplate>
                            <td>
                                <table width="330px" style="border:1px solid #cccccc; background-color:#FFF7E7;" cellspacing="0">
                                    <tr>
                                        <td colspan="3" class="ttlHeader">
                                            <asp:Label runat="server" ID="lbDescription" Text='<%#Eval("Description")%>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="ttlHeader"><%#Eval("Span")%></td>
                                    </tr>
                                    <tr>
                                        <td class="ttlTitle">Corporate</td>
                                        <td class="ttlTitle">Total Revenue</td>
                                        <td class="ttlTitle">Totals</td>
                                    </tr>
                                    <tr>                                        
                                        <td>$<asp:LinkButton ID="lnkCorpCost" runat="server" Text='<%#Eval("CorporateCost","{0:n2}")%>' class="ttlLabel"></asp:LinkButton></td>
                                        <td class="ttlLabel"><%# FormatCurrency((Eval("AgedRev") + Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) - (Eval("AffiliateCost") + Eval("InternalCost")))%></td>
                                        <td class="ttlLabel"><%# FormatCurrency((Eval("AgedRev") + Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) - (Eval("AffiliateCost") + Eval("InternalCost") + Eval("LaborCost") + Eval("CorporateCost")))%></td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <!--If Hidden Fields Are Needed-->
                            </td>
                        </ItemTemplate>                    
                    </asp:Repeater>
                </tr>
                <!-- Additional Total End-->
                <tr>
                <asp:Repeater ID="Repeater1" runat="server">
                    <ItemTemplate>
                       <td>
                            <table width="330px" style="border:1px solid #cccccc" cellspacing="0" class="revcat">
                                <tr>
                                    <td colspan="2" style="text-align:center; font-size:16px">
                                        <%#Eval("Category")%></td>
                                </tr>
                                <tr>
                                    <th><%# If(CDate(txtDate2.Text).Equals(Today), Format(Eval("RevDate"), "MMMM d, yyyy"), Format(Eval("RevDate"), "MMMM d") & " - " & Format(CDate(txtDate2.Text), "MMMM d, yyyy"))%></th>
                                    <th>&nbsp;</th>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:LinkButton ID="btnAffiliateCost" runat="server" CommandName="ShowAffiliateCost" CausesValidation="false" CommandArgument='<%#Eval("Category")%>' Font-Underline="true">Affiliate Cost</asp:LinkButton></td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("AffiliateCost"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:LinkButton ID="btnInternalCost" runat="server" CommandName="ShowInternalCost" CausesValidation="false" CommandArgument='<%#Eval("Category")%>' Font-Underline="true">Internal Cost</asp:LinkButton></td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("InternalCost"))%></td>
                                </tr>
                                <%--<tr>
                                    <td align="right">Labor Cost</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("LaborCost"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">Corporate Cost</td>
                                    <td align="right">
                                        $<asp:TextBox ID="txtCorpCost" runat="server" Text='<%#Eval("CorporateCost","{0:n2}")%>' style="text-align:right" width="75px"></asp:TextBox></td>
                                </tr>--%>
                                <tr class="sub">
                                    <td align="right"><i>Subtotal</i></td>
                                    <td align="right">
                                        <%--<%# FormatCurrency(Eval("AffiliateCost") + Eval("InternalCost") + Eval("LaborCost") + Eval("CorporateCost"))%></td>--%>
                                        <%# FormatCurrency(Eval("AffiliateCost") + Eval("InternalCost"))%></td>
                                </tr>
<%--                                <tr>
                                    <td align="right">Recycled Revenue</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("AgedRev"))%></td>
                                </tr>--%>
                                <tr>
                                    <td align="right">
                                        <asp:LinkButton ID="btnOnlineRev" runat="server" CommandName="ShowOnlineRev" CausesValidation="false" CommandArgument='<%#Eval("Category")%>' Font-Underline="true">Online Revenue</asp:LinkButton></td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("OnlineRev"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">Data Revenue</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("DataRev"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">Archive Revenue</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("ArchiveRev"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">List Mgt Revenue</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("ListMgtRev"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">Email Revenue</td>
                                    <td align="right">
                                        $<asp:TextBox ID="txtEmailRev" runat="server" Text='<%#Eval("EmailRev","{0:n2}")%>' style="text-align:right; height:14px;" width="75px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td align="right">Adsense Revenue</td>
                                    <td align="right">
                                        $<asp:TextBox ID="txtAdsenseRev" runat="server" Text='<%#Eval("AdsenseRev","{0:n2}")%>' style="text-align:right; height:14px;" width="75px"></asp:TextBox></td>
                                </tr>
                                <tr class="sub">
                                    <td align="right"><i>Subtotal</i></td>
                                    <td align="right">
                                        <%# FormatCurrency( Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev"))%></td>
                                </tr>
                                <tr>
                                    <td align="right">Total Revenue</td>
                                    <td align="right">
                                        <%# FormatCurrency((Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) - (Eval("AffiliateCost") + Eval("InternalCost")))%></td>
                                        <%--<%# FormatCurrency((Eval("AgedRev") + Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) - (Eval("AffiliateCost") + Eval("InternalCost") + Eval("LaborCost") + Eval("CorporateCost")))%></td>--%>
                                </tr>
                                <tr class="sub2">
                                    <td align="right">Online Margin %</td>
                                    <td align="right">
                                        <%# FormatPercent(((Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) - (Eval("AffiliateCost") + Eval("InternalCost"))) / (Eval("AffiliateCost") + Eval("InternalCost") + 1), 2)%></td>
                                </tr>
                                <tr class="sub2">
                                    <td align="right">Margin %</td>
                                    <td align="right">
                                        <%--<%# FormatPercent(((Eval("AgedRev") + Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) / (Eval("AffiliateCost") + Eval("InternalCost") + Eval("LaborCost") + Eval("CorporateCost") + 1)), 2)%></td>--%>
                                        <%# FormatPercent(((Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) / (Eval("AffiliateCost") + Eval("InternalCost") + 1)), 2)%></td>
                                </tr>
                                <tr class="sub2">
                                    <td align="right">Gross Revenue per Lead</td>
                                    <td align="right">
                                        <%# FormatCurrency((Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) / CheckZero(Eval("NewLeads")))%></td>
                                </tr>
                                <tr class="sub2">
                                    <td align="right">Cost per Lead</td>
                                    <td align="right">                               
                                        <%# FormatCurrency((Eval("AffiliateCost") + Eval("InternalCost")) / CheckZero(Eval("NewLeads")))%></td>
                                </tr>
                                <tr class="sub3">
                                    <td align="right">Net Revenue per Lead</td>
                                    <td align="right">
                                        <%# FormatCurrency(((Eval("OnlineRev") + Eval("DataRev") + Eval("EmailRev") + Eval("AdsenseRev") + Eval("ArchiveRev") + Eval("ListMgtRev")) / CheckZero(Eval("NewLeads"))) - ((Eval("AffiliateCost") + Eval("InternalCost")) / CheckZero(Eval("NewLeads"))))%></td>
                                </tr>
                                <tr class="sub4">
                                    <td align="right">RPL Data</td>
                                    <td align="right">
                                        <%# FormatCurrency((Eval("DataRev") + Eval("ArchiveRev") + Eval("EmailRev") + Eval("ListMgtRev")) / CheckZero(Eval("NewLeads")))%></td>
                                </tr>
                                <tr class="sub4">
                                    <td align="right">RPL Online</td>
                                    <td align="right">
                                        <%# FormatCurrency((Eval("OnlineRev") + Eval("AdsenseRev")) / CheckZero(Eval("NewLeads")))%></td>
                                </tr>
<%--                                <tr class="sub4">
                                    <td align="right">RPL Recycled</td>
                                    <td align="right">
                                        <%# FormatCurrency(Eval("AgedRev") / CheckZero(Eval("NewLeads")))%></td>
                                </tr>--%>
                                <tr class="sub4">
                                    <td align="right">RPL Data + Online + Recycled</td>
                                    <td align="right">
                                        <%# FormatCurrency((Eval("DataRev") + Eval("ArchiveRev") + Eval("OnlineRev") + Eval("EmailRev") + Eval("ListMgtRev")) / CheckZero(Eval("NewLeads")))%></td>
                                </tr>
                                <tr class="leads">
                                    <td align="right">Total Leads</td>
                                    <td align="right">
                                        <%#Eval("Leads", "{0:n0}")%></td>
                                </tr>
                                <tr class="leads">
                                    <td align="right">New Leads</td>
                                    <td align="right">
                                        <%#Eval("NewLeads", "{0:n0}")%></td>
                                </tr>
                            </table>
                       </td>
                       <td>
                        <asp:HiddenField ID="hdnRevReportID" runat="server" Value='<%#Eval("RevReportID") %>' />&nbsp;
                        </td>
                    </ItemTemplate>
                </asp:Repeater>
                </tr>
                </table>
            </div>
            <asp:LinkButton ID="btnRefresh" runat="server"></asp:LinkButton>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-campaigns" title="Campaigns">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div>
                    <button id="Button1" style="float:right!important" onclick="return CloseCampaigns();" class="jqCloseButton">Close & Refresh Rev Report</button>
                    <button id="btnSaveCampaigns" style="float:right!important" class="jqSaveButton">Save</button>
                    <button id="Button3" style="float:right!important" onclick="return RefreshCampaigns();" class="jqRefreshButton">Refresh</button>
                    <div id="divLoadingCamp" style="float:left;">
                    </div> 
                </div>
                <div style="clear:both" />  
                <div style="padding-top:5px">
                    <asp:GridView ID="gvCampaigns" runat="server" Width="100%" AutoGenerateColumns="false" ShowFooter="true" AlternatingRowStyle-CssClass="altrow"
                            GridLines="None" BorderStyle="None">
                        <Columns>
                            <asp:BoundField DataField="CampaignID" HeaderText="ID" ItemStyle-Width="33px" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                            <asp:TemplateField HeaderText="Campaign" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkShowSubIds" runat="server" CommandName="ShowSubIDs" CommandArgument='<%#Eval("CampaignID")%>' CausesValidation="false"><u><%#Eval("Campaign")%></u></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Affiliate" HeaderText="Affiliate" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="Clicks" HeaderText="Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="Conversions" HeaderText="Conversions" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="billable" HeaderText="Billable" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                            <asp:TemplateField HeaderText="PPC" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" FooterStyle-CssClass="footeritem2">
                                <ItemTemplate>
                                    $<input id="txtPPC" type="text" value='<%#Eval("Paid","{0:n2}") %>' style="text-align:right; width:40px" />
                                    <input id="hdnCurPPC" type="hidden" value='<%#Eval("Paid","{0:n2}") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Cost" HeaderText="Cost" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass="footeritem2" />
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:LinkButton ID="lnkRefreshCampaigns" runat="server"></asp:LinkButton>
                <asp:LinkButton ID="lnkSaveCampaigns" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="dialog-subids" title="Sub Id Cost Breakdown">
        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
            <ContentTemplate>
                <div>
                    <button id="btnCloseSubIds" style="float:right!important" class="jqCloseButton">Close & Refresh Campaigns</button>
                    <button id="btnSaveSubIds" style="float:right!important" class="jqSaveButton">Save</button>
                    <button id="btnRefreshSubIds" style="float:right!important" class="jqRefreshButton">Refresh</button>
                    <div id="div2" style="float:left;">

                    </div> 
                </div>
                <div style="clear:both" />  
                <div style="padding-top:5px">
                    <div style="padding-top:5px; height:500px; overflow:auto">
                        <asp:GridView ID="gvSubIds" runat="server" Width="100%" AutoGenerateColumns="false" ShowFooter="true" AlternatingRowStyle-CssClass="altrow"
                             GridLines="None" BorderStyle="None">
                            <Columns>
                                <asp:BoundField DataField="CampaignID" HeaderText="ID" ItemStyle-Width="33px" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="Campaign" HeaderText="Campaign" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="SubID1" HeaderText="Sub Id" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="Clicks" HeaderText="Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                                <asp:TemplateField HeaderText="Add Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2">
                                    <ItemTemplate>
                                        <input id="txtAddClick" type="text" value="0" maxlength="4" style="width:40px; text-align:center" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Conversions" HeaderText="Conversions" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="billable" HeaderText="Billable" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                                <asp:TemplateField HeaderText="Add Billable" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2">
                                    <ItemTemplate>
                                        <input id="txtAddConv" type="text" value="0" maxlength="4" style="width:40px; text-align:center" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="paid" HeaderText="PPC" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" DataFormatString="{0:c}" />
                                <asp:BoundField DataField="Cost" HeaderText="Cost" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass="footeritem2" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <asp:LinkButton ID="lnkRefreshSubIds" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:UpdatePanel ID="upnlJsRunner" UpdateMode="Always" runat="server">
		<ContentTemplate>
			<asp:PlaceHolder ID="phrJsRunner" runat="server"></asp:PlaceHolder>
		</ContentTemplate>
	</asp:UpdatePanel>
    <div id="dialog-online" title="Online Revenue">
        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
            <ContentTemplate>
                <div>
                    <button id="btnCloseOnline" style="float:right!important" class="jqCloseButton">Close & Refresh Rev Report</button>
                    <button id="btnRefreshOnline" style="float:right!important" class="jqRefreshButton">Refresh</button>
                    <div id="div3" style="float:left;">
   
                    </div> 
                </div>
                <div style="clear:both" />  
                <div style="padding-top:5px; height:500px; overflow:auto">
                    <asp:GridView ID="gvOnline" runat="server" Width="100%" AutoGenerateColumns="false" ShowFooter="true" AlternatingRowStyle-CssClass="altrow"
                            GridLines="None" BorderStyle="None">
                        <Columns>
                            <asp:BoundField DataField="CampaignID" HeaderText="ID" ItemStyle-Width="33px" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                            <asp:TemplateField HeaderText="Offer" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkShowSrcIds" runat="server" CommandName="ShowSrcIDs" CommandArgument='<%#CStr(Eval("CampaignID")) + ";" + Eval("Offer") + ";" + Eval("Category")%>' CausesValidation="false"><u><%#Eval("Offer")%></u></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Advertiser" HeaderText="Advertiser" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="Clicks" HeaderText="Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="Conversions" HeaderText="Conversions" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="PPC" HeaderText="PPC" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass="footeritem2" />
                            <asp:BoundField DataField="Received" HeaderText="Revenue" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass="footeritem2" />
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:LinkButton ID="lnkRefreshOnline" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="dialog-onlinesrc" title="">
        <asp:UpdatePanel ID="UpdatePanel5" runat="server">
            <ContentTemplate>
                <div>
                    <button id="btnCloseOnlineSrc" style="float:right!important" class="jqCloseButton">Close & Refresh Online</button>
                    <button id="btnSaveOnlineSrc" style="float:right!important" class="jqSaveButton">Save</button>
                    <button id="btnRefreshOnlineSrc" style="float:right!important" class="jqRefreshButton">Refresh</button>
                    <div id="divLoadingOnlineSrc" style="float:left;"></div> 
                </div>
                <div style="clear:both" />  
                <div style="padding-top:5px">
                    <div style="padding-top:5px; height:500px; overflow:auto">
                        <asp:GridView ID="gvOnlineSrc" runat="server" Width="100%" AutoGenerateColumns="false" ShowFooter="true" AlternatingRowStyle-CssClass="altrow"
                             GridLines="None" BorderStyle="None">
                            <Columns>
                                <asp:BoundField DataField="SrcCampaignID" HeaderText="ID" ItemStyle-Width="33px" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="Campaign" HeaderText="Campaign" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" HeaderStyle-HorizontalAlign="Left" FooterStyle-CssClass="footeritem2" />
                                <asp:BoundField DataField="Clicks" HeaderText="Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                                <asp:TemplateField HeaderText="Add Clicks" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2">
                                    <ItemTemplate>
                                        <input id="txtAddClick" type="text" value="0" maxlength="4" style="width:40px; text-align:center" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Conversions" HeaderText="Conversions" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" />
                                <asp:TemplateField HeaderText="Add Conv" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2">
                                    <ItemTemplate>
                                        <input id="txtAddConv" type="text" value="0" maxlength="4" style="width:40px; text-align:center" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="PPC" HeaderText="PPC" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" ItemStyle-HorizontalAlign="Center" FooterStyle-CssClass="footeritem2" DataFormatString="{0:c}" />
                                <asp:BoundField DataField="Received" HeaderText="Revenue" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" FooterStyle-CssClass="footeritem2" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <asp:LinkButton ID="lnkRefreshOnlineSrc" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="dialog-corporate" title="">
        <asp:UpdatePanel ID="UpdatePanel6" runat="server">
            <ContentTemplate>
                <div>
                    <%--<button id="Button2" style="float:right!important" class="jqCloseButton">Close & Refresh Online</button>--%>
                    <button id="btnSaveCorporateTotals" style="float:right!important" class="jqSaveButton">Save</button>
                    <%--<button id="Button5" style="float:right!important" class="jqRefreshButton">Refresh</button>--%>
                    <div id="div4" style="float:left;"></div> 
                </div>
                <div style="clear:both" />  
                <div style="padding-top:5px">
                Enter the New Corporate Cost for this Month: $<asp:TextBox ID="tbCorpCost" runat="server" style="height:14px;"></asp:TextBox>
                </div>
                <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>