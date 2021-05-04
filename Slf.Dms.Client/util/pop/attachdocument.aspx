<%@ Page Language="VB" AutoEventWireup="true" CodeFile="attachdocument.aspx.vb" Inherits="util_pop_attachdocument" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Scanning</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>   
    <script type="text/javascript" language="javascript">
    
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        function OnFileClick(name)
        {
            document.getElementById('<%=hdnDocument.ClientID %>').value = name;
            <%=Page.ClientScript.GetPostBackEventReference(lnkDocSelected, Nothing) %>;
        }
        function OnLoad()
        {
            if (document.getElementById('<%=hdnDocument.ClientID %>').value.length > 0)
            {
                window.close();
            }
            
            if (document.body.offsetWidth < 594 || document.body.offsetHeight < 423)
            {
                window.resizeTo(600, 500);
            }
        }
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; overflow: auto;" onload="javascript:OnLoad();">
    <form runat="server" action="">
    <fieldset class="entry" style="white-space:nowrap;" id="fldUploadDoc" runat="server">
        <legend>Upload Document</legend>
        Type:<asp:DropDownList id="ddlDocuments" runat="server" CssClass="entry2" /><br />
        <asp:FileUpload ID="fuNewDoc" runat="server" CssClass="entry2" style="width:77%;"  Height="25" />
        <asp:Button ID="btnUpload" runat="server" CssClass="entry2" Text="Save Document" Height="25"/>
        
    </fieldset>
    <fieldset class="entry">
        <legend>Choose a Document</legend>
        <table style="width: 100%; height: 100%;">
            <tr>
                <td>
                    <table style="font-family: tahoma; font-size: 11px; width: 100%; background-color: #d0d0d0;">
                        <tr>
                            <td style="width: 20px;" align="center">
                                <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                            </td>
                            <td style="width: 11px;">
                                &nbsp;
                            </td>
                            <td align="left" style="width: 260px;">
                                Document Name
                            </td>
                            <td align="left" style="width: 60px;">
                                Received
                            </td>
                            <td align="left" style="width: 60px;">
                                Created
                            </td>
                            <td align="left">
                                Created By
                            </td>
                            <td style="width: 20px;" align="right">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="width: 100%; vertical-align: top;">
                <td colspan="2" style="width: 100%;">
                    <asp:TreeView ID="trvFiles" ExpandDepth="FullyExpand" ShowLines="false" Font-Names="Tahoma"
                        Font-Size="11px" ForeColor="#000000" Width="100%" ShowExpandCollapse="true" CollapseImageUrl="~/images/16x16_empty.png"
                        ExpandImageUrl="~/images/16x16_empty.png" NodeIndent="0" runat="server">
                        <NodeStyle Width="100%" />
                        <HoverNodeStyle BackColor="#d1d1d1" />
                    </asp:TreeView>
                </td>
            </tr>
            <tr>
                <td id="tdNoDir" style="font-weight: bold; color: #A03535;" runat="server">
                    This client does not have a directory!
                </td>
            </tr>
            <tr style="height: 100%;">
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </fieldset>
    <input id="hdnDocument" type="hidden" runat="server" />
    <asp:LinkButton ID="lnkDocSelected" runat="server" />
    </form>
</body>
</html>
