<%@ Page Language="VB" AutoEventWireup="false" CodeFile="kpi-persistency.aspx.vb"
    Inherits="mobile_kpi_persistency" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <div class="toolbar">
        <h1>
            KPI Persistency</h1>
        <a href="home.aspx" class="backButton">back</a>
        <h3 id="hOptions" runat="server">
            <asp:Label ID="lblLastMod" runat="server"></asp:Label>
        </h3>
    </div>
    <div>
        <table class="grid3">
            <tr>
                <th style="width: 120px; text-align: left">
                    &nbsp;
                </th>
                <th style="width: 70px">
                    Submitted Cases
                </th>
                <th style="width: 90px">
                    Active
                </th>
                <th style="width: 65px">
                    Inactive
                </th>
                <th style="width: 65px">
                    Pending
                </th>
                <th style="width: 65px">
                    Cancelled
                </th>
                <th style="width: 65px">
                    Non Deposit
                </th>
                <th style="width: 70px">
                    Pending Approval
                </th>
                <th style="width: 75px">
                    0-30 days
                </th>
                <th style="width: 70px">
                    31-60 days
                </th>
                <th style="width: 70px">
                    61-90 days
                </th>
                <th style="width: 70px">
                    3-6 months
                </th>
                <th style="width: 70px">
                    6-9 months
                </th>
                <th style="width: 70px">
                    +9 months
                </th>
            </tr>
        </table>
        <ajaxToolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="false"
            FadeTransitions="true" TransitionDuration="50" FramesPerSecond="100" RequireOpenedPane="false">
            <HeaderTemplate>
                <table class="grid3">
                    <tr>
                        <td style="width: 120px; text-align: left">
                            <img src="images/16x16_plus.png" align="absmiddle" style="margin-right: 5px" /><%#Eval("mthyr")%>
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("submittedcases")%>
                        </td>
                        <td style="width: 90px; text-align: center">
                            <%#Eval("active")%>
                            (<%#Eval("activepct", "{0:P1}")%>)
                        </td>
                        <td style="width: 65px; text-align: center">
                            <%#Eval("inactive")%>
                        </td>
                        <td style="width: 65px; text-align: center">
                            <%#Eval("pending")%>
                        </td>
                        <td style="width: 65px; text-align: center">
                            <%#Eval("cancelled")%>
                        </td>
                        <td style="width: 65px; text-align: center">
                            <%#Eval("nondeposit")%>
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("pendingapproval")%>
                        </td>
                        <td style="width: 75px; text-align: center">
                            <%#Eval("30days")%>
                            (<%#Eval("30dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("60days")%>
                            (<%#Eval("60dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("90days")%>
                            (<%#Eval("90dayspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("6months")%>
                            (<%#Eval("6monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("9months")%>
                            (<%#Eval("9monthspct", "{0:P1}")%>)
                        </td>
                        <td style="width: 70px; text-align: center">
                            <%#Eval("9monthsplus")%>
                            (<%#Eval("9monthspluspct", "{0:P1}")%>)
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
            <ContentTemplate>
                <asp:GridView ID="gvPersistency" runat="server" AutoGenerateColumns="false" DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>'
                    BorderStyle="None" CssClass="grid3">
                    <Columns>
                        <asp:BoundField DataField="mthyr" HeaderText="Month" ItemStyle-Width="120px" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="retention" HeaderText="Days" ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="cases" HeaderText="Cancelled" ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="casespct" HeaderText="%" ItemStyle-Width="80px" DataFormatString="{0:P1}"
                            ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </ajaxToolkit:Accordion>
        <asp:Repeater ID="rptFooter" runat="server">
            <ItemTemplate>
        <table class="grid3">
            <tr>
                <th style="width: 120px; text-align: left">
                    &nbsp;
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("submittedcases")%>
                </th>
                <th style="width: 90px; text-align: center">
                    <%#Eval("active")%>
                    (<%#Eval("activepct", "{0:P1}")%>)
                </th>
                <th style="width: 65px; text-align: center">
                    <%#Eval("inactive")%>
                </th>
                <th style="width: 65px; text-align: center">
                    <%#Eval("pending")%>
                </th>
                <th style="width: 65px; text-align: center">
                    <%#Eval("cancelled")%>
                </th>
                <th style="width: 65px; text-align: center">
                    <%#Eval("nondeposit")%>
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("pendingapproval")%>
                </th>
                <th style="width: 75px; text-align: center">
                    <%#Eval("30days")%>
                    (<%#Eval("30dayspct", "{0:P1}")%>)
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("60days")%>
                    (<%#Eval("60dayspct", "{0:P1}")%>)
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("90days")%>
                    (<%#Eval("90dayspct", "{0:P1}")%>)
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("6months")%>
                    (<%#Eval("6monthspct", "{0:P1}")%>)
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("9months")%>
                    (<%#Eval("9monthspct", "{0:P1}")%>)
                </th>
                <th style="width: 70px; text-align: center">
                    <%#Eval("9monthsplus")%>
                    (<%#Eval("9monthspluspct", "{0:P1}")%>)
                </th>
            </tr>
        </table>
        </ItemTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>
