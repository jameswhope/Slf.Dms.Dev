<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frame.aspx.vb" Inherits="reports_interface_frame" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Report Wizard</title>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/installed.js") %>"></script>
    <script type="text/javascript">

	function CheckIfClosed()
	{
		if (document.all)
		{
			var tempX = event.clientX + document.body.scrollLeft;
			var tempY = event.clientY + document.body.scrollTop;
			
			//If mouse is over the close "X", it will return very very large negative numbers
			if (tempX < 0 && tempY < 0)
			{
				ItIsClosed();
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
				ItIsClosed();
			}
		}
	}
	function Querystring(key)
	{
		var tmp = unescape(location.search.substring(1));
		var i = tmp.toUpperCase().indexOf(key.toUpperCase()+"=");

		if (i >= 0)
		{
			tmp = tmp.substring( key.length+i+1 );
			i = tmp.indexOf("&");
			return( tmp = tmp.substring( 0, (i>=0) ? i : tmp.length ));
		}

		return("");
	}
	function ItIsClosed()
	{
		if (Querystring("reload") == "true") {
		
			self.opener.location = self.opener.location.href;
			
		}
	}
    function ShowLoading(force)
    {
        var fBody = document.getElementById("fBody");
        
        if (fBody.readyState=="complete" && !force)
            ShowFrame("body");
        else
            ShowFrame("loading");      
    }
    function ShowFrame(f)
    {
        var fs = document.getElementById("fs");
        if (f=="nopdf")
            fs.rows = "42,*,0,0";
        else if (f=="loading")
            fs.rows = "42,0,*,0";
        else if (f=="body")
            fs.rows = "42,0,0,*";
    }
    function Reload(str, isPDF)
    {
        var fBody = document.getElementById("fBody");
        if (!InstallAcrobat.Installed && isPDF)
        {
			ShowFrame("nopdf");
        }
        else
        {
            ShowFrame("loading");
            fBody.onreadystatechange = ShowLoading;
            fBody.src = str;
        }
        
    }
	</script>
</head>

    <frameset rows="42,0,0,*" onunload="CheckIfClosed()" id="fs" frameborder="no" framespacing="0">
		<frame name="header" src="header.aspx" scrolling="no" noresize />
		<frame name="nopdf" src="nopdf.aspx" scrolling="no" noresize  />
		<frame name="loading" src="loading.aspx" scrolling="no" noresize  />
		<frame name="body" src="<%=ResolveUrl("~/blank.aspx") %>" scrolling="auto" noresize id="fBody"/>	
	</frameset>

</html>