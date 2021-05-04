<%@ Page Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master" AutoEventWireup="false" CodeFile="batchpayments.aspx.vb" Inherits="research_reports_financial_commission_batchpayments" Title="DMP - Commission" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %><%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel runat="server" ID="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
<style type="text/css">
thead th{
	position:relative; 
	top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
}
</style>
<script type="text/javascript">
    function ShowMessage(Value)
    {
        var dvError = document.getElementById("<%= dvError.ClientID %>");
        var tdError = document.getElementById("<%= tdError.ClientID %>");

        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function Requery()
    {
        var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
        var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
        
        var date1 = txtTransDate1.value.substring(0, 6) + "20" + txtTransDate1.value.substr(6,2);
        var date2 = txtTransDate2.value.substring(0, 6) + "20" + txtTransDate2.value.substr(6,2);
        
        if (!IsValidDateTime(date1))
        {
            ShowMessage("You entered an invalid date in the begin range selector.")
        }
        else if (!IsValidDateTime(date2))
        {
            ShowMessage("You entered an invalid date in the end range selector.")
        }
        else
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkRequery, Nothing) %>;
        }
        
    }
   	function SetDates(ddl)
	{
	    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
	    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

	    var str = ddl.value;
	    if (str != "Custom")
	    {
	        var parts = str.split(",");
	        txtTransDate1.value=parts[0];
	        txtTransDate2.value=parts[1];
	    }
	}
	function SetCustom()
	{
	    var ddl = document.getElementById("<%=ddlQuickPickDate.ClientId %>");
        ddl.selectedIndex=8;	
	}
	function SetKeyPress()
	{
	    var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
        txtTransDate1.OnKeyPress = SetCustom;
        AddHandler(txtTransDate1, "keypress", "OnKeyPress");

	    var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");
        txtTransDate2.OnKeyPress = SetCustom;
        AddHandler(txtTransDate2, "keypress", "OnKeyPress");
	}
	function AddHandler(eventSource, eventName, handlerName, eventParent)
    {
	    // TODO: factor into the event function so multiple parents are possible
	    //if (eventParent != null)
	    //	eventSource.parent = eventParent;
	    var eventHandler = function(e) {eventSource[handlerName](e, eventParent);};
    	
	    if (eventSource.addEventListener)
	    {
		    eventSource.addEventListener(eventName, eventHandler, false);
	    }
	    else if (eventSource.attachEvent)
	    { 
		    eventSource.attachEvent("on" + eventName, eventHandler);
	    }
	    else
	    {
		    var originalHandler = eventSource["on" + eventName];
    		
		    if (originalHandler)
		    {
			    eventHandler = function(e) {originalHandler(e); eventSource[handlerName](e, eventParent);};
		    }

		    eventSource["on" + eventName] = eventHandler;
	    }
    }
</script>
<script type="text/javascript">

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
function RowClick(tr, CommBatch, CommRecID)
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
    
    //navigate to correct CommBatchId
    document.getElementById("ifrmDetail").src = "batchdetail.aspx?commissionbatchids=" + CommBatch + "&commrecid=" + CommRecID + "&company=<%= ddlCompany.SelectedValue %>";
    
    //set this as last
    tbl.lastSelTr = tr;
}
function printReport()
{
    var ifrmDetail=document.getElementById("ifrmDetail");
    if (!IsNullOrEmpty_string(ifrmDetail.src))
    {
        window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_commission_batchpayments", "win_report_servicefee_byagency", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
    }
}
function Export()
{
    var ifrmDetail=document.getElementById("ifrmDetail");
    if (!IsNullOrEmpty_string(ifrmDetail.src))
    {
        window.location="batchdetailxls.ashx";
    }
}
function IsNullOrEmpty_string(str)
{
    if (str == null)
        return true;
    else if (str.length == null)
        return true;
    else if (str == "")
        return true;
    
    return false;
}
</script>
<body scroll="no" onload="SetKeyPress();">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="top" colspan="2">
                <div runat="server" id="dvError" style="display:none;">
                    <TABLE style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
				        <TR>
					        <TD valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
					        <TD runat="server" id="tdError"></TD>
				        </TR>
			        </TABLE></div>
            </td>
        </tr>
        <tr>
            <td style="background-color:rgb(244,242,232);" colspan="2">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlQuickPickDate" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:8;">&nbsp;</td>
                                    <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:8;">:</td>
                                    <td nowrap="true" style="width:65;padding-right:5;"><cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nn"></cc1:InputMask></td>
                                    <td nowrap="true" style="width:5px;">&nbsp;</td>
                                    <td nowrap="true"><asp:DropDownList id="ddlCompany" accesskey="1" width="125" runat="server" style="font-family:Tahoma;font-size:11px" /></td>
                                    <td nowrap="true" style="width:5px;">&nbsp;</td>
                                    <td nowrap="true"><img id="Img3" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="true">
                                        <asp:LinkButton id="lnkRequery" runat="server"></asp:LinkButton>
                                        <a href="javascript:Requery()" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</a>
                                    </td>
                                    <td nowrap="true" style="width:100%;">&nbsp;</td>
                                    <td nowrap="true"><a runat="server" class="gridButton" href="javascript:Export();"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /> </a></td>
                                    <td nowrap="true"><a runat="server" class="gridButton" href="javascript:printReport()"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                    <td nowrap="true" style="width:10;">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top" style="width:400px;height:100%;border-left:solid 1px rgb(172,168,153);background-color:#fcfcfc">
                <div style="overflow:auto;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top" style="height:100%;width:100%">
                                <div style="width:100%;height:100%;overflow:auto">
                                    <table class="list" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="3" width="100%" border="0">
                                        <thead>
                                        <tr>
                                            <th nowrap style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="middle" /></th>
                                            <th nowrap align="left">Agency</th>
                                            <th nowrap align="right" >Amount&nbsp;&nbsp;</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <asp:repeater id="rpBatches" runat="server">
                                                <itemtemplate>
                                                    <a href="#" onclick="RowClick(this.childNodes(0), '<%#CType(Container.DataItem, BatchInformation).CommBatchIDs %>', <%#CType(Container.DataItem, BatchInformation).CommRecID %>);"><tr>
                                                        <td style="width:22" align="center">
                                                            <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                        </td>
                                                        <td nowrap align="left" style="width:100%;">
	                                                        <%#CType(Container.DataItem, BatchInformation).AgencyName%>
	                                                    </td>
	                                                    <td nowrap align="right" style="width:100px;">
                                                            <%#CType(Container.DataItem, BatchInformation).Amount.ToString("c")%>
                                                            &nbsp;&nbsp;
                                                        </td>
                                                    </tr></a>
                                                </itemtemplate>
                                            </asp:repeater>
                                        </tbody>
                                    </table>
                                </div>
                                <asp:panel runat="server" id="pnlNone" style="text-align:center;padding:20 5 5 5;">You have no Batches meeting the supplied criteria.</asp:panel>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle" align="right" id="tdTotal" runat="server" style="height:21;padding-right:2px;background-color:rgb(220,220,220)"></td>
                        </tr>
                    </table>
                </div>
            </td>
            <td style="border-left: solid 1 rgb(200,200,200)"><iframe width="100%" height="100%" frameborder="0" id="ifrmDetail" marginwidth="0" marginheight="0"></iframe></td>
        </tr>
    </table>
</body>
</asp:Panel></asp:Content>