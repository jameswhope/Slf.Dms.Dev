<%@ Page Language="VB" AutoEventWireup="false" CodeFile="client-fees-and-payments.aspx.vb" Inherits="mobile_financial_client_fees_and_payments" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="../css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="toolbar">
        <h1>
           Fees & Payments</h1>
           <a href="default.aspx" class="backButton">back</a>
           <a href="options.aspx?page=client-fees-and-payments" class="button">options</a>
       <h3 id="hOptions" runat="server"></h3>
    </div>
    <div>
            <asp:Repeater ID="Repeater1" runat="server">
                <HeaderTemplate>
                    <table class="grid">
                        <tr>
                            <th align="left">Recipient</th>
                            <th colspan="2">Payments Made</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <%#DataBinder.Eval(Container.DataItem, "feetype")%>
                        </td>
                        <td align="right">
                            <%#DataBinder.Eval(Container.DataItem, "countpaid", "{0:#,##0}")%>
                        </td>
                        <td align="right">
                            <%#DataBinder.Eval(Container.DataItem, "sumpaid", "{0:c}")%>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
</body>
</html>