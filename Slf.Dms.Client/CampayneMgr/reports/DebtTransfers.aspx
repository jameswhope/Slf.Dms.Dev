<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="DebtTransfers.aspx.vb" Inherits="reports_DebtTransfers" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .jqSaveButton
        {
        }
        .currRow
        {
            background-color: blue;
            cursor: pointer;
        }
        fieldset
        {
            border: solid 1px #f6a828;
        }
        .headitem2
        {
            background-color: #e5e5e5;
	        border-top: solid 1px #bbbbbb;
	        border-bottom: solid 1px #bbbbbb;
	        white-space: nowrap;
	        font-family: Arial;
	        font-size: 8px;
	        font-weight: bold;
        }
    </style>

    <script type="text/javascript">

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

        function ValidateFilter(){
            if ($("[id$='ddlCampaigns']").val() == -1) {
                alert('Please enter a campaign.');
                return false;
            }
            return true;
        }

        
    </script>

    <script type="text/javascript">
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);

        function pageLoad() {
            docReady();
        }
        function docReady() {

            var windowWidth = $(window).width(); //retrieve current window width
            var windowHeight = $(window).height(); //retrieve current window height
             
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-SrcCampaigns").dialog({
                    autoOpen: false,
                    width: windowWidth-30,
                    height: windowHeight-30,
                    modal: true,
                    position: [10, 10]
                });
                $(".jqButton").button();
                $(".jqAddButton").button({
                    icons: {
                        primary: "ui-icon-plusthick"
                    },
                    text: false
                });
                $(".jqDeleteButton").button({
                    icons: {
                        primary: "ui-icon-trash"
                    },
                    text: false
                });
                $(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
                $(".jqSaveButtonNoText").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: false
                });
                $(".jqSaveButtonWithText").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
                $(".jqRefreshButton").button({
                    icons: {
                        primary: "ui-icon-refresh"
                    },
                    text: false
                });
                $(".jqFirstButton").button({
                    icons: {
                        primary: "ui-icon-seek-first"
                    },
                    text: false
                });
                $(".jqPrevButton").button({
                    icons: {
                        primary: "ui-icon-seek-prev"
                    },
                    text: false
                });
                $(".jqNextButton").button({
                    icons: {
                        primary: "ui-icon-seek-next"
                    },
                    text: false
                });
                $(".jqLastButton").button({
                    icons: {
                        primary: "ui-icon-seek-end"
                    },
                    text: false
                });
                $(".jqFilterButton").button();
//                $(".jqExportButton").button();
//                $(".jqExportButton").click(function () {
//                    if (!ValidateFilter()) return false;
//                    Export();
//                });
            });
        }
        
        
    </script>
    <script type="text/javascript">
        function ShowBreakdown(advertiserid, rto, vertical, direct) {
            $("#dialog-SrcCampaigns").data('advertiserid', advertiserid);
            $("#dialog-SrcCampaigns").data('rto', rto);
            $("#dialog-SrcCampaigns").data('vertical', vertical);
            $("#dialog-SrcCampaigns").dialog("open");
            getSrcCampaigns(direct);
        }

        function getSrcCampaigns(direct) {
            $('#divLoadingSrcCampaigns').html('<img src="../images/loader3.gif" alt="loading..." />');

            var advertiserid = $("#dialog-SrcCampaigns").data('advertiserid');
            var rto = $("#dialog-SrcCampaigns").data('rto');
            var vertical = $("#dialog-SrcCampaigns").data('vertical');
            var startdate = $("*[id$='txtDate1']").val();
            var enddate = $("*[id$='txtDate2']").val();

            var dArray = "{'advertiserid': '" + advertiserid + "',";
            dArray += "'rto': '" + rto + "',";
            dArray += "'vertical': '" + vertical + "',";
            dArray += "'startdate': '" + startdate + "',";
            dArray += "'enddate': '" + enddate + "',";
            dArray += "'direct': '" + direct + "'}";

            $.ajax({
                type: "POST",
                url: "../service/cmService.asmx/GetSrcCampaignsByAdvertiser",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#divSrcCampaigns').html(response.d);
                    $('#divLoadingSrcCampaigns').html('');
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }
    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="float:left; padding-top:5px;">
                <h2>Debt Transfers To Client Intake Department</h2>
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
                            <asp:DropDownList ID="ddlQuerySource" runat="server">
                            </asp:DropDownList>                        
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" PopupButtonID="imgDate1" />&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="7"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" PopupButtonID="imgDate2" />&nbsp;&nbsp;
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" Font-Size="8pt" CssClass="jqFilterButton" />
                            </small>
                        </td>
                        <%--<td>
                            <small>
                               <asp:Button ID="btnExport" runat="server" Text="Export" Font-Size="8pt" CssClass="jqExportButton"  />
                            </small>
                        </td>--%>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvCallCenterTransferOverview" runat="server" Width="100%" HeaderStyle-Font-Size=".9em" AutoGenerateColumns="false"
                    RowStyle-Font-Size = ".8em" GridLines="None" Caption="<div class='ui-widget-header'>Overview of Transferred Leads to CID</div>"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow">
                        <Columns>
                            <asp:TemplateField HeaderText="<br/>Advertiser" SortExpression="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="nothing" runat="server" Text="All"/>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem2" HorizontalAlign="Left" width="200"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" width="200"/>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Ttl Leads" HeaderText="Total<br/>Leads" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                             <asp:BoundField DataField="Ttl Returned" HeaderText="Total<br/>Returned" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                           <asp:BoundField DataField="Called" HeaderText="<br/>Called" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contacted" HeaderText="<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Contacted" HeaderText="Percent<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Not Contacted" HeaderText="Not<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dials" HeaderText="<br/>Dials" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DialsPerContact" HeaderText="Dials Per<br/>Contact" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Transferred" HeaderText="<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Transferred" HeaderText="Percent<br/>Transferred" HtmlEncode="false" DataFormatString="{0:p2}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contracts Sent" HeaderText="Contracts<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Sent" HeaderText="Percent<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Contracts Signed" HeaderText="Contracts<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Signed" HeaderText="Percent<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>                             
                        </Columns>                        
                    </asp:GridView>
                </div>
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvDebtTransfersByCallCenter" runat="server" Width="100%" AutoGenerateColumns="false"
                   GridLines="None" Caption="<div class='ui-widget-header'>Debt Leads / Call Center</div>"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" ShowFooter="true">
                        <Columns>
                            <asp:TemplateField HeaderText="<br/>Advertiser" SortExpression="Advertiser">
                                <ItemTemplate>
                                    <asp:LinkButton ID="showSrcCampaigns" runat="server" Text='<%# eval("Advertiser") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem2" HorizontalAlign="Left" width="200"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" width="200"/>
                                <FooterStyle CssClass="footeritem2" HorizontalAlign="Left" Width="200" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Ttl Leads" HeaderText="Total<br/>Leads" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Ttl Returned" HeaderText="Total<br/>Returned" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                           <asp:BoundField DataField="Called" HeaderText="<br/>Called" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contacted" HeaderText="<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Contacted" HeaderText="Percent<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Not Contacted" HeaderText="Not<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dials" HeaderText="<br/>Dials" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DialsPerContact" HeaderText="Dials Per<br/>Contact" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Transferred" HeaderText="<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Transferred" HeaderText="Percent<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contracts Sent" HeaderText="Contracts<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Sent" HeaderText="Percent<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField> 
                            <asp:BoundField DataField="Contracts Signed" HeaderText="Contracts<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Signed" HeaderText="Percent<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>                             
                        </Columns>                        
                    </asp:GridView>
                </div>
            </div>
            <%--<div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvDirectTransferOverview" runat="server" Width="100%" HeaderStyle-Font-Size=".9em" AutoGenerateColumns="false"
                    RowStyle-Font-Size = ".8em" GridLines="None" Caption="<div class='ui-widget-header'>Overview of Direct Leads to CID</div>"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow">
                        <Columns>
                            <asp:TemplateField HeaderText="<br/>Advertiser" SortExpression="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="nothing" runat="server" Text="All"/>
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem2" HorizontalAlign="Left" width="200"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" width="200"/>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TtlLeads" HeaderText="Total<br/>Leads" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                           <asp:BoundField DataField="Called" HeaderText="<br/>Called" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contacted" HeaderText="<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PctContacted" HeaderText="Percent<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="NotContacted" HeaderText="Not<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dials" HeaderText="<br/>Dials" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DialsPerContact" HeaderText="Dials Per<br/>Contact" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Transferred" HeaderText="<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PctTransferred" HeaderText="Percent<br/>Transferred" HtmlEncode="false" DataFormatString="{0:p2}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CSent" HeaderText="Contracts<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PctSent" HeaderText="Percent<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="CSigned" HeaderText="Contracts<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PctSigned" HeaderText="Percent<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                            </asp:BoundField>                             
                        </Columns>                        
                    </asp:GridView>
                </div>
            </div>--%>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvDebtTransfersByDirect" runat="server" Width="100%" AutoGenerateColumns="false"
                   GridLines="None" Caption="<div class='ui-widget-header'>Debt Leads / Direct</div>"
                        BorderStyle="None" AlternatingRowStyle-CssClass="altrow" ShowFooter="true">
                        <Columns>
                            <asp:TemplateField HeaderText="<br/>Advertiser" SortExpression="Advertiser">
                                <ItemTemplate>
                                    <asp:LinkButton ID="showSrcCampaigns" runat="server" Text='<%# eval("Advertiser") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headitem2" HorizontalAlign="Left" width="200"/>
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" width="200"/>
                                <FooterStyle CssClass="footeritem2" HorizontalAlign="Left" width="200"/>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Ttl Leads" HeaderText="Total<br/>Leads" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Ttl Returned" HeaderText="Total<br/>Returned" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                           <asp:BoundField DataField="Called" HeaderText="<br/>Called" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contacted" HeaderText="<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Contacted" HeaderText="Percent<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Not Contacted" HeaderText="Not<br/>Contacted" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dials" HeaderText="<br/>Dials" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DialsPerContact" HeaderText="Dials Per<br/>Contact" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Transferred" HeaderText="<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Transferred" HeaderText="Percent<br/>Transferred" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Contracts Sent" HeaderText="Contracts<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Sent" HeaderText="Percent<br/>Sent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField> 
                            <asp:BoundField DataField="Contracts Signed" HeaderText="Contracts<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="% Signed" HeaderText="Percent<br/>Signed" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem2" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"/>
                                <FooterStyle HorizontalAlign="right" CssClass="footeritem2" />
                            </asp:BoundField>                             
                        </Columns>                        
                    </asp:GridView>
                </div>
            </div>  
            <asp:HiddenField ID="hdnStartDate" runat="server" />
        </ContentTemplate>
        <%--<Triggers>
            <asp:PostBackTrigger ControlID ="lnkExport"/>
        </Triggers> --%>
    </asp:UpdatePanel>
    <div id="dialog-SrcCampaigns" title="Source Campaigns By Advertiser">
        <div>
            <button id="btnRefreshSrcCampaigns" class="jqRefreshButton" style="float:right!important" onclick="return getSrcCampaigns()">Refresh</button>
            <div id="divLoadingSrcCampaigns" style="float:left;"></div> 
        </div>
        <div style="clear:both; padding-bottom:3px" />
        <div id="divSrcCampaigns">
        </div>
    </div>
</asp:Content>

