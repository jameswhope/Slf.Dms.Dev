<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ConfirmMasterCreditor.aspx.vb" Inherits="util_pop_ConfirmMasterCreditor" %>
<%@ Register TagPrefix="cc1" Namespace="AssistedSolutions.WebControls" Assembly="AssistedSolutions.WebControls.InputMask" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Confirm Master Creditor</title>
    <base target="_self" />
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }

        function Close() {
            var vReturnValue = new Object();
            vReturnValue.Status = 'CANCEL';
            if (window.parent.currentModalDialog) {
                window.parent.currentModalDialog.modaldialog("returnValue", vReturnValue);
            } else {
                window.returnValue = vReturnValue;
            }
            window.close();
        }
        function OK() {
            var vReturnValue = new Object();
            vReturnValue.Status = 'OK';
            if (window.parent.currentModalDialog) {
                window.parent.currentModalDialog.modaldialog("returnValue", vReturnValue);
            } else {
                window.returnValue = vReturnValue;
            }
            window.close();
        } 
    </script>
</head>
<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <form id="form1" runat="server">
   <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager> 
        <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="padding:15 15 5 15 15;" >
                    <asp:Label runat="server"  ID="lblMessage" Font-Names="Tahoma" Font-Size="11px" Text="Are you sure you want to save this creditor as a master creditor?" ></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="height: 40; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                    padding-right: 10px" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; font-family: tahoma;
                        font-size: 11px; width: 100%;">
                        <tr>
                            <td style="padding-top: 3px">
                                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="lnk" OnClientClick="Close();">
                                    Cancel<img id="Img3" runat="server" align="absMiddle" border="0" src="~/images/16x16_back.png"
                                        style="margin-left: 6px;" /></asp:LinkButton>
                                        
                                        </td>
                            <td align="right" style="padding-top: 3px">
                                <asp:LinkButton ID="lnkAdd" runat="server" CssClass="lnk" OnClientClick="OK();">
                                    Add Master Creditor<img id="Img1" runat="server" align="absMiddle" border="0" src="~/images/16x16_forward.png"
                                        style="margin-left: 6px;" /></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
