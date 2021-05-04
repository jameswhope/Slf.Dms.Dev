<%@ Page Title="SmartDebtor Phone List" Language="VB" MasterPageFile="~/Site.master"
    AutoEventWireup="false" CodeFile="PhoneList.aspx.vb" Inherits="Clients_Enrollment_PhoneList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <!--#include file="mgrtoolbar.inc"-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../../FormMgr/FormMgr.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .modalBackground
        {
            background-color: Gray;
            filter: alpha(opacity=50);
            opacity: 0.50;
        }
        .updateProgress
        {
            border-width: 1px;
            border-style: solid;
            background-color: #FFFFFF;
            position: absolute;
            width: 180px;
            height: 65px;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="width: 235px; background-color: rgb(214,231,243); padding: 20px;" valign="top">
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Add Market
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txtMarket" runat="server" CssClass="entry2" TabIndex="1"></asp:TextBox><br />
                                                    <asp:Button ID="btnAddMarket" runat="server" Text="Add Market" CssClass="entry2">
                                                    </asp:Button>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Add Source
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:DropDownList ID="ddlMarket" runat="server" CssClass="entry2" TabIndex="3">
                                                        <asp:ListItem Text="Select Market"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <a href="EditMarkets.aspx" style="margin-left: 5px">
                                                        <img id="Img3" src="~/images/16x16_edit.gif" border="0" runat="server" alt="Edit Markets" /></a><br />
                                                    <asp:TextBox ID="txtSource" runat="server" CssClass="entry2" TabIndex="4"></asp:TextBox><br />
                                                    <asp:Button ID="btnAddSource" runat="server" Text="Add Source" CssClass="entry2"
                                                        TabIndex="5" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Phone Lists
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoneList" runat="server" CssClass="entry2" AutoPostBack="true"
                                                        TabIndex="6" ToolTip="Select Phone List to manage">
                                                    </asp:DropDownList>
                                                    <asp:ImageButton ID="btnDeletePhoneList" runat="server" ImageUrl="~/images/16x16_delete.png"
                                                        ToolTip="Delete Phone List" Style="vertical-align: middle" />
                                                    <ajaxToolkit:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" ConfirmText="Are you sure you want to delete this phone list?"
                                                        TargetControlID="btnDeletePhoneList">
                                                    </ajaxToolkit:ConfirmButtonExtender>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Create New Phone List
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txtForDate" runat="server" Width="70px" CssClass="entry2" TabIndex="7"></asp:TextBox><ajaxToolkit:CalendarExtender
                                                        ID="CalendarExtender1" runat="server" TargetControlID="txtForDate" Format="MM/dd/yyyy">
                                                    </ajaxToolkit:CalendarExtender>
                                                    <asp:Button ID="btnCreate" runat="server" Text="Create" CssClass="entry2" TabIndex="8" /><ajaxToolkit:TextBoxWatermarkExtender
                                                        ID="TextBoxWatermarkExtender1" runat="server" TargetControlID="txtForDate" WatermarkText="For Date">
                                                    </ajaxToolkit:TextBoxWatermarkExtender>
                                                    <br />
                                                    <asp:CheckBox ID="chkCopy" runat="server" Text="Copy selected phone list" CssClass="entry2"
                                                        Checked="true" TabIndex="9" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                        <div>
                            <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="sideRollupCellHeader">
                                        Common Tasks
                                    </td>
                                </tr>
                                <tr>
                                    <td class="sideRollupCellBody">
                                        <table class="sideRollupCellBodyTable" cellpadding="0" cellspacing="7" border="0">
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="btnSave" runat="server" CssClass="lnk">
                                                        <img id="Img2" src="~/images/16x16_save.png" runat="server" alt="Save" border="0"
                                                            style="vertical-align: middle" />&nbsp;&nbsp;Save Changes</asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="height: 20px;">
                            &nbsp;</div>
                    </td>
                    <td valign="top">
                        <div style="margin: 15px;">
                            <h2 id="hPhoneList" runat="server">
                                Phone List for</h2>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                DisplayAfter="0">
                                <ProgressTemplate>
                                    <div>
                                        <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                        Loading..
                                    </div>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                            <div class="box">
                                <table class="entry2" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="background-color: #f5f5f5; padding: 5">
                                            <asp:Label ID="lblLastMod" runat="server" CssClass="entry2"></asp:Label>
                                        </td>
                                        <td style="background-color: #f5f5f5; padding: 5" align="right">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvList" runat="server" AutoGenerateColumns="false" BorderWidth="0"
                                                CellPadding="5" ShowFooter="true" CssClass="entry2" DataKeyNames="LeadPhoneListID"
                                                Width="100%">
                                                <Columns>
                                                    <asp:BoundField DataField="Market" HeaderText="Market" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" />
                                                    <asp:BoundField DataField="Source" HeaderText="Source" HeaderStyle-HorizontalAlign="Left"
                                                        ItemStyle-Wrap="false" HeaderStyle-CssClass="headerbg" />
                                                    <asp:TemplateField HeaderText="Phone #" FooterText="Totals" FooterStyle-Font-Bold="true"
                                                        HeaderStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="entry2" Text='<%# DataBinder.Eval(Container.DataItem,"Phone")%>'
                                                                Width="85px"></asp:TextBox>
                                                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtPhone"
                                                                Mask="(999) 999-9999" ClearMaskOnLostFocus="true" MaskType="Number">
                                                            </ajaxToolkit:MaskedEditExtender>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Budget" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtBudget" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Budget","{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="75px"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <%#TotalBudget().ToString("C2")%>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Actual" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtActual" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Actual","{0:#####0.00}")%>'
                                                                CssClass="entry2" Width="75px" OnChange="javascript:txtActual_OnChange(this);"></asp:TextBox>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <%#TotalActual().ToString("C2")%>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="+/-" FooterStyle-Font-Bold="true" HeaderStyle-CssClass="headerbg">
                                                        <ItemTemplate>
                                                            <%#DataBinder.Eval(Container.DataItem, "Diff", "{0:C2}")%>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <%#TotalDiff().ToString("C2")%>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:ButtonField ButtonType="Image" CommandName="Remove" ShowHeader="false" ImageUrl="~/images/16x16_delete.png"
                                                        HeaderStyle-CssClass="headerbg" />
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
