<%@ Page Language="VB" EnableEventValidation="false"  MasterPageFile="~/research/negotiation/negotiation.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="research_negotiation_preview_Default" title="DMP - Negotiations" %>
<%@ Register Src="PreviewControl.ascx" TagName="PreviewControl" TagPrefix="uc1" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
<uc1:PreviewControl ID="pvg1" runat="server" />

</asp:Content>

