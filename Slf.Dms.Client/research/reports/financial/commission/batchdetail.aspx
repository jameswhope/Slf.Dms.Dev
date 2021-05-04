<%@ Page Language="VB" AutoEventWireup="false" CodeFile="batchdetail.aspx.vb" Inherits="research_reports_financial_commission_batchdetail" Title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %><%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Debt Mediation Portal</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    
    <script language="javascript">
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        function RowClick(tr, ClientID)
        {

            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#f9f9f9";
            tr.style.backgroundColor = "#fBfBfB";
            
            var commrecid = '<%= Request.QueryString("commrecid") %>';
            
            document.getElementById("ifrmPerson").src = 'persondetail.aspx?commissionbatchids=<%= Request.QueryString("commissionbatchids") %>&commrecid=' + commrecid + '&currentclientidentry=' + ClientID;
            
            //set this as last
            tbl.lastSelTr = tr;
        }
    </script>
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
    <asp:placeholder ID="pnlBody" runat="server">
    <table style="width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
    <tr>
    <td>
    <table id="tbBatch" style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0" visible="true" runat="server">
        <tr>
            <td valign="top" style="width:100%;height:100%;background-color:#fcfcfc">
                <div id="dvBatch" style="overflow:auto" runat="server">
                    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top" style="height:100%;width:100%">
                                <div id="dvBatch" style="width:100%;height:100%;overflow:auto">
                                    <table class="fixedlist" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="0" width="100%" border="0" >
                                        <thead>
                                            <tr>
                                                <th nowrap style="width:22;height:22" align="left"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                                <th nowrap align="left">Client ID&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                                <th nowrap align="left">Name</th>
                                                <th nowrap align="right">Amount&nbsp;&nbsp;&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:repeater id="rpBatch" runat="server">
                                                <itemtemplate>
                                                    <a href="#" onclick="RowClick(this.childNodes(0), <%#CType(Container.DataItem, CommissionBatchEntry).ClientID %>);">
                                                    <tr>
                                                        <td style="width:22;height:22" align="middle">
                                                            <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                        </td>
                                                        <td nowrap="true" align="left" valign="middle">
                                                            <%#CType(Container.DataItem, CommissionBatchEntry).ClientID%>
                                                        </td>
                                                        <td nowrap="true" align="left" valign="middle">
                                                            <%#CType(Container.DataItem, CommissionBatchEntry).Name%>
                                                        </td>
                                                        <td align="right">
                                                            <%#CType(Container.DataItem, CommissionBatchEntry).Amount.ToString("c")%>
                                                            &nbsp;&nbsp;&nbsp;
                                                        </td>
                                                    </tr>
                                                    </a>
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
    </td>
    <td style="border-left: solid 1 rgb(200,200,200);width:325px;">
        <iframe width="100%" height="100%" frameborder="0" id="ifrmPerson" marginwidth="0" marginheight="0"></iframe>
    </td>
    </tr>
    </table>
    </asp:placeholder>
</form>
</body>
</html>