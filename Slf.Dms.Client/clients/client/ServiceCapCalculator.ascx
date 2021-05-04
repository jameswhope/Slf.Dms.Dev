<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ServiceCapCalculator.ascx.vb" Inherits="Clients_client_ServiceCapCalculator" %>
<link href="../Enrollment/Enrollment.css" rel="stylesheet" type="text/css" />
<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
</asp:ScriptManagerProxy>
<asp:UpdatePanel ID="upd" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional"  >
    <ContentTemplate>
        <table class="window2" style="font-family:Tahoma; font-size: 11px;" >
            <tr>
                <td>
                    <h2>
                        <span style="float: left">Settlement Estimate Calculator</span> <span style="float: right">
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="Upd"
                                DisplayAfter="0">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                    <font style="font-weight: normal">Calculating..</font>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </span>
                        <h2>
                        </h2>
                    </h2>
                </td>
            </tr>
            <tr>
                <td>
                    <table class="estcalc">
                        <tr>
                            <th>
                                <font color="red"># of Accounts</font>
                            </th>
                            <th>
                                &nbsp;
                            </th>
                            <th>
                                <asp:TextBox ID="txtNumAccts" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Text="1" TabIndex="1" OnTextChanged="txtNumAccts_TextChanged" AutoPostBack="true"></asp:TextBox>
                            </th>
                            <th style="width: 25px">
                                &nbsp;
                            </th>
                            <th>
                                <font color="red">Total Debt</font>
                            </th>
                            <th>
                                $
                            </th>
                            <th>
                                <asp:TextBox ID="txtTotalDebt" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Text="0.00" TabIndex="2" OnTextChanged="txtTotalDebt_TextChanged" AutoPostBack="true"></asp:TextBox>
                                <asp:ImageButton ID="btnCalculate" runat="server" ImageUrl="~/images/16x16_calculator.png"
                                    ImageAlign="AbsMiddle" />
                            </th>
                        </tr>
                        <tr>
                            <td>
                                Initial Deposit
                            </td>
                            <td>
                                $
                            </td>
                            <td>
                                <asp:TextBox ID="txtInitialDeposit" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Text="0.00" OnTextChanged="txtInitialDeposit_TextChanged" AutoPostBack="true" TabIndex="3"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>
                                Service Fee Cap
                            </td>
                            <td>
                                $
                            </td>
                            <td>
                                <asp:TextBox ID="txtMaintFeeCap" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Enabled="false"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Deposit Committment&nbsp;
                            </td>
                            <td>
                                $
                            </td>
                            <td>
                                <asp:TextBox ID="txtDepositComitmment" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Text="0.00" OnTextChanged="txtDepositComitmment_TextChanged" AutoPostBack="true" TabIndex="4"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>
                                Monthly Fee Per Acct&nbsp;
                            </td>
                            <td>
                                $
                            </td>
                            <td>
                                <asp:TextBox ID="txtMaintFeePerAcct" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Enabled="false" Text="10.00"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="estcalc-split">
                            <td>
                                <%--Est Growth--%>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:TextBox ID="txtEstGrowth" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Enabled="false" Visible="false"></asp:TextBox>%
                            </td>
                            <td>
                            </td>
                            <td>
                                Settlement Fee
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:TextBox ID="txtSettlementFeePct" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Enabled="false"></asp:TextBox>%
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>PBM only</b>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                Min Payment
                            </td>
                            <td>
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
                            <td>
                            </td>
                            <td>
                                <asp:TextBox ID="txtIntRate" CssClass="entry" runat="server" Style="text-align: right;"
                                    Width="75px" Enabled="false"></asp:TextBox>%
                            </td>
                            <td>
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
                    <asp:GridView ID="gvPBM" runat="server" BorderWidth="0" BorderStyle="None" Style="margin-top: 15px"
                        Width="100%" ShowHeader="false">
                    </asp:GridView>
                    <asp:GridView ID="gvEstimates" runat="server" BorderWidth="0" BorderStyle="None"
                        Style="margin-top: 15px" Width="100%" ShowHeader="false">
                    </asp:GridView>
                    <asp:GridView ID="gvCompare" runat="server" BorderWidth="0" BorderStyle="None" Style="margin-top: 15px"
                        Width="100%" ShowHeader="false">
                    </asp:GridView>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hdnClientId" runat="server" />
        <asp:HiddenField ID="hdnUseSD" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>