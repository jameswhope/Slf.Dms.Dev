<%@ Page Language="VB" AutoEventWireup="true" CodeFile="default.aspx.vb" Inherits="reports_scanning_default" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Scanning</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    
    <script type="text/javascript" language="javascript">
        //var intFocus;
        
        function ddlDocument_OnChange()
        {
            var hdnCurrent = document.getElementById('<%=hdnCurrent.ClientID %>');
            var ddlDocument = document.getElementById('<%=ddlDocument.ClientID %>');
            
            if (ddlDocument.value != 'SELECT')
            {
                //var conf = window.confirm('Are you sure you wish to generate a new document?');
            
                //if (conf)
                //{
                    hdnCurrent.value = ddlDocument.selectedIndex;
                    <%=Page.ClientScript.GetPostBackEventReference(lnkGenerate, Nothing) %>;
                //}
                //else
                //{
                    //ddlDocument.selectedIndex = hdnCurrent.value;
                //}
            }
            else
            {
                ddlDocument.selectedIndex = hdnCurrent.value;
            }
        }
        function RelateDocument()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRelateDocument, Nothing) %>;
        }
        function OnLoad()
        {
            var related = '<%=WasRelated %>';
            
            if (related == 'True')
            {
                opener.location.reload();
                window.close();
                //intFocus = setInterval('RegainFocus()', 500);
            }
        }
        //function RegainFocus()
        //{
            //window.focus();
            //clearInterval(intFocus);
        //}
    </script>
</head>

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>);background-position:left top;background-repeat:repeat-x;overflow:hidden;font-family:Tahoma;font-size:11px;" onload="javascript:OnLoad();">
<form runat="server" action="">
    <table style="width:100%;height:100%;font-family:Tahoma;font-size:11px;">
        <tr>
            <td colspan="2">
                <asp:DropDownList ID="ddlDocument" onchange="javascript:ddlDocument_OnChange();" Font-Names="Tahoma" Font-Size="11px" runat="server" />
            </td>
            <asp:Panel ID="pnlRegenerate" runat="server">
            <td>
                <a href="javascript:ddlDocument_OnChange();" style="display:none;">Regenerate Document</a>
            </td>
            </asp:Panel>
        </tr>
        <tr>
            <td>
                Document Path:
            </td>
            <td>
                <asp:Label ID="lblPath" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Filename:
            </td>
            <td>
                <asp:Label ID="lblFilename" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Document ID:
            </td>
            <td>
                <asp:Label ID="lblDocID" runat="server" />
            </td>
        </tr>
        <tr>
            <td style="height:40;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;" valign="top" colspan="2">
                <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left"><a style="color:black" class="lnk" href="javascript:window.close();"><img style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absMiddle"/>Cancel</a></td>
                        <asp:Panel ID="pnlPrint" runat="server">
                        <td align="center"><img style="margin-right:6px;" runat="server" src="~/images/16x16_print.png" border="0" align="absMiddle"/><a style="color:black" class="lnk" href="javascript:window.print();">Print</a></td>
                        <td align="right"><a style="color:black" class="lnk" href="#" onclick="javascript:RelateDocument();return false;">Continue<img style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absMiddle"/></a></td>
                        </asp:Panel>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkGenerate" runat="server" />
    <asp:LinkButton ID="lnkRelateDocument" runat="server" />
    <input id="hdnCurrent" type="hidden" runat="server" />
</form>
</body>
</html>