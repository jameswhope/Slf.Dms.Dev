<%@ Page Title="" Language="VB" MasterPageFile="~/portals/affiliate/affiliate.master"
    AutoEventWireup="false" CodeFile="download.aspx.vb" Inherits="portals_affiliate_download" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalhead" runat="Server">
    <script type="text/javascript">
        var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                loadButtons();
                loadJQGridviewButtons();

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
    </script>
    <script type="text/javascript">
        function CreateCSV(csvtype) {

            var tst = $().toastmessage('showToast', {
                text: 'Generating file...<img src="../../images/loader3.gif" alt="Loading..."/>',
                sticky: true,
                type: 'notice'
            });

             var da = new Object();
             da.DownloadType = csvtype;
             
             var arr = new Array;
             arr.push(<%= Page.User.Identity.Name %>);
             arr.push($("#<%= ddlSites.ClientID %>").val());
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
            <li><a href="Default.aspx">Affiliate Home</a></li>
            <li>Downloads</li>
        </ul>
    </div>
    <div style="clear: both;" />
    <asp:UpdatePanel ID="upDefault" runat="server">
        <ContentTemplate>
            <div class="portlet">
                <div class="portlet-header">
                    :::
                    <asp:Label ID="lblHeader" runat="server" Text="Download Suppression List" /></div>
                <div class="portlet-content">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                Select Site:
                                <asp:DropDownList ID="ddlSites" runat="server" AutoPostBack="True" DataSourceID="dsSites"
                                    DataTextField="Name" DataValueField="Val">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="dsSites" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                    SelectCommand="stp_portals_GetUsersWebsites" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:Parameter Name="userid" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </td>
                            <td align="right" style="width: 100px">
                                <div id="updateDiv" style="display: none;">
                                    <img id="Img1" src="~/images/loader3.gif" runat="server" style="vertical-align: middle"
                                        alt="" />
                                    Loading ...</div>
                            </td>
                            <td>
                                <asp:LinkButton CssClass="jqButton" ID="lnkExport" runat="server" Text="Export" Style="float: right!important"
                                    OnClientClick="return CreateCSV(4);" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
