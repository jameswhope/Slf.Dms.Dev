<%@ Page Title="Settlement Processing" Language="VB" MasterPageFile="~/negotiation/Negotiation.master"
    AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="negotiation_processing_default"
    EnableEventValidation="false" %>

<%@ MasterType TypeName="negotiation_Negotiation" %>

<%@ Register Src="~/CustomTools/UserControls/SettlementProcessing.ascx" TagName="SettlementProcessing"
    TagPrefix="LexxWebPart" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script language="javascript">
        function SettlementClick(TaskId) {
            window.navigate('<%= ResolveUrl("~/processing/TaskSummary/default.aspx") %>?id=' + TaskId);
        }</script>
    <div style="padding:15px; width:95%">
        <LexxWebPart:SettlementProcessing ID="SettlementProcessing1" runat="server" />
    </div>
</asp:Content>
