<%@ Page Title="" Language="VB" AutoEventWireup="false" CodeFile="CommissionPayments.aspx.vb"
    Inherits="admin.Financial.adminFinancialCommissionPayments" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<style type="text/css">
    #header 
    {
    background:#0C52E9;
	border-bottom: double 3px #aba;
	border-left: solid 1px #9a9;
	border-right: solid 1px #565;
	border-top: solid 1px #9a9;
	font: italic normal 100% 'Tahoma' 16px;
	letter-spacing: 0.2em;
	margin: 0;
	padding: 15px 10px 15px 60px;
	height:20px;
	text-align:center;
	caption-side:top;
    }
</style>

<script type="text/javascript">
    function EnableButton() {
        var check = document.getElementById('<%=gvPayee.clientid %>')
        for(var i = 1; i<=check.rows.length-1; i++)
        {
            if(check.rows(i).cells([5].children(0).checked)
            {
                btnSubmit.enabled = true
            }
        }
    }
</script>

<head>
    <title>Comission Payments</title>
</head>
<body>
    <form id="form1" runat="server">
    
    <ajaxToolkit:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" />
            <h3 style="font-family:Tahoma; color:Black; text-align:center; vertical-align:top">
                Deposits and Payee payouts, dynamically change during the day.
            </h3>
            
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
        <ContentTemplate>
            <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                <ProgressTemplate>
                    <img alt="Updating records" src="~/Images/loading.gif" style="width: 16px; height: 16px" runat="server" />
                </ProgressTemplate>
            </asp:UpdateProgress>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <div id="divHeading">
        <table id="tblHeading" runat="server" width="100%">
            <tr align="right">
                    <th align="right" style="font-family:Tahoma; font-size:14px; vertical-align:middle; text-align:right;">
                        <asp:Label ID="lblReport" runat="server" Text="Reporting" style="vertical-align:middle; text-align:center;"></asp:Label> &nbsp;
                        <asp:ImageButton AlternateText="Print Report" ID="ibPrint" ImageUrl="~/images/48x48_printing.png" runat="server" style="text-align:center; vertical-align:middle;" onClick="btnReport_Click"/>
                    </th>
            </tr>
        </table>
    </div>
    
    <hr size="5" color="lightblue" align="left" />
    
    <asp:GridView ID="gvAttorney" runat="server" ShowHeader="True" CellPadding="4" AutoGenerateColumns="False"
        Width="100%" BorderWidth="0" Font-Names="Tahoma" GridLines="None" >
        <Columns>
            <asp:BoundField HeaderText="Attorney" DataField="AttorneyGCA" HeaderStyle-HorizontalAlign="Left" />
            <asp:BoundField HeaderText="Acct. Balance" DataField="CurrentBalance" DataFormatString="{0:c2}"
                HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Deposits" DataField="Deposits" DataFormatString="{0:c2}"
                HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="Payout" DataField="PlannedPayout" DataFormatString="{0:c2}"
                HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" />
            <asp:BoundField HeaderText="New Balance" DataField="NewBalance" DataFormatString="{0:c2}"
                HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" />
        </Columns>
    </asp:GridView>
    
    <hr size="5" color="lightblue" align="left" />
    
    <asp:GridView ID="gvPayee" runat="server" ShowHeader="true" CellPadding="4" AutoGenerateColumns="False"
        Width="100%" BorderWidth="0" Font-Names="Tahoma" GridLines="None" OnRowDataBound="gvPayee_RowDataBound">
        <Columns>
            <asp:BoundField HeaderText="Payee" DataField="Payee" HeaderStyle-HorizontalAlign="Left" />
            <asp:TemplateField >
                <HeaderTemplate>
                   AR Balance
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Right" />
                <ItemTemplate>
                    <asp:Label runat="server" ID="lblOpeningBalance" Text='<%#Format(Eval("ARBalance"), "Currency") %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="right" />
            </asp:TemplateField>
            <asp:BoundField HeaderText="Paid Today" DataField="Payout" DataFormatString="{0:c2}"
                HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" />
           <asp:TemplateField >
                <HeaderTemplate>
                   Account #
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Right" />
                <ItemTemplate>
                    <asp:Label runat="server" ID="txtAccountNumber" Text='<%#Eval("AccountNumber") %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="right" />
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    Withhold %
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtPct" Width="30" Text="10" AutoPostBack="false"
                        Font-Size="12px" MaxLength="2" />%
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    Withhold?
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="ckWithhold" Text="" Width="30px" Enabled="true"
                        Font-Size="12px" ></asp:CheckBox> 
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    Hold in Escrow Account
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <asp:DropDownList runat="server" ID="ddlAttorneyGCA" Font-Size="12px"
                        Font-Names="Tahoma" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
            <HeaderTemplate>
                Adj. AR Balance
            </HeaderTemplate>
            <ItemTemplate>
                <asp:Label ID="lblAdjBal" runat="server" Visible="True" Font-Size="16px" Font-Names="Tahoma" style="text-align:right;"/>
            </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Label ID="lblAPayout" runat="server" Visible="false" Text='<%#Eval("Payout") %>'   ></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
    <hr size="5" color="lightblue" align="left" />
    
    <div align="center" style="cursor: hand;">
        <asp:ImageButton AlternateText="Submit withholding for processing" ID="btnSubmit" ImageUrl="~/images/BigSubmit.jpg" runat="server" style="text-align:center; vertical-align:middle;" onClick="btnGCAClick" Enabled="true"/>
    </div>
    
    <%--Operating account withholding --%>
    <hr size="5" color="lightblue" align="left" />
    <asp:GridView ID="gvOperatingAcct" runat="server" ShowHeader="true" CellPadding="4" AutoGenerateColumns="False"
        Width="100%" BorderWidth="0" Font-Names="Tahoma" GridLines="None" OnRowDataBound="gvOperatingAcct_RowDataBound">
        <Columns>
            <asp:TemplateField >
                <HeaderTemplate>
                   Attorney OA
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <asp:Label runat="server" ID="lblAttorney" Text='<%#Eval("Name") %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Left" />
            </asp:TemplateField>
            <asp:TemplateField >
                <HeaderTemplate>
                   Paying into OA
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Right" />
                <ItemTemplate>
                    <asp:Label runat="server" ID="lblOAAmount" Text='<%#Format(Eval("OAAmount"), "Currency") %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
           <asp:TemplateField >
                <HeaderTemplate>
                   Account #
                </HeaderTemplate>
                <HeaderStyle HorizontalAlign="Right" />
                <ItemTemplate>
                    <asp:Label runat="server" ID="txtOAAccountNumber" Text='<%#Eval("OAAccountNumber") %>' />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="right" />
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    Keep in GCA %
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:TextBox runat="server" ID="txtOAPct" Width="30" Text="0" AutoPostBack="false"
                        Font-Size="12px" MaxLength="2" />%
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    Keep in GCA?
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox runat="server" ID="ckOAWithhold" Text="" Width="30px" Enabled="true"
                        Font-Size="12px" ></asp:CheckBox> 
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField>
            <HeaderTemplate>
                Adj. OA Payment
            </HeaderTemplate>
            <ItemTemplate>
                <asp:Label ID="lblOAAdjBal" runat="server" Visible="True" Font-Size="16px" Font-Names="Tahoma" style="text-align:right;"/>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="right" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
    <hr size="5" color="lightblue" align="left" />
    
    <div align="center" style="cursor: hand;">
        <asp:ImageButton AlternateText="Submit GCA Hold for processing" ID="btnSubmit2" ImageUrl="~/images/BigSubmit.jpg" runat="server" style="text-align:center; vertical-align:middle;" onClick="btnOAClick" Enabled="true"/>
    </div>
    
    </form>
</body>
</html>
