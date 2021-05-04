<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ResolveNonDeposit.aspx.vb" Inherits="util_pop_ResolveNonDeposit" %>

<%@ Register src="../../CustomTools/UserControls/NonDepositMatterResolve.ascx" tagname="NonDepositMatterResolve" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Resolve Non Deposit Matter</title>
    <base target=_self>
    <script type="text/javascript" language="javascript">
        try {
            var windowname = '';
            try { windowname = window.top.parent.name.toLowerCase(); }
            catch (e1) {
                document.domain = "dmsi.local";
                windowname = window.top.parent.name.toLowerCase();
            }
        }
        catch (e) { }
        
        function ResizeWin(OptionType) {
            var height;
            switch (OptionType) {
                case '1':
                    height = '260';
                    break;
                case '2':
                    height = '350';
                    break;
                case '3':
                    height = '300';
                    break;
                case '4':
                    height = '530';
                    break;
            }

            if (window.parent.currentModalDialog) {
                height = parseInt(height) + 200;
                window.parent.currentModalDialog.modaldialog("option", "height", height);
                window.parent.currentModalDialog.modaldialog("getDlgWindow").dialog("option", "height", height);
            } else {
                window.dialogHeight = height + 'px';
            }
        
        }
    </script> 
</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top; background-repeat: repeat-x;">
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <div style="margin-left: 30px;" >
        <uc1:NonDepositMatterResolve ID="NonDepositMatterResolve1" runat="server" />
    </div>
    </form>
</body>
</html>
