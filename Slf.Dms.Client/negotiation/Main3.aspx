﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main3.aspx.vb" Inherits="Negotiation_Main3" %>
<%@ Register src="../CallControls/CallControlBar.ascx" tagname="CallControlBar" tagprefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Negotiation</title>
      <script language="javascript" type="text/javascript">
        function make_call1(phonenumber) {
            make_call(phonenumber);
        }

        function DialINAfterPickup(CallMadeId) {
            if (CallMadeId < 0) return;
            make_call_dialerIN(CallMadeId);
        }
        
        function GotoURL(url) {
            if (!url) return;
            var f = document.getElementById('iframe1');
            f.src = url;
        }
        function LoadSideCommPage(url) {
            var pname = window.parent.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('main3');

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
            var pname = window.parent.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('main3');

            if (idxMain != -1) {
                var s = document.getElementById('ifmSide');
                if (url.indexOf('Session') == -1) {
                    s.src = url;
                }
            }
        }
        function HideSideComm() {
            var pname = window.parent.location.pathname;
            pname = pname.toLowerCase();
            var idxMain = pname.indexOf('main3');

            if (idxMain != -1) {
                var td = document.getElementById('tdComms');
                td.style.display = 'none';
            }
        }
        function resizeIframe() {
            var f = document.getElementById('iframe1');
            var s = document.getElementById('ifmSide');
            var h = document.body.clientHeight;
            //var c = document.getElementById('dvcallbar');
            f.height = h - 70; //c.offsetHeight;
            s.height = h - 70; //c.offsetHeight;
        }

        window.onresize = resizeIframe;
                
    </script>
    <link href="css/NegCallControls.css" rel="stylesheet" type="text/css" />
    <link href="../css/default.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="callbar">
        <uc1:CallControlBar ID="CallControlBar1" runat="server" />
    </div>
    <table style="height: 60px;" border="1">
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    <table class="entry">
        <tr valign="top">
            <td>
                <iframe id="iframe1" runat="server" src="default.aspx" style="width: 100%; height: 85%;
                    min-height: 700px" frameborder="0" scrolling="auto"></iframe>
            </td>
            <td id="tdComms" style="width: 300px; display: none;">
                <iframe id="ifmSide" runat="server" style="width: 100%; margin: 0; min-height: 700px"
                    frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
