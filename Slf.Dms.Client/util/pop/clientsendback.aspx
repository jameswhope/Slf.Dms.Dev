<%@ Page ValidateRequest="false" Language="VB" AutoEventWireup="false" CodeFile="clientsendback.aspx.vb" Inherits="util_pop_clientsendback" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Send Back to Agency</title>
    <!--<base target="_self" />-->
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); }; 
    </script>
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 15 15;">
                    This action will mark the client as having "Incomplete Data", sending back to the Agency.
                    Please indicate precisely the data which is missing.  This comment is required.
                </td>
            </tr>
            <tr>
                <td style="height:100%;padding-bottom:20px">
                    <asp:TextBox Rows="5" runat="server" ID="txtComment" Width="100%" Height="100%" TextMode="MultiLine" Font-Size="11px" style="font-family:Tahoma "></asp:TextBox>
                </td>
            </tr>
            
            <tr>
                <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();">
                                    <img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />
                                    Cancel and Close
                                </a>
                            </td>
                            <td align="right">
                                <asp:linkbutton runat="server" id="lnkAction" tabindex="2" style="color:black" cssclass="lnk">
                                    Send Back to Agency
                                    <img style="margin-left:6px;" src="<%=ResolveUrl("~/images/16x16_forward.png")%>" border="0" align="absmiddle" />
                                </asp:linkbutton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>