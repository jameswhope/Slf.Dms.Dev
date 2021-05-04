<%@ Page Title="" Language="VB" MasterPageFile="~/processing/Processing.master" AutoEventWireup="false" CodeFile="PrintQueue.aspx.vb" Inherits="processing_PrintQueue_PrintQueue" %>
<%@ Register Src="../../CustomTools/UserControls/PrintQueueControl.ascx" TagName="PrintQueueControl"   TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphProcessingBody" Runat="Server">
<table class="entry">
    <tr>
        <td>
            <uc1:PrintQueueControl ID="PrintQueueControl1" runat="server" />
        </td>
    </tr>
</table>
</asp:Content>

