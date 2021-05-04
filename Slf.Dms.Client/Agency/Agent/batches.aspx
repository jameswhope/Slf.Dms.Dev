<%@ Page Language="VB" AutoEventWireup="false" CodeFile="batches.aspx.vb" Inherits="_Agent_Batches" title="Agent Interface" Async="true" %>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Agent Interface</title>
    </head>
    <body style="vertical-align:top;">
        <form id="fmMain" action="#" runat="server">
            <table id="tblLoading" width="100%" visible="true" runat="server">
                <tr>
                    <td>
                        Loading...
                    </td>
                </tr>
            </table>
            <table id="tblHeaders" width="100%" visible="false" runat="server">
                <tr>
                    <td style="width:7%"></td>
                    <td style="width:23%;">Batch</td>
                    <td style="width:57%;">Date</td>
                    <td style="width:13%;">Total</td>
                </tr>
            </table>
            <table id="tblNone" visible="false" runat="server">
                <tr>
                    <td>
                        Sorry, there are no batches available for the
                        specified criteria...
                    </td>
                </tr>
            </table>
            
            <asp:TreeView ID="trvBatches" Width="100%" Height="100%" Visible="false" ShowLines="true" Font-Names="Arial" Font-Size="12px" ShowExpandCollapse="true" ForeColor="Black" ExpandDepth="0" runat="server" />
        </form>
    </body>
</html>