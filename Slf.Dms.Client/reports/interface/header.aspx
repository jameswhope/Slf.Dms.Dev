<%@ Page Language="VB" AutoEventWireup="false" CodeFile="header.aspx.vb" Inherits="reports_interface_header" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Reports Wizard</title>
	<style>BODY { BORDER-RIGHT: 0px; BORDER-TOP: 0px; BACKGROUND: buttonface; BORDER-LEFT: 0px; BORDER-BOTTOM: 0px ;PADDING:0 }
	</style>
	<link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>

<body style="padding:0;margin:0">
    <script type="text/javascript">
        function printbody()
        {
            top.body.print();
        }
        function switchFormat(format)
        {
            document.getElementById("<%=txtFormat.ClientId %>").value=format;
            <%=ClientScript.GetPostBackEventReference(lnkSwitchFormat,Nothing) %>;
        }
        function SaveAs()
        {
            <%=ClientScript.GetPostBackEventReference(lnkSaveAs,Nothing) %>;
        }
        
    </script>

    <form id="Form1" method="post" runat="server">

       <table cellpadding="0" cellspacing="0" style="width:100%;height:43px;font-family:tahoma;font-size:11px;background-color:rgb(174,212,240);background-image:url(<%=ResolveUrl("~/images/menubackbig.png") %>); background-repeat:repeat-x; background-position:left top;" onselectstart="return false">
            <tr>
                <td><img runat="server" width="8" height="28" src="~/images/spacer.gif"/></td>
                
                <td nowrap>
                    <a id="aPDF" runat="server" class="menuButton" href="#" onclick="switchFormat('pdf')">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/icons/pdf.png" />Acrobat PDF</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap>
                    <a id="aRTF" runat="server" class="menuButton" href="#" onclick="switchFormat('rtf')">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/icons/doc.png" />MS Word</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap>
                    <a id="aHTML" runat="server" class="menuButton" href="#" onclick="switchFormat('html')">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/icons/html.png" />HTML</a></td>
                <td class="menuSeparator">|</td>
                <td nowrap>
                    <a id="aText" runat="server" class="menuButton" href="#" onclick="switchFormat('txt')">
                        <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/icons/txt.png" />Text</a></td>

                <td style="width:100%"></td>
                <td>
                    <table style="height:28">
                        <tr>
                            <td nowrap="true">
                                <a runat="server" class="menuButton" href="#" onclick="SaveAs()">
                                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />Save As</a></td>
                            <td class="menuSeparator">|</td>
                            <td nowrap="true">
                                <a runat="server" class="menuButton" href="#" onclick="javascript:printbody();">
                                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_print.png" />Print</a></td>
                        </tr>
                    </table>
                </td>
                <td><img runat="server" width="8" height="28" src="~/images/spacer.gif"/></td>
            </tr>
        </table>
               
        <asp:LinkButton ID="lnkSwitchFormat" runat="server"></asp:LinkButton>
        <asp:LinkButton ID="lnkSaveAs" runat="server"></asp:LinkButton>
        <input type="hidden" runat="server" id="txtFormat" value="pdf" />
    </form>
    </body>
</html>
