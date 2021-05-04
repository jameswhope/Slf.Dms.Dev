<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CalculatorModelControl.ascx.vb" Inherits="CalculatorModelControl" %>
<style type="text/css">
    .InfoMsg
    {
        background-color: Black;
        color: White;
        writing-mode: tb-rl;
        filter: flipv fliph;
        vertical-align: middle;
        text-align: center;
    }
    .gridHdr
    {
        background-color: Black;
        color: White;
        font-family: Tahoma;
        font-size: 8pt;
    }
    .gridCaption
    {
        font-weight: bold;
        font-size: 11pt;
        font-family: Tahoma;
        background-color: #F0E68C;
        color: black;
    }
      .btnCalc
    {
	    font-family: Tahoma;
	    font-size: 11px;
	    height: 22px;  
	    }
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
    .window
{
    width: 100%;
    background-color: #f1f1f1;
    margin: 0 0 10px 0;
    border:solid 1px #e1e1e1;
}
.window h2, .window2 h2, .window h3
{
    background-color: #F0E68C;
    height: 22px;
    font-weight: bold;
    font-family: tahoma;
    font-size: 11px;
    padding: 3px;
    margin: 0;
}
.window h2 a, .window2 h2 a
{
	font-weight:normal;
	float:right;
}
.window h3
{
	font-weight:normal;
}
.window td, .window2 td
{
    padding: 1px 1px 1px 1px;
}
.bottomborder td {border-bottom: 1pt solid #3D3D3D} 
.bottomborder th {border-bottom: 1pt solid #3D3D3D} 

</style>
<asp:Panel ID="Panel1" runat="server" DefaultButton="btnCalculate">
<table id="tblAcctInfo" runat="server" class="window" style="font-family: Tahoma; font-size: 11px;">
    <tr>
        <td>
            <table class="entry" border="0" style=" border-collapse:collapse;" cellpadding="0" cellspacing="0" >
                <tr class="bottomborder" >
                    <th align="left">
                        <font color="red"># of Accounts</font>
                    </th>
                    <th>
                        &nbsp;
                    </th>
                    <th align="left">
                        <asp:TextBox ID="txtNumAccts" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Text="1" TabIndex="1"></asp:TextBox>
                    </th>
                    <th style="width: 25px">
                        &nbsp;
                    </th>
                    <th align="left">
                        <font color="red">Total Debt</font>
                    </th>
                    <th>
                        $
                    </th>
                    <th align="left">
                        <asp:TextBox ID="txtTotalDebt" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Text="0.00" TabIndex="2"></asp:TextBox>
                        <asp:ImageButton ID="btnCalculate" runat="server" ImageUrl="~/images/16x16_calculator.png"
                            ImageAlign="AbsMiddle" />
                    </th>
                </tr>
                <tr class="entry2">
                    <td>
                        <asp:Label ID="lblInitialDeposit" runat="server" Text="Initial Deposit" style="text-align: left;" Visible="true" Enabled="true" ></asp:Label>
                    </td>
                    <td>
                        $
                    </td>
                    <td>
                        <asp:TextBox ID="txtInitialDeposit" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Text="0.00" TabIndex="3"></asp:TextBox>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblMonthlyFee" runat="server" Text="Monthly Fee" style="text-align: left;" Visible="true" Enabled="true" ></asp:Label> &nbsp;
                    </td>
                    <td>
                        $
                    </td>
                    <td>
                        <asp:TextBox ID="txtMaintFeePerAcct1" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false" Text="0.00" Visible="false"></asp:TextBox>
                        <asp:TextBox ID="txtMaintFeePerAcct" runat="server" Width="75px" Enabled="false" Text="65" Style="text-align: right;">
                        </asp:TextBox>
                    </td>
                    <td>&nbsp;
                    </td>
-                    <td>
                        &nbsp;
                    </td>
                    <td>
                       &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr class="entry2" id="trProperties">
                    <td>
                        Deposit Committment&nbsp;
                    </td>
                    <td>
                        $
                    </td>
                    <td>
                        <asp:TextBox ID="txtDepositComitmment" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Text="0.00" TabIndex="4"></asp:TextBox>
                    </td>
                     <td>&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblContingencyFee" runat="server"  Text="Contingency Fee" style="text-align: left;" Visible="true"></asp:Label>
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtSettlementFeePct" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false"></asp:TextBox>%
                    </td>
                </tr>
                <div runat="server" id="dvOldCalc" visible="true">
                <tr class="bottomborder">
                    <td>
                        <asp:Label ID="lblEstGrowth" runat="server" Text="Est Growth" style="text-align: left;" Visible="true"></asp:Label>%
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtEstGrowth" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false" Visible="true"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                     <td>
                        <asp:Label ID="lblMaintFeeCap" runat="server" Text="Service Fee Cap" style="text-align: left;" Visible="true"></asp:Label>
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtMaintFeeCap" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false" Visible="true"></asp:TextBox>
                    </td>
                </tr>
                </div>
                <tr class="entry2">
                    <td>
                        <b>PBM only</b>
                    </td>
                    <td>
                    &nbsp;
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        Min Payment
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtMinPct" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false"></asp:TextBox>%
                    </td>
                </tr>
                <tr>
                    <td>
                        Interest Rate
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtIntRate" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false"></asp:TextBox>%
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>
                        Min Payment
                    </td>
                    <td>
                        $
                    </td>
                    <td>
                        <asp:TextBox ID="txtMinAmt" CssClass="entry" runat="server" Style="text-align: right;"
                            Width="75px" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</asp:Panel>
<div id="tblBody" runat="server">
    <asp:GridView ID="gvMinPayment" runat="server" CssClass="entry" Caption="<div style='text-align:left;background-color:#F0E68C;'><b>Minimum Payments Example<sup>(1)</sup></b></div>"
        AutoGenerateColumns="false" HeaderStyle-VerticalAlign="Bottom">
        <Columns>
            <asp:TemplateField HeaderText="Total Principle">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblTotalPrinciple" runat="server" Text='<%#eval("TotalPrinciple") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Total Interest">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblTotalInterest" runat="server" Text='<%#eval("TotalInterest") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="true" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Total Amount Paid">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblTotalAmtPaid" runat="server" Text='<%#eval("TotalAmountPaid") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Number of Months">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblNumberMonths" runat="server" Text='<%#eval("NumberOfMonths") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Number of Years">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblNumberYears" runat="server" Text='<%#eval("NumberOfYears") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />
    <asp:GridView ID="gvExample" runat="server" CssClass="entry" Caption="<div style='text-align:left;background-color:#F0E68C;'><b>Settlement Example<sup>(7)(8)</sup></b></div>"
        AutoGenerateColumns="false" HeaderStyle-VerticalAlign="Bottom">
        <Columns>
            <asp:TemplateField HeaderText="Original Balance">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblStartingDebtBal" runat="server" Text='<%#eval("StartingDebtBal") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Estimated Debt Balance at Time of Settlement" >
                <ItemTemplate>
                    <div>
                        <%#DataBinder.Eval(Container.DataItem, "EstDebtBal", "{0:C0}") %>
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="true" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Target Debts">
                <ItemTemplate>
                    <div>
                        <asp:Label ID="lblTotalAccts" runat="server" Text='<%#eval("TotalAccts") %>' />
                    </div>
                </ItemTemplate>
                <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />
    <%--<table class="entry" cellpadding="0" cellspacing="0">
        <tr>
            <td rowspan="2" class="InfoMsg" style="background-color: #3D3D3D; width: 17px">
                If you deposit:
            </td>
            <td align="center" style="background-color: #458B74; color: White;">
                <asp:Label ID="lblCreditorAccept" runat="server" Text="If your creditors accept:" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:PlaceHolder ID="phGrids" runat="server" />
            </td>
        </tr>
    </table>--%>
    <asp:PlaceHolder ID="phGrids" runat="server" />
</div>
