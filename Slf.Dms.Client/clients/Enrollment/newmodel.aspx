<%@ Page Language="VB" AutoEventWireup="false" CodeFile="newmodel.aspx.vb" Inherits="newmodel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-family: tahoma;
            font-size: 12px;
        }
        .grids td
        {
            font-family: tahoma;
            font-size: 12px;
            padding: 3px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table>
                <tr>
                    <td valign="top">
                        <table>
                            <tr>
                                <td>
                                    Total debt amt
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:Label ID="lbltotaldebtamt" runat="server"></asp:Label>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Accts
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:Label ID="lblAccts" runat="server"></asp:Label>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Interest rate
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtinterestrate" runat="server" Text="23.50" Width="75px"></asp:TextBox>
                                    %
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Deposit commitment
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtdepcommit" runat="server" Width="75px" Text="500.00"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Est growth
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtestgrowth" runat="server" Text="31" Width="75px"></asp:TextBox>
                                    %
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Service fee cap
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtcap" runat="server" Width="75px" Text="50.00"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Monthly service fee per acct
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtfeeperacct" runat="server" Text="10.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Settlement Fee
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSettlementFee" runat="server" Text="33" Width="75px"></asp:TextBox>
                                    %
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:Button ID="btnCalc" runat="server" Text="CALCULATE" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td>
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                        DisplayAfter="0">
                                        <ProgressTemplate>
                                            <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                            Calculating..
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 75px;">
                        <table>
                            <tr>
                                <td>
                                    Acct 1
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct1" runat="server" Text="1000.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 2
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct2" runat="server" Text="2000.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 3
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct3" runat="server" Text="3000.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 4
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct4" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 5
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct5" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 6
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct6" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 7
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct7" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 8
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct8" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 9
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct9" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Acct 10
                                </td>
                                <td>
                                    $
                                </td>
                                <td>
                                    <asp:TextBox ID="txtAcct10" runat="server" Text="0.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 75px;">
                        <table>
                            <tr >
                                <td width="120px">
                                    Settlement % from
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSettFrom" runat="server" Text="30" Width="50px"></asp:TextBox>
                                    to
                                    <asp:TextBox ID="txtSettTo" runat="server" Text="100" Width="50px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Increment
                                </td>
                                <td>
                                    <asp:TextBox ID="txtIncr" runat="server" Text="10" Width="50px"></asp:TextBox>%
                                </td>
                            </tr>
                        </table>
                        <hr />
                        <table>
                            <tr>
                                <td>
                                    Curreny Model Only
                                </td>
                            </tr>
                            <tr>
                                <td width="120px">
                                    First Year Maint. Fee
                                </td>
                                <td>$</td>
                                <td>
                                    <asp:TextBox ID="txtFirstYrMaintFee" runat="server" Text="130.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Subseq Maint. Fee
                                </td>
                                <td>$</td>
                                <td>
                                    <asp:TextBox ID="txtSubMaintFee" runat="server" Text="130.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <hr />
                        <table>
                            <tr>
                                <td colspan="3">
                                    LEXXIOM Retainer Model Only
                                </td>
                            </tr>
                            <tr>
                                <td width="120px">
                                    Retainer Fee
                                </td>
                                <td></td>
                                <td>
                                    <asp:TextBox ID="txtRetainerFee" runat="server" Text="10.00" Width="75px"></asp:TextBox>
                                    %
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Maintenance Fee
                                </td>
                                <td>$</td>
                                <td>
                                    <asp:TextBox ID="txtMaintenceFee" runat="server" Text="65.00" Width="75px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left: 75px; ">
                        <table>
                            <tr>
                                <td>
                                    PBM Variable Model
                                </td>
                            </tr>
                            <tr >
                                <td width="130px">
                                    Minimum Payment Pct
                                </td>
                                <td> </td>
                                <td>
                                    <asp:TextBox ID="txtMinPayPct" runat="server" Text="2.50" Width="50px"></asp:TextBox>%
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Minimum Payment
                                </td>
                                <td>$</td>
                                <td>
                                    <asp:TextBox ID="txtMinPay" runat="server" Text="10.00" Width="50px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                   </td>
                </tr>
            </table>
            <table>
                <tr style="padding-top: 25px;">
                    <td>
                        <font color="blue"><b>SMARTDEBTOR NEW Model</b></font>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <ajaxToolkit:TabContainer ID="TabContainer2" runat="server">
                            <ajaxToolkit:TabPanel ID="TabPanel3" HeaderText="Summary" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="gvNewLifecycle" runat="server">
                                    </asp:GridView>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                            <ajaxToolkit:TabPanel ID="TabPanel8" HeaderText="Total Settl Cost Compare" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="gvCompare" runat="server">
                                    </asp:GridView>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                        </ajaxToolkit:TabContainer>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>SMARTDEBTOR CURRENT Model</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:GridView ID="gvCurrentLifecycle" runat="server">
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>LEXXIOM Retainer Model Summary</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:GridView ID="GridView3" runat="server">
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>PBM Variable Summary</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:GridView ID="GridView4" runat="server">
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>PBM 1-Payment Summary</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:GridView ID="GridView5" runat="server">
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font color="blue"><b>SMARTDEBTOR NEW Model</b></font>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:PlaceHolder ID="phNewLifecycle" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>SMARTDEBTOR CURRENT Model</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:PlaceHolder ID="phCurrentLifecycle" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>LEXXIOM Retainer Model Detail</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:PlaceHolder ID="PlaceHolder3" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>PBM Variable Detail</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:PlaceHolder ID="PlaceHolder4" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>PBM 1-Payment Detail</b>
                    </td>
                </tr>
                <tr>
                    <td class="grids" style="padding-bottom: 25px">
                        <asp:PlaceHolder ID="PlaceHolder5" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>