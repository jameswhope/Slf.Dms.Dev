<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/financial/commission/commission.master"
    AutoEventWireup="false" CodeFile="clientintakepayments.aspx.vb" Inherits="research_reports_financial_commission_clientintakepayments" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
<script language="javascript">
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
</script>
<style type="text/css">
    .header1
    {
        font-family:Tahoma;
        font-size:11px;
        background-color:#c1c1c1;
        font-weight:bold;
        white-space:nowrap;
        text-align:right;
    }
    .row1
    {
    	font-family:Tahoma;
        font-size:11px;
        text-align:right;
    }
</style>
    <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0"
        cellpadding="0" cellspacing="0">
        <tr>
            <td style="background-color: rgb(244,242,232);">
                <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                    border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" />
                        </td>
                        <td style="width: 100%;">
                            <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                border="0">
                                <tr>
                                    <td nowrap="true">
                                        <asp:DropDownList ID="ddlQuickPickDate" runat="server" Style="font-family: Tahoma;
                                            font-size: 11px">
                                        </asp:DropDownList>
                                    </td>
                                    <td nowrap="true" style="width: 8;">
                                        &nbsp;
                                    </td>
                                    <td nowrap="true" style="width: 65; padding-right: 5;">
                                        <cc1:inputmask class="entry" runat="server" id="txtTransDate1" mask="nn/nn/nn"></cc1:inputmask>
                                    </td>
                                    <td nowrap="true" style="width: 8;">
                                        :
                                    </td>
                                    <td nowrap="true" style="width: 65; padding-right: 5;">
                                        <cc1:inputmask class="entry" runat="server" id="txtTransDate2" mask="nn/nn/nn"></cc1:inputmask>
                                    </td>
                                    <td nowrap="true">
                                        <img id="Img6" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                    </td>
                                    <td nowrap="true">
                                        <asp:LinkButton ID="lnkRequery" runat="server" CssClass="gridButton">
                                            <img id="Img7" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                src="~/images/16x16_exclamationpoint.png" />Refresh</asp:LinkButton>
                                    </td>
                                    <td nowrap="true" style="width: 100%;">
                                        &nbsp;
                                    </td>
                                    <td nowrap="true">
                                        <img id="Img8" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                    </td>
                                    <td nowrap="true">
                                        <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                            <img id="Img9" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                src="~/images/icons/xls.png" /></asp:LinkButton>
                                    </td>
                                    <td nowrap="true" style="width: 10;">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding: 20px 20px 10px 20px">
                <b><u>CID Payments to Lexxiom</u></b>
            </td>
            </tr>
        <tr>
            <td style="padding: 0 20px 20px 20px">
                <asp:GridView ID="gvPayments" runat="server" AllowPaging="False" AllowSorting="false" CellPadding="5"
                    AutoGenerateColumns="true" GridLines="None" ShowFooter="true" HeaderStyle-CssClass="header1" RowStyle-CssClass="row1" FooterStyle-CssClass="header1" Width="700px">
                    <EmptyDataTemplate>
                        <div style="padding: 20px; color: gray; font-style: italic">
                            No payments to Lexxiom within this date range.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td style="padding: 0 20px 20px 20px">
                <div style="width:720px; height:300px; overflow:auto">
                    <asp:GridView ID="gvPaymentsByClient" runat="server" AllowPaging="False" AllowSorting="false" CellPadding="3"
                        AutoGenerateColumns="true" GridLines="None" ShowFooter="false" HeaderStyle-CssClass="header1" RowStyle-CssClass="row1" FooterStyle-CssClass="header1" Width="700px">
                    </asp:GridView>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>
