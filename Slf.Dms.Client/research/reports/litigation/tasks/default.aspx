<%@ Page Title="" Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false"
    CodeFile="default.aspx.vb" Inherits="research_reports_litigation_tasks_default" %>

<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
        }
        .headItem
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
        }
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: underline;
        }
        .filter
        {
            background-color: #6CA6CD;
        }
        .filter th, .results
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #fff;
            text-align: left;
        }
        .analysis
        {
            border: solid 3px #d3d3d3;
            padding: 10px;
            background-color: #E8E8E8;
        }
        .analysis th
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-decoration: underline;
            color: #000;
            padding: 5px;
            text-align: left;
        }
        .analysis td
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #000;
            text-align: left;
        }
        .altrow
        {
            background-color: #dcdcdc;
        }
        .modalBackgroundMatterSearch
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupMatterSearch
        {
            background-color: #D6E7F3;
            border-width: 3px;
            border-style: solid;
            border-color: Gray;
            padding: 3px;
            width: 60%;
            height: 400px;
        }
        fieldset
        {
            height: 100%;
            padding: 3px;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />

    <script language="javascript" type="text/javascript">
        function SetDates(ddl) {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            }
        }
        function ShowMatterPopup(matterURL) {
            var frm = $get('<%=frameForm.ClientID %>');
            frm.src = matterURL;
            $find("<%=mpeMatter.ClientID %>").show();
        }
        function SetDatesGeneric(ddl, txtStart, txtEnd) {
            var txtTransDate1 = document.getElementById(txtStart);
            var txtTransDate2 = document.getElementById(txtEnd);
            var str = ddl.value;
            if (str != "Custom" && str != "-1") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            } else {
                txtTransDate1.value = "";
                txtTransDate2.value = "";
            }

        }
        function CheckForAll() {
            var allCreated = document.getElementById('<%= ddlQuickPickDate.ClientID %>').value;
            var allResolved = document.getElementById('<%= ddlDueDate.ClientID %>').value;
            var allDue = document.getElementById('<%= ddlResolvedDate.ClientID %>').value;
            if (allCreated == -1 && allResolved == -1 && allDue == -1) {
                alert('You have chosen "ALL" for all date filters, this search returns too many rows.  Please pick a time frame for at least one date filter.');
                return false;
            } else {
                return true;
            }

        }
        function RefreshGrid() {
             <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }
        function FrameLoaded(){
            var dvloading = $get('loading');
            dvloading.style.display = 'none';
        }
    </script>

    <asp:UpdatePanel ID="updatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="filter">
                        <table class="entry" border="0">
                            <tr valign="top">
                                <td style="width: 20%;">
                                    <fieldset>
                                        <legend>Task Type:</legend>
                                        <asp:ListBox ID="lbTaskType" runat="server" DataSourceID="ds_TaskType" DataTextField="name"
                                            DataValueField="tasktypeid" CssClass="entry" SelectionMode="Multiple" Rows="13">
                                        </asp:ListBox>
                                        <asp:SqlDataSource ID="ds_TaskType" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                            SelectCommand="select distinct tt.tasktypeid, tt.name, 3 [seq] from tbltasktype tt where TaskTypeCategoryID = 9 union select -1, 'All', 0 union select 0, 'Ad hoc', 1 order by seq, name"
                                            SelectCommandType="Text"></asp:SqlDataSource>
                                    </fieldset>
                                </td>
                                <td>
                                    <fieldset>
                                        <legend>Filter Options</legend>
                                        <ajaxToolkit:TabContainer ID="tcResolutionFilters" runat="server" CssClass="tabContainer"
                                            ActiveTabIndex="0">
                                            <ajaxToolkit:TabPanel ID="tpType" runat="server">
                                                <HeaderTemplate>
                                                    Resolution Type</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbTaskResolution" runat="server" CssClass="entry" DataSourceID="ds_TaskResolution"
                                                        DataTextField="Name" DataValueField="TaskResolutionID" Rows="11" SelectionMode="Multiple">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="ds_TaskResolution" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        ProviderName="System.Data.SqlClient" SelectCommand="select * from (SELECT [TaskResolutionID],[Name],3 [seq] FROM [tblTaskResolution]  union select -1, 'All', 0 ) resData order by seq">
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="tpBy" runat="server">
                                                <HeaderTemplate>
                                                    Resolved By</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbResolvedBy" runat="server" CssClass="entry" DataSourceID="dsResolvedBy"
                                                        DataTextField="resolvedBy" DataValueField="userid" Rows="11" SelectionMode="Multiple">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="dsResolvedBy" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        ProviderName="System.Data.SqlClient" SelectCommand="select distinct u.userid, u.firstname + ' ' + u.lastname [resolvedBy], 1 [seq] from tbltask t join tblmattertask m on m.taskid = t.taskid join tbluser u on u.userid = t.resolvedBy and (u.usergroupid = @ugroupid or @ugroupid=-1)union select -1, 'All', 0 union select 0, 'None', 0 order by seq, resolvedBy">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="ugroupid" DefaultValue="-1" />
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="tpFilters" runat="server">
                                                <HeaderTemplate>
                                                    Resolve Filters</HeaderTemplate>
                                                <ContentTemplate>
                                                    <table>
                                                        <tr>
                                                            <td align="left" colspan="2" style="color: White;">
                                                                <asp:CheckBox ID="chkResolved" runat="server" CssClass="entry2" Text="Only Resolved" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" colspan="2" style="color: White;">
                                                                <asp:CheckBox ID="chkOnlyUnresolved" runat="server" CssClass="entry2" Text="Only Unresolved" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="tpFirm" runat="server">
                                                <HeaderTemplate>
                                                    Firm</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbCompany" runat="server" CssClass="entry" DataSourceID="ds_Company"
                                                        DataTextField="shortconame" DataValueField="companyid" Rows="11" SelectionMode="Multiple">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="ds_Company" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                                        SelectCommand="select companyid, shortconame, 1 [seq] from tblcompany union select -1, 'All', 0 order by seq, shortconame"
                                                        SelectCommandType="Text"></asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="TabPanel1" runat="server">
                                                <HeaderTemplate>
                                                    Created By</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbCreatedBy" runat="server" DataSourceID="ds_CreatedBy" DataTextField="assignedto"
                                                        DataValueField="userid" CssClass="entry" SelectionMode="Multiple" Rows="11">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="ds_CreatedBy" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                                        SelectCommandType="Text" SelectCommand="select distinct u.userid, u.firstname + ' ' + u.lastname [assignedto], 1 [seq] from tbltask t join tblmattertask m on m.taskid = t.taskid join tbluser u on u.userid = t.createdby union select -1, 'All', 0 order by seq, assignedto">
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="TabPanel2" runat="server">
                                                <HeaderTemplate>
                                                    Assigned Group</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbUserGroup" runat="server" DataSourceID="ds_UserGroup" DataTextField="name"
                                                        DataValueField="usergroupid" CssClass="entry" SelectionMode="Multiple" Rows="11"
                                                        AutoPostBack="true"></asp:ListBox>
                                                    <asp:SqlDataSource ID="ds_UserGroup" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                                        SelectCommandType="Text" SelectCommand="select usergroupid, name, 1 [seq] from tblusergroup where usergroupid in (30,36,37,38,39,40,41,50) union select -1, 'All', 0 order by seq, name">
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="TabPanel3" runat="server">
                                                <HeaderTemplate>
                                                    Assigned To</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbAssignedTo" runat="server" DataSourceID="ds_AssignedTo" DataTextField="assignedto"
                                                        DataValueField="userid" CssClass="entry" SelectionMode="Multiple" Rows="11">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="ds_AssignedTo" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                                        SelectCommandType="Text" SelectCommand="select distinct u.userid, u.firstname + ' ' + u.lastname [assignedto], 1 [seq] from tbltask t join tblmattertask m on m.taskid = t.taskid join tbluser u on u.userid = t.assignedto and (u.usergroupid = @ugroupid or @ugroupid=-1)union select -1, 'All', 0 union select 0, 'None', 0 order by seq, assignedto">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="ugroupid" DefaultValue="-1" />
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="TabPanel5" runat="server">
                                                <HeaderTemplate>
                                                    Matter Classification</HeaderTemplate>
                                                <ContentTemplate>
                                                    <asp:ListBox ID="lbClassifications" runat="server" CssClass="entry" DataSourceID="dsMatterClass"
                                                        DataTextField="classification" DataValueField="classificationid" Rows="11" SelectionMode="Multiple">
                                                    </asp:ListBox>
                                                    <asp:SqlDataSource ID="dsMatterClass" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        ProviderName="System.Data.SqlClient" SelectCommand="select classificationid, classification,'1'[Seq] from tblclassifications union select -1, 'All', 0 order by seq,classification">
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                            <ajaxToolkit:TabPanel ID="TabPanel4" runat="server">
                                                <HeaderTemplate>
                                                    Optional</HeaderTemplate>
                                                <ContentTemplate>
                                                    <table class="entry">
                                                        <tr>
                                                            <td style="color: White; width: 15%;" align="right">
                                                                Creditor(s):
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtCreditors" runat="server" Rows="12" CssClass="entry" TextMode="SingleLine" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="color: White;" align="right">
                                                                Description(s):
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtDescriptions" runat="server" Rows="12" CssClass="entry" TextMode="SingleLine" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="color: White;" align="right">
                                                                Matter(s):
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtMatters" runat="server" Rows="12" CssClass="entry" TextMode="SingleLine" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </ajaxToolkit:TabPanel>
                                        </ajaxToolkit:TabContainer>
                                    </fieldset>
                                </td>
                                <td>
                                    <fieldset>
                                        <legend>Date Filters:</legend>
                                        <table border="0" cellpadding="0" cellspacing="0" class="entry" style="color: White;">
                                            <tr style="white-space: nowrap;">
                                                <td align="right">
                                                    Created:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlQuickPickDate" runat="server" CssClass="entry2">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                                <td style="width: 20px; text-align: center;">
                                                    To
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                            </tr>
                                            <tr style="white-space: nowrap;">
                                                <td align="right">
                                                    Due:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlDueDate" runat="server" CssClass="entry2">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtDueStart" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                                <td style="width: 20px; text-align: center;">
                                                    To
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtDueEnd" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                            </tr>
                                            <tr style="white-space: nowrap;">
                                                <td align="right" class="entry2">
                                                    Resolved:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlResolvedDate" runat="server" CssClass="entry2">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtResolveStart" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                                <td style="width: 20px; text-align: center;">
                                                    To
                                                </td>
                                                <td>
                                                    <cc1:InputMask class="entry" runat="server" ID="txtResolveEnd" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                    <fieldset style="text-align: center;">
                                        <legend>Actions</legend>
                                        <table border="0" cellpadding="0" cellspacing="0" class="entry">
                                            <tr>
                                                <td align="center">
                                                    <asp:Button Width="200px" ID="btnRefresh" runat="server" Text="Refresh" CssClass="entry2"
                                                        OnClientClick="return CheckForAll();" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <asp:Button Width="200px" ID="btnExport" runat="server" Text="Export to Excel" CssClass="entry2" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <asp:Label ID="lblResults" runat="server" CssClass="results"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </td>
                                <td style="padding-top:10px;" class="results">
                                <asp:Panel ID="pnlr" runat="server" Height="195px" ScrollBars="Vertical">
                                    <asp:Literal ID="lblSelection" runat="server" />
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td id="tdAnalysis" class="analysis">
                        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CellPadding="5"
                            GridLines="None" BorderStyle="None" AllowPaging="True" AllowSorting="True" DataSourceID="dsResults"
                            CssClass="entry" PageSize="15" OnRowDataBound="gvResults_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="matterid" HeaderText="Matter" SortExpression="MatterId"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false"
                                    Visible="false">
                                    <HeaderStyle CssClass="headItem" Wrap="false" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="taskid" HeaderText="Task" SortExpression="TaskId" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" HtmlEncode="false" Visible="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="tasktype" HeaderText="Task&nbsp;Type" SortExpression="TaskType"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="description" SortExpression="Description" HeaderText="Task&nbsp;Description"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" Width="300px" />
                                    <ItemStyle CssClass="creditor-item" Wrap="true" Width="300px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="accountnumber" SortExpression="AccountNumber" HeaderText="Account"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="client" SortExpression="Client" HeaderText="Client" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="clientstate" SortExpression="ClientState" HeaderText="Client State"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="company" SortExpression="Company" HeaderText="Firm" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="creditor" SortExpression="Creditor" HeaderText="Creditor"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" Wrap="true" />
                                </asp:BoundField>
                                <asp:BoundField DataField="createdby" SortExpression="CreatedBy" HeaderText="Created By"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="assignedtogroup" SortExpression="AssignedToGroup" HeaderText="Assigned&nbsp;Group"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="assignedto" SortExpression="AssignedTo" HeaderText="Assigned&nbsp;To"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="created" SortExpression="Created" HeaderText="Created"
                                    DataFormatString="{0:dd MMM, yyyy}" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="due" SortExpression="Due" HeaderText="Due" ItemStyle-CssClass="creditor-item"
                                    HeaderStyle-CssClass="headItem" DataFormatString="{0:dd MMM, yyyy}" HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="resolved" SortExpression="Resolved" HeaderText="Resolved"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" DataFormatString="{0:dd MMM, yyyy}"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="resolvedBy" SortExpression="resolvedBy" HeaderText="Resolved By"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" DataFormatString="{0:dd MMM, yyyy}"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Matter Classification" SortExpression="Matter Classification" HeaderText="Classification"
                                    ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" 
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headItem" />
                                    <ItemStyle CssClass="creditor-item" />
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
                        </asp:GridView>
                        <asp:SqlDataSource ID="dsResults" ConnectionString="<%$ AppSettings:connectionstring %>"
                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_MattersReport"
                            SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:Parameter Name="criteria" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupMatterSearch" Style="display: none">
                            <table id="tblPopHolder" class="entry" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <th style="background-color: #3376AB; color: White; font-size: medium; text-decoration: none;">
                                        Matter Detail
                                    </th>
                                    <th style="background-color: #3376AB; color: White; font-size: medium; text-align: right;">
                                        <img src="../../../../images/16x16_close.png" id="imgClose" runat="server" onmouseover="this.style.cursor ='hand';" />
                                    </th>
                                </tr>
                                <tr style="height: 625px;">
                                    <td colspan="2" valign="top">
                                        <div id="loading" style="width: 100%; text-align: center; vertical-align: middle;
                                            height: 100%; display: block;">
                                            <br />
                                            Loading...<br />
                                            <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/bigloading.gif" />
                                        </div>
                                        <iframe id="frameForm" runat="server" marginwidth="0" marginheight="0" frameborder="0"
                                            vspace="0" hspace="0" style="overflow: visible; width: 100%; height: 98%; display: block;" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
                        <ajaxToolkit:ModalPopupExtender ID="mpeMatter" runat="server" TargetControlID="dummyButton"
                            PopupControlID="pnlPopup" CancelControlID="imgClose" OnCancelScript="RefreshGrid();return false;"
                            BackgroundCssClass="modalBackgroundMatterSearch" RepositionMode="RepositionOnWindowResizeAndScroll">
                        </ajaxToolkit:ModalPopupExtender>
                    </td>
                </tr>
            </table>
            <div id="updateTaskDiv" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="Image1" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">

        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateTaskDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('tdAnalysis');

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
            var updateProgressDiv = $get('updateTaskDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeTask" BehaviorID="Taskanimation"
        runat="server" TargetControlID="updatePanel1">
        <Animations>
                    <OnUpdating>
                        <Parallel duration="0">
                            <%-- place the update progress div over the gridview control --%>
                            <ScriptAction Script="onUpdating();" />  
                            <EnableAction AnimationTarget="tdAnalysis" Enabled="false" />
                                             
                            <%-- fade-out the holder --%>
                            <FadeOut minimumOpacity=".5" />
                         </Parallel>
                    </OnUpdating>
                    <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the holder --%>
                            <FadeIn minimumOpacity=".5" />
                            <EnableAction AnimationTarget="tdAnalysis" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
    <asp:GridView ID="gvExport" runat="server" />
</asp:Content>
