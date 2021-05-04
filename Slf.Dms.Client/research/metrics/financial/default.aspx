<%@ Page Language="VB" MasterPageFile="~/research/metrics/financial/financial.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_financial_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/metrics">Metrics</a>&nbsp;>&nbsp;Financial</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblCommission" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Commission</td>
                    </tr>
                    <tr id="trComparison" runat="server">
                        <td style="padding-left:20;"><a id="A5" runat="server" class="lnk" href="~/research/metrics/financial/commission.aspx"><img id="Img5" style="margin-right:5;" src="~/images/16x16_chart_bar.png" runat="server" border="0" align="absmiddle"/>Commission Comparison</a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>

