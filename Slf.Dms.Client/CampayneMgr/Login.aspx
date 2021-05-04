<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Campayne Manager | Login</title>
    <link href="css/identi-style.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="jquery/css/ui-lightness/jquery-ui-1.8.20.custom.css" />
    <script type="text/javascript" src="jquery/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="jquery/jquery-ui-1.8.20.custom.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".jqButton").button();
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="login-wrapper">
        <div class="login-inner">
            <div class="login-headerwrap">
                <div class="login-header-left">
                    <img border="0" src="images/campaynemgr-logo.png" alt="Campayne Mgr" />
                </div>
                <!-- end header-left -->
                <div class="login-header-right">
                    <%--<ul>
				<li><a href="Default.aspx" title="Home">Home</a></li>
				<li><a href="contact.aspx" title="Contact Us">Contact Us</a></li>
			</ul>--%>
                </div>
                <!-- end header-right -->
            </div>
            <!-- end headerwrap -->
            <div class="login-main-top">
                <h4>
                    Account Login</h4>
                <h5>
                    Username</h5>
                <asp:TextBox ID="txtUserName" runat="server" Width="335px" BackColor="#F3F3F3" BorderColor="#d1d1d7"
                    BorderStyle="Solid" BorderWidth="1px" Height="24px" MaxLength="50" CausesValidation="True"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rqUserName" runat="server" ErrorMessage="Username is required"
                    ControlToValidate="txtUserName" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                <div style="padding-bottom: 10px;">
                </div>
                <h5>
                    Password</h5>
                <asp:TextBox ID="txtPassword" runat="server" Width="335px" BackColor="#F3F3F3" BorderColor="#d1d1d7"
                    BorderStyle="Solid" BorderWidth="1px" Height="24px" TextMode="Password" MaxLength="50"
                    CausesValidation="True"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rqPassword" runat="server" ErrorMessage="Password is required"
                    ControlToValidate="txtPassword" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                <div style="padding-bottom: 20px;" id="divMsg" runat="server">
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="Login" Width="126px" CssClass="jqButton" />
            </div>
            <!-- end main-top -->
        </div>
        <!-- end inner -->
    </div>
    <!-- end wrapper -->
    <div class="login-footer">
        Copyright &copy;2011 -
        <%=Now.Year%>
        CampayneMgr.com
    </div>
    <!-- end footer -->
    </form>
</body>
</html>
