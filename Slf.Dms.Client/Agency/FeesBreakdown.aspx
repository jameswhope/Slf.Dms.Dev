<%@ Page Title="Fee Breakdown" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false" CodeFile="FeesBreakdown.aspx.vb" Inherits="Agency_FeesBreakdown" Debug="true" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
  
<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" Runat="Server">

<script type="text/javascript">
 
    var prm = Sys.WebForms.PageRequestManager.getInstance();
  
    prm.add_beginRequest(function() {
         prm._scrollPosition = null;
     });
  
</script>

                <rsweb:ReportViewer ID="ReportViewer2" runat="server" Visible="true" Enabled="true" Width="100%" Height="95%">
                    
                </rsweb:ReportViewer>
</asp:Content>
