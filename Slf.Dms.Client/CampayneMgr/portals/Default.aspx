<%@ Page Title="" Language="VB" MasterPageFile="~/portals/portal.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="portals_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/javascript">
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
				        .end()
			        .find(".portlet-content");

        });
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

<div class="portlet">
<div class="ui-widget-header">:::  Portals</div>
<div class="ui-widget-content">
<div style="padding:50px;">
<h2>
Select a Portal from the menu above...
</h2>
</div>
</div>
</div>

    
    
    
    
</asp:Content>
