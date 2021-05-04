<%@ Page Language="VB" MasterPageFile="~/research/negotiation/negotiation.master"
    AutoEventWireup="false" CodeFile="criteriadistribution.aspx.vb" Inherits="Clients_client_creditors_mediation_criteriadistribution"
    Title="DMP - Criteria " %>

<%@ Register Src="usercontrol/criteriaBuilder.ascx" TagName="criteriaBuilder" TagPrefix="uc1" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tbl1" style="font-family: tahoma; font-size: 11px; width: 750px;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td valign="bottom" style="font-family: tahoma; font-size: 11px; height: 22px; width: 100%;
                color: rgb(50,112,163);">
                <asp:Literal ID="ltHeader" runat="server"></asp:Literal></td>
        </tr>
        <tr>
            <td valign="top" style="font-family: tahoma; font-size: 11px; height: 25px; width: 100%;">
                <asp:GridView ID="grdCriteria" BorderStyle="none" BorderColor="transparent" BackColor="transparent"
                    runat="server" Width="100%" GridLines="horizontal" AutoGenerateColumns="False"
                    DataKeyNames="FilterId" HeaderStyle-Height="20px" HeaderStyle-Font-Bold="false">
                    <RowStyle CssClass="GridViewItems" Font-Bold="false"></RowStyle>
                    <HeaderStyle CssClass="GridHeaderStyle" Font-Bold="false"></HeaderStyle>
                    <Columns>
                        <asp:BoundField DataField="FilterId" ShowHeader="False" Visible="False" />
                        <asp:BoundField DataField="Description" HeaderStyle-Width="157px" HeaderText="Filter Name">
                            <HeaderStyle HorizontalAlign="Left" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FilterText" HeaderText="Filter Clause">
                            <HeaderStyle HorizontalAlign="Left" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="Left"  />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Clients&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Accounts&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="States&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ZipCodes&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Creditors&#160;&#160;">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="center"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Available&#160;">
                            <HeaderStyle HorizontalAlign="Right" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="Right"  />
                            <ItemTemplate>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FilterType" Visible="false">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="right"  />
                            <ItemTemplate>
                                <asp:Label ID="lblFilterType"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"FilterType") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Parent" Visible="false">
                            <HeaderStyle HorizontalAlign="center" Font-Bold="false" />
                            <ItemStyle HorizontalAlign="right"  />
                            <ItemTemplate>
                                <asp:Label ID="lblParentId"  runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ParentFilterId") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellspacing="0" cellpadding="0" width="750px">
                    <tr>
                        <td colspan="2" valign="top" style="font-family: tahoma; font-size: 11px; width: 100%;
                            color: rgb(50,112,163);">
                            <asp:Literal ID="ltSubHeader" runat="server"></asp:Literal></td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
                            <uc1:criteriaBuilder ID="ucCriteriaBuilder" Visible="True" runat="server" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
