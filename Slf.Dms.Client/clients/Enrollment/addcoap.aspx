<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addcoap.aspx.vb" Inherits="Enrollment_addCoap" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" namespace="AssistedSolutions.WebControls" tagprefix="cc1" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebDataInput" tagprefix="igtxt" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Co-applicant</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">

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
	
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
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
                            <td style="width: 80px">
                                First Name:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="1" Font-Names="tahoma" Font-Size="11px" runat="server"
                                    ID="txtFirst" Width="100%"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="txtFirst" Display="Dynamic" 
                                    ErrorMessage="First Name is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Last Name:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox ID="txtLast" runat="server" Font-Names="tahoma" Font-Size="11px" MaxLength="50"
                                    TabIndex="2" Width="100%"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="txtLast" Display="Dynamic" 
                                    ErrorMessage="Last Name is required!"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Address:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox ID="txtAddress" runat="server" Font-Names="tahoma" 
                                    Font-Size="11px" MaxLength="50"
                                    TabIndex="3" Width="100%"></asp:TextBox>
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
                        <tr>
                            <td style="width: 80px">
                                Relationship:
                            </td>
                            <td style="width: 95px">
                                <asp:DropDownList ID="ddlRelationship" runat="server" CssClass="entry2">
                                    <asp:ListItem>Spouse</asp:ListItem>
                                    <asp:ListItem>Father</asp:ListItem>
                                    <asp:ListItem>Mother</asp:ListItem>
                                    <asp:ListItem>Son</asp:ListItem>
                                    <asp:ListItem>Daughter</asp:ListItem>
                                    <asp:ListItem>Brother</asp:ListItem>
                                    <asp:ListItem>Sister</asp:ListItem>
                                    <asp:ListItem>Friend</asp:ListItem>
                                    <asp:ListItem>Coworker</asp:ListItem>
                                    <asp:ListItem>Other</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Home Phone:
                            </td>
                            <td style="width: 95px">
                            <igtxt:WebMaskEdit ID="txtPhoneNumber1" runat="server" 
                                    InputMask="(###) ###-####" 
                                    Font-Names="tahoma" Font-Size="11px" TabIndex="5">
                                </igtxt:WebMaskEdit>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Business Phone:
                            </td>
                            <td style="width: 95px">
                            <igtxt:WebMaskEdit ID="txtPhoneNumber2" runat="server" 
                                    InputMask="(###) ###-####" 
                                    Font-Names="tahoma" Font-Size="11px" TabIndex="6">
                                </igtxt:WebMaskEdit>
                                
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Cell Phone:
                            </td>
                            <td style="width: 95px">
                              <igtxt:WebMaskEdit ID="txtPhoneNumber3" runat="server" 
                                    InputMask="(###) ###-####" 
                                    Font-Names="tahoma" Font-Size="11px" TabIndex="9">
                                </igtxt:WebMaskEdit>
                            
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Fax Number:
                            </td>
                            <td style="width: 95px">
                                   <igtxt:WebMaskEdit ID="txtPhoneNumber4" runat="server" 
                                    InputMask="(###) ###-####" 
                                    Font-Names="tahoma" Font-Size="11px">
                                </igtxt:WebMaskEdit>
                           
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                SSN:
                            </td>
                            <td style="width: 200px">
                             <igtxt:WebMaskEdit ID="txtSSN" runat="server" 
                                    InputMask="###-##-####" 
                                    Font-Names="tahoma" Font-Size="11px">
                                </igtxt:WebMaskEdit>
                           
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                DOB:
                            </td>
                            <td style="width: 200px">
                            
                            <igtxt:WebDateTimeEdit ID="txtDOB" runat="server" 
                                    Font-Names="tahoma" Font-Size="11px" MaxValue="2500-01-01" 
                                    MinValue="1900-01-01" TabIndex="10">
                                </igtxt:WebDateTimeEdit>
                                
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Email Address:
                            </td>
                            <td style="width: 200px">
                                <asp:TextBox MaxLength="50" TabIndex="11" ID="txtEmailAddress" runat="server" Font-Names="tahoma"
                                    Font-Size="11px" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Can Authorize:
                            </td>
                            <td>
                                <asp:CheckBox ID="chkCanAuth" runat="server" TabIndex="12" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                                padding-right: 10px;" valign="top" colspan="2">
                                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                                    cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <a tabindex="16" style="color: black" class="lnk" href="javascript:window.close();">
                                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                                    border="0" align="absMiddle" />Cancel and Close</a>
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkAddBank" runat="server" Text="Add Co-Applicant" />
                                            <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                                border="0" align="absMiddle" />
                                        </td>
                                    </tr>
                                </table>
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
