<%@ Page Language="VB" AutoEventWireup="false" CodeFile="termsInService.aspx.vb"
    Inherits="Clients_Enrollment_creditpackage_termsInService" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        table
        {
            width: 100%;
            border-spacing: 0.5rem;
            border-collapse: collapse;
        }
        td
        {
            border: 1px solid black;
        }
        p
        {
            font-size: 12px;
        }
        h1
        {
            font-size: 28px;
            margin: 20px 0px 20px 0px;
        }
        h2
        {
            font-size: 24px;
            margin: -20px 0px 10px 0px;
        }
        
        .center
        {
            text-align: center;
        }
        .left
        {
            text-align: left;
        }
        .right
        {
            text-align: right;
        }
        .top
        {
            vertical-align: top;
        }
        
        .bold
        {
            font-weight: bold;
        }
        .underline
        {
            text-decoration: underline;
        }
        .noBorder
        {
            border: 0px;
        }
        
        .f10
        {
            font-size: 10px;
        }
        .f12
        {
            font-size: 12px;
        }
        .f14
        {
            font-size: 14px;
        }
        
        .blackBG
        {
            background-color: #000;
        }
        .greyBG
        {
            background-color: #f0f0f0;
        }
        .whiteF
        {
            color: #fff;
        }
        
        .marginT
        {
            margin-top: 8px;
        }
        
        .firstColumn
        {
            width: 16%; /*140px*/
        }
        
        .calculateDefinition
        {
            width: 21%    
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="container" class="center">
        <h1>
            TRUTH-IN-SERVICE DISCLOSURE STATEMENT</h1>
        <h2>
            Regarding Our Non-Litigation, Litigation and Debt Settlement Services</h2>
        <!--General Inforamtion-->
        <table id="tblClientInfo" class="f14">
            <tr>
                <td class="right top bold noBorder">
                    Client(s):&nbsp;
                </td>
                <td class="left top noBorder">
                    <asp:Label ID="clientsNames" runat="server" />
                </td>
                <td class="right top bold noBorder">
                    Law Firm:&nbsp;
                </td>
                <td class="left top noBorder">
                    <asp:Label ID="LawFirmName" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="right top bold noBorder">
                    Mailing Address:&nbsp;
                </td>
                <td class="left top noBorder">
                    <asp:Label ID="Address1" runat="server" />
                </td>
                <td class="right top bold noBorder">
                    Prepared By:&nbsp;
                </td>
                <td class="left top noBorder">
                    <asp:Label ID="AgentName" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="right top bold noBorder">
                </td>
                <td class="left top noBorder">
                    <asp:Label ID="CityStateZip" runat="server" />
                </td>
                <td class="right top bold noBorder">
                    Date Prepared:&nbsp;
                </td>
                <td class="left top noBorder">
                    <%= Date.Now %>
                </td>
            </tr>
        </table>
        <!--Disclaimer-->
        <p>
            We will be providing you with fee-based non-litigation and litigation services (where
            you pay an initial and a monthly fee) and contingent fee debt settlement services
            (where you pay us only if we settle a debt). Even though these are separate services,
            we want you to know the true potential cost of our representation over time, and
            what your possible savings may be. PLEASE REVIEW THIS DOCUMENT CAREFULLY.</p>
        <!--MinimumPayments-->
        <div class="blackBG whiteF">
            Minimum Payments Example(1)</div>
        <!--Minimum Payments Breakdown-->
        <table class="marginT">
            <tr class="f14 blackBG whiteF">
                <td>
                    Total Principle(2)
                </td>
                <td>
                    Total Interest(3)
                </td>
                <td>
                    Total Amount Paid(4)
                </td>
                <td>
                    Number of Months(5)
                </td>
                <td>
                    Number of Years(6)
                </td>
            </tr>
            <tr class="f12">
                <td>
                    <asp:label ID="TotalDebt" runat="server" />
                </td>
                <td>
                    <asp:label ID="TotalInterest" runat="server" />
                </td>
                <td>
                    <asp:label ID="TotalPaid" runat="server" />
                </td>
                <td>
                    <asp:label ID="MinMonths" runat="server" />
                </td>
                <td>
                    <asp:label ID="MinYears" runat="server" />
                </td>
            </tr>
        </table>
        <table class="marginT">
            <tr class="f14 blackBG whiteF">
                <td colspan="2">
                    Settlement Example(7)(8)
                </td>
            </tr>
            <tr class="f12">
                <td>
                    ORIGINAL BALANCE(2)<br />
                    <asp:label ID="TotalDebt2" runat="server" />
                </td>
                <td>
                    TARGET DEBTS(9)<br />
                    <asp:label ID="TotalNumberOfDebts" runat="server" />
                </td>
            </tr>
        </table>
        <!--Calculation-->
        <table class="f12 marginT">
            <tr>
                <td class="firstColumn blackBG whiteF">
                    Your Deposit Will Be:
                </td>
                <td colspan="4">
                    If Your Creditors Accept:
                </td>
            </tr>
            <tr>
                <td class="firstColumn blackBG whiteF">
                    <asp:Label ID="One_MonthlyDeposit" runat="server" />
                    a month
                </td>
                <td class=" blackBG whiteF calculateDefinition">
                    25%
                </td>
                <td class=" blackBG whiteF calculateDefinition">
                    50%
                </td>
                <td class=" blackBG whiteF calculateDefinition">
                    75%
                </td>
                <td class=" blackBG whiteF calculateDefinition">
                    100%
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Settlement Amount(10)
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_25_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_50_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_75_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_100_SettleAmount" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Total Settlement Cost(11)
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_25_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_50_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_75_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="One_100_SettleCost" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number Of Months(12)
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_25_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_50_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_75_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_100_Months" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number of Years(13)
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_25_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_50_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_75_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="One_100_Years" runat="server" />
                </td>
            </tr>
        </table>
        <table class="f12 marginT">
            <tr>
                <td class="firstColumn blackBG whiteF">
                    Your Deposit Will Be:
                </td>
                <td colspan="4">
                    If Your Creditors Accept:
                </td>
            </tr>
            <tr>
                <td class="firstColumn blackBG whiteF">
                    <asp:Label ID="Two_MonthlyDeposit" runat="server" />
                    a month
                </td>
                <td class=" blackBG whiteF">
                    25%
                </td>
                <td class=" blackBG whiteF">
                    50%
                </td>
                <td class=" blackBG whiteF">
                    75%
                </td>
                <td class=" blackBG whiteF">
                    100%
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Settlement Amount(10)
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_25_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_50_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_75_SettleAmount" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_100_SettleAmount" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Total Settlement Cost(11)
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_25_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_50_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_75_SettleCost" runat="server" />
                </td>
                <td class="right calculateDefinition">
                    <asp:Label ID="Two_100_SettleCost" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number Of Months(12)
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_25_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_50_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_75_Months" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_100_Months" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number of Years(13)
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_25_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_50_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_75_Years" runat="server" />
                </td>
                <td class="calculateDefinition">
                    <asp:Label ID="Two_100_Years" runat="server" />
                </td>
            </tr>
        </table>
        <table class="f12 marginT">
            <tr>
                <td class="firstColumn blackBG whiteF">
                    Your Deposit Will Be:
                </td>
                <td colspan="4">
                    If Your Creditors Accept:
                </td>
            </tr>
            <tr>
                <td class="firstColumn blackBG whiteF">
                    <asp:Label ID="Three_MonthlyDeposit" runat="server" />
                    a month
                </td>
                <td class=" blackBG whiteF">
                    25%
                </td>
                <td class=" blackBG whiteF">
                    50%
                </td>
                <td class=" blackBG whiteF">
                    75%
                </td>
                <td class=" blackBG whiteF">
                    100%
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Settlement Amount(10)
                </td>
                <td class="right">
                    <asp:Label ID="Three_25_SettlementAmount" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_50_SettlementAmount" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_75_SettlementAmount" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_100_SettlementAmount" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Total Settlement Cost(11)
                </td>
                <td class="right">
                    <asp:Label ID="Three_25_SettlementCost" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_50_SettlementCost" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_75_SettlementCost" runat="server" />
                </td>
                <td class="right">
                    <asp:Label ID="Three_100_SettlementCost" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number Of Months(12)
                </td>
                <td>
                    <asp:Label ID="Three_25_Months" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_50_Months" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_75_Months" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_100_Months" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="firstColumn left">
                    Number of Years(13)
                </td>
                <td>
                    <asp:Label ID="Three_25_Years" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_50_Years" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_75_Years" runat="server" />
                </td>
                <td>
                    <asp:Label ID="Three_100_Years" runat="server" />
                </td>
            </tr>
        </table>
        <!--Disclaimer-->
        <p class="left">
            <strong>THIS TRUTH-IN-SERVICE DISCLOSURE STATEMENT IS A PROJECTION ONLY. ACTUAL RESULTS
                MAY VARY.</strong> All figures in this statement are calculated based on many
            estimates including but not limited to accuracy of deposits, payments, interest
            rates, balances, the actual sequence of settlements, monthly legal fees, estimated
            settlement percentages and contingency fees. Our representation does not release
            you of your debts or obligations to your creditors but rather attempts to negotiate
            an agreeable lump sum settlement between you and your creditors. Negotiations are
            made in good faith and for that reason the law firm cannot predict or guarantee
            the success or any specific results or outcomes of any settlement. No specific outcome
            is predicted or guaranteed. Past settlement results are not an indication of future
            results. This statement is being provided for illustrative purposes only. The results
            shown in this statement are not guaranteed and may vary from your actual results.
        </p>
    </div>
    </form>
</body>
</html>
