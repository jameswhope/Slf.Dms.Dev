<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="NewerModel.aspx.vb" Inherits="Clients_Enrollment_NewerModel" %>

<%@ Register Src="../../CustomTools/UserControls/CalculatorModelControl.ascx" TagName="CalculatorModelControl"
    TagPrefix="LexxControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img id="Img2" width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <link href="Enrollment.css" rel="stylesheet" type="text/css" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px;"
                border="0" cellpadding="0" cellspacing="15">
                <tr>
                    <td>
                        <table class="window">
                            <tr>
                                <td>
                                    <h3>
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <b>Creditors</b>
                                                </td>
                                                <td align="right">
                                                    <asp:LinkButton ID="lnkAddCreditor" runat="server" CssClass="lnk">
                                                        <img id="Img1" style="margin-right: 5;" src="~/images/16x16_trust.png" runat="server"
                                                            border="0" align="absmiddle" />Add Creditor</asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </h3>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="gvCreditors" runat="server" AutoGenerateColumns="false" Width="100%">
                                        <Columns>
                                            <asp:ButtonField ButtonType="Image" ImageUrl="~/images/16x16_delete.png" CommandName="Delete"
                                                HeaderText="" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col2" />
                                            <asp:TemplateField HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col2"
                                                HeaderStyle-HorizontalAlign="Left">
                                                <HeaderTemplate>
                                                    Current Creditor
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    Sample Creditor
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col2"
                                                ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                <HeaderTemplate>
                                                    Balance
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:TextBox ID="txtBalance" runat="server" Style="text-align: right" Text='<%# DataBinder.Eval(Container.DataItem,"balance")%>'
                                                        CssClass="entry2" TabIndex="1"></asp:TextBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                        </table>
                        <table class="window">
                            <tr>
                                <td>
                                    <h2>
                                        Settlement Estimate Calculator</h2>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <LexxControls:CalculatorModelControl ID="CalculatorModelControl1" runat="server"
                                        Visible="true" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top">
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                            DisplayAfter="0">
                            <ProgressTemplate>
                                <div>
                                    <img src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
