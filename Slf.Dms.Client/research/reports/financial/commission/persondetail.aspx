<%@ Page Language="VB" AutoEventWireup="false" CodeFile="persondetail.aspx.vb" Inherits="research_reports_financial_commission_persondetail" Title="DMP - Commission" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Debt Mediation Portal</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
</head>

<style type="text/css">
thead th{
	position:relative; 
	top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
	font-weight:normal;
}
</style>
<body scroll="no">
<form runat="server">
    <asp:placeholder ID="pnlBodyPerson" runat="server">
    <table id="tbPerson" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" cellpadding="0" cellspacing="0" visible="false" runat="server">
        <tr>
            <td valign="top" style="width:100%;height:100%;background-color:#fcfcfc">
                <div style="overflow:auto">
                    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top" style="height:100%;width:100%">
                                <div style="width:100%;height:100%;overflow:auto">
                                    <table class="fixedlist" onselectstart="return false;" cellspacing="0" cellpadding="0" width="100%" border="0" >
                                        <thead>
                                            <tr>
                                                <th nowrap style="width:22;height:22" align="left"><img id="Img1" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                                <th nowrap align="left">Fee</th>
                                                <th nowrap align="left">Percent</th>
                                                <th nowrap align="right">Amount&nbsp;&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:repeater id="rpPerson" runat="server">
                                                <itemtemplate>
<tr style="<%#IIf(Container.ItemIndex Mod 2 = 0, "", "background-color:#f1f1f1;")%>">
    <td style="width:22;height:22" align="middle">
        <img id="Img2" runat="server" src="~/images/16x16_cheque.png" border="0"/>
    </td>
    <td align="left">
        <%#CType(Container.DataItem, CommissionPersonEntry).EntryType%>
    </td>
    <td nowrap="true" align="left" valign="middle" >
        <%#CType(Container.DataItem, CommissionPersonEntry).Percent.ToString()%>
    </td>
    <td align="right">
        <%#CType(Container.DataItem, CommissionPersonEntry).Amount.ToString("c")%>
        &nbsp;&nbsp;
    </td>
</tr>
                                                </itemtemplate>
                                            </asp:repeater>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="right" id="tdTotal" runat="server" style="height:21;padding-right:2px;background-color:rgb(220,220,220)"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    </asp:placeholder>
</form>
</body>

</html>
