<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="clients_client_finances_bytype_default" Title="DMP - Client - Payments" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="Slf.Dms.Controls" Namespace="Slf.Dms.Controls" TagPrefix="asi" %>
<%@ Import Namespace="Slf.Dms.Records" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript">

        function Record_AddTransaction()
        {
            window.navigate("<%= ResolveUrl("~/clients/client/finances/bytype/add.aspx?id=" & ClientID) %>");
        }
        function RowHover(td, on)
        {
            var tr = td.parentElement;

            //preceding deposits
            while (tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.previousSibling;
            }
            
            //main row
            if (on)
                tr.style.backgroundColor = "#f3f3f3";
            else
                tr.style.backgroundColor = "#ffffff";
            
            //following deposits
            tr = td.parentElement.nextSibling;
            while (tr != null && tr.IsMainRow == null)
            {
                if (on)
                    tr.style.backgroundColor = "#f3f3f3";
                else
                    tr.style.backgroundColor = "#ffffff";
                tr = tr.nextSibling;
            }
        }

    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%;" border="0" cellspacing="15">
        <tr>
            <td valign="top" style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;Finances&nbsp;>&nbsp;Transactions By Type
            </td>
        </tr>
        <tr>
            <td style="height:100%;" valign="top">
                <asi:TabStrip runat="server" id="tsMain"></asi:TabStrip>
                <div id="dvPanel0" runat="server">
                    <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="padding:5 7 5 7;color:rgb(50,112,163);">Payments</td>
                            <td style="padding-right:7;" align="right"></td>
                        </tr>
                    </table>
                    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle"/></td>
                            <td class="headItem">Date<img align="absmiddle" style="margin-left:5;" runat="server" border="0" src="~/images/sort-asc.png" /></td>
                            <td class="headItem">Fee Type Paid</td>
                            <td class="headItem" align="right">Fee Total</td>
                            <td class="headItem" align="right">Paid Amount</td>
                            <td class="headItem" align="center">IFP</td>
                            <td class="headItem" style="padding-left:10;">From</td>
                            <td class="headItem">Check #</td>
                            <td class="headItem">Date</td>
                            <td class="headItem" align="right">Portion Used</td>                            
                        </tr>
                        <asp:repeater id="rpPayments" runat="server">
                            <itemtemplate>
                                <a class="lnk" href="payment.aspx?id=<%= ClientID %>&rpid=<%#DataBinder.Eval(Container.DataItem, "RegisterPaymentID")%>">
                                <tr IsMainRow="true">
                                    <td valign="top" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" style="width:22;" class="listItem" align="center" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                        <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                    </td>
                                    <td valign="top" style="padding-top:5" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                        <%#DataBinder.Eval(Container.DataItem, "PaymentDate", "{0:MM/dd/yyyy}")%>&nbsp;
                                    </td>
                                    <td valign="top" style="padding-top:5" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                        <a class="lnk" href="register.aspx?id=<%= ClientID %>&rid=<%#DataBinder.Eval(Container.DataItem, "FeeRegisterID")%>" ><%#DataBinder.Eval(Container.DataItem, "FeeRegisterEntryTypeName")%></a>&nbsp;
                                    </td>
                                    <td valign="top" style="padding-top:5;color:red;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right">
                                        <%#DataBinder.Eval(Container.DataItem, "FeeRegisterAmount", "{0:c}")%>&nbsp;
                                    </td>
                                    <td valign="top" style="padding-top:5;color:rgb(0,139,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right">
                                        <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                    </td>
                                    <td valign="top" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="center">
                                        <img src="<%#IIf(DataBinder.Eval(Container.DataItem, "FeeRegisterIsFullyPaid"), ResolveUrl("~/images/16x16_check.png"), ResolveUrl("~/images/16x16_empty.png"))%>" border="0" align="absmiddle" />
                                    </td>
                                    <asp:repeater runat="server" datasource="<%# CType(Container.DataItem, RegisterPayment).Deposits %>">
                                        <itemtemplate>
                                            <%#IIf(Container.ItemIndex = 0, "", "</tr><tr>")%>
                                            <td style="padding-left:10;height:24;" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                <a class="lnk" href="register.aspx?id=<%= ClientID %>&rid=<%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterId %>" ><%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName%></a>&nbsp;
                                            </td>
                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterCheckNumber%>&nbsp;
                                            </td>
                                            <td onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem">
                                                <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterTransactionDate.ToString("MM/dd/yyyy")%>&nbsp;
                                            </td>
                                            <td style="color:rgb(0,139,0);" onmouseover="RowHover(this, true);" onmouseout="RowHover(this, false);" class="listItem" align="right">
                                                <%#CType(Container.DataItem, RegisterPaymentDeposit).Amount.ToString("c")%>&nbsp;
                                            </td>
                                        </itemtemplate> 
                                    </asp:repeater>
                                </tr>
                                </a>
                            </itemtemplate>
                            <FooterTemplate>
                               
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>                      
                                    <td style="text-align:right">Fee Total: <asp:Label ID="lblFeeTotal" runat="server" /></td>
                                    <td style="text-align:right">Paid Total: <asp:Label ID="lblPaidTotal" runat="server" /></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td style="text-align:right">Portion Total: <asp:Label ID="lblPortionTotal" runat="server" /></td>
                                </tr>
                                
                            </FooterTemplate>
                        </asp:repeater>
                    </table>
                   
                    <asp:panel runat="server" id="pnlNone" style="text-align:center;padding:20 5 5 5;">This client has no payments.</asp:panel>
                </div>
            </td>
        </tr>
    </table>

</asp:Content>