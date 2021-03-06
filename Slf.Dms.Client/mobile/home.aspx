<%@ Page Language="VB" AutoEventWireup="false" CodeFile="home.aspx.vb" Inherits="mobile_home" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta name="apple-touch-fullscreen" content="YES" />
    <link href="css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="home">
        <div class="toolbar">
            <h1>
                Home</h1>
            <asp:ImageButton ID="btnLogout" runat="server" CssClass="toprightimgbutton" ImageUrl="images/logout.png" />
            <h4 id="hWelcome" runat="server">Welcome, First Last</h4>
        </div>
        <ul class="edgetoedge">
            <li><a href="financial/default.aspx">Financial</a></li>
            <li><a href="clients/default.aspx">Clients</a></li>
            <li><a href="kpi-report.aspx?rev=0">KPI Report</a></li>
            <li><a href="kpi-report.aspx?rev=1">Rev-Share KPI</a></li>
            <li><a href="kpi-persistency.aspx">KPI Persistency</a></li>
            <li><a href="revshare-report.aspx">Rev-Share Report</a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/depositanalysisreport.aspx?mobile=1")%>'>Lead Deposit Analysis</a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/depositanalysisreport1.aspx?mobile=1")%>'>Lead Deposit by Hire Date</a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/AttorneyPendingQueue.aspx?mobile=1")%>'>Pending Clients <%=GetPendingClientsCount()%></a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/DashboardAgencyRep.aspx?mobile=1")%>'>Lead Dashboard</a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/DashboardAgencyJQ.aspx?mobile=1")%>'>Sales Dashboard</a></li>
            <li><a href='<%=ResolveUrl("~/clients/enrollment/DepositHistory.aspx?mobile=1")%>'>Deposit Commitments</a></li>
        </ul>
    </div>
    </form>
</body>
</html>
