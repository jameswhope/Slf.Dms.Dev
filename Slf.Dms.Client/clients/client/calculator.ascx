<%@ Control Language="VB" AutoEventWireup="false" CodeFile="calculator.ascx.vb" Inherits="Clients_client_calculator" %>
<script src="<%= ResolveUrl("~/jscript/validation/Display.js") %>" type="text/javascript"></script>
<style type="text/css">
.calculator    
{
    font-family: tahoma;
    font-size: 11px;
    table-layout: fixed;  
    width: 540px;
    height: 230px;
    }
.calculator td
{
    padding: 0;
}
.calculator h2
{
    background-color: SteelBlue;
    height:19px;
    font-weight: bold;
    font-family: tahoma;
    font-size: 11px;
    color: #fff;
    text-align: center;
    padding: 2px;
    margin: 0;
}
.calculator h3
{
    height:15px;
    padding: 3px;
    background-color: #ADD8E6;
    font-weight: bold ;
    font-family: tahoma;
    font-size: 11px;
    margin: 0;
    white-space: nowrap;
}

.entryin
{
    font-family: tahoma;
    font-size: 11px;
    width: 130px;
    border: solid 1px #7F9DB9;
    height: 19px;
}
.calculator span
{
	float:right;
	height:18px;
}
.green
{
    background-color: LawnGreen;
    height: 19px;
    padding: 2px;
    width: 132px;
    color: Black;
}

.orange
{
    background-color: orange;
    height: 19px;
    padding: 2px;
    width: 132px;
    color: Black; 
}

.red
{
    background-color: red;
    height: 19px;
    padding: 2px;
    width: 132px;
    color: Yellow; 
}

.calculator h4
{
    padding: 3px;
    font-weight: normal;
    font-family: tahoma;
    font-size: 11px;
    margin: 0;
    white-space: nowrap;
    height:19px;

}
.calculatorh5
{
    padding: 0;
    font-weight: bold;
    font-family: tahoma;
    font-size: 11px;
    color: Yellow;
    text-align: center;
    margin: 0;
    width: 50%;
    background-color: SteelBlue;
    height: 22px;
}
</style>
<script type="text/javascript">
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
            //if (TotalDebt<5000){
            //    return;
            //}

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

function InitFocus()
{
   document.getElementById("<%= txtTotalDebt.ClientID %>").focus(); 
}

</script> 

<table class="calculator">
    <tr>
        <td colspan="2">
            <h2>&nbsp;</h2>
        </td>
        <td>
            <h2>Final Numbers</h2>
        </td>
        <td>
            <h2>Recommendation</h2>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <h3>Total Debt:</h3>
        </td>
        <td>
            <asp:TextBox TabIndex="1000" CssClass="entryin" runat="server" ID="txtTotalDebt"
                BackColor="Gold" Style="text-align: right;" reqSave="True" 
                valCap="Total Debt" valFun="IsValidCurrency(Input.value);" onkeyup=""  Width="130px"></asp:TextBox>
        </td>
        <td align="center">
            <asp:Label Text="Debt Settlement" Font-Bold="True" runat="server" ID="lblDebtSettle"
                CssClass="green"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <h4>
                Settlement %:</h4>
        </td>
        <td>
            <asp:DropDownList TabIndex="1001" CssClass="entryin" runat="server" ID="ddlSettlementPct"
                 BackColor="Gold">
            </asp:DropDownList>
        </td>
        <td >
            <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblSettlementPct2"></asp:Label>
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
            <asp:DropDownList TabIndex="1002" CssClass="entryin" runat="server" ID="ddlMaintenanceFee"
                 BackColor="Gold" DataTextFormatString="{0:#,###,##0.00}">
            </asp:DropDownList>
        </td>
        <td>
            <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblMaintenanceFeeTotal"></asp:Label>
        </td>
        <td align="center">
            <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblCurrentMonthly"
                ></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <h4>
                Subsequent Maint. Fee $:</h4>
        </td>
        <td>
            <asp:DropDownList CssClass="entryin" runat="server" ID="ddlSubMaintenanceFee" 
                BackColor="Gold" TabIndex="1004" DataTextFormatString="{0:#,###,##0.00}">
            </asp:DropDownList>
        </td>
        <td>
            <asp:Label CssClass="green" Style="text-align: right;" runat="server" ID="lblSubMaintenanceFee"></asp:Label>
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
            <asp:DropDownList TabIndex="1005" CssClass="entryin" runat="server" ID="ddlSettlementFee"
                 BackColor="Gold">
            </asp:DropDownList>
        </td>
        <td>
            <asp:Label CssClass="green" Font-Bold="False" Style="text-align: right;"
                runat="server" ID="lblSettlementFee"></asp:Label>
        </td>
        <td align="center">
            <asp:Label CssClass="green" Font-Bold="False" Style="text-align: right;"
                runat="server" ID="txtNominalDeposit" ></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <h4>
                Total Settlement + Fees:</h4>
        </td>
        <td>
            <asp:Label CssClass="green" Font-Bold="False" Style="text-align: right;"
                runat="server" ID="txtSettlementFees" ></asp:Label>
        </td>
        <td>
            <h2>
                Deposit Range</h2>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <h3>Initial Deposit:</h3>
        </td>
        <td>
            <asp:TextBox TabIndex="1006" Style="text-align: right;" CssClass="entryin" runat="server"
                ID="txtDownPmt" BackColor="Gold" Width="130px"></asp:TextBox>
        </td>
        <td>
            <asp:Label ID="Label1" class="calculatorh5"  runat="server">High</asp:Label> 
            <asp:Label ID="Label2" class="calculatorh5"  runat="server">Low</asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <h4>
                Deposit Committment:</h4>
        </td>
        <td>
            <asp:TextBox TabIndex="1008" CssClass="entryin" runat="server" ID="txtDepositComitmment"
                Style="text-align: right;" BackColor="Gold" Width="130px"></asp:TextBox>
        </td>
        <td nowrap="nowrap">
            <asp:Label BackColor="LawnGreen" Font-Bold="False" runat="server" 
                ID="lblHighAmt" Height="20px"
                    Style="text-align: center;" Width="50%"></asp:Label>
            <asp:Label BackColor="Red"  
                ForeColor="Yellow" Font-Bold="False" 
                Style="text-align: center;" runat="server" ID="lblLowAmt" 
                Height="20px" Width="50%"></asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <h3>
                Term (Years):</h3>
        </td>
        <td>
            <asp:Label CssClass="green" Font-Bold="False" Style="text-align: center;"
                runat="server" ID="txtTerm" ></asp:Label>
        </td>
        <td>&nbsp;</td>
    </tr>
    </table>
               