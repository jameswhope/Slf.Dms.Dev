<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EmailCheckByPhone.aspx.vb" Inherits="processing_popups_EmailCheckByPhone" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Email Check By Phone Confirmation</title>
    <link href="<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>" type="text/css"rel="stylesheet"  />
    <link href="<%= ResolveUrl("~/css/default.css") %>" type="text/css"rel="stylesheet"  />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        
        function docReady() {
            $(document).ready(function() {
                $('#<%=btnSend.ClientId %>').button().unbind("click").click(function() { return SendEmail(); });
                $('#<%=btnClose.ClientId %>').button().unbind("click").click(function() { CloseWnd(); });
            });
        }
        
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        function IsValidEmailAddress(value){
            return (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value));
        }
        
        function IsValid(){

            var email = $("#txtEmailConfirmationTo").val();
            email = email.trim()
            if (!email){
                alert("Please enter the email address");
                return false;  
            }
            if (!IsValidEmailAddress(email)){
                alert("The email address format is not valid");
                return false;          
            }
           
            return true;
        }
        
        function SendEmail() {
            if (!IsValid()) return false;
            var emailaddress = $('#<%=txtEmailConfirmationTo.ClientId %>').val();
            return SendCheckByPhoneEmail(emailaddress, '<%= SettlementId%>', '<%= PaymentId%>');
        }
    
        function CloseWnd()
        {
            window.close();
        }

        function SendCheckByPhoneEmail(emailaddress, Id, pId) {  
        var dArray = {emailaddress: emailaddress, paymentid: pId, settlementid: Id};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/EmailCheckByPhone") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                alert(response.d.message);
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
        
</script> 
    
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; margin: 0px 0px 0px 0px;">
    
    <form id="frmSendEmail" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

     <table class="entry" border="0" style="width: 100%; border-top: solid 1px #3D3D3D; height: 125px">
        <tr valign="middle">
            <td class="info">
                <fieldset>
                <legend>Enter Recipient's Email Address</legend>
                <table class="entry">
                <tr>
                <td><asp:TextBox ID="txtEmailConfirmationTo" runat="server" CssClass="entry" /></td>
                <td width="50px"><asp:Button ID="btnSend" runat="server" Text="Send" /></td>
                </tr>
                </table>
                </fieldset>
            </td>
        </tr>
        <tr>
            <td>
                <div class="entry" style="text-align: right; padding-right: 3px; height: 15px; vertical-align: middle;">
                    <asp:Button ID="btnClose" runat="server" Text="Close" />
                </div>
            </td>
        </tr>
    </table>

    </form>
</body>
</html>