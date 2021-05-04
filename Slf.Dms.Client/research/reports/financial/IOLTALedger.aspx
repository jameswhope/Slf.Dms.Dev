<%@ Page Title="IOLTA Ledger" Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false" CodeFile="IOLTALedger.aspx.vb" Inherits="research_reports_financial_IOLTALedger" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cphBodyAgency" Runat="Server">
    <table>
        <tr>
            <td>
                <asp:Label ID="lblsDate" Font-Bold="true" Text="Start Date: " runat="server"></asp:Label>&nbsp;
                <asp:TextBox ID="sDateTxt" runat="server" Caption="Start Date:" CaptionAlign="Left" Width="70px" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>&nbsp;
                <ajaxToolkit:CalendarExtender ID="sDateExt" runat="server" TargetControlID="sDateTxt"></ajaxToolkit:CalendarExtender>
            </td>
            <td>
                <asp:Label ID="lbleDate" Font-Bold="true" Text="End Date: " runat="server"></asp:Label>&nbsp;
                <asp:TextBox ID="eDateTxt" runat="server" Caption="End Date:" CaptionAlign="Left" Width="70px"  BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>&nbsp;
                <ajaxToolkit:CalendarExtender ID="eDateExt" runat="server" TargetControlID="eDateTxt"></ajaxToolkit:CalendarExtender>
            </td>
            <td>
                <asp:Button ID="btnRun" Text="Run Report" runat="server" />&nbsp;
            </td>
            <td>
                <asp:Label ID="lblBeginBal" Text="Beginning Balance:" runat="server" Font-Bold="true"></asp:Label>&nbsp;
            </td>
            <td>
                <asp:Label ID="lblEndBal" Text="Ending Balance:" runat="server" Font-Bold="true"></asp:Label>
            </td>
        </tr>
    </table>
   
    <table>
    <asp:Repeater ID="rptIOLTALedger" runat="server">
        <HeaderTemplate>
            <table border="1" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <th scope="col">
                        Transaction Created
                    </th>
                    <th scope="col">
                        Client ID
                    </th>
                    <th scope="col">
                        Description
                    </th>
                    <th scope="col">
                        Beginning Balance
                    </th>
                    <th scope="col">
                        Credit
                    </th>
                    <th scope="col">
                        Debit
                    </th>
                    <th scope="col">
                        Ending Balance
                    </th>
            </tr>
            <b></b>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td width="100px" align="Left"><%#Eval("Created", "{0:M/d/yyyy}")%></td>
                <td width="100px" align="Left"><%#Eval("ClientAccountNumber")%></td>
                <td width="200px" align="Left"><%#Eval("TransactionType")%></td>
                <td width="100px" align="Right"><%#Eval("BeginningBalance", "{0:c}")%></td>
                <td width="100px" align="Right"><%#InsertNBSP(Eval("Credit", "{0:c}"))%></td>
                <td width="100px" align="Right"><%#InsertNBSP(Eval("Debit", "{0:c}"))%></td>
                <td width="100px" align="Right"><%#Eval("EndingBalance", "{0:c}")%></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
                <tr>
                    <td colspan="7">
                        <asp:Label runat="server" Width="100%" ForeColor="Red" Text="This report is run at 5 AM PT each day. It is only accurate up until 5 AM PT today."></asp:Label>
                    </td>
                </tr>
        </FooterTemplate>
    </asp:Repeater>
    </table>
    
</asp:Content>

