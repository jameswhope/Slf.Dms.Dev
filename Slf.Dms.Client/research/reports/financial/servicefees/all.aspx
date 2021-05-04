<%@ Page Language="VB" MasterPageFile="~/research/queries/financial/servicefees/servicefees.master" AutoEventWireup="false" CodeFile="all.aspx.vb" Inherits="research_reports_financial_servicefees_all" title="DMP - Service Fees" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/installed.js") %>"></script>
<script type="text/javascript">

    function Body_OnLoad()
    {
        var ifrmNoPDF = document.getElementById("ifrmNoPDF");
        var ifrmReport = document.getElementById("ifrmReport");
        var ifrmLoading = document.getElementById("ifrmLoading");

        if (InstallAcrobat.Installed)
        {
            ifrmNoPDF.style.display = "none";
            ifrmLoading.style.display = "inline";

            ifrmReport.style.display = "none";
            ifrmReport.onreadystatechange = ShowLoading;
            ifrmReport.src = "<%= ResolveUrl("~/reports/engine/container.ashx?rpt=report_servicefee_all_payments&f=pdf&d=False") %>";
        }
        else
        {
            ifrmNoPDF.style.display = "inline";
            ifrmLoading.style.display = "none";
        }

        SetKeyPress();
    }
    function ShowLoading(force)
    {
        var ifrmNoPDF = document.getElementById("ifrmNoPDF");
        var ifrmReport = document.getElementById("ifrmReport");
        var ifrmLoading = document.getElementById("ifrmLoading");

        if (ifrmNoPDF.style.display == "none")
        {
            if (ifrmReport.readyState=="complete" && !force)
            {
                ifrmReport.style.display="block";
                ifrmLoading.style.display="none";
            }
            else
            {
                ifrmReport.style.display="none";
                ifrmLoading.style.display="block";
            }
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
<body scroll="no" onload="Body_OnLoad();">
<table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
            <div style="overflow:auto">
                <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
              
                    <tr>
                        <td style="background-color:rgb(244,242,232);">
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
                                                <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                                <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton></td>
                                               
                                                <td nowrap="true" style="width:100%;">&nbsp;</td>
                                                <td nowrap="true" style="width:10;">&nbsp;</td>
                                            </tr>
                                            <script type="text/javascript">SetKeyPress();</script>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="height:100%;width:100%">
                            <iframe id="ifrmNoPDF" frameborder="0" src="<%=ResolveUrl("~/reports/interface/nopdf.aspx") %>" scrolling="no" style="display:none;width:100%;height:100%"></iframe>
                            <iframe id="ifrmLoading" frameborder="0" src="<%=ResolveUrl("~/reports/interface/loading.aspx") %>" scrolling="no" style="width:100%;height:100%"></iframe>
                            <iframe id="ifrmReport" frameborder="0" src="<%=ResolveUrl("~/blank.aspx") %>" scrolling="auto" style="display:none;width:100%;height:100%"></iframe> 
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>
</body>

<asp:LinkButton runat="server" id="lnkDelete" style="display:none;"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>