<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ResendCheckByEmail.aspx.vb" Inherits="processing_popups_ResendCheckByEmail"  ValidateRequest="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Send Check By Email</title>
    <style type="text/css">
        .entrycell
        { }
        .entrytitlecell
        {
            width: 85;
        }
        .style1
        {
            width: 211px;
        }
        .entry2
        {
            margin-left: 0px;
        }
        .style2
        {
            width: 199px;
        }
        .textstyle
        {
            font-family:Tahoma;
        }
        .style3
        {
            width: 240px;
            padding-left:10px;
        }
        .style5
        {
            margin-left: 0px;
            width: 199px;
        }
        
    </style>
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
        
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        function IsValidEmailAddress(value){
            return (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value));
        }
        
        function IsValid(){
            var email = $("#<%=txtRecipientEmail.ClientId %>").val();
            email = email.trim()
            if (!email){
                ShowMessage("Please enter the email address");
                return false;  
            }
            if (!IsValidEmailAddress(email)){
                ShowMessage("The email address format is not valid");
                return false;          
            }
            return true;
        }
        
        function Record_Save() {
          HideMessage();
          if (!IsValid()) return false;   
          <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
        }

      function ShowMessage(Value) {
        $("#<%= dvError.ClientID %>").html(Value).show();

      }
      function HideMessage() {
           $("#<%= dvError.ClientID %>").empty().hide();
      }
      
      function CloseSend()
        {
            if (window.parent.currentModalDialog) {
                window.parent.currentModalDialog.modaldialog("returnValue", -1);
             } else {
                window.returnValue ="-1";
             }
            window.close();
        }
    
         function Record_Cancel()
        {
            window.close();
        }
        
</script> 
    
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    
    <form id="frmSendLetter" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="5">
        <table id="tbsendEmail" style="font-size: 8pt; width: 100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td colspan="2" style="vertical-align: top;" class="style2">
                    <table class="box" style="width: 100%;" cellpadding="3">                    
                        <tr>
                            <td class="style2" colspan="2">
                                <div runat="server" id="dvError" style="display: none; margin-top: 0 !important" class="error" >
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" style="width: 40px;">
                               Recipient:
                            </td>
                            <td align="left" class="style3">
                               <asp:HiddenField ID="hdnFromAddress" runat="server" />
                               <asp:HiddenField ID="hdnCheckNumber" runat="server" />
                               <asp:HiddenField ID="hdnClientId" runat="server" />
                               <asp:HiddenField ID="hdnSettlementId" runat="server" />
                               <asp:TextBox ID = "txtRecipientEmail" runat="server" class="style3" style="width: 200px;"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" style="width: 40px;">
                               Date Sent:
                            </td>
                            <td align="left" class="style3">
                               <asp:Label ID = "lblDateSent" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" style="width: 40px;">
                               Sent By:
                            </td>
                            <td align="left" class="style3">
                               <asp:Label ID = "lblSentBy" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" style="width: 40px;">
                               Subject:
                            </td>
                            <td align="left" class="style3">
                               <asp:Label ID = "lblSubject" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                           <td colspan="2">
                               <div style="height: 250px; overflow: scroll;" >
                                <asp:Literal ID="ltrBody" runat="server"></asp:Literal>
                               </div>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="2">
                              <asp:CheckBox ID="chkOverride" runat ="server" Text="Replace Delivery Email Address" />
                           </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>        
        <table style="font-size: 8pt; width: 40%;" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td class="style1">
                    <a tabindex="6" style="color: black" class="lnk" href="javascript:Record_Cancel();">
                        <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                            border="0" align="Middle" />
                        Cancel and Close </a>
                </td>
                <td align="right">
                    <a tabindex="7" style="color: black" class="lnk" href="#" onclick="Record_Save();return false;" >
                        <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                            border="0" align="Middle" />
                        Send Email </a>                    
                </td>
            </tr>
        </table>
    </table>

    <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    <asp:HiddenField ID="hdnEmail" runat="server" />
    </form>
</body>
</html>