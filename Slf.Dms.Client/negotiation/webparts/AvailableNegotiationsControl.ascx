<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AvailableNegotiationsControl.ascx.vb"
    Inherits="negotiation_webparts_AvailableNegotiationsControl" EnableViewState="true" %>

<script language="JavaScript">
  window.onbeforeunload = confirmExit;
  function confirmExit()
  {
    <%=Page.ClientScript.GetPostBackEventReference(lnkCloseSession, Nothing) %>;
  }
</script>

<asp:UpdatePanel ID="upavailneg" UpdateMode="Conditional" runat="server">
    <ContentTemplate>
        <table width="100%">
            <tr id="trFilter" runat="server" style="display:block;">
                <td>
                    <table style="background-color: #E3E3F0; width: 100%;">
                        <tr>
                            <td align="left">
                                <div style="vertical-align: bottom;">
                                    <asp:Label ID="lblFilter" runat="server" Text="Filter By" />
                                    <asp:DropDownList AutoPostBack="false" Style="height: 18px; font-size: 8pt;" ID="ddlColumns"
                                        runat="server">
                                        <asp:ListItem Value="ApplicantFirstName">First Name</asp:ListItem>
                                        <asp:ListItem Value="ApplicantLastName">Last Name</asp:ListItem>
                                        <asp:ListItem Value="CurrentCreditor">Current Creditor</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:TextBox ID="txtFilter" EnableViewState="true" Style="font-size: 8pt;" runat="server" />
                                    <asp:ImageButton ID="ibtnFilter" runat="server" Text="Filter" ImageUrl="~/negotiation/images/filter_off.png"
                                        OnClick="ibtnFilter_Click" onmouseout="this.src='../../negotiation/images/filter_off.png';"
                                        onmouseover="this.src='../../negotiation/images/filter_on.png';" />
                                    <asp:ImageButton ID="lnkReset" runat="server" Text="Clear Filter" ImageUrl="~/negotiation/images/clear_filter_off.png"
                                        OnClick="lnkReset_Click" onmouseout="this.src='../../negotiation/images/clear_filter_off.png';"
                                        onmouseover="this.src='../../negotiation/images/clear_filter_on.png';" />
                                </div>
                            </td>
                            <td align="right">
                                <asp:Label ID="Label1" runat="server" Text="Go to Page " />
                                <asp:DropDownList AutoPostBack="true" ID="ddlPage" runat="server" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                </asp:DropDownList>
                                of
                                <asp:Label ID="lblTotalPages" runat="server" Text="" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="GridView1" Width="100%" runat="server" AllowSorting="True" AllowPaging="false"
                        BorderStyle="None" AutoGenerateColumns="False" CellPadding="4" 
                        DataKeyNames="AccountID,ClientID" ForeColor="#333333" GridLines="None" OnRowDataBound="GridView1_RowDataBound"
                        OnRowCommand="GridView1_RowCommand" OnSorting="GridView1_Sorting" OnRowCreated="GridView1_RowCreated">
                        <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                        <HeaderStyle CssClass="webpartgridhdrstyle" />
                        <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                        <RowStyle CssClass="webpartgridrowstyle" />
                        <Columns>
                            <asp:BoundField DataField="ApplicantFullName" HeaderText="Applicant" SortExpression="ApplicantFullName">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FundsAvailable" DataFormatString="{0:c}" HtmlEncode="False" SortExpression="FundsAvailable"
                                HeaderText="Available" >
                                <HeaderStyle HorizontalAlign="Right" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CurrentCreditor" HeaderText="Current Creditor" SortExpression="CurrentCreditor">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="currentcreditoraccountnumber" HeaderText="Acct #"  SortExpression="currentcreditoraccountnumber" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CurrentAmount" DataFormatString="{0:c}" HtmlEncode="False"
                                HeaderText="Current Amount" SortExpression="CurrentAmount">
                                <HeaderStyle HorizontalAlign="Right" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AccountStatus" HeaderText="Status" SortExpression="AccountStatus">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastOffer" HeaderText="Last Offer" SortExpression="LastOffer">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Offer Direction" SortExpression="OfferDirection">
                                <ItemTemplate>
                                    <asp:Image ID="imgDir" runat="server" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            No Assignments.
                            <asp:ImageButton ID="lnkReset" runat="server" Text="Clear Filter" ImageUrl="~/negotiation/images/clear_filter_off.png"
                                OnClick="lnkReset_Click" />
                        </EmptyDataTemplate>
                        <PagerSettings Position="Top" Mode="NumericFirstLast" PageButtonCount="20" />
                    </asp:GridView>
                </td>
            </tr>
        </table>
        <asp:LinkButton ID="lnkCloseSession" runat="server" />
        <asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnIds" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnSQL" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnNegGuid" runat="server" EnableViewState="true" />
        <asp:HiddenField ID="hdnNoteID" runat="server" EnableViewState="true" />
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="PageIndexChanging" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="Sorting" />
        <asp:AsyncPostBackTrigger ControlID="GridView1" EventName="RowCommand" />
    </Triggers>
</asp:UpdatePanel>
