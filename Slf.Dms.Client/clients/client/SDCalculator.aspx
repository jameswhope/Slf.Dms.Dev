<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="SDCalculator.aspx.vb" Inherits="clients_client_sdcalculator" Title="DMP - Client" %>

<%@ MasterType TypeName="clients_client" %>
<%@ Register Src="calculator.ascx" TagName="calculator" TagPrefix="uc1" %>
<%@ Register Src="../../CustomTools/UserControls/CalculatorModelControl.ascx" TagName="CalculatorModelControl"
    TagPrefix="LexxControls" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .btnCalc
        {
            font-family: Tahoma;
            font-size: 11px;
            height: 22px;
        }
        .calculator
        {
            font-family: tahoma;
            font-size: 11px;
            table-layout: fixed;
            width: 540px;
            height: 230px;
        }
        .calculator td
        {
            padding: 0;
        }
        .calculator h2
        {
            background-color: SteelBlue;
            height: 19px;
            font-weight: bold;
            font-family: tahoma;
            font-size: 11px;
            color: #fff;
            text-align: center;
            padding: 2px;
            margin: 0;
        }
        .calculator h3
        {
            height: 15px;
            padding: 3px;
            background-color: #ADD8E6;
            font-weight: bold;
            font-family: tahoma;
            font-size: 11px;
            margin: 0;
            white-space: nowrap;
        }
        .entryin
        {
            font-family: tahoma;
            font-size: 11px;
            width: 130px;
            border: solid 1px #7F9DB9;
            height: 19px;
        }
        .calculator span
        {
            float: right;
            height: 18px;
        }
        .green
        {
            background-color: LawnGreen;
            height: 19px;
            padding: 2px;
            width: 132px;
            color: Black;
        }
        .orange
        {
            background-color: orange;
            height: 19px;
            padding: 2px;
            width: 132px;
            color: Black;
        }
        .red
        {
            background-color: red;
            height: 19px;
            padding: 2px;
            width: 132px;
            color: Yellow;
        }
        .calculator h4
        {
            padding: 3px;
            font-weight: normal;
            font-family: tahoma;
            font-size: 11px;
            margin: 0;
            white-space: nowrap;
            height: 19px;
        }
        .calculatorh5
        {
            padding: 0;
            font-weight: bold;
            font-family: tahoma;
            font-size: 11px;
            color: Yellow;
            text-align: center;
            margin: 0;
            width: 50%;
            background-color: SteelBlue;
            height: 22px;
        }
    </style>

    <script type="text/javascript">
        function RowHover(td, on) {
            if (on)
                td.parentElement.style.backgroundColor = "#f3f3f3";
            else
                td.parentElement.style.backgroundColor = "#ffffff";
        }
    </script>


    <asp:UpdatePanel ID="UpdCalculator" runat="server" ChildrenAsTriggers="true" >
    <ContentTemplate>
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;
        height: 100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td>
                <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table style="width: 100%; color: rgb(120,120,120); font-size: 11; font-family: Verdana, Arial, Helvetica"
                                cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="bottom">
                                        <asp:Label Style="color: rgb(80,80,80); font-family: tahoma; font-size: medium;"
                                            runat="server" ID="lblName"></asp:Label>&nbsp;<a class="lnk" style="font-family: verdana;
                                                color: rgb(80,80,80);" runat="server" id="lnkNumApplicants"></a><br />
                                        <asp:Label runat="server" ID="lblAddress"></asp:Label>
                                    </td>
                                    <td align="right" valign="bottom">
                                        <asp:Label runat="server" ID="lblSSN"></asp:Label><br />
                                        Status:&nbsp;<asp:LinkButton Style="color: rgb(50,112,163);" CssClass="lnk" runat="server"
                                            ID="lnkStatus"></asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-image: url(<%= ResolveUrl("~/images/dot.png") %>); background-position: left center;
                        background-repeat: repeat-x;">
                        <td>
                            <img height="30" width="1" runat="server" src="~/images/spacer.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left" style="padding: 3px; vertical-align: top; height: 35px;">
                            Load calculator data from:
                                    <asp:Button CssClass="btnCalc" ID="btnSD" runat="server" Text="Client Intake Department's site"
                                        TabIndex="1010" UseSubmitBehavior="False" />&nbsp;
                                    <asp:Button CssClass="btnCalc" ID="btnCurrent" runat="server" Text="This site: Current"
                                        TabIndex="1011" UseSubmitBehavior="False" />
                        </td>
                    </tr>
                    <tr id="trCalculator" runat="server">
                        <td style="height: 100%;" valign="top">
                            <uc1:calculator ID="sdcalculator" runat="server" />
                        </td>
                    </tr>
                    <tr id="trNewCalculator" runat="server">
                        <td style="height: 100%;" valign="top">
                            <LexxControls:CalculatorModelControl ID="newCalcModel" runat="server" Visible="true"
                                HideAcctPanel="false" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnCalculator" runat="server" />    
    </ContentTemplate> 
    </asp:UpdatePanel>

</asp:Content>
