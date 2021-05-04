<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SettlementProcessing.ascx.vb"
    Inherits="CustomTools_UserControls_SettlementProcessing" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
    function PrintConfirm()
    {
        var itemCount = document.getElementById("<%=hdnChecksPrinted.ClientId %>");

        if (parseInt(itemCount.value) < 1 || DataChecked() == false) {
             var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Print&m=Please select a record to Print") %>';
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Print",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400, scrollable: false});  
                return false;               
        }
       
    }
    
    function DataChecked(){
        return ($("#<%=gvPrintChecks.ClientID %>").find("input[type='checkbox']:checked").length > 0);
    }
    
    function PreApproveConfirm()
    {
        var itemCount = document.getElementById("<%=hdnPayments.ClientId %>");
        var gridControl = document.getElementById("<%=gvAccounting.ClientID %>");
        
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        var TotalAmount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) {
                CheckedCount += 1;
                
                if (isNaN(parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""))) == false) {
                    TotalAmount += parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""));
                }
            }
        }

        if (parseInt(itemCount.value) < 1 || CheckedCount < 1) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Pre-Approve&m=Please select records to Pre-Approve") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Pre-Approve",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
        else{
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_PreApprove&t=Pre-Approve&m=Are you sure you want to pre-approve the selected payments';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Pre-Approve",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
       
    }
    
    function ApproveConfirm()
    {
        var itemCount = document.getElementById("<%=hdnPayments.ClientId %>");
        var gridControl = document.getElementById("<%=gvAccounting.ClientID %>");
        
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        var TotalAmount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) {
                CheckedCount += 1;
                
                if (isNaN(parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""))) == false) {
                    TotalAmount += parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""));
                }
            }
        }

        if (parseInt(itemCount.value) < 1 || CheckedCount < 1) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Approve&m=Please select a record to Approve") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Approve",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
        else{
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Approve&t=Approve&m=Are you sure you want to approve the selected payments%3F ............ Number of Selected Payments are ' + CheckedCount + ' ..................... Total Check Amount:$' + TotalAmount + '';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Approve",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
       
    }
    
    function HoldConfirm()
    {
        var itemCount = document.getElementById("<%=hdnPayments.ClientId %>");
        var gridControl = document.getElementById("<%=gvAccounting.ClientID %>");
        
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        var TotalAmount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) {
                CheckedCount += 1;
                
                if (isNaN(parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""))) == false) {
                    TotalAmount += parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""));
                }
            }
        }

        if (parseInt(itemCount.value) < 1 || CheckedCount < 1) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Hold&m=Please select records to Hold") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Hold",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
        else{
            window.dialogArguments = window;  //Changed by removing table tags - Cody Holt 2/4/2020
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_HoldPayment&t=Hold&m=Are%20you%20sure%20you%20want%20to%20hold%20the%20selected%20payments%20Selected%20Payments:' + CheckedCount + 'Total%20Check%20Amount:$' + TotalAmount + '';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Hold",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
       
    }
    
    function RejectConfirm()
    {
        var itemCount = document.getElementById("<%=hdnPayments.ClientId %>");
        var gridControl = document.getElementById("<%=gvAccounting.ClientID %>");
        
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        var TotalAmount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) {
                CheckedCount += 1;
                
                if (isNaN(parseFloat(gridControl.rows[i].cells[8].innerText.replace("$", "").replace(",", ""))) == false) {
                    TotalAmount += parseFloat(gridControl.rows[i].cells[8].innerText.replace("$", "").replace(",", ""));
                }
            }
        }

        if (parseInt(itemCount.value) < 1 || CheckedCount < 1) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Reject&m=Please select a record to Reject") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Reject",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
        else{
            window.dialogArguments = window; //Changed by removing table tags - Cody Holt 2/4/2020
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Reject&t=Reject&m=Are%20you%20sure%20you%20want%20to%20reject%20the%20selected%20payments%20Selected%20Payments:' + CheckedCount + 'Total%20Check%20Amount:$' + TotalAmount + '';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Reject",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
       
    }
    
    function ApproveOverridesConfirm()
    {
        var gridControl = document.getElementById("<%=gvPaymentsOverride.ClientID %>");   
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) 
                CheckedCount += 1;
        }

        if (CheckedCount == 0) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Approve&m=Please select payments to Approve") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Approve",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        } else { 
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=ApproveOverrides&t=Approve Overrides&m=Are you sure you want to approve the selected payments ......................  Number of Selected Payments: ' + CheckedCount;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Approve Overrides",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
          }
    }
    
    function RejectOverridesConfirm()
    {
        var gridControl = document.getElementById("<%=gvPaymentsOverride.ClientID %>");   
        var rowcount = gridControl.rows.length;
        var CheckedCount = 0
        
        for (i = 1; i < rowcount; i++) {
            if (gridControl.rows[i].cells[0].children[0].checked == true) 
                CheckedCount += 1;
        }

        if (CheckedCount == 0) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Reject&m=Please select payments to Reject") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Reject",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        } else {
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=RejectOverrides&t=Reject Overrides&m=Are you sure you want to reject the selected payments<br><br><table style="font-family: tahoma; font-size: 11px; background-color:red; color:white"><tr><td>Selected Payments:</td><td>' + CheckedCount + '</td></tr></table>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Reject Overrides",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
    }
    
    function ApproveOverrides()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkApproveOverrides, Nothing) %>;
    }
    
    function RejectOverrides()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkRejectOverrides, Nothing) %>;
    }
    
    function CheckProcessConfirm()
    {
        var itemCount = document.getElementById("<%=hdnConfirmSettlements.ClientId %>");
        var txtNote = document.getElementById("<%=txtConfirmNote.ClientId %>");
        var txtReference = document.getElementById("<%=txtReference.ClientId %>");

        if (parseInt(itemCount.value) < 1 || ProcessDataChecked() == false) {
            var url = '<%= ResolveUrl("~/util/pop/message.aspx?t=Confirm&m=Please select a record to Confirm") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Confirm",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 350, width: 400});
        }
        else if (txtNote.value == "" || txtReference.value == ""){
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx?f=Record_CheckProcess&t=Confirm Checks&m=Are you sure you want to proceed<br><br>There is no Reference Number Or Note associated with these Checks<br>Click Cancel to go back and enter Reference Number Or Note<br>Click On Confirm Checks to proceed with the confirmations") %>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Confirm Checks",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450}); 
        }
        else{
            Record_CheckProcess()
        }
    }
    
    function Record_PreApprove()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkPreApprovePayment, Nothing) %>;
    }  
    
    function Record_HoldPayment()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkHoldPayment, Nothing) %>;
    }  
    
    function Record_Approve()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkApprovePayment, Nothing) %>;
    }   
    
    function Record_Reject()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkRejectPayment, Nothing) %>;
    }   
    
    function Record_CheckProcess()
    {
        <%= Page.ClientScript.GetPostBackEventReference(lnkProcessChecks, Nothing) %>;
    }
    
    function ProcessDataChecked()
    {
        return ($("#<%=gvConfirmSettlement.ClientID %>").find("input[type='checkbox']:checked").length > 0)
    }

    function checkAll(chk_SelectAll) 
    {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                el.checked = chkState;
            }
        }
    }
    
    function checkConfirmAll(chk_SelectAll) 
    {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_confirmSelect') != -1) {
                el.checked = chkState;
            }
        }
    }
    
    function checkAccAll(chk_SelectAll) 
    {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_Accselect') != -1) {
                el.checked = chkState;
            }
        }
    }
    
    function checkOverrideAll(chk_SelectAll) 
    {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chkOverride') != -1) {
                el.checked = chkState;
            }
        }
    }
    
    function OpenPABox(settid){
             var url = '<%= ResolveUrl("~/util/pop/PaymentArrangementInfo.aspx?sid=") %>' + settid;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Payment Arrangement Info",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 450, width: 550});
             return false;
        }  
</script>

<div id="divSettlementProc" runat="server" visible="false" style="padding: 0px 0px 20px 0px">
    <asi:TabStrip runat="server" ID="tsSettlementProc">
    </asi:TabStrip>
    <div id="phSettlementsProcessed" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table class="entry2">
                        <tr>
                            <td style="padding-left: 5px">
                                Firm:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlClient" runat="server" CssClass="entry2">
                                </asp:DropDownList>
                            </td>
                            <td style="padding-left: 5px">
                                From:
                            </td>
                            <td>
                                <igsch:WebDateChooser ID="txtFromDate" runat="server" Width="100px" Value="" EnableAppStyling="True"
                                    StyleSetName="Nautilus">
                                    <CalendarLayout ChangeMonthToDateClicked="True">
                                    </CalendarLayout>
                                </igsch:WebDateChooser>
                            </td>
                            <td style="padding-left: 5px">
                                To:
                            </td>
                            <td>
                                <igsch:WebDateChooser ID="txtToDate" runat="server" Width="100px" Value="" EnableAppStyling="True"
                                    StyleSetName="Nautilus">
                                    <CalendarLayout ChangeMonthToDateClicked="True">
                                    </CalendarLayout>
                                </igsch:WebDateChooser>
                            </td>
                            <td style="width:80%;">
                                <asp:LinkButton ID="lnkFilter" runat="server" class="gridButton"><img src="~/images/16x16_funnel.png" runat="server" alt="filter" border="0" class="gridButtonImage" onclick="javascript:SubmitFilter()" align="absmiddle" />Apply Filter</asp:LinkButton>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="lnkExportOpen" runat="server" CssClass="lnk"><img src="~/images/icons/xls.png" runat="server" border="0" align="absmiddle" />&nbsp;Export</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvSettlementsProcessed" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvSettlementsProcessed" runat="server" AutoGenerateColumns="false"
                            AllowPaging="True" AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="50"
                            Width="100%" CssClass="entry2">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img id="imgHeader" src="~/images/16x16_icon.png" alt="" runat="server" border="0" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img id="imgItem" src="~/images/16x16_calendar.png" alt="" runat="server" border="0" />
                                        <input type="hidden" id="hdnSettTaskId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "TaskId")%>' />
                                        <input type="hidden" id="hdnSettId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementId")%>' />
                                        <input type="hidden" id="hdnSettTaskTypeId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "TaskTypeId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="SettlementDueDate" HeaderText="Sett Due" DataFormatString="{0:MMM d}" SortExpression="SettlementDueDate">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Negotiator" HeaderText="Negotiator">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="shortconame" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditorname"
                                    DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="SettlementAmount" HeaderText="Settlement" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Avail SDA" ControlStyle-CssClass="lnk" DataTextField="RegisterBalance"
                                    DataTextFormatString="{0:C}" DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/finances/register/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:TemplateField HeaderText="Stipulation">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    <HeaderTemplate>
                                        <a>C.Stip.</a>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsClientStipulation")) AndAlso DataBinder.Eval(Container.DataItem, "IsClientStipulation"), "Yes", "No")%>
                                        <asp:Literal ID="ltrStipulation" runat="server" />
                                    </ItemTemplate>
                                 </asp:TemplateField> 
                                 <asp:TemplateField HeaderText="P.A.">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    <HeaderTemplate>
                                        <a>P.A.</a>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsPaymentArrangement")) AndAlso DataBinder.Eval(Container.DataItem, "IsPaymentArrangement"), "<a href=""javascript:void()"" onclick=""OpenPABox('" & DataBinder.Eval(Container.DataItem, "SettlementId") & "');return false;"">Yes</a>", "No")%>
                                    </ItemTemplate>
                                 </asp:TemplateField> 
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnSettlementsProcessed" />
                </td>
            </tr>
        </table>
    </div>
    <div id="phPaymentsOverride" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                        cellspacing="0" border="0">
                        <tr>
                            <td style="width: 100%">
                                &nbsp;
                            </td>
                            <td style="white-space: nowrap">
                                <a id="A1" class="gridButton" href="javascript:ApproveOverridesConfirm();">
                                    <img src="images/16x16_Check.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" />Approve</a>
                                <asp:LinkButton ID="lnkApproveOverrides" runat="server" class="gridButton" />
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                <a id="A2" class="gridButton" href="javascript:RejectOverridesConfirm();">
                                    <img src="images/16x16_delete.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" />Reject</a>
                                <asp:LinkButton ID="lnkRejectOverrides" runat="server" class="gridButton" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvPaymentsOverride" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvPaymentsOverride" runat="server" AutoGenerateColumns="false"
                            AllowPaging="True" AllowSorting="True" CssClass="entry2" CellPadding="2" BorderWidth="0px"
                            PageSize="50" GridLines="None" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chkSelectOverrideAll" runat="server" onclick="checkOverrideAll(this);" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <input type="checkbox" runat="server" id="chkOverride" />
                                        <input type="hidden" id="hdnSettlementID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="SettlementDueDate" HeaderText="Sett&nbsp;Due" DataFormatString="{0:MMM d}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Account" ControlStyle-CssClass="lnk" DataTextField="accountnumber"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                 <asp:BoundField DataField="clientname" HeaderText="Client">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditorname"
                                    DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="SettlementAmount" HeaderText="Settlement" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PaymentAmount" HeaderText="Payment Amount" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Avail&nbsp;SDA" ControlStyle-CssClass="lnk" DataTextField="RegisterBalance"
                                    DataTextFormatString="{0:C}" DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/finances/register/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="diffAmount" HeaderText="Difference" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" ForeColor="Red" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Next&nbsp;Dep
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#GetNextDepositDate(Eval("ClientId"))%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Expected*
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#GetExpectedDeposits(Eval("ClientId"), Eval("SettlementDueDate"))%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:HyperLinkField HeaderText="Bounced" ControlStyle-CssClass="lnk" DataTextField="bounce"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/finances/register/?id={0}">
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                 <asp:TemplateField HeaderText="P.A.">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    <HeaderTemplate>
                                        <a>P.A.</a>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsPaymentArrangement")) AndAlso DataBinder.Eval(Container.DataItem, "IsPaymentArrangement"), "<a href=""javascript:void()"" onclick=""OpenPABox('" & DataBinder.Eval(Container.DataItem, "SettlementId") & "');return false;"">Yes</a>", "No")%>
                                    </ItemTemplate>
                                 </asp:TemplateField> 
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnPaymentsOverrideCount" />
                </td>
            </tr>
            <tr>
                <td align="right" style="padding: 3px">
                    <div style="font-size: xx-small">
                        *Expected deposits between today and the settlement due date.</div>
                </td>
            </tr>
        </table>
    </div>
    <div id="phAccounting" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td>
                    <table class="entry2">
                        <tr>
                            <td style="padding-left: 5px">
                                Delivery:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDelMethod" runat="server" CssClass="entry2">
                                    <asp:ListItem Text="-- All --" Value="All" Selected="True" />
                                    <asp:ListItem Text="Check" Value="C" />
                                    <asp:ListItem Text="Check By Phone" Value="P" />
                                    <asp:ListItem Text="EMail" Value="E" />
                                </asp:DropDownList>
                            </td>
                            <td style="padding-left: 5px">
                                Firm:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlAccCompany" runat="server" CssClass="entry2">
                                </asp:DropDownList>
                            </td>
                            <td style="padding-left: 5px">
                                Type:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlRequestType" runat="server" CssClass="entry2">
                                    <asp:ListItem Text="-- All --" Value="0" Selected="True" />
                                    <asp:ListItem Text="Settlement" Value="1" />
                                    <asp:ListItem Text="Settlement - P.A." Value="5" />
                                </asp:DropDownList>
                            </td>
                            <td style="padding-left: 5px">
                                From:
                            </td>
                            <td>
                                <igsch:WebDateChooser ID="txtDueStart" runat="server" Width="90px" Height="18px"
                                    Value="" NullDateLabel="All">
                                    <CalendarLayout ChangeMonthToDateClicked="True">
                                    </CalendarLayout>
                                </igsch:WebDateChooser>
                            </td>
                            <td style="padding-left: 5px">
                                To:
                            </td>
                            <td>
                                <igsch:WebDateChooser ID="txtDueEnd" runat="server" Width="90px" Height="18px" Value="" NullDateLabel="All">
                                    <CalendarLayout ChangeMonthToDateClicked="True">
                                    </CalendarLayout>
                                </igsch:WebDateChooser>
                            </td>
                             <td style="padding-left: 5px">
                                Show:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSDAFilter" runat="server" CssClass="entry2">
                                    <asp:ListItem Text="-- All --" Value="0" Selected="True" />
                                    <asp:ListItem Text="Only Positive SDA Balance" Value="1" />
                                    <asp:ListItem Text="Only Positive Avail. SDA" Value="2" />
                                    <asp:ListItem Text="Only Overages" Value="3" />
                                    <asp:ListItem Text="Only On Hold" Value="4" />
                                </asp:DropDownList>
                            </td>
                             <td style="padding-left: 5px">
                                Search:
                            </td>
                            <td>
                                <asp:TextBox ID="txtAccSearch" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                        cellspacing="0" border="0">
                        <tr>
                            <td style="width: 100%">
                                &nbsp;
                            </td>
                            <td style="white-space: nowrap">
                                <a id="lnkConfirmApprove" class="gridButton" href="javascript:ApproveConfirm();">
                                    <img src="images/16x16_Check.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" />Approve</a>
                                <asp:LinkButton ID="lnkApprovePayment" runat="server" class="gridButton" />
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                <a class="gridButton" href="javascript:PreApproveConfirm();">
                                    <img src="images/16x16_thumb_up.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" />Pre-Approve</a>
                                <asp:LinkButton ID="lnkPreApprovePayment" runat="server" />
                            </td>
                             <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                <a class="gridButton" href="javascript:HoldConfirm();">
                                    <img src="~/images/16x16_exclamationpoint.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" runat="server"/>Hold</a>
                                <asp:LinkButton ID="lnkHoldPayment" runat="server" />
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                <a id="lnkConfirmReject" class="gridButton" href="javascript:RejectConfirm();">
                                    <img src="images/16x16_delete.png" alt="filter" border="0" class="gridButtonImage"
                                        align="absmiddle" />Reject</a>
                                <asp:LinkButton ID="lnkRejectPayment" runat="server" class="gridButton" />
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                <asp:LinkButton ID="lnkAcctFilter" runat="server" class="gridButton"><img src="images/16x16_funnel.png" alt="filter" border="0" class="gridButtonImage" align="absmiddle" />Apply Filter</asp:LinkButton>&nbsp;
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                &nbsp;<a class="gridButton" runat="server" href="~/processing/CheckRegister/default.aspx"
                                    id="lnkFirmRegister">
                                    <img src="images/16x16_trust.png" border="0" align="absmiddle" />
                                    Firm&nbsp;Register</a>
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                &nbsp;<a class="gridButton" runat="server" href="~/processing/PrintQueue/PrintQueue.aspx?qtype=12" id="A3">
                                    <img src="~/images/16x16_print.png" border="0" align="absmiddle" runat="server"/>
                                    Sett.&nbsp;Kits&nbsp;<%= GetSettKitCount()%></a>
                            </td>
                            <td>
                                |
                            </td>
                            <td style="white-space: nowrap">
                                &nbsp;<asp:LinkButton ID="lnkExportAcc" runat="server" CssClass="gridButton"><img id="Img3" src="~/images/icons/xls.png" runat="server" border="0" align="absmiddle" />&nbsp;Export</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvAccounting" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvAccounting" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            AllowSorting="True" CssClass="entry2" CellPadding="2" BorderWidth="0px" PageSize="50"
                            GridLines="None" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chk_selectAccAll" runat="server" onclick="checkAccAll(this);" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <input type="checkbox" runat="server" id="chk_Accselect" />
                                        <input type="hidden" id="hdnMatterID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                                        <input type="hidden" id="hdnProcessingId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                                        <input type="hidden" id="hdnPayDelivery" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "DeliveryMethod")%>' />
                                        <input type="hidden" id="hdnSettlementId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementID")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="DeliveryMethod">
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lnk" runat="server" CausesValidation="false" CommandName ="Sort" CommandArgument="DeliveryMethod">
                                            <img ID="imgFolder" runat="server" src="~/images/16x16_icon.png" style="vertical-align:middle;border: 0px;"  />
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#GetDeliveryMethodIcon(Eval("DeliveryMethod"))%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DueDate" HeaderText="Sett&nbsp;Due" DataFormatString="{0:MMM d}"
                                    SortExpression="DueDate">
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" Wrap="false" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RequestType" HeaderText="Type" SortExpression="RequestType">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Firm" HeaderText="Firm" SortExpression="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Account" ControlStyle-CssClass="lnk" DataTextField="AccountNumber"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}" SortExpression="AccountNUmber">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="ClientName" HeaderText="Client" SortExpression="ClientName">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PayableTo" HeaderText="Payable To" SortExpression="PayableTo">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Last4" HeaderText="Acct #" SortExpression="Last4">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CheckAmount" HeaderText="Check&nbsp;Amt" DataFormatString="{0:c}" SortExpression="CheckAmount">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Avail&nbsp;SDA" ControlStyle-CssClass="lnk" DataTextField="AvailableSDA"
                                    DataTextFormatString="{0:C}" DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/finances/register/?id={0}" SortExpression="AvailableSDA">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="SDA Balance" ControlStyle-CssClass="lnk" DataTextField="SDABalance"
                                    DataTextFormatString="{0:C}" DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/finances/register/?id={0}" SortExpression="SDABalance">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:TemplateField SortExpression="NextDeposit">
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lnkSortNextDep" runat="server" CausesValidation="false" CommandName ="Sort" CommandArgument="NextDeposit" Text="Next Dep">
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#GetNextDepositDate(Eval("ClientId"))%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:TemplateField SortExpression="Expected">
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lnkSortExpected" runat="server" CausesValidation="false" CommandName ="Sort" CommandArgument="Expected" Text="Expected*">
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#GetExpectedDeposits(Eval("ClientId"), Eval("DueDate"))%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="P.A." SortExpression="IsPaymentArrangement">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lnkSortPA" runat="server" CausesValidation="false" CommandName ="Sort" CommandArgument="IsPaymentArrangement" Text="P.A.">
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#IIf(Not IsDBNull(DataBinder.Eval(Container.DataItem, "IsPaymentArrangement")) AndAlso DataBinder.Eval(Container.DataItem, "IsPaymentArrangement"), "<a href=""javascript:void()"" onclick=""OpenPABox('" & DataBinder.Eval(Container.DataItem, "SettlementId") & "');return false;"">Yes</a>", "No")%>
                                    </ItemTemplate>
                                 </asp:TemplateField> 
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnPayments" />
                </td>
            </tr>
            <tr>
                <td align="right" style="padding: 3px">
                    <div style="font-size: xx-small">
                        *Expected deposits between today and the settlement due date.</div>
                </td>
            </tr>
        </table>
    </div>
    <div id="phPrintChecks" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="3"
                        cellspacing="0" border="0">
                        <tr>
                            <td nowrap="nowrap">
                                Delivery Address:
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlDeliveryAddressPrint" runat="server" CssClass="entry2" AppendDataBoundItems="true">
                                    <asp:ListItem Text="--All--"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td nowrap="nowrap">
                                <asp:LinkButton ID="lnkFilterChecksToPrint" runat="server" CssClass="lnk"><img src="images/16x16_funnel.png" border="0" align="absmiddle" /> Apply Filter</asp:LinkButton>
                            </td>
                            <td nowrap="nowrap" style="width: 100%;" class="entryFormat">
                                &nbsp;
                            </td>
                            <td style="white-space: nowrap">
                                <asp:LinkButton ID="lnkPrint" CssClass="lnk" runat="server">
                                    <img id="imgPrint" runat="server" align="absmiddle" border="0" alt="" src="~/images/16x16_print.png" />
                                    Print Selected Checks</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvPrintChecks" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvPrintChecks" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                            AllowSorting="True" CssClass="entry2" CellPadding="2" BorderWidth="0px" PageSize="50"
                            GridLines="None" Width="100%">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <input type="hidden" id="hdnCheckPaymentId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                                        <input type="hidden" id="hdnCheckSettlement" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                                        <input type="hidden" id="hdnCheckClientId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                        <input type="hidden" id="hdnCheckAccountId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AccountId")%>' />
                                        <input type="checkbox" runat="server" id="chk_select" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img src="images/16x16_icon.png" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img src="images/16x16_cheque.png" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DueDate" HeaderText="Due ^" DataFormatString="{0:MMM d}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Firm" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditorname"
                                    DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="CheckAmount" HeaderText="Check&nbsp;Amt" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AvailableSDA" HeaderText="Avail&nbsp;SDA" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DeliveryAddress" HeaderText="Delivery&nbsp;Address" HtmlEncode="false"
                                    SortExpression="DeliveryAddress">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AttentionTo" HeaderText="Attention">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnChecksPrinted" />
                </td>
            </tr>
        </table>
    </div>
    <div id="phConfirmSettlements" runat="server" style="display: none">
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                    <table cellpadding="0" cellspacing="3" border="0">
                        <tr>
                            <td style="border-right: dotted 1px #666666; padding-right: 30px" valign="top">
                                <table>
                                    <tr>
                                        <td>
                                            Delivery Address:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlDeliveryAddress" runat="server" CssClass="entry2" AppendDataBoundItems="true">
                                                <asp:ListItem Text="--All--"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="lnkFilterChecks" runat="server" CssClass="lnk"><img src="images/16x16_funnel.png" border="0" align="absmiddle" /> Filter Checks</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="padding-left: 30px">
                                <table>
                                    <tr>
                                        <td>
                                            Reference #:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtReference" Width="150px" runat="server" CssClass="entry" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            Notes:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtConfirmNote" Width="250px" TextMode="MultiLine" runat="server" Rows="3"
                                                CssClass="entry2" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <a id="lnkConfirmSettlement" class="lnk" href="javascript:CheckProcessConfirm();">
                                                <img src="images/16x16_check.png" border="0" align="absmiddle" />
                                                Confirm Selected Checks</a>
                                            <asp:LinkButton ID="lnkProcessChecks" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <div id="dvConfirmSettlement" runat="server" class="grid" style="width: 100%">
                        <asp:GridView ID="gvConfirmSettlement" runat="server" AutoGenerateColumns="false"
                            AllowPaging="True" AllowSorting="True" CssClass="entry2" CellPadding="3" BorderWidth="0px"
                            PageSize="50" GridLines="None" Width="100%">
                            <AlternatingRowStyle BackColor="White" />
                            <RowStyle CssClass="row" />
                            <Columns>
                                <asp:TemplateField ItemStyle-CssClass="listItem" HeaderStyle-CssClass="headItem5"
                                    ItemStyle-Width="16px" HeaderStyle-Width="16px">
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chk_confirmAll" runat="server" onclick="checkConfirmAll(this);" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <input type="checkbox" runat="server" id="chk_confirmSelect" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <img src="images/16x16_icon.png" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <img src="images/16x16_cheque.png" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DueDate" HeaderText="Sett&nbsp;Due" DataFormatString="{0:MMM d}"
                                    SortExpression="DueDate">
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" Wrap="false" />
                                    <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RequestType" HeaderText="Request&nbsp;Type">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Firm" HeaderText="Firm">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname"
                                    DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditorname"
                                    DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:HyperLinkField>
                                <asp:BoundField DataField="Amount" HeaderText="Check&nbsp;Amt" DataFormatString="{0:c}">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DeliveryAddress" HeaderText="Delivery&nbsp;Address" HtmlEncode="false"
                                    SortExpression="DeliveryAddress">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AttentionTo" HeaderText="Attention">
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <input type="hidden" id="hdnConfirmPaymentId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                                        <input type="hidden" id="hdnConfirmSettlement" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                                        <input type="hidden" id="hdnProcessClientId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "ClientId")%>' />
                                        <input type="hidden" id="hdnProcessAccountId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AccountId")%>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                                </asp:TemplateField>
                            </Columns>
                            <PagerSettings Mode="NumericFirstLast" Visible="true" />
                            <PagerStyle CssClass="pagerstyle" />
                        </asp:GridView>
                    </div>
                    <input type="hidden" runat="server" id="hdnConfirmSettlements" />
                </td>
            </tr>
        </table>
    </div>
    <div id="phCheckByPhone" runat="server" style="display: none">
        <div style="padding-top:10px">
            <table style="font-family: tahoma; font-size: 11px; width: 100%; margin-bottom: 10px;" cellpadding="3"
                cellspacing="0" border="0">
                <tr>
                    <td nowrap="nowrap">
                        Creditor:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCBPCreditors" runat="server" CssClass="entry2" AppendDataBoundItems="true">
                            <asp:ListItem Text="--All--"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td nowrap="nowrap">
                        <asp:LinkButton ID="lnkCBPFiler" runat="server" CssClass="lnk"><img src="images/16x16_funnel.png" border="0" align="absmiddle" /> Apply Filter</asp:LinkButton>
                    </td>
                    <td nowrap="nowrap" style="width: 100%;" class="entryFormat">
                        &nbsp;
                    </td>
                    <td style="white-space: nowrap">
                    </td>
                </tr>
            </table>
            <asp:GridView ID="gvPhoneProcessing" runat="server" AutoGenerateColumns="false" AllowPaging="True"
                AllowSorting="True" CssClass="entry2" CellPadding="2" BorderWidth="0px" PageSize="50"
                GridLines="None" Width="100%" DataSourceID="dsPhoneProcessing">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <img id="Img1" src="~/images/16x16_icon.png" runat="server" alt="icon" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <img id="ImgPhoneIcon" src="~/images/16x16_phone3.png" runat="server" alt="Phone" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="DueDate" HeaderText="Due ^"
                        DataFormatString="{0:MMM d}">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:BoundField>
                    <asp:BoundField DataField="negname" HeaderText="Negotiator">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Firm" HeaderText="Firm">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:BoundField>
                    <asp:BoundField DataField="accountnumber" HeaderText="Acct #">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:BoundField>
                    <asp:HyperLinkField HeaderText="Client" ControlStyle-CssClass="lnk" DataTextField="clientname"
                        DataNavigateUrlFields="clientid" DataNavigateUrlFormatString="~/clients/client/?id={0}">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:HyperLinkField>
                    <asp:HyperLinkField HeaderText="Creditor" ControlStyle-CssClass="lnk" DataTextField="creditorname"
                        DataNavigateUrlFields="clientid,AccountID" DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:HyperLinkField>
                    <asp:BoundField DataField="Amount" HeaderText="Check&nbsp;Amount" DataFormatString="{0:c}">
                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" />
                    </asp:BoundField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <input type="hidden" id="hdnChkPhoneMatterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "MatterId")%>' />
                            <input type="hidden" id="hdnChkPhonePaymentId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                            <input type="hidden" id="hdnPhoneCheck" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "CheckNumber")%>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Panel runat="server" ID="pnlNoChecksPhone" Style="text-align: center; font-style: italic;
                        padding: 10 5 5 5;">
                        There are no pending Checks By Phone to process.</asp:Panel>
                </EmptyDataTemplate>
                <PagerSettings Mode="NumericFirstLast" Visible="true" />
                <PagerStyle CssClass="pagerstyle" />
            </asp:GridView>
        </div>
    </div>
</div>

<input type="hidden" runat="server" id="hdnChecksByPhone" />
<asp:LinkButton ID="btnReloadCheckByPhone" runat="server"></asp:LinkButton>

<asp:SqlDataSource ID="dsPhoneProcessing" ConnectionString="<%$ AppSettings:connectionstring %>"
    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetCheckByPhoneProcessing"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="userid" DefaultValue="-1" />
    </SelectParameters>
</asp:SqlDataSource>

<script language="javascript" type="text/javascript">
    var vartabIndex=<%=tabIndex %>;
    
    if(vartabIndex ==4)
        document.getElementById("<%=phPrintChecks.ClientID%>").style.display="block"  //print queue
    else if(vartabIndex ==3)
        document.getElementById("<%=phSettlementsProcessed.ClientID%>").style.display="block"  //opensettlements
    else if(vartabIndex ==5)
        document.getElementById("<%=phPaymentsOverride.ClientID%>").style.display="block"  //manager override
    else if(vartabIndex ==6)
        document.getElementById("<%=phConfirmSettlements.ClientID%>").style.display="block"  //confirmation queue
    else if(vartabIndex ==7)
        document.getElementById("<%=phAccounting.ClientID%>").style.display="block"  //Accounting queue
    else if(vartabIndex ==2)
        document.getElementById("<%=phCheckByPhone.ClientID%>").style.display="block"
            
    function popupSettlemetInfoDlg(dlgurl){
        window.dialogArguments = window;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: dlgurl,
                   title: "Settlement Information",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 650, width: 700, scrollable: true,
                   onClose: function(){
                        if ($(this).modaldialog("returnValue") == -1) {
                           var wnd = $(this).modaldialog("dialogArguments");
                           wnd.location = wnd.location.href.replace(/#/g,"");
                        } 
                   }});
    }
        
    //Settlement Info popupSettlementInfo functionality Starts
    function popupSettlementInfo(id)
    {
        var url = '<%= ResolveUrl("~/processing/popups/ManagerOverrideInfo.aspx") %>?sid='+ id;
        popupSettlemetInfoDlg(url);
    }

    function popupAccountingInfo(matterId)
    {
        var url = '<%= ResolveUrl("~/processing/popups/AccountingApproval.aspx") %>?type='+ status +'&mid='+ matterId;
        popupSettlemetInfoDlg(url);
    }
    
     function popupAccountingInfoPA(paymentid)
    {
        var url = '<%= ResolveUrl("~/processing/popups/AccountingPAApproval.aspx") %>?pmtid='+ paymentid;
        popupSettlemetInfoDlg(url);
    }
    
    function popupDeliveryMethod(paymentid, matterId, delMethod, payableTo, callbackfn)
    {
         var url = '<%= ResolveUrl("~/processing/popups/UpdateDeliveryMethod.aspx?mid=")%>'+ matterId + '&pmtid='+ paymentid +'&delMethod='+ delMethod +'&payTo='+ payableTo;
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "Change Delivery Method",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: true,
                   height: 370, width: 740, 
                   onClose: function(){
                        if ($(this).modaldialog("returnValue") == -1) {
                           var wnd = $(this).modaldialog("dialogArguments");
                           if (callbackfn){
                                callbackfn();
                           } else {
                                wnd.location = wnd.location.href.replace(/#/g,"");
                           }
                        } 
                   }});
    }
    
    function setMouseOverColor(element, bgColor)
    {
        if (typeof bgColor != "undefined")
            element.style.backgroundColor=bgColor;
        else 
            element.style.backgroundColor="#e5e5e5";
            
        element.style.cursor='hand';
    }

    function setMouseOutColor(element, bgColor)
    {
        if (typeof bgColor != "undefined")
            element.style.backgroundColor=bgColor;
        else 
            element.style.backgroundColor="#ffffff";
            
        element.style.textDecoration='none';
    }
    
    function SubmitFilter()
    {
        //SubmitFilter
        <%=Page.ClientScript.GetPostBackEventReference(lnkFilter,Nothing) %>
    }
    //Settlement Info popupSettlementInfo functionality Ends
    
    function popupPhoneInfo(Id, chk, pmtid) {
        var url = '<%= ResolveUrl("~/processing/popups/PhoneProcessing.aspx") %>?type=' + status + '&sid=' + Id + '&chk=' + chk + '&pmtid=' + pmtid;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Phone Processing",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: true,
                           height: 630, width: 670, 
                           onClose: function (){
                                if ($(this).modaldialog("returnValue") == -1) {
                                    setTimeout(function(){afterPopupPhoneInfo(Id,pmtid);},1);
                                } 
                              }
                           });  
    }
    
    function afterPopupPhoneInfo(Id, pmtid){
        var url = '<%= ResolveUrl("~/processing/popups/EmailCheckByPhone.aspx") %>?sid=' + Id + '&pmtid=' + pmtid;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Send Check By Phone Email Confirmation",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 325, width: 450, 
                           onClose: function (){
                                ReloadChecks();
                              }
                           });  
    
    }
    
    function ReloadChecks() {
        <%=Page.ClientScript.GetPostBackEventReference(btnReloadCheckByPhone,Nothing) %>;
    }
    
</script>

