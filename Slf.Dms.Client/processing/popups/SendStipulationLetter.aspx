<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SendStipulationLetter.aspx.vb" Inherits="processing_popups_SendStipulationLetter" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Send Stipulation Letter</title>
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
        .fldMethod
        {
            margin-left: 0px;
            margin-right: 0px;
            padding-right: 0px;
            }

          .custom-combobox {
            position: relative;
            display: inline;
          }
          .custom-combobox-toggle 
          {
            position: absolute !important;
            margin-left: -1px;
            padding: 5px;
            display: inline;
            height: 23px;
           
          }
          .custom-combobox-input 
          {
            margin: 0;
            padding: 5px 10px;
            top: 0px; 
            width: 200px;
          }
          .buffer
          {
              height: 40px;
              } 
         .lnkstipdoc
         {
             width: 16px;
             height: 16px;
             background-image: url(../../images/16x16_pdf.png);
             background-repeat: no-repeat;
             }
             
         .lnkstipdoc a
         {
             width: 16px;
             height: 16px;
             display: inline-block;
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
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.combobox.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        
        function docReady() {
            $(document).ready(function () {
                $(".ddlcombo1").combobox({title: "Select or type email address"});
                $(".ddlcombo2").combobox({readonly: true, title: "Select a printer"});
            });
        }
        
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        function IsValidEmailAddress(value){
            return (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value));
        }
        
        function IsValid(){
            if (!($("#<%=hdnDoc.ClientId %>").val())){
                ShowMessage("There is no document to send!");
                    return false;  
            }
            if ($("#<%=rdEmail.CLientid %>").prop("checked")) {
                var email = $(".ddlcombo1").combobox("getselected");
                email = email.trim()
                if (!email){
                    ShowMessage("Please enter the email address");
                    return false;  
                }
                if (!IsValidEmailAddress(email)){
                    ShowMessage("The email address format is not valid");
                    return false;          
                }
            } else if ($("#<%=rdPrinter.Clientid %>").prop("checked")) {
                //Do nothing
            } else {
              ShowMessage("Please select the method to use.");
              return false;
            }
            
            if(!$("#<%=chkVerified.Clientid %>").prop("checked")){
              ShowMessage("Please confirm you have opened and verified the document.");
              return false;
            }
            return true;
        }
        
        function Record_Save() {
          HideMessage();
          if (!IsValid()) return false;   
          $("#<%=hdnEmail.ClientId %>").val($(".ddlcombo1").combobox("getselected"));
          $("#<%=hdnPrinter.ClientId %>").val($(".ddlcombo2").combobox("getselected"));
          <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
        }

      function ShowMessage(Value) {
        $("#<%= dvError.ClientID %>").html(Value).show();
        $(".buffer").hide();

      }
      function HideMessage() {
           $("#<%= dvError.ClientID %>").empty().hide();
           $(".buffer").show();
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
        <table id="tbsendletter" style="font-size: 8pt; width: 100%" cellpadding="0" cellspacing="0" border="0">
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
                                Document:
                            </td>
                            <td align="left" class="style3">
                                <asp:Literal ID="lblDocument" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                 <fieldset class="fldMethod" >
                                    <legend>Send By:</legend>
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:RadioButton ID="rdEmail" GroupName="radMethod" Text="Email" runat="server" CssClass="entryFormat" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlEmailAddresses" runat="server" CssClass="ddlcombo1">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:RadioButton ID="rdPrinter" GroupName="radMethod" Text="Printer" runat="server" CssClass="entryFormat" />
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlPrinters" runat="server" CssClass="ddlcombo2">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                 </fieldset> 
                            </td>
                        </tr>
                        <tr>
                           <td colspan="2">
                               <span>Note:</span><br/>
                               <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Rows="3" Width="100%" ></asp:TextBox>
                           </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:CheckBox ID="chkVerified" runat="server" Text=" I have verified the Client Stipulation Document. " />
                            </td>
                        </tr>
                          <tr>
                            <td class="style2" colspan="2">
                                <div runat="server" id="dvBuffer" style="display: block; margin-top: 0 !important" class="buffer" >
                                </div>
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
                        Send Letter </a>                    
                </td>
            </tr>
        </table>
    </table>

    <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    <asp:HiddenField ID="hdnDoc" runat="server" />
    <asp:HiddenField ID="hdnPrinter" runat="server" />
    <asp:HiddenField ID="hdnEmail" runat="server" />
    </form>
</body>
</html>