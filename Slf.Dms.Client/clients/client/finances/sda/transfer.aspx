<%@ Page Title="" Language="VB" MasterPageFile="~/Clients/client/client.master" AutoEventWireup="false"
    CodeFile="transfer.aspx.vb" Inherits="Clients_client_finances_sda_transfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
        cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkSDAStructure"
                    runat="server" class="lnk" style="color: #666666;">SDA Structure</a> &nbsp;>&nbsp;Ad-hoc Transfer
            </td>
        </tr>
        <tr>
            <td>
                <br />
                <table style="width: 300; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                    cellspacing="0">
                    <tr>
                        <td style="background-color: #f1f1f1; padding: 5 5 5 5;">
                            Ad-hoc Transfer
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width: 300; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                cellspacing="5">
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        From Orig. Trust Location :
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="lblOrigTrust"></asp:Label>
                                        <asp:HiddenField ID="hdnOrigCompanyID" runat="server" Value="-1" />
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        To Current Trust Location :
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="lblCurrTrust"></asp:Label>
                                        <asp:HiddenField ID="hdnCurCompanyID" runat="server" Value="-1" />
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        Date Converted :
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="lblDateConverted"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        Account Number :
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="lblAccountNumber"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        SDA Balance :
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="lblSDABalance"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        Amount :
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAmount" runat="server" CssClass="entry2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap" align="right">
                                        &nbsp;
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:Button ID="btnCreate" runat="server" Text="Transfer" CssClass="entry2" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
