<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Main2.aspx.vb" Inherits="Clients_Enrollment_Main2" %>

<%@ Register Src="../../CallControls/CallToolBar.ascx" TagName="CallToolBar" TagPrefix="ctb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SmartDebtor</title>
    <link rel="stylesheet" href="../../css/slide.css" type="text/css" media="screen" />
    <!--[if lte IE 6]>
		<script type="text/javascript" src="../../jquery/plugins/pngfix/supersleight-min.js"></script>
	<![endif]-->

    <script src="../../jquery/jquery-1.3.2.min.js" type="text/javascript"></script>

    <script src="../../jquery/plugins/slide.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
            function make_call1(phonenumber) {
                var d1 = new Date();
                make_call(phonenumber);
                var d2 = new Date();
                document.getElementById('<%=Label1.ClientID %>').innerHTML = d1 + ' ' + d2;
            }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="toppanel">
        <div id="panel">
            <div class="content clearfix">
                <div class="left">
                    <ctb:CallToolBar ID="CallToolBar1" runat="server" />
                    <a href="javascript:make_call1('323');">Make Call</a>
                    <asp:Label ID="Label1" runat="server"></asp:Label>
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
</body>
</html>
