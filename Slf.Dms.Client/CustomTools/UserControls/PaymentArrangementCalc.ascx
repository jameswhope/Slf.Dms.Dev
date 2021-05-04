﻿<%@ Control Language="VB" AutoEventWireup="false" CodeFile="PaymentArrangementCalc.ascx.vb"
    Inherits="CustomTools_UserControls_PaymentArrangementCalc" EnableViewState="true"  %>
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
         overflow: auto;
         }
         
    .tbPmntResults
    {
         empty-cells: show;
         margin-top: 3px;
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
         width: 50px;
         text-align: right;
         color: #000000;
         padding-right: 10px;
         padding-left: 10px;
         }
          
      .sumRed
      {
          color: red !important;
          }
         
     fieldset {padding: 5px 3px 5px 3px; 
               margin-top: 3px;
               margin-bottom: 3px;}
     
     .dvSettInfo
     {
         width: 50px;
         }
        
    .dvCustomContainer 
    {
        width: 100%;
        height: 200px;
        overflow: auto;
        }
        
    .imgsettinfo
    {   
        width: 16px;
        height:16px;
        background: url(<%= ResolveUrl("~/images/16x16_dataentry.png")%>); 
        }
    
    .dvPopupInfo.ui-tooltip
    {
        max-width: 300px;
        width: 300px;
        line-height: 18px;
        }
        
    .dvPopupInfo.ui-tooltip label
    {
        width: 100px;
        font-weight: bold;
        }
    .ppOn 
    {
       /*color: red !important;*/
       font-weight: bold !important;
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

            $("#dialog-monthly-span").dialog({
                autoOpen: false,
                height: 750,
                width: 350,
                modal: true,
                position: 'top',
                resizable: true,
                scrollable: true
            });        
             
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
                    step: 0.01,
                    numberFormat: "n",
                    min: 0.00,
                    spin: function( event, ui ){CalculateAmountFromPct();}
                }).removeClass("box")
                  .keydown(function(){CalculateAmountFromPct();})
                  .keypress(function(event){decimalOnly(event, $(this));}); 
             
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
                
             //redraw from view state
             selectPaymentPlan($('#<%= ddlPlanType.ClientId %>'));
             DrawPaymentHtml();
             
             showMode();
             
             refreshPACheckbox();
             $("input[id$='chkUsePArrangement']").button()
                                                 .change(function(){
                                                         refreshPACheckbox();
                                                         refreshRegularCalculator();
                                                }); 
             
             //Custom section
             $("#table_calc").find("input[id$='txtSettlementAmt']").keyup(function(event){
                setTimeout(function(){syncSettlementAmount(1);},1);}); 
             
             $("#table_calc").find("input[id$='txtSettlementPercent']").keyup(function(event){
                setTimeout(function(){syncSettlementAmount(1);},1);}); 
             
             $("#table_calc").find("img[onclick^='PercentUpDown']").click(function(event){
                setTimeout(function(){syncSettlementAmount();},1);}); 
             
             if (parseFloat($("#<%= hdnSettlementAmount.ClientId %>").val()) > 0) {
                setTimeout(function(){
                    syncBackSettlementAmount();
                    SyncCustomHeader($("#<%= hdnSettlementAmount.ClientId %>").val());
                },1);
             }
             
             $('#<%=lnkNewPlan.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkDeletePlan.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkAddNew.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkSaveCustom.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkDeleteAll.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkRemoveCustom.ClientId%>').button().css("margin", "1px");
             $('#<%=lnkAdd.ClientId%>').button();
             $('#<%=lnkSave.ClientId%>').button();
             $('#<%=lnkDelete.ClientId%>').button();
             $('#<%=lnkCancel.ClientId%>').button();
             
             $('#<%=divPopupInfo.ClientId %>').hide();
             $('.imgsettinfo').tooltip({items: "div", content:$('#<%=divPopupInfo.CLientId %>').html() })
                              .off("mouseover")
                              .on("click", function(){
                                            $(this).tooltip("open");
                                            return false;
                                            });
                                            
              $("#table_calc").find("input[id$='ibtnAccept']")
                              .click(function(event){
                                    event.preventDefault();
                                    ValidateAcceptOffer();
                                    return false;
                              }
              );
              
              $(document).keydown(function(e){
                    if ( e.keyCode == 8 && e.target.tagName != 'INPUT' && e.target.tagName != 'TEXTAREA') {
                        e.preventDefault();
                    }
              });
        });
    }
        
        function getSDASpan() {

            //$('#divLoading').html('<img src="../../images/loading_miniballs.gif" alt="loading..." />');

            var dArray = "{'clientid': '<%= Me.DataClientId %>'}";

            $.ajax({
                type: "POST",
                url: "default.aspx/getSpan",
                data: dArray,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                success: function (response) {
                    $('#divGrid').html(response.d);
                    //$('#divLoading').html('');
                    $("#dialog-monthly-span").dialog("open");
                    return false;
                },
                error: function (response) {
                    alert(response.responseText);
                    return false;
                }
            });
            
            return false;
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
    
    function ValidateAcceptOffer(){
        clearMsg();
        var pasession = $('#<%= hdnPASessionId.ClientId%>');
        var pasessionid = pasession.val();
        var chkPA = $("input[id$='chkUsePArrangement']");
        var usedownpayment = (chkPA && chkPA.prop('checked') && chkPA.closest("td").is(':visible'));
        if (usedownpayment){
            $('#dvValMsg').hide();
            switch ($("#<%=hdnMode.ClientId %>").val()){
                case "1":
                    if (!IsValidPlan()) {
                        return false;
                    }
                    SavePlan_Yes(function(){
                        var jsonPmts = {payments:[]};
                        $(".tbContainer").find("tr:not(:has(th))").each(function(index,item){
                            if (item.cells(0).innerText != 0) {
                                jsonPmts.payments.push({position: item.cells(0).innerText ,date: item.cells(1).innerText , amount: item.cells(2).innerText});
                            }
                        });
                        pasessionid = pasession.val();
                        AcceptOfferJS(pasessionid, jsonPmts);}
                        );
                    break;
                case "2":
                    ValidateCustomCalc(function(){
                        AcceptOfferJS(pasessionid);}
                        );
                default:
                    break;
            }
        } else {
            AcceptOfferJS(0); 
        }
        return false;
    } 
    
    function refreshPACheckbox(){
        var $chk = $("input[id$='chkUsePArrangement']").button();
        if ($chk.prop('checked')) {
                $chk.button("option","label", "Payment Plan is ON");
                $chk.next("label").addClass("ppOn");
         } else {
                $chk.button("option","label", "Payment Plan is OFF");
                $chk.next("label").removeClass("ppOn");
         }
    }
    
    function refreshRegularCalculator(){
        try{
           var ctl = $("#table_calc").find("input[id$='txtSettlementAmt']");
           updateDataByAmount(ctl.get(0));
       }catch(e){}
    }
    
    function SyncCustomHeader(settamount){
        $("#<%= lblCustomSettAmount.ClientId%>").text('$'+settamount);
        DrawCustomHeader();
    }
    
    function DrawCustomHeader(){
         var settamt = parseFloat($("#<%= lblCustomSettAmount.ClientId%>").text().replace(/\$/gi,"").replace(/,/gi,""));

         var lcustamtused = $("#<%=lblCustomAmountUsed.ClientId %>");
         var custamtused = parseFloat(lcustamtused.text().replace(/\$/gi,"").replace(/,/gi,""));

         if (custamtused == 0) {
            lcustamtused.closest("td").addClass('sumRed');
         } else {
            lcustamtused.closest("td").removeClass('sumRed');
         }  
         
         var lcustamtleft =  $("#<%=lblCustomAmountLeft.ClientId %>");  
         var custamtleft = parseFloat(settamt - custamtused);
         
         if (parseFloat(custamtleft) != 0) {
            lcustamtleft.closest("td").addClass('sumRed');
         } else {
            lcustamtleft.closest("td").removeClass('sumRed');
         } 
         
         if (custamtleft < 0) {
            custamtleft = '($'+CurrencyFormatted(custamtleft).replace(/-/gi,"")+')';
         } else {
            custamtleft = '$'+CurrencyFormatted(custamtleft);
         }
         lcustamtleft.text(custamtleft);
    }
    
    function syncSettlementAmount(skipRefresh){
       var amt=$("#table_calc").find("input[id$='txtSettlementAmt']");
       if (amt.val()) {
            $("#<%= hdnSettlementAmount.ClientId %>").val(amt.val().replace(/,/gi,""));
            CalculateAmountPct(skipRefresh);
            SyncCustomHeader(amt.val());
       }
    }
    
    function syncBackSettlementAmount(){
       var ctl = $("#table_calc").find("input[id$='txtSettlementAmt']");
       ctl.val($("#<%= hdnSettlementAmount.ClientId %>").val());
       try{
           updateDataByAmount(ctl.get(0));
       }catch(e){}
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
    
    function DrawPaymentHtml(skipRefresh){
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
            $('<td class="' + ((index == 0)?'firstpayment ':'') + 'resultValue">').html('$'+CurrencyFormatted(value)).appendTo(tr);
            
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
        var btn = $("<button id='btnGetSA'></button>");
        btn.button({icons: { primary: "ui-icon-arrowrefresh-1-s" }, 
                   text: false})
                   .css("width", "16px")
                   .css("height", "3px")
                   .click(function(event){
                        event.preventDefault();
                        syncSettlementAmount();
                        }).hide();
        $('<td class="sumHdr">').html("Settlement Amount:").appendTo(trs);
        $('<td class="sumValue">').html('$'+CurrencyFormatted(totalAmount)).prepend(btn).appendTo(trs);
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
            totalLeft = '($'+totalLeft.replace(/-/gi,"")+')';
        } else {
            totalLeft ='$'+totalLeft.replace(/-/gi,"");
        }
        tds.html(totalLeft).appendTo(trs);
        tds.appendTo(trs);
        tbsumm.append(trs);
        
        dv.empty().append(tbsumm);
        $('<div class="tbContainer">').appendTo(dv).append(tables);
        
        //refresh down payment and calculation
        if ($('#<%= hdnMode.ClientId %>').val() == 1 && skipRefresh !=1 ){
            refreshRegularCalculator();
        }
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
        
        if (partial > 0 && total/partial < 120)
        {
            while (total > 0){
                if (total - partial < 1 ){
                    paymnts.push(total);
                    total = 0;
                } else {
                    paymnts.push(partial);
                    total = total - partial;
                }
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
        clearMsg();
        $('#<%= txtStartDate.ClientId %>').val("");
        $('#<%= ddlPlanType.ClientId %>').get(0).selectedIndex = 0;
        $('#<%= txtPmtAmount.ClientId%>').val("0.00");
        $('#<%= txtPmtAmountPct.ClientId%>').spinner("value", 0);
        $('#<%= ddlInstallmentType.ClientId %>').get(0).selectedIndex = 0;
        $('#<%= txtInstallmentCount.ClientId%>').val("0");
        $('#<%= txtInstallmentAmount.ClientId%>').val("0.00");
        syncSettlementAmount();
    }

    function hidePaymentGrids() {
        $('#<%= divNewPlan.CLientId %>').hide();
        $('#<%= divGrid.ClientId %>').hide();
    }

    function DeletePlan_Yes() {
        var pasession = $('#<%=hdnPASessionID.clientID %>');
        var dArray = "{'pasessionid': '" + pasession.val() + "'}";
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/DeletePACalc") %>',
            data: dArray,
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                            //setTimeout(function() { AlertModal({ message: response.d.message, title: "Success", type: "success", width: 300, height: 30 }); }, 1);
                            $('#<%= hdnOldSessionId.ClientId %>').val(0);
                            pasession.val(0);
                            clearMsg();
                            changeMode(0);
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
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
    
    function getPAJson(){
       return {clientid: "<%= me.dataclientid %>", 
              accountid: "<%= me.accountid %>",
       settlementamount: $('#<%= hdnSettlementAmount.ClientId%>').val(), 
              startdate: $('#<%= txtStartDate.ClientId %>').datepicker( "getDate" ),
               plantype: $('#<%= ddlPlanType.ClientId %>').val(),
                lumpsum: $('#<%= txtPmtAmount.ClientId%>').val(),
      installmentmethod: $('#<%= ddlInstallmentType.ClientId %>').val() ,
      installmentamount: $('#<%= txtInstallmentAmount.ClientId%>').val(), 
       installmentcount: $('#<%= txtInstallmentCount.ClientId%>').val()
                  };    
    }
    
    function SavePlan_Yes(fn) {
        var pasession = $('#<%= hdnPASessionId.ClientId %>');
        var jsonPA = {pasessionid: pasession.val(), 
                      sessiondata: getPAJson()};
        
        $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%=  ResolveUrl("~/services/LexxwareService.asmx/SavePACalc")%>',
                data: JSON.stringify(jsonPA),
                dataType: "json",
                async: true,
                success: function(response) {
                    switch (response.d.status)
                    {
                        case "success":
                            //setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            $('#<%= hdnOldSessionId.ClientId %>').val(0);
                            pasession.val(response.d.returnData);
                            clearMsg();
                            changeMode(1);
                            if (fn) {
                                fn()
                            }
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
    
    function CreateCustomPlan_Yes() {
        var pasession = $('#<%= hdnPASessionId.ClientId%>');
        var pasessionid = pasession.val();
        var jsonPA = getPAJson();
        var jsonPmts = {pasessionid: pasessionid, 
                        sessiondata: jsonPA,
                        payments:[]};
        $(".tbContainer").find("tr:not(:has(th))").each(function(index,item){
            if (item.cells(0).innerText != 0) {
                jsonPmts.payments.push({position: item.cells(0).innerText ,date: item.cells(1).innerText , amount: item.cells(2).innerText});
            }
        });
        
        $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%=  ResolveUrl("~/services/LexxwareService.asmx/CreatePACustomCalc")%>',
                data: JSON.stringify(jsonPmts),
                dataType: "json",
                async: true,
                success: function(response) {
                    switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            $('#<%= hdnOldSessionId.ClientId %>').val(0);
                            pasession.val(pasessionid);
                            changeMode(2);
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
   
    function IsValidPlan() {
        var bvalid = true;
        //check startdate
        var startdate = $('#<%= txtStartDate.ClientId %>').datepicker( "getDate" );
        if (!startdate) {
            writeValidationMsg('A start date is required, please select the starting date for the installments!', 'error');
            return false;
        }
        var today = new Date();
        today.setHours(0,0,0,0)
        var sdate = new Date(startdate);
        sdate.setHours(0,0,0,0)
        if (sdate < today) {
            writeValidationMsg('A start date cannot be older than ' + $.datepicker.formatDate('mm/dd/yy', today), 'error');
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
        
        return bvalid;
    
    }
    
    function IsValidCustomPlan(){
       
    }
   
    function CreateCustomPlan() {
        $('#dvValMsg').hide();
        
        if (!IsValidPlan()) {
            return false;
        }
       
        ConfirmationModalDialog({window: window, 
                     title: "Create Custom Plan", 
                     callback: "CreateCustomPlan_Yes", 
                     message: "A custom payment plan will be created, do you want to continue?"});

        return false;
    }
    
    function SavePlan(){
        $('#dvValMsg').hide();
        
        if (!IsValidPlan()) {
            return false;
        }
       
        ConfirmationModalDialog({window: window, 
                     title: "Save Plan", 
                     callback: "SavePlan_Yes", 
                     message: "A new plan will overwrite the previous plan if it exists, do you want to continue?"});

        return false;
    
    }
    
    function newPlanSession(){
        var planid = $('#<%= hdnPASessionId.ClientId %>');
        if (planid.val() > 0)  {
            $('#<%= hdnOldSessionId.ClientId %>').val(planid.val());
            planid.val(0); 
        }
        changeMode(1);
        resetNewPlan();
        selectPaymentPlan($('#<%= ddlPlanType.ClientId %>'));
        DrawPaymentHtml();
        return false;
    }
    
    function resetPlanSession(){
        resetNewPlan();
        selectPaymentPlan($('#<%= ddlPlanType.ClientId %>'));
        DrawPaymentHtml();
        return false;
    }
    
</script>

<script type="text/javascript">
    function refresh() { 
           hidePaymentGrids();
           <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
    }
    
    function Cancel() {
        clearMsg();
        $('#<%= divAdd.ClientID %>').hide();
        $('#<%= divGrid.ClientID %>').show();
        $('#<%= lnkSaveCustom.ClientID %>').show();
        $('#<%= txtPaymentDate.ClientID %>').val("");
        $('#<%= txtPaymentAmt.ClientID %>').val("");
        return false;
    }
    
    function AddNew() {
         clearMsg();
        $('#<%= divGrid.ClientID %>').hide();
        $('#<%= divAdd.ClientID %>').show();
        $('#<%= lnkAdd.ClientID %>').show();
        $('#<%= lnkSave.ClientID %>').hide();
        $('#<%= lnkDelete.ClientID %>').hide();
        $('#<%= lnkSaveCustom.ClientID %>').hide();
        $('#<%= hdnPADetailID.ClientID %>').val("");
        $('#<%= txtPaymentDate.ClientID %>').val("");
        $('#<%= txtPaymentAmt.ClientID %>').val("");
        return false;
    }
    
    function ShowEdit(date, amt, payid) {
        $('#<%= hdnPADetailID.ClientID %>').val(payid);
        $('#<%= divAdd.ClientID %>').show();
        $('#<%= divGrid.ClientID %>').hide();
        $('#<%= lnkSaveCustom.ClientID %>').hide();
        $('#<%= lnkAdd.ClientID %>').hide();
        $('#<%= lnkSave.ClientID %>').show();
        $('#<%= lnkDelete.ClientID %>').show();
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
    
    function repaintRegularCalculator(mode){
        if (mode==0){
           $("#table_calc").find("input[id$='chkUsePArrangement']").closest("td").hide();
           $("#table_calc").find("input[id$='lblPADownPayment']").closest("tr").hide();
        } else{
           $("input[id$='chkUsePArrangement']").closest("td").show();
        }
    return false;
    }
    
    function ShowDefaulMode(){
        $("#<%= divNoPlan.clientid %>").hide();
        $('#<%= divGrid.clientID %>').hide();
        $('#<%= divNewPlan.clientId %>').show(); 
        $('#<%= tdAddNew.clientId %>').hide();  
        $('#<%= tdSaveCustom.clientId %>').hide();
        $('#<%= dvCustomInfo.clientId %>').hide();
        $('#<%= tdRemoveCustom.clientId %>').hide();  
        if ($("#<%= hdnPASessionId.clientId %>").val() > 0) {
            $("#<%= lnkCancelPlan.clientid %>").hide();
            $("#<%= tdNewPlan.clientid %>").show(); 
            $("#<%= tdDeletePlan.clientid %>").show();
            $("#<%= lnkRestorePlan.clientid %>").show();
            $(".imgsettinfo").show();
        } else {
            $("#<%= tdNewPlan.clientid %>").hide();
            $("#<%= tdDeletePlan.clientid %>").hide();
            $("#<%= lnkRestorePlan.clientid %>").hide();
            $(".imgsettinfo").hide();
            $("#<%= lnkCancelPlan.clientid %>").show();
        }
        $("#<%= tdDeleteAllPmts.clientid %>").hide();
        
    }
    
    function ShowCustomMode(){
        $('#<%= divNewPlan.clientId %>').hide();
        $("#<%= divNoPlan.clientid %>").hide();
        $('#<%= dvCustomInfo.clientId %>').show();
        $('#<%= divGrid.clientID %>').show();
        $('#<%= tdAddNew.clientId %>').show();
        $('#<%= tdSaveCustom.clientId %>').show();
        $("#<%= tdNewPlan.clientid %>").show();
        $("#<%= tdDeletePlan.clientid %>").show();
        $("#<%= tdDeleteAllPmts.clientid %>").show();
        $('#<%= tdRemoveCustom.clientId %>').show();
        $(".imgsettinfo").show();
    }
    
    function ShowNoResults(){
        $('#<%= divNewPlan.clientId %>').hide();
        $('#<%= dvCustomInfo.clientId %>').hide();
        $('#<%= divGrid.clientID %>').hide();
        $('#<%= tdSaveCustom.clientId %>').hide();
        $("#<%= divNoPlan.clientid %>").show();
        $('#<%= tdAddNew.clientId %>').hide();
        $("#<%= tdNewPlan.clientid %>").show();
        $("#<%= tdDeletePlan.clientid %>").hide();
        $("#<%= tdDeleteAllPmts.clientid %>").hide();
        $('#<%= tdRemoveCustom.clientId %>').hide();
    }
    
    function showMode(){
        var mode = $("#<%= hdnMode.ClientId %>").val();
        switch (mode){
            case "0":
                ShowNoResults();
                break;
            case "2":
                ShowCustomMode();
                break;
            default:
                ShowDefaulMode();
        }
        repaintRegularCalculator(mode);
    }
    
    function changeMode(newmode) {
       var hdnmode = $("#<%= hdnMode.ClientId %>");
       var hdnoldmode = $("#<%= hdnOldMode.ClientId %>");
       hdnoldmode.val(hdnmode.val());
       hdnmode.val(newmode);
       showMode();
       //repaintRegularCalculator(newmode);
       $('#dvValMsg').hide();
        return false;
    }
    
     function reloadSession(pasession){
        $('#<%= hdnSettlementAmount.ClientId%>').val(pasession.settlementamount);
       
        $('#<%= txtStartDate.ClientId %>').val(pasession.startdate);
        
        var plantype = $('#<%= ddlPlanType.ClientId %>');
        plantype.val(pasession.plantype);

        $('#<%= txtPmtAmount.ClientId%>').val(pasession.lumpsum);
        CalculateAmountPct();
        
        $('#<%= ddlInstallmentType.ClientId %>').val(pasession.installmentmethod);
        $('#<%= txtInstallmentCount.ClientId%>').val(pasession.installmentcount);
        $('#<%= txtInstallmentAmount.ClientId%>').val(pasession.installmentamount);
        selectPaymentPlan(plantype);
        DrawPaymentHtml();
        return false;
    }
    
    function restoreSession(planid,mode){
         var pasession =  $('#<%= hdnPASessionId.ClientId %>');
         var dArray = "{'pasessionid': '" + planid + "'}";
         $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= ResolveUrl("~/services/LexxwareService.asmx/GetPACalc")%>',
                data: dArray,
                dataType: "json",
                async: true,
                success: function(response) {
                    switch (response.d.status)
                    {
                        case "success":
                            $('#<%= hdnOldSessionId.ClientId %>').val(0);
                            pasession.val(planid);
                            reloadSession(response.d.returnData);
                            changeMode(mode);
                            syncBackSettlementAmount();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
                },
                error: function(response) {
                    alert(response.responseText);
                }
            });
          return false;
    }
    
    function cancelDefaultMode(){
        clearMsg();
        var pasession = $("#<%= hdnPASessionId.ClientId %>");
        
        if ($("#<%= hdnOldSessionId.ClientId %>").val() > 0){
            restoreDefaultMode();
        } else {
            changeMode($("#<%= hdnOldMode.ClientId %>").val());
        }
        return false;
    }
    
    function restoreDefaultMode(){
        var hdnmode = $("#<%= hdnMode.ClientId %>");
        var oldmode = $("#<%= hdnOldMode.ClientId %>").val();
        var pasession =  $('#<%= hdnPASessionId.ClientId %>');
        var planid = pasession.val();
        if (!planid || planid == 0) {
            planid = $('#<%= hdnOldSessionId.ClientId %>').val();
        }
        if (oldmode == "2") {
            pasession.val(planid);
            changeMode(oldmode);
        } else {
            restoreSession(planid,oldmode);
        }
        return false;
    }
    
    function DeletePlan() {
        ConfirmationModalDialog({window: window, 
                         title: "Delete Plan", 
                         callback: "DeletePlan_Yes", 
                         message: "Are you sure you want to delete this payment plan?"});
        return false;
    }
    
    
    function SaveCustomPayment(){
        
        var bVal = ValidateFields();
        if (bVal==false){
            return false;
        }
        
        clearMsg();
        $('#<%= divAdd.ClientID %>').hide();
        
        var padetailid = $('#<%=hdnPADetailID.clientID %>').val();
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var paymentdate = $('#<%= txtPaymentDate.ClientID %>').val();
        var paymentamount = $('#<%= txtPaymentAmt.ClientID %>').val();
        var settlementamount = $('#<%= hdnSettlementAmount.ClientID %>').val();
        if (padetailid ==''){
            padetailid = '-1';
        }
        
        var dArray = { padetailid: padetailid, 
                      pasessionid: pasessionid, 
                      settlementamount: settlementamount,
                      paymentdata: {date: paymentdate, amount: paymentamount}};
        
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/SavePADetail")%>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
      
      return false;
        
    }
    
    function DeleteCustomPayment(){
        ConfirmationModalDialog({window: window, 
                         title: "Delete Payment", 
                         callback: "DeleteCustomPayment_Yes", 
                         message: "Are you sure you want to delete this payment?"});
        return false;
    }
    
    function DeleteCustomPayment_Yes(){
        var padetailid = $('#<%=hdnPADetailID.clientID %>').val();
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var settlementamount = $('#<%= hdnSettlementAmount.ClientID %>').val();
        var dArray = {padetailid: padetailid, pasessionid: pasessionid, settlementamount: settlementamount};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/DeletePADetail") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                             clearMsg();
                            $('#<%= divAdd.ClientID %>').hide();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
    function DeleteAllCustomPmts(){
        ConfirmationModalDialog({window: window, 
                         title: "Delete All Payments", 
                         callback: "DeleteAllCustomPmts_Yes", 
                         message: "Are you sure you want to delete all custom payments?"});
        return false;
    }
    
    function DeleteAllCustomPmts_Yes(){
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var dArray = {pasessionid: pasessionid};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/DeleteAllPADetails") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
    function RemoveCustom(){
        ConfirmationModalDialog({window: window, 
                         title: "Rollback customizations", 
                         callback: "RemoveCustom_Yes", 
                         message: "Are you sure you want to rollback the customizations to a regular payment schedule?"});
        return false;
    }
    
    function RemoveCustom_Yes(){
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var dArray = {pasessionid: pasessionid};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/RemovePACustomizations") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
    function SaveCustomCalc(){
        ConfirmationModalDialog({window: window, 
                         title: "Save Settlement Amount", 
                         callback: "SaveCustomCalc_Yes", 
                         message: "Are you sure you want to save the settlement amount?"});
        return false;
    }
    
    function SaveCustomCalc_Yes(){
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var settlementamount = $('#<%= hdnSettlementAmount.ClientID %>').val();
        var dArray = {pasessionid: pasessionid, settlementamount: settlementamount};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/UpdatePACalcSettlementAmount") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                             clearMsg();
                            $('#<%= divAdd.ClientID %>').hide();
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Success", type: "success" ,width: 300, height: 30});},1);
                            refresh();
                            break;
                        case "error":
                            //writeValidationMsg(response.d.message,"error"); 
                            setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
    function ValidateCustomCalc(fn){
        var pasessionid = $('#<%=hdnPASessionID.clientID %>').val();
        var settlementamount = $('#<%= hdnSettlementAmount.ClientID %>').val();
        var dArray = {pasessionid: pasessionid, settlementamount: settlementamount};
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= ResolveUrl("~/services/LexxwareService.asmx/ValidatePACalcCustom") %>',
            data: JSON.stringify(dArray),
            dataType: "json",
            async: true,
            success: function(response) {
                switch (response.d.status)
                    {
                        case "success":
                            clearMsg();
                            $('#<%= divAdd.ClientID %>').hide();
                            if (fn){
                                fn();
                            }
                            break;
                        case "error":
                            writeMsg(response.d.message,"error"); 
                            //setTimeout(function(){AlertModal({message: response.d.message, title: "Error", type: "error" ,width: 300, height: 30});},1);
                            break;
                        default:
                            break;
                    }
            },
            error: function(response) {
                alert(response.responseText);
            }
        });
        
        return false;
    }
    
</script>

<div id="divControl" runat="server" style="padding: 5px;">
    <div id="divtoolbar" class="ui-widget-header ui-corner-all" >
        <table style="height: 35px" cellspacing="0" >
            <tr>
                <td id="tdNewPlan" runat="server">
                    <asp:LinkButton ID="lnkNewPlan" runat="server" CssClass="lnk" Style="margin: 5px;
                        font-weight: bold; white-space: nowrap;" OnClientClick="return newPlanSession();" ForeColor="White" ToolTip="Create Plan">
                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/16x16_note_add.png" ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
                <td id="tdDeletePlan" runat="server">
                    <asp:LinkButton ID="lnkDeletePlan" runat="server" CssClass="lnk" OnClientClick="return DeletePlan();"
                        Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White" ToolTip="Delete Plan">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/16x16_transaction_void.png"
                            ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
                <td id="tdAddNew" runat="server">
                    <asp:LinkButton ID="lnkAddNew" runat="server" OnClientClick="return AddNew();" CssClass="lnk"
                        Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White" ToolTip="Add a Payment">
                        <asp:Image ID="imgFolder" runat="server" ImageUrl="~/images/16x16_adddep.png"
                            ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
                <td id="tdSaveCustom" runat="server">
                    <asp:LinkButton ID="lnkSaveCustom" runat="server" OnClientClick="return SaveCustomCalc();" CssClass="lnk"
                        Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White" ToolTip="Save Settlement Amount">
                        <asp:Image ID="Image5" runat="server" ImageUrl="~/images/16x16_save.png"
                            ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
                 <td id="tdDeleteAllPmts" runat="server">
                    <asp:LinkButton ID="lnkDeleteAll" runat="server" CssClass="lnk" OnClientClick="return DeleteAllCustomPmts();"
                        Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White" ToolTip="Delete All Payments">
                        <asp:Image ID="Image3" runat="server" ImageUrl="~/images/16x16_reason.png"
                            ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
                <td id="tdRemoveCustom" runat="server">
                    <asp:LinkButton ID="lnkRemoveCustom" runat="server" CssClass="lnk" OnClientClick="return RemoveCustom();"
                        Style="margin: 5px; font-weight: bold; white-space: nowrap;" ForeColor="White" ToolTip="Remove Customization">
                        <asp:Image ID="Image4" runat="server" ImageUrl="~/images/16x16_cancel2.png"
                            ImageAlign="AbsMiddle" />
                    </asp:LinkButton>
                </td>
            </tr>
        </table>
    </div>
    <div id="divResults" runat="server">
    </div>
    <div id="divNoPlan" class="info" runat="server" >
        There is no payment calculation plan to display
    </div>
    <div id="dvCustomInfo" runat="server">
            <table>
                <tr>
                    <td class="sumHdr">Settlement Amount:</td>
                    <td class="sumValue"><asp:Label ID="lblCustomSettAmount" runat="server" EnableViewState="true"/></td>
                    <td class="sumHdr">Amount Used:</td>
                    <td class="sumValue"><asp:Label ID="lblCustomAmountUsed" runat="server"/></td>
                    <td rowspan="2"><div class="imgsettinfo"></div></td> 
                </tr>
                <tr>
                    <td class="sumHdr"># of Payments:</td>
                    <td class="sumValue"><asp:Label ID="lblCustomNumberOfPmts" runat="server"/></td>
                    <td class="sumHdr">Amount left:</td>
                    <td class="sumValue"><asp:Label ID="lblCustomAmountLeft" runat="server"/></td>
                </tr>
            </table>
        </div>
    <div id="divGrid" runat="server" style="width: 100%; padding: 5px;">
        <div class="dvCustomContainer">
            <asp:GridView ID="gvCustomPADetails" runat="server" AllowPaging="False" AllowSorting="False"
                AutoGenerateColumns="False" DataKeyNames="padetailid"
                CssClass="entry" CellPadding="4" GridLines="None" ShowFooter="false" Width="100%"  >
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" CssClass="lnk" runat="server" Text="Edit" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="20" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="20" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="paDetailId" HeaderText="paDetailId" InsertVisible="False"
                        ReadOnly="True" SortExpression="PmtScheduleID" Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PaymentNumber" HeaderText="#" InsertVisible="False"
                        ReadOnly="True" SortExpression="PaymentNumber" >
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" Width="20"/>
                        <ItemStyle CssClass="listItem" HorizontalAlign="Right" Width="20" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PaymentDueDate" HeaderText="Scheduled For" SortExpression="PaymentDueDate" DataFormatString="{0:MM/dd/yyyy}">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="75" />
                        <ItemStyle CssClass="listItem gvcustompmtdate" HorizontalAlign="Left" Width="75" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" SortExpression="PaymentAmount"
                        DataFormatString="{0:c2}">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" Width="75" Wrap="false" />
                        <ItemStyle CssClass="listItem gvcustompmtamount" HorizontalAlign="Right" Width="75" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                        DataFormatString="{0:MM/dd/yyyy}" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" SortExpression="CreatedBy"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastModified" HeaderText="LastModified" SortExpression="LastModified"
                        DataFormatString="{0:MM/dd/yyyy}" Visible="False">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModifiedBy" SortExpression="LastModifiedBy"
                        Visible="false">
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:TemplateField>
                        <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="150"/>
                        <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="150" />
                        <ItemTemplate>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <EmptyDataTemplate>
                    <div class="info">
                        There are no custom payments to display.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <div id="updateDiv" style="display: none; height: 40px; width: 40px">
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
        </div>
    </div>
    <div id="divNewPlan" style="width: 100%; border: solid 1px #70A8D1; background-color: #F0F5FB;
        padding: 5px; display: none;" runat="server">
        <div id="dvValMsg" style="display: none;"></div>
        <div class="box">
            <table width="100%">
                <tr>
                    <td>Start Date: <asp:TextBox ID="txtStartDate" Width="60px" runat="server" /></td>
                    <td style="text-align: right;"><span class="imgsettinfo" ></span></td>
                </tr>
            </table>
        </div>
        <fieldset> 
            <div class="box"> 
                <div>
                    <asp:DropDownList ID="ddlPlanType" runat="server" CssClass="ddlPmt" >
                        <asp:ListItem Selected="True" Value="0">Select Payment Plan</asp:ListItem>
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
            <div id="dvPmtResults" class="pmtResults">
            </div>
        <hr />
        <asp:LinkButton ID="lnkCreatePlan" runat="server" Text="Customize Plan" CssClass="lnk"
            Style="margin: 5px;" OnClientClick="return CreateCustomPlan();" />&nbsp;<span style="color: black !important;">|</span>&nbsp;
        <asp:LinkButton ID="lnkSavePlan" runat="server" Text="Save" CssClass="lnk" OnClientClick="return SavePlan();" Style="margin: 5px;"/>&nbsp;<span style="color: black !important;">|</span>&nbsp;
        <asp:LinkButton ID="lnkCancelPlan" runat="server" Text="Cancel" CssClass="lnk" OnClientClick="return cancelDefaultMode();" Style="margin: 5px;"/>
        <asp:LinkButton ID="lnkRestorePlan" runat="server" Text="Undo" CssClass="lnk" OnClientClick="return restoreDefaultMode();" Style="margin: 5px;"/>&nbsp;<span style="color: black !important;">|</span>&nbsp;
        <asp:LinkButton ID="lnkResetPlan" runat="server" Text="Reset" CssClass="lnk" OnClientClick="return resetPlanSession();" Style="margin: 5px;"/>
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
                        OnClientClick="return DeleteCustomPayment();"
                        Text="Delete" Style="position: relative; float: right;
                        margin: 2px;" />
                    <asp:LinkButton ID="lnkAdd" Style="position: relative; float: right; margin: 2px;"
                        runat="server" Text="Add" CssClass="lnk" OnClientClick="return SaveCustomPayment();"
                        />
                    <asp:LinkButton ID="lnkSave" runat="server" Text="Save" Style="position: relative;
                        float: right; margin: 2px; display: none;" CssClass="lnk" OnClientClick="return SaveCustomPayment();"
                         />
                </td>
            </tr>
        </table>
    </div>
    <div id="divPopupInfo" runat="server" title="Show Info" class="dvPopupInfo"  >
        <fieldset>
            <div>
                <label for="<%= lblPACreated.ClientID%>">Created on:</label>
                <asp:Label ID="lblPACreated" runat="server"></asp:Label>
            </div>
            <div>
                <label for="<%= lblPACreatedBy.ClientID%>">Created by:</label>
                <asp:Label ID="lblPACreatedBy" runat="server"></asp:Label>
            </div>
            <div>
                <label for="<%= lblPAModified.ClientID%>">Last Modified on:</label>
                <asp:Label ID="lblPAModified" runat="server"></asp:Label>
            </div>
            <div>
                <label for="<%= lblPAModifiedBy.ClientID%>">Last Modified by:</label>
                <asp:Label ID="lblPAModifiedBy" runat="server"></asp:Label>
            </div>
        </fieldset>
    </div>
    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
</div>
<asp:HiddenField ID="hdnPADetailID" runat="server" />
<asp:HiddenField ID="hdnClientID" runat="server" />
<asp:HiddenField ID="hdnSettlementID" runat="server" />
<asp:HiddenField ID="hdnAccountID" runat="server" />
<asp:HiddenField ID="hdnSettlementAmount" runat="server" />
<asp:HiddenField ID="hdnPASessionId" runat="server" />
<asp:HiddenField ID="hdnMode" runat="server" />
<asp:HiddenField ID="hdnOldMode" runat="server" />
<asp:HiddenField ID="hdnOldSessionId" runat="server" />
