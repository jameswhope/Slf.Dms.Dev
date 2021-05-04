<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false" CodeFile="VicidialReport.aspx.vb" Inherits="reports_VicidialReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     //initial jquery stuff
     function pageLoad() {
         docReady();
     }

     function docReady() {
         $(document).ready(function () {
            $(".jqButton").button();
             $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .prepend("<span class='ui-icon ui-icon-gear' title='hide/show filter options'></span>")
				        .end()
			        .find(".portlet-content");
             $(".portlet-header .ui-icon").click(function () {
                 $('.jqDateTbl').toggle();
             });
         });
    }

    
     }

     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<iframe id="ViciReportFrame" src="http://192.168.1.4/admin-reports" marginheight="0" marginwidth="0" width="100%" height="700px" frameborder="0" style="overflow: scroll;" >
</iframe> 
</asp:Content>

