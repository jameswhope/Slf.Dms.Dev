<%@ Page Language="VB" AutoEventWireup="false" CodeFile="BankActivity.aspx.vb" Inherits="mobile_financial_BankActivity" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lexxiom Mobile</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <link href="../css/mobile.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="Form1" runat="server">
    <div class="toolbar">
        <h1>
            Wells Account Processing</h1>
        <a href="default.aspx" class="backButton">back</a>
        <h3 id="hOptions" runat="server">
        </h3>
    </div>
    <div>
        <asp:GridView ID="gvSummary" runat="server" ShowFooter="False" Caption="Summary" CaptionAlign="Left" AutoGenerateColumns="true"
            DataSourceID="ds_Summary" GridLines="None" CssClass="grid3">
        </asp:GridView>
    </div>
    <div>
        <asp:GridView ID="gvActivity" runat="server" ShowFooter="true" Caption="Detail" CaptionAlign="Left" AutoGenerateColumns="true"
            DataSourceID="ds_Activity" GridLines="None" CssClass="grid3">
        </asp:GridView>
    </div>
    <asp:SqlDataSource ID="ds_Activity" runat="server" SelectCommand="SELECT * FROM tblBankingActivity" SelectCommandType="Text"
        ConnectionString="<%$ AppSettings:connectionstring %>"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ds_Summary" runat="server" SelectCommand="SELECT EffectiveDate,  Account, AccountNumber, Balance FROM tblbankingactivity  WHERE Account LIKE '%Balance%' ORDER BY Account
" SelectCommandType="Text"
        ConnectionString="<%$ AppSettings:connectionstring %>"></asp:SqlDataSource>
</form>
</body>
</html>
