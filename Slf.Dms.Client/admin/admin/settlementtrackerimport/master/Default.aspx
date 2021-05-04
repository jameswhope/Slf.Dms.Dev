<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="admin_settlementtrackerimport_master_Default"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">
        function MonthChanged(monthSelect) {
            var chosenoption = monthSelect.options[monthSelect.selectedIndex] //this refers to "selectmenu"
            if (chosenoption.value != "nothing") {
                var hdn = $get("<%=hdnMonth.ClientID %>");
                hdn.value = chosenoption.value;
                <%= ClientScript.GetPostBackEventReference(lnkChangeMonth, nothing) %>;
            }

        }
        function YearChanged(YearSelect) {
            var chosenoption = YearSelect.options[YearSelect.selectedIndex] //this refers to "selectmenu"
            if (chosenoption.value != "nothing") {
                var hdn = $get("<%=hdnYear.ClientID %>");
                hdn.value = chosenoption.value;
            }

        }
         function closePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
        }
    </script>

    <style type="text/css">
        .modalBackgroundTracker
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupTracker
        {
            background-color: #F0E68C;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            width: 50%;
        }
        .headItem5
        {
            background-color: #DCDCDC;
            border-bottom: solid 1px #d3d3d3;
            font-weight: normal;
            color: Black;
            font-size: 11px;
            font-family: tahoma;
        }
        .headItem5 a
        {
            text-decoration: none;
            display: block;
            color: Black;
            font-weight: 200;
        }
        .listItem
        {
            cursor: pointer;
            border-bottom: solid 1px #d3d3d3;
        }
        .entry
        {
            font-family: tahoma;
            font-size: 11px;
            width: 100%;
        }
        .entry2
        {
            font-family: tahoma;
            font-size: 11px;
        }
        .tdHdr
        {
            text-align: right;
        }
        .tdCnt
        {
            text-align: left;
        }
    </style>
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/default.aspx">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;Master Data
            </td>
        </tr>
        <tr>
            <td>
                <div id="dvMsg" runat="server" class="info" style="display: none; width: 50%;" />
                <asp:GridView ID="gvMaster" runat="server" AllowPaging="True" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyNames="TrackerImportID" Font-Size="X-Small"
                    PageSize="25" DataSourceID="dsMaster" UseAccessibleHeader="true" CssClass="entry"
                    GridLines="Vertical">
                    <SelectedRowStyle BackColor="#D6E7F3" />
                    <EmptyDataTemplate>
                        No Data.
                        <asp:LinkButton ID="lnknodataclear" runat="server" Text="Reset Search Filter" OnClick="lnkClear_Click" />
                    </EmptyDataTemplate>
                    <EditRowStyle Font-Size="X-Small" />
                    <PagerStyle CssClass="entry" Font-Size="X-Small" />
                    <HeaderStyle VerticalAlign="Middle" Height="30px" Font-Bold="true" />
                    <RowStyle Font-Size="8pt" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                            </HeaderTemplate>
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <input type="checkbox" runat="server" id="chk_select" />
                            </ItemTemplate>
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="LawFirm" HeaderText="Law" SortExpression="LawFirm" ReadOnly="True"
                            HtmlEncode="false">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Left" Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField HtmlEncode="false" DataField="Team" HeaderText="Team" SortExpression="Team"
                            ReadOnly="True">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Left" Wrap="false" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Negotiator" SortExpression="Negotiator">
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlNeg" runat="server" DataSourceID="dsNegotiators" AppendDataBoundItems="true"
                                    DataTextField="FullName" DataValueField="UserName" SelectedValue='<%# Bind("Negotiator") %>'>
                                    <asp:ListItem Text="" Value="" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblNeg" runat="server" Text='<%# Bind("Negotiator") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField HtmlEncode="false" DataField="Date" HeaderText="Date" SortExpression="Date"
                            DataFormatString="{0:M/d}" ReadOnly="True">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HtmlEncode="false" DataField="Status" HeaderText="Status" SortExpression="Status"
                            ReadOnly="True">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Due" SortExpression="Due">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Due","{0:d MMM}") %>'></asp:TextBox>
                                <ajaxToolkit:CalendarExtender ID="TextBox1_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="TextBox1">
                                </ajaxToolkit:CalendarExtender>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Due", "{0:d MMM}") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField HtmlEncode="false" DataField="ClientAcctNumber" HeaderText="Client Acct #"
                            SortExpression="ClientAcctNumber" ReadOnly="True">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField HtmlEncode="false" DataField="Name" HeaderText="Name" SortExpression="Name"
                            ReadOnly="True">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Left" Wrap="False" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Curr. Creditor" SortExpression="CurrentCreditor">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# eval("CurrentCreditor") + " #" + right(eval("CreditorAccountNum").tostring,4) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="left" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="left" />
                        </asp:TemplateField>
                        <asp:BoundField HtmlEncode="false" DataField="BALANCE" HeaderText="Bal" SortExpression="BALANCE"
                            DataFormatString="{0:c}">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField HtmlEncode="false" DataField="SETTLEmentAmt" HeaderText="Sett Amt"
                            SortExpression="SETTLEmentAmt" DataFormatString="{0:c}">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FundsAvail" HeaderText="Funds Avail" SortExpression="FundsAvail"
                            DataFormatString="{0:$ #,#.00}" HtmlEncode="false">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" Wrap="False" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Right" Wrap="false" />
                        </asp:BoundField>
                        <asp:CheckBoxField DataField="IsPaymentArrangement" SortExpression="IsPaymentArrangement"
                            Visible="true" HeaderText="PA">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Center" />
                            <ItemStyle CssClass="listitem" HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                        <asp:BoundField DataField="TrackerImportID" Visible="False" />
                    </Columns>
                    <PagerTemplate>
                        <div id="pager" class="entry" style="background-color: #DCDCDC; padding-left: 10px;">
                            View
                            <asp:TextBox CssClass="entry2" ID="txtPageSize" runat="server" Width="25px" EnableViewState="true"></asp:TextBox>
                            results per page
                            <asp:LinkButton CssClass="entry2" ID="lnkSavePageSize" runat="server"><strong>Save</strong></asp:LinkButton>
                            | Page(s)
                            <asp:DropDownList CssClass="entry2" ID="ddlPageSelector" runat="server" AutoPostBack="true">
                            </asp:DropDownList>
                            of
                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                            |
                            <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                ID="btnFirst" />
                            <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                ID="btnPrevious" />
                            -
                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                ID="btnNext" />
                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                ID="btnLast" />
                        </div>
                    </PagerTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="dsMaster" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    SelectCommandType="StoredProcedure" DeleteCommandType="StoredProcedure" SelectCommand="stp_settlementimport_gettrackers"
                    ProviderName="System.Data.SqlClient" UpdateCommand="UPDATE tblSettlementTrackerImports SET Negotiator=@Negotiator,Due = @Due,CreditorAccountNum=@CreditorAccountNum ,BALANCE = @BALANCE, SettlementAmt = @SettlementAmt, SettlementPercent = @SettlementPercent, FundsAvail = @fundsavail, ClientSavings = @ClientSavings, SettlementFees = @SettlementFees, sent = @sent, paid = @paid, lastmodifed= getdate(),lastmodifedby = @userid WHERE (TrackerImportID = @TrackerImportID)"
                    DeleteCommand="stp_settlementimport_deletetracker" InsertCommand="INSERT INTO [tblSettlementTrackerImports] 
	([TrackerImportBatchID],[Negotiator],[Date],[Due],[ClientAcctNumber],[Name],[CreditorAccountNum],
	[CurrentCreditor],[BALANCE],[SettlementAmt],[SettlementPercent],[ClientSavings],[SettlementFees],
	[SettlementSavingsPct],[ImportDate],[ImportBy],[AgencyID],[LawFirm],[Status],[FundsAvail],
	[Team],[OriginalCreditor],[paid],[days])
	values (
	[@TrackerImportBatchID],[@Negotiator],[@Date],[@Due],[@ClientAcctNumber],[@Name],[@CreditorAccountNum],
	[@CurrentCreditor],[@BALANCE],[@SettlementAmt],[@SettlementPercent],[@ClientSavings],[@SettlementFees],
	[@SettlementSavingsPct],[@ImportDate],[@ImportBy],[@AgencyID],[@CompanyID],[@Status],[@FundsAvail],
	[@Team],[@OriginalCreditor],[@paid],[@days]
	)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="month" />
                        <asp:Parameter DefaultValue="-1" Name="year" />
                    </SelectParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="TrackerImportID" />
                    </DeleteParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Negotiator" />
                        <asp:Parameter Name="Due" />
                        <asp:Parameter Name="CreditorAccountNum" />
                        <asp:Parameter Name="BALANCE" />
                        <asp:Parameter Name="SettlementAmt" />
                        <asp:Parameter Name="SettlementPercent" />
                        <asp:Parameter Name="fundsavail" />
                        <asp:Parameter Name="ClientSavings" />
                        <asp:Parameter Name="SettlementFees" />
                        <asp:Parameter Name="DaysInPipeline" />
                        <asp:Parameter Name="sent" />
                        <asp:Parameter Name="paid" />
                        <asp:Parameter Name="TrackerImportID" />
                        <asp:Parameter Name="UserID" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
                <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="dummyButton"
                    PopupControlID="pnlPopup" CancelControlID="imgClose" BackgroundCssClass="modalBackgroundTracker"
                    BehaviorID="programmaticModalPopupBehavior" RepositionMode="RepositionOnWindowResizeAndScroll"
                    PopupDragHandleControlID="programmaticPopupDragHandle">
                </ajaxToolkit:ModalPopupExtender>
                <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupTracker" Style="display: none;
                    border-collapse: collapse;">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;
                                border: solid 1px Gray; color: Black; text-align: center;" ToolTip="Hold left mouse button to drag.">
                                <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';" onclick="javascript:closePopup();"
                                    style="padding: 3px; width: 99%; background-color: #3D3D3D; z-index: 51; text-align: right;
                                    vertical-align: middle; border-collapse: collapse;">
                                    <div style="float: left; color: White;">
                                        Settlement Tracker Info</div>
                                    <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" />
                                </div>
                            </asp:Panel>
                            <table class="entry" style="height: 100%">
                                <tr valign="top">
                                    <td>
                                        <asp:TextBox runat="server" ID="txtTrackerImportID" Style="display: none;" />
                                        <table class="entry">
                                            <tr>
                                                <td class="tdHdr">
                                                    Team
                                                </td>
                                                <td class="tdCnt">
                                                    <asp:DropDownList ID="ddlTeam" runat="server" DataSourceID="dsTeams" AppendDataBoundItems="true"
                                                        DataTextField="FilterColumn" DataValueField="FilterColumn" CssClass="entry">
                                                        <asp:ListItem Text="" Value="" />
                                                    </asp:DropDownList>
                                                </td>
                                                <td class="tdHdr">
                                                    Negotiator
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlNegotiator" runat="server" DataSourceID="dsNegotiators"
                                                        CssClass="entry" AppendDataBoundItems="true" DataTextField="FullName" DataValueField="UserName">
                                                        <asp:ListItem Text="" Value="" />
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Agency Code
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAgencyID" runat="server" DataSourceID="dsAgencies" AppendDataBoundItems="true"
                                                        DataTextField="AgencyID" DataValueField="AgencyID" CssClass="entry">
                                                        <asp:ListItem Text="" Value="" />
                                                    </asp:DropDownList>
                                                </td>
                                                <td class="tdHdr">
                                                    Law Firm
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLawFirm" runat="server" DataSourceID="dsFirms" AppendDataBoundItems="true"
                                                        DataTextField="shortconame" DataValueField="shortconame" CssClass="entry" Enabled ="false">
                                                        <asp:ListItem Text="" Value="" />
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Date
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDate" runat="server" CssClass="entry" Enabled ="false"/>
                                                    <ajaxToolkit:CalendarExtender ID="txtDate_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="txtDate">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                                <td class="tdHdr">
                                                    Due
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDue" runat="server" CssClass="entry" />
                                                    <ajaxToolkit:CalendarExtender ID="txtDue_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="txtDue">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Client Acct#
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtClientAcctNumber" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Orig. Creditor
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtOriginalCreditor" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Name
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtName" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Curr. Creditor
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtCurrentCreditor" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Bal
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtBALANCE" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Creditor Acct#
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtCreditorAccountNum" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Settlement $
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtSettlementAmt" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Client Savings
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtClientSavings" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Funds Avail
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtFundsAvail" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Settlement Fees
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtSettlementFees" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Settlement %
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtSettlementPercent" CssClass="entry" Enabled ="false"/>
                                                </td>
                                                <td class="tdHdr">
                                                    Settlement Fee %
                                                </td>
                                                <td>
                                                    <asp:TextBox runat="server" ID="txtSettlementSavingsPct" CssClass="entry" Enabled ="false"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Sent
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtsent" runat="server" CssClass="entry" />
                                                    <ajaxToolkit:CalendarExtender ID="txtSent_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="txtsent">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                                <td class="tdHdr">
                                                    Paid
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtpaid" runat="server" CssClass="entry" />
                                                    <ajaxToolkit:CalendarExtender ID="txtPaid_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="txtPaid">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Status
                                                </td>
                                                <td colspan="3">
                                                    <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="dsStatus" AppendDataBoundItems="true"
                                                        DataTextField="description" DataValueField="code" CssClass="entry2" Enabled ="false">
                                                        <asp:ListItem Text="" Value="" />
                                                        <asp:ListItem Text="Funds" Value="FUNDS" />
                                                        <asp:ListItem Text="Hold" Value="HOLD" />
                                                        <asp:ListItem Text="Money" Value="MONEY" />
                                                        <asp:ListItem Text="Ready" Value="READY" />
                                                        <asp:ListItem Text="Sent" Value="SENT" />
                                                        <asp:ListItem Text="SIF" Value="SIF" />
                                                        <asp:ListItem Text="Verbal" Value="VERBAL" />
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="tdHdr">
                                                    Note
                                                </td>
                                                <td colspan="3">
                                                    <asp:TextBox runat="server" ID="txtNote" TextMode="MultiLine" Rows="3" CssClass="entry" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="background-color: #DCDCDC">
                                        <table class="entry2" border="0">
                                            <tr style="white-space: nowrap; font-size: 12px;">
                                                <td>
                                                    <asp:LinkButton ID="btnSave" runat="server" Text="Save Changes" CssClass="lnk" />
                                                    |
                                                </td>
                                                <td id="tdCancel" runat="server">
                                                    <asp:LinkButton ID="btnCancel" runat="server" Text="Cancel Settlement" CssClass="lnk"
                                                        OnClientClick="return confirm('Are you sure you want to cancel this settlement?');" />
                                                    |
                                                </td>
                                                <td id="tdReactivate" runat="server">
                                                    <asp:LinkButton ID="btnReactivate" runat="server" Text="Reverse Cancellation" CssClass="lnk"
                                                        OnClientClick="return confirm('Are you sure you want to erase the cancel date for this settlement?');" />
                                                    |
                                                </td>
                                                <td>
                                                    <asp:LinkButton ID="btnDelete" runat="server" Text="Delete Settlement" CssClass="lnk"
                                                        OnClientClick="return confirm('Are you sure you want to delete this settlement?');" />
                                                    |
                                                </td>
                                                <td>
                                                    <asp:LinkButton ID="btnClose" runat="server" Text="Close" CssClass="lnk" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td valign="top" style="height: 100%">
            </td>
        </tr>
    </table>
    <asp:GridView ID="gvExport" runat="server" />
    <asp:SqlDataSource ID="dsNegotiators" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select FullName, [username]=FullName from (SELECT FirstName + ' ' + LastName AS [FullName],username FROM tblUser WHERE (UserGroupID = 4)  and locked = 0 ) as userdata order by fullname">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsTeams" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select distinct team[FilterColumn] from tblsettlementtrackerimports order by team">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsAgencies" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select distinct agencyid from tblagency order by agencyid">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsFirms" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select distinct companyid, shortconame from tblcompany order by companyid">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsStatus" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select distinct code,description from tblaccountstatus order by code">
    </asp:SqlDataSource>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
</asp:Content>
