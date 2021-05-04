<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta name="apple-touch-fullscreen" content="YES" />
    <style type="text/css" media="screen">
        @import "iui.css";
    </style>

    <script type="application/x-javascript" src="iui.js"></script>
</head>
<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
    </div>
    <ul id="home" title="Home" selected="true">
        <li><a href="#financial">Financial</a></li>
        <li><a href="#clients">Clients</a></li>
        <li><a href="http://service.lexxiom.com/mobile/iui/financial/fees-and-payments.aspx" target="_self">Flick Test</a></li>
    </ul>
    <ul id="financial" title="Financial">
        <li><a href="financial/fees-and-payments.aspx">Client Fees & Payments</a></li>
        <li><a href="financial/deposits.aspx">Client Deposits</a></li>
        <li><a href="financial/fees-paid.aspx">Agent Fees Paid</a></li>
    </ul>
    <ul id="clients" title="Clients">
        <li><a href="clients/default.aspx">Clients</a></li>
        <li><a href="clients/deposits.aspx">Client Deposits</a></li>
        <li><a href="clients/longevity.aspx">Longevity</a></li>
    </ul>
</body>
</html>
