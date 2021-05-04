<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="SDClientRetention.aspx.vb" Inherits="Clients_Enrollment_SDClientRetention" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <ajaxToolkit:ToolkitScriptManager ID="sm1" runat="server"></ajaxToolkit:ToolkitScriptManager>
    
         <script type="text/javascript" >
    
    var RepID = null;
    var SourceID = null;
    var MarketID = null;
        
    function RefreshAll()
    {
        RepID = document.getElementById("<%= ddlRep.ClientID %>");
        document.getElementById("<%=hdnRepID.ClientID %>").value = RepIDID.value;
        SourceID = document.getElementById("<%= ddlSource.ClientID %>");
        document.getElementById("<%=hdnSourceID.ClientID %>").value = SourceID.value;
        MarketID = document.getElementById("<%= ddlMarket.ClientID %>");
        document.getElementById("<%=hdnMarketID.ClientID %>").value = MarketID.value;
        <%= ClientScript.GetPostBackEventReference(lnkRefreshAll, Nothing) %>;
    }
        </script>
    
    <asp:UpdatePanel ID="updClient" runat="server">
        <ContentTemplate>
            <div style="padding-left: 15px; text-align: center; width: 98%;">
                <table class="sideRollupTable" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="sideRollupCellHeader">
                            12-Month Rolling Client Cancellation
                            <asp:Label ID="RepLbl" runat="server" Text="|      By Agent:  " Font-Size="11px" Font-Names="Tahoma"></asp:Label>
                            <asp:DropDownList ID="ddlRep" runat="server" Font-Size="11px" Font-Names="Tahoma">
                                <asp:ListItem Text="**** All ****" runat="server" Value="0" />
                            </asp:DropDownList>
                            <%--<asp:Label ID="Typelbl" runat="server" Text="|      By Lead Type:  " Font-Size="11px" Font-Names="Tahoma"></asp:Label>
                            <asp:DropDownList ID="ddlType" runat="server" Font-Size="11px" Font-Names="Tahoma">
                                <asp:ListItem Text="**** All ****" runat="server" Value="0" />
                            </asp:DropDownList>--%>
                            <asp:Label ID="Marketlbl" runat="server" Text="|      By Lead Market:  " Font-Size="11px" Font-Names="Tahoma"></asp:Label>
                            <asp:DropDownList ID="ddlMarket" runat="server" Font-Size="11px" Font-Names="Tahoma">
                                <asp:ListItem Text="**** All ****" runat="server" Value="0" />
                            </asp:DropDownList>
                            <asp:Label ID="Sourcelbl" runat="server" Text="|      By Lead Source:  " Font-Size="11px" Font-Names="Tahoma"></asp:Label>
                            <asp:DropDownList ID="ddlSource" runat="server" Font-Size="11px" Font-Names="Tahoma" >
                                <asp:ListItem Text="**** All ****" runat="server" Value="0" />
                            </asp:DropDownList>
                            <asp:Label ID="lblRefresh" runat="server" Text="|      Refresh Reports:  " Font-Size="11px" Font-Names="Tahoma"></asp:Label>
                            <asp:ImageButton ID="btnRefresh" runat="server" ImageUrl="~\images\16x16_publish.png" onclick="RefreshAll" />
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
                                        <asp:GridView ID="gvRolling" runat="server" CssClass="entry2">
											<HeaderStyle ForeColor="white" BackColor="#4791C5" />
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
                <asp:Panel ID="pnlMonth" runat="server">
                <table class="sideRollupTable" ID="Table100" runat="server" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="sideRollupCellHeader" valign="middle">
                            Client Cancellation By Month Enrolled
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
               </asp:Panel>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlYears" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="lnkRefreshAll" runat="server"></asp:LinkButton>
    <asp:HiddenField ID="hdnDate" runat="server" />
    <asp:HiddenField ID="hdnParams" runat="server" />
    <asp:HiddenField ID="hdnRepID" runat="server" />
    <asp:HiddenField ID="hdnSourceID" runat="server" />
    <asp:HiddenField ID="hdnMarketID" runat="server" />
</asp:Content>