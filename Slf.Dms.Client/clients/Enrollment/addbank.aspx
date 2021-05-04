<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addbank.aspx.vb" Inherits="Enrollment_addbank" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Bank</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    } 
	
	function txtZipCode_OnBlur(obj)
	{
		var txtCity = document.all("txtCity");
		var cboStateID = document.all("cboStateID");

		if (obj.value.length > 0)
		{
		    var zipXml = new ActiveXObject("Microsoft.XMLDOM");

		    zipXml.async = false;

			zipXml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + obj.value);

			var address = zipXml.getElementsByTagName("address")[0];

			if (address != null && address.attributes.length > 0)
			{
				if (address.attributes.getNamedItem("city") != null)
				{
					txtCity.value = address.attributes.getNamedItem("city").value;
				}

				if (cboStateID != null)
				{
					if (address.attributes.getNamedItem("stateabbreviation") != null) {
						for (i = 0; i < cboStateID.options.length; i++) {
							if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
								cboStateID.selectedIndex = i;
						}
					}
				}
			}
			else
			{
			    txtCity.value = "";
			    cboStateID.selectedIndex = 0;
			}
		}
		else
		{
		    txtCity.value = "";
		    cboStateID.selectedIndex = 0;
		}
	}
	 function RoutingNumberLengthCheck(source, clientside_arguments)
   {         
      if (clientside_arguments.Value.length == 9 )
      {
         clientside_arguments.IsValid=true;
      }
      else {clientside_arguments.IsValid=false};
   }
   
   function PromptCheckType(){
        var rd = document.getElementsByName('radDepositTypeList');
         for (var i = 0; i < rd.length; i ++) {
            if (rd[i].checked) {
              if (rd[i].value=='Deposit By Check'){
                 if (confirm('Are you sure the deposit method is Check?')==false) {
                    return false; 
                 }
              }
            }
         }
        return true;   
   }

    </script>

    <form id="form1" runat="server" style="height: 100%;">
    <asp:Panel runat="server" ID="pnlMain" Style="width: 100%; height: 100%;">
        <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display: none;">
                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                            width="100%" border="0">
                            <tr>
                                <td valign="top" width="20">
                                    <img id="Img1" runat="server" src="~/images/message.png" align="absMiddle" border="0">
                                </td>
                                <td runat="server" id="tdError">
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top: 15; height: 100%;">
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td colspan="2">
                                <asp:RadioButtonList ID="radDepositTypeList" runat="server" RepeatDirection="Horizontal"
                                    Font-Names="tahoma" Font-Size="11px" TabIndex="0" AutoPostBack="True">
                                    <asp:ListItem >Deposit By ACH</asp:ListItem>
                                    <asp:ListItem Selected="True" >Deposit By Check</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Bank:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="1" Font-Names="tahoma" Font-Size="11px" runat="server"
                                    ID="txtName" Width="100%"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                    ControlToValidate="txtName" Display="Dynamic" 
                                    ErrorMessage="Bank Name is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Street:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="2" ID="txtStreet" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Street 2:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="3" ID="txtStreet2" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                City, State Zip:
                            </td>
                            <td style="width: 200px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td>
                                            <asp:TextBox TabIndex="5" ID="txtCity" runat="server" Font-Names="tahoma" Font-Size="11px"
                                                Width="100%"></asp:TextBox>
                                        </td>
                                        <td style="width: 40px; padding-right: 7px; padding-left: 7px;">
                                            <asp:DropDownList TabIndex="6" ID="cboStateID" runat="server" Font-Names="Tahoma"
                                                Font-Size="11px" Width="100%">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 45px">
                                            <asp:TextBox MaxLength="50" TabIndex="4" ID="txtZipCode" runat="server" Font-Names="tahoma"
                                                Font-Size="11px" Width="100%"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 80px">
                                Phone:
                            </td>
                            <td style="width: 95px">
                                <igtxt:WebMaskEdit runat="server" ID="txtPhoneNumber1" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%" InputMask="(###) ###-####" TabIndex="7">
                                </igtxt:WebMaskEdit>
                            </td>
                            <td style="width: 55px">
                                <asp:TextBox ID="txtPhoneExtension1" runat="server" Font-Names="tahoma" Font-Size="11px"
                                    MaxLength="10" TabIndex="8" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td colspan="2">
                                <asp:RadioButtonList ID="radAcctType" runat="server" RepeatDirection="Horizontal"
                                    Font-Names="tahoma" Font-Size="11px" TabIndex="9">
                                    <asp:ListItem>Account Type Savings</asp:ListItem>
                                    <asp:ListItem>Account Type Checking</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:Label ID="lblInvalidAccType" runat="server" ForeColor="Red" style="text-align: center; width: 100%"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px; vertical-align:top; padding-top:4px;">
                                Routing #:
                            </td>
                            <td style="width: 200px">
                                <igtxt:WebMaskEdit runat="server" ID="RoutingNumber" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%" InputMask="AAAAAAAAA" TabIndex="10">
                                </igtxt:WebMaskEdit><asp:Label ID="lblInvalidRouting" runat="server" ForeColor="Red"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="RoutingNumber" Display="Dynamic" 
                                    ErrorMessage="Rounting # is required!"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="RoutingNumber"
                                    ErrorMessage="9 Digits are Required!" ClientValidationFunction="RoutingNumberLengthCheck"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px; vertical-align:top; padding-top:4px;">
                                Account #:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" Font-Names="tahoma" Font-Size="11px" runat="server"
                                    ID="AccountNumber" Width="100%" TabIndex="11"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="AccountNumber" Display="Dynamic" 
                                    ErrorMessage="Account # is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                    <asp:LinkButton runat="server" ID="lnkSave"  ></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                    padding-right: 10px;" valign="top">
                    <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                        cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <a tabindex="16" style="color: black" class="lnk" href="javascript:window.close();">
                                    <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                        border="0" align="absMiddle" />Cancel and Close</a>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="lnkAddBank" runat="server" Text="Add Bank" OnClientClick="return PromptCheckType();"/>
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absMiddle" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    
    </form>
</body>
</html>
