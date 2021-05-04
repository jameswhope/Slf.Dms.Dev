<%@ Page Title="" Language="VB" MasterPageFile="~/portals/advertiser/advertiser.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="portals_advertiser_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphPortalHead" runat="Server">
    <style type="text/css">
        .column
        {
            width: 25%;
            float: left;
        }
        .wide
        {
            width: 75%;
            float: left;
        }
    </style>
    <script type="text/javascript">
        var loadingSmall = 'Grabbing Data...<img src="../../images/loader3.gif" alt="loading..." />';
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

                $(".column").disableSelection();
                loadNotifications();
            });
        }
        function loadNotifications() {
        $("#notify-box").html('Searching for Notifications...<img src="../../images/loader3.gif" alt="loading..." />')

        var dArray = "{";
        dArray += "'userid': '" + <%=Page.User.Identity.Name %> + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "<%=resolveurl("~/Service/PortalService.asmx") %>/GetNotifications",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                $("#notify-box").html(response.d);
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    }
    function MarkAsRead(notificationid, elem){
        var dArray = "{";
        dArray += "'notificationid': '" + notificationid + "',";
        dArray += "'userid': '" + <%=Page.User.Identity.Name %> + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "<%=resolveurl("~/Service/PortalService.asmx") %>/MarkAsRead",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function (response) {
                $().toastmessage('showSuccessToast',response.d);
                var pn = elem.parentNode;
                pn.style.display = 'none';
                loadNotifications();
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphPortalBody" runat="Server">
    <div>
        <ul class="breadcrumb">
            <li><a href="#">Advertiser Home</a></li>
        </ul>
    </div>
    <div style="clear: both;" />
    <div class="column">
        <div class="portlet">
            <div class="portlet-header">
                ::: Advertiser Info</div>
            <div class="portlet-content">
                <table style="width: 100%">
                    <tr>
                        <td class="ui-widget-header">
                            Name
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblName" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="ui-widget-header">
                            Account Manager
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblAcctMgr" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="ui-widget-header">
                            Address
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblAddress" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="ui-widget-header">
                            Website
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblWebsite" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="wide column">
        <div class="portlet">
            <div class="portlet-header">
                ::: Notifications
            </div>
            <div class="portlet-content">
                <div id="notify-box" class="notifyBox" />
            </div>
        </div>
    </div>
</asp:Content>
