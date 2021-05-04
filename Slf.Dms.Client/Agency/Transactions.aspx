<%@ Page Title="" Language="VB" MasterPageFile="~/site.master" AutoEventWireup="false"
    CodeFile="Transactions.aspx.vb" Inherits="Agency_Transactions" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img id="Img1" width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="#">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_web_home.png" />Home</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="../Clients/Enrollment/Enrollment.css" rel="stylesheet" type="text/css" />
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 774px;
                margin: 15px;" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="padding: 7px; background-color: #cccccc">
                        <table>
                            <tr class="entry2">
                                <td>
                                    Start Date:
                                </td>
                                <td>
                                    End Date:
                                </td>
                                <td>
                                    Batch ID:
                                </td>
                                <td>
                                    Batch Date:
                                </td>
                                <td>
                                    Scenario:
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="entry2" Width="75px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlBatchID" runat="server" CssClass="entry2" Width="65px">
                                        <asp:ListItem Text="All"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlBatchDate" runat="server" CssClass="entry2" Width="90px">
                                        <asp:ListItem Text="All"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlScenario" runat="server" CssClass="entry2" Width="65px">
                                        <asp:ListItem Text="All"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="entry2" />
                                </td>
                                <td>
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                        <ProgressTemplate>
                                            <img id="Img3" runat="server" src="~/images/loading.gif" />
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="background-color: #B8B8B8">
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <th style="width: 120px" class="top-col">
                                    Transaction Date
                                </th>
                                <th style="width: 80px" class="top-col">
                                    Account#
                                </th>
                                <th style="width: 100px" class="top-col">
                                    Fee Type
                                </th>
                                <th style="width: 80px" class="top-col">
                                    Payments
                                </th>
                                <th style="width: 80px" class="top-col">
                                    Chargebacks
                                </th>
                                <th style="width: 80px" class="top-col">
                                    Batch ID
                                </th>
                                <th style="width: 90px" class="top-col">
                                    Batch Date
                                </th>
                                <th style="width: 70px" class="top-col">
                                    Scenario
                                </th>
                            </tr>
                        </table>
                        <div style="height: 400px; overflow: auto">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" ShowHeader="false">
                                <Columns>
                                    <asp:BoundField DataField="transdate" HeaderText="Transaction Date" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col2" ItemStyle-Width="120px" />
                                    <asp:BoundField DataField="accountnumber" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3"
                                        ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="entrytype" HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3"
                                        ItemStyle-Width="100px" />
                                    <asp:BoundField DataField="payments" HeaderText="Payments" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" DataFormatString="{0:c}" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="chargebacks" HeaderText="Chargebacks" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" DataFormatString="{0:c}" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="commbatchid" HeaderText="Batch ID" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" ItemStyle-Width="80px" />
                                    <asp:BoundField DataField="batchdate" HeaderText="Batch Date" DataFormatString="{0:d}"
                                        HeaderStyle-CssClass="top-col" ItemStyle-CssClass="center-col3" ItemStyle-Width="90px" />
                                    <asp:BoundField DataField="commstructid" HeaderText="Scenario" HeaderStyle-CssClass="top-col"
                                        ItemStyle-CssClass="center-col3" ItemStyle-Width="70px" />
                                </Columns>
                                <EmptyDataTemplate>
                                    No transactions found.
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 7px; background-color: #B8B8B8">
                    </td>
                </tr>
                <tr>
                    <td style="padding: 7px; background-color: #cccccc">
                        <asp:Label ID="lblFound" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
