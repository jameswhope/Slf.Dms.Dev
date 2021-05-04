<%@ Page Title="" Language="VB" MasterPageFile="~/Agency/agency.master" AutoEventWireup="false"
    CodeFile="client_retention.aspx.vb" Inherits="Agency_client_retention" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphAgencyBody" runat="Server">
    <asp:UpdatePanel ID="updClient" runat="server">
        <ContentTemplate>
            <div style="padding-left: 15px; text-align: center; width: 98%;">
                <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="sideRollupCellHeader">
                            24-Month Rolling Client Retention
                        </td>
                    </tr>
                    <tr>
                        <td class="sideRollupCellBody">
                            <table id="Table2" runat="server" class="sideRollupCellBodyTable" cellpadding="0"
                                cellspacing="7" border="0">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblRollingTot" runat="server" />
                                        <br />
                                        <br />
                                        <asp:GridView ID="gvRolling" runat="server" Height="150px" Width="100%" CssClass="entry2">
											<HeaderStyle ForeColor="white" BackColor="#4791C5" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
                <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="sideRollupCellHeader" valign="middle">
                            Client Retention By Month Enrolled
                        </td>
                    </tr>
                    <tr>
                        <td class="sideRollupCellBody">
                            <table id="Table1" runat="server" class="sideRollupCellBodyTable" cellpadding="0"
                                cellspacing="7" border="0">
                                <tr>
                                    <td>
                                        <table class="paramTable" cellpadding="0" cellspacing="0">
                                            <tr style="padding: 5px; vertical-align: middle;">
                                                <td style="">
                                                    <asp:Label ID="Label1" runat="server" Text="Select Enrollment" />
                                                    <asp:Label ID="Label3" runat="server" Text="Year " />
                                                    <asp:DropDownList ID="ddlYears" runat="server" AutoPostBack="True"  Width="55px" />
                                                    <asp:UpdateProgress ID="uppDay" runat="server" AssociatedUpdatePanelID="updClient">
                                                        <ProgressTemplate>
                                                            Refreshing Chart...
                                                            <asp:Image ID="imgWaiting" runat="server" ImageUrl="~/images/loading.gif" />
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                            </tr>
                                        </table>
                                        <br />
                                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlYears" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hdnDate" runat="server" />
</asp:Content>
