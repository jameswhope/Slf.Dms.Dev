<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/processing/CheckRegister/CheckRegister.master" CodeFile="BankReconciliation.aspx.vb" Inherits="processing_CheckRegister_BankReconciliation" title="Bank Reconciliation" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<%@ MasterType TypeName="processing_CheckRegister_CheckRegister" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
<asp:Panel runat="server" ID="pnlBody">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/rgbcolor.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script> 
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">
    var startDate = null;
    var endDate = null;
    var txtFile = null;
    var ddlFirm = null;
    var lnkVoidConfirm = null;
    var recordCount = null;
    var reportCount = null;
    var exceptionAmount = null;
    var lblTotalExceptionAmt = null;
    var lblTotalCleared = null;
    var hdnseidamanProcess = null;
    var hdnPalmerProcess = null;
    var hdnBofaCount = null;

    function LoadControls() {
        startDate = document.getElementById("<%=txtStartDate.ClientID %>");
        endDate = document.getElementById("<%=txtEndDate.ClientID %>");
        txtFile = document.getElementById("<%=txtPath.ClientID %>");
        filePath = document.getElementById("<%=hdnFilePath.ClientID %>");
        recordCount = document.getElementById("<%=hdnRecordCount.ClientID %>");
        reportCount = document.getElementById("<%=hdnReportCount.ClientID %>");
        exceptionAmount = document.getElementById("<%=hdnExceptionAmount.ClientID %>");
        lblTotalExceptionAmt = document.getElementById("<%=lblTotalException.ClientID %>");
        ddlFirm = document.getElementById("<%=ddlFirm.ClientID %>");
        lblTotalCleared = document.getElementById("<%=lblTotalCleared.ClientID %>");
        hdnseidamanProcess = document.getElementById("<%=hdnSeidaman.ClientID %>");
        hdnPalmerProcess = document.getElementById("<%=hdnPalmer.ClientID %>");
        hdnBofaCount = document.getElementById("<%=hdnBofa.ClientID %>");
    }
    
    function ExcludeAmount(amountToExclude, chkAmount){
        LoadControls();
        var totalAmount = parseFloat(lblTotalExceptionAmt.innerText.replace("$","").replace(",",""));
        
        if (isNaN(totalAmount) == true){
            totalAmount = parseFloat(lblTotalExceptionAmt.innerText.replace("$","").replace(",","").replace("(","").replace(")",""));
            if (isNaN(totalAmount) == false){
                totalAmount = totalAmount * -1;
            }
        }
        
        if (chkAmount.checked){
            lblTotalExceptionAmt.innerText = FormatNumber((totalAmount - amountToExclude), true, 2);
        }
        else{
            lblTotalExceptionAmt.innerText = FormatNumber((totalAmount + amountToExclude), true, 2);
        }

    }
    
    function Validate(){
        LoadControls();
        HideMessage();
        
        if (ddlFirm.selectedIndex == 0){
            ShowMessage("Select an account for reconciliation.");
            return;
        }
        
        if (txtFile.value == null || txtFile.value == "") {
            ShowMessage("Select a valid file");
            return;
        }
        
        var strArray = txtFile.value.split(".")
        var isExist = 0;
        
        for (i = 0;i<strArray.length;i++){
            if (strArray[i] == "csv"){
                isExist = 1;
                break;
            }
        }
        
        if (isExist = 0) {
            ShowMessage("This format of file is not supported. Choose a .csv file for processing");
            return;
        }
        
        if ((ddlFirm[ddlFirm.selectedIndex].text == "The Seidaman Law Firm" && hdnseidamanProcess.value == "1") ||
            (ddlFirm[ddlFirm.selectedIndex].text == "The Palmer Firm, P.C." && hdnPalmerProcess.value == "1") ||
            (ddlFirm[ddlFirm.selectedIndex].text == "Bank Of America Accounts" && hdnBofaCount.value == "1")){
                window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Upload&t=Upload New File&m=<strong>Are you sure you want Upload a new file?</strong><br><br>There are some transactions pending from a previously uploaded file<br>Click on Upload New File to overwrite the previously uploaded file<br>Click on Cancel and click Process button to process already existing file?';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Upload New File",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false}); 
        }
        else{
            window.dialogArguments = window;
            var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Upload&t=Upload New File&m=<strong>Are you sure you want Upload a new file?</strong>';
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Upload New File",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 400, width: 450, scrollable: false}); 
        }
    }    
    
    function Record_Upload()
    {
        // postback to Process
        <%=Page.ClientScript.GetPostBackEventReference(lnkProcess, Nothing) %>;
    }
    
    function ProcessValidate(){
        LoadControls();
        HideMessage();
        
        if (ddlFirm.selectedIndex == 0){
            ShowMessage("Select an account for reconciliation.");
            return;
        }
        
        if (startDate.value == "") {
            ShowMessage("Select a Valid Start Date");
            return;
        }

        if (endDate.value == "") {
            ShowMessage("Select a Valid End Date");
            return;
        }
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkValidate, Nothing) %>;
    }
    
    function ExcelValidate(){
        LoadControls();
        HideMessage();
        
        if (ddlFirm.selectedIndex == 0){
            ShowMessage("Select an account for reconciliation.");
            return;
        }
        
        if (startDate.value == "") {
            ShowMessage("Select a Valid Start Date");
            return;
        }

        if (endDate.value == "") {
            ShowMessage("Select a Valid End Date");
            return;
        }
        
        <%=Page.ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
    }
   
    function ShowMessage(Value) {

        var dvError = document.getElementById("<%= dvError.ClientID %>");
        var tdError = document.getElementById("<%= tdError.ClientID %>");

        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage() {
        var dvError = document.getElementById("<%= dvError.ClientID %>");
        var tdError = document.getElementById("<%= tdError.ClientID %>");

        tdError.innerHTML = "";
        dvError.style.display = "none";
    }

    function setMouseOverColor(element)
    {
        element.style.backgroundColor='#f3f3f3';
        element.style.cursor='hand';
    }

    function setMouseOutColor(element)
    {
        element.style.backgroundColor="#ffffff";
        element.style.textDecoration='none';
    }
    
    function checkAll(chk_SelectAllRecord) {
            var frm = document.forms[0];
            var chkState = chk_SelectAllRecord.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_selectRecord') != -1) {
                    el.checked = chkState;
                }
            }
        }
        
        function checkAllFirm(chk_SelectAllFirm) {
            var frm = document.forms[0];
            var chkState = chk_SelectAllFirm.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_selectFirm') != -1) {
                    el.checked = chkState;
                }
            }
        }
        
        function AddToCleared()
        {
            LoadControls();

            if (parseInt(reportCount.value) > 0 && ReportDataChecked() == true) {
                window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_AddClear&t=Add To Cleared Queue&m=<strong>Are you sure you want to add these transactions to the cleared queue?</strong><br><br>If a change is made to the amount, the original amount will be voided and the new amount will be added to Client Register.<br>If the delivery fee amount is adjusted to zero, an Overnight fee of $15.00 will be charged';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Add To Cleared Queue",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false}); 
            }
            else {
                 var url = '<%= ResolveUrl("~/util/pop/message.aspx")%>?t=Add To Cleared Queue&m=<strong>Please select a transaction to add to the queue</strong>';
                 currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Add To Cleared Queue",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false}); 
            }
        }
        
        function ClearTransaction()
        {
            LoadControls();
            var totalExcepAmount = parseFloat(lblTotalExceptionAmt.innerText.replace("$","").replace(",",""));
            var totalClearAmount = parseFloat(lblTotalCleared.innerText.replace("$","").replace(",",""));
        
            if (isNaN(totalExcepAmount) == true){
                totalExcepAmount = parseFloat(lblTotalExceptionAmt.innerText.replace("$","").replace(",","").replace("(","").replace(")",""));
                if (isNaN(totalExcepAmount) == false){
                    totalExcepAmount = totalExcepAmount * -1;
                }
            }
            
            if (isNaN(totalClearAmount) == true){
                totalClearAmount = parseFloat(lblTotalCleared.innerText.replace("$","").replace(",","").replace("(","").replace(")",""));
                if (isNaN(totalClearAmount) == false){
                    totalClearAmount = totalClearAmount * -1;
                }
            }
            
            var totalAmount = (totalClearAmount - totalExcepAmount);

            if (parseInt(recordCount.value) > 0 && ClearedDataChecked() == true) {
                 window.dialogArguments = window;
                var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Clear&t=Clear Transaction&m=<strong>Are you sure you want to clear these transactions?</strong><br><br>There is a difference of <strong>$'+ totalAmount +' </strong>between<br>cleared amount and amount in the uploaded file.<br>Do you want to clear the transactions?';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Clear Transaction",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false});
            }
            else {
                var url = '<%= ResolveUrl("~/util/pop/message.aspx")%>?t=Clear Transaction&m=<strong>Please select a transaction to clear</strong>';
                currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                               title: "Clear Transaction",
                               dialogArguments: window,
                               resizable: false,
                               scrollable: false,
                               height: 400, width: 450, scrollable: false}); 
            }
        }
        
        function Record_Clear()
        {
            // postback to void
            <%= Page.ClientScript.GetPostBackEventReference(lnkClearChecks, Nothing) %>;
        }
        
        function Record_AddClear()
        {
            // postback to void
            <%= Page.ClientScript.GetPostBackEventReference(lnkAddToClear, Nothing) %>;
        }
        
        function ClearedDataChecked() {
            var frm = document.forms[0];
            
            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_selectRecord') != -1 && el.checked == true) {
                    return true;
                }
            }

            return false;
        }
        
        function ReportDataChecked() {
            var frm = document.forms[0];
            
            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_selectFirm') != -1 && el.checked == true) {
                    return true;
                }
            }

            return false;
        }
//       
//       var vartabIndex=<%=tabIndex %>;
//        if(vartabIndex ==2)
//        document.getElementById("<%=phBankReport.ClientID%>").style.display="block"  
//        else if(vartabIndex ==1)
//        document.getElementById("<%=phFirmReport.ClientID%>").style.display="block"  
//        else if(document.getElementById("<%=phClearedReport.ClientID%>") != null) {
//        document.getElementById("<%=phClearedReport.ClientID%>").style.display="block"  
//        }

</script>
    
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
        <tr style="height:5%">
            <td valign="top">
                <div runat="server" id="dvError" style="display:none;">
                    <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda;" cellspacing="10" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td valign="top" width="20"><img id="imgMessage" runat="server" src="~/images/message.png" align="middle" border="0"></td>
                            <td runat="server" id="tdError"></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr style="height:5%">
            <td style="background-color:rgb(244,242,232);">
                <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table style="background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;width:100%;background-position:left top;font-size:11px;font-family:tahoma;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="entryFormat">
                                        Firm:
                                    </td>
                                    <td >
                                        &nbsp;&nbsp;<asp:DropDownList ID="ddlFirm" Width="200" runat="server" CssClass="entryFormat">
                                                        <asp:ListItem Text="---Select---" Value="0"/>
                                                        <asp:ListItem Text="The Seidaman Law Firm" Value="1"/>
                                                        <asp:ListItem Text="The Palmer Firm, P.C." Value="2"/>
                                                        <asp:ListItem Text="Bank Of America Accounts" Value="3"/>
                                                    </asp:DropDownList>
                                    </td> 
                                    <td nowrap="nowrap"><img id="Img3" class="entryFormat" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td >
                                        File:&nbsp;&nbsp;
                                    </td>
                                    <td >
                                        <asp:FileUpload id="txtPath" CssClass="entryFormat"  runat="server" />
                                    </td>   
                                    <td nowrap="nowrap"><img id="Img7" class="entryFormat" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="nowrap"><asp:LinkButton id="lnkProcessValidate" runat="server" />
                                        <a href="javascript:Validate()" class="gridButton"><img id="Img10" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Validate</a></td>
                                    <td nowrap="nowrap" style="width:100%;" class="entryFormat">&nbsp;</td>    
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><img id="Img8" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                        <td style="width:100%;">
                            <table style="background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);width:100%;background-repeat:repeat-x;background-position:left top;font-size:11px;font-family:tahoma;color:Black" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="entryFormat">
                                        From:&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <igsch:WebDateChooser ID="txtStartDate" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                                             Value="" Width="100px" Height="19px">
                                            <EditStyle Font-Size="11px" Font-Names="tahoma" />
                                            <ExpandEffects Type="Fade" />
                                            <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                                NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                                PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                                ShowFooter="False" ShowMonthDropDown="True"
                                                ShowYearDropDown="True" ShowTitle="False">
                                                <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                                    Font-Size="8pt">
                                                </CalendarStyle>
                                                <DayHeaderStyle>
                                                    <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                                </DayHeaderStyle>
                                                <OtherMonthDayStyle ForeColor="#ACA899" />
                                                <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                                    BorderWidth="2px" ForeColor="Black" />
                                                <TitleStyle BackColor="#9EBEF5" />
                                                <TodayDayStyle BackColor="#FBE694" />
                                            </CalendarLayout>
                                        </igsch:WebDateChooser>                                                 
                                    </td>
                                    <td class="entryFormat">
                                        &nbsp;To:&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <igsch:WebDateChooser ID="txtEndDate" runat="server" NullDateLabel="No Date" NullValueRepresentation="DateTime_MinValue"
                                             Value="" Width="100px" Height="19px">
                                            <EditStyle Font-Size="11px" Font-Names="tahoma" />
                                            <ExpandEffects Type="Fade" />
                                            <CalendarLayout CellPadding="5" DayNameFormat="FirstLetter" 
                                                NextMonthImageUrl="~/ig_res/default/images/igsch_right_arrow.gif"
                                                PrevMonthImageUrl="~/ig_res/default/images/igsch_left_arrow.gif" 
                                                ShowFooter="False" ShowMonthDropDown="True"
                                                ShowYearDropDown="True" ShowTitle="False">
                                                <CalendarStyle BackColor="White" BorderColor="#7F9DB9" BorderStyle="Solid" Font-Names="Tahoma,Verdana"
                                                    Font-Size="8pt">
                                                </CalendarStyle>
                                                <DayHeaderStyle>
                                                    <BorderDetails ColorBottom="172, 168, 153" StyleBottom="Solid" WidthBottom="1px" />
                                                </DayHeaderStyle>
                                                <OtherMonthDayStyle ForeColor="#ACA899" />
                                                <SelectedDayStyle BackColor="Transparent" BorderColor="#BB5503" BorderStyle="Solid"
                                                    BorderWidth="2px" ForeColor="Black" />
                                                <TitleStyle BackColor="#9EBEF5" />
                                                <TodayDayStyle BackColor="#FBE694" />
                                            </CalendarLayout>
                                        </igsch:WebDateChooser>                                                    
                                    </td>
                                    <td nowrap="nowrap"><img id="Img2" class="entryFormat" style="margin:0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" /></td>
                                    <td nowrap="nowrap"><asp:LinkButton id="lnkValidate" runat="server" />
                                        <a href="javascript:ProcessValidate()" class="gridButton"><img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png" />Process</a></td>
                                    <td nowrap="nowrap" style="width:100%;" class="entryFormat">&nbsp;</td>
                                    <td nowrap="nowrap"><asp:LinkButton id="lnkExport" runat="server" class="gridButton"/><a href="javascript:ExcelValidate()" class="gridButton"><img id="Img5" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/icons/xls.png" /></a></td>
                                    <td nowrap="nowrap" class="entryFormat"><a id="A1" runat="server" class="gridButton" href="javascript:window.print();"><img id="Img6" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a></td>
                                    <td nowrap="nowrap" style="width:10;" class="entryFormat">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
             </td>
        </tr>  
        <tr style="height:5%">
            <td valign="top">
                <asp:Panel runat="server" ID="pnlNoProcess" Style="text-align: center; font-style: italic;
                                    padding: 10 5 5 5;">
                                    Upload a bank statement to reconcile in .csv format. 
                                    Then choose the time period to compare. You can aslso choose to 
                                    reconcile a Specific firms transactions. Then click on Process button</asp:Panel>
            </td>
        </tr>
        <tr style="height:85%">
            <td valign="top" style="width: 90%;">
                <asi:TabStrip runat="server" ID="tsReconcile">
                </asi:TabStrip>
                <div id="phClearedReport" runat="server" style="display: none">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                        <tr>
                            <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                    cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <a id="A2" style="color: black;" runat="server" class="lnk" href="#">Cleared Checks Report</a>
                                        </td>
                                        <td align="right">
                                            <a id="lnkConfirmClear" class="gridButton" href="javascript:ClearTransaction();">Clear Transactions</a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <div id="dvCleared" runat="server">
                                    <asp:GridView ID="gvCleared" runat="server" AutoGenerateColumns="False"
                                        AllowPaging="False" AllowSorting="False" CssClass="datatable" CellPadding="0" BorderWidth="0px"
                                        PageSize="25" GridLines="None" Width="100%">
                                        <AlternatingRowStyle BackColor="White" />
                                        <RowStyle CssClass="row" />                        
                                        <Columns> 
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    &nbsp;<input type="checkbox" id="chk_selectAllRecord" runat="server" onclick="checkAll(this);" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <input type="checkbox" runat="server" id="chk_selectRecord" />
                                                    <input type="hidden" id="hdnPaymentId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "PaymentProcessingId")%>' />
                                                    <input type="hidden" id="hdnFirmRegisterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FirmRegisterId")%>' />
                                                    <input type="hidden" id="hdnRegisterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "RegisterId")%>' />
                                                    <input type="hidden" id="hdnFirmId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FirmId")%>' />
                                                    <input type="hidden" id="hdnCounted" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "Counted")%>' />
                                                    <input type="hidden" id="hdnChkAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "CheckAmount")%>' />
                                                    <input type="hidden" id="hdnFeeId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FeeRegisterId")%>' />
                                                    <input type="hidden" id="hdnFeeAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FeeAmount")%>' />
                                                    <input type="hidden" id="hdnAdjustedFee" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AdjustedFeeAmount")%>' />
                                                    <input type="hidden" id="hdnSettAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmount")%>' />
                                                    <input type="hidden" id="hdnAdjustedSett" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AdjustedSettlementAmount")%>' />
                                                    <input type="hidden" id="hdnDataType" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "DataType")%>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="5%" />
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="5%" />
                                             </asp:TemplateField> 
                                            <asp:BoundField DataField="ProcessedDate" HeaderText="Check&nbsp;Issued&nbsp;Date" DataFormatString="{0:MM/dd/yyyy}">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem"   />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5"  />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RequestType" HeaderText="RequestType">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="AdjustedCheckAmount" HeaderText="Check&nbsp;Amount" DataFormatString="{0:c2}">
                                                <ItemStyle HorizontalAlign="Right" CssClass="listItem"   />
                                                <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CheckNumber" HeaderText="Check&nbsp;Number">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RecipientAccountNumber" HeaderText="Account&nbsp;Number" >
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RecipientName" HeaderText="Recipient&nbsp;Name">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="AdjustedDataType" HeaderText="DataType">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                    <asp:Panel runat="server" ID="pnlTotalCleared" Style="padding: 10 5 5 5;background-color:#f3f3f3;width:100%;">
                                        <table width="100%">
                                            <tr>
                                                <td style="font-style:italic;font-size:12px;text-align:right;width:60%;">
                                                    Total Amount Cleared:
                                                </td>
                                                <td style="font-weight:bold;font-style:italic;font-size:12px;text-align:left;width:40%;">
                                                    <asp:Label ID="lblTotalCleared" runat="server"/>
                                                    <input type="hidden" runat="server" id="hdnTotalClearedAmt" value="0"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                                <asp:Panel runat="server" ID="pnlNoRecords" Style="text-align: center; font-style: italic;
                                    padding: 10 5 5 5;">
                                    There are no records to display</asp:Panel>
                                <input type="hidden" runat="server" id="hdnRecordCount" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="phFirmReport" runat="server" style="display: none">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                        <tr>
                            <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                    cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <a id="A3" style="color: black;" runat="server" class="lnk" href="#">Outstanding Checks in Firm Register</a>
                                        </td>
                                        <td align="right">
                                            <a id="lnkConfirmAdd" class="gridButton" href="javascript:AddToCleared();">Add To Cleared Report</a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <div id="dvFirmReport" runat="server">
                                    <asp:GridView ID="gvFirmReport" runat="server" AutoGenerateColumns="False"
                                        AllowPaging="False" AllowSorting="False" CssClass="datatable" CellPadding="0" BorderWidth="0px"
                                        PageSize="25" GridLines="None" Width="100%" >
                                        <AlternatingRowStyle BackColor="White" />
                                        <RowStyle CssClass="row" />   
                                        <Columns> 
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    &nbsp;<input type="checkbox" id="chk_selectAllFirm" runat="server" onclick="checkAllFirm(this);" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <input type="checkbox" runat="server" id="chk_selectFirm" />
                                                    <input type="hidden" id="hdnReportFirmRegister" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FirmRegisterId")%>' />
                                                    <input type="hidden" id="hdnReportRegisterId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "RegisterId")%>' />
                                                    <input type="hidden" id="hdnReportFirm" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FirmId")%>' />
                                                    <input type="hidden" id="hdnItemCounted" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "Counted")%>' />
                                                    <input type="hidden" id="hdnReportAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "CheckAmount")%>' />
                                                    <input type="hidden" id="hdnReportFeeId" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FeeRegisterId")%>' />
                                                    <input type="hidden" id="hdnReportFeeAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "FeeAmount")%>' />
                                                    <input type="hidden" id="hdnReportSettAmount" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmount")%>' />
                                                    <input type="hidden" id="hdnDelivery" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "DeliveryMethod")%>' />
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="5%" />
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="5%" />
                                             </asp:TemplateField> 
                                             <asp:BoundField DataField="ProcessedDate" HeaderText="Check&nbsp;Issued&nbsp;Date" DataFormatString="{0:MM/dd/yyyy}">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem"   />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5"  />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RequestType" HeaderText="RequestType">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Check&nbsp;Amount">
                                                <ItemTemplate>                                                
                                                    Amount:&nbsp;<asp:TextBox ID="txtAmount" runat="server" TextMode="SingleLine" CssClass="entryFormat" Text='<%#DataBinder.Eval(Container.DataItem, "AdjustedSettlementAmount")%>' /><br />
                                                    Fee:&nbsp;<asp:TextBox ID="txtFeeAmount" runat="server" TextMode="SingleLine" CssClass="entryFormat" Text='<%#DataBinder.Eval(Container.DataItem, "AdjustedFeeAmount")%>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" CssClass="listItem"   />
                                                <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CheckNumber" HeaderText="Check&nbsp;Number">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RecipientAccountNumber" HeaderText="Account&nbsp;Number">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RecipientName" HeaderText="Recipient&nbsp;Name">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="DataType">
                                                <ItemTemplate>                                                
                                                    <asp:DropDownList ID="ddlDataType" runat="server" CssClass="entryFormat">
                                                        <asp:ListItem Text="DEBITS"/>
                                                        <asp:ListItem Text="CREDITS"/>
                                                    </asp:DropDownList>   
                                                    <input type="hidden" id="hdnReportDataType" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "AdjustedDataType")%>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:TemplateField>
                                        </Columns>                     
                                    </asp:GridView>
                                </div>
                                <asp:Panel runat="server" ID="pnlNoFirmReport" Style="text-align: center; font-style: italic;
                                    padding: 10 5 5 5;">
                                    There are no Exceptions found in the Firm Report</asp:Panel>
                                <input type="hidden" runat="server" id="hdnReportCount" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="phBankReport" runat="server" style="display: none">
                    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                                            cellspacing="0">
                        <tr>
                            <td style="background-color: #f5f5f5; padding: 2 5 2 5;">
                                <table style="font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0"
                                    cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <a id="A4" style="color: black;" runat="server" class="lnk" href="#">Exception Report For Bank Statement</a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <div id="dvExceptionReport" runat="server">
                                    <asp:GridView ID="gvExceptionReport" runat="server" AutoGenerateColumns="False"
                                        AllowPaging="False" AllowSorting="False" CssClass="datatable" CellPadding="0" BorderWidth="0px"
                                        PageSize="25" GridLines="None" Width="100%">
                                        <AlternatingRowStyle BackColor="White" />
                                        <RowStyle CssClass="row" />      
                                        <Columns> 
                                            <asp:TemplateField HeaderText="Reject">
                                                <ItemTemplate>
                                                    <input type="checkbox" runat="server" id="chk_RejectTransaction" />
                                                    <input type="hidden" runat="server" id="hdnBankRegisterId" value='<%#DataBinder.Eval(Container.DataItem, "BankRegisterId")%>'/>
                                                    <input type="hidden" runat="server" id="hdnBankCounted" value='<%#DataBinder.Eval(Container.DataItem, "Counted")%>'/>
                                                    <input type="hidden" runat="server" id="hdnRejected" value='<%#DataBinder.Eval(Container.DataItem, "Rejected")%>'/>
                                                    <input type="hidden" runat="server" id="hdnUploadId" value='<%#DataBinder.Eval(Container.DataItem, "BankUploadId")%>'/>
                                                </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="5%" />
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="5%" />
                                             </asp:TemplateField> 
                                             <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:c2}">
                                                <ItemStyle HorizontalAlign="Right" CssClass="listItem"   />
                                                <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CustomerRef" HeaderText="Customer&nbsp;Reference">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="BAICode" HeaderText="BAI&nbsp;Code">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Description" HeaderText="Description">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="DataType" HeaderText="DataType">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="BankAccountName" HeaderText="Bank&nbsp;Account">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="ProcessedDate" HeaderText="Processed&nbsp;On" DataFormatString="{0:MM/dd/yyyy}">
                                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                                            </asp:BoundField>
                                        </Columns>                  
                                    </asp:GridView>
                                    <asp:Panel runat="server" ID="pnlTotalAmount" Style="padding: 10 5 5 5;background-color:#f3f3f3;width:100%;">
                                        <table width="100%">
                                            <tr>
                                                <td style="font-style:italic;font-size:12px;text-align:right;width:70%;">
                                                    Total Amount in the Uploaded Sheet:
                                                </td>
                                                <td style="font-weight:bold;font-style:italic;font-size:12px;text-align:left;width:30%;">
                                                    <asp:Label ID="lblTotalException" runat="server"/>
                                                    <input type="hidden" runat="server" id="hdnExceptionAmount" value="0"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                                <asp:Panel runat="server" ID="pnlNoBankReport" Style="text-align: center; font-style: italic;
                                    padding: 10 5 5 5;">
                                    There are no Exceptions found in the Bank Statement</asp:Panel>
                                <input type="hidden" runat="server" id="hdnExceptionCount" />
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    </asp:Panel>
<asp:HiddenField ID="hdnFilePath" runat="server" />
<asp:LinkButton ID="lnkAddToClear" runat="server" />
<asp:LinkButton ID="lnkProcess" runat="server" />
<asp:LinkButton ID="lnkClearChecks" runat="server"/>
<asp:HiddenField ID="hdnSeidaman" value="0" runat="server"/>
<asp:HiddenField ID="hdnPalmer" value="0" runat="server"/>
<asp:HiddenField ID="hdnBofa" value="0" runat="server"/>
</asp:Content>


