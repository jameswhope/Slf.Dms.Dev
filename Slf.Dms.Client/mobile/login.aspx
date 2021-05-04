<%@ Page Language="VB" AutoEventWireup="false" CodeFile="login.aspx.vb" Inherits="mobile_login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Lexxiom Mobile Login</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta name="HandheldFriendly" content="true" />  
    <style type="text/css" media="screen">
        @import "css/mobile.css";
    </style>  
</head>
<body style="margin: 0; padding: 0; background: #fff url('images/bg.png') repeat-x;">
    <form id="form1" runat="server">
    <div class="lexxiom">
        <img src="images/lexxiom_logo.png" alt="Lexxiom" /></div>
    <div class="toprow">
        <label>
            Username</label>
        <asp:TextBox ID="txtUsername" runat="server" MaxLength="15"></asp:TextBox>
    </div>
    <div class="botrow">
        <label>
            Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="15"></asp:TextBox>
    </div>
    <asp:ImageButton ID="btnLogin" runat="server" ImageUrl="images/login.png" CssClass="login" />
    <div style="clear:both; padding-left:10px">
        <asp:CheckBox ID="chkFullSite" runat="server" Text="Use full site" />
    </div>
    <div class="msgs">
        <asp:Label ID="lblMsgs" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
