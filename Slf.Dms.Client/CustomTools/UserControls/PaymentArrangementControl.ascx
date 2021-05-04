<%@ Control Language="VB" AutoEventWireup="false" CodeFile="PaymentArrangementControl.ascx.vb"
    Inherits="CustomTools_UserControls_PaymentArrangementControl" %>
<style type="text/css">
    .ui-datepicker-trigger { position: relative; top: 3px; margin-left: 2px;}
    .ddlPmt {
        width: 180px;
        }
    .txtPmtPct 
    {
        width: 50px;
        border-style: none !important;
        padding: 0 0 0 0 !important;
        border-width: 0px !important
        }
    .txtPmtAmt 
    {
        width: 50px;
        height: 18px;
          
    }
    .ui-spinner-input 
    {
        margin: 0 0 0 0 !important;
        }

    .pmtMeassure
    {
        width: 20px;
        text-align: center !important;
        background-color: rgb(220, 237, 242);
        border-color: #bedce6;
        border-style: solid;
        border-width: 1px;
        padding-right: 3px;
        padding-left: 3px;
        line-height: 17px !important;
        float: left;
        color: #000000;
        }
     
     .dvPmt
     {
         float: left;
         }
     .pmtResults
     {
         border-color:#a2cee4;
         border-style:solid;
         border-width:1px;
         background-color: #ffffff;
         height: 150px;
         padding: 5px 5px 5px 5px;
         }
         
    .tbPmntResults
    {
         empty-cells: show;
         margin-top: 10px;
         border-collapse:collapse;
         display: inline;
        }
     
    .tbPmntResults th 
    {
       color: #1d78a5;
        background-color: rgb(220, 237, 242);
        background-image: url("../images/widget_headbg.png");
        background-repeat: repeat-x;
        padding: 5px 5px 5px 5px;
        border-collapse: collapse;
        border-style: solid;
        border-width: 1px;
        border-color: #a2cee4;
        }
           
    .tbPmntResults td 
    {
        padding: 5px 5px 5px 5px;
        background-color: rgb(220, 237, 242);
        border-style: solid;
        border-width: 1px;
        border-color: #a2cee4;
        }  
        
     .resultDate
     {
         width: 60px;
         }     
         
     .resultValue
     {
         width: 60px;
         text-align: right;
         }  
         
     .tbContainer
     {
         width: 100%;
         border-top-style: solid;
         border-top-width: 1px;
         border-top-color: #a2cee4;
         margin-top: 10px;
         }
                 
     #tbPmntSummary {width: 100px}
     
     .sumHdr
     {
         font-weight: bold;
         white-space: nowrap;
         }
         
     .sumValue
     {
         font-weight: normal;
         white-space: nowrap;
         width: 100px;
         text-align: right;
         color: #000000;
         padding-right: 10px;
         padding-left: 10px;
         }
          
      .sumRed
      {
          color: red !important;
          }
         
     fieldset {padding: 8px 8px 8px 8px;}
     
     .dvSettInfo
     {
         width: 100px;
         }
    
</style>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/datej.js") %>"></script>
<script type="text/javascript">
    window.baseurl = "<%= ResolveUrl("~/")%>";

    function  pageLoad(){
        try {
                docuReady();
            } catch (e) { } 
        }

    function docuReady() {
        $(document).ready(function() {
            $('#<%=txtStartDate.ClientID %>').datepicker({
                    showOn: "button",
                    buttonImage: '<%= ResolveUrl("~/images/Calendar_scheduleHS.png")%>',
                    buttonImageOnly: true,
                    buttonText: "Select payments start date",
                    dateFormat: "mm/dd/yy",
                    minDate: 0,
                    onSelect: function(){
                        DrawPaymentHtml();
                    }
                }).attr('readonly', 'true').
                keypress(function(event){
                  if(event.keyCode == 8){
                    event.preventDefault();
                  }
                });
                
            $('#<%=txtPmtAmountPct.ClientID %>').spinner({
                    step: 1.00,
                    numberFormat: "n",
                    min: 0.00,
                    max: 100.00,
                    spin: function( event, ui ){CalculateAmountFromPct();}
                }).removeClass("box")
                  .keydown(function(){CalculateAmountFromPct();})
                  .keypress(function(event){integerOnly(event, $(this));}); 
             
             $('#<%=txtPmtAmount.ClientID %>').keydown(function(){CalculateAmountPct();})
                                              .keypress(function(event){decimalOnly(event, $(this));});   
             
             $('.pmtMeassure').removeClass("box");
             
             $('#<%= ddlPlanType.ClientId %>').change(function(){
                                                        selectPaymentPlan($(this));
                                                        DrawPaymentHtml();
                                                        });
             
             $('#<%= ddlInstallmentType.ClientId %>').change(function(){
                                                                selectInstallmentType($(this));
                                                                DrawPaymentHtml();
                                                                });
             $('#<%=txtInstallmentCount.ClientID %>').keydown(function(){
                                                                    setTimeout(function(){DrawPaymentHtml();},1);
                                                               })
                                                     .keypress(function(event){integerOnly(event, $(this));});                                                   
                                                     
             $('#<%=txtInstallmentAmount.ClientID %>').keydown(function(){
                                                                    setTimeout(function(){DrawPaymentHtml();},1);
                                                               })
                                                      .keypress(function(event){decimalOnly(event, $(this));});                                                   
                
                
             $('#<%=txtPaymentAmt.ClientID %>').keypress(function(event){decimalOnly(event, $(this));}); 
             
             $('#<%=txtPaymentDate.ClientID %>').datepicker({
                    showOn: "button",
                    buttonImage: '<%= ResolveUrl("~/images/Calendar_scheduleHS.png")%>',
                    buttonImageOnly: true,
                    buttonText: "Select payment date",
                    dateFormat: "mm/dd/yy",
                    minDate: 0
                }).attr('readonly', 'true').
                keypress(function(event){
                  if(event.keyCode == 8){
                    event.preventDefault();
                  }
                });
                
        });
    }
    
    function decimalOnly(event, $this){
        if ((event.which != 46 || $this.val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    }
    
    function integerOnly(event, $this){
        if (event.which != 8 && event.which != 0 && (event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    }
    
    function CalculateAmountPct(skipRefresh){
        setTimeout(function(){
            var spnVal = "0";
            var settAmt = $('#<%= hdnSettlementAmount.ClientId%>').val();
            if (settAmt && parseFloat(settAmt) != 0){
                spnVal = CurrencyFormatted(100*($('#<%=txtPmtAmount.ClientID %>').val()/ parseFloat(settAmt)));
            }
            $('#<%=txtPmtAmountPct.ClientID %>').spinner("value", parseFloat(spnVal));  
            DrawPaymentHtml(skipRefresh);   
        }, 1);       
     }
     
     function CalculateAmountFromPct(){
        setTimeout(function(){
        var spnVal = $('#<%=txtPmtAmountPct.ClientID %>').spinner("value");
            var settAmt = $('#<%= hdnSettlementAmount.ClientId%>').val();
            var iniAmt = "0.00";
            if (settAmt){
                iniAmt = CurrencyFormatted(settAmt * spnVal / 100);
            }
            $('#<%=txtPmtAmount.ClientID %>').val(iniAmt);
            DrawPaymentHtml();
            }, 1);
     }
    
    function selectPaymentPlan($this){
     switch($this.val()){
        case "1":
            $('#dvPmtOpts').hide();
            $('#dvDPmtAmnt').show();
            $('#dvPmtPct').hide();
            $('#<%= txtLSumAmount.ClientId%>').show();
            $('#<%= txtPmtAmount.ClientId%>').hide();
            $('#<%= txtLSumAmount.ClientId%>').val($('#<%= hdnSettlementAmount.ClientId%>').val());
            break;      
        case "2":
        case "3":
            $('#dvPmtOpts').show();
            $('#dvDPmtAmnt').show();
            $('#dvPmtPct').show();
            $('#<%= txtLSumAmount.ClientId%>').hide();
            var txtPmt = $('#<%= txtPmtAmount.ClientId%>');
            txtPmt.show();
            if (!txtPmt.val()){
                txtPmt.val("0.00");
                CalculateAmountPct();
            }
            selectInstallmentType($('#<%= ddlInstallmentType.ClientId %>'));
            break;
        case "4":
            $('#dvPmtOpts').show();
            $('#dvDPmtAmnt').hide();
            $('#dvPmtPct').show();
            selectInstallmentType($('#<%= ddlInstallmentType.ClientId %>'));
            break;
        default:
            $('#dvPmtOpts').hide();
            $('#dvDPmtAmnt').hide();
            $('#dvPmtPct').hide();
            break;
        }
    }
    
     function selectInstallmentType($this){
        switch($this.val()){
            case "1":
                $('#dvItmCount').show();
                $('#dvItmAmount').hide();
                var txtInstCount = $('#<%= txtInstallmentCount.ClientId %>');
                if (!txtInstCount.val()) {
                    txtInstCount.val("0");
                }
                break;      
            case "2":
                $('#dvItmCount').hide();
                $('#dvItmAmount').show();
                var txtInstAmount = $('#<%= txtInstallmentAmount.ClientId %>');
                if (!txtInstAmount.val()) {
                    txtInstAmount.val("0.00");
                }
                break;
            default:
                $('#dvItmCount').hide();
                $('#dvItmAmount').hide();
                break;
        }
    }
    
    function DrawPaymentHtml(){
        var sdate = $('#<%= txtStartDate.ClientId %>').datepicker( "getDate" ); 
        var pmts = getPaymentsCalculation();
        var dv = $('#dvPmtResults');
        var tb;

        var instCount = 0;
        var totalUsed = 0; 
        var maxTable = 2;
        var minTbRows = 3;
        var maxTbRows;
        var rowCount;
        var tbCount = 1;
        var tables = [];
        var tdate;
        
        if (pmts.length > minTbRows) {
            tbCount = maxTable;
        }
        
        maxTbRows = Math.ceil(pmts.length/tbCount);
        rowCount = 0;
        
        $.each(pmts, function(index, value){
        
            if (pmts.length > 0 && rowCount == 0) {
                tb = $('<table class="tbPmntResults">');
                $('<tr><th>#</th><th>Date</th><th>Amount</th></tr>').appendTo(tb);
            }
        
            var tr = $('<tr>');
            $('<td>').html(index + 1 + '.').appendTo(tr);
            var dtf = '&nbsp;';
            if (sdate) {
                tdate = new DateClass(new Date(sdate));
                dtf = $.datepicker.formatDate('mm/dd/yy', tdate.addMonths(index));
            }
            $('<td class="resultDate">').html(dtf).appendTo(tr);
            $('<td class="resultValue">').html('$'+CurrencyFormatted(value)).appendTo(tr);
            tb.append(tr);
            instCount++;
            totalUsed = totalUsed + parseFloat(value);
            
            rowCount++;
            if (rowCount == maxTbRows || (index + 1 == pmts.length)) {
                if (rowCount < maxTbRows) {
                    for(i=0;i< maxTbRows-rowCount;i++){
                        tb.append('<tr><td>&nbsp;</td><td class="resultDate">&nbsp;</td><td class="resultValue">&nbsp;</td></tr>');
                    }  
                }
                tables.push(tb.get(0));
                rowCount = 0;
            }
            
        });
              
        var totalAmount = $('#<%= hdnSettlementAmount.ClientId %>').val();
        var tbsumm = $('<table id="tbPmntSummary">');
        var trs = $('<tr>');
        var tds;

        $('<td class="sumHdr">').html("Settlement Amount:").appendTo(trs);
        $('<td class="sumValue">').html('$'+CurrencyFormatted(totalAmount)).appendTo(trs);
        
        $('<td class="sumHdr">').html("Amount Used:").appendTo(trs);
        tds = $('<td id="tdAmountUsed" class="sumValue">');
        tds.html('$'+CurrencyFormatted(totalUsed));
        if (totalUsed == 0){
            tds.addClass("sumRed");
        }else{
            tds.removeClass("sumRed"); 
        }
        tds.appendTo(trs);
        tbsumm.append(trs);
        
        trs = $('<tr>');
        $('<td class="sumHdr">').html("# of Payments:").appendTo(trs);
        $('<td class="sumValue">').html(instCount).appendTo(trs);
        $('<td class="sumHdr">').html("Amount Left:").appendTo(trs);
        tds = $('<td id="tdAmountLeft" class="sumValue">');
        var totalLeft = CurrencyFormatted(parseFloat(totalAmount) - parseFloat(totalUsed));
        if (totalLeft != 0){
            tds.addClass("sumRed");
        }else{
            tds.removeClass("sumRed"); 
        }
        if (totalLeft < 0) {
            totalLeft = totalLeft.replace(/-/gi,"&#8209;") 
        }
        tds.html('$'+ totalLeft).appendTo(trs);
        tds.appendTo(trs);
        tbsumm.append(trs);
        
        dv.empty().append(tbsumm);
        $('<div class="tbContainer">').appendTo(dv).append(tables);
    }
    
    function getPaymentsCalculation(){
        var gTotal = parseFloat($('#<%= hdnSettlementAmount.ClientId%>').val());
        var pmts = []; 
        var ddlP = $('#<%= ddlPlanType.ClientId %>');
        switch(ddlP.val()){
            case "1":
                pmts.push(gTotal);
                return pmts;
                break;      
            case "2":
                var dnPmt = parseFloat($('#<%= txtPmtAmount.ClientId%>').val());
                if (dnPmt > 0) {
                    gTotal = gTotal - dnPmt;
                    pmts.push(dnPmt);
                }
                return $.merge(pmts, getInstallments(gTotal));
                break;
            case "3":
                var lastPmt = parseFloat($('#<%= txtPmtAmount.ClientId%>').val());
                if (lastPmt > 0) {
                    gTotal = gTotal - lastPmt;
                    pmts.push(lastPmt);
                }
                return $.merge(getInstallments(gTotal), pmts);
                break;
            case "4":
                return $.merge(pmts,getInstallments(gTotal));
                break;
            default:
                return pmts;
                break;
        }
    }
    
    function getInstallments(total){
        var pmts = [];
        var ddlI = $('#<%= ddlInstallmentType.ClientId %>');
        switch(ddlI.val()){
            case "1":
                var count = parseInt($('#<%= txtInstallmentCount.ClientId%>').val());
                if (count && count > 0) {
                    return getPaymentsByCount(total,count);
                }  
                break;      
            case "2":
                var amount = parseFloat($('#<%= txtInstallmentAmount.ClientId%>').val());
                if (amount && amount > 0) {
                    return getPaymentsByAmount(total,amount);
                } 
                break;
            default:
                break;
        } 
        return pmts;
    }
    
    function getPaymentsByAmount(total, partial){
        var paymnts = [];
        while (total > 0){
            if (total - partial < 1 ){
                paymnts.push(total);
                total = 0;
            } else {
                paymnts.push(partial);
                total = total - partial;
            }
        }
        return paymnts;
    }
    
    function getPaymentsByCount(total, count){
        var partial = (total / count).toFixed(2); 
        return getPaymentsByAmount(total, partial);
    }
    
    function CurrencyFormatted(amount) {
        var i = parseFloat(amount);
        if (isNaN(i)) { i = 0.00; }
        var minus = '';
        if (i < 0) { minus = '-'; }
        i = Math.abs(i);
        i = parseInt((i + .005) * 100);
        i = i / 100;
        s = new String(i);
        if (s.indexOf('.') < 0) { s += '.00'; }
        if (s.indexOf('.') == (s.length - 2)) { s += '0'; }
        s = minus + s;
        return s;
    }
    
    function writeValidationMsg(msgtext, msgtype, bClose) {
        var dv = $('#dvValMsg');
        dv.addClass(msgtype);
        dv.html(msgtext);
        dv.show();
        if (bClose == true) {
            dv.append("<br/><br/>" + "<a href='#'" + ' onclick="this.parentNode.style.display=' + "'none'" + ';"' + ">Close</a>")
        }
    }

    function validateInstallmentType() {
        var ddlI = $('#<%= ddlInstallmentType.ClientId %>');
        switch (ddlI.val()) {
            case "1":
                var count = parseInt($('#<%= txtInstallmentCount.ClientId%>').val());
                if (!(count && count > 0)) {
                    writeValidationMsg('Please, enter the number of installments!', 'error');
                    return false;
                }
                break;
            case "2":
                var amount = parseFloat($('#<%= txtInstallmentAmount.ClientId%>').val());
                if (!(amount && amount > 0)) {
                    writeValidationMsg('Please, enter the installment amount!', 'error');
                    return false;
                }
                break;
            default:
                writeValidationMsg('Please, select an installment method!', 'error');
                return false;
                break;
        }
        return true;
    }

    function validateLargeAmountPlan(gTotal, depositName) {
        var depPmt = parseFloat($('#<%= txtPmtAmount.ClientId%>').val());
        if (depPmt > gTotal) {
            writeValidationMsg('The ' + depositName  + ' payment amount cannot exceed the 100% of the settlement amount!', 'error');
            return false;
        }
        if ((depPmt == 0) && ($('#<%= ddlInstallmentType.ClientId %>').val() < 1)) {
            writeValidationMsg('Please, select a ' + depositName  + ' payment amount!', 'error');
            return false;
        }
        if (depPmt < gTotal) {
            if (!validateInstallmentType()) {
                return false;
            }
        }
        return true;
    }

    function resetNewPlan() {
        $('#<%= txtStartDate.ClientId %>').val("");
        $('#<%= ddlPlanType.ClientId %>').get(0).selectedIndex = 0;
        $('#<%= txtPmtAmount.ClientId%>').val("0.00");
        $('#<%= txtPmtAmountPct.ClientId%>').spinner("value", 0);
        $('#<%= ddlInstallmentType.ClientId %>').get(0).selectedIndex = 0;
        $('#<%= txtInstallmentCount.ClientId%>').val("0");
        $('#<%= txtInstallmentAmount.ClientId%>').val("0.00");
    }

    function hidePaymentGrids() {
        $('#divNewPlan').hide();
        $('#<%= divGrid.ClientId %>').hide();
    }

    function DeletePlan_Yes() {
        var settlementid = document.getElementById('<%=hdnSettlementID.clientID %>').value;
        var dArray = "{'settlementid': '" + settlementid + "'}";
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%=  ResolveUrl("~/services/LexxwareService.asmx/DeletePaymentSchedule")%>',
            data: dArray,
            dataType: "json",
            async: true,
            success: function(response) {
                setTimeout(function() { AlertModal({ message: response.d, title: "Success", type: "success", width: 300, height: 30 }); }, 1);
                refresh();
            },
            error: function(response) {
                alert(response.responseText);
                refresh();
            }
        });
    }
    
    function CreateNewPlan_Yes() {
        var settid = $('#<%= hdnSettlementId.ClientId%>').val();
        var jsonPmts = {settlementid: settid, payments:[]};
        $(".tbContainer").find("tr:not(:has(th))").each(function(index,item){
            if (item.cells(0).innerText != 0) {
                jsonPmts.payments.push({position: item.cells(0).innerText ,date: item.cells(1).innerText , amount: item.cells(2).innerText});
            }
        });
        
        $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%=  ResolveUrl("~/services/LexxwareService.asmx/CreatePaymentSchedulePlan")%>',
                data: JSON.stringify(jsonPmts),
                dataType: "json",
                async: true,
                success: function(response) {
                    switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            resetNewPlan();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            writeValidationMsg(response.d.message,"error"); 
                            break;
                        default:
                            break;
                    }
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });
    }
    
    function clearMsg() {
        $('#<%= divResults.ClientID %>').empty().removeClass();
    }
   
    function CreatePlan() {
        $('#dvValMsg').hide();
        
        var bvalid = true;
        //check startdate
        var startdate = $('#<%= txtStartDate.ClientId %>').datepicker( "getDate" );
        if (!startdate) {
            writeValidationMsg('A start date is required, please select the starting date for the installments!', 'error');
            return false;
        }
        //Settlement amount
        var gTotal = parseFloat($('#<%= hdnSettlementAmount.ClientId%>').val());
        if (gTotal <= 0)  {
            writeValidationMsg('The settlement amount must be greater than zero!', 'error');
            return false;
        }      
        //ValidateFields Plans
        var ddlP = $('#<%= ddlPlanType.ClientId %>');
        switch(ddlP.val()){
            case "1":
                break;      
            case "2":
                if (!validateLargeAmountPlan(gTotal,'down')){
                    return false;
                }
                break;
            case "3":
                 if (!validateLargeAmountPlan(gTotal,'balloon')){
                    return false;
                }
                break;
            case "4":
                if (!validateInstallmentType()){
                    return false;
                }
                break;
            default:
                writeValidationMsg('Please, select a payment plan!', 'error');
                return false;
                break;
        }
        
        //Validate 100% Used and no Left Over
        var totalUsed = $("#tdAmountUsed").text();
        var totalLeft = $("#tdAmountLeft").text();
        totalUsed = parseFloat(totalUsed.replace(/\$/gi,""));
        totalLeft = parseFloat(totalLeft.replace(/\$/gi,""));
        
        if ((gTotal != totalUsed) || (totalLeft != 0 )) {
            writeValidationMsg('Calculation error. The sum of payments and the settlement amount do not balance.', 'error');
            return false;
        }
       
        ConfirmationModalDialog({window: window, 
                     title: "Create New Plan", 
                     callback: "CreateNewPlan_Yes", 
                     message: "A new plan will delete the previous plan if it exists, do you want to continue?"});

        return false;
    }
    
    function DeletePayment_Yes(){
        var paymentscheduleid = document.getElementById('<%=hdnPmtScheduleID.clientID %>').value;
        var dArray = "{'paymentscheduleid': '" + paymentscheduleid + "'}";
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/DeleteSchedulePayment") %>',
            data: dArray,
            dataType: "json",
            async: true,
            success: function(response) {
                clearMsg();
                $('#<%= divAdd.ClientID %>').hide();
                setTimeout(function(){AlertModal({message: response.d, title: "Success", type: "success" ,width: 300, height: 30});},1);
                refresh();
            },
            error: function(response) {
                alert(response.responseText);
                refresh();
            }
        });
    }
</script>

<script type="text/javascript">
    function refresh() { 
           hidePaymentGrids();
           <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
    }
    
    function Cancel() {
        $('#<%= divAdd.ClientID %>').hide();
        $('#<%= divGrid.ClientID %>').show();
        $('#<%= txtPaymentDate.ClientID %>').val("");
        $('#<%= txtPaymentAmt.ClientID %>').val("");
        return false;
    }
    
    function AddNew() {
        $('#<%= divGrid.ClientID %>').hide();
        $('#<%= divAdd.ClientID %>').show();
        $('#<%= lnkAdd.ClientID %>').show();
        $('#<%= lnkSave.ClientID %>').hide();
        $('#<%= hdnPmtScheduleID.ClientID %>').val("");
        $('#<%= txtPaymentDate.ClientID %>').val("");
        $('#<%= txtPaymentAmt.ClientID %>').val("");
        return false;
    }
    
    function ShowEdit(date, amt, payid) {
        $('#<%= hdnPmtScheduleID.ClientID %>').val(payid);
        $('#<%= divAdd.ClientID %>').show();
        $('#<%= divGrid.ClientID %>').hide();
        $('#<%= lnkAdd.ClientID %>').hide();
        $('#<%= lnkSave.ClientID %>').show();
        $('#<%= txtPaymentDate.ClientID %>').val(date);
        amt = amt.replace(/\$/gi,"");
        $('#<%= txtPaymentAmt.ClientID %>').val(amt);
        return false;
    }
    
    function ValidateFields() {
        var msg = '';
        var bValid = true;
        var dv = $('#<%= divResults.ClientID %>');

        var pd = $('#<%= txtPaymentDate.ClientID %>');
        var pa = $('#<%= txtPaymentAmt.ClientID %>');

        if (pd.val() == '') {
            msg = 'A payment date is required for a payment entry!';
            bValid = false;
        }

        if (!pa.val() || pa.val() == 0 ) {
            if (msg != '') {
                msg += '<br />';
            }
            msg += 'A payment amount is required for a payment entry!';
            bValid = false;
        }
        if (bValid == false) {
            writeMsg(msg, 'error');
        }
        return bValid;
    }
    
    function writeMsg(msgtext, msgtype, bClose) {
        var dv = document.getElementById('<%= divResults.ClientID %>');
        dv.className = msgtype;
        dv.innerHTML = msgtext;
        if (bClose == true) {
            dv.innerHTML += "<br/><br/>" + "<a href='#'" + ' onclick="this.parentNode.style.display=' + "'none'" + ';"' + ">Close</a>";
        }
    }
    
    function togglePlans() {
        var dvA = document.getElementById('<%= divGrid.ClientID %>')
        var d = document.getElementById('divNewPlan');
        var dres = $("#<%= divResults.clientid %>");
        var noresults = (dres.find("span[noresults]='yes'").size() !=0);
        d.style.display = (d.style.display != 'none' ? 'none' : '');
        
        if ((d.style.display != 'none') || noresults) {
             dvA.style.display = 'none';
        } else {
            dvA.style.display = (dvA.style.display != 'none' ? 'none' : '');
        }
        
        if (noresults){
            if (d.style.display != 'none'){
                dres.hide();} 
            else {
                dres.show();
                }
        }
        
        $('#dvValMsg').hide();
        
        return false;
    }
    
    function DeletePlan() {
        ConfirmationModalDialog({window: window, 
                         title: "Delete Plan", 
                         callback: "DeletePlan_Yes", 
                         message: "Are you sure you want to delete this payment plan?"});
        return false;
    }
    
    function DeletePayment(){
        ConfirmationModalDialog({window: window, 
                         title: "Delete Payment", 
                         callback: "DeletePayment_Yes", 
                         message: "Are you sure you want to delete this payment?"});
        return false;
    }
    
    function InsertUpdatePayment(){
        
        var bVal = ValidateFields();
        if (bVal==false){
            return false;
        }
        
        clearMsg();
        $('#<%= divAdd.ClientID %>').hide();
        
        var paymentscheduleid = $('#<%=hdnPmtScheduleID.clientID %>').val();
        var settlementid = $('#<%=hdnSettlementID.clientID %>').val();
        var paymentdate = $('#<%= txtPaymentDate.ClientID %>').val();
        var paymentamount = $('#<%= txtPaymentAmt.ClientID %>').val();
        
        if (paymentscheduleid ==''){
            paymentscheduleid= '-1';
        }
        
        var dArray = {paymentscheduleid: paymentscheduleid, 
                      settlementid: settlementid, 
                      paymentdate: paymentdate, 
                      paymentamount: paymentamount};
        
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/InsertUpdateSchedulePayment")%>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
               setTimeout(function(){AlertModal({message: response.d, title: "Success", type: "success" ,width: 300, height: 30});},1);
               refresh();
            },
            error: function(response) {
                alert(response.responseText);
                refresh();
            }
        });
      
      return false;
        
    }
</script>

<div id="divControl" runat="server" style="padding: 5px;">
    <div id="divInfo" runat="server" style="width: 100%; padding: 5px;">
        <div id="divClientInfo" runat="server" visible="false">
            <asp:Label ID="lClient" runat="server" Text="Client Acct#:" />
            <asp:Label ID="lblClient" runat="server" /><br />
            <asp:Label ID="lClientName" runat="server" Text="Client Name:" />
            <asp:Label ID="lblClientName" runat="server" />
        </div>
        <div id="divCreditorInfo" runat="server" visible="false">
            <asp:Label ID="lblCred" runat="server" Text="Creditor :" />
            <asp:Label ID="lblCreditor" runat="server" /><br />
            <asp:Label ID="Label1" runat="server" Text="Balance :" />
            <asp:Label ID="lblAcctBal" runat="server" />
        </div>
        <div id="divSettInfo" runat="server">
            <asp:Label ID="Label2" runat="server" Text="Sett Due:" />
            <asp:Label ID="lblSettDue" runat="server" CssClass="dvSettInfo" />
            <asp:Label ID="Label3" runat="server" Text="Sett Amt :"/>
            <asp:Label ID="lblSettAmt" runat="server"  CssClass="dvSettInfo" />
            <asp:Label ID="Label4" runat="server" Text="Sett Fee :"  />
            <asp:Label ID="lblSettFee" runat="server" CssClass="dvSettInfo"/>
        </div>
    </div>
    <div id="divResults" runat="server">
    </div>
    <div id="divGrid" runat="server" style="width: 100%; padding: 5px;">
        <div id="divtoolbar" style="background-color: #5D7B9D;">
            <table style="height: 35px">
                <tr>
                    <td id="tdAddNew" runat="server">
                        <asp:LinkButton ID="lnkAddNew" runat="server" OnClientClick="return AddNew();" CssClass="lnk"
                            Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White">
                            <asp:Image ID="imgFolder" runat="server" ImageUrl="~/images/16x16_transaction_add.png"
                                ImageAlign="AbsMiddle" />
                            Add New Payment
                        </asp:LinkButton>
                    </td>
                    <td>
                        <asp:LinkButton ID="lnkNewPlan" runat="server" CssClass="lnk" Style="margin: 5px;
                            font-weight: bold; white-space: nowrap;" OnClientClick="return togglePlans();" ForeColor="White">
                            <asp:Image ID="Image2" runat="server" ImageUrl="~/images/16x16_note_add.png" ImageAlign="AbsMiddle" />
                            New Payment Plan
                        </asp:LinkButton>
                    </td>
                    <td>
                        <asp:LinkButton ID="lnkDeletePlan" runat="server" CssClass="lnk" OnClientClick="return DeletePlan();"
                            Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White">
                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/16x16_transaction_void.png"
                                ImageAlign="AbsMiddle" />
                            Delete Payment Plan
                        </asp:LinkButton>
                    </td>
                </tr>
            </table>
        </div>
            <asp:GridView ID="gvReport" runat="server" AllowPaging="False" AllowSorting="False"
                AutoGenerateColumns="False" DataKeyNames="PmtScheduleID,ClientID,SettlementID,AccountID"
                DataSourceID="dsReport" CssClass="entry" CellPadding="4" GridLines="None" ShowFooter="false" Width="300px"  >
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" CssClass="lnk" runat="server" Text="Edit" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="50" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="50" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="PmtScheduleID" HeaderText="PmtScheduleID" InsertVisible="False"
                        ReadOnly="True" SortExpression="PmtScheduleID" Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ClientID" HeaderText="ClientID" SortExpression="ClientID"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ClientName" HeaderText="ClientName" ReadOnly="True" SortExpression="ClientName"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" Wrap="false" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AccountID" HeaderText="AccountID" SortExpression="AccountID"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" />
                        <ItemStyle CssClass="listItem" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SettlementID" HeaderText="SettlementID" SortExpression="SettlementID"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" />
                        <ItemStyle CssClass="listItem" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CurrentCreditor" HeaderText="Creditor" SortExpression="CurrentCreditor"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:c2}"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PaymentNumber" HeaderText="#" InsertVisible="False"
                        ReadOnly="True" SortExpression="PaymentNumber" >
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PmtDate" HeaderText="Scheduled" SortExpression="PmtDate" DataFormatString="{0:MM/dd/yyyy}">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="75" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="75" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PmtAmount" HeaderText="Amount" SortExpression="PmtAmount"
                        DataFormatString="{0:c2}">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" Width="150" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" Width="150" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PmtRecdDate" HeaderText="Paid On" SortExpression="PmtRecdDate"
                        DataFormatString="{0:d}">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="150" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="150" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                        DataFormatString="{0:MM/dd/yyyy}" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="75" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="75" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" SortExpression="CreatedBy"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CreatedByName" HeaderText="Created By" ReadOnly="True"
                        SortExpression="CreatedByName" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastModified" HeaderText="LastModified" SortExpression="LastModified"
                        DataFormatString="{0:MM/dd/yyyy}" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="75" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="75" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModifiedBy" SortExpression="LastModifiedBy"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastModifedByName" HeaderText="Last Modifed By" ReadOnly="True"
                        SortExpression="LastModifedByName" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SettlementDueDate" HeaderText="Settlement Due Date" SortExpression="SettlementDueDate"
                        DataFormatString="{0:MM/dd/yyyy}" Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SettlementAmount" HeaderText="SettlementAmount" SortExpression="SettlementAmount"
                        DataFormatString="{0:c2}" Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AccountNumber" HeaderText="AccountNumber" SortExpression="AccountNumber"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" />
                        <ItemStyle CssClass="listItem" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ReferenceNumber" HeaderText="ReferenceNumber" SortExpression="ReferenceNumber"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" />
                        <ItemStyle CssClass="listItem" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <EmptyDataTemplate>
                    <div class="info">
                        There are no Payment Arrangements at this time.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        <asp:SqlDataSource ID="dsReport" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
            ProviderName="System.Data.SqlClient" SelectCommand="stp_paymentarrangement_Select"
            SelectCommandType="StoredProcedure" DeleteCommand=" ">
            <SelectParameters>
                <asp:Parameter Name="SettlementID" Type="Int32"  />
            </SelectParameters>
        </asp:SqlDataSource>
        <div id="updateDiv" style="display: none; height: 40px; width: 40px">
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
        </div>
        
        <div id="divTotal" runat="server" style="vertical-align: middle; background-color: #5D7B9D;
            font-weight: bold; color: White; padding: 3px;">
            Total : $0.00</div>
    </div>
    <br />
    <div id="divNewPlan" style="width: 100%; border: solid 1px #70A8D1; background-color: #F0F5FB;
        padding: 10px; display: none;">
        <div id="dvValMsg" style="display: none;"></div>
        <fieldset>
            <legend>Start Date:</legend>
            <div class="box">
                <asp:TextBox ID="txtStartDate" Width="60px" runat="server" />
            </div>
        </fieldset>
        <fieldset> 
            <legend>Payment Options:</legend>
            <div class="box"> 
                <div>
                    <asp:DropDownList ID="ddlPlanType" runat="server" CssClass="ddlPmt" >
                        <asp:ListItem Selected="True" Value="0">Select Payment Plan</asp:ListItem>
                        <asp:ListItem Value="1">One Lump Sum</asp:ListItem>
                        <asp:ListItem Value="2">Down Payment + Installments</asp:ListItem>
                        <asp:ListItem Value="3">Installments + Balloon Payment</asp:ListItem>
                        <asp:ListItem Value="4">Installments</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div id="dvDPmtAmnt" style="display:none;">
                    <div class="dvPmt"">
                        <span class="pmtMeassure">$</span>
                        <div>
                            <asp:TextBox ID="txtLSumAmount" runat="server" CssClass="txtPmtAmt" ReadOnly="True"></asp:TextBox> 
                            <asp:TextBox ID="txtPmtAmount" runat="server" CssClass="txtPmtAmt"></asp:TextBox> 
                        </div>
                    </div>
                    <div id="dvPmtPct" class="dvPmt">
                        <span class="pmtMeassure">%</span>
                        <div>
                            <asp:TextBox ID="txtPmtAmountPct" runat="server" CssClass="txtPmtPct"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div id="dvPmtOpts" class="box" style="clear:both; padding-top: 1px; display: none;">
                <div>
                    <asp:DropDownList ID="ddlInstallmentType" runat="server" CssClass="ddlPmt">
                        <asp:ListItem Selected="True" Value="0">Select Installment Method</asp:ListItem>
                        <asp:ListItem Value="1">By Number of Installments</asp:ListItem>
                        <asp:ListItem Value="2">By Installment Amount</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div style="display:inline;">
                    <div id="dvItmCount" class="dvPmt">
                        <span class="pmtMeassure">#</span>
                        <div>
                            <asp:TextBox ID="txtInstallmentCount" runat="server" CssClass="txtPmtAmt"></asp:TextBox>
                        </div>
                    </div>
                    <div id="dvItmAmount" class="dvPmt">
                        <span class="pmtMeassure">$</span>
                        <div>
                            <asp:TextBox ID="txtInstallmentAmount" runat="server" CssClass="txtPmtAmt"></asp:TextBox> 
                        </div>
                    </div>
                </div>
            </div>
        </fieldset>
        <fieldset>
            <legend>Results:</legend> 
            <div id="dvPmtResults" class="pmtResults">
        </div>
        </fieldset>
        <hr />
        <asp:LinkButton ID="lnkCreatePlan" runat="server" Text="Create Payment Plan" CssClass="lnk"
            Style="margin: 5px;" OnClientClick="return CreatePlan();" />&nbsp;<span style="color: black !important;">|</span>&nbsp;
        <asp:LinkButton ID="lnkCancelPlan" runat="server" Text="Cancel" CssClass="lnk" OnClientClick="return togglePlans();" Style="margin: 5px;"/>
    </div>
    <div id="divAdd" runat="server" style="width: 250; border: solid 1px #DCDCDC; display: none;">
        <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <th class="headItem5" style="height: 25px;">
                    Payment Info
                </th>
            </tr>
            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td align="right">
                                <asp:Label ID="lblData" runat="server" Text="Payment Date:" />
                            </td>
                            <td>
                                <div class="box">
                                    <asp:TextBox ID="txtPaymentDate" runat="server" style="width: 70px;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Label ID="lblAmt" runat="server" Text="Payment Amount:" />
                            </td>
                            <td>
                                <div class="box dvPmt">
                                    <span class="pmtMeassure">$</span>
                                    <div>
                                        <asp:TextBox ID="txtPaymentAmt" runat="server" CssClass="txtPmtAmt" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="right" style="background-color: #DCDCDC; color: #000; height: 25px; white-space: nowrap">
                    <asp:LinkButton ID="lnkCancel" runat="server" Text="Cancel" CssClass="lnk" OnClientClick="return Cancel();"
                        Style="position: relative; float: right; margin: 2px;" />
                    <asp:LinkButton ID="lnkDelete" CssClass="lnk" runat="server" CommandName="Delete"
                        OnClientClick="return DeletePayment();"
                        Text="Delete" Style="position: relative; float: right;
                        margin: 2px;" />
                    <asp:LinkButton ID="lnkAdd" Style="position: relative; float: right; margin: 2px;"
                        runat="server" Text="Add" CssClass="lnk" OnClientClick="return InsertUpdatePayment();"
                        />
                    <asp:LinkButton ID="lnkSave" runat="server" Text="Save" Style="position: relative;
                        float: right; margin: 2px; display: none;" CssClass="lnk" OnClientClick="return InsertUpdatePayment();"
                         />
                </td>
            </tr>
        </table>
    </div>
    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
</div>
<asp:HiddenField ID="hdnPmtScheduleID" runat="server" />
<asp:HiddenField ID="hdnClientID" runat="server" />
<asp:HiddenField ID="hdnSettlementID" runat="server" />
<asp:HiddenField ID="hdnAccountID" runat="server" />
<asp:HiddenField ID="hdnSettlementAmount" runat="server" />
<asp:HiddenField ID="hdnSettlementFee" runat="server" />
<asp:HiddenField ID="hdnNoPlan" runat="server" />
