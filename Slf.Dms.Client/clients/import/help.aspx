<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Client Import Help</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
</head>

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" style="padding:15 15 15 15;">
                <p>
                    <b>1. Validate</b><br />
                    To validate a given excel workbook, click the browse <i>Browse</i> button. Once you have selected a file,
                    click on the <i>Validate</i> button on the right hand side of the toolbar.
                </p>
                <p>
                    <b>2. Fix</b><br />
                    If any errors are found in the formatting of the uploaded file, they will be reported to you - often
                    times accompanied by suggestions on how to fix the issues. To open the file for editing, just click the
                    <i>Edit File</i> button on the far right hand side of the toolbar, make your changes, save the file, and
                    close the window. Once you have fixed the errors, you can click <i>Validate</i> again.
                </p>
                <p>
                    <b>3. Import</b><br />
                    Once the file has been validated and all errors fixed, you can click the <i>Import</i> button (which
                    should have appeared in the upper left hand corner). After this has been completed, it should give you
                    a message of success - including the number of clients that have been uploaded.
                </p>
            </td>
        </tr>
        <tr>
            <td style="height:40px;border-top:solid 2px rgb(149,180,234);padding-left:10px;padding-right:10px;">
                <table style="height:100%;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="right">
                            <a tabindex="2" style="color:black" class="lnk" href="#" onclick="window.close();return false;">
                                Close&nbsp;
                                <img style="margin-right:6px;" runat="server" src="~/images/16x16_forward.png" border="0" align="absmiddle" alt="" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>