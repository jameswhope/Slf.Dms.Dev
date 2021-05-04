<%@ Control Language="VB" AutoEventWireup="false" CodeFile="hardshipControl.ascx.vb"
    Inherits="hardshipControl" %>
<style type="text/css">
    .captionCell {
        height: 25px;
        font-size: 16px;
        font-weight: bold;
        border-bottom: solid 1px black;
        padding-bottom: 10px;
    }

    .sectionCell {
        font-size: 14px;
        font-weight: bold;
        border-bottom: solid 1px black;
        padding: 5px;
        background-color: #D6E7F3;
        background-image: url(../../../images/menubacksmall.bmp);
        border-left: rgb(112,168,209) 1px solid;
        padding-left: 8px;
        background-repeat: repeat-x;
        background-position: left top;
    }

        .sectionCell a {
            color: black;
            background: none;
            text-decoration: none;
        }

            .sectionCell a:hover {
                background: none;
                text-decoration: underline;
            }

    .sectionCellSelected {
        height: 25px;
        font-size: 14px;
        font-weight: bold;
        color: White;
        background-color: #3376AB;
        border-bottom: solid 1px black;
        padding: 5px;
        border: solid 1px #3D3D3D;
        filter: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr='#F3F3F3', EndColorStr='#3376AB');
    }

        .sectionCellSelected a {
            color: Black;
            background: none;
            text-decoration: none;
        }

    .sectionContent {
        background-color: #F0F5FB;
        border: 1px inset #C6DEF2;
        border-top: none;
        padding: 5px;
        padding-top: 10px;
    }

    .subSectionCell {
        border-bottom: solid 1px black;
        font-weight: bold;
        font-style: italic;
    }

    .groupCell {
        padding: 5px;
        font-weight: bold;
        background-color: #DCDCDC;
        font-style: italic;
    }

    .groupLastCell {
        padding: 5px;
        font-weight: bold;
        background-color: #DCDCDC;
        border-left: dotted 1px black;
        font-style: italic;
    }

    .cellHeader {
        text-align: right;
    }

    .headItem5 {
        background-color: #DCDCDC;
        border-bottom: solid 1px #d3d3d3;
        font-weight: normal;
        color: Black;
        font-size: 11px;
        font-family: tahoma;
    }

        .headItem5 a {
            text-decoration: none;
            display: block;
            color: Black;
            font-weight: 200;
        }
</style>

<script type="text/javascript">

    window.onload = function () {
        addIncomeTotal();
        addAssetsTotal();
        addExpensesTotal();
    };

    function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode

        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            alert('Please enter only numeric text (ie. 0123456789)!');
            return false;
        } else {
            return true;
        }
    }
    function isCurrencyKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode

        if (charCode == 44) {
            return true;
        }
        if (charCode == 46) {
            return true;
        }

        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            alert('Please enter only currency values (ie. 5,768.34)!');
            return false;
        } else {
            return true;
        }
    }

    function addIncomeTotal() {
        document.getElementById('<%= MonthlyIncome_TotalMonthlyIncomeTextBox.ClientID %>').value = 0;
        var num1 = document.getElementById('<%= MonthlyIncome_Client_WorkTextBox.ClientID %>').value;
        num1 = parseFloat(num1.replace(/\,/g, ''));
        var num2 = document.getElementById('<%= MonthlyIncome_Client_SocialSecurityTextBox.ClientID %>').value;
        num2 = parseFloat(num2.replace(/\,/g, ''));
        var num3 = document.getElementById('<%= MonthlyIncome_Client_DisabilityTextBox.ClientID %>').value;
        num3 = parseFloat(num3.replace(/\,/g, ''));
        var num4 = document.getElementById('<%= MonthlyIncome_Client_RetirementPensionTextBox.ClientID %>').value;
        num4 = parseFloat(num4.replace(/\,/g, ''));
        var num5 = document.getElementById('<%= MonthlyIncome_Client_SelfEmployedTextBox.ClientID %>').value;
        num5 = parseFloat(num5.replace(/\,/g, ''));
        var num6 = document.getElementById('<%= MonthlyIncome_Client_UnemployedTextBox.ClientID %>').value;
        num6 = parseFloat(num6.replace(/\,/g, ''));
        var num7 = document.getElementById('<%= MonthlyIncome_Spouse_WorkTextBox.ClientID %>').value;
        num7 = parseFloat(num7.replace(/\,/g, ''));
        var num8 = document.getElementById('<%= MonthlyIncome_Spouse_SocialSecurityTextBox.ClientID %>').value;
        num8 = parseFloat(num8.replace(/\,/g, ''));
        var num9 = document.getElementById('<%= MonthlyIncome_Spouse_DisabilityTextBox.ClientID %>').value;
        num9 = parseFloat(num9.replace(/\,/g, ''));
        var num10 = document.getElementById('<%= MonthlyIncome_Spouse_RetirementPensionTextBox.ClientID %>').value;
        num10 = parseFloat(num10.replace(/\,/g, ''));
        var num11 = document.getElementById('<%= MonthlyIncome_Spouse_SelfEmployedTextBox.ClientID %>').value;
        num11 = parseFloat(num11.replace(/\,/g, ''));
        var num12 = document.getElementById('<%= MonthlyIncome_Spouse_UnemployedTextBox.ClientID %>').value;
        num12 = parseFloat(num12.replace(/\,/g, ''));

        var total = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10 + num11 + num12;
        document.getElementById('<%= MonthlyIncome_TotalMonthlyIncomeTextBox.ClientID %>').value = parseFloat(total).toFixed(2);
    }

    function addAssetsTotal() {
        document.getElementById('<%= totalAssetIncomeTextBox.ClientID %>').value = 0;
        var num1 = document.getElementById('<%= MonthlyIncome_Client_Retirement401kTextBox.ClientID %>').value;
        num1 = parseFloat(num1.replace(/\,/g, ''));
        var num2 = document.getElementById('<%= MonthlyIncome_Client_SavingsCheckingsTextBox.ClientID %>').value;
        num2 = parseFloat(num2.replace(/\,/g, ''));
        var num3 = document.getElementById('<%= MonthlyIncome_Client_OtherAssetsTextBox.ClientID %>').value;
        num3 = parseFloat(num3.replace(/\,/g, ''));
        var num4 = document.getElementById('<%= MonthlyIncome_Client_OtherDebtsTextBox.ClientID %>').value;
        num4 = parseFloat(num4.replace(/\,/g, ''));
        var num5 = document.getElementById('<%= MonthlyIncome_Spouse_Retirement401kTextBox.ClientID %>').value;
        num5 = parseFloat(num5.replace(/\,/g, ''));
        var num6 = document.getElementById('<%= MonthlyIncome_Spouse_OtherAssetsTextBox.ClientID %>').value;
        num6 = parseFloat(num6.replace(/\,/g, ''));
        var num7 = document.getElementById('<%= MonthlyIncome_Spouse_OtherDebtsTextBox.ClientID %>').value;
        num7 = parseFloat(num7.replace(/\,/g, ''));
        var num8 = document.getElementById('<%= MonthlyIncome_Spouse_SavingsCheckingsTextBox.ClientID %>').value;
        num8 = parseFloat(num8.replace(/\,/g, ''));

        var total = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8;
        document.getElementById('<%= totalAssetIncomeTextBox.ClientID %>').value = parseFloat(total).toFixed(2);

    }

    function addExpensesTotal() {
        document.getElementById('<%= Monthly_TotalExpensesTextBox.ClientID %>').value = 0;
        document.getElementById('<%= IncomeAfterExpensesTextBox.ClientID %>').value = 0;
        var num1 = document.getElementById('<%= MonthlyExpenses_RentTextBox.ClientID %>').value;
        num1 = parseFloat(num1.replace(/\,/g, ''));
        var num2 = document.getElementById('<%= MonthlyExpenses_MortgageTextBox.ClientID %>').value;
        num2 = parseFloat(num2.replace(/\,/g, ''));
        var num3 = document.getElementById('<%= MonthlyExpenses_2ndMortgageAmtTextBox.ClientID %>').value;
        num3 = parseFloat(num3.replace(/\,/g, ''));
        var num4 = document.getElementById('<%= MonthlyExpenses_CarpaymentTextBox.ClientID %>').value;
        num4 = parseFloat(num4.replace(/\,/g, ''));
        var num5 = document.getElementById('<%= MonthlyExpenses_CarInsuranceTextBox.ClientID %>').value;
        num5 = parseFloat(num5.replace(/\,/g, ''));
        var num6 = document.getElementById('<%= MonthlyExpenses_UtilitiesTextBox.ClientID %>').value;
        num6 = parseFloat(num6.replace(/\,/g, ''));
        var num7 = document.getElementById('<%= MonthlyExpenses_GroceriesTextBox.ClientID %>').value;
        num7 = parseFloat(num7.replace(/\,/g, ''));
        var num8 = document.getElementById('<%= MonthlyExpenses_DiningOutTextBox.ClientID %>').value;
        num8 = parseFloat(num8.replace(/\,/g, ''));
        var num9 = document.getElementById('<%= MonthlyExpenses_EntertainmentTextBox.ClientID %>').value;
        num9 = parseFloat(num9.replace(/\,/g, ''));
        var num10 = document.getElementById('<%= MonthlyExpenses_MedicalInsuranceTextBox.ClientID %>').value;
        num10 = parseFloat(num10.replace(/\,/g, ''));
        var num11 = document.getElementById('<%= MonthlyExpenses_MedicationsTextBox.ClientID %>').value;
        num11 = parseFloat(num11.replace(/\,/g, ''));
        var num12 = document.getElementById('<%= MonthlyExpenses_GasolineTextBox.ClientID %>').value;
        num12 = parseFloat(num12.replace(/\,/g, ''));
        var num13 = document.getElementById('<%= MonthlyExpenses_SchoolLoansTextBox.ClientID %>').value;
        num13 = parseFloat(num13.replace(/\,/g, ''));
        var num14 = document.getElementById('<%= MonthlyExpenses_HomeInsuranceTextBox.ClientID %>').value;
        num14 = parseFloat(num14.replace(/\,/g, ''));
        var num15 = document.getElementById('<%= MonthlyExpenses_PhoneTextBox.ClientID %>').value;
        num15 = parseFloat(num15.replace(/\,/g, ''));
        var num16 = document.getElementById('<%= MonthlyExpenses_OtherTextBox.ClientID %>').value;
        num16 = parseFloat(num16.replace(/\,/g, ''));
        var num17 = document.getElementById('<%= MonthlyExpenses_SchoolExpensesTextBox.ClientID %>').value;
        num17 = parseFloat(num17.replace(/\,/g, ''));
        var num18 = document.getElementById('<%= MonthlyExpenses_lawfirmTextBox.ClientID %>').value;
        num18 = parseFloat(num18.replace(/\,/g, ''));
        var num19 = document.getElementById('<%= MonthlyExpenses_loansTextBox.ClientID %>').value;
        num19 = parseFloat(num19.replace(/\,/g, ''));
        var num20 = document.getElementById('<%= MonthlyExpenses_creditcardsTextBox.ClientID %>').value;
        num20 = parseFloat(num20.replace(/\,/g, ''));
        var num21 = document.getElementById('<%= MonthlyExpenses_Other2TextBox.ClientID %>').value;
        num21 = parseFloat(num21.replace(/\,/g, ''));
        var num22 = document.getElementById('<%= MonthlyExpenses_Other3TextBox.ClientID %>').value;
        num22 = parseFloat(num22.replace(/\,/g, ''));

        var total = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10 + num11 + num12 + num13 + num14 + num15 + num16 + num17 + num18 + num19 + num20 + num21 + num22;
        document.getElementById('<%= Monthly_TotalExpensesTextBox.ClientID %>').value = parseFloat(total).toFixed(2);
        var after = document.getElementById('<%= MonthlyIncome_TotalMonthlyIncomeTextBox.ClientID %>').value - document.getElementById('<%= Monthly_TotalExpensesTextBox.ClientID %>').value;
        document.getElementById('<%= IncomeAfterExpensesTextBox.ClientID %>').value = after;
    }

</script>

<ajaxToolkit:TabContainer ID="tcHistory" runat="server" CssClass="tabcontainer" ActiveTabIndex="0">
    <ajaxToolkit:TabPanel ID="tabHard" runat="server">
        <HeaderTemplate>
            Enter Client HardShip Form
        </HeaderTemplate>
        <ContentTemplate>
            <table cellpadding="0" cellspacing="0" class="entry">

                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" class="entry2">
                            <tr>
                                <td style="padding: 5px;">Married
                                    <asp:CheckBox ID="MarriedCheckBox" runat="server" Checked='<%# Bind("Married") %>' />
                                    Single
                                    <asp:CheckBox ID="SingleCheckBox" runat="server" Checked='<%# Bind("Single") %>' />
                                    Divorced
                                    <asp:CheckBox ID="DivorcedCheckBox" runat="server" Checked='<%# Bind("Divorced") %>' />
                                    Widowed
                                    <asp:CheckBox ID="WidowedCheckBox" runat="server" Checked='<%# Bind("Widowed") %>' />
                                </td>
                                <tr>

                                    <td style="padding: 5px;">Number of Children in Household:
                                    <asp:TextBox ID="NumChildrenTextBox" runat="server" Text='<%# Bind("NumChildren") %>'
                                        CssClass="entry2" Width="25" onkeypress="return isNumberKey(event)" />
                                        Number Grand Children in Household:
                                    <asp:TextBox ID="NumGrandChildrenTextBox" runat="server" Text='<%# Bind("NumGrandChildren") %>'
                                        CssClass="entry2" Width="25" onkeypress="return isNumberKey(event)" />
                                    </td>
                                </tr>
                            </tr>
                            <tr>
                                <td style="padding: 5px;">Behind:
                                    <asp:DropDownList ID="ddlBehind" runat="server" Width="150px">
                                        <asp:ListItem Text="" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Not Behind" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Current 0-Months" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="1 - 3 Months" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="3 - 6 Months" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="More than 6 months" Value="5"></asp:ListItem>
                                    </asp:DropDownList>
                                    Concerns:
                                    <asp:DropDownList ID="ddlConcerns" runat="server" Width="150px">
                                        <asp:ListItem Text="" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Creditor Phone Calls" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Only making minimum" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="Not getting out of debt" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="Unable to keep up" Value="4"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px;">Hardship: 
                                    <asp:DropDownList ID="ddlHardship" runat="server" Width="150px">
                                        <asp:ListItem Text="" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Divorce" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Death of spouse" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="Loss of job" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="Unable to keep up" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="Raised Int/Mthly pymt" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="Cut in hours" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="Medical Hardship" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="Other" Value="8"></asp:ListItem>
                                    </asp:DropDownList>
                                    Own/Rent:
                                    <asp:DropDownList ID="ddlOwnRent" runat="server" Width="150px">
                                        <asp:ListItem Text="" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Own" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Rent" Value="2"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        <ajaxToolkit:Accordion ID="accMain" runat="server" HeaderCssClass="accordion_Header" ContentCssClass="accordion_Content"
                            HeaderSelectedCssClass="accordion_HeaderSelected" SuppressHeaderPostbacks="true" SelectedIndex="0"
                            FadeTransitions="true" FramesPerSecond="40" TransitionDuration="250" AutoSize="None" Height="450px">
                            <Panes>
                                <ajaxToolkit:AccordionPane ID="pIncome" runat="server">
                                    <Header>
                                        <a href="">Monthly Income</a>
                                    </Header>
                                    <Content>
                                        <table class="entry2" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="groupCell">Client Income
                                                </td>
                                                <td class="groupLastCell">Spouse Income
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="cellHeader">Work
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_WorkTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_Work","{0:n2}") %>' Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Social Security
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_SocialSecurityTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_SocialSecurity", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Disability
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_DisabilityTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_Disability", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Retirement/Pension
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_RetirementPensionTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_RetirementPension", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>                                                        
                                                        <tr>
                                                            <td class="cellHeader">Self Employed
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_SelfEmployedTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_SelfEmployed", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Unemployed
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Client_UnemployedTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_Unemployed", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 15px; border-left: dotted 1px black">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="cellHeader">Work
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_WorkTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_Work", "{0:n2}") %>' Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Social Security
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_SocialSecurityTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_SocialSecurity", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Disability
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_DisabilityTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_Disability", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Retirement/Pension
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_RetirementPensionTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_RetirementPension", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>                                                        
                                                        <tr>
                                                            <td class="cellHeader">Self Employed
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_SelfEmployedTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_SelfEmployed", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Unemployed
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addIncomeTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_UnemployedTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_Unemployed", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <tr>
                                                    <td class="cellHeader">Total Income:
                                                    </td>
                                                    <td>$<asp:TextBox ReadOnly="true" CssClass="entry2" ID="MonthlyIncome_TotalMonthlyIncomeTextBox"
                                                        runat="server" Text='<%# Bind("MonthlyIncome_TotalMonthlyIncome", "{0:n2}") %>'
                                                        Width="75px" />
                                                    </td>
                                                </tr>
                                            </tr>
                                            <tr>
                                                <td class="groupCell">Client Assets
                                                </td>
                                                <td class="groupLastCell">Spouse Assets
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="cellHeader">Retirement/401k
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Client_Retirement401kTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_401k", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Savings/Checkings
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Client_SavingsCheckingsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_Savings", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Other Assets
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Client_OtherAssetsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_Other", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Assets Description
                                                            </td>
                                                            <td>
                                                                <asp:TextBox CssClass="entry2" ID="MonthlyIncome_Client_OtherAssetsDescribeTextBox"
                                                                    runat="server" Text='<%# Bind("MonthlyIncome_Client_DescribeOther") %>'
                                                                    Width="100px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Other Debts
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Client_OtherDebtsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Client_OtherDebts", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        
                                                    </table>
                                                </td>
                                                <td style="padding-left: 15px; border-left: dotted 1px black">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="cellHeader">Retirement/401k
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_Retirement401kTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_401k", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Savings/Checkings
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_SavingsCheckingsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_Savings", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Other Assets
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_OtherAssetsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_OtherAssets", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Assets Description
                                                            </td>
                                                            <td>
                                                                <asp:TextBox CssClass="entry2" ID="MonthlyIncome_Spouse_OtherAssetsDescribeTextBox"
                                                                    runat="server" Text='<%# Bind("MonthlyIncome_Spouse_DescribeOther") %>'
                                                                    Width="100px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Other Debts
                                                            </td>
                                                            <td>$<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addAssetsTotal()" CssClass="entry2" ID="MonthlyIncome_Spouse_OtherDebtsTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyIncome_Spouse_OtherDebts", "{0:n2}") %>'
                                                                Width="75px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                        
                                                    </table>
                                                </td>
                                                <tr>
                                                    <td class="cellHeader">Total Assets:
                                                    </td>
                                                    <td>$<asp:TextBox ReadOnly="true" CssClass="entry2" ID="totalAssetIncomeTextBox"
                                                        runat="server" Text="" Width="75px" />
                                                    </td>
                                                </tr>
                                            </tr>
                                            <tr>
                                                <td class="groupCell">Client Job
                                                </td>
                                                <td class="groupLastCell">Spouse Job
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="cellHeader">Job Description:
                                                            </td>
                                                            <td>
                                                                <asp:TextBox CssClass="entry2" ID="MonthlyIncome_Client_JobDescriptionTextBox" runat="server"
                                                                    Text='<%# Bind("MonthlyIncome_Client_JobDescription") %>' Width="100px" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">Full Time
                                                                <asp:CheckBox ID="MonthlyIncome_Client_FullTimeCheckBox" runat="server" Checked='<%# Bind("MonthlyIncome_Client_FullTime") %>' />
                                                                Part Time
                                                                <asp:CheckBox ID="MonthlyIncome_Client_PartTimeCheckBox" runat="server" Checked='<%# Bind("MonthlyIncome_Client_PartTime") %>' />
                                                            </td>
                                                        </tr>
                                                        </table>
                                                    </td>
                                                <td style="padding-left: 15px;">
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>Job Description:<asp:TextBox  Width="100px" ID="MonthlyIncome_Spouse_JobDescriptionTextBox"
                                                                    runat="server" Text='<%# Bind("MonthlyIncome_Spouse_JobDescription", "{0:n2}") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Full Time
                                                                <asp:CheckBox ID="MonthlyIncome_Spouse_FullTimeCheckBox" runat="server" Checked='<%# Bind("MonthlyIncome_Spouse_FullTime") %>' />
                                                                Part Time
                                                                <asp:CheckBox ID="MonthlyIncome_Spouse_PartTimeCheckBox" runat="server" Checked='<%# Bind("MonthlyIncome_Spouse_PartTime") %>' />
                                                            </td>
                                                        </tr>
                                                        </table>
                                                    </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="font-weight: bold;">* have client fax in proof of Social Security or Disability such as bank statement
                                                    or award letter.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">Are you and/or your spouse receiving any state assistance (Check if YES)?:
                                                    <asp:CheckBox ID="MonthlyIncome_IsRecievingStateAssistanceCheckBox" runat="server"
                                                        Checked='<%# Bind("MonthlyIncome_IsRecievingStateAssistance") %>' />
                                                    <br />
                                                    If yes, explain (for example: food stamps or welfare):
                                                    <asp:TextBox ID="MonthlyIncome_IsRecievingStateAssistanceDescriptionTextBox" runat="server"
                                                        Text='<%# Bind("MonthlyIncome_IsRecievingStateAssistanceDescription") %>' Rows="5"
                                                        TextMode="MultiLine" CssClass="entry" />
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="pExpense" runat="server">
                                    <Header>
                                        <a href="">Monthly Expenses</a>
                                    </Header>
                                    <Content>
                                        <table class="entry2" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>

                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>Rent
                                                                $<asp:TextBox CssClass="entry2" ID="MonthlyExpenses_RentTextBox" onfocusout="javascript:return addExpensesTotal()" runat="server" Text='<%# Bind("MonthlyExpenses_Rent", "{0:n2}") %>'
                                                                    Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                            </td>
                                                            <td>2nd Mortgage (Check if YES)
                                                                <asp:CheckBox ID="MonthlyExpenses_2ndMortgageCheckBox" runat="server" Checked='<%# Bind("MonthlyExpenses_2ndMortgage") %>' />
                                                                $<asp:TextBox onkeypress="return isCurrencyKey(event)" onfocusout="javascript:return addExpensesTotal()" CssClass="entry2" ID="MonthlyExpenses_2ndMortgageAmtTextBox"
                                                                    runat="server" Text='<%# Bind("MonthlyExpenses_2ndMortgageAmt", "{0:n2}") %>'
                                                                    Width="75px" />(monthly Amt)
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Mortgage
                                                           
                                                                $<asp:TextBox CssClass="entry2" ID="MonthlyExpenses_MortgageTextBox" onfocusout="javascript:return addExpensesTotal()" runat="server"
                                                                    Text='<%# Bind("MonthlyExpenses_Mortgage", "{0:n2}") %>' onkeypress="return isCurrencyKey(event)" />
                                                            </td>
                                                            <td>Owe on Home: $<asp:TextBox CssClass="entry2" ID="MonthlyExpenses_OweOnHomeTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyExpenses_OweOnHome", "{0:n2}") %>'
                                                                onkeypress="return isCurrencyKey(event)" />
                                                            </td>

                                                        </tr>
                                                        <tr>
                                                            <td>Have you refinanced (Check if YES)?:
                                                                <asp:CheckBox ID="MonthlyExpenses_HasClientRefinancedCheckBox" runat="server" Checked='<%# Bind("MonthlyExpenses_HasClientRefinanced") %>' />
                                                            </td>
                                                            <td>Equity value of Home: $<asp:TextBox CssClass="entry2" ID="MonthlyExpenses_EquityValueOfHomeTextBox"
                                                                runat="server" Text='<%# Bind("MonthlyExpenses_EquityValueOfHome", "{0:n2}") %>'
                                                                Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                            </td>

                                                        </tr>
                                                    </table>
                                                    <table class="entry2" cellpadding="0" cellspacing="0">

                                                        <tr>
                                                            <td colspan="2">Reason for Debt: (a basic summary of why client had to join our services):
                                                                <asp:TextBox ID="MonthlyExpenses_ReasonForDebtTextBox" runat="server" Text='<%# Bind("MonthlyExpenses_ReasonForDebt") %>'
                                                                    Rows="5" TextMode="MultiLine" CssClass="entry" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">Do you or your spouse have any assets that can be liquidated to create cash? (Check
                                                                if Yes):
                                                                <asp:CheckBox ID="MonthlyExpenses_DoesClientHaveAssetsCheckBox" runat="server" Checked='<%# Bind("MonthlyExpenses_DoesClientHaveAssets") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table class="entry2" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <table cellpadding="0" cellspacing="0" class="entry2">
                                                                    <tr>
                                                                        <td class="cellHeader">Car payment
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_CarpaymentTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Carpayment", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Car Insurance
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_CarInsuranceTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_CarInsurance", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Utilities
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_UtilitiesTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Utilities", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Groceries
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_GroceriesTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Groceries", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Dining Out
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_DiningOutTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_DiningOut", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Entertainment
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_EntertainmentTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Entertainment", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Loans
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_loansTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_loans", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Credit Cards
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_creditcardsTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_creditcards", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other: 
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_OtherTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Other", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other2: 
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_Other2TextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Other2", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other3: 
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_Other3TextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Other3", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td>
                                                                <table cellpadding="0" cellspacing="0" class="entry2">
                                                                    <tr>
                                                                        <td class="cellHeader">Medical Insurance
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_MedicalInsuranceTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_MedicalInsurance", "{0:n2}") %>' Width="75px"
                                                                            onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Medications
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_MedicationsTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Medications", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Gasoline
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_GasolineTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_Gasoline", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">School Loans
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_SchoolLoansTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_SchoolLoans", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Law Firm
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_lawfirmTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_lawfirm", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">School Expenses
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_SchoolExpensesTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_SchoolExpenses", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Phone/Cell
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_PhoneTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_PhoneCell", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Home Insurance
                                                                        </td>
                                                                        <td>$<asp:TextBox CssClass="entry2" onfocusout="javascript:return addExpensesTotal()" ID="MonthlyExpenses_HomeInsuranceTextBox" runat="server"
                                                                            Text='<%# Bind("MonthlyExpenses_HomeInsurance", "{0:n2}") %>' Width="75px" onkeypress="return isCurrencyKey(event)" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other Description: 
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox CssClass="entry2" ID="MonthlyExpenses_OtherDescriptionTextBox" runat="server"
                                                                                Text='<%# Bind("MonthlyExpenses_OtherDescription") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other2 Description: 
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox CssClass="entry2" ID="MonthlyExpenses_Other2DescriptionTextBox" runat="server"
                                                                                Text='<%# Bind("MonthlyExpenses_OtherDescription2") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other3 Description: 
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox CssClass="entry2" ID="MonthlyExpenses_Other3DescriptionTextBox" runat="server"
                                                                                Text='<%# Bind("MonthlyExpenses_OtherDescription3") %>' />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Total Expenses: 
                                                            </td>
                                                            <td>
                                                                <asp:TextBox CssClass="entry2" ReadOnly="true" ID="Monthly_TotalExpensesTextBox" runat="server"
                                                                    Text='<%# Bind("Monthly_TotalExpenses") %>' />
                                                            </td>
                                                            <td>*Excludes "Owe on home" & "Equity Value of Home" fields 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="cellHeader">Total Income After Expenses: 
                                                            </td>
                                                            <td>
                                                                <asp:TextBox CssClass="entry2" ReadOnly="true" ID="IncomeAfterExpensesTextBox" runat="server"
                                                                    Text='<%# Bind("IncomeAfterExpenses") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="pMedical" runat="server">
                                    <Header>
                                        <a href="">Medical Conditions</a>
                                    </Header>
                                    <Content>
                                        <table cellpadding="0" cellspacing="0" class="entry2">
                                            <tr>
                                                <td class="groupCell" style="width: 50%">Client
                                                </td>
                                                <td class="groupLastCell" style="width: 50%">Spouse
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" class="entry2">
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Conditions/Diseases
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table cellpadding="0" cellspacing="0" class="entry2">
                                                                    <tr>
                                                                        <td class="cellHeader">Diabetes
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Client_DiabetesCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Client_Diabetes") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Arthritis
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Client_ArthritisCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Client_Arthritis") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Asthma
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Client_AsthmaCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Client_Asthma") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">High Blood Pressure
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Client_HighBloodPressureCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalCondtions_Client_HighBloodPressure") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Anxiety/Depression
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalConditions_Client_AnxietyDepressionCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalConditions_Client_AnxietyDepression") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Heart Condition
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalConditions_Client_HeartConditionCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalConditions_Client_HeartCondition") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">High Cholesterol
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Client_HighCholesterolCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalCondtions_Client_HighCholesterol") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other:
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox CssClass="entry2" ID="MedicalCondtions_Client_OtherTextBox" runat="server"
                                                                                Text='<%# Bind("MedicalCondtions_Client_Other") %>' />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Medications
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">How many pills do you take on a daily basis?:
                                                           
                                                                <asp:TextBox CssClass="entry2" ID="MedicalCondtions_Client_NumPillsTakenTextBox"
                                                                    runat="server" Text='<%# Bind("MedicalCondtions_Client_NumPillsTaken") %>' onkeypress="return isNumberKey(event)" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Medical History
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:TextBox ID="MedicalCondtions_Client_HistoryTextBox" runat="server" Text='<%# Bind("MedicalCondtions_Client_History") %>'
                                                                    Rows="5" TextMode="MultiLine" CssClass="entry" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 15px; border-left: dotted 1px black">
                                                    <table cellpadding="0" cellspacing="0" class="entry">
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Conditions/Diseases
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table cellpadding="0" cellspacing="0" class="entry2">
                                                                    <tr>
                                                                        <td class="cellHeader">Diabetes
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Spouse_DiabetesCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Spouse_Diabetes") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Arthritis
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Spouse_ArthritisCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Spouse_Arthritis") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Asthma
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Spouse_AsthmaCheckBox" runat="server" Checked='<%# Bind("MedicalCondtions_Spouse_Asthma") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">High Blood Pressure
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Spouse_HighBloodPressureCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalCondtions_Spouse_HighBloodPressure") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Anxiety/Depression
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalConditions_Spouse_AnxietyDepressionCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalConditions_Client_AnxietyDepression") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Heart Condition
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalConditions_Spouse_HeartConditionCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalConditions_Spouse_HeartCondition") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">High Cholesterol
                                                                        </td>
                                                                        <td>
                                                                            <asp:CheckBox ID="MedicalCondtions_Spouse_HighCholesterolCheckBox" runat="server"
                                                                                Checked='<%# Bind("MedicalCondtions_Spouse_HighCholesterol") %>' />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="cellHeader">Other:
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox CssClass="entry2" ID="MedicalCondtions_Spouse_OtherTextBox" runat="server"
                                                                                Text='<%# Bind("MedicalCondtions_Spouse_Other") %>' />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Medications
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">How many pills do you take on a daily basis?:
                                                            
                                                                <asp:TextBox CssClass="entry2" ID="MedicalCondtions_Spouse_NumPillsTakenTextBox"
                                                                    runat="server" Text='<%# Bind("MedicalCondtions_Spouse_NumPillsTaken") %>' onkeypress="return isNumberKey(event)" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="subSectionCell">Medical History
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:TextBox ID="MedicalCondtions_Spouse_HistoryTextBox" runat="server" Text='<%# Bind("MedicalCondtions_Spouse_History") %>'
                                                                    Rows="5" TextMode="MultiLine" CssClass="entry" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                                <ajaxToolkit:AccordionPane ID="pAdditional" runat="server">
                                    <Header>
                                        <a href="">Additional Information</a>
                                    </Header>
                                    <Content>
                                        <asp:TextBox ID="AdditionalInformationTextBox" runat="server" Text='<%# Bind("AdditionalInformation") %>'
                                            TextMode="MultiLine" Rows="10" CssClass="entry" />
                                    </Content>
                                </ajaxToolkit:AccordionPane>
                            </Panes>
                        </ajaxToolkit:Accordion>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tabHistory" runat="server">
        <HeaderTemplate>
            View Hardship History
        </HeaderTemplate>
        <ContentTemplate>
            <br />
            <asp:GridView ID="gvHardshipHistory" runat="server" CssClass="entry" AllowPaging="True"
                AllowSorting="True" AutoGenerateColumns="False" DataSourceID="dsHardshipHistory"
                PageSize="5" DataKeyNames="hardshipid">
                <PagerStyle BackColor="#DCDCDC" Font-Names="tahoma" Font-Size="11pt" />
                <Columns>
                    <asp:BoundField DataField="clientid" HeaderText="clientid" SortExpression="clientid"
                        Visible="False" />
                    <asp:BoundField DataField="hardshipid" HeaderText="hardshipid" InsertVisible="False"
                        ReadOnly="True" SortExpression="hardshipid" Visible="False" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkLoad" runat="server" Text="Load" CommandName="load" CommandArgument='<%#Eval("hardshipid") %>' />
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="center" Width="35px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="center" CssClass="listitem" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="User" HeaderText="User" ReadOnly="True" SortExpression="User">
                        <HeaderStyle HorizontalAlign="Left" Width="200px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Left" CssClass="listitem" Width="200px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date">
                        <HeaderStyle HorizontalAlign="Center" Width="120px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Center" CssClass="listitem" Width="120px" Wrap="false" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Ttl Income" DataFormatString="{0:c}" HeaderText="Ttl Income"
                        ReadOnly="True" SortExpression="Ttl Income">
                        <HeaderStyle HorizontalAlign="Right" Width="75px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Right" CssClass="listitem" Width="75px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Ttl Expenses" DataFormatString="{0:c}" HeaderText="Ttl Expenses"
                        ReadOnly="True" SortExpression="Ttl Expenses">
                        <HeaderStyle HorizontalAlign="Right" Width="75px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Right" CssClass="listitem" Width="75px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Medical" HeaderText="Medical" ReadOnly="True" SortExpression="Medical">
                        <HeaderStyle HorizontalAlign="Center" Width="75px" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Center" CssClass="listitem" Width="75px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Summary" HeaderText="Summary" ReadOnly="True" SortExpression="Summary">
                        <HeaderStyle HorizontalAlign="Left" CssClass="headitem5" />
                        <ItemStyle HorizontalAlign="Left" CssClass="listitem" />
                    </asp:BoundField>
                </Columns>
                <EmptyDataTemplate>
                    No hardships on file.
                </EmptyDataTemplate>
                <PagerTemplate>
                    <div id="pager">
                        <table cellpadding="0" cellspacing="0" class="entry">
                            <tr>
                                <td style="padding-left: 10px;">Page(s)
                                    <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
                                    of
                                    <asp:Label ID="lblNumber" runat="server" CssClass="entry2" />
                                </td>
                                <td style="padding-right: 10px; text-align: right;">
                                    <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                        ID="btnFirst" CssClass="entry2" />
                                    <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                        ID="btnPrevious" CssClass="entry2" />
                                    -
                                    <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                        ID="btnNext" CssClass="entry2" />
                                    <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                        ID="btnLast" CssClass="entry2" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </PagerTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="dsHardshipHistory" ConnectionString="<%$ AppSettings:connectionstring %>"
                runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_Hardship_getHardshipHistory"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter DefaultValue="-1" Name="clientid" QueryStringField="id"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
</ajaxToolkit:TabContainer>