<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addappointment.aspx.vb"
    Inherits="Enrollment_addappointment" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Appointment</title>
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
                                    <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
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
                            <td>
                                Date:
                            </td>
                            <td>
                                <igtxt:WebDateTimeEdit TabIndex="1" ID="AppDate" runat="server" BackColor="#FFFFFF"
                                    DataMode="Date" Font-Names="Tahoma" Font-Size="8pt" Height="20px" 
                                    Width="60px" MinValue="09/01/2010 12:00:00 AM" 
                                    MaxValue="12/31/2050 12:00:00 AM" DisplayModeFormat="MM/dd/yyyy" 
                                    AutoPostBack="True" >
                                    <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                        StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                        WidthLeft="1px" WidthRight="1px" WidthTop="1px"  />
                                </igtxt:WebDateTimeEdit>
                                <asp:Button ID="btnToday" runat="server" Text="<-Today" 
                                    style="font-family: Tahoma; font-size: 8pt;" TabIndex="2"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Time Zone:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="entry" Width="150px"
                                    AutoPostBack="true" TabIndex="3">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" >
                                Time (For Lead):
                            </td>
                            <td>
                                <igtxt:WebDateTimeEdit ID="AppLeadTime" runat="server" EditModeFormat="hh:mm tt"
                                    Font-Names="Tahoma" Font-Size="8pt" Height="21px" Width="55px" AutoPostBack="true"
                                    TabIndex="4">
                                </igtxt:WebDateTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Time (local):
                            </td>
                            <td>
                                <igtxt:WebDateTimeEdit ID="AppTime" runat="server" EditModeFormat="hh:mm tt"
                                    Height="21px" Font-Names="Tahoma" Font-Size="8pt" Width="55px" AutoPostBack="true"
                                    TabIndex="5">
                                </igtxt:WebDateTimeEdit>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 80px">
                                Phone Number:
                            </td>
                            <td style="width: 95px">
                                <igtxt:WebMaskEdit TabIndex="6" ID="txtPhone" runat="server" Font-Names="Tahoma"
                                Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####"  
                                ReadOnly="False"  DisplayMode="BlankWhenEmpty"  >
                                <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                    StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                    WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                            </igtxt:WebMaskEdit>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Status:
                            </td>
                            <td>
                                <asp:Label ID="lblStatus" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" >
                                Note:
                            </td>
                            <td>
                                <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" 
                                    style="width: 200px; height: 100px; font-family: Tahoma; font-size: 8pt;" 
                                    TabIndex="7"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Created:
                            </td>
                            <td>
                                <asp:Label ID="lblCreated" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Last Modified:
                            </td>
                            <td>
                                <asp:Label ID="lblModified" runat="server"></asp:Label>
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
                                                <img id="Img2" style="margin-right: 6px; height: 16px; width: 16px;" 
                                                runat="server" src="~/images/16x16_back.png"
                                                    border="0" align="absMiddle" />Cancel and Close</a>
                                        </td>
                                        <td id="trSave" align="right" runat="server"  >
                                            <asp:LinkButton ID="lnkSaveAppointment" runat="server" Text="Save" />
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
