<%@ Page Language="VB" AutoEventWireup="false" CodeFile="options.aspx.vb" Inherits="public_options" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Multiple Settlement Selection</title>
    <link href="~/css/default.css" rel="stylesheet" type="text/css" />
    <link href="~/processing/css/globalstyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html, body
        {
            height: 100%;
        }
        #divContent
        {
            text-align: center;
            padding: 10px;
        }
        .divHeader
        {
            padding: 10px;
            background-color: #3376AB;
            color: White;
            width: 97%;
        }
        .proceed
        {
            padding: 10px;
            background-color: #3376AB;
            color: White;
        }
        .modalMulitpleSettlement
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupMulitpleSettlement
        {
            background-color: #D6E7F3;
            border-width: 3px;
            border-style: solid;
            border-color: Gray;
            padding: 3px;
            width: 60%;
        }
        .PanelDragHeader
        {
            background-color: #3376AB;
            color: White;
            text-align: center;
            cursor: hand;
        }
        .gvAchGrid
        {
            width: 100%;
        }
        .gvAchGrid td
        {
            padding-right: 10px;
            padding-left: 3px;
        }
        .calcPanel{
          height:95px;
          background-color:#ffcccc;
          width:100%;
        }
    </style>
</head>
<body>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

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

            UpdateSettlementData();
        }

        function UpdateSettlementData() {
            var totalSettAmount = 0;
            var totalFees = 0;
            var totalSaving = 0;
            var totalCredit = 0;
            var totalDeliveryFees = 0;
            var totalAmtAvailable = 0;
            var totalOwed = 0;
            var totalFeeAvailable = 0;
            var totalFeeOwed = 0;
            var totalSettlementCosts = 0;

            var gridControl = document.getElementById("<%=gvOptions.ClientID %>");
            var txtDeliveryFees = document.getElementById("<%=lblDeliveryFee.ClientID %>");
            var txtFees = document.getElementById("<%=lblFee.ClientID %>");
            var txtSavings = document.getElementById("<%=lblSavings.ClientID %>");
            var txtCredit = document.getElementById("<%=lblFeeCredit.ClientID %>");
            var txtAmount = document.getElementById("<%=lblSettAmount.ClientID %>");
            var txtSDA = document.getElementById("<%=lblSDABalance.ClientID %>");
            var txtPFO = document.getElementById("<%=lblPFOBalance.ClientID %>");
            var txtFeeAvailable = document.getElementById("<%=lblFeeAvailable.ClientID %>");
            var txtFeeOwed = document.getElementById("<%=lblFeeOwed.ClientID %>");
            var txtAmtAvailable = document.getElementById("<%=lblAvailable.ClientID %>");
            var txtAmtOwed = document.getElementById("<%=lblAmountOwed.ClientID %>");
            var txtSettCost = document.getElementById("<%=lblSettCost.ClientID %>");
            var btn = document.getElementById("<%=trProceed.ClientID %>");
            var dMsg = document.getElementById("<%=divMsg.ClientID %>");

            var rowcount = gridControl.rows.length;

            for (i = 1; i < rowcount; i++) {
                if (gridControl.rows[i].cells[0].children[0].checked == true) {
                    if (isNaN(parseFloat(gridControl.rows[i].cells[4].innerText.replace("$", "").replace(",", ""))) == false) {
                        totalSettAmount += parseFloat(gridControl.rows[i].cells[4].innerText.replace("$", "").replace(",", ""));
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[1].value)) == false) {
                        totalSettlementCosts += parseFloat(gridControl.rows[i].cells[0].children[1].value);
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[2].value)) == false) {
                        totalAmtAvailable += parseFloat(gridControl.rows[i].cells[0].children[2].value);
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[4].value)) == false) {
                        totalOwed += parseFloat(gridControl.rows[i].cells[0].children[4].value);
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[5].value)) == false) {
                        totalFeeAvailable += parseFloat(gridControl.rows[i].cells[0].children[5].value);
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[0].children[7].value)) == false) {
                        totalFeeOwed += parseFloat(gridControl.rows[i].cells[0].children[7].value);
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[11].innerText.replace("$", "").replace(",", ""))) == false) {
                        totalSaving += parseFloat(gridControl.rows[i].cells[11].innerText.replace("$", "").replace(",", ""));
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[10].innerText.replace("$", "").replace(",", ""))) == false) {
                        totalCredit += parseFloat(gridControl.rows[i].cells[10].innerText.replace("$", "").replace(",", ""));
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""))) == false) {
                        totalDeliveryFees += parseFloat(gridControl.rows[i].cells[9].innerText.replace("$", "").replace(",", ""));
                    }

                    if (isNaN(parseFloat(gridControl.rows[i].cells[7].innerText.replace("$", "").replace(",", ""))) == false) {
                        totalFees += parseFloat(gridControl.rows[i].cells[7].innerText.replace("$", "").replace(",", ""));
                    }
                }
            }

            var regbal = parseFloat(txtSDA.innerText.replace("$", "").replace(",", ""));
            var pfobal = parseFloat(txtPFO.innerText.replace("$", "").replace(",", ""));

            txtAmount.innerText = "$" + FormatNumber(totalSettAmount, false, 2);
            txtCredit.innerText = "$" + FormatNumber(totalCredit, false, 2);
            txtDeliveryFees.innerText = "$" + FormatNumber(totalDeliveryFees, false, 2);
            txtFees.innerText = "$" + FormatNumber(totalFees, false, 2);
            txtSavings.innerText = "$" + FormatNumber(totalSaving, false, 2);
            txtAmtAvailable.innerText = "$" + FormatNumber(totalAmtAvailable, false, 2);
            if (regbal > totalSettAmount) {
         
                txtAmtAvailable.style.color = "green";
                txtAmtOwed.innerText = "$" + FormatNumber(0, false, 2);
                txtAmtOwed.style.color = "green";
                btn.style.display = 'block';
                dMsg.style.display = 'none';
                dMsg.innerHTML = '';
            }
            else {
                txtAmtAvailable.style.color = "red";
                var dif = Math.abs(regbal - totalSettAmount)
                txtAmtOwed.innerText = "$" + FormatNumber(dif, false, 2);
                txtAmtOwed.style.color = "red";
                btn.style.display = 'none';
                dMsg.style.display = 'block';
                dMsg.className = 'error';
                dMsg.innerHTML = 'Selected settlements are over your available funds by $' + FormatNumber(dif, false, 2) + '<br>';
                dMsg.innerHTML += '<a href="#" onclick="return showAdd();">Create an Ad-hoc deposit</a>';
            }

            if ((regbal - pfobal - totalSettAmount) > totalSettlementCosts) {
                txtFeeAvailable.style.color = "green";
                txtFeeAvailable.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
                txtFeeOwed.innerText = "$" + FormatNumber(0, false, 2);
            }
            else {
                txtFeeAvailable.style.color = "red";
                if ((regbal - pfobal - totalSettAmount) >= 0) {
                    txtFeeAvailable.innerText = "$" + FormatNumber((regbal - pfobal - totalSettAmount), false, 2);
                    txtFeeOwed.innerText = "$" + FormatNumber((totalSettlementCosts - (regbal - pfobal - totalSettAmount)), false, 2);
                }
                else {
                    txtFeeAvailable.innerText = "$" + FormatNumber(0, false, 2);
                    txtFeeOwed.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
                }
            }

            txtSettCost.innerText = "$" + FormatNumber(totalSettlementCosts, false, 2);
        }
       
        function showAdd() {
            var tbl = document.getElementById('<%=trACH.ClientID %>');
            tbl.style.display = (tbl.style.display != 'none' ? 'none' : '');
            return false;
        }
        
    </script>

    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="smOptions" runat="server" />
    <asp:UpdatePanel ID="updPendingSettlementCalculator" runat="server">
        <ContentTemplate>
            <div id="divContent" runat="server">
                <table class="entry" cellpadding="0" cellspacing="0" border="0">
                    <tr style="color: White;">
                        <td style="padding: 5px;">
                            <asp:Panel ID="pnlHeader" runat="server" BackColor="#4791C5">
                                <h1>
                                    Multiple Settlement Selections</h1>
                            </asp:Panel>
                            <ajaxToolkit:RoundedCornersExtender ID="rcepnlHeader" runat="server" TargetControlID="pnlHeader"
                                Radius="6" BorderColor="Black" />
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 15px; text-align: center;">
                            <div id="divMsg" runat="server" style="display: none;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 15px;">
                            <asp:GridView ID="gvOptions" runat="server" AllowPaging="False" AllowSorting="True"
                                AutoGenerateColumns="False" BorderStyle="None" GridLines="none" PageSize="7"
                                Width="100%" CssClass=" entry" DataSourceID="dsOptions" DataKeyNames="settlementid">
                                <HeaderStyle ForeColor="Black" />
                                <EmptyDataTemplate>
                                    <div>
                                        No records to display.</div>
                                </EmptyDataTemplate>
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            &nbsp;<input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input type="checkbox" runat="server" id="chk_select" onclick="UpdateSettlementData();" />
                                            <input type="hidden" runat="server" id="hdnSettCost" value='<%#DataBinder.Eval(Container.DataItem, "SettlementCost")%>' />
                                            <input type="hidden" runat="server" id="hdnAmtAvail" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtAvailable")%>' />
                                            <input type="hidden" runat="server" id="hdnAmtSent" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtBeingSent")%>' />
                                            <input type="hidden" runat="server" id="henAmtOwed" value='<%#DataBinder.Eval(Container.DataItem, "SettlementAmtStillOwed")%>' />
                                            <input type="hidden" runat="server" id="hdnFeeAvail" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtAvailable")%>' />
                                            <input type="hidden" runat="server" id="hdnFeePaid" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtBeingPaid")%>' />
                                            <input type="hidden" runat="server" id="hdnFeeOwed" value='<%#DataBinder.Eval(Container.DataItem, "SettlementFeeAmtStillOwed")%>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Width="25" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" Width="25" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CreditorName" SortExpression="CreditorName" HeaderText="CreditorName"
                                        HtmlEncode="False">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AccountNumber" SortExpression="AccountNumber" HeaderText="Acct#"
                                        HtmlEncode="false">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AccountBalance" SortExpression="AccountBalance" DataFormatString="{0:C}"
                                        HeaderText="Account Balance" HtmlEncode="False">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementAmount" DataFormatString="{0:C}" HeaderText="Settlement Amount"
                                        HtmlEncode="False" SortExpression="SettlementAmount">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementPercent" DataFormatString="{0:N2}" HeaderText="Settlement %"
                                        HtmlEncode="False" SortExpression="SettlementPercent">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementDueDate" DataFormatString="{0:d}" HeaderText="Due Date"
                                        HtmlEncode="False" SortExpression="SettlementDueDate">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementFee" HeaderText="Sett Fee" DataFormatString="{0:C}"
                                        HtmlEncode="false" SortExpression="SettlementFee">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementFeePercentage" HeaderText="Sett Fee %" DataFormatString="{0:N}"
                                        HtmlEncode="false" SortExpression="SettlementFeePercentage">
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DeliveryFee" HeaderText="Delivery Fee" DataFormatString="{0:C}"
                                        HtmlEncode="false" SortExpression="DeliveryFee">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementFeeCredit" HeaderText="Sett Fee Credit" DataFormatString="{0:C}"
                                        HtmlEncode="false" SortExpression="SettlementFeeCredit">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SettlementSavings" HeaderText="Savings" DataFormatString="{0:C}"
                                        HtmlEncode="false" SortExpression="SettlementSavings">
                                        <HeaderStyle HorizontalAlign="Right" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Status" HeaderText="Status" HtmlEncode="false" SortExpression="Status">
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" Wrap="true" />
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="dsOptions" ConnectionString="<%$ AppSettings:connectionstring %>"
                                runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_GetPendingSettlementsForClient"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-1" Name="clientid" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 15px;">
                            <table style="width: 100%; font-family: tahoma; font-size: 11px;" cellpadding="0"
                                cellspacing="0" border="0">
                                <tr>
                                    <td style="background-color: #DCDCDC; height: 20px; border-bottom: solid 1px #d3d3d3;
                                        font-weight: bold; color: Black; font-size: 11px; font-family: tahoma;">
                                        Calculator
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 5 10 10 10;">
                                        <table style="width: 100%; font-family: tahoma; font-size: 11px; height:120px;" cellpadding="0"
                                            cellspacing="3" border="0">
                                            <tr align="left" valign="top">
                                                <td style="width:33%; padding:5px;">
                                                    <asp:Panel ID="pnlBalInfo" runat="server" CssClass="calcPanel" >
                                                        <table  class="entry">
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px; text-align"
                                                                    nowrap="true">
                                                                    Available SDA Balance:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblSDABalance" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    PFO Balance:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblPFOBalance" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Next Deposit Amount:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblDeliveryAmount" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Next Deposit Date:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblDeliveryDate" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <ajaxToolkit:RoundedCornersExtender ID="RoundedCornersExtender1" runat="server" TargetControlID="pnlBalInfo"
                                                        Radius="6" BorderColor="Black" />
                                                </td>
                                                <td style="width:33%;padding:5px;">
                                                    <asp:Panel ID="pnlSettInfo" runat="server" CssClass="calcPanel"  >
                                                        <table style="border-right-color: #BEDCE6; border-right-width: 2px; border-right-style: solid;
                                                            border-left-color: #BEDCE6; border-left-width: 2px; border-left-style: solid;
                                                            width: 100%">
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Settlement Amount:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblSettAmount" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black;" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Savings:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblSavings" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Amount Owed:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblAmountOwed" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Amount Available:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblAvailable" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Fee Owed:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblFeeOwed" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <ajaxToolkit:RoundedCornersExtender ID="RoundedCornersExtender2" runat="server" TargetControlID="pnlSettInfo"
                                                        Radius="6" BorderColor="Black" />
                                                </td>
                                                <td style="width:33%;padding:5px;">
                                                    <asp:Panel ID="pnlFeeInfo" runat="server" CssClass="calcPanel" >
                                                        <table style="width: 100%;">
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Fee:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblFee" runat="server" Style="width: 60; font-family: Tahoma; font-size: 11px;
                                                                        color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Fee Credit:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblFeeCredit" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Delivery Fees:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblDeliveryFee" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px">
                                                                    Total Fee Amount Available:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblFeeAvailable" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 15;" align="center" />
                                                                <td style="width: 130; color: Black; font-family: Tahoma; font-size: 11px" nowrap="true">
                                                                    Total Settlement Costs:
                                                                </td>
                                                                <td style="width: 70; text-align: right;">
                                                                    <asp:Label ID="lblSettCost" runat="server" Style="width: 60; font-family: Tahoma;
                                                                        font-size: 11px; color: Black" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <ajaxToolkit:RoundedCornersExtender ID="RoundedCornersExtender3" runat="server" TargetControlID="pnlFeeInfo"
                                                        Radius="6" BorderColor="Black" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trProceed" runat="server" style="display: none;">
                        <td style="padding: 5px;">
                            <asp:Panel ID="pnlProceed" runat="server" BackColor="#4791C5" Height="25">
                                <asp:Button ID="btnProceed" runat="server" Text="Process Selected Settlements" />
                            </asp:Panel>
                            <ajaxToolkit:RoundedCornersExtender ID="rcepnlProceed" runat="server" TargetControlID="pnlProceed"
                                Radius="6" BorderColor="Black" />
                        </td>
                    </tr>
                    <tr id="trACH" runat="server" style="display:block;">
                        <td>
                            <table class="entry" cellpadding="0" cellspacing="0">
                                <tr style="color: White;">
                                    <td style="padding: 5px;">
                                        <asp:Panel ID="pnlACH" runat="server" BackColor="#4791C5">
                                            <table class="entry" cellpadding="0" cellspacing="0">
                                                <td align="left" style="padding-left: 10px;">
                                                    <h2>
                                                        ACH Info</h2>
                                                </td>
                                                <td align="right" style="padding-right: 10px;">
                                                    <asp:CheckBox ID="OnlyNotDeposited" runat="server" Text="Show only not deposited"
                                                        AutoPostBack="true" />
                                                </td>
                                            </table>
                                        </asp:Panel>
                                        <ajaxToolkit:RoundedCornersExtender ID="rcepnlACH" runat="server" TargetControlID="pnlACH"
                                            Radius="6" BorderColor="Black" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 10px;">
                                        <asp:GridView ID="gvAch" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                                            DataSourceID="dsACH" CssClass="gvAchGrid" GridLines="None" DataKeyNames="AdHocAchID">
                                            <Columns>
                                                <asp:CommandField ShowEditButton="True">
                                                    <HeaderStyle CssClass="headItem5" Width="30px" />
                                                    <ItemStyle CssClass="listitem" Width="30px" HorizontalAlign="Center" />
                                                </asp:CommandField>
                                                <asp:CommandField ShowDeleteButton="True">
                                                    <HeaderStyle CssClass="headItem5" Width="30px" />
                                                    <ItemStyle CssClass="listitem" Width="30px" HorizontalAlign="Center" />
                                                </asp:CommandField>
                                                <asp:BoundField DataField="AdHocAchID" HeaderText="AdHocAchID" SortExpression="AdHocAchID"
                                                    Visible="False" InsertVisible="False" ReadOnly="True"></asp:BoundField>
                                                <asp:BoundField DataField="ClientID" HeaderText="ClientID" SortExpression="ClientID"
                                                    Visible="False"></asp:BoundField>
                                                <asp:BoundField DataField="RegisterID" HeaderText="RegisterID" SortExpression="RegisterID"
                                                    Visible="False" />
                                                <asp:TemplateField HeaderText="Deposit Date" SortExpression="DepositDate">
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="DepositDateTextBox" runat="server" Text='<%# Bind("DepositDate", "{0:MM/dd/yyyy}") %>'
                                                            CssClass="entry2" />
                                                        <asp:ImageButton runat="Server" ID="imgDepositDateTextBox" ImageUrl="~/images/Calendar_scheduleHS.png"
                                                            AlternateText="Click to show calendar" ImageAlign="AbsMiddle" />
                                                        <ajaxToolkit:CalendarExtender ID="extDepositDateTextBox" runat="server" TargetControlID="DepositDateTextBox"
                                                            PopupButtonID="imgDepositDateTextBox" CssClass="MyCalendar" />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("DepositDate", "{0:MM/dd/yyyy}") %>'
                                                            CssClass="entry2"></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Deposit Amount" SortExpression="DepositAmount">
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="DepositAmountTextBox" runat="server" Text='<%# Bind("DepositAmount","{0:c2}") %>'
                                                            CssClass="entry"></asp:TextBox>
                                                        <ajaxToolkit:FilteredTextBoxExtender ID="extDepositAmountTextBox" runat="server"
                                                            TargetControlID="DepositAmountTextBox" FilterType="Custom" ValidChars="0123456789.," />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("DepositAmount","{0:c2}") %>'
                                                            CssClass="entry2"></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Right" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Bank Name" SortExpression="BankName">
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="ddlBankName" runat="server" CssClass="entry" />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label3" runat="server" Text='<%# string.format("{0} - {1} - {2}", eval("BankName"),eval("BankAccountNumber"),eval("BankType")) %>'
                                                            CssClass="entry2"></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Routing #" SortExpression="BankRoutingNumber" Visible="false">
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="BankRoutingNumberTextBox" runat="server" Text='<%# Bind("BankRoutingNumber") %>'
                                                            CssClass="entry"></asp:TextBox>
                                                        <ajaxToolkit:FilteredTextBoxExtender ID="extBankRoutingNumberTextBox" runat="server"
                                                            TargetControlID="BankRoutingNumberTextBox" FilterType="Custom" ValidChars="0123456789" />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("BankRoutingNumber") %>' CssClass="entry2"></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Account #" SortExpression="BankAccountNumber" Visible="false">
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="BankAccountNumberTextBox" runat="server" Text='<%# Bind("BankAccountNumber") %>'
                                                            CssClass="entry"></asp:TextBox>
                                                        <ajaxToolkit:FilteredTextBoxExtender ID="extBankAccountNumberTextBox" runat="server"
                                                            TargetControlID="BankAccountNumberTextBox" FilterType="Custom" ValidChars="0123456789-" />
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("BankAccountNumber") %>' CssClass="entry2"></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="BankType" HeaderText="Type" SortExpression="BankType"
                                                    Visible="false" ReadOnly="true">
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:CheckBoxField DataField="InitialDraftYN" HeaderText="Initial Draft Y/N" SortExpression="InitialDraftYN"
                                                    ReadOnly="true">
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Center" />
                                                </asp:CheckBoxField>
                                                <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                                    ReadOnly="true">
                                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" SortExpression="CreatedBy"
                                                    Visible="false" />
                                                <asp:BoundField DataField="LastModified" HeaderText="LastModified" SortExpression="LastModified"
                                                    Visible="false" ReadOnly="true">
                                                    <HeaderStyle CssClass="headItem5" />
                                                    <ItemStyle CssClass="listItem" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModifiedBy" SortExpression="LastModifiedBy"
                                                    Visible="false">
                                                    <HeaderStyle CssClass="headItem5" />
                                                    <ItemStyle CssClass="listItem" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="BankAccountId" HeaderText="BankAccountId" SortExpression="BankAccountId"
                                                    Visible="False" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                            <div style="padding:10px; font-weight:bold; text-align:left;" class="entry">
                                                No Ach Info.
                                                </div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="dsACH" runat="server" ConnectionString="<%$ Appsettings:ConnectionString %>"
                                            SelectCommand="stp_lexxsign_getClientAchInfo" SelectCommandType="StoredProcedure"
                                            ProviderName="System.Data.SqlClient" UpdateCommand="stp_lexxsign_updateClientAchInfo"
                                            UpdateCommandType="StoredProcedure" DeleteCommand="stp_lexxsign_deleteClientAchInfo"
                                            DeleteCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:Parameter Name="Clientid" DefaultValue="-1" />
                                                <asp:Parameter DefaultValue="0" Name="onlyDeposited" Type="Boolean" />
                                            </SelectParameters>
                                            <DeleteParameters>
                                                <asp:Parameter Name="AdHocAchID" Type="Int32" />
                                            </DeleteParameters>
                                            <UpdateParameters>
                                                <asp:Parameter Name="DepositDate" Type="DateTime" />
                                                <asp:Parameter Name="DepositAmount" Type="Decimal" />
                                                <asp:Parameter Name="BankAccountId" Type="Int32" />
                                                <asp:Parameter Name="AdHocAchID" Type="Int32" />
                                            </UpdateParameters>
                                        </asp:SqlDataSource>
                                        <fieldset id="fldAdd" runat="server" style="display: block;">
                                            <legend>Add New Deposit</legend>
                                            <table id="tblAddACH" runat="server" class="gvAchGrid" cellpadding="0" cellspacing="0"
                                                border="0">
                                                <thead>
                                                    <tr>
                                                        <th class="headItem5" style="width: 60px;">
                                                            &nbsp;
                                                        </th>
                                                        <th class="headItem5" style="width: 175px; text-align: left;">
                                                            Deposit Date
                                                        </th>
                                                        <th class="headItem5" style="width: 100px; text-align: right;">
                                                            Deposit Amount
                                                        </th>
                                                        <th class="headItem5" style="text-align: left;">
                                                            Bank Name
                                                        </th>
                                                        <th class="headItem5" style="width: 100px; text-align: left;">
                                                            Routing #
                                                        </th>
                                                        <th class="headItem5" style="width: 100px; text-align: left;">
                                                            Account #
                                                        </th>
                                                        <th class="headItem5" style="width: 100px; text-align: center;">
                                                            Account Type
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tr>
                                                    <td class="listItem" style="width: 60px; text-align: center;">
                                                        <asp:LinkButton ID="lnkSaveACH" runat="server" Text="Save" CssClass="lnk" />
                                                        <asp:LinkButton ID="lnkCancel" runat="server" Text="Cancel" CssClass="lnk" />
                                                    </td>
                                                    <td class="listItem" align="left" style="width: 175px;">
                                                        <asp:TextBox CssClass="entry2" ID="txtDepositDate" Width="150px" runat="server" />
                                                        <asp:ImageButton runat="Server" ID="imgDepositDate" ImageUrl="~/images/Calendar_scheduleHS.png"
                                                            AlternateText="Click to show calendar" ImageAlign="AbsMiddle" />
                                                        <ajaxToolkit:CalendarExtender ID="extDepositDate" runat="server" TargetControlID="txtDepositDate"
                                                            PopupButtonID="imgDepositDate" CssClass="MyCalendar" />
                                                    </td>
                                                    <td class="listItem" style="width: 100px; text-align: left;">
                                                        <asp:TextBox CssClass="entry" ID="txtDepositAmt" runat="server" />
                                                        <ajaxToolkit:FilteredTextBoxExtender ID="txtDepositAmt_FilteredTextBoxExtender" runat="server"
                                                            Enabled="True" TargetControlID="txtDepositAmt" ValidChars="0123456789.," />
                                                    </td>
                                                    <td class="listItem">
                                                        <asp:DropDownList CssClass="entry" ID="ddlBanks" runat="server" AutoPostBack="true" />
                                                    </td>
                                                    <td class="listItem" style="width: 100px;">
                                                        <asp:Label CssClass="entry" ID="txtBankRouting" MaxLength="9" runat="server" />
                                                    </td>
                                                    <td class="listItem" style="width: 100px;">
                                                        <asp:Label CssClass="entry" ID="txtBankAcct" runat="server" />
                                                    </td>
                                                    <td class="listItem" style="width: 100px; text-align: center">
                                                        <asp:Label CssClass="entry" ID="lblBankAcctType" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </td>
                                </tr>
                                
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvOptions" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="gvOptions" EventName="PageIndexChanging" />
            <asp:AsyncPostBackTrigger ControlID="gvOptions" EventName="Sorting" />
            <asp:AsyncPostBackTrigger ControlID="gvAch" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="lnkSaveACH" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    </form>
</body>
</html>
