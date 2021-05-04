<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="FormContent.aspx.vb" Inherits="FormMgr_FormContent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height:28px">
                <a runat="server" class="menuButton" href="Default.aspx">
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
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 175px; background-color: rgb(214,231,243); padding:20px;" valign="top">
                        <div class="TaskBox">
                            <h6>
                                <span>Common Tasks</span></h6>
                            <div class="last">
                                <img src="~/images/16x16_save.png" runat="server" alt="Save" />
                                <asp:LinkButton ID="lnkSave" runat="server" CssClass="lnk">Save Changes</asp:LinkButton>
                            </div>
                        </div>
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <div class="grey">
                                <a class="greylnk" href="Default.aspx">Forms</a>&nbsp;>&nbsp;<asp:Label ID="lblFormName"
                                    runat="server" CssClass="grey"></asp:Label>
                            </div>
                            <h2 id="hFormName" runat="server">
                            </h2>
                            <div>
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            Form Content
                                        </td>
                                        <td style="background-color: #f5f5f5; padding: 5" align="right">
                                            <asp:LinkButton ID="lnkAdd" runat="server" CssClass="lnk">Add Content</asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvFormContent" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="4" ShowFooter="true" CssClass="entry2" DataKeyNames="FormContentID">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle">
                                                        <HeaderTemplate>
                                                            <img src="~/images/16x16_icon.png" runat="server" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a href='AddEdit.aspx?id=<%# DataBinder.Eval(Container.DataItem,"FormContentID")%>'
                                                                title="Edit">
                                                                <img id="Img2" src="~/images/16x16_edit.gif" border="0" runat="server" /></a>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:ButtonField ButtonType="Image" CommandName="Delete" ImageUrl="~/images/16x16_delete.png"
                                                        HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle" />
                                                    <asp:TemplateField HeaderText="Show" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chkShow" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"Show")%>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Seq" HeaderStyle-CssClass="headerbg" ItemStyle-CssClass="itemstyle">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtSeq" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Seq")%>'
                                                                CssClass="entry2" Width="50px"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Title" ItemStyle-Wrap="false" HeaderText="Title" HeaderStyle-CssClass="headerbg"
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
