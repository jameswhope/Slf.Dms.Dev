<%@ Page Language="VB" AutoEventWireup="false" CodeFile="colorpicker.aspx.vb" Inherits="util_pop_colorpicker" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Color Picker</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        var c = null;
        var Factor = <%=Factor %>;

        function SetupColors()
        {
            <%=strSetupScript %>
        }
        function SelectColor()
        {
            if (event.button != 0)
            {
            
                var div = document.getElementById("dvPreview");
                var hex = c[parseInt(event.offsetX / Factor)][parseInt(event.offsetY / Factor)];
                var hsb = rgb2hsb(hex2rgb(hex));
                div.style.backgroundColor = rgb2hex(hsb2rgb(hsb));
            }
        }
        function Select()
        {
            var div = document.getElementById("dvPreview");
            if (div.style.backgroundColor != null && div.style.backgroundColor.length > 0)
            <%=actionCode%>
            window.close();
        }
    </script>
</head>
<body onload="SetupColors()" onselectstart="return false" ondragstart="return false" oncontextmenu="return false">
    <form id="form1" runat="server" >
        <table style="width:100%" >
            <tr>
                <td style="border:solid 1px gray" align="center">
                    <img 
                        galleryimg="false" 
                        src="<%=ResolveUrl(ImageSrc) %>" 
                        onmousemove="SelectColor()" 
                        onmousedown="SelectColor()"
                        style="width:<%=Width * Factor %>;height:<%=Height * Factor %>"
                    />
                </td>
                <td style="width:100%">
                    <div style="width:50;height:50;border:solid 1px gray" id="dvPreview">&nbsp;</div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                    <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><a tabindex="1" style="color:black" class="lnk" href="javascript:window.close();"><img id="Img1" style="margin-right:6px;" runat="server" src="~/images/16x16_back.png" border="0" align="absmiddle" />Cancel and Close</a></td>
                            <td align="right"><a tabindex="1" style="color:black" class="lnk" href="javascript:Select();">Select Color<img id="Img2" style="margin-left:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" /></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>