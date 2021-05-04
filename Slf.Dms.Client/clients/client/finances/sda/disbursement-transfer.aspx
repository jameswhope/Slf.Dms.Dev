<%@ Page Title="" Language="VB" MasterPageFile="~/Clients/client/client.master" AutoEventWireup="false"
    CodeFile="disbursement-transfer.aspx.vb" Inherits="Clients_client_finances_sda_disbursement_transfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
        cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a href="../../default.aspx" class="lnk" style="color: #666666;">Clients</a>&nbsp;>&nbsp;<a
                    id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Finances&nbsp;>&nbsp;Ad-hoc
                Transfer
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
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <table style="width: 300; font-family: tahoma; font-size: 11px;" border="0" cellpadding="0"
                                        cellspacing="5">
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                From :
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="lblFrom"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                To :
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:DropDownList ID="ddlTo" runat="server" CssClass="entry2" AutoPostBack="true">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr id="trRouting" runat="server" visible="false">
                                            <td align="right">
                                                Routing :
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtRouting" runat="server" MaxLength="9"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr id="trAccount" runat="server" visible="false">
                                            <td align="right">
                                                Account :
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAccount" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr id="trType" runat="server" visible="false">
                                            <td align="right">
                                                Type :
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlType" runat="server" CssClass="entry2">
                                                    <asp:ListItem Text="C"></asp:ListItem>
                                                    <asp:ListItem Text="S"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                Transaction ID :
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="lblTransactionID"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                Check Number :
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="lblCheckNumber"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                Transaction Type :
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="lblTransactionType"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                Amount :
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="lblAmount"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                                    DisplayAfter="0">
                                                    <ProgressTemplate>
                                                        <img src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                            <td nowrap="nowrap">
                                                <hr />
                                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="entry2" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" align="right">
                                                &nbsp;
                                            </td>
                                            <td nowrap="nowrap">
                                                WARNING: This transaction was originally issued as a check. Submitting this
                                                <br />
                                                ad-hoc transfer will ACH these funds into the client's personal bank account.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="lblErrMsg" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnAccountNumber" runat="server" />
</asp:Content>
