<%@ Page Language="VB" AutoEventWireup="false" CodeFile="queryresults.aspx.vb" Inherits="queryresults" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Query Results</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript">
    function print()
    {
        window.top.print();
    }
    function RowOpen(url)
    {
        self.top.opener.location.href=url;
        self.top.opener.focus();
    }
    
    function MyWindow(){return self.top;}
    function MainWindow(){return self.top.opener.window;}
       
    function ResizeWindows()
    {
        var TargetWidth = 300;
        var ScreenWidth = MainWindow().screen.availWidth;
        var ScreenHeight = MainWindow().screen.availHeight;
        
        MyWindow().moveTo(ScreenWidth - TargetWidth, 0);
        MyWindow().resizeTo(TargetWidth, ScreenHeight);
                
        MainWindow().Width = MainWindow().document.body.offsetWidth+6;
        
        if (MainWindow().document.body.offsetWidth > MainWindow().screen.availWidth - TargetWidth)
        {
            MainWindow().resizeTo(ScreenWidth - TargetWidth, MainWindow().Height);
        }
        
        if (MainWindow().screenLeft + MainWindow().Width > MyWindow().screenLeft)
        {
            MainWindow().moveBy(-(MainWindow().screenLeft + MainWindow().Width - MyWindow().screenLeft), 0);
        }
    }
    </script>
    <style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
    </style>
</head>

    <body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;" >
        <form id="form1" runat="server">        
            <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="background-color:rgb(244,242,232);">
                        <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                                <td style="width:100%;">
                                    <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td nowrap="true">
                                                <asp:LinkButton class="gridButton" id="lnkRequery" runat="server"><img id="Img6" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                            </td>
                                            <td nowrap="true" style="width:100%;height:25">&nbsp;</td>
                                            <td nowrap="true"><img id="Img7" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                            <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
                                            <td nowrap="true"><a runat="server" class="gridButton" href="javascript:print()"><img id="Img9" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                            <td nowrap="true" style="width:10;">&nbsp;</td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="width:100%;height:100%" >
                        <div style="width:100%;height:100%;overflow:auto;padding: 0 0 0 0">
                            <table class="list" onmouseover="Grid_RowHover(this,true)" onmouseout="Grid_RowHover(this,false)" 
                                style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0">
                                <thead>
                                    <tr>
									    <asp:literal runat="server" id="ltrHeaders"></asp:literal>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:literal runat="server" id="ltrGrid"></asp:literal>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table onselectstart="return false;" style="height:25;background-color:rgb(239,236,222);background-image:url(<%= ResolveUrl("~/images/grid_bottom_back.bmp") %>);background-repeat:repeat-x;background-position:left bottom;font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tr>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkFirst" runat="server" class="gridButton"><img id="imgFirst" align="absmiddle" runat="server" src="~/images/16x16_selector_first.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkPrevious" runat="server" class="gridButton"><img id="imgPrevious" align="absmiddle" runat="server" src="~/images/16x16_selector_prev.png" border="0"/></asp:LinkButton></td>
                                <td><img id="Img2" style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td nowrap="true">Page&nbsp;&nbsp;<asp:TextBox AutoPostBack="true" CssClass="entry2" style="width:40;text-align:center;" runat="server" id="txtPageNumber"></asp:TextBox>&nbsp;&nbsp;of&nbsp;<asp:Label ID="lblPageCount" runat="server"></asp:Label></td>
                                <td><img id="Img3" style="margin:0 5 0 5;" border="0" runat="server" src="~/images/grid_bottom_separator.png" /></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkNext" runat="server" class="gridButton"><img id="imgNext" align="absmiddle" runat="server" src="~/images/16x16_selector_next.png" border="0"/></asp:LinkButton></td>
                                <td style="padding:4 0 4 0;"><asp:LinkButton style="padding-top:1;" ID="lnkLast" runat="server" class="gridButton"><img id="imgLast" align="absmiddle" runat="server" src="~/images/16x16_selector_last.png" border="0"/></asp:LinkButton></td>
                                <td style="width:100%;">&nbsp;</td>
                                <td style="padding-right:7;" nowrap="true" align="right"><asp:Label runat="server" id="lblResults"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>        
    </body>


</html>












