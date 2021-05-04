<%@ Page Language="VB" AutoEventWireup="false" CodeFile="revshare-report.aspx.vb" Inherits="mobile_revshare_report"
    EnableViewState="false" %>

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
            Rev-Share Report</h1>
        <a href="home.aspx" class="backButton">back</a>
        <h3 id="hOptions" runat="server">
            <asp:Label ID="lblLastMod" runat="server"></asp:Label>
        </h3>
    </div>
    <div>
        <table class="grid3">
            <tr>
                <th style="width: 140px; white-space:nowrap">
                    &nbsp;
                </th>
                <th style="width: 50px; text-align: center">
                    Total Leads
                </th>
                <th style="width: 50px; text-align: center">
                    RS Leads
                </th>
                <th style="width: 50px; text-align: center">
                    RS Closed
                </th>
                <th style="width: 50px; text-align: center">
                    Std Leads
                </th>
                <th style="width: 50px; text-align: center">
                    New RS
                </th>
                <th style="width: 50px; text-align: center">
                    Attempt Contact
                </th>
                <th style="width: 60px; text-align: center">
                    Contacted
                </th>
                <th style="width: 60px; text-align: center">
                    RS Closed
                </th>
                <th style="width: 60px; text-align: center">
                    RS Contacted
                </th>
                <th style="width: 70px; text-align: right">
                    Spent
                </th>
            </tr>
        </table>
        <ajaxToolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="false"
            FadeTransitions="true" TransitionDuration="50" FramesPerSecond="100" RequireOpenedPane="false">
            <HeaderTemplate>
                <table class="grid3">
                    <tr>
                        <td style="width: 140px; white-space:nowrap">
                            <img src="images/16x16_plus.png" align="absmiddle" style="margin-right:5px" /><%#Eval("monthyr")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("total leads")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("rev share leads")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("rev shares closed")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("standard leads")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("new rev shares")%>
                        </td>
                        <td style="width: 50px; text-align: center">
                            <%#Eval("attempted contact")%>
                        </td>
                        <td style="width: 60px; text-align: center">
                            <%#Eval("contacted")%>
                        </td>
                        <td style="width: 60px; text-align: center">
                            <%#Eval("pct rev shares closed", "{0:P2}")%>
                        </td>
                        <td style="width: 60px; text-align: center">
                            <%#Eval("pct rev shares contacted", "{0:P2}")%>
                        </td>
                        <td style="width: 70px; text-align: right">
                            <%#Eval("marketing budget spent", "{0:C2}")%>
                        </td>
                    </tr>
                </table>
            </HeaderTemplate>
            <ContentTemplate>
                <ajaxToolkit:Accordion ID="accByDay" runat="server" SuppressHeaderPostbacks="false"
                    DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>' FadeTransitions="true"
                    TransitionDuration="50" FramesPerSecond="100" RequireOpenedPane="false" SelectedIndex="-1">
                    <HeaderTemplate>
                        <table class="grid2">
                            <tr>
                                <td style="width: 125px; padding-left: 20px; white-space:nowrap">
                                    <img id="imgPlus" runat="server" src="images/16x16_plus.png" align="absmiddle" alt="" style="margin-right:5px" /><%#Eval("servicefee", "{0:C2}")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("total leads")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("rev share leads")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("rev shares closed")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("standard leads")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("new rev shares")%>
                                </td>
                                <td style="width: 50px; text-align: center">
                                    <%#Eval("attempted contact")%>
                                </td>
                                <td style="width: 60px; text-align: center">
                                    <%#Eval("contacted")%>
                                </td>
                                <td style="width: 60px; text-align: center">
                                    <%#Eval("pct rev shares closed", "{0:P2}")%>
                                </td>
                                <td style="width: 60px; text-align: center">
                                    <%#Eval("pct rev shares contacted", "{0:P2}")%>
                                </td>
                                <td style="width: 70px; text-align: right">
                                    <%#Eval("marketing budget spent", "{0:C2}")%>
                                </td>
                            </tr>
                        </table>
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table class="grid2">
                            <asp:Repeater ID="rptByDay" runat="server" DataSource='<%# Container.DataItem.CreateChildView("Relation2") %>'>
                                <ItemTemplate>
                                    <tr>
                                        <th style="width: 105px; padding-left: 40px; text-align: left">
                                            <%#Eval("createddate")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("total leads")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("rev share leads")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("rev shares closed")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("standard leads")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("new rev shares")%>
                                        </th>
                                        <th style="width: 50px; text-align: center">
                                            <%#Eval("attempted contact")%>
                                        </th>
                                        <th style="width: 60px; text-align: center">
                                            <%#Eval("contacted")%>
                                        </th>
                                        <th style="width: 60px; text-align: center">
                                            <%#Eval("pct rev shares closed", "{0:P2}")%>
                                        </th>
                                        <th style="width: 60px; text-align: center">
                                            <%#Eval("pct rev shares contacted", "{0:P2}")%>
                                        </th>
                                        <th style="width: 70px; text-align: right">
                                            <%#Eval("marketing budget spent", "{0:C2}")%>
                                        </th>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:Accordion>
                </table>
            </ContentTemplate>
        </ajaxToolkit:Accordion>
    </div>
    </form>
</body>
</html>