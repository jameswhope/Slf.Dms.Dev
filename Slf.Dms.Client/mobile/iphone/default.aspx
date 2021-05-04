<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="mobile_iphone_default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile</title>
    
    <style type="text/css" media="screen">
        @import "jqtouch/themes/jqt/jqtouch.css";
    </style>

    <script type="text/javascript" src="http://www.google.com/jsapi"></script>

    <script type="text/javascript">google.load("jquery", "1.3.2");</script>

    <script src="jqtouch/js/jqtouch.min.js" type="application/x-javascript" charset="utf-8"></script>

    <script type="text/javascript" charset="utf-8">
        $(document).jQTouch({
            icon: 'jqtouch.png',
            statusBar: 'black-translucent'
        });
        $.preloadImages([
        'jqtouch/themes/jqt/img/chevron_white.png',
        'jqtouch/themes/jqt/img/bg_row_select.gif',
        'jqtouch/themes/jqt/img/back_button.png',
        'jqtouch/themes/jqt/img/back_button_clicked.png',
        'jqtouch/themes/jqt/img/button_clicked.png',
        'jqtouch/themes/jqt/img/grayButton.png',
        'jqtouch/themes/jqt/img/whiteButton.png'
        ]);
    </script>

</head>
<body>
    <div id="home" selected="true">
        <div class="toolbar">
            <h1>
                Home</h1>
        </div>
        <ul class="edgetoedge">
            <li><a href="#financial">Financial</a></li>
            <li><a href="#clients">Clients</a></li>
            <li><a href="#globalroadmap">Global Roadmap</a></li>
            <li><a class="flip" href="#flipdemo">Flip Test &raquo;</a></li>
            <!--<li><a href="http://service.lexxiom.com/mobile/financial/fees-and-payments.aspx">Flick
                Test &raquo;</a></li>-->
            <li><a class="slideup" id="infoButton" href="#about">About</a></li>
        </ul>
    </div>
    <div id="about" class="panel">
        <div class="pad" style="padding-top: 40px; text-align: center">
            <p>
                Lexxiom Mobile for iPhone<br />
                Version 1.0 BETA<br />
                All rights reserved.<br />
                Contact: <a href="mailto:itdevelopers@lexxiom.com">IT Dept.</a></p>
            <a href="#" class="grayButton back">Close</a>
        </div>
    </div>
    <div id="financial">
        <div class="toolbar">
            <h1>
                Financial</h1>
            <a class="back button" href="#home">Home</a>
        </div>
        <ul class="edgetoedge">
            <li><a href="#feespayments">Client Fees & Payments</a></li>
            <li><a href="#clientdeposits">Client Deposits</a></li>
            <li><a href="#feespaid">Agent Fees Paid</a></li>         
        </ul>
    </div>
    <div id="clients" class="panel">
        <div class="toolbar">
            <h1>
                Clients</h1>
            <a class="back button" href="#home">Home</a>
        </div>
        <ul class="edgetoedge">
            <li><a href="#clientsdefault">Clients</a></li>
            <li><a href="#clientdeposits">Client Deposits</a></li>
            <li><a href="#clientlongevity">Longevity</a></li>
        </ul>
    </div>
    <div id="flipdemo" class="panel">
        <div class="pad">
            <div style="font-size: 1.5em; text-align: center; margin: 160px 0 160px; font-family: Marker felt;">
                Cool, huh?
            </div>
            <a href="#" class="back whiteButton">Go back</a>
        </div>
    </div>
    <div id="feespaid" class="panel">
        <div class="toolbar">
            <h1>Fees Paid</h1>
            <a class="back button" href="#">Financial</a>
        </div>
        <div>
            <asp:Repeater ID="rptFeesPaid" runat="server">
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
    </div>
    <div id="feespayments">
        <div class="toolbar">
            <h1>Fees & Payments</h1>
            <a class="back button" href="#">Financial</a>
        </div>
        <ul class="edgetoedge">
            <li>Coming Soon!</li>
        </ul>
    </div>
    <div id="clientsdefault">
        <div class="toolbar">
            <h1>Clients</h1>
            <a class="back button" href="#">Clients</a>
        </div>
        <ul class="edgetoedge">
            <li>Coming Soon!</li>
        </ul>
    </div>
    <div id="clientdeposits">
        <div class="toolbar">
            <h1>Client Deposits</h1>
            <a class="back button" href="#">Clients</a>
        </div>
        <ul class="edgetoedge">
            <li>Coming Soon!</li>
        </ul>
    </div>
    <div id="clientlongevity">
        <div class="toolbar">
            <h1>Longevity</h1>
            <a class="back button" href="#">Clients</a>
        </div>
        <ul class="edgetoedge">
            <li>Coming Soon!</li>
        </ul>
    </div>
    <div id="globalroadmap">
        <div class="toolbar">
            <h1>Global Roadmap</h1>
            <a class="back button" href="#">Home</a>
        </div>
        <ul class="edgetoedge">
            <li>Coming Soon!</li>
        </ul>
    </div>
</body>
</html>
