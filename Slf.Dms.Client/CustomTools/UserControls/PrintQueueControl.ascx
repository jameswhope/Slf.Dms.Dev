﻿<%@ Control Language="VB" AutoEventWireup="false" CodeFile="PrintQueueControl.ascx.vb"
    Inherits="PrintQueueControl" %>
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
   
</style>

<script type="text/javascript">
    function checkAll(chk_SelectAll) {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;

        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                el.checked = chkState;
            }
        }
    }
    function FillSearchText(txtObj) {
        var hdn = document.getElementById('<%=hdnSearchText.ClientID %>');
        hdn.value = txtObj.value;
    }
    function savePrinter(txtObj) {
        var hdn = document.getElementById('<%=hdnPrinterName.ClientID %>');
        hdn.value = txtObj.value;
    }
</script>

<div id="divMsg" runat="server">
</div>
<table class="entry" cellpadding="0" cellspacing="0">
    <tr style="height: 60px;">
        <td style="padding: 3px; color: White;">
            <table class="entry" style="color: White;">
                <tr>
                    <td align="left" style="width:38%;">
                        <asp:Panel ID="pnlQueue" runat="server" BackColor="#3376AB" Height="50">
                            <table class="entry" style="color: White;" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                <td style="text-align: right; width:125px" >
                                    Queue Type:
                                </td>
                                <td align="left" width="200" >
                                    <asp:DropDownList ID="ddlQueueType" runat="server" AutoPostBack="true"  CssClass="entry" />
                                </td>
                                <td align="center" rowspan="2">
                                    <asp:LinkButton ID="lnkPrintQ" runat="server" Text="Begin Printing" ForeColor="white"
                                        Font-Size="12pt" CssClass="lnk" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;width:125px" >
                                    Select Printer:
                                </td>
                                <td align="left" width="200">
                                    <asp:DropDownList ID="ddlPrinter" runat="server" AutoPostBack="false" onchange="savePrinter(this);"
                                        CssClass="entry" />
                                </td>
                            </tr>
                        </table>
                        </asp:Panel>
                        <ajaxToolkit:RoundedCornersExtender ID="pnlQueue_RoundedCornersExtender" runat="server" TargetControlID="pnlQueue"  Radius="5"/>
                    </td>
                    <td>
                        <asp:Panel ID="pnlResults" runat="server" ScrollBars="None" BackColor="#4791C5" Height="50" HorizontalAlign="Center" >
                        <br />
                            <asp:Label ID="lblQCount" runat="server" Text="Client(s) in Queue" ForeColor="white"
                                Font-Bold="true" />
                                <br />
                        </asp:Panel>
                        <ajaxToolkit:RoundedCornersExtender ID="pnlResults_RoundedCornersExtender" runat="server" TargetControlID="pnlResults"  Radius="5"/>
                    </td>
                    <td style="padding: 3px; color: White; text-align: right;">
                    <asp:Panel ID="pnlSearch" runat="server" ScrollBars="None" BackColor="#838B8B" Height="50" HorizontalAlign="Center">
                    <br />
                        <table class="entry">
                            <tr>
                                <td align="right">
                                    <asp:Label ID="Label1" runat="server" Text="Search:" ForeColor="white" Font-Bold="true" />
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="entry2" Width="60%" />
                                    <asp:LinkButton ID="lnkGo" runat="server" Text="Go" ForeColor="white" CssClass="lnk" />
                                    &nbsp;|&nbsp;
                                    <asp:LinkButton ID="lnkClear" runat="server" Text="Clear" ForeColor="white" CssClass="lnk" />
                                </td>
                            </tr>
                        </table>
                        </asp:Panel>
                        <ajaxToolkit:RoundedCornersExtender ID="pnlSearch_RoundedCornersExtender" runat="server" TargetControlID="pnlSearch"  Radius="5"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
   
</table>
<asp:GridView ID="gvQueue" runat="server" AllowPaging="True" AllowSorting="True"
    AutoGenerateColumns="False" DataKeyNames="qid,PrintDocumentPath,DataClientID"
    DataSourceID="dsQueue" Font-Size="8pt" PageSize="25" CssClass="entry" ShowHeader="true" GridLines="None">
    <AlternatingRowStyle BackColor="#F3F3F3" />
    <EmptyDataTemplate>
    <div class="info">
        No Documents in Queue!
        </div>
    </EmptyDataTemplate>
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
                &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
            </HeaderTemplate>
            <ItemTemplate>
                <input type="checkbox" runat="server" id="chk_select" />
            </ItemTemplate>
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="25" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="25" />
        </asp:TemplateField>
        <asp:BoundField DataField="qid" HeaderText="qid" InsertVisible="False" ReadOnly="True"
            SortExpression="qid" Visible="False">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Display Name" HeaderText="Display Name" SortExpression="Display Name">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="150" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="150" />
        </asp:BoundField>
        <asp:BoundField DataField="Client Name" HeaderText="Client Name" ReadOnly="True"
            SortExpression="Client Name">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="DataClientId" HeaderText="ClientId" ReadOnly="True" SortExpression="ClientId">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Bank Account" HeaderText="Bank Account" ReadOnly="True" SortExpression="Bank Account">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Bank Routing" HeaderText="Bank Routing" ReadOnly="True" SortExpression="Bank Routing">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Check Amount" HeaderText="Check Amount" SortExpression="Check Amount" DataFormatString="{0:c}">
            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="right" CssClass="listItem" />
        </asp:BoundField>

        <asp:BoundField DataField="Printed By" HeaderText="Printed By" ReadOnly="True" SortExpression="Printed By">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Total Pages" HeaderText="Page Count" ReadOnly="True" SortExpression="Total Pages">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField ConvertEmptyStringToNull="False" DataField="ActionDate" DataFormatString="{0:d}"
            HeaderText="Date" SortExpression="ActionDate">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Width="100" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" Width="100" />
        </asp:BoundField>
        <asp:BoundField ConvertEmptyStringToNull="False" DataField="PrintDocumentPath" HeaderText="Document Path"
            SortExpression="PrintDocumentPath">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="Creditor" HeaderText="Creditor" SortExpression="Creditor">
            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="SettlementAmount" HeaderText="Settlement $" SortExpression="SettlementAmount" DataFormatString="{0:c}">
            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="right" CssClass="listItem" />
        </asp:BoundField>
        <asp:BoundField DataField="SettlementDueDate" HeaderText=" Due Date" SortExpression="SettlementDueDate" DataFormatString="{0:d}">
            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
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
<asp:SqlDataSource ID="dsQueue" ConnectionString="<%$ AppSettings:connectionstring %>"
    runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_LetterTemplates_getPrintQueue"
    SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="QueueType" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:HiddenField ID="hdnSearchText" runat="server" />
<asp:HiddenField ID="hdnPrinterName" runat="server" />
