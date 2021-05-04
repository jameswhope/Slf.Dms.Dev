<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ViciMain.aspx.vb" Inherits="ViciMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" >
        try {
            var windowname = '';
            try { windowname = window.top.parent.name.toLowerCase(); }
            catch (e1) {
                document.domain = "dmsi.local";
                windowname = window.top.parent.name.toLowerCase();
            }
        }
        catch (e) { }
    
        function SetCurrentTab(tabName) {
            document.getElementById('<%=hdnCurrentTab.ClientId() %>').value = tabName;
        }

        function LoadSideCommPage(url) {
            var pname = window.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('vicimain');

            if (idxMain != -1) {
                var td = document.getElementById('tdComms');
                td.style.display = (td.style.display != 'none' ? 'none' : '');
                var s = document.getElementById('ifmSide');
                if (url.indexOf('Session') == -1) {
                    s.src = url;
                }
            }
        }
        function InitSideComm(url) {
            var pname = window.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('vicimain');

            if (idxMain != -1) {
                var s = document.getElementById('ifmSide');
                if (url.indexOf('Session') == -1) {
                    s.src = url;
                }
            }
        }
        function HideSideComm() {
            var pname = window.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('vicimain');

            if (idxMain != -1) {
                var td = document.getElementById('tdComms');
                td.style.display = 'none';
            }
        }
        function resizeIframe() {
            var f = document.getElementById('iMainPanel');
            var s = document.getElementById('ifmSide');
            var h = document.body.clientHeight;
            f.height = h - 200; //c.offsetHeight;
            s.height = h - 200; //c.offsetHeight;
        }

        window.onresize = resizeIframe;

    </script> 
</head>
<body style="width: 100%; height: 100%; margin: 0" onload="resizeIframe()">
    <form id="form1" runat="server">
        <table class="entry" style="width: 100%; height: 100%;" >
            <tr valign="top">
               <td>
                    <iframe id="iMainPanel" runat="server" src="default.aspx" style="width: 100%;" frameborder="0" scrolling="auto"></iframe>
                </td>
                <td id="tdComms" style="width: 290px; display: none;">
                    <iframe id="ifmSide" runat="server" style="width: 100%; margin: 0;" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" />
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hdnCurrentTab" runat="server" />
    </form>
</body>
</html>
