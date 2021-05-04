<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RejectionDetails.aspx.vb" Inherits="processing_popups_RejectionDetails" %>
<%@ Register Src="~/processing/webparts/SettlementCalculations.ascx" TagName="SettlementCalculations"
    TagPrefix="webPart" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Settlement Calculations</title>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript" language="javascript">
    
if (window.parent.currentModalDialog) {
    window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
}

</script>
</head>
<link href="<%= ResolveUrl("~/processing/css/globalstyle.css") %>" type="text/css" rel="stylesheet" />
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="frmRejection" runat="server">
        <table style="font-size: 8pt;" cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>               
                <td align="left">
                    <webPart:SettlementCalculations ID="SettCalcs" runat="server" />
                </td>
            </tr>
    </table>
    </form>
</body>

</html>