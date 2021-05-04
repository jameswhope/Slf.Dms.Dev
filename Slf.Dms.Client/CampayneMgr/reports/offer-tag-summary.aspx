<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="offer-tag-summary.aspx.vb" Inherits="reports_offer_tag_summary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
                $("#dialog-offers").dialog({
                    autoOpen: false,
                    width: 950,
                    modal: true,
                    position: [10, 10]
                });
                $("#dialog-campaigns").dialog({
                    autoOpen: false,
                    width: 950,
                    modal: true,
                    position: [10, 30]
                });
                $("#dialog-srccampaigns").dialog({
                    autoOpen: false,
                    width: 800,
                    modal: true,
                    position: [30, 30]
                });
                $("#dialog-subid").dialog({
                    autoOpen: false,
                    width: 950,
                    modal: true,
                    position: [10, 50]
                });
                $("#dialog-addconversions").dialog({
                    autoOpen: false,
                    width: 550,
                    height: 300,
                    modal: true,
                    position: [50, 50]
                });
                $(".jqButton").button();
                $(".jqRefreshButton").button({
                    icons: {
                        primary: "ui-icon-refresh"
                    },
                    text: false
                });
                $(".jqAddButton").button({
                    icons: {
                        primary: "ui-icon-plus"
                    },
                    text: false
                });
            });
        }

        function clickReport(ID,Tag) {

            var tst = $().toastmessage('showToast', {
                text: 'Generating file...<img src="../images/loader3.gif" alt="" />',
                sticky: true,
                type: 'notice'
            });
           
            $.ajax({
                type: "POST",
                url: "offer-tag-summary.aspx/ClickReport",
                data: "{'ID':'" + ID + "','StartDate':'" + $("*[id$='txtDate1']").val() + "','EndDate':'" + $("*[id$='txtDate2']").val() + "','Tag':'" + Tag + "'}",
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
            $.ajax({
                type: "POST",
                url: "offer-tag-summary.aspx/DeleteTempFiles",
                data: "{'tempfile':'" + $(".downFile").attr('href') + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true
            });
        }

        function ShowOffers(tag) {
            $("#dialog-offers").data('tag', tag)
            
            switch (tag) {
                case 'Data Feed':
                    ShowCampaigns(-1, tag);
                    break;
                default:
                    $("#dialog-offers").dialog("open");
                    $("#dialog-offers").dialog("option", "title", tag + ' Offers');
                    getOfferData();
                    break;
            }
        }

        function ShowCampaigns(offerid, offer) {
            var tag = $("#dialog-offers").data('tag');

            $("#dialog-campaigns").data('tag', tag)
            $("#dialog-campaigns").data('offerid', offerid)
            $("#dialog-campaigns").dialog("open");

            switch (tag) {
                case 'Data':
                case 'Live Transfer':
                case 'List Management':
                    $("#dialog-campaigns").dialog("option", "title", offer + ' Buyers');
                    getBuyerData();
                    break;
                default:
                    $("#dialog-campaigns").dialog("option", "title", offer + ' Campaigns');
                    getCampaignData();
                    break;
            }
        }
       
        function RefreshCampaignData() {
            var tag = $("#dialog-offers").data('tag');
            
            switch (tag) {
                case 'Data':
                case 'Live Transfer':
                case 'List Management':
                    getBuyerData();
                    break;
                default:
                    getCampaignData();
                    break;
            }

        }
        function ShowSubID(campaignid, campaign) {
            $("#dialog-subid").data('campaignid', campaignid)
            $("#dialog-subid").dialog("open");
            $("#dialog-subid").dialog("option", "title", 'Campaigns by SubID for  ' + campaign);

            getCampaignSubData();
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

        function ShowAddConversions(campaignid, offer, srccampaignid, campaign, curconv) {
            $("#dialog-addconversions").data('campaignid', campaignid);
            $("#dialog-addconversions").data('srccampaignid', srccampaignid);
            $("#dialog-addconversions").dialog("open");
            $("#dialog-addconversions").dialog("option", "title", 'Add Conversions to ' + offer + ' - ' + campaign + ' (' + srccampaignid + ')');
            $("*[id$='lblCurrentConv']").html(curconv);
            $("*[id$='txtConversionDate']").val($("*[id$='txtDate2']").val());
        }

        function AddConversions() {

            var dArray = "{'CampaignID': '" + $("#dialog-addconversions").data('campaignid') + "',";
            dArray += "'SrcCampaignID': '" + $("#dialog-addconversions").data('srccampaignid') + "',";
            dArray += "'NumToAdd': '" + $("*[id$='txtNum']").val() + "',";
            dArray += "'ConversionDate': '" + $("*[id$='txtConversionDate']").val() +"'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/AddConversions",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function(response) {
                    $().toastmessage('showSuccessToast', response.d);
                    getSrcCampaignData();
                },
                error: function(response) {
                    showStickyToast(response.responseText, 'showErrorToast');
                }
            });
            $("#dialog-addconversions").dialog("close");
        }

    function getOfferData() {
        $('#divLoadingOffers').html('<img src="../images/loader3.gif" alt="loading..." />');
        
        var tag = $("#dialog-offers").data('tag');
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var fromhr = $("*[id$='txtTime1']").val();
        var tohr = $("*[id$='txtTime2']").val();
        var dArray = "{'tag': '" + tag + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'fromhr': '" + fromhr + "',";
        dArray += "'tohr': '" + tohr + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetOffersByTag",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#divOfferGrid').html(response.d);
                $('#divLoadingOffers').html('');
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
    }
    function getBuyerData() {
        $('#divLoadingCamp').html('<img src="../images/loader3.gif" alt="" />');
        
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var offerid = $("#dialog-campaigns").data('offerid');
        var tag = $("#dialog-campaigns").data('tag');
        var fromhr = $("*[id$='txtTime1']").val();
        var tohr = $("*[id$='txtTime2']").val();

        var dArray = "{'offerid': '" + offerid + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'tag': '" + tag + "',";
        dArray += "'fromhr': '" + fromhr + "',";
        dArray += "'tohr': '" + tohr + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetBuyersByOffer",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#divCampaignGrid').html(response.d);
                $('#divLoadingCamp').html('');
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        return false
    }
    
    function getCampaignData() {
        $('#divLoadingCamp').html('<img src="../images/loader3.gif" alt="" />');
        
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var offerid = $("#dialog-campaigns").data('offerid');
        var fromhr = $("*[id$='txtTime1']").val();
        var tohr = $("*[id$='txtTime2']").val();
        var tag = $("#dialog-campaigns").data('tag');
        
        var dArray = "{'offerid': '" + offerid + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'fromhr': '" + fromhr + "',";
        dArray += "'tohr': '" + tohr + "',";
        dArray += "'tag': '" + tag + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetCampaignsByOffer",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#divCampaignGrid').html(response.d);
                $('#divLoadingCamp').html('');
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        return false
    }

    function ShowSrcCampaigns(offerid, offer) {
        $("#dialog-srccampaigns").data('offerid', offerid)
        $("#dialog-srccampaigns").dialog("open");
        $("#dialog-srccampaigns").dialog("option", "title", 'Source Campaigns for ' + offer);
        getSrcCampaignData();
    }

    function getSrcCampaignData() {
        $('#divLoadingSrc').html('<img src="../images/loader3.gif" alt="" />');
        
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var offerid = $("#dialog-srccampaigns").data('offerid');
        var fromhr = $("*[id$='txtTime1']").val();
        var tohr = $("*[id$='txtTime2']").val();

        if ($('#chkSrcEST').is(':checked')) {
            var dt = new Date(startdate);
            dt.setMinutes(dt.getMinutes() - 120);
            startdate = dt.format('M/d/yyyy HH:mm');
        }

        var dArray = "{'offerid': '" + offerid + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'fromhr': '" + fromhr + "',";
        dArray += "'tohr': '" + tohr + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetSrcCampaignsByOffer",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#divSrcCampaignGrid').html(response.d);
                $('#divLoadingSrc').html('');
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        return false
    }
    
    function getCampaignSubData() {
        $('#divLoadingSubId').html('<img src="../images/loader3.gif" alt="" />');

        var cid = $("#dialog-subid").data('campaignid');
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var fromhr = $("*[id$='txtTime1']").val();
        var tohr = $("*[id$='txtTime2']").val();
        var dArray = "{'campaignid': '" + cid + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'export': 'false',";
        dArray += "'mtd': 'false',";
        dArray += "'fromhr': '" + fromhr + "',";
        dArray += "'tohr': '" + tohr + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetSubIDByCampaign",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                $('#divSubIdGrid').html(response.d);
                $('#divLoadingSubId').html('');
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        return false;
    }

    function ExportExcel(mtd) {
        var cid = $("#dialog-subid").data('campaignid');
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();

        var dArray = "{'campaignid': '" + cid + "',";
        dArray += "'startdate': '" + startdate + "',";
        dArray += "'enddate': '" + enddate + "',";
        dArray += "'export': 'true',";
        dArray += "'mtd': '" + mtd + "',";
        dArray += "'fromhr': '0:00 AM',";
        dArray += "'tohr': '11:59 PM'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetSubIDByCampaign",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                popup(response.d);
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
    }

    function SubIDExportMTD() {
        var cid = $("#dialog-subid").data('campaignid');
        var startdate = $("*[id$='txtDate1']").val();
        var dArray = "{'campaignid': '" + cid + "','startdate': '" + startdate + "'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetSubIDExportMTD",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                popup(response.d);
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    }

    function SubIDExport() {
        var cid = $("#dialog-subid").data('campaignid');
        var startdate = $("*[id$='txtDate1']").val();
        var enddate = $("*[id$='txtDate2']").val();
        var dArray = "{'campaignid': '" + cid + "','startdate': '" + startdate + "','enddate': '" + enddate + "','fromhr': '0:00 AM','tohr': '11:59 PM'}";

        $.ajax({
            type: "POST",
            url: "../service/cmService.asmx/GetSubIDExport",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                popup(response.d);
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    }

    function popup(data) {
        $("body").append('<form id="exportform" action="../Handlers/CsvExport.ashx?f=CampaignsBySub" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
        $("#exportdata").val(data);
        $("#exportform").submit().remove();
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" PopupButtonID="imgDate1" />&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="7"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><cc1:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" PopupButtonID="imgDate2" />&nbsp;&nbsp;
                            <asp:TextBox ID="txtTime1" runat="server" Size="7" MaxLength="8" Text="12:00 AM"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                                ID="txtTime2" runat="server" Size="7" MaxLength="8" Text="11:59 PM"></asp:TextBox>
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnApply" runat="server" Text="Apply" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvTags" runat="server" AutoGenerateColumns="false" GridLines="None"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%"
                        ShowFooter="true" CellPadding="4">
                        <Columns>
                            <asp:BoundField DataField="tag" HeaderText="Tag" HeaderStyle-HorizontalAlign="Left"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" FooterStyle-CssClass="footeritem3"
                                ItemStyle-Font-Underline="true" />
                            <asp:BoundField DataField="newclicks" HeaderText="Clicks" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" FooterStyle-CssClass="footeritem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="newconv" HeaderText="Conv" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="newconvpct" HeaderText="Conv %" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                            <asp:BoundField DataField="newreceived" HeaderText="Revenue" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" FooterStyle-CssClass="footeritem3"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                            <asp:BoundField DataField="revisitclicks" HeaderText="Clicks" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" FooterStyle-CssClass="footeritem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="revisitconv" HeaderText="Conv" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="revisitconvpct" HeaderText="Conv %" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                            <asp:BoundField DataField="revisitreceived" HeaderText="Revenue" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem3" ItemStyle-CssClass="griditem3" FooterStyle-CssClass="footeritem3"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                            <asp:BoundField DataField="clicks" HeaderText="Clicks" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" FooterStyle-CssClass="footeritem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="conversions" HeaderText="Conv" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="convpct" HeaderText="Conv %" HeaderStyle-HorizontalAlign="Right"
                                FooterStyle-CssClass="footeritem2" HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                            <asp:BoundField DataField="received" HeaderText="Revenue" HeaderStyle-HorizontalAlign="Right"
                                HeaderStyle-CssClass="headitem2" ItemStyle-CssClass="griditem2" FooterStyle-CssClass="footeritem2"
                                ItemStyle-HorizontalAlign="Right" DataFormatString="{0:c}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-offers" title="Offers">
        <div>
            <button id="btnRefreshOffer" class="jqRefreshButton" style="float:right!important" onclick="return getOfferData()">Refresh</button>
            <div id="divLoadingOffers" style="float:left;"></div> 
        </div>
        <div style="clear:both; padding-bottom:3px" />
        <div id="divOfferGrid">
        </div>
    </div>
    <div id="dialog-campaigns" title="Campaigns">
        <div>
            <button id="btnRefreshCampaign" class="jqRefreshButton" style="float: right!important" onclick="return RefreshCampaignData();">Refresh</button>
            <div id="divLoadingCamp" style="float:left;"></div> 
        </div>
        <div style="clear:both; padding-bottom:3px" />  
        <div id="divCampaignGrid">
        </div>
    </div>
    <div id="dialog-srccampaigns" title="Source Campaigns">
        <div>
            <label for="chkSrcEST" style="float:left"><input id="chkSrcEST" type="checkbox" />2-hour delay</label>
            <button id="btnRefreshSrcCampaign" class="jqRefreshButton" style="float: right!important" onclick="return getSrcCampaignData();">Refresh</button>
            <div id="divLoadingSrc" style="float:left;"></div>                
        </div>
        <div style="clear:both; padding-bottom:3px" />
        <div id="divSrcCampaignGrid">
        </div>
    </div>
    <div id="dialog-subid" title="Campaigns By Sub Id">
        <div style="height:38px">
            <button onclick="SubIDExportMTD();" class="jqButton" style="float:right!important">Export MTD Detail</button>
            <button onclick="ExportExcel(true);" class="jqButton" style="float:right!important">Export MTD</button>
            <button onclick="SubIDExport();" class="jqButton" style="float:right!important">Export Detail</button>
            <button onclick="ExportExcel(false);" class="jqButton" style="float:right!important">Export</button>
            <button id="btnRefreshCampaignSub" class="jqRefreshButton" style="float:right!important" onclick="return getCampaignSubData();">Refresh</button>
            <div id="divLoadingSubId" style="float:left;"></div>    
        </div>
        <div id="divSubIdGrid">
        </div>
        <div>
            <sup>Top 50 Sub Ids shown. Export for full list.</sup>
        </div>
    </div>
    <div id="dialog-addconversions" title="Add Conversions">
        <table>           
            <tr>
                <td align="right">
                    Current Conversions:
                </td>
                <td>
                    <asp:Label ID="lblCurrentConv" runat="server"></asp:Label>&nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    # of Conversions to Add:
                </td>
                <td>
                    <asp:TextBox ID="txtNum" runat="server" MaxLength="3" size="10" Text="1"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right">
                    Conversion Date:
                </td>
                <td>
                    <asp:TextBox ID="txtConversionDate" runat="server" MaxLength="10" size="10"></asp:TextBox>
                    <asp:ImageButton runat="Server" ID="StartImage" ImageUrl="~/images/24x24_calendar.png"
                        AlternateText="Click to show calendar" ImageAlign="AbsMiddle" /><cc1:CalendarExtender
                            ID="extStartDate"
                            runat="server" TargetControlID="txtConversionDate" PopupButtonID="StartImage" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <hr />
                </td>
               </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td>
                    <button class="jqButton" id="btnSaveContact" onclick="return AddConversions();">
                        Add Conversions</button>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
