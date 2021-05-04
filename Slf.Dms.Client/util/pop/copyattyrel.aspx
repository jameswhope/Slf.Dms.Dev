<%@ Page Language="VB" AutoEventWireup="false" CodeFile="copyattyrel.aspx.vb" Inherits="util_pop_copyattyrel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Copy Relationships</title>
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; margin-left: 0; margin-right: 0">
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;">
            <tr>
                <td style="padding-top: 15; padding-left: 15; height: 100%;" valign="top">
                    <table border="0" cellpadding="0" cellspacing="7" style="font-family: tahoma; font-size: 11px;">
                        <tr>
                            <td colspan="2">
                                Use this screen to copy attorney relationships from one settlement attorney
                                to another. This action will only add new relationships that do not currently exist
                                for the destination settlement attorney.<br /><br />
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                Copy From:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSource" runat="server" Font-Names="tahoma" Font-Size="11px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Copy To:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDest" runat="server" Font-Names="tahoma" Font-Size="11px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:CheckBox ID="chkPrimary" runat="server" Checked="true" />Include state primary relationships
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 48; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                    padding-right: 10px" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; font-family: tahoma;
                        font-size: 11px; width: 100%;">
                        <tr>
                            <td style="padding-top: 8px">
                                <a class="lnk" href="javascript:window.close();" style="color: black" tabindex="16">
                                    <img id="Img2" runat="server" align="absMiddle" border="0" src="~/images/16x16_back.png"
                                        style="margin-right: 6px;" />Cancel</a></td>
                            <td align="right" style="padding-top: 8px">
                                <asp:LinkButton ID="lnkDone" runat="server" CssClass="lnk">
                                    Copy<img id="Img1" runat="server" align="absMiddle" border="0" src="~/images/16x16_forward.png"
                                        style="margin-left: 6px;" /></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
