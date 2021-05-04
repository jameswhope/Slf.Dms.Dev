<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CalculatorControl.ascx.vb"
    Inherits="negotiation_webparts_CalculatorControl" %>

<style type="text/css">
    .headerCell
    {
        text-align: right;
        font-family: Tahoma;
        font-weight: bold;
    }
    .textCell
    {
        text-align: right;
    }
    .calcCell
    {
        text-align: right;
        width: 100px;
    }
    INPUT
    {
        border: none;
        font-family: Tahoma;
    }
    .nowrapFieldSet
    {
        display: inline-block;
    }
    .AcceptModalBackground
    {
        background-color: #808080;
        filter: alpha(opacity=70);
        opacity: 0.7;
        z-index: 10000;
    }
    .AcceptModalPopup
    {
        background-color: #F5FAFD;
        filter: progid:DXImageTransform.Microsoft.dropShadow(color=black,offX=5,offY=5, positive=true);
        border-width: 1px;
        border-style: ridge;
        border-color: Gray;
        padding: 0px;
        position: absolute;
        width: 600px;
    }
</style>

<script type="text/javascript">
     

    function DueDate_SelectionChanged(sender, args) {
        var yesterDay = new Date()
        yesterDay.setDate(yesterDay.getDate() - 1)
        if (sender._selectedDate < yesterDay) {
            alert("You cannot select a day earlier than today!");
            sender._selectedDate = new Date();
            // set the date back to the current date
            var txtDueDate = document.getElementById('<%=txtDueDate.ClientID %>');
            txtDueDate.value = sender._selectedDate.format(sender._format);
            //sender._textbox.set_Value(sender._selectedDate.format(sender._format))
        }
        else {
            var hdnDueDate = document.getElementById('<%=hdnDueDate.ClientID %>');
            var txtDueDate = document.getElementById('<%=txtDueDate.ClientID %>');

            hdnDueDate.value = txtDueDate.value;
        }
    }
    function ConvertToCurrency(num) {
        return new Number(num).localeFormat('c');
    }
    
    function GetPADownPayment(){
        var amt = "0"
        try{
            var mode = $('input[id$=hdnMode]');
       
            switch (mode.val()) {
                case "0":
                    break;
                case "1":
                    amt = $("#dvPmtResults").find(".firstpayment").first().text();
                    break;
                case "2":
                    amt = $("table[id$='gvCustomPADetails']").find(".gvcustompmtamount").first().text();
                    break;
                default:
                    break;
            }
        
        } catch(e){
        
        }
        
        
        return ((amt)?amt:"0");
    }

    function updateDataByPercent(ctl) {
        //use downpayment
        var chkPA = $("#<%= chkUsePArrangement.clientid%>");
        var usedownpayment = (chkPA && chkPA.prop('checked') && chkPA.closest("td").is(':visible'));
        var DownPayment = $("#<%= lblPADownPayment.ClientId%>");
     
        //debt amt
        var CurrentDebtBal = document.getElementById('<%=lblCurrentBalance.ClientID %>');
        //sett amt
        var SettAmt = document.getElementById('<%=txtSettlementAmt.ClientID %>');
        //sett cost
        var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
        //sett saving
        var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');

        //fee fields
        var regBal = document.getElementById('<%=lblAvailSDABal.ClientID %>');
        var pfoBal = document.getElementById('<%=lblPFOBal.ClientID %>');
        var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');
        var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
        var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
        var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');

        //percent of creditor acct bal
        var perValue = parseFloat(ctl.value);
        if (perValue.toString == '0' || isNaN(perValue) == true) {
            SettSavings.value = ConvertToCurrency(0);
            SettCost.value = ConvertToCurrency(0);
            SettAmt.value = ConvertToCurrency(0);
            return;
        }

        //get bal owed to creditor
        var CreditorAcctBal = parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$", ""));

        //amt creditor will settle acct for
        var SettlementAmt = GetAmount(CreditorAcctBal, perValue)
        SettAmt.value = String.format("{0:N2}", SettlementAmt);

        //amt client saved 
        var SettlementSavings = CreditorAcctBal - SettlementAmt
        SettSavings.innerText = ConvertToCurrency(SettlementSavings);

        //update fee calcs
        //get avail register bal
        var tempRegBal = regBal.innerText.replace(/,/g, "").replace("$", "");
        if (isNaN(parseFloat(tempRegBal)) == true) {
            var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
            RegisterBalance = RegisterBalance * -1;
        } else {
            var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$", ""));
        }

        var pfoBalance = parseFloat(pfoBal.innerText.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
        RegisterBalance = RegisterBalance - pfoBalance; // Factor in PFO bal

        //sett fee        
        var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
        var tmpSettlSavings = CalculateTempSavings(SettlementAmt, SettlementSavings);
        var balance = GetDebtBalance();
        var companyid = document.getElementById('<%=hdnCompanyId.ClientID %>').value;
        var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$", "")) / 100 * tmpSettlSavings;
        if (companyid === '10' || companyid === '11') {
            var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$", "")) / 100 * balance;
        }       
        SettFee.innerText = ConvertToCurrency(SettFeeAmt)


        //sett fee credit
        var SettFeeCredit = document.getElementById('<%=lblSettlementFeeCredit.ClientID %>');
        var SettFeeCreditValue = parseFloat(SettFeeCredit.value.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
        
        //downpayment
        if (usedownpayment){
            DownPayment.closest("tr").show();
            var downpmt = GetPADownPayment();
            downpmt = parseFloat(downpmt.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
            DownPayment.val(ConvertToCurrency(downpmt));
            DownPayment.closest("tr").show();
            SettlementAmt = downpmt;
        } else {
            DownPayment.closest("tr").hide();
        }

        //od fee
        var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
        var odFeeValue = parseFloat(odFee.value.replace(/,/g, "").replace("$", ""))
        if (SettFeeAmt > SettFeeCreditValue) {
            var sCost = (SettFeeAmt - SettFeeCreditValue) + odFeeValue;
        } else {
            var sCost = 0 + odFeeValue;
        }
        SettCost.value = ConvertToCurrency(sCost);

        var dBal;

        if (parseFloat(RegisterBalance) < 0)
            dBal = -parseFloat(SettlementAmt);
        else
            dBal = parseFloat(RegisterBalance) - parseFloat(SettlementAmt);

        if (dBal > sCost) {
            SettFeeAmtAvail.value = ConvertToCurrency(sCost);
            SettFeeAmtOwed.value = ConvertToCurrency('0');
        } else {
            SettFeeAmtAvail.value = ConvertToCurrency(dBal);
            var owed = sCost - dBal
            SettFeeAmtOwed.value = ConvertToCurrency(owed);
        }

        SettFeeAmtPaid.value = SettFeeAmtAvail.value
    }

    function CalculateTempSavings(SettlementAmt, SettlementSavings){
        //sett fee        
        var tmpSettlSavings = SettlementSavings;
        if (document.getElementById('<%=lblUseOriginal.ClientID %>').innerHTML) 
        {
            //Use original debt value
            if (document.getElementById('<%=hdnVerifiedAmount.ClientID %>').value) 
               tmpSettlSavings = parseFloat(document.getElementById('<%=hdnVerifiedAmount.ClientID %>').value) - SettlementAmt;
            else 
               tmpSettlSavings = parseFloat(document.getElementById('<%=hdnOriginalBalance.ClientID %>').value) - SettlementAmt;
        }
        return tmpSettlSavings;
    }

    function remove(s, t) {
        /*
        **  Remove all occurrences of a token in a string
        **    s  string to be processed
        **    t  token to be removed
        **  returns new string
        */
        i = s.indexOf(t);
        r = "";
        if (i == -1) return s;
        r += s.substring(0, i) + remove(s.substring(i + t.length), t);
        return r;
    }
    
    function GetDebtBalance(){
        //get balance to use       

        if (document.getElementById('<%=hdnVerifiedAmount.ClientID %>').value) 
               {return parseFloat(document.getElementById('<%=hdnVerifiedAmount.ClientID %>').value);}
        else 
               {return parseFloat(document.getElementById('<%=hdnOriginalBalance.ClientID %>').value);}
    }
    
    function updateDataByAmount(ctl) {
        //use downpayment
        var chkPA = $("#<%= chkUsePArrangement.clientid%>");
        var usedownpayment = (chkPA && chkPA.prop('checked') && chkPA.closest("td").is(':visible'));
        var DownPayment = $("#<%= lblPADownPayment.ClientId%>");
     

        ctl.value = ctl.value.replace(/\$|\,/g, '')

        var CurrentDebtBal = document.getElementById('<%=lblCurrentBalance.ClientID %>');
        var SettPercent = document.getElementById('<%=txtSettlementPercent.ClientID %>');
        var SettCost = document.getElementById('<%=lblSettlementCost.ClientID %>');
        var SettSavings = document.getElementById('<%=lblSettlementSavings.ClientID %>');
        var AmtValue = parseFloat(ctl.value);

        if (AmtValue.toString == '0' || isNaN(AmtValue) == true) {
            SettSavings.value = ConvertToCurrency(0);
            SettCost.value = ConvertToCurrency(0);
            return;
        }

        var perVal = GetPercent(AmtValue, parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$", "")));
        SettPercent.value = String.format("{0:N2}", perVal);

        var SettValue = parseFloat(CurrentDebtBal.innerText.replace(/,/g, "").replace("$", ""));

        var savingValue = SettValue - AmtValue;
        SettSavings.value = ConvertToCurrency(savingValue);

        //get avail register bal
        var regBal = document.getElementById('<%=lblAvailSDABal.ClientID %>');
        var pfoBal = document.getElementById('<%=lblPFOBal.ClientID %>');
        var tempRegBal = regBal.innerText.replace(/,/g, "").replace("$", "");
        if (isNaN(parseFloat(tempRegBal)) == true) {
            var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
            RegisterBalance = RegisterBalance * -1;
        } else {
            var RegisterBalance = parseFloat(regBal.innerText.replace(/,/g, "").replace("$", ""));
        }

        var pfoBalance = parseFloat(pfoBal.innerText.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));
        RegisterBalance = RegisterBalance - pfoBalance; // Factor in PFO bal

        var SettFeePercentage = document.getElementById('<%=lblSettlementFeePercentage.ClientID %>');

        //settlement fee
        var SettFee = document.getElementById('<%=lblSettlementFee.ClientID %>');
        var tmpSettlSavings = CalculateTempSavings(AmtValue, savingValue);
        var balance = GetDebtBalance();
        var companyid = document.getElementById('<%=hdnCompanyId.ClientID %>').value;
        var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$", "")) / 100 * tmpSettlSavings;
        if (companyid === '10' || companyid === '11') {
            var SettFeeAmt = parseFloat(SettFeePercentage.value.replace(/,/g, "").replace("$", "")) / 100 * balance;
        }       
        SettFee.innerText = ConvertToCurrency(SettFeeAmt)

        //sett fee credit
        var SettFeeCredit = document.getElementById('<%=lblSettlementFeeCredit.ClientID %>');
        var SettFeeCreditValue = parseFloat(SettFeeCredit.value.replace(/,/g, "").replace("$", "").replace("(", "").replace(")", ""));

        //downpayment
        if (usedownpayment){
            DownPayment.val(GetPADownPayment());
            DownPayment.closest("tr").show();
        } else {
            DownPayment.closest("tr").hide();
        }

        //Me.Settlement_Cost = Me.Settlement_Fee + Me.Client_OvernightDeliveryFee
        var odFee = document.getElementById('<%=lblOvernightDeliveryCost.ClientID %>');
        var odFeeValue = parseFloat(odFee.value.replace(/,/g, "").replace("$", ""))
        if (SettFeeAmt > SettFeeCreditValue) {
            var sCost = (SettFeeAmt - SettFeeCreditValue) + odFeeValue;
        } else {
            var sCost = 0 + odFeeValue;
        }

        SettCost.value = ConvertToCurrency(sCost);

        var SettFeeAmtAvail = document.getElementById('<%=lblSettlementFee_AmtAvailable.ClientID %>');
        var SettFeeAmtPaid = document.getElementById('<%=lblSettlementFee_AmtBeingPaid.ClientID %>');
        var SettFeeAmtOwed = document.getElementById('<%=lblSettlementFee_AmtStillOwed.ClientID %>');

        var dBal;

        if (RegisterBalance < 0)
            dBal = -AmtValue;
        else
            dBal = RegisterBalance - AmtValue;

        if (dBal > sCost) {
            SettFeeAmtAvail.value = ConvertToCurrency(sCost);
            SettFeeAmtOwed.value = ConvertToCurrency('0');
        } else {
            SettFeeAmtAvail.value = ConvertToCurrency(dBal);
            var owed = sCost - dBal
            SettFeeAmtOwed.value = ConvertToCurrency(owed);
        }

        SettFeeAmtPaid.value = SettFeeAmtAvail.value

    }
    function GetAmount(total, percent) {
        var percentAMT = total * (percent / 100)
        return percentAMT
    }
    function GetPercent(amt, total) {
        var percentAmt = (amt / total) * 100
        return percentAmt
    }
    function PercentUpDown(n) {
        var txtSettlementPercent = document.getElementById('<%=txtSettlementPercent.ClientID %>');
        var pct = parseFloat(txtSettlementPercent.value);
        txtSettlementPercent.value = (pct + n);
        updateDataByPercent(txtSettlementPercent);
    }

    function CheckRestrictive(chkBox) {

        var div = document.getElementById('<%= divConversationDate.ClientID %>');
        var hdnR = document.getElementById('<%=hdnRestrictiveEndorsement.ClientID %>');
        if (chkBox.checked == true) {
            div.style.display = 'block';
            hdnR.value = '1';

            //no check by phone
            var hdnD = document.getElementById('<%=hdnDeliveryMethod.ClientID %>');
            if (hdnD.value == 'chkbytel' || hdnD.value == 'chkbyemail') {
                alert('Restrictive Endorsement delivery method can only be check! Please change delivery method to Check.');
                div.style.display = 'none';
                hdnR.value = '0';
                hdnD.value = 'chk';
                chkBox.checked = false;
            }
        } else {
            div.style.display = 'none';
            hdnR.value = '0';
        }
    }
    function DeliveryMethodCheck(theRadioButton) {
        var fldAdd = document.getElementById("fldAddress");
        var fldEmail = document.getElementById("fldEmailAddress");
        var fldContact = document.getElementById("fldContactNumber");
        var txt = document.getElementById('<%=txtDeliveryAmount.ClientID %>');
        var hdn = document.getElementById('<%=hdnDeliveryMethod.ClientID %>');
        hdn.value = theRadioButton.value;
        var hdnR = document.getElementById('<%=hdnRestrictiveEndorsement.ClientID %>');

        switch (theRadioButton.value) {
            case 'chk':
                fldContact.style.display = "none";
                fldAdd.style.display = "block";
                fldEmail.style.display = "none";
                txt.setAttribute('readOnly', 'readonly');
                txt.value = document.getElementById('<%=hdnDefaultOvernightAmount.ClientId %>').value;
                break;
            case 'chkbyemail':
                if (hdnR.value == 1) {
                    alert('Check by Email is not allowed for Restrictive Endorsements!');
                    hdn.value = '';
                    var copt = document.getElementById('<%=rblDelivery.clientid %>_0');
                    copt.checked = true;
                    return false;
                } else {
                    fldContact.style.display = "none";
                    fldEmail.style.display = "block";
                    fldAdd.style.display = "none";
                }
                txt.value = document.getElementById('<%=hdnDefaultOvernightAmount.ClientId %>').value;
                break;
            case 'chkbytel':
                if (hdnR.value == 1) {
                    alert('Check by Telephone is not allowed for Restrictive Endorsements!');
                    hdn.value = '';
                    var copt = document.getElementById('<%=rblDelivery.clientid %>_0');
                    copt.checked = true;
                    return false;
                } else {
                    fldContact.style.display = "block";
                    fldAdd.style.display = "none";
                    fldEmail.style.display = "none";
                }
                txt.value= "0.00" ;
                break;
            default:
                fldContact.style.display = "none";
                fldAdd.style.display = "none";
                fldEmail.style.display = "none";
                break;
        }
        return true;
    }
    function ClientStipulation(chkBox) {
        var hdn = document.getElementById('<%=hdnIsClientStipulation.ClientID %>');
        if (chkBox.checked == true) {
            hdn.value = '1';
        } else {
            hdn.value = '0';
        }
    }
    function PaymentArrangement(chkBox) {
        var hdn = document.getElementById('<%=hdnIsClientPaymentArrangement.ClientID %>');
        if (chkBox.checked == true) {
            hdn.value = '1';
        } else {
            hdn.value = '0';
        }
    }
    function submitOffer() {

        //get restictive endorsement fields
        var attTo = document.getElementById('<%= txtRestrictive_Attention.ClientID%>').value
        var addr = document.getElementById('<%= txtRestrictive_Address.ClientID%>').value
        var city = document.getElementById('<%= txtRestrictive_City.ClientID%>').value
        var state = document.getElementById('<%= ddlRestrictive_State.ClientID%>').value
        var zip = document.getElementById('<%= txtRestrictive_Zip.ClientID%>').value
        //assign to hidden field
        document.getElementById('<%= hdnRestrictive_Attention.ClientID%>').value = attTo;
        document.getElementById('<%= hdnRestrictive_Address.ClientID%>').value = addr;
        document.getElementById('<%= hdnRestrictive_City.ClientID%>').value = city;
        document.getElementById('<%= hdnRestrictive_State.ClientID%>').value = state;
        document.getElementById('<%= hdnRestrictive_Zip.ClientID%>').value = zip;

        //get delivery method fields
        var d_attTo = document.getElementById('<%= txtDelivery_Attention.ClientID%>').value
        var d_addr = document.getElementById('<%= txtDelivery_Address.ClientID%>').value
        var d_city = document.getElementById('<%= txtDelivery_City.ClientID%>').value
        var d_state = document.getElementById('<%= ddlDelivery_State.ClientID%>').value
        var d_zip = document.getElementById('<%= txtDelivery_Zip.ClientID%>').value
        var d_email = document.getElementById('<%= txtDelivery_EmailAddress.ClientID%>').value
        var d_number = document.getElementById('<%= txtDelivery_ContactNumber.ClientID%>').value
        //assign to hidden field
        document.getElementById('<%= hdnDelivery_Attention.ClientID%>').value = d_attTo;
        document.getElementById('<%= hdnDelivery_Address.ClientID%>').value = d_addr;
        document.getElementById('<%= hdnDelivery_City.ClientID%>').value = d_city;
        document.getElementById('<%= hdnDelivery_State.ClientID%>').value = d_state;
        document.getElementById('<%= hdnDelivery_Zip.ClientID%>').value = d_zip;
        document.getElementById('<%= hdnDelivery_EmailAddress.ClientID%>').value = d_email;
        document.getElementById('<%= hdnDelivery_ContactNumber.ClientID%>').value = d_number;

        var hdn = document.getElementById('<%=hdnDeliveryMethod.ClientID %>');

        switch (hdn.value) {
            case 'chk':
                if (d_attTo == '') {
                    alert('Payable To is required when delivery method is check!');
                    return false;
                }
                if (d_addr == '') {
                    alert('Address is required when delivery method is check!');
                    return false;
                }
                if (d_city == '') {
                    alert('City is required when delivery method is check!');
                    return false;
                }
                if (d_state == '') {
                    alert('state is required when delivery method is check!');
                    return false;
                }
                if (d_zip == '') {
                    alert('Zip is required when delivery method is check!');
                    return false;
                }
                break;
            case 'chkbytel':
                if (d_number == '' || d_number == '(___)___-____ x____') {
                    alert('Telephone number is required when delivery method is check by telephone!');
                    return false;
                }
                break;
            case 'chkbyemail':
                if (d_email == '') {
                    alert('Email is required when delivery method is check by email!');
                    return false;
                }else{
                    var reg = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
                    if(reg.test(d_email) == false) {
                        alert('Invalid Email Address');
                        return false;
                    } 
                    if (d_email.indexOf('www.')!=-1){
                        alert('This appears to be a web address and not an email address.  Please check the email address!');
                        return false;                    
                    }
                }
                break;
            default:
                alert('Delivery Method is required!');
                return false;
                break;
        }
    }
    function saveTextBoxToHidden(saveTextBx) {
        //assign text value to corresponding hidden field
        var txtCity = null;
        var cboStateID = null;
        var nId = saveTextBx.id.replace('txt', 'hdn');
        var hdn = document.getElementById(nId);
        hdn.value = saveTextBx.value;
        
         if (nId.indexOf('Zip') != -1){
            var zType = nId;
            zType = nId.replace('_Zip', '');
            var ztypes = zType.split("_");
            zType = ztypes[ztypes.length-1];
            zType = zType.replace('hdn', '')
            switch (zType) {
                case "Delivery":
                    txtCity = document.getElementById('<%= txtDelivery_City.ClientID %>');
                    cboStateID = document.getElementById('<%= ddlDelivery_State.ClientID %>');
                    break;
                case "Restrictive":
                    txtCity = document.getElementById('<%= txtRestrictive_City.ClientID %>');
                    cboStateID = document.getElementById('<%= ddlRestrictive_State.ClientID %>');
                    break;
                default:
                    break;
            }
            
            var xml = new ActiveXObject("Microsoft.XMLDOM");
            xml.async = false;
            xml.load("<%= ResolveUrl("~/util/citystatefinder.aspx?zip=") %>" + hdn.value);
            var address = xml.getElementsByTagName("address")[0];
            if (address != null && address.attributes.length > 0 && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan")
            {
	            if (address.attributes.getNamedItem("city") != null)
	            {
		            txtCity.value = address.attributes.getNamedItem("city").value;
	            }
	            if (cboStateID != null)
	            {
		            if (address.attributes.getNamedItem("stateabbreviation") != null) {
		                for (i = 0; i < cboStateID.options.length; i++) {
						    if (cboStateID.options[i].text == address.attributes.getNamedItem("stateabbreviation").value)
							    cboStateID.selectedIndex = i;
					    }
		            }
	            }
            }else {
                if(cboStateID.options[cboStateID.selectedIndex].text != "St. Kitts" && cboStateID.options[cboStateID.selectedIndex].text != "Hokkaido Japan") {         
                    txtCity.value = "";
                    cboStateID.selectedIndex = 0;
                }
            }
            
            
        }
    }
    function overwriteOffer(elem){
        var parent = elem.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
        var dvs = parent.getElementsByTagName('div');
        if (dvs.length > 0){
            for (i=0;i<=dvs.length-1;i++){
                var dName = dvs[i].id;
                if (dName.indexOf('pnlDueDate') != -1){
                    dvs[i].style.display = 'block';
                }
                if (dName.indexOf('pnlWarning') != -1){
                    dvs[i].style.display = 'none';
                } 
            }
        }   
         var sID = document.getElementById('<%= hdnOverwriteSettlementID.ClientID%>').value;
        PageMethods.PM_sendOverwriteNotice(sID,<%=UserID %>);             
        return false;
    } 
       function closeAcceptPopup() {
        var modalPopupBehavior = $find('mpeAcceptBehavior');
        modalPopupBehavior.hide();
        return false;
    } 
    
    function AcceptOfferJS(pasessionid, payments){
        $("#<%= hdnPACalculatorId.ClientId %>").val(pasessionid);
        if (payments){
            $("#<%= hdnPACalculatorJson.ClientId %>").val(JSON.stringify(payments.payments));
        } 
        else {
            $("#<%= hdnPACalculatorJson.ClientId %>").val("");
        }
        <%= Page.ClientScript.GetPostBackEventReference(ibtnAccept, nothing) %>;
    }
</script>

<asp:UpdatePanel ID="upDefault" runat="server">
    <ContentTemplate>
        <table id="table_calc" style="font-size: 8pt; height: 200px;" cellpadding="0" cellspacing="0"
            border="0">
            <tr>
                <td style="vertical-align: bottom; border-right: solid 1px #A1D0E0; border-bottom: solid 1px #A1D0E0;">
                    <table class="box">
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #DCEDF2; font-weight: normal">
                                <asp:Label Text="PFO Balance:" ID="Label2" runat="server" />
                            </td>
                            <td class="textCell" style="background-color: #DCEDF2">
                                <asp:Label ID="lblPFOBal" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #DCEDF2; font-weight: normal">
                                SDA Balance:
                            </td>
                            <td class="textCell" style="background-color: #DCEDF2">
                                <asp:Label ID="lblSDABal" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #DCEDF2; font-weight: normal">
                                Bank Reserve:
                            </td>
                            <td class="textCell" style="background-color: #DCEDF2">
                                <asp:Label ID="lblReserve" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #DCEDF2; font-weight: normal">
                                Funds On Hold:
                            </td>
                            <td class="textCell" style="background-color: #DCEDF2">
                                <asp:Label ID="lblFundsOnHold" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #DCEDF2">
                                Avail SDA Bal:
                            </td>
                            <td class="textCell" style="background-color: #DCEDF2">
                                <asp:Label ID="lblAvailSDABal" runat="server" Font-Bold="true" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #E3CF57">
                                <asp:Label Text="Account Bal:" ID="Label4" runat="server" />
                            </td>
                            <td class="textCell" style="background-color: #E3CF57">
                                <asp:Label ID="lblCurrentBalance" runat="server" Font-Bold="true" />
                                <asp:HiddenField ID="hdnOriginalBalance" runat="server" />
                                <asp:HiddenField ID="hdnVerifiedAmount" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #CDC8B1; font-weight: normal">
                                <asp:Label Text="Next Dep Date:" ID="Label5" runat="server" />
                            </td>
                            <td class="textCell" style="white-space: nowrap; background-color: #CDC8B1">
                                <asp:Label ID="lblNextDepDate" runat="server" Text="" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headerCell" style="white-space: nowrap; background-color: #CDC8B1; font-weight: normal">
                                <asp:Label Text="Next Dep Amt:" ID="Label7" runat="server" />
                            </td>
                            <td class="textCell" style="white-space: nowrap; background-color: #CDC8B1">
                                <asp:Label ID="lblNextDepAmt" runat="server" Text="" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="border-bottom: solid 1px #A1D0E0;" valign="bottom">
                    <table class="box">
                        <tr class="headerCell">
                            <td>
                                Savings:
                            </td>
                            <td>
                                <asp:TextBox Width="55px" ID="lblSettlementSavings" runat="server" CssClass="label cur"
                                    Font-Bold="true"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="textCell">
                            <td style="background-color: #DCEDF2">
                                <asp:TextBox Style="display: none; border: none; text-align: right; width: 15px"
                                    Enabled="false" ID="lblSettlementFeePercentage" runat="server"></asp:TextBox>Settlement
                                Fee:
                                 
                            </td>
                            <td style="background-color: #DCEDF2">
                                <asp:Label ID="lblUseOriginal" runat="server" style="color:Red; cursor: pointer;"></asp:Label>
                                <asp:TextBox ID="lblSettlementFee" Width="55px" runat="server" CssClass="label cur"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="textCell">
                            <td nowrap="nowrap" style="background-color: #DCEDF2">
                                Settlement Fee Credit:
                            </td>
                            <td style="background-color: #DCEDF2">
                                <asp:TextBox ID="lblSettlementFeeCredit" runat="server" CssClass="label cur" Width="55px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="textCell">
                            <td nowrap="nowrap" style="background-color: #DCEDF2">
                                Overnight Delivery Cost:
                            </td>
                            <td style="background-color: #DCEDF2">
                                <asp:TextBox ID="lblOvernightDeliveryCost" Width="55px" runat="server" CssClass="label cur"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="headerCell">
                            <td style="background-color: #DCEDF2">
                                Settlement Cost:
                            </td>
                            <td style="background-color: #DCEDF2">
                                <asp:TextBox ID="lblSettlementCost" runat="server" Width="55px" CssClass="label cur"
                                    Font-Bold="true"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="headerCell" style="display: none;">
                            <td style="background-color: #DCEDF2">
                                Down Payment:
                            </td>
                            <td style="background-color: #DCEDF2">
                                <asp:TextBox ID="lblPADownPayment" runat="server" Width="55px" CssClass="label cur"
                                    Font-Bold="true"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="textCell">
                            <td>
                                Amount Available:
                            </td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtAvailable" Width="55px" runat="server" CssClass="label cur"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="textCell">
                            <td>
                                Amount Being Paid:
                            </td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtBeingPaid" Width="55px" runat="server" CssClass="label cur"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="headerCell">
                            <td>
                                Amount Still Owed:
                            </td>
                            <td>
                                <asp:TextBox ID="lblSettlementFee_AmtStillOwed" Width="55px" runat="server" CssClass="label cur"
                                    Font-Bold="true"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table class="box" style="width: 100%;">
                        <tr>
                            <td>
                                <asp:RadioButtonList ID="radDirection" runat="server" CssClass="label" Font-Bold="true"
                                    Font-Names="tahoma" RepeatDirection="Horizontal" RepeatLayout="Table" TextAlign="right">
                                    <asp:ListItem Selected="True" Value="Received">Offer received</asp:ListItem>
                                    <asp:ListItem Value="Made">Offer made</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            
                            <td align="right" style="height: 22px;">
                                <asp:ImageButton ID="ibtnAccept" runat="server" ImageUrl="~/negotiation/images/accept_off.png"
                                    OnClick="ibtnAccept_Click" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);"
                                    ImageAlign="AbsMiddle" />
                                <asp:ImageButton ID="ibtnReject" runat="server" ImageUrl="~/negotiation/images/reject_off.png"
                                    OnClick="ibtnReject_Click" onmouseout="SwapImage(this);" onmouseover="SwapImage(this);"
                                    ImageAlign="AbsMiddle" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 22px;">
                                Settlement:
                                <asp:TextBox ID="txtSettlementPercent" runat="server" AutoPostBack="false" Enabled="true"
                                    MaxLength="5" onkeyup="javascript:updateDataByPercent(this);" Width="25px" Wrap="False"
                                    CssClass="entry2">0</asp:TextBox>%
                                <img runat="server" alt="Down" src="~/negotiation/images/droparrow_off.png" onmouseout="SwapImage(this);"
                                    onmouseover="SwapImage(this);" onclick="PercentUpDown(-1);" align="absmiddle" />
                                <img runat="server" alt="Up" src="~/negotiation/images/uparrow_off.png" onmouseout="SwapImage(this);"
                                    onmouseover="SwapImage(this);" onclick="PercentUpDown(1);" align="absmiddle" />
                                $<asp:TextBox ID="txtSettlementAmt" runat="server" AutoPostBack="false" CssClass="entry2"
                                    onkeyup="javascript:updateDataByAmount(this);" Width="45px" Wrap="False">0.00</asp:TextBox>
                            </td>
                            <td id="tdChkPA" style="text-align: right;" runat="server">
                                <input type="checkbox" ID="chkUsePArrangement" runat="server"  /><label for="<%= chkUsePArrangement.clientid%>">Payment Plan is OFF</label>  
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:Button ID="btnDummy" runat="server" Style="display: none;" />
        <ajaxToolkit:ModalPopupExtender ID="mpeAccept" BehaviorID="mpeAcceptBehavior" runat="server"
            BackgroundCssClass="AcceptModalBackground" PopupControlID="pnlAccept" PopupDragHandleControlID="pnlDrag"
            TargetControlID="btnDummy" Y="20">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Panel ID="pnlAccept" runat="server" CssClass="AcceptModalPopup" Style="display: none">
            <asp:Panel ID="pnlDrag" runat="server" Style="display: block;" CssClass="PanelDragHeader"
                Width="100%">
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr class="headerstyle">
                        <td align="left" style="padding-left: 10px;">
                            <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Accept Offer" />
                        </td>
                        <td align="right" style="padding-right: 5px;">
                            <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="$find('mpeAcceptBehavior').hide();return false;"
                                ImageUrl="~/images/16x16_close.png" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlDueDate" runat="server" Style="text-align: left; display: block;
                vertical-align: top;" CssClass="entry2">
                <div class="entry2" style="padding: 10px;">
                    <div id="divAcceptMsg" runat="server" style="display: none;" />
                    <fieldset style="text-align: left; padding: 5px; vertical-align: middle;">
                        <asp:Label CssClass="entry2" runat="server" ID="lblDate" Text="Select Offer Due Date:" />
                        <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" ID="txtDueDate"
                            Width="150px" runat="server" />
                        <asp:ImageButton runat="Server" ID="ImgCalendar" ImageUrl="~/images/Calendar_scheduleHS.png"
                            AlternateText="Click to show calendar" ImageAlign="AbsMiddle" />
                        <ajaxToolkit:CalendarExtender ID="extDueDate" OnClientDateSelectionChanged="DueDate_SelectionChanged"
                            runat="server" TargetControlID="txtDueDate" PopupButtonID="imgCalendar" CssClass="MyCalendar" />
                    </fieldset>
                    <br />
                    <fieldset style="text-align: left; padding: 5px;">
                        <table class="entry" border="0">
                            <tr>
                                <td valign="middle">
                                    <asp:Label CssClass="entry2" runat="server" ID="Label17" Text="Delivery Method:" />
                                    <asp:RadioButtonList ID="rblDelivery" runat="server" CssClass="entry2" RepeatDirection="Horizontal"
                                        DataTextField="Name" DataValueField="Value" DataSourceID="dsDeliveryTypes" />
                                    <asp:SqlDataSource ID="dsDeliveryTypes" runat="server" ConnectionString='<%$ AppSettings:connectionstring %>'
                                        SelectCommandType="Text" SelectCommand="SELECT Name, Value FROM tblSettlements_DeliveryTypes">
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset id="fldCharge" style="display: block; text-align: left; padding: 5px;">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label19" Text="Delivery Charge Amount:" />
                                                </td>
                                                <td valign="middle">
                                                    $<asp:TextBox ID="txtDeliveryAmount" runat="server" Style="border: 1px solid darkblue;"
                                                        Width="50px" />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="txtDeliveryAmount_FilteredTextBoxExtender"
                                                        runat="server" TargetControlID="txtDeliveryAmount" FilterType="Custom" FilterMode="ValidChars"
                                                        ValidChars="0123456789.," />
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <fieldset id="fldAddress" style="display: none; padding: 5px;">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label20" Text="Overnight Delivery Address:" />
                                        <table class="entry2" border="0">
                                            <tr>
                                                <td align="right" style="width: 100px;">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label11" Text="Payable To:" />
                                                </td>
                                                <td colspan="5" align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry" ID="txtDelivery_Attention"
                                                        runat="server" onblur="saveTextBoxToHidden(this);" TabIndex="1" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label12" Text="Address:" />
                                                </td>
                                                <td colspan="5" align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" ID="txtDelivery_Address" runat="server"
                                                        CssClass="entry" onblur="saveTextBoxToHidden(this);" TabIndex="2" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label13" Text="City:" />
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" ID="txtDelivery_City" runat="server"
                                                        CssClass="entry2" Width="130px" onblur="saveTextBoxToHidden(this);" />
                                                </td>
                                                <td align="right">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label14" Text="State:" />
                                                </td>
                                                <td>
                                                    <asp:DropDownList Style="border: 1px solid darkblue;" ID="ddlDelivery_State" runat="server"
                                                        CssClass="entry2" onblur="saveTextBoxToHidden(this);" DataSourceID="dsStates"
                                                        DataTextField="abbreviation" DataValueField="abbreviation" Width="50" />
                                                    <asp:SqlDataSource ID="dsStates" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        SelectCommand="Select abbreviation from tblstate" SelectCommandType="Text" EnableCaching="true" />
                                                </td>
                                                <td align="right">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label15" Text="Zip:" />
                                                </td>
                                                <td>
                                                    <asp:TextBox Style="border: 1px solid darkblue;" ID="txtDelivery_Zip" runat="server"
                                                        CssClass="entry2" onblur="saveTextBoxToHidden(this);" TabIndex="3" />
                                                    <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                                        Enabled="True" FilterType="Numbers" TargetControlID="txtDelivery_Zip">
                                                    </ajaxToolkit:FilteredTextBoxExtender>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                    <fieldset id="fldEmailAddress" style="display: none; padding: 5px;">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label1" Text="Check By Email" />
                                        <table class="entry" border="0">
                                            <tr>
                                                <td align="right" style="width: 75px;">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label16" Text="Email Address:" />
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" Width="300" ID="txtDelivery_EmailAddress"
                                                        runat="server" onblur="saveTextBoxToHidden(this);" />
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                    <fieldset id="fldContactNumber" style="display: block; padding: 5px;">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label18" Text="Check By Phone" />
                                        <table class="entry" border="0">
                                            <tr>
                                                <td align="right" style="width: 75px;">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label21" Text="Contact Name:" />
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" ID="txtDelivery_ContactName"
                                                        runat="server" onblur="saveTextBoxToHidden(this);" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" style="width: 75px;">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label22" Text="Contact #:" />
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" ID="txtDelivery_ContactNumber"
                                                        runat="server" onblur="saveTextBoxToHidden(this);" />
                                                    <ajaxToolkit:MaskedEditExtender ID="txtDelivery_ContactNumber_MaskedEditExtender"
                                                        runat="server" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                                        CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                                        CultureTimePlaceholder="" Enabled="True" ClearMaskOnLostFocus="true" Mask="(999)999-9999"
                                                        MaskType="Number" TargetControlID="txtDelivery_ContactNumber">
                                                    </ajaxToolkit:MaskedEditExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" style="width: 75px;">
                                                    <asp:Label CssClass="entry2" runat="server" ID="Label23" Text="Contact Ext#:" />
                                                </td>
                                                <td align="left">
                                                    <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" Width="40px" ID="txtDelivery_ContactNumberExt"
                                                        runat="server" onblur="saveTextBoxToHidden(this);" MaxLength="6" />
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <br />
                    <fieldset style="padding: 5px;">
                        <asp:CheckBox ID="chkClientStipulation" runat="server" Text="Client Stipulation ?"
                            CssClass="chkClass" onclick="javascript:ClientStipulation(this);" />
                    </fieldset>
                    <br />
                    <fieldset style="padding: 5px; width: 578px;">
                        <asp:CheckBox ID="chkRestrictiveEndorsement" runat="server" Text="Restrictive Endorsement ?"
                            onclick="javascript:CheckRestrictive(this);" CssClass="chkClass" />
                        <div id="divConversationDate" runat="server" style="display: none;" class="entry">
                            <table class="entry" border="0">
                                <tr>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label3" Text="Conversation Date:" />
                                    </td>
                                    <td colspan="5" align="left">
                                        <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry2" ID="txtRestrictiveEndorsement"
                                            runat="server" TabIndex="4" />
                                        <asp:ImageButton runat="Server" ID="imgRestrictiveEndorsement" ImageUrl="~/images/Calendar_scheduleHS.png"
                                            AlternateText="Click to show calendar" ImageAlign="AbsMiddle" />
                                        <ajaxToolkit:CalendarExtender ID="txtRestrictiveEndorsement_CalendarExtender" runat="server"
                                            TargetControlID="txtRestrictiveEndorsement" PopupButtonID="imgRestrictiveEndorsement"
                                            CssClass="MyCalendar" Animated="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="lblAttent" Text="Attention To:" />
                                    </td>
                                    <td colspan="5" align="left">
                                        <asp:TextBox Style="border: 1px solid darkblue;" CssClass="entry" ID="txtRestrictive_Attention"
                                            runat="server" TabIndex="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label6" Text="Address:" />
                                    </td>
                                    <td colspan="5" align="left">
                                        <asp:TextBox Style="border: 1px solid darkblue;" ID="txtRestrictive_Address" runat="server"
                                            CssClass="entry" TabIndex="6" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label8" Text="City:" />
                                    </td>
                                    <td align="left">
                                        <asp:TextBox Style="border: 1px solid darkblue;" ID="txtRestrictive_City" runat="server"
                                            CssClass="entry2" Width="130px" />
                                    </td>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label9" Text="State:" />
                                    </td>
                                    <td>
                                        <asp:DropDownList Style="border: 1px solid darkblue;" ID="ddlRestrictive_State" runat="server"
                                            CssClass="entry2" Width="50px" DataSourceID="dsStates" DataTextField="abbreviation"
                                            DataValueField="abbreviation" />
                                    </td>
                                    <td align="right">
                                        <asp:Label CssClass="entry2" runat="server" ID="Label10" Text="Zip:" />
                                    </td>
                                    <td>
                                        <asp:TextBox Style="border: 1px solid darkblue;" ID="txtRestrictive_Zip" runat="server"
                                            CssClass="entry2" onblur="saveTextBoxToHidden(this);" TabIndex="7" />
                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtZip_FilteredTextBoxExtender" runat="server"
                                            Enabled="True" FilterType="Numbers" TargetControlID="txtRestrictive_Zip">
                                        </ajaxToolkit:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    <br />
                    <fieldset style="padding: 5px;">
                        <asp:CheckBox ID="chkPaymentArrangement" runat="server" Text="Client Payment Arrangement ?"
                            CssClass="chkClass" onclick="javascript:PaymentArrangement(this);" />
                        <asp:Label ID="lblPaymentArrangement" runat="server"></asp:Label>
                        <div id="dvPaymentArrangement" runat="server">
                            <asp:CheckBox ID="chkPAbyClient" runat="server" Text="Click on this checkbox if the Client will make the payments directly to the creditor"
                            CssClass="chkClass"  Style="margin-left: 30px; margin-top: 10px;" />
                        </div>
                    </fieldset>
                </div>
                <table class="entry" border="0" style="background-color: #DCDCDC; border-top: solid 1px #3D3D3D;">
                    <tr valign="middle">
                        <td>
                            <div class="entry" style="text-align: right; padding-right: 3px; height: 25px; vertical-align: middle;">
                                <asp:Button ID="lnkContinue" runat="server" Text="Continue" OnClientClick="return submitOffer();"
                                    CssClass="fakeButtonStyle" />
                                <asp:Button ID="lnkCancel" runat="server" Text="Cancel" OnClientClick="return closeAcceptPopup();"
                                    CssClass="fakeButtonStyle" />
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlSettAcceptForm" Style="display: block; text-align: center;" runat="server"
                CssClass="entry">
                <table class="entry" border="0" style="width: 100%; background-color: #DCDCDC; border-top: solid 1px #3D3D3D;
                    height: 400px">
                    <tr valign="middle">
                        <td>
                            <asp:PlaceHolder ID="phDocuments" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="entry" style="text-align: right; padding-right: 3px; height: 15px; vertical-align: middle;">
                                <asp:Button ID="Button3" runat="server" Text="Close" OnClientClick="$find('mpeAcceptBehavior').hide();return false;"
                                    CssClass="fakeButtonStyle" />
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlWarning" Style="display: none; text-align: center;" runat="server"
                CssClass="entry">
                <table class="entry" border="0" style="width: 100%; background-color: #DCDCDC; border-top: solid 1px #3D3D3D;
                    height: 200px">
                    <tr valign="middle">
                        <td class="error">
                            <div style="font-weight: bold; text-align: center;">
                                There is an existing settlement already accepted for this creditor.
                                <br />
                                <img alt="Warning" src="../../images/policestop.gif" />
                                <br />
                                Press [Overwrite] to continue with creating a new accepted settlement or [Cancel]
                                to stop the process.</div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="entry" style="text-align: right; padding-right: 3px; height: 15px; vertical-align: middle;">
                                <asp:Button ID="Button2" runat="server" Text="Overwrite" OnClientClick="return overwriteOffer(this);"
                                    CssClass="fakeButtonStyle" />
                                <asp:Button ID="Button4" runat="server" Text="Cancel" OnClientClick="$find('mpeAcceptBehavior').hide();return false;"
                                    CssClass="fakeButtonStyle" />
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            
        </asp:Panel>
        <asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnCompanyId" runat="server" />
        <asp:HiddenField ID="hdnDueDate" runat="server" />
        <asp:HiddenField ID="hdnRestrictiveEndorsement" runat="server" />
        <asp:HiddenField ID="hdnIsClientStipulation" runat="server" />
        <asp:HiddenField ID="hdnDeliveryMethod" runat="server" />
        <asp:HiddenField ID="hdnDelivery_Attention" runat="server" />
        <asp:HiddenField ID="hdnDelivery_Address" runat="server" />
        <asp:HiddenField ID="hdnDelivery_City" runat="server" />
        <asp:HiddenField ID="hdnDelivery_State" runat="server" />
        <asp:HiddenField ID="hdnDelivery_Zip" runat="server" />
        <asp:HiddenField ID="hdnRestrictive_Attention" runat="server" />
        <asp:HiddenField ID="hdnRestrictive_Address" runat="server" />
        <asp:HiddenField ID="hdnRestrictive_City" runat="server" />
        <asp:HiddenField ID="hdnRestrictive_State" runat="server" />
        <asp:HiddenField ID="hdnRestrictive_Zip" runat="server" />
        <asp:HiddenField ID="hdnDelivery_EmailAddress" runat="server" />
        <asp:HiddenField ID="hdnDelivery_ContactName" runat="server" />
        <asp:HiddenField ID="hdnDelivery_ContactNumber" runat="server" />
        <asp:HiddenField ID="hdnDelivery_ContactNumberExt" runat="server" />
        <asp:HiddenField ID="hdnIsClientPaymentArrangement" runat="server" />
        <asp:HiddenField ID="hdnOverwriteSettlementID" runat="server" />
        <asp:HiddenField ID="hdnPACalculatorId" runat="server" />
        <asp:HiddenField ID="hdnPACalculatorJson" runat="server" />
        <asp:HiddenField ID="hdnDefaultOvernightAmount" runat="server" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ibtnReject" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="lnkContinue" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
