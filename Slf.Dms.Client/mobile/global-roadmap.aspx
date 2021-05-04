<%@ Page Language="VB" AutoEventWireup="false" CodeFile="global-roadmap.aspx.vb"
    Inherits="mobile_global_roadmap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="toolbar">
            <h1>
                Global Roadmap</h1>
            <a href="home.aspx" class="backButton">back</a>
        </div>
        <table class="grid">
            <thead>
                <tr>
                    <th align="left">
                        Status
                    </th>
                    <th align="right">
                        Clients
                    </th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="Repeater1" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <%#GetGRImg(CType(Container.DataItem, Roadmap))%>
                                <%#CType(Container.DataItem, Roadmap).Name%>
                            </td>
                            <td align="right">
                                <%#CType(Container.DataItem, Roadmap).Count%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
