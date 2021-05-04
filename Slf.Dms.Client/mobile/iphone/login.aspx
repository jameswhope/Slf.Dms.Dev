<%@ Page Language="VB" AutoEventWireup="false" CodeFile="login.aspx.vb" Inherits="mobile_iphone_login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lexxiom Mobile Login</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta name="apple-touch-fullscreen" content="YES" />
    <style type="text/css" media="screen">
        @import "iui/iui.css";
    </style>

    <script type="application/x-javascript" src="iui/iui.js"></script>

</head>
<body style="margin: 0px">
    <form id="form1" runat="server" selected="true">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="width: 100%; border-bottom: solid 2px #000000; padding: 10px; background-color: #fff;">
                <img src="../images/lexxiom_logo.png" /></div>
            <div class="panel">
                <fieldset>
                    <div class="row">
                        <label>
                            Username</label>
                        <input type="text" name="username" value="" id="txtUsername" runat="server" />
                    </div>
                    <div class="row">
                        <label>
                            Password</label>
                        <input type="password" name="password" value="" id="txtPassword" runat="server" />
                    </div>
                </fieldset>
                <asp:LinkButton ID="btnLogin" CssClass="whiteButton" runat="server">Login</asp:LinkButton>
                <div style="color:red; text-align:center; padding:15px;">
                    <asp:Label ID="lblMsgs" runat="server"></asp:Label>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
