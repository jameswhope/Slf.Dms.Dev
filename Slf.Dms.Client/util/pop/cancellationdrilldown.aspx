<%@ Page Language="VB" AutoEventWireup="true" CodeFile="cancellationdrilldown.aspx.vb" Inherits="util_pop_cancellationdrilldown" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cancellation Drilldown</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
</head>

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;overflow:auto;">
<form runat="server" action="">
    <table style="width:100%;height:100%;vertical-align:top;">
        <tr>
            <td>
                <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="5" cellspacing="0">
                    <tr style="background-color:#E5E5E5;border-bottom:solid 1px #C0C0C0;">
                        <td>
                            Account Number
                        </td>
                        <td>
                            Client Name
                        </td>
                        <td>
                            Date Cancelled
                        </td>
                        <td>
                            Refund Amount
                        </td>
                    </tr>
                    <asp:Repeater ID="rptDrillDown" runat="server">
                        <ItemTemplate>
                            <tr style="background-color:<%#IIf(Container.ItemIndex Mod 2 = 0, "#FFFFFF", "#F0F0F0") %>">
                                <td>
                                    <%#CType(Container.DataItem, DrillDown).AccountNumber %>
                                </td>
                                <td>
                                    <%#CType(Container.DataItem, DrillDown).Name %>
                                </td>
                                <td>
                                    <%#CType(Container.DataItem, DrillDown).Cancelled.ToString("MM/dd/yyyy") %>
                                </td>
                                <td>
                                    <%#CType(Container.DataItem, DrillDown).Refund.ToString("c") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </td>
        </tr>
        <tr style="height:100%;">
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</form>
</body>
</html>