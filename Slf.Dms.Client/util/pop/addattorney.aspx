<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addattorney.aspx.vb" Inherits="util_pop_addattorney" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Add Employed Attorney</title>
    <script language="javascript">
        function OnChangeAttorney()
        {
            var rdo = document.getElementById("<%=rdoExisting.ClientID %>")
   	        rdo.checked = true;
        }
    </script>
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; margin-left: 0; margin-right: 0">
    <form id="form1" runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
        </ajaxToolkit:ToolkitScriptManager>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;">
            <tr>
                <td style="padding-top: 15; padding-left: 15; height: 100%;" valign="top">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                        
                    <table border="0" cellpadding="0" cellspacing="7" style="font-family: tahoma; font-size: 11px;">
                        <tr>
                            <td style="width: 10px">
                                <asp:RadioButton ID="rdoNew" runat="server" Checked="true" GroupName="Group1" />
                            </td>
                            <td>
                                New Attorney
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 10px; height: 33px;">
                                <asp:RadioButton ID="rdoExisting" runat="server" GroupName="Group1" />
                            </td>
                            <td style="height: 33px">
                                <asp:DropDownList ID="ddlAttorney" runat="server" Style="font-family: tahoma; font-size: 11px; width: 210px" AutoPostBack="true">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 10px; height: 33px;">
                                &nbsp;
                            </td>
                            <td style="height: 33px">
                                <asp:Label ID="lblStateBarsFor" runat="server" Text="" CssClass="entry2"></asp:Label><br />
                                <asp:DropDownList ID="ddlStateBar" runat="server" Style="font-family: tahoma; font-size: 11px; width: 210px;" Visible="false">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 10px; height: 10px;">
                            </td>
                            <td style="height: 10px">
                            </td>
                        </tr>
                    </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                    padding-right: 10px" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; font-family: tahoma;
                        font-size: 11px; width: 100%;">
                        <tr>
                            <td style="padding-top: 3px">
                                <a class="lnk" href="javascript:window.close();" style="color: black" tabindex="16">
                                    <img id="Img2" runat="server" align="absMiddle" border="0" src="~/images/16x16_back.png"
                                        style="margin-right: 6px;" />Cancel</a></td>
                            <td align="right" style="padding-top: 3px">
                                <asp:LinkButton ID="lnkAdd" runat="server" CssClass="lnk">
                                    Add Attorney<img id="Img1" runat="server" align="absMiddle" border="0" src="~/images/16x16_forward.png"
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
