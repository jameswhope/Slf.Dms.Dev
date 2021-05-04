<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main3.aspx.vb" Inherits="Main3" %>
<%@ Register Src="CallControls/CallControlBar.ascx" TagName="CallControlBar" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Debt Mediation Portal</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <link runat="server" href="~/css/slide.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
        function SetCurrentTab(tabName) {
            document.getElementById('<%=hdnCurrentTab.ClientId() %>').value = tabName;
        }

        function make_call1(phonenumber) {
            make_call(phonenumber);
        }

        function CallToolBarEvents() {
            var cw = document.getElementById('iframe1').contentWindow;
            var page = cw.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                cw.SaveAndNoEndPage();
            }
        }

        function SearchClient(CallIdKey, RemoteAddress, Url) {
            if (!RemoteAddress || RemoteAddress.length < 10) return;
            var clientid = openSearch(RemoteAddress);
            if ((clientid != undefined) && (clientid != '')) {
                var f = document.getElementById('iframe1');
                f.src = 'clients/client/?id=' + clientid;
            }
        }

        function AfterPickup(CallIdKey, RemoteAddress) {
            if (!RemoteAddress || RemoteAddress.length < 10) return;
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndLoadPickup(CallIdKey, RemoteAddress);
            } else {
                f.src = 'clients/enrollment/newenrollment2.aspx?callidkey=' + CallIdKey + '&ani=' + RemoteAddress;
            }
        }

        function CIDDialAfterPickup(CallMadeId) {
            if (CallMadeId < 0) return;
            make_call_ciddialer(CallMadeId);
        }

        function DialINAfterPickup(CallMadeId) {
            if (CallMadeId < 0) return;
            make_call_dialerIN(CallMadeId);
        }

        function CIDDialerAfterPickupAppointment(LeadId, CallMadeId, AppointmentId) {
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndRedirect('clients/enrollment/newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId + '&atid=' + AppointmentId);
            } else {
                f.src = 'clients/enrollment/newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId + '&atid=' + AppointmentId;
            }
        }

        function CIDDialAfterCallMade(LeadId, CallMadeId) {
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndRedirect('~/clients/enrollment/newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId);
            } else {
                f.src = 'clients/enrollment/newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId;
            }
        }

        function GotoURL(url) {
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
            var c = document.getElementById('dvcallbar');
            var dHeight = c.offsetHeight + 30;
            f.height = h - (dHeight);
            s.height = h - (dHeight);
        }

        window.onresize = resizeIframe;
    </script>
</head>
<body onload="resizeIframe()">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="dvcallbar" class="callbar" runat="server">
        <uc1:CallControlBar ID="CallControlBar1" runat="server" />
    </div>
    <table class="entry">
        <tr valign="top">
            <td>
                <iframe id="iframe1" runat="server" src="default.aspx" style="width: 100%; margin: 0;"
                    frameborder="0" scrolling="auto"></iframe>
            </td>
            <td id="tdComms" style="width: 300px; display: none;">
                <iframe id="ifmSide" runat="server" style="width: 100%; margin: 0;" frameborder="0"
                    marginheight="0" marginwidth="0" scrolling="auto" />
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnCurrentTab" runat="server" />
    </form>
</body>
</html>
