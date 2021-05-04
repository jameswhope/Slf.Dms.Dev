<%@ Page Language="VB" AutoEventWireup="false" CodeFile="fees-paid.aspx.vb" Inherits="financial_fees_paid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta name="apple-touch-fullscreen" content="YES" />
    <style type="text/css" media="screen">
        @import "iui/iui.css";
    </style>

    <script type="application/x-javascript" src="iui/iui.js"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div class="toolbar">
        <h1 id="pageTitle">
        </h1>
        <a id="backButton" class="button" href="#"></a>
    </div>
    <div>
        <asp:Repeater ID="Repeater1" runat="server">
            <HeaderTemplate>
                <table class="grid">
                    <tr>
                        <th align="left">Recipient</th>
                        <th align="right">Count</th>
                        <th align="right">Amount</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <%#DataBinder.Eval(Container.DataItem, "commrecname")%>
                    </td>
                    <td align="right">
                        <%#DataBinder.Eval(Container.DataItem, "count", "{0:#,##0}")%>
                    </td>
                    <td align="right">
                        <%#DataBinder.Eval(Container.DataItem, "amount", "{0:c}")%>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>
