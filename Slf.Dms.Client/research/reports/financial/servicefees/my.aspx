<%@ Page EnableEventValidation="false" Language="VB" MasterPageFile="~/research/reports/financial/servicefees/servicefees.master" AutoEventWireup="false" CodeFile="my.aspx.vb" Inherits="research_reports_financial_servicefees_my" Title="DMP - Service Fees" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:panel runat="server" id="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript">
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
    function RowHover(tbl, over)
    {
        if (event.srcElement.tagName == "TD")
        {
            //remove hover from last tr
            if (tbl.getAttribute("lastTr") != null)
            {
                tbl.getAttribute("lastTr").style.backgroundColor = "#ffffff";
            }

            //if the mouse is over the table, set hover to current tr
            if (over)
            {
                var curTr = event.srcElement.parentElement;
                curTr.style.backgroundColor = "#f3f3f3";
                tbl.setAttribute("lastTr", curTr);
            }
        }
    }

    function printReport()
    {
        window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "report_servicefee_agency", "win_report_servicefee_byagency", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
    }
    function SortA(obj)
    {
        document.getElementById("<%=txtSortFieldA.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
    function SortB(obj)
    {
        document.getElementById("<%=txtSortFieldB.ClientId %>").value = obj.id.substring(obj.id.lastIndexOf("_") + 1);
        <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
    }
</script>
<script type="text/javascript" id="Date Util">
    function GetMonthName(i)
    {
        switch (i)
        {
            case 1:
                return "January";
            case 2:
                return "February";
            case 3:
                return "March";
            case 4:
                return "April";
            case 5:
                return "May";
            case 6:
                return "June";
            case 7:
                return "July";
            case 8:
                return "August";
            case 9:
                return "September";
            case 10:
                return "October";
            case 11:
                return "November";
            case 12:
                return "December";
        }
    }
    var ddlMonth=null;
    var ddlYear=null;
    var ddlDay=null;
    
    var yYear=null;
    var yMonth=null;
    var yDay=null;
    
    var minYear=null;
    var minMonth=null;
    var minDay=null;
    
    function LoadControls()
    {
        if (ddlMonth==null)
        {
            ddlMonth=document.getElementById("<%=ddlMonth.ClientId %>");
            ddlYear=document.getElementById("<%=ddlYear.ClientId %>");
            ddlDay=document.getElementById("<%=ddlDay.ClientId %>");
            
            var yesterday = new Date();
            //yesterday.setDate(yesterday.getDate() - 1);
            yYear = takeYear(yesterday);
            yMonth = yesterday.getMonth()+1;
            yDay = yesterday.getDate();
            
            minYear=2006;
            minMonth=6;
            minDay=5;
        }
    }
    function takeYear(theDate)
    {
	    x = theDate.getYear();
	    var y = x % 100;
	    y += (y < 38) ? 2000 : 1900;
	    return y;
    }
    function getDaysInMonth(month, year)
    {
        switch(parseInt(month))
        {
            case 1:
                return 31;
            case 2:
                if (isLeapYear(parseInt(year)))
                    return 29;
                else
                    return 28;
            case 3:
                return 31;
            case 4:
                return 30;
            case 5:
                return 31;
            case 6:
                return 30;
            case 7:
                return 31;
            case 8:
                return 31;
            case 9:
                return 30;
            case 10:
                return 31;
            case 11:
                return 30;
            case 12:
                return 31;
        }
    }
    function isLeapYear(yr) 
    {
        return new Date(yr, 2-1, 29).getDate() == 29;
    }
</script>
<script type="text/javascript" id="Date Event">
    function Year_Change()
    {   
        LoadControls();
        
        var month1 = 1;
        var month2 = 12;
        
        //set month1 to min month if on min year
        if (parseInt(ddlYear.value) == minYear)
            month1 = minMonth;
        
        //set month2 to current month if on current year
        if (parseInt(ddlYear.value) == yYear)
            month2 = yMonth;
       
        //add any needed months
        for (var i = month1; i <= month2; i++)
        {
            var index = i - month1;
            
            if (ddlMonth.options.length >= index + 1)
            {
                ddlMonth.options[index].innerHTML = GetMonthName(i);
                ddlMonth.options[index].value = i;
            }
            else
            {
                var n = document.createElement("option");
                n.value = i;
                ddlMonth.options.add(n);
                n.innerHTML = GetMonthName(i);
            }
        }
        
        for (var i = ddlMonth.options.length; i > month2-month1; i--)
        {
            ddlMonth.options.remove(i);
        }
         
        //trigger the month change event
        Month_Change(ddlMonth);
    }
    function Month_Change()
    {
        LoadControls();
        
        var day1 = 1;
        var day2 = getDaysInMonth(ddlMonth.value, ddlYear.value);
        
        
        //set day1 to min day if on min year and min month
        if (parseInt(ddlYear.value) == minYear && parseInt(ddlMonth.value) == minMonth)
            day1 = minDay;
        
        //set day2 to current day if on current year and month
        if (parseInt(ddlYear.value) == yYear && parseInt(ddlMonth.value) == yMonth)
            day2 = yDay;
        
        //add any needed days
        for (var i = day1; i <= day2; i++)
        {
            var index = i - day1;
            
            if (ddlDay.options.length >= index + 1)
            {
                ddlDay.options[index].innerHTML = i;
                ddlDay.options[index].value = i;
            }
            else
            {
                var n = document.createElement("option");
                n.value = i;
                ddlDay.options.add(n);
                n.innerHTML = i;
            }
        }
        
        //remove unneeded days
        for (var i = ddlDay.options.length-1; i > 0; i--)
        {
            if (parseInt(ddlDay.options[i].value) > day2)
                ddlDay.options.remove(i);
        }
    }
    function FixDates()
    {
        LoadControls();
        var day = ddlDay.value;
        var month = ddlMonth.value;
        var year = ddlYear.value;
        
        Year_Change();
        ddlMonth.selectedIndex=FindIndex(ddlMonth,month);
        Month_Change();
        ddlDay.selectedIndex=FindIndex(ddlDay, day);
        
    }
    function FindIndex(ddl, value)
    {
        for(var i=1; i<ddl.options.length;i++)
        {
            if (ddl.options[i].value==value)
            {
                return i;
            }
        }
        return 0;
    }
    
</script>
<style>
    table thead th {font-weight:normal}
    
</style>

<body scroll="no" onload="FixDates()">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="background-color:rgb(244,242,232);">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlMonth" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlDay" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true">
                                        <asp:dropdownlist id="ddlYear" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist>
                                    </td>
                                    <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td><asp:dropdownlist id="ddlCommRecId" runat="server" style="font-family:Tahoma;font-size:11px"></asp:dropdownlist></td>
                                    <td nowrap="true" style="width:5;">&nbsp;</td>
                                    <td nowrap="true"><img style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="true"><asp:LinkButton id="lnkRequery" runat="server" class="gridButton"><img runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton></td>
                                   
                                    <td nowrap="true" style="width:100%;">&nbsp;</td>
                                    <td nowrap="true"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"><img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></asp:LinkButton></td>
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
            <td valign="top" style="width:100%;height:100%;border-left:solid 1px rgb(172,168,153);">
                <div style="overflow:auto">
                    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;table-layout:fixed"  border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td valign="top" style="height:100%;width:100%">
                                <div style="width:100%;height:100%;overflow:auto">
                                    <table style="width:100%;height:100%" cellspacing="15px">
                                        <tr>
                                            <td valign="top" colspan="2">
                                                
                                                <table style="font-family:tahoma;font-size:11px;width:100%;background-color:#f5f5f5;padding: 5 5 5 5;" cellpadding="0" cellspacing="0" border="0">
                                                    <tr><td>Service Fee Payments</td></tr>
                                                </table>
                                                <table class="list" onmousemove="RowHover(this, true);" onmouseout="RowHover(this, false);" onselectstart="return false;" style="font-size:11px;font-family:tahoma" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                    <thead>
                                                        <tr>
                                                            <th nowrap style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                                            <th onclick="SortA(this)" runat="server" id="tdAccountNumber" nowrap align="left" >Acct. No.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdHireDate" nowrap align="center" >Hire Date</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdFirstName" nowrap align="left" >First Name</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdLastName" nowrap align="left" >Last Name</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdFeeCategory" nowrap align="left" >Fee Category</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdSettlementNumber" nowrap align="left" >Setl. No.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdOriginalBalance" nowrap align="right" >Orig Bal.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdBeginningBalance" nowrap align="right" >Beg Bal.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdPaymentAmount" nowrap align="right" >Pmt Amt.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdEndingBalance" nowrap align="right" >End Bal.</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdRate" nowrap align="center" >Rate</th>
                                                            <th onclick="SortA(this)" runat="server" id="tdAmount" nowrap align="right">Amount</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <asp:Repeater id="rpPayments" runat="server">
<ItemTemplate><a class="lnk" href="<%=ResolveUrl("~/clients/client/finances/bytype/payment.aspx") %>?id=<%#CType(Container.DataItem, Payment).ClientId%>&rpid=<%#CType(Container.DataItem, Payment).RegisterPaymentID%>">
<tr><td style="width:22"><img runat="server" src="~/images/16x16_cheque.png" border="0"/></td>
<td><%#CType(Container.DataItem, Payment).AccountNumber%></td>
<td align="center"><%#CType(Container.DataItem, Payment).HireDate.ToString("MMM d, yyyy")%></td>
<td><%#CType(Container.DataItem, Payment).FirstName%></td>
<td><%#CType(Container.DataItem, Payment).LastName%></td>
<td><%#CType(Container.DataItem, Payment).FeeCategory %></td>
<td><%#CType(Container.DataItem, Payment).SettlementNumber %>&nbsp;</td>
<td align="right"><%#CType(Container.DataItem, Payment).OriginalBalance.ToString("c")%></td>
<td align="right"><%#CType(Container.DataItem, Payment).BeginningBalance.ToString("c")%></td>
<td align="right"><%#CType(Container.DataItem, Payment).PaymentAmount.ToString("c")%></td>
<td align="right"><%#CType(Container.DataItem, Payment).EndingBalance.ToString("c")%></td>
<td align="center"><%#(CType(Container.DataItem, Payment).Rate * 100).ToString("F2")%>%</td>
<td align="right"><%#CType(Container.DataItem, Payment).Amount.ToString("c")%></td>
</tr></a></ItemTemplate>
                                                        </asp:Repeater>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>                                                           
                                                            <td runat="server" id="tdPaymentsTotal" colspan="6" style="padding-left:5px">Total</td>
                                                            <td runat="server" id="tdPaymentsAmountSum" align="right" colspan="7" style="padding-right:5px" >Sum</td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </td>
                                        </tr>
                                        <asp:placeholder id="pnlCharges" runat="server">
                                        <tr>
                                            <td valign="top" colspan="2">
                                                <table style="font-family:tahoma;font-size:11px;width:100%;background-color:#f5f5f5;padding: 5 5 5 5;" cellpadding="0" cellspacing="0" border="0">
                                                    <tr><td>Service Fee New Charges/Overview</td></tr>
                                                </table>
                                                <table class="list" onmousemove="RowHover(this, true);" onmouseout="RowHover(this, false);" onselectstart="return false;" style="font-size:11px;font-family:tahoma" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                    <thead>
                                                        <tr>
                                                            <th nowrap style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></th>
                                                            <th onclick="SortB(this)" runat="server" id="tdAccountNumber2" nowrap align="left">Acct. No.</th>
                                                            <th onclick="SortB(this)" runat="server" id="tdHireDate2" nowrap align="center" >Hire Date</th>
                                                            <th onclick="SortB(this)" runat="server" id="tdFirstName2" nowrap align="left" >First Name</th>
                                                            <th onclick="SortB(this)" runat="server" id="tdLastName2" nowrap align="left" >Last Name</th>
                                                            <th onclick="SortB(this)" runat="server" id="tdFeeCategory2" nowrap align="left" >Fee Category</th>
                                                            <th onclick="SortB(this)" runat="server" id="tdAmount2" nowrap align="right" >Amount</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <asp:Repeater id="rpCharges" runat="server">
<ItemTemplate><a class="lnk" href="<%=ResolveUrl("~/clients/client/finances/bytype/register.aspx") %>?id=<%#CType(Container.DataItem, Payment).ClientId%>&rid=<%#CType(Container.DataItem, Payment).RegisterID%>">
<tr><td style="width:22;cursor:default;"><img runat="server" src="~/images/16x16_cheque.png" border="0"/></td>
<td><%#CType(Container.DataItem, Payment).AccountNumber%></td>
<td align="center"><%#CType(Container.DataItem, Payment).HireDate.ToString("MMM d, yyyy")%></td>
<td><%#CType(Container.DataItem, Payment).FirstName%></td>
<td><%#CType(Container.DataItem, Payment).LastName%></td>
<td><%#CType(Container.DataItem, Payment).FeeCategory %></td>
<td align="right"><%#CType(Container.DataItem, Payment).Amount.ToString("c")%></td>
</tr></a></ItemTemplate>
                                                        </asp:Repeater>
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>                                                           
                                                            <td runat="server" id="tdChargesTotal" colspan="6" style="padding-left:5px" >Total</td>
                                                            <td runat="server" id="tdChargesAmountSum" align="right" colspan="7" style="padding-right:5px" >Sum</td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </td>
                                        </tr>
                                        </asp:placeholder>
                                        <asp:placeholder id="pnlTotals" runat="server">
                                        <tr>
                                            <td></td>
                                            <td style="height:100%;width:50%" valign="top" align="right">
                                                <hr  style="width:80%"/>
                                                <table style="font-family:tahoma;font-size:11px;width:100%;font-weight:bold" cellpadding="3" cellspacing="0" border="0">
                                                    <tr><td align="right">Service Fee Previous Balance:</td><td id="tdTotalPreviousBalance" runat="server" align="right"></td></tr>
                                                    <tr><td align="right">Service Fee New Charges:</td><td id="tdTotalNewCharges" runat="server" align="right"></td></tr>
                                                    <tr><td align="right">Service Fee Payments:</td><td id="tdTotalPayments" runat="server" align="right"></td></tr>
                                                    <tr><td align="right">Service Fee Ending Balance:</td><td id="tdTotalEndingBalance" runat="server" align="right"></td></tr>
                                                </table>
                                                
                                            </td>
                                        </tr>
                                        </asp:placeholder>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</body>

<asp:LinkButton ID="lnkResort" runat="server"></asp:LinkButton>
<asp:TextBox ID="txtSortFieldA" runat="server"></asp:TextBox>
<asp:TextBox ID="txtSortFieldB" runat="server"></asp:TextBox>

</asp:panel>

</asp:Content>
