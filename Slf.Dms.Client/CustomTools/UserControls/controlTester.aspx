<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="controlTester.aspx.vb" Inherits="CustomTools_UserControls_controlTester" %>

<%@ Register src="PaymentArrangementControl.ascx" tagname="PaymentArrangementControl" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
<div style="padding:20px;">
    <uc2:PaymentArrangementControl ID="PaymentArrangementControl1" runat="server" />
</div>
</asp:Content>

