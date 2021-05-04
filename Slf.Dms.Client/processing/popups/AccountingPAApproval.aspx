<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AccountingPAApproval.aspx.vb" Inherits="processing_popups_AccountingPAApproval" %>
<%@ Register Src="~/processing/webparts/SettlementPACalculations.ascx" TagName="SettlementPACalculations"
    TagPrefix="webPart" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <link href="../css/globalstyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
 
        function OpenDocument(path) {
            window.open(path);
            return false;
        }
    </script>
    <title>Settlement Calculations - Payment Arrangement</title>
</head>

<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="frmRejection" runat="server">
        <div style="margin:10px">
            <table style="font-size: 8pt;" cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>               
                    <td align="left">
                        <webPart:SettlementPACalculations ID="SettCalcs" runat="server" />
                        <br />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>

</html>