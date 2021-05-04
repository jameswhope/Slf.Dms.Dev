<%@ Page Language="VB" AutoEventWireup="false" CodeFile="queryresultsholder.aspx.vb" Inherits="queryresultsholder" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Query Results</title>
</head>
<body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0; border:none">
    <form id="form1" runat="server">
        <iframe style="width:100%;height:100%;border:none" border="0" frameborder="0" scrolling="no" src="queryresults.aspx?<%=QueryString %>"></iframe>
    </form>
</body>
</html>