<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Password.aspx.vb" Inherits="Password" %>

<%@ Register Assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Campayne Manager | Password Change</title>
    <link href="css/identi-style.css" rel="stylesheet" type="text/css" />
    <link href="jquery/passwordStrength/password_strength.css" rel="stylesheet" type="text/css" />

    <link rel="Stylesheet" href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.17/themes/ui-lightness/jquery-ui.css" />
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.17/jquery-ui.js"></script>
    <script type="text/javascript" src="jquery/passwordStrength/password_strength_plugin.js"></script>

    <script type="text/javascript">
            $(document).ready(function () {
                $(".jqButton").button();
               
                $("#<%=txtNewPassword.ClientID %>").passStrength({
                    shortPass:              "shortPass",     
                    badPass:                "badPass",    
                    goodPass:               "goodPass",
                    strongPass:             "strongPass",
                    samePassword:           "Old Password and New Password are identical!",
                    baseStyle:              "testresult",
                    userid:                 "#<%=txtOldPassword.ClientID %>",                                        
                    messageloc:             1
                });
            });
    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <asp:ToolkitScriptManager ID="tspMan" runat="server" />
    <div class="login-wrapper">
        <div class="login-inner">
            <div class="login-headerwrap">
                <div class="login-header-left">
                    <img border="0" src="images/campaynemgr-logo.png" alt="Campayne Mgr" />
                </div>
                <!-- end header-left -->
                <div class="login-header-right">
                   
                </div>
                <!-- end header-right -->
            </div>
            <!-- end headerwrap -->
             <div class="login-main-top" >
             <h4>
                    Change Password</h4>
                <h5>
                    Old Password</h5>
                <asp:TextBox ID="txtOldPassword" runat="server" Width="250px" BackColor="#F3F3F3" BorderColor="#d1d1d7"
                    BorderStyle="Solid" BorderWidth="1px" Height="24px" MaxLength="50" CausesValidation="True"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Old Password is required"
                    ControlToValidate="txtOldPassword" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                <div style="padding-bottom: 10px;">
                </div>
                <h5>
                    New Password</h5>
                <asp:TextBox ID="txtNewPassword" runat="server" Width="250px" BackColor="#F3F3F3" BorderColor="#d1d1d7"
                    BorderStyle="Solid" BorderWidth="1px" Height="24px" TextMode="Password" MaxLength="50" style="float:left;"
                    CausesValidation="True"></asp:TextBox>
                 <%--<asp:PasswordStrength ID="txtNewPassword_PasswordStrength" runat="server" 
                     DisplayPosition="BelowLeft" Enabled="True" MinimumNumericCharacters="1"  MinimumUpperCaseCharacters="1" MinimumLowerCaseCharacters="6"
                      RequiresUpperAndLowerCaseCharacters="true" CalculationWeightings="30;25;25;20" TextStrengthDescriptions="Very Poor;Weak;Average;Strong;Excellent"
                     PreferredPasswordLength="8" TargetControlID="txtNewPassword">
                 </asp:PasswordStrength>--%>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="New Password is required"
                    ControlToValidate="txtNewPassword" Text="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <br />
                 

                <div style="padding-bottom: 40px;" id="div1" runat="server">
                </div>
                <asp:Button ID="btnChangePwd" runat="server" Text="Change Password" CssClass="jqButton"  />
            </div>
            <!-- end main-top -->
        </div>
        <!-- end inner -->
    </div>
    <!-- end wrapper -->
    <div class="login-footer">
        Copyright &copy;2011 - <%=Now.Year%> CampayneMgr.com
    </div>
    <!-- end footer -->
    </form>
 
</body>
</html>
