<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FeeAdjustment.aspx.vb" Inherits="processing_popups_FeeAdjustment" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Settlement Fee Adjustment</title>
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
    
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    
    <script language="javascript" type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        var txtFees = null;
        var txtSettFees = null;
        var rdAccept = null;
        var rdReject = null;
        var txtConfirm = null;  
        var txtManager = null;      

        function LoadControls() {
            txtSettFees = document.getElementById("<%=txtsettFeeMask.ClientID %>");
            txtFees = document.getElementById("<%=txtDeliveryFees.ClientID %>");
            rdAccept = document.getElementById("<%=radAccept.ClientID %>")
            rdReject = document.getElementById("<%=radReject.ClientID %>")
            txtConfirm  = document.getElementById("<%=txtAuthCode.ClientID %>")
            txtManager  = document.getElementById("<%=txtManager.ClientID %>")
        }
        
        function Record_Save() {
          LoadControls()
          RemoveBorder(txtConfirm)

        RemoveBorder(rdReject)
        RemoveBorder(rdAccept)

       
        if (!(rdReject.checked || rdAccept.checked)) {
            ShowMessage("Please select status")
            AddBorder(rdAccept)
            AddBorder(rdReject)
            return false;
        }
        
        if (txtManager.value == ""){
         ShowMessage("Please Enter the Manager's Username")
            AddBorder(txtManager)
            return false;
       }

       if (txtConfirm.value == ""){
         ShowMessage("Please Enter the confirmation code")
            AddBorder(txtConfirm)
            return false;
       }
          
          <%=Page.ClientScript.GetPostBackEventReference(lnkSave,"") %>
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
      
      function CloseFeeAdjustment()
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
    <form id="frmManagerOverrideInfo" runat="server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="5">
        <table id="table_calc" style="font-size: 8pt; width: 40%" cellpadding="0" cellspacing="0"
            border="0">
            <tr>
                <td style="vertical-align: top;" 
                    class="style2">
                    <table class="box" width="100%">                    
                        <tr style="height: 35px; background-color: #f5f5f5;">
                             <td class="entry2" style="font-weight:bold" colspan="2">
                                Settlement Fee Details
                            </td>                            
                        </tr>
                        <tr>
                            <td class="style2" colspan="2">
                                <div runat="server" id="dvError" style="display: none; vertical-align: bottom;">
                                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                        width="100%" border="0">
                                        <tr>
                                            <td valign="top" style="width: 20;">
                                                <img id="Img1" runat="server" src="~/images/message.png" align="middle" border="0">
                                            </td>
                                            <td runat="server" id="tdError">
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Settlement Fee:
                            </td>
                            <td align="left" class="style3">
                                <asp:Label ID="lblSettlementFee" runat="server" Width="199px" 
                                    CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Delivery Fees:
                            </td>
                            <td align="left" class="style3">
                                <asp:Label ID="lblDelFees" Width="55px" runat="server" CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Delivery Method:
                            </td>
                            <td align="left" class="style3">
                                <asp:Label ID="lblDelMethod" Width="55px" runat="server" CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Adjusted Settlement Fees:
                            </td>
                            <td align="left" class="style3">
                                <asp:TextBox runat="server" id="txtsettFeeMask" width="105px" CssClass="textstyle" 
                                    AutoPostBack="false"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" colspan="2" style="font-weight:bold;">
                                Settlement Fees is adjusted by <asp:Label ID="lblSettDiff" Width="55px" runat="server" CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" nowrap="nowrap">
                                Adjusted Delivery Fees:
                            </td>
                            <td align="left" class="style3">
                                <asp:TextBox runat="server" id="txtDeliveryFees" width="105px" 
                                    CssClass="textstyle" AutoPostBack="false" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5" colspan="2" style="font-weight:bold;">
                                Delivery Fees is adjusted by <asp:Label ID="lblDelDiff" Width="55px" runat="server" CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Next Deposit Date:
                            </td>
                            <td align="left" class="style3">
                                <asp:Label ID="lblNextDepositDate" Width="55px" runat="server" CssClass="entry2" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Next Deposit Amount:
                            </td>
                            <td align="left" class="style3">
                                <asp:Label ID="lblDepositAmount" Width="55px" runat="server" CssClass="entry2" />
                            </td>                            
                        </tr>
                        <tr>
                            <td class="style2">
                                Status
                            </td>
                            <td class="style3">
                                 <asp:RadioButton ID="radAccept" GroupName="radStatus" Text="Accept" runat="server" CssClass="entryFormat" />
                                 <asp:RadioButton ID="radReject" GroupName="radStatus" Text="Reject" runat="server" CssClass="entryFormat" />
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Manager UserName:
                            </td>
                            <td align="left" class="style3">
                                <asp:TextBox runat="server" id="txtManager" width="105px" CssClass="textstyle" 
                                    AutoPostBack="false"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="style5">
                                Enter Authorization Code:
                            </td>
                            <td align="left" class="style3">
                                <asp:TextBox runat="server" id="txtAuthCode" width="105px" CssClass="textstyle" 
                                    AutoPostBack="false" TextMode="Password" MaxLength="50"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>        
        <table style="font-size: 8pt; width: 40%;" cellpadding="0" cellspacing="0" 
        border="0">
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
                        Save and Process </a>                    
                </td>
            </tr>
        </table>
    </table>

    <asp:LinkButton id="lnkSave" runat="server" text=""></asp:LinkButton>
    </form>
</body>

</html>