﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="side_noteholder.aspx.vb" Inherits="side_noteholder" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Note</title>
    
    <script type="text/javascript">
        function ShowScanning(url) {
            try {
                var val = window.opener.ShowScanning(url);
            }
            catch (e) {
                var val = window.parent.opener.ShowScanning(url);
            }            
        }
        function IsClosing()
	    {
		    if (document.all)
		    {
			    var tempX = event.clientX + document.body.scrollLeft;
			    var tempY = event.clientY + document.body.scrollTop;
    			
			    //If mouse is over the close "X", it will return very very large negative numbers
			    if (tempX < 0 && tempY < 0)
			    {
				    return true;
			    }
		    }
		    else
		    {
			    //Detects Back/Forward Buttons and link clicking
			    ThisPage = document.location.href;
			    if (ThePage != ThisPage)
			    {
				    //looking at different location
			    }
			    else
			    {
				    return true;
			    }
		    }
		    return false;
	    }
	    function CheckForClose()
	    {
	        if (IsClosing())
	        {
	            try{
                    self.top.opener.SetCommWindowOpen(false);
                    self.top.opener.RestorePosition();
                }catch(e){}
	        }
	    }
    </script>
</head>
<body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0; border:none" onunload="CheckForClose();" >
    <form id="form1" runat="server">
        <iframe style="width:100%;height:100%;border:none" border="0" frameborder="0" scrolling="auto" src="side_note.aspx?<%=QueryString %>"></iframe>
    </form>
</body>
</html>