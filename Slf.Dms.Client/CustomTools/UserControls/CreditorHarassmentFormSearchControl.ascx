<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CreditorHarassmentFormSearchControl.ascx.vb"
    Inherits="CustomTools_UserControls_CreditorHarassmentFormSearchControl" %>

<style type="text/css">
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
    .modalBackgroundHarassSearch
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .modalPopupHarassSearch
    {
        background-color: #D6E7F3;
        border-width: 3px;
        border-style: solid;
        border-color: Gray;
        padding: 3px;
        width: 60%;
        height: 400px;
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
    .searchBox
    {
        display: block;
    }
    .searchBox *
    {
        display: block;
        height: 1px;
        overflow: hidden;
        font-size: .01em;
        background: #DCDCDC;
    }
    .searchBox1
    {
        margin-left: 3px;
        margin-right: 3px;
        padding-left: 1px;
        padding-right: 1px;
        border-left: 1px solid #efefef;
        border-right: 1px solid #efefef;
        background: #e4e4e4;
    }
    .searchBox2
    {
        margin-left: 1px;
        margin-right: 1px;
        padding-right: 1px;
        padding-left: 1px;
        border-left: 1px solid #fbfbfb;
        border-right: 1px solid #fbfbfb;
        background: #e2e2e2;
    }
    .searchBox3
    {
        margin-left: 1px;
        margin-right: 1px;
        border-left: 1px solid #e2e2e2;
        border-right: 1px solid #e2e2e2;
    }
    .searchBox4
    {
        border-left: 1px solid #efefef;
        border-right: 1px solid #efefef;
    }
    .searchBox5
    {
        border-left: 1px solid #e4e4e4;
        border-right: 1px solid #e4e4e4;
    }
    .searchBoxfg
    {
        background: #DCDCDC;
    }
    .submitHdr
    {
        text-align: right;
        width: 35px;
        font-weight: bold;
    }
    .submitCnt
    {
        text-align: left;
    }
    .clientHdr
    {
        text-align: right;
        width: 35px;
        font-weight: bold;
    }
    .clientCnt
    {
        text-align: left;
    }
    .creditorHdr
    {
        text-align: right;
        width: 55px;
        font-weight: bold;
    }
    .creditorCnt
    {
        text-align: left;
    }
    .statusHdr
    {
        text-align: right;
        width: 45px;
        font-weight: bold;
    }
    .statusCnt
    {
        text-align: left;
    }
       .faux-button
        {
            cursor: pointer;
            white-space: nowrap;
            vertical-align: middle;
            padding:5px;
        }
</style>

<script type="text/javascript">
    function showDetail(subId) {
        var frm = $get("<%= frameForm.ClientID %>")
        frm.src = subId
        $find("<%=ModalPopupExtender1.ClientID %>").show();
    }
    function SetDates(ddl) {
        var txtTransDate1 = document.getElementById("<%=txtStart.ClientId %>");
        var txtTransDate2 = document.getElementById("<%=txtEnd.ClientId %>");

        var str = ddl.value;
        if (str != "Custom") {
            var parts = str.split(",");
            txtTransDate1.value = parts[0];
            txtTransDate2.value = parts[1];
        }
    }
</script>

<asp:UpdatePanel ID="upHarassSearch" runat="server">
    <ContentTemplate>
        <ajaxToolkit:TabContainer ID="tcHarass" runat="server" CssClass="tabcontainer">
            <ajaxToolkit:TabPanel ID="tpSearch" runat="server">
                <HeaderTemplate>
                    Harassment Search
                </HeaderTemplate>
                <ContentTemplate>
                    <div style="padding: 5px;" class="entry">
                        <table class="entry" id="divHarassSearch" border="0">
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Panel ID="pnlSearchBox" runat="server" CssClass="entry" Height="20" >
                                        <table class="entry" border="0" cellpadding="1" cellspacing="0">
                                            <tr style="white-space: nowrap; background-color: #DCDCDC">
                                                <td style="padding-left: 5px;width:240px;">
                                                    Select Search Column:
                                                    <asp:DropDownList ID="ddlSearchColumn" runat="server" CssClass="entry2" AutoPostBack="true"
                                                        ToolTip="Column to search">
                                                        <asp:ListItem Selected="True">Select Column</asp:ListItem>
                                                    </asp:DropDownList>
                                               </td>
                                               <td>
                                                    <asp:DropDownList ID="ddlSearch" runat="server" Visible="false" CssClass="entry"
                                                        ToolTip="select value to find in column" Width="150"/>
                                                    <asp:TextBox ID="txtSearch" runat="server" Visible="false" Width="150" CssClass="entry"
                                                        ToolTip="enter value to find in column" />
                                                    <div id="divDateSearch" runat="server" style="display: none;">
                                                        <asp:Label ID="Label2" runat="server" Text="Range:" />
                                                        <asp:DropDownList Style="font-size: 11px; font-family: Tahoma" ID="ddlQuickPickDate"
                                                            runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuickPickDate_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                        <asp:Label ID="Label1" runat="server" Text="Start Date:" />
                                                        <asp:TextBox ID="txtStart" runat="server" CssClass="entry2" ToolTip="select start date" />
                                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtStart"
                                                            CssClass="MyCalendar" />
                                                        <asp:Label ID="Label3" runat="server" Text="End Date:" />
                                                        <asp:TextBox ID="txtEnd" runat="server" CssClass="entry2" ToolTip="select end date" />
                                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtEnd"
                                                            CssClass="MyCalendar" />
                                                    </div>
                                                </td>
                                                <td style="padding-right:5px; padding-left:5px; text-align: center;width:100px;">
                                                    <asp:LinkButton ID="lnkSearch" runat="server" Text="Search" CssClass="lnk" />
                                                    |
                                                    <asp:LinkButton ID="lnkClear" runat="server" Text="Clear" CssClass="lnk" />
                                                </td>
                                                <td style="padding-right: 15px; text-align:right; width:100px; ">
                                                    <asp:Label ID="lblResultCnt" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <ajaxToolkit:RoundedCornersExtender ID="pnlSearchBox_RoundedCornersExtender" runat="server"
                                     TargetControlID="pnlSearchBox" Radius="5" Corners="All" Color="#DCDCDC" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="gvSearch" runat="server" AllowPaging="True" AllowSorting="True"
                                        AutoGenerateColumns="False" DataKeyNames="ClientSubmissionID" DataSourceID="dsSearch"
                                        PageSize="10" Font-Size="8pt" ToolTip="Double click a row to see abuse form."
                                        CssClass="entry">
                                        <AlternatingRowStyle BackColor="#F3F3F3" />
                                        <Columns>
                                            <asp:BoundField DataField="ClientSubmissionID" HeaderText="ClientSubmissionID" InsertVisible="False"
                                                ReadOnly="True" SortExpression="ClientSubmissionID" Visible="False" />
                                            <asp:BoundField DataField="ClientAccountNumber" HeaderText="Acct #" SortExpression="ClientAccountNumber"
                                                HeaderStyle-Wrap="false" ReadOnly="True" Visible="False">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="ClientName" HeaderText="Client Name" SortExpression="ClientName"
                                                HeaderStyle-Wrap="false" ReadOnly="True" Visible="False">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="ClientState" HeaderText="State" SortExpression="ClientState"
                                                ReadOnly="True" Visible="False">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="OriginalCreditorName" HeaderText="Orig. Creditor" SortExpression="OriginalCreditorName"
                                                ReadOnly="True" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CurrentCreditorName" HeaderText="Curr. Creditor" SortExpression="CurrentCreditorName"
                                                ReadOnly="True" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="CreatedByUser" HeaderText="Created By" ReadOnly="True"
                                                SortExpression="CreatedByUser" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="IndividualCallingDateOfCall" DataFormatString="{0:d}"
                                                ReadOnly="True" HeaderText="Date Of Call" SortExpression="IndividualCallingDateOfCall"
                                                Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="IndividualCallingTimeOfCall" HeaderText="Time Of Call"
                                                ReadOnly="True" SortExpression="IndividualCallingTimeOfCall" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="DateFormSubmitted" DataFormatString="{0:d}" HeaderText="Date Submitted"
                                                ReadOnly="True" SortExpression="DateFormSubmitted" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" VerticalAlign="Top" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Reason" SortExpression="ReasonData" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="Old_lblReason" runat="server" Width="300" Text='<%# eval("ReasonData") %>' />
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="20%" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="true" Font-Size="8pt"
                                                    Width="20%" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="HarassmentStatusDate" HeaderText="Status Date" SortExpression="HarassmentStatusDate"
                                                ReadOnly="True" Visible="false">
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Status" SortExpression="StatusDescription" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label ID="Old_lblStatus" runat="server" Text='<%# eval("StatusDescription") %>' /><br />
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="Old_ddlStatus" runat="server" DataSourceID="dsStatus" DataTextField="StatusDescription"
                                                        DataValueField="HarassmentStatusID" AppendDataBoundItems="true">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="Old_dsStatus" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="SELECT [HarassmentStatusID], [StatusDescription] FROM [tblHarassmentStatusReasons] Order By StatusDescription">
                                                    </asp:SqlDataSource>
                                                </EditItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Submitted/Created By Info">
                                                <ItemTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td class="submitHdr">
                                                                Date:
                                                            </td>
                                                            <td class="submitCnt">
                                                                <asp:Label ID="lblSubmittedDate" runat="server" Text='<%#eval("DateFormSubmitted") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="submitHdr">
                                                                By:
                                                            </td>
                                                            <td class="submitCnt">
                                                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#eval("CreatedByUser") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Client Info">
                                                <ItemTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td class="clientHdr">
                                                                Acct#:
                                                            </td>
                                                            <td class="clientCnt">
                                                                <asp:Label ID="lblAcctNum" runat="server" Text='<%#eval("ClientAccountNumber") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="clientHdr">
                                                                Name:
                                                            </td>
                                                            <td class="clientCnt">
                                                                <asp:Label ID="lblClientName" runat="server" Text='<%#eval("ClientName") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="clientHdr">
                                                                State:
                                                            </td>
                                                            <td class="clientCnt">
                                                                <asp:Label ID="lblClientState" runat="server" Text='<%#eval("ClientState") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="clientHdr">
                                                                Firm:
                                                            </td>
                                                            <td class="clientCnt">
                                                                <asp:Label ID="Label10" runat="server" Text='<%#eval("FirmName") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Creditor Info">
                                                <ItemTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td class="creditorHdr">
                                                                Orig:
                                                            </td>
                                                            <td class="creditorCnt">
                                                                <asp:Label ID="lblOrigCreditor" runat="server" Text='<%#eval("OriginalCreditorName") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="creditorHdr">
                                                                Current:
                                                            </td>
                                                            <td class="creditorCnt">
                                                                <asp:Label ID="lblCurrCreditor" runat="server" Text='<%#eval("CurrentCreditorName") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="creditorHdr">
                                                                Acct #:
                                                            </td>
                                                            <td class="creditorCnt">
                                                                <asp:Label ID="Label8" runat="server" Text='<%#eval("acctnumber") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="creditorHdr">
                                                                Ref #:
                                                            </td>
                                                            <td class="creditorCnt">
                                                                <asp:Label ID="Label9" runat="server" Text='<%#eval("refnumber") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Harassment Info">
                                                <ItemTemplate>
                                                    <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td colspan="2">
                                                                <table class="entry" border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td style="width: 35px; font-weight: bold;">
                                                                            Date:
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="Label5" runat="server" Text='<%#eval("IndividualCallingDateOfCall") %>' />
                                                                        </td>
                                                                        <td style="width: 35px; font-weight: bold;">
                                                                            Time:
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="Label6" runat="server" Text='<%#eval("IndividualCallingTimeOfCall") %>' />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <b>Type:</b>
                                                                <asp:Label ID="Label7" runat="server" Text='<%#eval("HarassmentType") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr valign="top">
                                                            <td colspan="2">
                                                                <b>Reason:</b>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblReason" runat="server" CssClass="entry2" Text='<%# eval("ReasonData") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top" Width="300" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Status Info">
                                                <ItemTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Date:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:Label ID="lblStatusDate" runat="server" Text='<%#eval("HarassmentStatusDate") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Status:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:Label ID="lblStatusDesc" runat="server" Text='<%#eval("StatusDescription") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Reason:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:Label ID="Label4" runat="server" Text='<%#eval("HarassmentDeclineReason") %>' />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <EditItemTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Date:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:Label ID="lblStatusDate" runat="server" Text='<%#eval("HarassmentStatusDate") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Status:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="dsStatus" DataTextField="StatusDescription"
                                                                    DataValueField="HarassmentStatusID" AppendDataBoundItems="true" SelectedValue='<%# eval("HarassmentStatusID") %>'>
                                                                </asp:DropDownList>
                                                                <asp:SqlDataSource ID="dsStatus" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="SELECT [HarassmentStatusID], [StatusDescription] FROM [tblHarassmentStatusReasons] Order By StatusDescription">
                                                                </asp:SqlDataSource>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="statusHdr">
                                                                Reason:
                                                            </td>
                                                            <td class="statusCnt">
                                                                <asp:DropDownList ID="ddlDeclineReason" runat="server" DataSourceID="dsDeclineReason"
                                                                    DataTextField="DeclineReasonDescription" DataValueField="HarassmentDeclineReasonID"
                                                                    AppendDataBoundItems="true" SelectedValue='<%#eval("HarassmentDeclineReasonID") %>'>
                                                                    <asp:ListItem Value="" Text="Select Decline Reason" />
                                                                </asp:DropDownList>
                                                                <asp:SqlDataSource ID="dsDeclineReason" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                                    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="select HarassmentDeclineReasonID,DeclineReasonDescription from [tblHarassmentDeclineReasons] Order By DeclineReasonDescription">
                                                                </asp:SqlDataSource>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </EditItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Left" VerticalAlign="Top" />
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="False">
                                                <EditItemTemplate>
                                                    <asp:LinkButton ID="lnkSave" runat="server" CausesValidation="True" CommandName="Update"
                                                        CommandArgument='<%# eval("ClientSubmissionID") %>' Text="Update"></asp:LinkButton>
                                                    &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                        Text="Cancel"></asp:LinkButton>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="Change"
                                                        CausesValidation="False" />
                                                </ItemTemplate>
                                                <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="FirmName" HeaderText="FirmName" InsertVisible="False"
                                                ReadOnly="True" SortExpression="FirmName" Visible="false" />
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No Results
                                        </EmptyDataTemplate>
                                        <PagerTemplate>
                                            <div id="pager" style="background-color: #DCDCDC">
                                                <table class="entry">
                                                    <tr class="entry2">
                                                        <td style="padding-left: 10px;">
                                                            Page
                                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
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
                                    </asp:GridView>
                                    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupHarassSearch" Style="display: none">
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                            <ContentTemplate>
                                                <table class="entry">
                                                    <tr>
                                                        <th style="background-color: #3376AB; color: White; font-size: large;">
                                                            Creditor Harassment Detail
                                                        </th>
                                                    </tr>
                                                    <tr style="height: 350px;">
                                                        <td>
                                                            <iframe id="frameForm" runat="server" width="100%" height="95%" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <asp:LinkButton ID="btnClose" runat="server" Text="Close" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </asp:Panel>
                                    <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
                                    <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="dummyButton"
                                        PopupControlID="pnlPopup" CancelControlID="btnClose" BackgroundCssClass="modalBackgroundHarassSearch"
                                        RepositionMode="RepositionOnWindowResizeAndScroll">
                                    </ajaxToolkit:ModalPopupExtender>
                                    
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
            <ajaxToolkit:TabPanel ID="tpStats" runat="server">
                <HeaderTemplate>
                    Harassment Statistics
                </HeaderTemplate>
                <ContentTemplate>
                    
                    <div style="padding: 5px;" class="entry">
                        <asp:Panel ID="pnlExport" runat="server" BackColor="#3376AB" HorizontalAlign="Right"  cssclass="entry" style="padding: 5px;">
                            <div class="faux-button">
                                <asp:ImageButton ID="imgExportStatsBtn" runat="server" ImageUrl="~/images/16x16_edit.gif"
                                    AlternateText="Print Screen" />
                                <asp:Label ID="lblExportStats" runat="server" ForeColor="White" Text="Export Excel"
                                    AssociatedControlID="imgExportStatsBtn" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration=''" />
                            </div>
                        </asp:Panel >
                         <ajaxToolkit:RoundedCornersExtender ID="RoundedCornersExtender1" runat="server"
                                     TargetControlID="pnlExport" Radius="5" Corners="All" Color="#3376AB" />
                        <asp:GridView ID="gvStats" runat="server" DataSourceID="dsStats" AllowPaging="True" cssClass="entry"
                            PageSize="25" AutoGenerateColumns="False" AllowSorting="True">
                            <Columns>
                                <asp:BoundField DataField="DateSubmitted" HeaderText="DateSubmitted" ReadOnly="True"
                                    SortExpression="DateSubmitted" DataFormatString="{0:d}">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Firm" HeaderText="Firm" SortExpression="Firm">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumberOfIntake" HeaderText="NumberOfIntake" ReadOnly="True"
                                    SortExpression="NumberOfIntake">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumberOfDecline" HeaderText="NumberOfDecline" ReadOnly="True"
                                    SortExpression="NumberOfDecline">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumberOfDemand" HeaderText="NumberOfDemand" ReadOnly="True"
                                    SortExpression="NumberOfDemand">
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" Wrap="false" />
                                </asp:BoundField>
                            </Columns>
                            <PagerTemplate>
                                <div id="pager" style="background-color: #DCDCDC">
                                    <table class="entry">
                                        <tr class="entry2">
                                            <td style="padding-left: 10px;">
                                                Page
                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
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
                            <EmptyDataTemplate>
                                No Stats
                            </EmptyDataTemplate>
                        </asp:GridView>
                        
                    </div>
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
        </ajaxToolkit:TabContainer>
        <div id="updateHarassDiv" style="display: none; height: 40px; width: 40px">
            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
        </div>
    </ContentTemplate>
</asp:UpdatePanel>

<asp:GridView ID="gvExport" runat="server" />
<asp:SqlDataSource ID="dsStats" ConnectionString="<%$ AppSettings:connectionstring %>"
                            runat="server" ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_Harassment_getStatistics">
                        </asp:SqlDataSource>
<asp:SqlDataSource ID="dsSearch" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_Harassment_SearchSubmissions"
                                        SelectCommandType="StoredProcedure" UpdateCommand="stp_Harassment_updateStatus"
                                        UpdateCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:Parameter DefaultValue="ClientAccountNumber" Name="searchColumn" Type="String" />
                                            <asp:Parameter DefaultValue=" " Name="searchTerm" Type="String" />
                                        </SelectParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="clientsubmissionid" Type="Int32" />
                                            <asp:Parameter Name="statusid" Type="Int32" />
                                            <asp:Parameter Name="declinereasonid" Type="Int32" />
                                        </UpdateParameters>
                                    </asp:SqlDataSource>
<script type="text/javascript">

    function onUpdating() {
        // get the update progress div
        var updateProgressDiv = $get('tcHarass');
        // make it visible
        updateProgressDiv.style.display = '';

        //  get the gridview element
        var gridView = $get('divHarassSearch');

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

<ajaxToolkit:UpdatePanelAnimationExtender ID="upaeHarassSearch" BehaviorID="HarassSearchanimation"
    runat="server" TargetControlID="upHarassSearch">
    <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="divHarassSearch" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="divHarassSearch" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
    </Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>

