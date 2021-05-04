<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ReprintCheck.aspx.vb" Inherits="processing_popups_ReprintCheck" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Re Print Check</title>
    <link href="../../css/default.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
     if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }

    function CloseConfirmationWindow()
    {
        if (window.parent.currentModalDialog) {
            window.parent.currentModalDialog.modaldialog("returnValue", -1);
        } else {
            window.returnValue ="-1";
        }
        window.close();
    }

    var txtCheck = null;
    var lblCheck = null;
    var ddlPrinters = null;
    var hdnPrinter = null;

    function LoadControls() {
        txtCheck = document.getElementById("<%= txtCheckNumber.ClientID %>");
        lblCheck = document.getElementById("<%= txtVerifyCheck.ClientID %>");
        ddlPrinters = document.getElementById("<%= ddlPrinters.ClientID %>");
        hdnPrinter = document.getElementById("<%= hdnPrinter.ClientID %>");
    }

    function Record_Save() {
        LoadControls();
        RemoveBorder(txtCheck);
        RemoveBorder(ddlPrinters);
        HideMessage();

        if (lblCheck.innerText == "" || txtCheck.value != lblCheck.innerText) {
            AddBorder(txtCheck);
            ShowMessage("Please Enter a CheckNumber and Click on Confirm. Then Click on Re-Print Checks");
            return;
        }
        
        if (ddlPrinters.value == ""){
            AddBorder(ddlPrinters);
            ShowMessage("Please select a printer");
            return;
        }
        else{
            hdnPrinter.value = ddlPrinters.value;
        }
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>

    }

    function ConfirmCheckNumber() {
        LoadControls();
        RemoveBorder(txtCheck);
        HideMessage();

        if (txtCheck.value == "") {
            AddBorder(txtCheck);
            ShowMessage("Please Enter a CheckNumber to Print");
            return;
        }

        if (isNaN(parseInt(txtCheck.value))) {
            AddBorder(txtCheck);
            ShowMessage("Please Enter a valid Check Number");
            return;
        }
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkConfirm,"") %>

    }
 
    function AddBorder(obj) {
          obj.style.border = "solid 2px red";
          obj.focus();
      }
      function RemoveBorder(obj) {

          obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
          obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
      }
      
      function ShowMessage(Value) {

          var dvError = document.getElementById("<%= dvError.ClientID %>");
          var tdError = document.getElementById("<%= tdError.ClientID %>");

          dvError.style.display = "inline";
          tdError.innerHTML = Value;
      }
      function HideMessage() {
          var dvError = document.getElementById("<%= dvError.ClientID %>");
          var tdError = document.getElementById("<%= tdError.ClientID %>");

          tdError.innerHTML = "";
          dvError.style.display = "none";
      }
    
    </script>


</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table width="100%">
            <tr>
                <td colspan="2">
                    <div runat="server" id="dvError" style="display: none; vertical-align: bottom;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" style="width: 20;">
                                    <img id="Img5" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                </td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td colspan="3" style="font-family:Arial;font-size:11px;">
                                    Enter the Check Number you want to Print. Verify the displayed details. Then click on Re-Print Checks to print a check.
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;" >
                                    Please Enter The CheckNumber To Print:
                                </td>
                                <td align="left" style="width:150px;padding-left:10px;">
                                     <asp:TextBox ID="txtCheckNumber" runat="server" />
                                </td>
                                <td align="left">
                                    <a class="lnk" href="#" onclick="ConfirmCheckNumber();return false;" >Confirm</a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="dvCheckInfo" runat="server">
                        <table style="border-style:solid;border-width:thin;border-color:Black;width:100%">
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Check #:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:Label ID="txtVerifyCheck" runat="server" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Client Name:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:Label ID="txtClientName" runat="server" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Creditor Account Number:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:Label ID="txtCreditorAcct" runat="server" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Firm Name:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:Label ID="txtFirmName" runat="server" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Pay To:
                                </td>
                                <td align="left" 
                                    style="padding-left: 10px; font-family: Arial; font-size: 11px; white-space:nowrap;">
                                    <asp:Label ID="txtCreditorName" runat="server" CssClass="entry2" />
                                    
                                </td>
                                <td align="left" 
                                    style="padding-left: 10px; font-family: Arial; font-size: 11px; white-space:nowrap;">
                                    <asp:LinkButton ID="lnkEditPayTo" runat="server" Text="Change" Style="padding-left: 10px;
                                        display: none;" OnClientClick="return false;"  />
                                    <obo:Flyout ID="Flyout1" runat="server" AttachTo="lnkEditPayTo" Align="RIGHT" 
                                        Position="TOP_LEFT">
                                        <div style="vertical-align:middle; padding:3px">
                                            <table class="entry2" style="background-color: #C6DEF2; height: 75px; border:solid 1px #3D3D3D" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="text-align: center; background-color: #4791C5; color:#fff; font-weight:bold;">
                                                        Enter New Pay To
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding:5px">
                                                        <asp:TextBox ID="txtNewPayTo" runat="server" Width="200" />
                                                    </td>
                                                
                                                </tr>
                                                <tr>
                                                    <td style="text-align:right; padding-right:5px; padding:3px;background-color: #4791C5;">
                                                        <asp:LinkButton ID="lnkUpdatePayTo" runat="server" Text="Save" ForeColor="White" CssClass="lnk" OnClientClick="return confirm('Are you sure you want to update the Pay To?');" />
                                                        
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </obo:Flyout>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Amount:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:Label ID="txtAmount" runat="server" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold;font-size:12px;width:232px;">
                                    Select Printer:
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     <asp:DropDownList ID="ddlPrinters" Width="100" runat="server" AutoPostBack="false" CssClass="entry" />
                                </td>
                                <td align="left" style="padding-left:10px;font-family:Arial;font-size:11px;">
                                     &nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <a style="color: black" class="lnk" href="javascript:window.close();">
                        <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                            border="0" align="Middle" />
                        Cancel and Close </a>
                </td>
                <td align="right">
                    <a style="color: black" class="lnk" href="#" onclick="Record_Save();return false;" >
                        <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                            border="0" align="Middle" />
                          Re-Print Check     </a> 
                </td>
            </tr>
            
        </table>
    </div>
    <asp:LinkButton ID="lnkConfirm" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:HiddenField ID="hdnMatter" runat="server" />
    <asp:HiddenField ID="hdnPrinter" runat="server" />
    </form>
    
</body>
</html>