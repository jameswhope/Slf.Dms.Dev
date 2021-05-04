<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="disposition.aspx.vb" Inherits="reports_disposition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
                $("#dialog-subids").dialog({
                    autoOpen: false,
                    width: 950,
                    modal: true,
                    position: [20, 20]
                });
                $("#dialog-leads").dialog({
                    autoOpen: false,
                    width: 950,
                    modal: true,
                    position: [30, 30]
                });
                $(".jqButton").button();
            });
        }

        function ShowSubIds(campaignid, campaign) {
            
            $("#dialog-subids").dialog("open");
            $("#dialog-subids").dialog("option", "title", campaign + ' (' + campaignid + ')');

            $('#divGrid').html('<img src="../images/loader3.gif" alt="loading..." />');

            var startdate = $("*[id$='txtDate1']").val();
            var enddate = $("*[id$='txtDate2']").val();
            var fromhr = $("*[id$='txtTime1']").val();
            var tohr = $("*[id$='txtTime2']").val();

            var dArray = "{'CampaignID': '" + campaignid + "',";
            dArray += "'startdate': '" + startdate + "',";
            dArray += "'enddate': '" + enddate + "',";
            dArray += "'fromhr': '" + fromhr + "',";
            dArray += "'tohr': '" + tohr + "'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetDispositionsBySubId",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#divGrid').html(response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function ShowLeads(campaignid, subid1, status) {
            var title = $("#dialog-subids").dialog("option", "title") + ' > ' + subid1 + ' > ' + status;

            $("#dialog-leads").dialog("open");
            $("#dialog-leads").dialog("option", "title", title);

            $('#divGrid2').html('<img src="../images/loader3.gif" alt="loading..." />');

            var startdate = $("*[id$='txtDate1']").val();
            var enddate = $("*[id$='txtDate2']").val();
            var fromhr = $("*[id$='txtTime1']").val();
            var tohr = $("*[id$='txtTime2']").val();

            var dArray = "{'CampaignID': '" + campaignid + "',";
            dArray += "'SubId1': '" + subid1 + "',";
            dArray += "'IdentStatus': '" + status + "',";
            dArray += "'startdate': '" + startdate + "',";
            dArray += "'enddate': '" + enddate + "',";
            dArray += "'fromhr': '" + fromhr + "',";
            dArray += "'tohr': '" + tohr + "'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetDispositionLeadsBySubId",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#divGrid2').html(response.d);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float:left">
                <h2>Dialer Disposition Analysis</h2>
            </div>
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
                            <asp:CheckBox ID="chkShowPct" runat="server" Text="Show %" TextAlign="Left" Checked="true" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory" runat="server" DataSourceID="ds_Cat" DataTextField="Category" DataValueField="Category">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="ds_Cat" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>" SelectCommandType="Text" SelectCommand="select Category from tblCategory order by Category"></asp:SqlDataSource>
                        </td>
                        <td>
                            |
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
                    <asp:GridView ID="gvCampaigns" runat="server" AutoGenerateColumns="true" GridLines="None"
                        BorderStyle="None" RowStyle-CssClass="griditem2" AlternatingRowStyle-CssClass="griditem2 altrow" HeaderStyle-CssClass="headitem3" Width="100%"
                        ShowFooter="true" CellPadding="2">
                        <EmptyDataTemplate>
                            <p>No dialer dispositions available for this date range.</p>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
            <asp:PlaceHolder ID="phrJsRunner" runat="server"></asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div id="dialog-subids" title="">
        <div id="divGrid">
        </div>
    </div>
    <div id="dialog-leads" title="">
        <div id="divGrid2">
        </div>
    </div>
</asp:Content>