<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main3.aspx.vb" Inherits="Clients_Enrollment_Main3" %>

<%@ Register src="../../CallControls/CallControlBar.ascx" tagname="CallControlBar" tagprefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Client Intake Department</title>
    <link rel="stylesheet" href="../../css/slide.css" type="text/css" media="screen" />
      <link href="../../css/default.css" rel="stylesheet" type="text/css" />
      <script language="javascript" type="text/javascript">
      
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

        function AfterPickup(CallIdKey, RemoteAddress) {
           if (!RemoteAddress || RemoteAddress.length < 10) return; 
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndLoadPickup(CallIdKey, RemoteAddress);
            } else {
                f.src = 'newenrollment2.aspx?callidkey=' + CallIdKey + '&ani=' + RemoteAddress;
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
                f.contentWindow.SaveAndRedirect('newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId + '&atid=' + AppointmentId);
            } else {
            f.src = 'newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId + '&atid=' + AppointmentId;
            }
        }
        
        function CIDDialAfterCallMade(LeadId, CallMadeId) {
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment2.aspx') > 0) {
                f.contentWindow.SaveAndRedirect('newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId);
            } else {
            f.src = 'newenrollment2.aspx?id=' + LeadId + '&cmid=' + CallMadeId; 
            }
        }

        function GotoURL(url) {
            var f = document.getElementById('iframe1');
            f.src = url;
        }
        
    </script>
    
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
     <div class="callbar"  >
          <uc1:CallControlBar ID="CallControlBar1" runat="server" />
     </div>
    </form>
    <iframe id="iframe1" runat="server" src="default.aspx" style="width: 100%; height: 87%;
        margin: 0" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto">
    </iframe>
</body>
</html>
