<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="validationdetail.aspx.vb" Inherits="admin_creditors_validationdetail" %>

<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="../">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_admin.png" alt="Admin Home" />Admin Home</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a id="A2" class="menuButton" runat="server" href="useractivity.aspx">
                    <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_person.png" />User
                    Activity</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:Panel runat="server" ID="pnlMain" Style="width: 100%; height: 100%; padding: 15px;">
        <style type="text/css">
            .creditor-item
            {
                border-bottom: dotted 1px #d3d3d3;
                white-space: nowrap;
                font-family: Tahoma;
                font-size: 11px;
            }
            .headItem
            {
                font-family: Tahoma;
                font-size: 11px;
                font-weight: normal;
                text-align: left;
            }
        </style>
        <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
            cellspacing="0">
            <tr>
                <td>
                    <asp:Label ID="lblName" runat="server" Style="color: rgb(80,80,80); font-family: tahoma;
                        font-size: medium;"></asp:Label>
                    -
                    <asp:Label ID="lblDept" runat="server" Style="color: rgb(160,80,80); font-family: tahoma;
                        font-size: medium;"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="padding-bottom: 7px;">
                    <hr />
                    <br />
                    <b>Validated</b>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="gvValidated" runat="server" AutoGenerateColumns="false" CellPadding="5"
                        Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true" DataKeyNames="CreditorID,Active,Validated">
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                <HeaderTemplate>
                                    <img runat="server" src="~/images/16x16_icon.png" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <img id="imgIcon" runat="server" src="~/images/16x16_dataentry.png" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headItem" />
                                <ItemStyle CssClass="creditor-item" />
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Creditor" DataField="name" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="Street" DataField="street" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="" DataField="street2" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="City" DataField="city" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="State" DataField="state" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Zip Code" DataField="zipcode" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Created" DataField="created" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                        </Columns>
                        <EmptyDataTemplate>
                            No validated creditors.
                        </EmptyDataTemplate>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="padding-bottom: 7px;">
                    <br />
                    <b>Approved</b>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="gvApproved" runat="server" AutoGenerateColumns="false" CellPadding="5"
                        Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true" DataKeyNames="CreditorID,Active,Validated">
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                <HeaderTemplate>
                                    <img runat="server" src="~/images/16x16_icon.png" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <img id="imgIcon" runat="server" src="~/images/16x16_dataentry.png" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headItem" />
                                <ItemStyle CssClass="creditor-item" />
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Creditor" DataField="name" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="Street" DataField="street" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="" DataField="street2" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="City" DataField="city" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="State" DataField="state" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Zip Code" DataField="zipcode" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Created" DataField="created" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                        </Columns>
                        <EmptyDataTemplate>
                            No approved creditors.
                        </EmptyDataTemplate>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="padding-bottom: 7px;">
                    <br />
                    <b>Duplicates</b>
                </td>
            </tr>
            <tr>
                <td>
                <asp:GridView ID="gvDuplicates" runat="server" AutoGenerateColumns="false" CellPadding="5"
                        Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true" DataKeyNames="CreditorID,Active,Validated">
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                <HeaderTemplate>
                                    <img runat="server" src="~/images/16x16_icon.png" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <img id="imgIcon" runat="server" src="~/images/16x16_dataentry.png" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="headItem" />
                                <ItemStyle CssClass="creditor-item" />
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Creditor" DataField="name" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="Street" DataField="street" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                            <asp:BoundField HeaderText="" DataField="street2" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="City" DataField="city" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="State" DataField="state" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Zip Code" DataField="zipcode" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                                <asp:BoundField HeaderText="Created" DataField="created" ItemStyle-CssClass="creditor-item"
                                HeaderStyle-CssClass="headItem" />
                        </Columns>
                        <EmptyDataTemplate>
                            No duplicate creditors.
                        </EmptyDataTemplate>
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
