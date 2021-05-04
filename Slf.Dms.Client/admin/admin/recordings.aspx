<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="recordings.aspx.vb" Inherits="admin_recordings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
    <table style="margin-left:15px">
        <tr>
            <td colspan="2">
                Directory scanned:<br />
                <asp:TextBox ID="txtDir" runat="server" Width="300px" Text="\\dmf-fnp-0001\e$\RECORDINGS"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Size:
            </td>
            <td>
            <asp:Label ID="lblSize" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Files:
            </td>
            <td>
            <asp:Label ID="lblFiles" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Folders:
            </td>
            <td>
            <asp:Label ID="lblFolders" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Max Size:
            </td>
            <td>
            <asp:Label ID="lblMaxSize" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Avg Size:
            </td>
            <td>
            <asp:Label ID="lblAvgSize" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Content>

