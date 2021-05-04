<%@ Page Title="" Language="VB" MasterPageFile="~/negotiation/Negotiation.master" AutoEventWireup="false" CodeFile="DialerCall.aspx.vb" Inherits="negotiation_DialerCall" %>
<%@ Register src="../CustomTools/UserControls/DialerCallX.ascx" tagname="DialerCallX" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
   <uc1:DialerCallX ID="DialerCallX1" runat="server" />
 </asp:Content>

