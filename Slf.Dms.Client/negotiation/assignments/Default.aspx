<%@ Page Language="VB" MasterPageFile="~/negotiation/Negotiation.master" AutoEventWireup="false"
    EnableEventValidation="false" CodeFile="Default.aspx.vb" Inherits="negotiation_assignments_Default"
    Title="My Settlements" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:UpdatePanel ID="upAssignments" runat="server">
        <ContentTemplate>
            <div class="entry" style="padding: 20px;">
                <fieldset>
                    <legend style="font-family: Tahoma; font-size: 16px; font-weight: bold; padding-bottom: 10px;">
                        Settlement Totals</legend>
                    <asp:GridView ID="gvSummary" runat="server" AutoGenerateColumns="False" BackColor="White"
                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" CssClass="entry"
                        DataSourceID="dsSummary" ForeColor="Black" GridLines="Vertical">
                        <RowStyle BackColor="#F7F7DE" />
                        <Columns>
                            <asp:BoundField DataField="NegotiatorName" HeaderText="Negotiator" SortExpression="NegotiatorName"
                                HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="left" Visible="true" />
                            <asp:BoundField DataField="TotalFees" DataFormatString="{0:c}" HeaderText="Total Fees"
                                ReadOnly="True" SortExpression="TotalFees" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="TotalBalance" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" HeaderText="Total Bal" ReadOnly="True" SortExpression="TotalBalance" />
                            <asp:BoundField DataField="TotalSettAmt" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" HeaderText="Total Sett Amt" ReadOnly="True"
                                SortExpression="TotalSettAmt" />
                            <asp:BoundField DataField="TotalUnits" HeaderText="Total Units" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"
                                ItemStyle-HorizontalAlign="Center" SortExpression="TotalUnits" />
                            <asp:BoundField DataField="TotalAvgPct" HeaderText="Total Avg Pct" DataFormatString="{0:p2}"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ReadOnly="True"
                                SortExpression="TotalAvgPct" />
                            <asp:BoundField DataField="PaidFees" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" HeaderText="Total Paid Fees" ReadOnly="True"
                                SortExpression="PaidFees" />
                            <asp:BoundField DataField="PaidBalance" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" HeaderText="Total Paid Bal" ReadOnly="True"
                                SortExpression="PaidBalance" />
                            <asp:BoundField DataField="PaidSettAmt" DataFormatString="{0:c}" HeaderStyle-HorizontalAlign="Right"
                                ItemStyle-HorizontalAlign="Right" HeaderText="Total Paid Sett Amt" ReadOnly="True"
                                SortExpression="PaidSettAmt" />
                            <asp:BoundField DataField="PaidUnits" HeaderText="Total Paid Units" ReadOnly="True"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" SortExpression="PaidUnits" />
                            <asp:BoundField DataField="PaidAvgPct" HeaderText="Paid Avg Pct" DataFormatString="{0:p2}"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ReadOnly="True"
                                SortExpression="PaidAvgPct" />
                            <asp:BoundField DataField="PctPaid" HeaderText="Pct Paid" ReadOnly="True" DataFormatString="{0:p2}"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" SortExpression="PctPaid" />
                            <asp:BoundField DataField="AllSubmissions" HeaderText="AllSubmissions" HeaderStyle-HorizontalAlign="Center"
                                ItemStyle-HorizontalAlign="Center" ReadOnly="True" SortExpression="AllSubmissions"
                                Visible="false" />
                            <asp:BoundField DataField="PaidAvgFee" HeaderText="PaidAvgFee" ReadOnly="True" DataFormatString="{0:p2}"
                                HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" SortExpression="PaidAvgFee"
                                Visible="false" />
                        </Columns>
                         <EmptyDataTemplate>
                                        <div class="info">
                                            No summary data available!
                                        </div>
                                    </EmptyDataTemplate>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="dsSummary" ConnectionString="<%$ AppSettings:connectionstring %>"
                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_settlements_getTotalsByUserID"
                        SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:Parameter Name="userid" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </fieldset>
                <fieldset>
                    <legend style="font-family: Tahoma; font-size: 16px; font-weight: bold; padding-bottom: 10px;">
                        Pending Settlements</legend>
                    <table class="entry" cellpadding="0" cellspacing="0">
                        
                        <tr style="background-color: #4791C5; height: 30px; color: White;">
                            <td style="padding-left: 5px;">
                                <asp:CheckBox ID="chkShowPaid" runat="server" Text="Show Paid" AutoPostBack="true" />
                            </td>
                            <td style="text-align: right; padding-right: 5px;">
                                <asp:LinkButton ID="lnkExportExcel" runat="server" CssClass="lnk" ForeColor="White">
                                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/16x16_edit.gif" />
                                    Export Excel
                                </asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:GridView ID="gvAssignments" runat="server" AllowSorting="True" AllowPaging="true" PageSize="50"
                                    AutoGenerateColumns="False" DataKeyNames="SettlementID" DataSourceID="dsAssignments"
                                    CssClass="entry" CellPadding="4" ForeColor="#333333">
                                    <RowStyle BackColor="#FFFBD6" ForeColor="#333333" VerticalAlign="Top" />
                                    <Columns>
                                        <asp:BoundField DataField="Team" HeaderText="Team" SortExpression="Team"  Visible="true">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="False"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="true"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Negotiator" HeaderText="Negotiator" ReadOnly="True" SortExpression="Negotiator"
                                             Visible="true">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="true"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SettlementID" HeaderText="SettlementID" InsertVisible="False"
                                            ReadOnly="True" SortExpression="SettlementID" HeaderStyle-CssClass="headItem5"
                                            ItemStyle-CssClass="listItem" Visible="false">
                                            <HeaderStyle CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                         <asp:BoundField DataField="ClientAcctNum" HeaderText="600 #" InsertVisible="False"
                                            ReadOnly="True" SortExpression="ClientAcctNum" HeaderStyle-CssClass="headItem5"
                                            ItemStyle-CssClass="listItem" Visible="true">
                                            <HeaderStyle CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Client Name" SortExpression="ClientName">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="lnkClientName" runat="server" CssClass="lnk" />
                                           
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Client CDA Bal" HeaderText="CDA Bal" SortExpression="Client CDA Bal"
                                            DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="right" ItemStyle-HorizontalAlign="right">
                                            <HeaderStyle HorizontalAlign="Right" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Right" CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Creditor" SortExpression="CreditorName">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="lnkCreditorName" runat="server" CssClass="lnk" />
                                           
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="true" />
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField DataField="CreditorBal" HeaderText="Creditor Bal" SortExpression="CreditorBal"
                                            DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="right" ItemStyle-HorizontalAlign="right">
                                            <HeaderStyle HorizontalAlign="Right" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Right" CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="AccountStatus" HeaderText="Account Status" SortExpression="AccountStatus"
                                            HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" HeaderStyle-HorizontalAlign="Left"
                                            ItemStyle-HorizontalAlign="Left">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" Wrap="true"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Sett Due Date" SortExpression="SettlementDueDate">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("SettlementDueDate", "{0:d}") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="SettlementAmt" HeaderText="Sett Amt" DataFormatString="{0:c2}"
                                            SortExpression="SettlementAmt" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="right" ItemStyle-HorizontalAlign="right">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="SettlementFee" HeaderText="Sett Fee" SortExpression="SettlementFee"
                                            DataFormatString="{0:c2}" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right">
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Client Stipulation" HeaderText="Client Stip" SortExpression="Client Stipulation"
                                            HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" HeaderStyle-HorizontalAlign="Center"
                                            ItemStyle-HorizontalAlign="Center" ReadOnly="True">
                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="25"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="25"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Payment Arrangement" HeaderText="Payment Arrangement"
                                            ReadOnly="True" SortExpression="Payment Arrangement" HeaderStyle-CssClass="headItem5"
                                            ItemStyle-CssClass="listItem" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="50"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="50"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Restrictive Endorsement" HeaderText="REL" ReadOnly="True"
                                            SortExpression="Restrictive Endorsement" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="LC Approval" HeaderText="LC Approval" ReadOnly="True"
                                            SortExpression="LC Approval" HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem"
                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="50"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="50"></ItemStyle>
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True" SortExpression="Status"
                                            HeaderStyle-CssClass="headItem5" ItemStyle-CssClass="listItem" HeaderStyle-HorizontalAlign="Left"
                                            ItemStyle-HorizontalAlign="Left" Visible="true">
                                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" ></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" ></ItemStyle>
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Created" SortExpression="Created">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCreated" runat="server" Text='<%# Bind("Created", "{0:d}") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Paid" SortExpression="PaidDate">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPaidDate" runat="server" Text='<%# Bind("PaidDate", "{0:d}") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                        </asp:TemplateField>
                                        

                                        <asp:BoundField DataField="ClientID" HeaderText="ClientID" 
                                            SortExpression="ClientID" Visible="False" />
                                        <asp:BoundField DataField="CreditorAccountID" HeaderText="CreditorAccountID" 
                                            SortExpression="CreditorAccountID" Visible="False" />
                                        

                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="info">
                                            You have no settlements!
                                        </div>
                                    </EmptyDataTemplate>
                                    <PagerTemplate>
                                        <div id="pager">
                                            <table class="entry">
                                                <tr class="entry2">
                                                    <td style="padding-left: 10px;">
                                                        Page
                                                        <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2"
                                                            OnSelectedIndexChanged="pageSelector_SelectedIndexChanged" />
                                                        of
                                                        <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                    </td>
                                                    <td style="padding-right: 10px; text-align: right;">
                                                        <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                            ID="btnFirst" />
                                                        <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                            ID="btnPrevious" />
                                                        -
                                                        <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                            ID="btnNext" />
                                                        <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                            ID="btnLast" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </PagerTemplate>
                                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                                    <HeaderStyle Font-Bold="True" ForeColor="Black" VerticalAlign="Bottom" />
                                    <AlternatingRowStyle BackColor="White" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="dsAssignments" ConnectionString="<%$ AppSettings:connectionstring %>"
                                    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_settlements_getPendingByUserID"
                                    SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:Parameter Name="userid" Type="Int32" />
                                        <asp:Parameter Name="includePaid" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                 <div id="updateHarassDiv" style="display: none; height: 40px; width: 40px">
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
        </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="lnkExportExcel" />
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript">

    function onUpdating() {
        // get the update progress div
        var updateProgressDiv = $get('updateHarassDiv');
        // make it visible
        updateProgressDiv.style.display = '';

        //  get the gridview element
        var gridView = $get('gvAssignments');

        // get the bounds of both the gridview and the progress div
        var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
        var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

        //    do the math to figure out where to position the element (the center of the gridview)
        var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
        var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

        //    set the progress element to this position
        Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
    }

    function onUpdated() {
        // get the update progress div
        var updateProgressDiv = $get('updateHarassDiv');
        // make it invisible
        updateProgressDiv.style.display = 'none';
    }
             
</script>

<ajaxToolkit:UpdatePanelAnimationExtender ID="upaeAssignments" BehaviorID="Assignmentsanimation"
    runat="server" TargetControlID="upAssignments">
    <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="gvAssignments" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="gvAssignments" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
    </Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
