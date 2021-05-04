<%@ Page Title="Archived Document" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ArchiveViewer.aspx.vb" Inherits="ArchiveViewer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

<table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0">
        <tr>
            <td style="color: #666666; padding-bottom: 15px">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/default.aspx">Home</a>&nbsp;>&nbsp;
                <a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/Search.aspx">Search</a>&nbsp;>&nbsp;Archived Clients
            </td>
        </tr>
</table>

<iframe id="frViewer" runat="server" width="100%" height="90%" scrolling="auto" title="Archived Client File"></iframe>

</asp:Content>

