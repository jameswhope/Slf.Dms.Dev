<%@ Page Language="VB" AutoEventWireup="false" CodeFile="nopdf.aspx.vb" Inherits="reports_interface_nopdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMS - Reports - Acrobat Not Installed</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <table cellpadding="10" cellspacing="0" style="width:350px;text-align:center;font-family:tahoma;font-size:11px;">
            <tr><td align="center" style="font-size:13px;font-weight:bold;">You do not have Adobe Reader installed.</td></tr>
            <tr>
                <td align="center" style="border:solid 1px #d3d3d3;background-color:#f1f1f1;">
                    You must have Adobe Reader installed in order to view all DMS reports.  You may download and 
                    install the latest version of Reader from the Adobe web site by clicking the below link.<br /><br />
                    <a target="_blank" href="http://www.adobe.com/products/acrobat/readstep2.html"><img border="0" 
                    align="absmiddle" runat="server" src="~/images/getadobereader.gif" /></a><br /><br />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>