<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="FormMgr_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height:28px">
                <a id="A1" runat="server" class="menuButton" href="Default.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_form.png" />Forms</a>
            </td>
            <!--<td class="menuSeparator">
                |
            </td>-->
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="FormMgr.css" rel="stylesheet" type="text/css" />

            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 175px; background-color: rgb(214,231,243); padding:20px;" valign="top">
                        &nbsp;
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <div class="grey">
                                <a class="greylnk" href="Default.aspx">Forms</a>&nbsp;>&nbsp;Select a form
                            </div>
                            <h2>
                                Form Manager
                            </h2>
                            <div>
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            Forms
                                        </td>
                                        <td style="background-color: #f5f5f5; padding: 5" align="right">
                                            <asp:LinkButton ID="lnkAdd" runat="server" CssClass="lnk">Add Form</asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvForms" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="4" CssClass="entry2" DataKeyNames="FormID">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle">
                                                        <HeaderTemplate>
                                                            <img src="~/images/16x16_icon.png" runat="server" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a href='FormContent.aspx?fid=<%# DataBinder.Eval(Container.DataItem,"FormID")%>'
                                                                title="Edit">
                                                                <img src="~/images/16x16_edit.gif" border="0" runat="server" /></a>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:ButtonField ButtonType="Image" CommandName="Delete" ImageUrl="~/images/16x16_delete.png"
                                                        HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle" />
                                                    <asp:BoundField DataField="FormName" ItemStyle-Wrap="false" HeaderText="Form" HeaderStyle-CssClass="headerbg"
                                                        ItemStyle-CssClass="itemstyle" />
                                                    <asp:BoundField DataField="LastModified" HeaderText="Last Modified" HeaderStyle-CssClass="headerbg"
                                                        ItemStyle-CssClass="itemstyle2" />
                                                    <asp:BoundField DataField="LastModBy" HeaderText="Last Modified By" HeaderStyle-CssClass="headerbg"
                                                        ItemStyle-CssClass="itemstyle" />
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>

</asp:Content>
