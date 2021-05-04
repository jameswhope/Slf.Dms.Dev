﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main.aspx.vb" Inherits="Clients_Enrollment_Main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SmartDebtor</title>
    <link rel="stylesheet" href="../../css/slide.css" type="text/css" media="screen" />
    <!--[if lte IE 6]>
		<script type="text/javascript" src="../../jquery/plugins/pngfix/supersleight-min.js"></script>
	<![endif]-->

    <script src="../../jquery/jquery-1.3.2.min.js" type="text/javascript"></script>

    <script src="../../jquery/plugins/slide.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        function make_call1(phonenumber) {
            $("#open").click();
            make_call(phonenumber);
        }
        
        function CallToolBarEvents() {
            var cw = document.getElementById('iframe1').contentWindow;
            var page = cw.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('newenrollment.aspx') > 0) {
                cw.SaveAndNoEndPage();
            }
        }

        function AfterPickup(CallIdKey,RemoteAddress) {
            var f = document.getElementById('iframe1');
            var page = f.contentWindow.location.href.toString();
            page = page.toLowerCase();
            if (page.indexOf('enrollment/default.aspx') > 0) {
                f.src = 'newenrollment.aspx?callidkey=' + CallIdKey + '&ani=' + RemoteAddress; 
            }
            else if (page.indexOf('newenrollment.aspx') > 0) {
                f.contentWindow.SaveAndLoadPickup(CallIdKey,RemoteAddress);
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <div id="toppanel">
        <div id="panel">
            <div class="content clearfix">
                <div class="left">
                    
                </div>
            </div>
        </div>
        <div class="tab">
            <ul class="login">
                <li class="left">&nbsp;</li>
                <li id="toggle"><a id="open" class="open" href="#" style="white-space: nowrap">Open
                    Controls</a> <a id="close" style="display: none;" class="close" href="#">Close Controls</a>
                </li>
                <li class="right">&nbsp;</li>
            </ul>
        </div>
    </div>
    </form>
    <iframe id="iframe1" runat="server" src="default.aspx" style="width: 100%; height: 100%;
        margin: 0" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto">
    </iframe>
</body>
</html>
