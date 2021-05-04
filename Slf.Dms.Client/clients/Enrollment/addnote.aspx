<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addnote.aspx.vb" Inherits="Enrollment_addnote" %>

<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Notes</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
        .style1
        {
            width: 98px;
        }
        #radIn
        {
            width: 20px;
            height: 20px;
        }
        #radOut
        {
            width: 20px;
        }
    </style>
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
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
                                Contact Type:
                            </td>
                            <td style="width: 100px">
                                <asp:DropDownList TabIndex="1" ID="cboNoteTypeID" runat="server" Font-Names="Tahoma"
                                    Font-Size="11px" Width="100%">
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <table style="font-family: tahoma; font-size: 11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td colspan="2">
                                <asp:RadioButtonList Style="font-family: tahoma; font-size: 11px;" ID="radDirection"
                                    runat="server" RepeatDirection="Horizontal" TabIndex="4">
                                    <asp:ListItem Text="In-Bound" />
                                    <asp:ListItem Text="Out-Bound" Selected="True" />
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Date:
                            </td>
                            <td class="style1">
                                <igtxt:WebDateTimeEdit ID="WebDateTimeEdit1" runat="server" BorderColor="#7F9DB9"
                                    BorderStyle="Solid" BorderWidth="1px" CellSpacing="1" UseBrowserDefaults="False"
                                    Width="83px" Font-Names="tahoma" Font-Size="11px">
                                    <ButtonsAppearance CustomButtonDefaultTriangleImages="Arrow">
                                        <ButtonStyle BackColor="#C5D5FC" BorderColor="#ABC1F4" BorderStyle="Solid" BorderWidth="1px"
                                            ForeColor="#506080" Width="13px">
                                        </ButtonStyle>
                                        <ButtonHoverStyle BackColor="#DCEDFD">
                                        </ButtonHoverStyle>
                                        <ButtonPressedStyle BackColor="#83A6F4">
                                        </ButtonPressedStyle>
                                        <ButtonDisabledStyle BackColor="#E1E1DD" BorderColor="#D7D7D7" ForeColor="#BEBEBE">
                                        </ButtonDisabledStyle>
                                    </ButtonsAppearance>
                                    <SpinButtons DefaultTriangleImages="ArrowSmall" Width="15px" />
                                </igtxt:WebDateTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px" valign="top">
                                Note:
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    BorderStyle="None" ControlToValidate="txtNote" Display="Dynamic" 
                                    ErrorMessage="A note is required!" />
                            </td>
                            <td class="style1">
                                <asp:TextBox ID="txtNote" TextMode="MultiLine" runat="server" BorderStyle="Solid" Font-Names="Tahoma"
                                    Font-Size="11px" Height="200px" HorizontalAlign="Justify" Width="275px">
                                </asp:TextBox>
                                
                            </td>
                        </tr>
                    </table>
                    <br />
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
                                <asp:LinkButton runat="server" ID="lnkSave">Add Note
                            
                                </asp:LinkButton>
                                <img id="Img3" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <%--    <asp:Literal runat="server" ID="ltrJScript"></asp:Literal>
    <asp:Panel runat="server" ID="pnlMessage" Font-Names="Tahoma" Font-Size="11px" Width="100%" style="padding-top:35;display:none;"><center>Saving creditor...</center></asp:Panel>
    <asp:Panel runat="server" ID="pnlMain" style="width:100%;height:100%;">
        <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div runat="server" id="dvError" style="display:none;">
                        <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					        <tr>
						        <td valign="top" width="20"><img runat="server" src="~/images/message.png" align="absMiddle" border="0"></td>
						        <td runat="server" id="tdError"></td>
					        </tr>
				        </table>
				    </div>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top:15;height:100%;">
                     <table style="font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td style="width: 80px">Contact Type:</td>
                            <td style="width: 100px"><asp:DropDownList TabIndex="7" ID="cboNoteTypeID" runat="server" Font-Names="Tahoma" Font-Size="11px" Width="100%"></asp:DropDownList></td>
                        </tr>
                    </table>
                    <table style="font-family:tahoma;font-size:11px;" border="0" cellpadding="0" cellspacing="7">
                        <tr>
                            <td>
                                <asp:RadioButton runat="server" Text="In-Bound" ID="radIn" />
                             <td>
                                <asp:RadioButton runat="server" Text="Out-Bound" ID="radOut" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">Date:</td>
                            <td class="style1">
                                <igtxt:WebDateTimeEdit ID="WebDateTimeEdit1" runat="server" BorderColor="#7F9DB9"
                                    BorderStyle="Solid" BorderWidth="1px" CellSpacing="1" UseBrowserDefaults="False"
                                    Width="83px">
                                    <ButtonsAppearance CustomButtonDefaultTriangleImages="Arrow">
                                        <ButtonStyle BackColor="#C5D5FC" BorderColor="#ABC1F4" BorderStyle="Solid" BorderWidth="1px"
                                            ForeColor="#506080" Width="13px">
                                        </ButtonStyle>
                                        <ButtonHoverStyle BackColor="#DCEDFD">
                                        </ButtonHoverStyle>
                                        <ButtonPressedStyle BackColor="#83A6F4">
                                        </ButtonPressedStyle>
                                        <ButtonDisabledStyle BackColor="#E1E1DD" BorderColor="#D7D7D7" ForeColor="#BEBEBE">
                                        </ButtonDisabledStyle>
                                    </ButtonsAppearance>
                                    <SpinButtons DefaultTriangleImages="ArrowSmall" Width="15px" />
                                </igtxt:WebDateTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px"> Note:</td>
                            <td class="style1">
                                <igtxt:WebTextEdit ID="txtNote" runat="server" BorderStyle="Solid" 
                                    Font-Names="Tahoma" Font-Size="11pt" Height="200px" HorizontalAlign="Justify" 
                                    Width="275px"></igtxt:WebTextEdit>
                            </td>
                        </tr>
                    </table>
                    <br />
                    
                </td>
            </tr>
            <tr>
                <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a TabIndex="16" style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel and Close</a></td>
                            <td align="right">
                            <asp:LinkButton runat="server" ID="lnkSave">Add Note
                            
                            </asp:LinkButton>
                                            <img id="Img1" runat="server" src="~/images/16x16_forward.png" border="0" 
                                    align="absMiddle"/>            
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
    --%>
    </form>
</body>
</html>
