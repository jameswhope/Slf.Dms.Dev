<%@ Page Language="VB" AutoEventWireup="false" CodeFile="owed-to-gca.aspx.vb" Inherits="mobile_financial_owed_to_gca" %>

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
            Owed to GCA</h1>
        <a href="default.aspx" class="backButton">back</a>
        <h3 id="hOptions" runat="server">
        </h3>
    </div>
    <div>
        <asp:GridView ID="gvOwed" runat="server" ShowFooter="true" AutoGenerateColumns="true"
            DataSourceID="ds_Owed" GridLines="None" CssClass="grid3">
        </asp:GridView>
    </div>
    <asp:SqlDataSource ID="ds_Owed" runat="server" SelectCommand="stp_OwedToGCA" SelectCommandType="StoredProcedure"
        ConnectionString="<%$ AppSettings:connectionstring %>"></asp:SqlDataSource>
        </form>
</body>
</html>
