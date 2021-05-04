<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="NewEnrollment.aspx.vb"
    Inherits="Clients_Enrollment_NewEnrollment" Title="Client Intake Department - Enrollment" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebToolbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>    
<%@ Register assembly="System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="System.Web.UI" tagprefix="cc2" %>

<%--<%@ MasterType TypeName="clients" %>--%>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <ajaxToolkit:ToolkitScriptManager ID="smEnroll" runat="server" />
    <asp:Panel runat="server" ID="pnlMenuDefault">
        <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
            <tr>
                <td nowrap="nowrap" id="tdSave" runat="server" style="padding-left:5px;">
                    <igtbar:UltraWebToolbar ID="uwToolBar" runat="server">
                        <HoverStyle Cursor="Hand">
                        </HoverStyle>
                        <DefaultStyle Cursor="Hand">
                        </DefaultStyle>
                        <ButtonStyle Cursor="Hand">
                        </ButtonStyle>
                        <LabelStyle Cursor="Hand" />
                        <Items>
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_back.png"
                                SelectedImage="" Text="Back" Tag="back" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="50px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_back.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="50px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_person_add.png"
                                SelectedImage="" Text="New Applicant" Tag="new" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="95px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_person_add.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_save.png"
                                SelectedImage="" Text="Save Applicant" Tag="save" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="100px">
                                <Images>
                                    <DefaultImage Url="~/images/16x16_save.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="100px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="~/images/16x16_form_setup.png" HoverImage="" Image="~/images/16x16_form_setup.png"
                                SelectedImage="" Tag="generate" Text="Generate LSA" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="95px">
                                <Images>
                                    <DisabledImage Url="~/images/16x16_form_setup.png" />
                                    <DefaultImage Url="~/images/16x16_form_setup.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBCustom ID="TBCustom1" runat="server" Key="Custom8" Width="150px">
                            <asp:CheckBox  ID="chkFormLetter" runat="server" Text="Additional Cover Letter" />
                            </igtbar:TBCustom>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton DisabledImage="~/images/16x16_form_setup.png" HoverImage="" Image="~/images/16x16_form_setup.png"
                                SelectedImage="" Tag="generate" Text="Print Form" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="150px">
                                <Images>
                                    <DisabledImage Url="~/images/16x16_print.png" />
                                    <DefaultImage Url="~/images/16x16_print.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                            <igtbar:TBSeparator />
                            <igtbar:TBarButton Key="switch" DisabledImage="~/images/16x16_file_remove.png" HoverImage="" Image="~/images/16x16_file_remove.png"
                                SelectedImage="" Tag="switch" Text="Switch Model" DefaultStyle-CssClass="enrollmentMenuButton" HoverStyle-CssClass="enrollmentMenuButtonHover" DefaultStyle-Width="150px" >
                                <Images>
                                    <DisabledImage Url="~/images/16x16_file_remove.png" />
                                    <DefaultImage Url="~/images/16x16_file_remove.png" />
                                </Images>
                                <DefaultStyle CssClass="enrollmentMenuButton" Width="95px">
                                </DefaultStyle>
                                <HoverStyle CssClass="enrollmentMenuButtonHover">
                                </HoverStyle>
                            </igtbar:TBarButton>
                        </Items>
                    </igtbar:UltraWebToolbar>
                </td>
            </tr>
        </table>     
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlBodyMessage" Style="display: none;">
    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" cellpadding="0" cellspacing="20" border="0">
        <tr>
            <td valign="top" align="center">
            </td>
        </tr>
    </table>
</asp:Panel>
</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
    
    <style type="text/css">
        .creditortxt
        {
        	font-family:Tahoma;
        	font-size:11px;
        	width:100%;
        	border:solid 1px #c1c1c1;
        	background-color:#fff;
        }    
    </style>
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>

    <script type="text/javascript">
        function SaveAndNoEndPage()
        {
            var btn = document.getElementById('<%=btnSaveAndNoEndPage.ClientID %>');
            btn.click();
        }
        
        function SaveAndLoadPickup(CallIdKey,RemoteAddress)
        {
            var btn = document.getElementById('<%=btnSaveAndNoEndPage.ClientID %>');
            document.getElementById('<%=hdnCallIdKey.ClientID %>').value = CallIdKey;
            document.getElementById('<%=hdnAni.ClientID %>').value = RemoteAddress;
            btn.click();
        }
        
        var EstimatedEndAmount = 0;
    
        function GetStatusValue()
        {
            var ddlStatus = document.getElementById("<%= ddlStatus.ClientID %>");
            var reason = ddlStatus.options[ddlStatus.selectedIndex].text;
            //hdnClientStatus.value = ddlStatus.selectedvalue;
            
            if(reason == "Does Not Qualify")
                {
                    showModalDialog("../../Util/pop/LeadDNQ.aspx?a=" + getQueryValue('id') + '&s=' + document.getElementById("<%= ddlStatus.ClientID %>").value, window, "status:off;help:off;dialogWidth:400px;dialogHeight:200px; center:yes;");
                     
    //                 if(oReturnValue == undefined)
    //                {
    //                    alert("You must enter a reason why this applicant Does Not Qualify, or choose another status for this applicant.");
    //                    var ddlStatus = document.getElementById("<%= ddlStatus.ClientID %>");
    //                    document.getElementById("<%= ddlStatus.ClientID %>").selectedindex = 0
    //                }
                }
          
         //            if(reason == "Cancelled/Agent")
//                {
//                    var caReturnValue = showModalDialog("../../Util/pop/LeadCancelled.aspx?a=" + getQueryValue('id') + '&s=CA', window, "status:off;help:off;dialogWidth:400px;dialogHeight:200px; center:yes;");
//                    
//                    if(caReturnValue == undefined || caReturnValue == "")
//                        {
//                            alert("You can not use the status Cancelled/Agent without selecting a reason.");
//                            var ddlStatus = document.getElementById("<%= ddlStatus.ClientID %>");
//                            ddlStatus.value = '0';
//                            //location.reload(true);
//                        }
//                }
//            if(reason == "Cancelled/Consumer")
//               {
//                    var ccReturnValue = showModalDialog("../../Util/pop/LeadCancelled.aspx?a=" + getQueryValue('id') + '&s=CC', window, "status:off;help:off;dialogWidth:400px;dialogHeight:200px; center:yes;");
//                    
//                    if(ccReturnValue == undefined || ccReturnValue == "")
//                        {
//                            alert("You can not use the status Cancelled/Consumer without selecting a reason.");
//                            var ddlStatus = document.getElementById("<%= ddlStatus.ClientID %>");
//                            ddlStatus.value = '0';
//                            //location.reload(true);
//                        }
//               }
             if(reason == "In Process")
                {
                    var processor = document.getElementById("<%= ddlProcessor.ClientID %>");
                    processor.style.display = 'block';
/*                    var pstatus = document.getElementById("<%= ddlProcessingStatus.ClientID %>");
                    pstatus.style.display = 'block';
                    var lblprocstatus = document.getElementById("<%= lblProcStatus.ClientID %>");
                    lblprocstatus.style.display = 'block' */
                    var lblprocessors = document.getElementById("<%= lblProcessor.ClientID %>");
                    lblprocessors.style.display = 'block'
                }
            else
                {
                    var processor = document.getElementById("<%= ddlProcessor.ClientID %>");
                    processor.style.display = 'none'
/*                    var pstatus = document.getElementById("<%= ddlProcessingStatus.ClientID %>");
                    pstatus.style.display = 'none';
                    var lblprocstatus = document.getElementById("<%= lblProcStatus.ClientID %>");
                    lblprocstatus.style.display = 'none' */
                    var lblprocessors = document.getElementById("<%= lblProcessor.ClientID %>");
                    lblprocessors.style.display = 'none'
  
                }
         }
         function GetAssignedToValue()
         {
            var ddlAssignTo = document.getElementById("<%= ddlAssignTo.ClientID %>");
            hdnAssignedTo.value = ddlAssignTo.selectedValue;
         }	
        function FindCreditor(creditor,street,street2,city,stateid,zipcode)
        {
            var hdn = document.getElementById('<%=hdnCreditorInfo.ClientID %>');
            showModalDialog("<%= ResolveUrl("~/util/pop/holder.aspx?t=Find Creditor&p=findcreditorgroup.aspx") %>" + "&creditor=" + creditor + "&street=" + escape(street) + "&street2=" + escape(street2) + "&city=" + city + "&stateid=" + stateid + "&zipcode=" + zipcode, new Array(window, hdn, "CreditorFinderReturn"), "status:off;help:off;dialogWidth:650px;dialogHeight:520px");
        }
        function CreditorFinderReturn(hdn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)
        {
            hdn.value = creditorid + "|" + name + "|" + street + "|" + street2 + "|" + city + "|" + stateid + "|" + zipcode + "|" + creditorgroupid + "|" + validated;
            document.getElementById("<%= btnCreditorRefresh.ClientID() %>").click();
        }        
        function AddCreditors()
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = '-1';
            FindCreditor('','','','',-1,'');
        }
        function EditCreditor(creditorInstanceID,creditor,street,street2,city,stateid,zipcode)
        {
            document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = creditorInstanceID;
            FindCreditor(creditor,street,street2,city,stateid,zipcode);
        }
        function AddBanks(){
            if (!document.getElementById("<%= lnkAddBanks.ClientID() %>").disabled){
                showModalDialog("addbank.aspx?id=" + getQueryValue('id') + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:400px;dialogHeight:400px;center:yes;");
                document.getElementById("<%= btnBankRefresh.ClientID() %>").click();
            }
        }
        function EditBank(bankID){
            showModalDialog("addbank.aspx?bID=" + bankID  + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:400px;dialogHeight:400px; center:yes;");
            document.getElementById("<%= btnBankRefresh.ClientID() %>").click();
        }
        function AddCoApps(){
            if (!document.getElementById("<%= lnkAddCoApps.ClientID() %>").disabled){
                showModalDialog("addcoap.aspx?id=" + getQueryValue('id') + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:310px;dialogHeight:435px; center:yes;");
                document.getElementById("<%= btnCoAppRefresh.ClientID() %>").click();
            }
        }
        function EditCoApp(coappID){
            showModalDialog("addcoap.aspx?cID=" + coappID  + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:310px;dialogHeight:435px; center:yes;");
            document.getElementById("<%= btnCoAppRefresh.ClientID() %>").click();
        }
        function AddNotes(){
            if (!document.getElementById("<%= lnkAddNotes.ClientID() %>").disabled){
                showModalDialog("<%= ResolveUrl("~/Clients/Enrollment/addnote.aspx?id=") %>" + getQueryValue('id')  + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:400px;dialogHeight:400px; center:yes;");
                document.getElementById("<%= btnNotesRefresh.ClientID() %>").click();
            }
        }
        function EditNote(noteID){
            showModalDialog("<%= ResolveUrl("~/Clients/Enrollment/addnote.aspx?nID=") %>" + noteID  + '&md=' + Math.floor(Math.random()*99999), window, "status:off;help:off;dialogWidth:400px;dialogHeight:400px; center:yes;");
            document.getElementById("<%= btnNotesRefresh.ClientID() %>").click();
        }
        function getQueryValue( name ) {    
            var regex = new RegExp( "[\?&]"+name+"=([^&#]*)" );
            var results = regex.exec( window.location.href );    
            if( results == null){
                return "";    
            }else        {
                return results[1];
            }
        }
        function Recalc(commit){
            var TotalDebt = 0.0;
            var TotalDebtForDepositCommitment = 0.0;            //use total debt to calculate dep com
            var TotalAtSettlement = 0.0;
            var DepositCommitment = 0.0;
            var MinDeposit = <%= EnrollmentMinDeposit %>;       // minimum whole amount can deposit
            var MinPct = <%= EnrollmentMinPct %>;               // minimum percentage can deposit
            var MaxPct = <%= EnrollmentMaxPct %>;               // used to calc high deposit range
            var CurrentPct = <%= EnrollmentCurrentPct %>;       // this is just an estimate pct
            var txtTotalDebt = document.getElementById("<%= txtTotalDebt.ClientID %>");
            
            if (txtTotalDebt.value != null && txtTotalDebt.value.length > 0){
                TotalDebt = parseFloat(txtTotalDebt.value);
            }else{
                TotalDebt = 0.0;
            }
            if (TotalDebt<5000){
                return;
            }

            // recalc commitment
            if (commit == 1){
                //setup minimum deposit commitment
                if ((MinPct * TotalDebt) > MinDeposit){
                    DepositCommitment = MinPct * TotalDebt;
                }else{
                    DepositCommitment = MinDeposit;
                }
            //3.6.09.ug:  if dep committment has value use it regardless
                var currDepCommit = document.getElementById("<%= txtDepositComitmment.ClientID %>").value;
                currDepCommit = parseFloat(currDepCommit.replace(/,/g,''));
                if (currDepCommit != 0){
                    DepositCommitment = currDepCommit;
                }
            }
            
            var ddlSettlementPct = document.getElementById("<%= ddlSettlementPct.ClientID %>");
            var ddlSettlementFee = document.getElementById("<%= ddlSettlementFee.ClientID %>");
            var ddlMaintenanceFee = document.getElementById("<%= ddlMaintenanceFee.ClientID %>");
            var ddlSubMaintenanceFee = document.getElementById("<%= ddlSubMaintenanceFee.ClientID %>");
            var lblDebtSettle = document.getElementById("<%= lblDebtSettle.ClientID %>");
            var tblPlanOptions = document.getElementById("<%= tblPlanOptions.ClientID %>");
            
            var SettlementPct = ddlSettlementPct.options[ddlSettlementPct.selectedIndex].text / 100;
            var SettlementPctTotal = TotalDebt * SettlementPct;
            var SettlementFeePct = ddlSettlementFee.options[ddlSettlementFee.selectedIndex].text / 100;
            var SettlementFeeTotal = (TotalDebt - SettlementPctTotal) * SettlementFeePct;
            var MaintenanceFeeMonthly = ddlMaintenanceFee.options[ddlMaintenanceFee.selectedIndex].text;
            var MaintenanceFeeTotal = MaintenanceFeeMonthly * 12;
            var SubMaintentanceFeeMonthly = ddlSubMaintenanceFee.options[ddlSubMaintenanceFee.selectedIndex].text;
            var SubMaintenanceFeeTotal;
            var CurrentMonthly = TotalDebt * CurrentPct;
            var NominalDeposit;
            var LowAmt;
            var HighAmt;
            var Counseling = TotalDebt * MaxPct;
            var Bankruptcy1 = TotalDebt * MinPct;
            var Bankruptcy2 = MinDeposit;
            var TotalSettlementFees;
            var InitialDeposit = document.getElementById("<%= txtDownPmt.ClientID %>").value;
            var Term;
            
            if ((TotalDebt * MinPct) <= MinDeposit){
                NominalDeposit = MinDeposit;
            }else{
                NominalDeposit = TotalDebt * MinPct;
                }
            if ((TotalDebt * MinPct) <= MinDeposit){
                LowAmt = MinDeposit;
            }else{
                LowAmt = TotalDebt * MinPct;
                }
            if ((TotalDebt * MaxPct) <= MinDeposit){
                HighAmt = MinDeposit;
            }else{
                HighAmt = TotalDebt * MaxPct;
                }
            //Recommendation
            DepositCommitment = document.getElementById("<%= txtDepositComitmment.ClientID %>").value;
            DepositCommitment = parseFloat(DepositCommitment.replace(/,/g,''));
            
            if (((((SettlementPctTotal + SettlementFeeTotal + MaintenanceFeeTotal) - InitialDeposit) / (DepositCommitment)) / 12) < 0){
                Term = 0;
            }else{
                Term = ((((SettlementPctTotal + SettlementFeeTotal + (-12*(DepositCommitment - MaintenanceFeeMonthly)))) / (DepositCommitment-SubMaintentanceFeeMonthly)) / 12)+1;
            }
            
            //calculate based on remainder of term minus the first year
            SubMaintenanceFeeTotal = SubMaintentanceFeeMonthly *((Term*12)-12);
            
            TotalSettlementFees = SettlementPctTotal + MaintenanceFeeTotal + SubMaintenanceFeeTotal + SettlementFeeTotal;
            
            if (DepositCommitment > Counseling) {
                lblDebtSettle.innerHTML = "Credit Counseling";
                lblDebtSettle.className = "orange";
            } else if (DepositCommitment < Bankruptcy1) {
                lblDebtSettle.innerHTML = "Bankruptcy";
                lblDebtSettle.className = "red";
            } else {
                lblDebtSettle.innerHTML = "Debt Settlement";
                lblDebtSettle.className = "green";
            }
            
            document.getElementById("<%= lblSettlementPct2.ClientID %>").innerHTML = "$" + FormatNumber(SettlementPctTotal, true, 2);
            document.getElementById("<%= lblSettlementFee.ClientID %>").innerHTML = "$" + FormatNumber(SettlementFeeTotal, true, 2);
            document.getElementById("<%= lblCurrentMonthly.ClientID %>").innerHTML = "$" + FormatNumber(CurrentMonthly, true, 2);
            document.getElementById("<%= lblLowAmt.ClientID %>").innerHTML = "$" + FormatNumber(LowAmt, true, 2);
            document.getElementById("<%= lblHighAmt.ClientID %>").innerHTML = "$" + FormatNumber(HighAmt, true, 2);
            document.getElementById("<%= lblMaintenanceFeeTotal.ClientID %>").innerHTML = "$" + FormatNumber(MaintenanceFeeTotal, true, 2);
            document.getElementById("<%= lblSubMaintenanceFee.ClientID %>").innerHTML = "$" + FormatNumber(SubMaintenanceFeeTotal, true, 2);
            document.getElementById("<%= txtNominalDeposit.ClientID %>").innerHTML = "$" + FormatNumber(NominalDeposit, true, 2);
            document.getElementById("<%= txtSettlementFees.ClientID %>").innerHTML = "$" + FormatNumber(TotalSettlementFees, true, 2);
            document.getElementById("<%= txtTerm.ClientID %>").innerHTML = FormatNumber(Term, true, 2);

            /* Not rolling this feature out to production for 1/20/09 hotfix release
            //set estimates
            SetEstimates();

            //adjust initial total for future total (counting inflation)
            var EnrollmentInflation = <%= EnrollmentInflation %>;
            var BalanceAtEnrollment = TotalDebt;
            var BalanceAtSettlement = BalanceAtEnrollment + (BalanceAtEnrollment * EnrollmentInflation);
            
            // set the debt options
            var Options = (tblPlanOptions.rows[0].cells.length - 3);
        
            var i = 0
            while(i<4){
                try{
                    var Percentage = parseFloat(tblPlanOptions.rows[0].cells[i + 1].childNodes[0].value);
                    var txtEstimatedTotalPaid = tblPlanOptions.rows[1].cells[i + 1];
                    var txtEstimatedEnrollmentFee = tblPlanOptions.rows[2].cells[i + 1];
                    var txtEstimatedMaintenanceFee = tblPlanOptions.rows[3].cells[i + 1];
                    var txtEstimatedSettlementFee = tblPlanOptions.rows[4].cells[i + 1];
                    var txtEstimatedPlanCost = tblPlanOptions.rows[5].cells[i + 1];
                    var txtEstimatedDebtFree = tblPlanOptions.rows[6].cells[i + 1];
                    var txtEstimatedSavings = tblPlanOptions.rows[7].cells[i + 1];

                    var EstimatedTotalPaid = BalanceAtSettlement * Percentage;
                    var EstimatedEnrollmentFee = MaintenanceFeeTotal;
                    var EstimatedSettlementFee = (BalanceAtSettlement - (BalanceAtSettlement * Percentage)) * SettlementFeePct;
                    var EstimatedDebtFree = ((((EstimatedTotalPaid + EstimatedSettlementFee) + (-12*(DepositCommitment-MaintenanceFeeMonthly)))/(DepositCommitment-SubMaintentanceFeeMonthly))/12)+1;
                    var EstimatedMaintenanceFee = SubMaintentanceFeeMonthly * ((EstimatedDebtFree*12)-12);//(MaintenanceFeeMonthly * EstimatedDebtFree);
                    var EstimatedPlanCost = EstimatedTotalPaid + EstimatedEnrollmentFee + EstimatedSettlementFee + EstimatedMaintenanceFee;

                    txtEstimatedTotalPaid.innerHTML = "$" + FormatNumber(EstimatedTotalPaid, true,2);
                    txtEstimatedEnrollmentFee.innerHTML = "$" + FormatNumber(EstimatedEnrollmentFee, true,2);
                    txtEstimatedSettlementFee.innerHTML = "$" + FormatNumber(EstimatedSettlementFee, true,2);
                    txtEstimatedDebtFree.innerHTML = MonthsToYears(EstimatedDebtFree*12);
                    txtEstimatedMaintenanceFee.innerHTML = "$" + FormatNumber(EstimatedMaintenanceFee, true,2);
                    txtEstimatedPlanCost.innerHTML = "$" + FormatNumber(EstimatedPlanCost, true,2);
                    txtEstimatedSavings.innerHTML = "$" + FormatNumber((EstimatedEndAmount - EstimatedPlanCost), true,2);            
                    i++
                }
                catch(e){
                    alert(e);
                }
            }*/
            
        }
        
function MonthsToYears(Value){
    return Math.floor(Value / 12) + " yrs " + Math.round(Value % 12) + " mo";
}
function SetEstimates(){
    var TotalDebt = 0.0;
    var txtTotalDebt = document.getElementById("<%= txtTotalDebt.ClientID %>");
    if (txtTotalDebt.value != null && txtTotalDebt.value.length > 0)
        TotalDebt = parseFloat(txtTotalDebt.value);
    else
        TotalDebt = 0.0;

    var EnrollmentPBMAPR = <%= EnrollmentPBMAPR %>;
    var EnrollmentPBMMinimum = <%= EnrollmentPBMMinimum %>;
    var EnrollmentPBMPercentage = <%= EnrollmentPBMPercentage %>;


    var newBal = TotalDebt;
    var MPR = parseFloat(EnrollmentPBMAPR / 12).toFixed(6);

    var mip = 0;
    var payment = 0.0;
    var sumpayment = 0.0;

    while (newBal > 0){
        //if (TotalMonthlyPayment < (newBal * EnrollmentPBMPercentage))
        if (newBal < EnrollmentPBMMinimum){
            payment = newBal;
        }else{
            if ((newBal * EnrollmentPBMPercentage) <= EnrollmentPBMMinimum){
                if (newBal < EnrollmentPBMMinimum)
                    payment = newBal;
                else
                    payment = EnrollmentPBMMinimum;
            }else{
                payment = newBal * EnrollmentPBMPercentage;
            }
        }

        //last payment, last month
        if (newBal < EnrollmentPBMMinimum) {
            payment += newBal * MPR;
            sumpayment += payment;
            newBal -= payment;
        }else{
            sumpayment += payment;
            newBal = ((newBal + (newBal * MPR)) - payment);
        }

        mip += 1;
    }

    EstimatedEndAmount = sumpayment;
    EstimatedEndTime = mip;
}
function RemoveCoApp(id)
{
    document.getElementById("<%=hdnLeadCoApplicantID.ClientID %>").value = id;
    document.getElementById("<%=btnRemoveCoApp.ClientID() %>").click();
}
function RemoveBank(id)
{
    document.getElementById("<%=hdnLeadBankID.ClientID %>").value = id;
    document.getElementById("<%=btnRemoveBank.ClientID() %>").click();
}
function RemoveCreditor(id)
{
    document.getElementById("<%=hdnLeadCreditorInstance.ClientID %>").value = id;
    document.getElementById("<%=btnRemoveCreditor.ClientID() %>").click();
}
function ddlLeadSource_onchange(ddl)
{
    var source = ddl.options[ddl.selectedIndex].text;
    
    if (source == 'Paper Lead' || source == 'Radio' || source == 'TV')
        document.getElementById('<%=trPaperLeadCode.ClientID %>').style.display = '';
    else
        document.getElementById('<%=trPaperLeadCode.ClientID %>').style.display = 'none';
}

 function calluser(phonenumber, leadid) {
     parent.make_call_lead(phonenumber, leadid);
}


    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        </ContentTemplate>
    </asp:UpdatePanel>

        <div runat="server" id="dvErrorReceived" style="display:none;">
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="5" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td valign="top" style="width:20;"><img id="Img4" runat="server" src="~/images/16x16_exclamationpoint.png" align="absmiddle" border="0"></td>
                        <td runat="server" id="tdErrorReceived"></td>
                    </tr>
                </table>&nbsp;<br />
            </div>
            <div style="text-align: center;">
                <br />
                <div id="divMsg" runat="server" style="display: none; background-color: #FFFF99;
                    border: thin solid #FF0000; font-family: tahoma; font-size: 11px; font-weight: bold;
                    width: 40%; height: 50px;">
                </div>
            </div>
            <table runat="server" id="tblBody" class="enrollment_body">
                <tr>
                    <td style="color: #666666; padding-bottom: 15px;">
                        <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/Clients/Enrollment/Default.aspx">
                            Applicants</a>&nbsp;>&nbsp;<asp:Label ID="lblPerson" runat="server" Style="color: #666666;"
                                Text="New Applicant"></asp:Label>
                    </td>
                    <td>
                        &nbsp;</td>
                    <td style="text-align:right; padding-bottom: 15px;">
                        <asp:Label ID="lblLastSave" runat="server" Style="color: #666666;"></asp:Label></td>
                </tr>
                <tr>
                    <td valign="top">
                        <asp:Panel ID="pnlSetup" runat="server">
                            <table class="window">
                                <tr>
                                    <td colspan="2">
                                        <h2>
                                            1. Setup</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Name:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="1" CssClass="entry" runat="server" ID="txtName" Width="150px"
                                            BackColor="Gold" reqSave="True" valCap="Lead Name"/>
                                </tr>
                                <tr>
                                    <td>
                                        Phone:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="2" ID="txtPhone" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold" ReadOnly="False">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                         </igtxt:WebMaskEdit>
                                        <img id="ImgMakeCall" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtPhone.ClientId%>'), '<%= GetLeadId()%>');" style="cursor:hand" /> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Zip Code:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="3" reqSave="True" valCap="Lead phone number" valFun="IsZipCode" CssClass="entry" runat="server" ID="txtSZip" Width="150px"
                                            BackColor="Gold" AutoPostBack="true"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20">
                                        Behind:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBehind" runat="server" CssClass="entry" TabIndex="4" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Concerns:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlConcerns" runat="server" CssClass="entry" TabIndex="5" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Source:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlLeadSource" runat="server" CssClass="entry" TabIndex="6"
                                            Width="150px" onchange="javascript:ddlLeadSource_onchange(this);">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="trPaperLeadCode" runat="server" style="display:none">
                                    <td>
                                        Code:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="6" CssClass="entry" runat="server" ID="txtPaperLeadCode" Width="150px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Company:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCompany" runat="server" CssClass="entry" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Language:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="entry" TabIndex="7" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Delivery:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlDelivery" runat="server" CssClass="entry" TabIndex="8" Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        First Appointment:
                                    </td> 
                                    <td>
                                        <igsch:WebDateChooser ID="FirstAppDate" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="15px" NullDateLabel="" TabIndex="20" Value="" 
                                            Width="150px" NullValueRepresentation="DBNull" reqSave="True" valCap="Deposit date">
                                            <DropDownStyle Font-Names="Tahoma" Font-Size="8pt" Font-Strikeout="False">
                                            </DropDownStyle>
                                            <DropButton>
                                                <Style Font-Names="Tahoma" Font-Size="8pt">
                                                    </Style>
                                            </DropButton>
                                            <CalendarLayout>
                                                <DayHeaderStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                <NextPrevStyle Font-Names="Tahoma" Font-Overline="False" Font-Size="8pt" />
                                                <OtherMonthDayStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                <SelectedDayStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                <FooterStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                <DropDownStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </DropDownStyle>
                                            </CalendarLayout>
                                            <EditStyle Font-Names="Tahoma" Font-Size="8pt">
                                            </EditStyle>
                                        </igsch:WebDateChooser>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Time Zone:
                                    </td> 
                                    <td>
                                         <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="entry" Width="150px" AutoPostBack="true"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Time (For Lead):
                                    </td>
                                    <td>
                                        <igtxt:WebDateTimeEdit ID="FirstAppLeadTime" runat="server" 
                                            EditModeFormat="hh:mm tt" Font-Names="Tahoma" Font-Size="8pt" Height="21px" 
                                            Width="55px" AutoPostBack="true">
                                        </igtxt:WebDateTimeEdit>
                                        (Local)                                        
                                        <igtxt:WebDateTimeEdit ID="FirstAppTime" runat="server" 
                                            EditModeFormat="hh:mm tt" Height="21px" Font-Names="Tahoma" Font-Size="8pt" Width="55px" AutoPostBack="true">
                                        </igtxt:WebDateTimeEdit>
                                    </td>
                                 </tr>
                                <tr>
                                    <td>
                                        Assign To:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAssignTo" runat="server" CssClass="entry" TabIndex="9" 
                                            Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Status:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="entry" TabIndex="10" 
                                            Width="150px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                        <td>
                            <asp:label ID="lblProcessor" runat="server" Text="Processor:" style="display: none;" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlProcessor" runat="server" CssClass="entry" Width="150px"
                                TabIndex="45" style="display:none;">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:label ID="lblProcStatus" runat="server" Text="Processing Status:" style="display: none;" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlProcessingStatus" runat="server" CssClass="entry" Width="150px" TabIndex="46" style="display:none;">
                            </asp:DropDownList>
                        </td>
                    </tr>
                            </table>
                        </asp:Panel>
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Notes:</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblQuick" runat="server" Text="Quick Note:" />
                                    <asp:TextBox ID="txtQuickNote" runat="server" BorderStyle="Solid" Font-Names="Tahoma"
                                        Font-Size="11px" Height="50px" HorizontalAlign="Justify" Width="99%" TextMode="MultiLine"></asp:TextBox>
                                    <a id="lnkAddNotes" runat="server" class="lnk" href="javascript:AddNotes();">
                                        <img id="Img2" style="margin-right: 5;" src="~/images/16x16_Note.png" runat="server"
                                            border="0" align="absmiddle" />Add Notes</a>
                                    <br />
                                    <igtbl:UltraWebGrid ID="wGrdNotes" runat="server" Width="225px" DataSourceID="dsNotes"
                                        Browser="Xml" DataKeyField="LeadNoteID">
                                        <Bands>
                                            <igtbl:UltraGridBand RowSelectors="No" DataKeyField="LeadNoteID" AllowSorting="No">
                                                <Columns>
                                                    <igtbl:UltraGridColumn Width="50px" BaseColumnName="NoteType" DataType="System.String"
                                                        Hidden="True">
                                                        <Header Caption="Type">
                                                        </Header>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Width="75px" BaseColumnName="Created" DataType="System.DateTime"
                                                        Format="MM/dd/yy">
                                                        <Header Caption="Date">
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Header>
                                                        <CellStyle Width="65px" VerticalAlign="Top">
                                                        </CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Width="150px" BaseColumnName="Value" Type="HyperLink" CellMultiline="Yes">
                                                        <Header Caption="Notes">
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Header>
                                                        <CellStyle Wrap="True" Height="20px">
                                                        </CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn DataType="System.Int32" HTMLEncodeContent="True" Hidden="True"
                                                        BaseColumnName="LeadApplicantID">
                                                        <Header Caption="LeadApplicatantNo">
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn DataType="System.Int32" HTMLEncodeContent="True" Hidden="True"
                                                        BaseColumnName="LeadNoteID">
                                                        <Header Caption="LeadNoteID">
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                </Columns>
                                                <RowStyle TextOverflow="Ellipsis" />
                                                <AddNewRow View="NotSet" Visible="NotSet">
                                                </AddNewRow>
                                            </igtbl:UltraGridBand>
                                        </Bands>
                                        <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                            StationaryMarginsOutlookGroupBy="True" Version="4.00" AllowSortingDefault="Yes"
                                            AutoGenerateColumns="False" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                            BorderCollapseDefault="Collapse" RowSelectorsDefault="No">
                                            <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                            </FrameStyle>
                                            <Pager AllowPaging="false">
                                            </Pager>
                                            <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </FooterStyleDefault>
                                            <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </HeaderStyleDefault>
                                            <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                                Font-Names="Verdana" Font-Size="8pt">
                                                <Padding Left="3px" />
                                                <BorderDetails ColorLeft="White" ColorTop="White" ColorBottom="LightGray" StyleBottom="Solid" WidthBottom="1px" />
                                            </RowStyleDefault>
                                            <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                            </SelectedRowStyleDefault>
                                            <AddNewBox>
                                                <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                                </BoxStyle>
                                            </AddNewBox>
                                            <ActivationObject BorderColor="Black" BorderWidth="">
                                            </ActivationObject>
                                            <FilterOptionsDefault>
                                                <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                                    CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px" Width="200px">
                                                    <Padding Left="2px" />
                                                </FilterDropDownStyle>
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                                <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                                    BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px">
                                                    <Padding Left="2px" />
                                                </FilterOperandDropDownStyle>
                                            </FilterOptionsDefault>
                                        </DisplayLayout>
                                    </igtbl:UltraWebGrid>
                                    <asp:SqlDataSource ID="dsNotes" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getNotes"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter Name="applicantID" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <asp:Panel ID="pnlCalculator" runat="server">
                            <table class="window">
                                <tr>
                                    <td>
                                        <h2>
                                            2. Calculator:</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="calculator">
                                            <tr>
                                                <td colspan="2">
                                                    <h2>
                                                        &nbsp;</h2>
                                                </td>
                                                <td>
                                                    <h2>
                                                        Final Numbers</h2>
                                                </td>
                                                <td>
                                                    <h2>
                                                        Recommendation</h2>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h3>
                                                        Total Debt:</h3>
                                                </td>
                                                <td>
                                                    <asp:TextBox TabIndex="11" CssClass="entry" runat="server" ID="txtTotalDebt" Width="100px"
                                                        BackColor="Gold" Style="text-align: right;" reqSave="True" valCap="Total Debt" valFun="IsValidCurrency(Input.value);" onkeyup=""></asp:TextBox>
                                                </td>
                                                <td align="center">
                                                    <asp:Label Text="Debt Settlement" Font-Bold="True" runat="server" ID="lblDebtSettle"
                                                        CssClass="green" Width="110px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h4>
                                                        Settlement %:</h4>
                                                </td>
                                                <td>
                                                    <asp:DropDownList TabIndex="12" CssClass="entry" runat="server" ID="ddlSettlementPct"
                                                        Width="100px" BackColor="Gold">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblSettlementPct2"
                                                        Height="20px" Width="100px"></asp:Label>
                                                </td>
                                                <td>
                                                    <h2>
                                                        Current Monthly</h2>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h3>
                                                        First Year Maint. Fee $:</h3>
                                                </td>
                                                <td>
                                                    <asp:DropDownList TabIndex="13" CssClass="entry" runat="server" ID="ddlMaintenanceFee"
                                                        Width="100px" BackColor="Gold" DataTextFormatString="{0:#,###,##0.00}">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblMaintenanceFeeTotal"
                                                        Height="20px" Width="100px"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblCurrentMonthly"
                                                        Height="20px" Width="110px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h4>
                                                        Subsequent Maint. Fee $:</h4>
                                                </td>
                                                <td>
                                                    <asp:DropDownList CssClass="entry" runat="server" ID="ddlSubMaintenanceFee" Width="100px"
                                                        BackColor="Gold" TabIndex="14" DataTextFormatString="{0:#,###,##0.00}">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblSubMaintenanceFee"
                                                        Height="20px" Width="100px"></asp:Label>
                                                </td>
                                                <td>
                                                    <h2>
                                                        Nominal Deposit</h2>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h3>
                                                        Settlement Fee %:</h3>
                                                </td>
                                                <td>
                                                    <asp:DropDownList TabIndex="15" CssClass="entry" runat="server" ID="ddlSettlementFee"
                                                        Width="100px" BackColor="Gold">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <asp:Label BackColor="LawnGreen" Font-Bold="False" Style="text-align: right; padding: 3px 2px 0 0;"
                                                        runat="server" ID="lblSettlementFee" Height="20px" Width="100px"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label BackColor="LawnGreen" Font-Bold="False" Style="text-align: right; padding: 3px 2px 0 0;"
                                                        runat="server" ID="txtNominalDeposit" Height="20px" Width="110px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h4>
                                                        Total Settlement + Fees:</h4>
                                                </td>
                                                <td>
                                                    <asp:Label BackColor="LawnGreen" Font-Bold="False" Style="text-align: right; padding: 3px 2px 0 0;"
                                                        runat="server" ID="txtSettlementFees" Height="20px" Width="100px"></asp:Label>
                                                </td>
                                                <td>
                                                    <h2>
                                                        Deposit Range</h2>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h3>
                                                        Initial Deposit:</h3>
                                                </td>
                                                <td>
                                                    <asp:TextBox TabIndex="17" Style="text-align: right;" CssClass="entry" runat="server"
                                                        ID="txtDownPmt" Width="100px" BackColor="Gold"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <h5>
                                                        Low</h5>
                                                    <h5>
                                                        High</h5>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h4>
                                                        Deposit Committment:</h4>
                                                </td>
                                                <td>
                                                    <asp:TextBox TabIndex="18" CssClass="entry" runat="server" ID="txtDepositComitmment"
                                                        Style="text-align: right;" Width="100px" BackColor="Gold"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label BackColor="LawnGreen" Font-Bold="False" runat="server" ID="lblHighAmt" Height="20px"
                                                            Style="text-align: center; padding: 3px 2px 0 0;" Width="50%"></asp:Label><asp:Label BackColor="Red" ForeColor="Yellow" Font-Bold="False" Style="text-align: center; padding: 3px 2px 0 0;" runat="server" ID="lblLowAmt" Height="20px" Width="50%"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h3>
                                                        Term (Years):</h3>
                                                </td>
                                                <td>
                                                    <asp:Label BackColor="LawnGreen" Font-Bold="False" Style="text-align: center; padding: 3px 2px 0 0;"
                                                        runat="server" ID="txtTerm" Height="20px" Width="100px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h3>
                                                        Date of First Deposit:</h3>
                                                </td>
                                                <td>
                                                    <igsch:WebDateChooser ID="wFirstDepositDate" runat="server" BackColor="#FFCC00" Font-Names="Tahoma"
                                                        Font-Size="8pt" Height="20px" NullDateLabel="" TabIndex="20" Value="" 
                                                        Width="100px" NullValueRepresentation="DBNull" reqSave="True" valCap="Deposit date">
                                                        <DropDownStyle Font-Names="Tahoma" Font-Size="8pt" Font-Strikeout="False">
                                                        </DropDownStyle>
                                                        <DropButton>
                                                            <Style Font-Names="Tahoma" Font-Size="8pt">
                                                                </Style>
                                                        </DropButton>
                                                        <CalendarLayout>
                                                            <DayHeaderStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                            <NextPrevStyle Font-Names="Tahoma" Font-Overline="False" Font-Size="8pt" />
                                                            <OtherMonthDayStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                            <SelectedDayStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                            <FooterStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                            <DropDownStyle Font-Names="Tahoma" Font-Size="8pt">
                                                            </DropDownStyle>
                                                        </CalendarLayout>
                                                        <EditStyle Font-Names="Tahoma" Font-Size="8pt">
                                                        </EditStyle>
                                                    </igsch:WebDateChooser>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <h3>
                                                        Re-occurring deposit Day:</h3>
                                                </td>
                                                <td>
                                                    <asp:DropDownList TabIndex="22" CssClass="entry" runat="server" ID="ddlDepositDay"
                                                        Width="100px" BackColor="Gold">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                           </table>
                           <table class="window" id="tblStep4" runat="server" visible="false">
                                <tr>
                                    <td>
                                        <h2>
                                            4. Settlement Estimate Calculator:</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <table class="calculator" runat="server" id="tblPlanOptions" border="0">
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <%--Banking Information--%>
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Banking Information</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <a id="lnkAddBanks" runat="server" class="lnk" href="javascript:AddBanks();">
                                        <img id="Img1" style="margin-right: 5;" src="~/images/16x16_scale.png" runat="server"
                                            border="0" align="absmiddle" />Add Banking Information</a>
                                    <igtbl:UltraWebGrid ID="wGrdBanking" runat="server"
                                        Browser="Xml" DataKeyField="leadbankid" DataSourceID="dsBanks">
                                        <Bands>
                                            <igtbl:UltraGridBand DataKeyField="leadbankid" RowSelectors="No" AllowAdd="No" AllowDelete="No" AllowUpdate="No" AllowSorting="No">
                                                <Columns>
                                                    <igtbl:TemplatedColumn Width="16px">
                                                        <CellTemplate>
                                                            <a href='javascript:RemoveBank(<%#DataBinder.Eval(Container.DataItem, "LeadBankID")%>);' title="Remove Bank"><img runat="server" src="~/images/16x16_delete.png" style="border-style:none" /></a>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:UltraGridColumn Width="150px" BaseColumnName="BankName">
                                                        <Header Caption="Bank">
                                                        </Header>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Width="100px" BaseColumnName="RoutingNumber">
                                                        <Header Caption="Routing #">
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Header>
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn BaseColumnName="AccountNumber">
                                                        <Header Caption="Account #">
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Header>
                                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn BaseColumnName="Checking" Key="Checking" 
                                                        DataType="System.Boolean" >
                                                        <Header Caption="Check/Save">
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadBankID" DataType="System.Int32">
                                                        <Header Caption="LeadBankID">
                                                            <RowLayoutColumnInfo OriginX="4" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="4" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                </Columns>
                                                <AddNewRow View="NotSet" Visible="NotSet">
                                                </AddNewRow>
                                            </igtbl:UltraGridBand>
                                        </Bands>
                                        <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                            StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AutoGenerateColumns="False"
                                            AllowSortingDefault="Yes" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml" BorderCollapseDefault="Collapse">
                                            <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                            </FrameStyle>
                                            <Pager AllowPaging="false">
                                            </Pager>
                                            <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </FooterStyleDefault>
                                            <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </HeaderStyleDefault>
                                            <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                                Font-Names="Verdana" Font-Size="8pt">
                                                <Padding Left="3px" />
                                                <BorderDetails ColorLeft="White" ColorTop="White" />
                                            </RowStyleDefault>
                                            <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                            </SelectedRowStyleDefault>
                                            <AddNewBox>
                                                <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                                </BoxStyle>
                                            </AddNewBox>
                                            <ActivationObject BorderColor="Black" BorderWidth="">
                                            </ActivationObject>
                                            <FilterOptionsDefault>
                                                <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                                    CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px" Width="200px">
                                                    <Padding Left="2px" />
                                                </FilterDropDownStyle>
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                                <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                                    BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px">
                                                    <Padding Left="2px" />
                                                </FilterOperandDropDownStyle>
                                            </FilterOptionsDefault>
                                        </DisplayLayout>
                                    </igtbl:UltraWebGrid>
                                    <asp:SqlDataSource ID="dsBanks" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getBanks"
                                        SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter Name="applicantID" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Creditors</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <a id="lnkAddCreditors" runat="server" class="lnk" href="javascript:AddCreditors();">
                                        <img id="Img7" style="margin-right: 5;" src="~/images/16x16_trust.png" runat="server"
                                            border="0" align="absmiddle" />Add Creditors</a>
                                    <igtbl:UltraWebGrid ID="wGrdCreditors" runat="server"
                                        Browser="Xml" DataSourceID="dsCreditors" 
                                        DataKeyField="LeadCreditorInstance" >
                                        <Bands>
                                            <igtbl:UltraGridBand RowSelectors="No" AllowSorting="No" AllowDelete="No" AllowUpdate="No" DataKeyField="LeadCreditorInstance"
                                                BaseTableName="tblLeadCreditorInstance">
                                                <Columns>
                                                    <igtbl:TemplatedColumn Width="16px">
                                                        <CellTemplate>
                                                            <a href='javascript:RemoveCreditor(<%#DataBinder.Eval(Container.DataItem, "LeadCreditorInstance")%>);' title="Remove Creditor"><img runat="server" src="~/images/16x16_delete.png" style="border-style:none" /></a>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:UltraGridColumn Width="140px" BaseColumnName="Creditor">
                                                        <Header Caption="Creditor">
                                                        </Header>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <CellStyle Wrap="True">
                                                        </CellStyle>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:TemplatedColumn Width="100px">
                                                        <Header Caption="Account #">
                                                        </Header>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellTemplate>
                                                            <asp:TextBox ID="txtAccountNo" runat="server" CssClass="creditortxt" Text='<%# Bind("AccountNumber") %>'></asp:TextBox>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:TemplatedColumn Width="90px" BaseColumnName="Balance">
                                                        <Header Caption="Balance Due">
                                                        </Header>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellTemplate>
                                                            <asp:TextBox ID="txtBalance" runat="server" CssClass="creditortxt" Text='<%# Bind("Balance", "{0:c}") %>' style="text-align:right"></asp:TextBox>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadCreditorInstance" DataType="System.Int32">
                                                        <Header Caption="LeadCreditorInstance">
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="3" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:TemplatedColumn Width="85px" BaseColumnName="Phone">
                                                        <Header Caption="Phone">
                                                        </Header>
                                                        <CellTemplate>
                                                            <cc1:InputMask ID="txtCreditorPhone" runat="server" CssClass="creditortxt"
                                                                Mask="(nnn) nnn-nnnn" Text='<%# Bind("Phone") %>'></cc1:InputMask>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:TemplatedColumn Width="35px" BaseColumnName="Ext">
                                                        <Header Caption="Ext">
                                                        </Header>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <CellTemplate>
                                                            <asp:TextBox ID="txtExt" runat="server" CssClass="creditortxt" Text='<%# Bind("Ext") %>'></asp:TextBox>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="Street">
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="Street2">
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="City">
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="StateID">
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="ZipCode">
                                                    </igtbl:UltraGridColumn>
                                                </Columns>
                                                <AddNewRow View="NotSet" Visible="NotSet">
                                                </AddNewRow>
                                            </igtbl:UltraGridBand>
                                        </Bands>
                                        <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                            StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AllowSortingDefault="Yes"
                                            AutoGenerateColumns="False" HeaderClickActionDefault="SortSingle" 
                                            AllowDeleteDefault="No" BorderCollapseDefault="Collapse">
                                            <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                            </FrameStyle>
                                            <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </FooterStyleDefault>
                                            <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </HeaderStyleDefault>
                                            <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                                Font-Names="Verdana" Font-Size="8pt">
                                                <Padding Left="3px" />
                                                <BorderDetails ColorLeft="White" ColorTop="White" />
                                            </RowStyleDefault>
                                            <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                            </SelectedRowStyleDefault>
                                            <AddNewBox>
                                                <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                                </BoxStyle>
                                            </AddNewBox>
                                            <ActivationObject BorderColor="Black" BorderWidth="">
                                            </ActivationObject>
                                            <FilterOptionsDefault>
                                                <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                                    CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px" Width="200px">
                                                    <Padding Left="2px" />
                                                </FilterDropDownStyle>
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                                <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                                    BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px">
                                                    <Padding Left="2px" />
                                                </FilterOperandDropDownStyle>
                                            </FilterOptionsDefault>
                                        </DisplayLayout>
                                    </igtbl:UltraWebGrid>
                                    <asp:SqlDataSource ID="dsCreditors" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getCreditors"
                                        SelectCommandType="StoredProcedure" DeleteCommand="stp_enrollment_deleteCreditor"
                                        DeleteCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter Name="applicantID" Type="Int32" />
                                        </SelectParameters>
                                        <DeleteParameters>
                                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                            <asp:Parameter Name="creditorInstanceID" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <asp:Panel ID="pnlApplicant" runat="server">
                            <table class="window">
                                <tr>
                                    <td colspan="2">
                                        <h2>
                                            3. Primary</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Client:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="23" CssClass="entry" runat="server" ID="txtFirstName" Width="72px"></asp:TextBox>
                                        <asp:TextBox TabIndex="24" CssClass="entry" runat="server" ID="txtLastName" Width="75px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Address:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="25" CssClass="entry" runat="server" ID="txtAddress" Width="150px"
                                            BackColor="Gold"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        City:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="26" CssClass="entry" runat="server" ID="txtCity" Width="150px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        State/Zip:
                                    </td>
                                    <td>
                                        <asp:DropDownList TabIndex="27" CssClass="entry" runat="server" ID="cboStateID" Width="50px">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="entry" runat="server" TabIndex="27" ID="txtZip" Width="97px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Home Ph:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="28" ID="txtHomePhone" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                            <ButtonsAppearance>
                                                <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonStyle>
                                                <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonDisabledStyle>
                                            </ButtonsAppearance>
                                        </igtxt:WebMaskEdit>
                                        <img id="imgHomePhone" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtHomePhone.ClientId%>'), '<%= GetLeadId()%>');" style="cursor:hand" /> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Business Ph:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="29" ID="txtBusPhone" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                            <ButtonsAppearance>
                                                <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonStyle>
                                                <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonDisabledStyle>
                                            </ButtonsAppearance>
                                        </igtxt:WebMaskEdit>
                                        <img id="imgMakeCallB" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtBusPhone.ClientId%>'), '<%= GetLeadId()%>');" style="cursor:hand" /> 

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Cell Ph:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="30" ID="txtCellPhone" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="20px" Width="131px" InputMask="(###) ###-####" BackColor="Gold">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                            <ButtonsAppearance>
                                                <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonStyle>
                                                <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonDisabledStyle>
                                            </ButtonsAppearance>
                                        </igtxt:WebMaskEdit>
                                        <img id="imgMakeCallC" src='<%= ResolveUrl("~/images/phone2.png")%>' onclick="calluser(document.getElementById('<%= txtCellPhone.ClientId%>'), '<%= GetLeadId()%>');" style="cursor:hand" /> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Fax Number:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="31" ID="txtFaxNo" runat="server" Font-Names="Tahoma"
                                            Font-Size="8pt" Height="20px" Width="150px" InputMask="(###) ###-####" BackColor="Gold">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                            <ButtonsAppearance>
                                                <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonStyle>
                                                <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonDisabledStyle>
                                            </ButtonsAppearance>
                                        </igtxt:WebMaskEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        SSN:
                                    </td>
                                    <td>
                                        <igtxt:WebMaskEdit TabIndex="32" ID="txtSSN" runat="server" Font-Names="Tahoma" Font-Size="8pt"
                                            Height="20px" Width="150px" InputMask="###-##-####" BackColor="Gold">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                            <ButtonsAppearance>
                                                <ButtonStyle BackColor="#FFCC00" Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonStyle>
                                                <ButtonDisabledStyle Font-Names="Tahoma" Font-Size="8pt">
                                                </ButtonDisabledStyle>
                                            </ButtonsAppearance>
                                        </igtxt:WebMaskEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        DOB:
                                    </td>
                                    <td>
                                        <igtxt:WebDateTimeEdit TabIndex="33" ID="txtDOB" runat="server" BackColor="#FFCC00"
                                            DataMode="DateOrDBNull" Font-Names="Tahoma" Font-Size="8pt" Height="20px" Width="150px">
                                            <BorderDetails ColorBottom="#7F9DB9" ColorLeft="#7F9DB9" ColorRight="#7F9DB9" ColorTop="#7F9DB9"
                                                StyleBottom="Solid" StyleLeft="Solid" StyleRight="Solid" StyleTop="Solid" WidthBottom="1px"
                                                WidthLeft="1px" WidthRight="1px" WidthTop="1px" />
                                        </igtxt:WebDateTimeEdit>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Email Address:
                                    </td>
                                    <td>
                                        <asp:TextBox TabIndex="34" CssClass="entry" runat="server" ID="txtEmailAddress" Width="150px"
                                            BackColor="Gold"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Co-Applicants</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <a id="lnkAddCoApps" runat="server" class="lnk" href="javascript:AddCoApps();">
                                        <img id="Img3" style="margin-right: 5;" src="~/images/16x16_Person_add.png" runat="server"
                                            border="0" align="absmiddle" />Add Co-Applicant</a>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <igtbl:UltraWebGrid ID="wGrdCoApp" runat="server" Browser="Xml"
                                        DataKeyField="LeadCoApplicantID" DataSourceID="dsCoApp">
                                        <Bands>
                                            <igtbl:UltraGridBand DataKeyField="LeadCoApplicantID"
                                                RowSelectors="No">
                                                <Columns>
                                                    <igtbl:TemplatedColumn Width="16px">
                                                        <CellTemplate>
                                                            <a href='javascript:RemoveCoApp(<%#DataBinder.Eval(Container.DataItem, "LeadCoApplicantID")%>);' title="Remove Co-Applicant"><img runat="server" src="~/images/16x16_delete.png" style="border-style:none" /></a>
                                                        </CellTemplate>
                                                    </igtbl:TemplatedColumn>
                                                    <igtbl:UltraGridColumn BaseColumnName="Full Name">
                                                        <Header Caption="Co-applicant">
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Header>
                                                        <CellButtonStyle HorizontalAlign="Left">
                                                        </CellButtonStyle>
                                                        <HeaderStyle HorizontalAlign="Left" />
                                                        <CellStyle HorizontalAlign="Left">
                                                        </CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Type="CheckBox" BaseColumnName="AuthorizationPower"
                                                        DataType="System.Boolean" AllowUpdate="No">
                                                        <Header Caption="Can Authorize">
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Header>
                                                        <CellButtonStyle HorizontalAlign="Center">
                                                        </CellButtonStyle>
                                                        <CellStyle HorizontalAlign="Center">
                                                        </CellStyle>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="1" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                    <igtbl:UltraGridColumn Hidden="True" BaseColumnName="LeadCoApplicantID" DataType="System.Int32">
                                                        <Header Caption="LeadCoApplicantID">
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Header>
                                                        <Footer>
                                                            <RowLayoutColumnInfo OriginX="2" />
                                                        </Footer>
                                                    </igtbl:UltraGridColumn>
                                                </Columns>
                                                <AddNewRow View="NotSet" Visible="NotSet">
                                                </AddNewRow>
                                            </igtbl:UltraGridBand>
                                        </Bands>
                                        <DisplayLayout Name="UltraWebGrid1" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                                            StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" AllowSortingDefault="No"
                                            AutoGenerateColumns="False" HeaderClickActionDefault="SortMulti" LoadOnDemand="Xml"
                                            AllowDeleteDefault="No" AllowUpdateDefault="No" BorderCollapseDefault="Collapse">
                                            <FrameStyle BorderStyle="None" BorderWidth="0px" Cursor="Default">
                                            </FrameStyle>
                                            <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </FooterStyleDefault>
                                            <HeaderStyleDefault BackColor="SteelBlue" BorderStyle="Solid" ForeColor="White">
                                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                            </HeaderStyleDefault>
                                            <RowStyleDefault BackColor="White" BorderColor="Gray" BorderStyle="None" BorderWidth="0px"
                                                Font-Names="Verdana" Font-Size="8pt">
                                                <Padding Left="3px" />
                                                <BorderDetails ColorLeft="White" ColorTop="White" />
                                            </RowStyleDefault>
                                            <SelectedRowStyleDefault BackColor="#5796DE" ForeColor="White">
                                            </SelectedRowStyleDefault>
                                            <AddNewBox>
                                                <BoxStyle BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                                                </BoxStyle>
                                            </AddNewBox>
                                            <ActivationObject BorderColor="Black" BorderWidth="">
                                            </ActivationObject>
                                            <FilterOptionsDefault>
                                                <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                                    CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px" Width="200px">
                                                    <Padding Left="2px" />
                                                </FilterDropDownStyle>
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                                <FilterOperandDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid"
                                                    BorderWidth="1px" CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                                    Font-Size="11px">
                                                    <Padding Left="2px" />
                                                </FilterOperandDropDownStyle>
                                            </FilterOptionsDefault>
                                        </DisplayLayout>
                                    </igtbl:UltraWebGrid>
                                    <asp:SqlDataSource ID="dsCoApp" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        ProviderName="System.Data.SqlClient" SelectCommand="stp_enrollment_getCoApps"
                                        SelectCommandType="StoredProcedure" DeleteCommand="stp_enrollment_deleteCoApp"
                                        DeleteCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter Name="applicantID" Type="Int32" />
                                        </SelectParameters>
                                        <DeleteParameters>
                                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                            <asp:Parameter Name="coAppID" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
    <!--buttons to refresh when dialogs close-->
    <asp:LinkButton ID="btnNotesRefresh" runat="server" />
    <asp:LinkButton ID="btnBankRefresh" runat="server" />
    <asp:LinkButton ID="btnCoAppRefresh" runat="server" />
    <asp:LinkButton ID="btnRemoveCoApp" runat="server" />
    <asp:LinkButton ID="btnRemoveBank" runat="server" />
    <asp:LinkButton ID="btnRemoveCreditor" runat="server" />
    <asp:LinkButton ID="btnCreditorRefresh" runat="server" />
    <asp:LinkButton ID="btnSaveAndNoEndPage" runat="server" />
    <asp:HiddenField ID="hdnCallIdKey" runat="server" />
    <asp:HiddenField ID="hdnLeadApplicantID" runat="server" />
    <asp:HiddenField ID="hdnLeadCoApplicantID" runat="server" />
    <asp:HiddenField ID="hdnLeadBankID" runat="server" />
    <asp:HiddenField ID="hdnLeadCreditorInstance" runat="server" />
    <asp:HiddenField ID="hdnCallId" runat="server" />
    <asp:HiddenField ID="hdnDnis" runat="server" />
    <asp:HiddenField ID="hdnAni" runat="server" />
    <asp:HiddenField ID="hdnCreditorInfo" runat="server" />
    <asp:HiddenField ID="hdnClientStatus" runat="server" />
    <asp:HiddenField ID="hdnAssignedTo" runat="server" />
   
  </asp:Content>
 
