<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="LeadAnalysis.aspx.vb" Inherits="Clients_Enrollment_LeadAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a id="A1" runat="server" class="menuButton" href="~/clients/enrollment">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_back.png" />Back</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
            <td style="white-space: nowrap; text-align: right; padding-right: 15px">
                <asp:LinkButton ID="lnkExportToPDF" runat="server" CssClass="menuButton"><img runat="server" class="menuButtonImage" src="~/images/16x16_pdf.png" border="0" align="absmiddle" /> Export to PDF</asp:LinkButton>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .filter
        {
            background-color: #6CA6CD;
        }
        .filter th
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
            padding: 7px;
        }
        .analysistd
        {
            font-family: Tahoma;
            font-size: 22px;
            font-weight: normal;
            color: #000;
            text-align: center;
        }
        .altrow
        {
            background-color: #C1CDC1;
        }
        h3
        {
            font-family: Tahoma;
            font-size: 22px;
            font-weight: normal;
        }
        h4
        {
            font-family: Tahoma;
            font-size: 18px;
            font-weight: normal;
            margin: 0 0 0 20px;
        }
        .demorow
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #000;
            border-bottom: dotted 1px #999999;
            white-space: nowrap;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table id="tblProcessing" style="margin: 15px" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="filter">
                        <table>
                            <tr>
                                <th>
                                    Vendor:
                                </th>
                                <th>
                                    Product:
                                </th>
                                <th>
                                    Status Group:
                                </th>
                                <th>
                                    Status:
                                </th>
                                <!--<th>
                                    Fronter:
                                </th>
                                <th>
                                    Closer:
                                </th>-->
                                <th>
                                    Attorney:
                                </th>
                                <th>
                                    State:
                                </th>
                                <th>
                                    Client Status:
                                </th>
                                <th>
                                    Total Debt:
                                </th>
                                <th>
                                    Mthly Income:
                                </th>
                                <th>
                                    Fee:
                                </th>
                                <th>
                                    Deposits:
                                </th>
                                <th>
                                    Lead Created:
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <asp:ListBox ID="lbVendor" runat="server" DataSourceID="ds_LeadVendor" DataTextField="vendorcode"
                                        DataValueField="vendorid" CssClass="entry2" SelectionMode="Multiple" Rows="15"
                                        AutoPostBack="true"></asp:ListBox>
                                    <asp:SqlDataSource ID="ds_LeadVendor" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select vendorid, vendorcode from tblleadvendors union select -1, 'All' order by vendorcode">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbProduct" runat="server" DataTextField="productdesc" Width="130px"
                                        DataValueField="productid" CssClass="entry2" SelectionMode="Multiple" Rows="15">
                                        <asp:ListItem Text="All" Value="-1" Selected="True"></asp:ListItem>
                                    </asp:ListBox>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbStatusGroup" runat="server" DataSourceID="ds_LeadStatusGroup"
                                        DataTextField="groupname" DataValueField="statusgroupid" CssClass="entry2" SelectionMode="Multiple"
                                        Rows="15" AutoPostBack="true"></asp:ListBox>
                                    <asp:SqlDataSource ID="ds_LeadStatusGroup" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select cast(statusgroupid as varchar(10)) [statusgroupid], groupname from tblleadstatusgroup union select '-1', 'All' order by statusgroupid">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbStatus" runat="server" DataSourceID="ds_LeadStatus" DataTextField="description"
                                        DataValueField="statusid" CssClass="entry2" SelectionMode="Multiple" Rows="15">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_LeadStatus" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select cast(statusid as varchar(10)) [statusid], [description] from tblleadstatus union select '-1', 'All' union select '0', 'None' order by [description]">
                                    </asp:SqlDataSource>
                                </td>
                                <!--<td>
                                    <asp:ListBox ID="lbFronters" runat="server" DataSourceID="ds_Fronter" DataTextField="rep"
                                        DataValueField="userid" CssClass="entry2" SelectionMode="Multiple" Rows="15" Enabled="false">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_Fronter" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select userid, firstname + ' ' + left(lastname,1) + '.' [rep], 2 [seq] from tbluser where usergroupid in (1,24,25,26,28,29) and locked = 0  union  select -1, 'All', 0  order by [seq], [rep]">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbClosers" runat="server" DataSourceID="ds_Closers" DataTextField="closer"
                                        DataValueField="userid" CssClass="entry2" SelectionMode="Multiple" Rows="15" Enabled="false">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_Closers" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select userid, firstname + ' ' + left(lastname,1) + '.' [closer], 2 [seq] from tbluser where usergroupid = 25 and locked = 0  union  select -1, 'All', 0  order by [seq], [closer]">
                                    </asp:SqlDataSource>
                                </td>-->
                                <td>
                                    <asp:ListBox ID="lbCompany" runat="server" DataSourceID="ds_Company" DataTextField="shortconame"
                                        DataValueField="companyid" CssClass="entry2" SelectionMode="Multiple" Rows="15">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_Company" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select companyid, shortconame from tblcompany union select -1, 'All' union select 0, 'None'">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbState" runat="server" DataSourceID="ds_State" DataTextField="name"
                                        DataValueField="stateid" CssClass="entry2" SelectionMode="Multiple" Rows="15">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_State" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select stateid,name,2[seq] from tblstate union select -1,'All',0 union select 0,'None',1 order by seq,name">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbClientStatus" runat="server" CssClass="entry2" SelectionMode="Single"
                                        Rows="15">
                                        <asp:ListItem Text="" Value="-1"></asp:ListItem>
                                        <asp:ListItem Text="All"></asp:ListItem>
                                        <asp:ListItem Text="Active" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="Cancelled" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="Completed" Value="18"></asp:ListItem>
                                    </asp:ListBox>
                                </td>
                                <td valign="top">
                                    <asp:TextBox ID="txtTotalDebtMin" runat="server" CssClass="entry2" Width="65px" Text="0"></asp:TextBox><br />
                                    <asp:TextBox ID="txtTotalDebtMax" runat="server" CssClass="entry2" Width="65px" Text="100000"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    <asp:TextBox ID="txtIncomeMin" runat="server" CssClass="entry2" Width="65px" Text="0"></asp:TextBox><br />
                                    <asp:TextBox ID="txtIncomeMax" runat="server" CssClass="entry2" Width="65px" Text="100000"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    <asp:ListBox ID="lbMonthlyFee" runat="server" CssClass="entry2" SelectionMode="Single"
                                        Rows="8">
                                        <asp:ListItem Text="All" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="$25" Value="25"></asp:ListItem>
                                        <asp:ListItem Text="$50" Value="50"></asp:ListItem>
                                        <asp:ListItem Text="$75" Value="75"></asp:ListItem>
                                        <asp:ListItem Text="$80" Value="80"></asp:ListItem>
                                        <asp:ListItem Text="$30" Value="30"></asp:ListItem>
                                        <asp:ListItem Text="$60" Value="60"></asp:ListItem>
                                        <asp:ListItem Text="$90" Value="90"></asp:ListItem>
                                    </asp:ListBox>
                                </td>
                                <td valign="top">
                                    <asp:ListBox ID="lbDeposits" runat="server" CssClass="entry2" SelectionMode="Single"
                                        Rows="8">
                                        <asp:ListItem Text="All" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="0" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="1+" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2+" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3+" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4+" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5+" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6+" Value="6"></asp:ListItem>
                                    </asp:ListBox>
                                </td>
                                <td valign="top">
                                    <asp:TextBox ID="txtFrom" runat="server" CssClass="entry2" Width="65px"></asp:TextBox><br />
                                    <asp:TextBox ID="txtTo" runat="server" CssClass="entry2" Width="65px"></asp:TextBox>
                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFrom"
                                        PopupPosition="BottomLeft">
                                    </ajaxToolkit:CalendarExtender>
                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTo"
                                        PopupPosition="BottomLeft">
                                    </ajaxToolkit:CalendarExtender>
                                    <br />
                                    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="entry2" Font-Size="14px" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="analysis">
                        <asp:GridView ID="GridView2" runat="server" GridLines="None" Width="100%" AutoGenerateColumns="false"
                            AlternatingRowStyle-CssClass="altrow">
                            <Columns>
                                <asp:BoundField DataField="num" HeaderText="# of Leads" ItemStyle-CssClass="analysistd" />
                                <asp:BoundField DataField="noaccts" HeaderText="Avg # of Accts" ItemStyle-CssClass="analysistd" />
                                <asp:BoundField DataField="totaldebt" HeaderText="Avg Total Debt" DataFormatString="{0:c}"
                                    ItemStyle-CssClass="analysistd" />
                                <asp:BoundField DataField="daystosign" HeaderText="Avg Days to Sign" ItemStyle-CssClass="analysistd" />
                                <asp:BoundField DataField="nosigned" HeaderText="# Signed" ItemStyle-CssClass="analysistd" />
                            </Columns>
                        </asp:GridView>
                        <div id="divDemo" runat="server">
                            <hr />
                            <h4>
                                Lead Demographics</h4>
                            <table cellspacing="20">
                                <tr>
                                    <td valign="top">
                                        <b runat="server">Accounts with Balances</b>
                                        <asp:GridView ID="gvAccountTypes" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="300px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1" HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="accounttype" HeaderText="Type" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="numaccts" HeaderText="Accts" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="leads" HeaderText="Leads" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="avgper" HeaderText="Avg Per" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" DataFormatString="{0:n1}" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" DataFormatString="{0:p0}" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="avgbal" HeaderText="Avg Debt" ItemStyle-HorizontalAlign="Right"
                                                    DataFormatString="{0:c0}" ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Right" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">Type of Debt</b>
                                        <asp:GridView ID="gvTypeOfDebt" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1" HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="accounttype" HeaderText="Type" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="numaccts" HeaderText="Accts" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="leads" HeaderText="Leads" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="avgper" HeaderText="Avg Per" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" DataFormatString="{0:n1}" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" DataFormatString="{0:p0}" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="avgbal" HeaderText="Avg Debt" ItemStyle-HorizontalAlign="Right"
                                                    DataFormatString="{0:c0}" ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Right" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">Top 10 Zip Codes</b>
                                        <asp:GridView ID="gvZipCodes" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="120px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="zipcode" HeaderText="Zip Code" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="leads" HeaderText="Leads" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">FICO (Experian) including co-apps</b>
                                        <asp:GridView ID="gvFICO" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="150px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Score" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                            <table cellspacing="20">
                                <tr>
                                    <td valign="top">
                                        <b id="B6" runat="server">Top 10 Creditors with Balances</b>
                                        <asp:GridView ID="gvTopCreditors" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="250px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="creditor" HeaderText="Creditor" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B7" runat="server">Status Reasons</b>
                                        <asp:GridView ID="gvReasons" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="250px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="reason" HeaderText="Reason" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B4" runat="server">Salutation</b>
                                        <asp:GridView ID="gvSalutation" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="150px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Salutation" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B5" runat="server">Age</b>
                                        <asp:GridView ID="gvAge" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="150px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Age" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                            <hr />
                            <h4>
                                Hardship Demographics</h4>
                            <table cellspacing="20">
                                <tr>
                                    <td valign="top">
                                        <b id="B1" runat="server">Behind</b>
                                        <asp:GridView ID="gvBehind" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="250px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="behind" HeaderText="Behind" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B2" runat="server">Hardship</b>
                                        <asp:GridView ID="gvHardship" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="250px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="hardship" HeaderText="Hardship" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B3" runat="server">Monthly Income</b>
                                        <asp:GridView ID="gvIncome" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="230px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Income" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b id="B8" runat="server">Income Types</b>
                                        <asp:GridView ID="gvIncomeTypes" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="230px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="incometypedescription" HeaderText="Income" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="cnt" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                            <hr />
                            <h4>
                                Client Demographics</h4>
                            <table cellspacing="20">
                                <tr>
                                    <td valign="top">
                                        <b runat="server">Deposit Method</b>
                                        <asp:GridView ID="gvDepositMethod" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="160px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Method" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">Client Monthly Fee</b>
                                        <asp:GridView ID="gvMonthlyFee" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="160px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="maintfee" HeaderText="Amount" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:c}" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                        <div style="padding:4px; background-color:#999999; text-align:center">
                                            Median: <asp:Label ID="lblMedianFee" runat="server"></asp:Label>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">Deposit to Debt</b>
                                        <asp:GridView ID="gvDepositToDebt" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="160px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Deposit" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td valign="top">
                                        <b runat="server">Eligible vs Enrolled Accounts</b>
                                        <asp:GridView ID="gvEnrolled" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE" FooterStyle-BackColor="#ababab" ShowFooter="true" FooterStyle-Font-Bold="true" FooterStyle-HorizontalAlign="Center">
                                            <Columns>
                                                <asp:BoundField DataField="eligiblev" HeaderText="Eligible" ItemStyle-CssClass="demorow"
                                                    HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="40px" />
                                                <asp:BoundField DataField="total_eligible" HeaderText="Total Eligible" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="40px" />
                                                <asp:BoundField DataField="total_enrolled" HeaderText="Total Enrolled" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="40px" />
                                                <asp:BoundField DataField="deficiency" HeaderText="Deficiency" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="50px" />
                                                <asp:BoundField DataField="Avg_Enrolled" HeaderText="Avg Enrolled" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:n1}" ItemStyle-Width="40px" />
                                                <asp:BoundField DataField="Pct_Enrolled" HeaderText="% Enrolled" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="45px" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                        <table cellpadding="4" cellspacing="0" style="background-color:#a1a1a1">
                                            <tr>
                                                <td style="width:40px; text-align:center; font-weight:bold"><asp:Label ID="lblMedianEligible" runat="server"></asp:Label></td>
                                                <td style="width:145px; text-align:center">Median</td>
                                                <td style="width:54px; text-align:center; font-weight:bold"><asp:Label ID="lblMedianEnrolled" runat="server"></asp:Label></td>
                                                <td style="width:45px"></td>
                                            </tr>
                                        </table>
                                        <div style="padding:4px; background-color:#999999; text-align:center">
                                            Median Debt Eligible: <asp:Label ID="lblMedianDebtEligible" runat="server"></asp:Label>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <b id="B10" runat="server">Client Deposits</b>
                                        <asp:GridView ID="gvDeposits" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="200px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:BoundField DataField="description" HeaderText="Deposit" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="count" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                            <table cellspacing="20">
                                <tr>
                                    <td valign="top">
                                        <b id="B9" runat="server">Failed 3PV</b>
                                        <asp:GridView ID="gvFailed3PV" runat="server" AutoGenerateColumns="false" GridLines="None"
                                            Width="200px" CellPadding="4" CellSpacing="0" AlternatingRowStyle-BackColor="#C1CDC1"
                                            HeaderStyle-BackColor="#DEDEDE">
                                            <Columns>
                                                <asp:TemplateField HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="demorow">
                                                    <HeaderTemplate>
                                                        Last Question
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <span title='<%#Eval("question") %>'><%#Eval("laststep")%></span>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="cnt" HeaderText="#" ItemStyle-HorizontalAlign="Center"
                                                    ItemStyle-CssClass="demorow" HeaderStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="pct" HeaderText="%" DataFormatString="{0:p1}" ItemStyle-CssClass="demorow"
                                                    ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div style="background-color: #DEDEDE; padding: 5px">
                                                    No demographics in this data set.</div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    </tr>
                                    </table>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="divLoading" style="display: none; height: 48px; width: 48px; border: solid 1px #999999;
                background-color: #ffffff; padding: 20px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        function onUpdating() {
            var divLoading = $get('divLoading');
            divLoading.style.display = '';

            var div = $get('tblProcessing');

            var bounds = Sys.UI.DomElement.getBounds(div);
            var loadingBounds = Sys.UI.DomElement.getBounds(divLoading);

            var x = bounds.x + Math.round(bounds.width / 2) - Math.round(loadingBounds.width / 2);
            var y = 170;  //bounds.y + Math.round(bounds.height / 2) - Math.round(loadingBounds.height / 2);

            Sys.UI.DomElement.setLocation(divLoading, x, y);
        }

        function onUpdated() {
            var divLoading = $get('divLoading');
            divLoading.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1">
        <Animations>
            <OnUpdating>
                <Parallel duration="0">
                    <ScriptAction Script="onUpdating();" />  
                    <EnableAction AnimationTarget="tblProcessing" Enabled="false" />
                 </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration="0">
                    <EnableAction AnimationTarget="tblProcessing" Enabled="true" />
                    <ScriptAction Script="onUpdated();" /> 
                </Parallel> 
            </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
</asp:Content>
