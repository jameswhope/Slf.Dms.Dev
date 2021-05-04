<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NegotiationFilters.ascx.vb" Inherits="negotiation_webparts_NegotiationFilters" %>

<style type="text/css">
    .checkBoxList
    {
        color: #1080BF;
        font-size: 10px;
    }
</style>

<div style="height:150px;overflow-x:visible;overflow-y:auto;width:300px;">
    <asp:CheckBoxList ID="chkFilters" AutoPostBack="true" CssClass="checkBoxList" runat="server" />
</div>