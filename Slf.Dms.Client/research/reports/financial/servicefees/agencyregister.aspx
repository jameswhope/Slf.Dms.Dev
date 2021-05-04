<%@ Page Language="VB" MasterPageFile="~/site.master" AutoEventWireup="false" CodeFile="agencyregister.aspx.vb" Inherits="clients_client_finances_bytype_agencyregister" title="DMP - Client - Register" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Import Namespace="Slf.Dms.Records" %>

<asp:Content ID="cntMenu" ContentPlaceHolderID="cphMenu" Runat="Server"><asp:Panel runat="server" ID="pnlMenu">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td><img width="8" height="28" src="~/images/spacer.gif" runat="server" /></td>
            <td nowrap="true">
                <a class="menuButton" href="#" runat="server" id="lnkBack">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_arrowleft_clear.png" />Back to Service Fees</a></td>
            <td width="100%"></td>
        </tr>
    </table>   
</asp:Panel></asp:Content>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:Panel ID="pnlBody" runat="server">

<body style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>

    <script type="text/javascript">

    function RowHover(td, on)
    {
        var tr = td.parentElement;

        if (tr.style.backgroundColor != "rgb(255,230,230)")
        {
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
    }
    function RowClick(RegisterID)
    {
        window.navigate("<%= ResolveUrl("~/clients/client/finances/register/register.aspx?id=" & ClientID & "&rid=") %>" + RegisterID);
    }

    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><div style="color:rgb(80,80,80);font-family:tahoma;font-size:medium;" runat="server" ID="lnkClient"></div></td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv" style="background-color:rgb(213,236,188);">
                    <table class="iboxTable" style="background-color:rgb(213,236,188);" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td valign="top" ><asp:Label runat="server" ID="lblInfoBox"></asp:Label></td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="width:40%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;" colspan="2">General Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction ID:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblRegisterID"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction Type:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblEntryTypeName"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Posting Date:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblTransactionDate"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Transaction Amount:</td>
                                    <td nowrap="true"><asp:Label runat="server" ID="lblAmount"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Balance After:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblBalance"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Check Number:</td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblCheckNumber"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell"><asp:Label runat="server" id="lblIsFullyPaidHeader"></asp:Label></td>
                                    <td><asp:Label CssClass="entry" runat="server" ID="lblIsFullyPaid"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="2" nowrap="true" style="background-color:#f1f1f1;">Description</td>
                                </tr>
                                <tr>
                                    <td colspan="2"><asp:Label runat="server" id="lblDescription"></asp:Label><asp:TextBox style="display:none;width:100%;" Rows="7" CssClass="entry" runat="server" id="txtDescription" TextMode="MultiLine"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                        <td><img height="1" width="30" runat="server" src="~/images/spacer.gif" /></td>
                        <td style="width:60%;" valign="top">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                                <tr><td style="padding: 5 5 5 5;background-color:#f1f1f1;"><asp:Label runat="server" id="lblPaymentsHeader"></asp:Label></td></tr>
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" id="pnlPaymentsUsedFor">
                                            <table id="tblPaymentsUsedFor" onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
		                                        <tr>
		                                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0"/></td>
			                                        <td class="headItem">Date<img style="margin-left:8;" align="absmiddle" runat="server" src="~/images/sort-asc.png" border="0"/></td>
			                                        <td class="headItem" nowrap="true">Fee</td>
			                                        <td class="headItem" align="right" nowrap="true">Total</td>
			                                        <td class="headItem" style="padding-left:10;" nowrap="true">From</td>
			                                        <td class="headItem" nowrap="true">Date</td>
			                                        <td class="headItem" align="right" nowrap="true">Amount</td>
		                                        </tr>
                                                <asp:repeater id="rpPaymentsUsedFor" runat="server">
                                                    <itemtemplate>
                                                        
                                                        <tr IsMainRow="true" <%#IIf(DataBinder.Eval(Container.DataItem, "Voided") or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") %>>
                                                            <td valign="top" style="width:22;cursor:default" class="listItem" align="center" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;cursor:default" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <%#DataBinder.Eval(Container.DataItem, "PaymentDate", "{0:MM/dd/yyyy}")%>&nbsp;
                                                            </td>
                                                            <td valign="top" style="padding-top:5;cursor:default" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                This&nbsp;<%#DataBinder.Eval(Container.DataItem, "FeeRegisterEntryTypeName")%>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;cursor:default" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right" style="color:rgb(0,139,0);">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                            <asp:repeater runat="server" datasource="<%# CType(Container.DataItem, RegisterPayment).Deposits%>">
                                                                <itemtemplate>
                                                                    <%#IIf(Container.ItemIndex = 0, "", "</tr><tr " & IIf(DataBinder.Eval(Container.DataItem, "Voided") Or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") & ">")%>
                                                                    <td style="padding-left:10;height:24;cursor:default" class="listItem">
                                                                        Deposit
                                                                    </td>
                                                                    <td class="listItem" style="cursor:default">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterTransactionDate.ToString("MM/dd/yyyy")%>&nbsp;
                                                                    </td>
                                                                    <td class="listItem" style="color:rgb(0,139,0);cursor:default" align="right">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).Amount.ToString("c")%>&nbsp;
                                                                    </td>
                                                                </itemtemplate> 
                                                            </asp:repeater>
                                                        </tr>

                                                    </itemtemplate>
                                                </asp:repeater>
	                                        </table><br />
	                                        <div nowrap="true" style="text-align:right;">Left&nbsp;to&nbsp;be&nbsp;paid:&nbsp;<asp:label style="color:rgb(255,0,0);" runat="server" id="lblDebitRemaining"></asp:label></div>
	                                    </asp:Panel>
	                                    <asp:Panel runat="server" id="pnlPaymentsMadeWith">
                                            <table id="tblPaymentsMadeWith" onselectstart="return false;" style="font-size:11px;font-family:tahoma;width:100%;" cellspacing="0" cellpadding="3" border="0">
                                                <tr>
		                                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_icon.png" border="0"/></td>
			                                        <td class="headItem">Date<img style="margin-left:8;" align="absmiddle" runat="server" src="~/images/sort-asc.png" border="0"/></td>
			                                        <td class="headItem" nowrap="true">Fee</td>
			                                        <td class="headItem" align="right" nowrap="true">Total</td>
			                                        <td class="headItem" style="padding-left:10;" nowrap="true">From</td>
			                                        <td class="headItem" nowrap="true">Date</td>
			                                        <td class="headItem" align="right" nowrap="true">Amount</td>
                                                </tr>
		                                        <asp:Repeater id="rpPaymentsMadeWith" runat="server">
			                                        <ItemTemplate>
                                                        <tr IsMainRow="true" <%#IIf(DataBinder.Eval(Container.DataItem, "Voided") or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") %>>
                                                            <td valign="top" style="width:22;" class="listItem" align="center" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <img runat="server" src="~/images/16x16_cheque.png" border="0"/>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <%#DataBinder.Eval(Container.DataItem, "PaymentDate", "{0:MM/dd/yy}")%>&nbsp;
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>">
                                                                <%#DataBinder.Eval(Container.DataItem, "FeeRegisterEntryTypeName")%>
                                                            </td>
                                                            <td valign="top" style="padding-top:5;" class="listItem" rowspan="<%#CType(Container.DataItem, RegisterPayment).Deposits.Count%>" align="right" style="color:rgb(0,139,0);">
                                                                <%#DataBinder.Eval(Container.DataItem, "Amount", "{0:c}")%>&nbsp;
                                                            </td>
                                                            <asp:repeater runat="server" datasource="<%# CType(Container.DataItem, RegisterPayment).Deposits%>">
                                                                <itemtemplate>
                                                                    <%#IIf(Container.ItemIndex = 0, "", "</tr><tr " & IIf(DataBinder.Eval(Container.DataItem, "Voided") Or DataBinder.Eval(Container.DataItem, "Bounced"), "style=""background-color:rgb(255,230,230);""", "") & ">")%>
                                                                    <td style="padding-left:10;height:24;" class="listItem">
                                                                        <%#IIf(RegisterID = CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterID, "This " & CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName, "<div>" & CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterEntryTypeName & "</div>")%>
                                                                    </td>
                                                                    <td class="listItem">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).DepositRegisterTransactionDate.ToString("MM/dd/yy")%>&nbsp;
                                                                    </td>
                                                                    <td class="listItem" style="color:rgb(0,139,0);" align="right">
                                                                        <%#CType(Container.DataItem, RegisterPaymentDeposit).Amount.ToString("c")%>&nbsp;
                                                                    </td>
                                                                </itemtemplate> 
                                                            </asp:repeater>
                                                        </tr>
			                                        </ItemTemplate>
		                                        </asp:Repeater>
                                            </table><br />
	                                        <div nowrap="true" style="text-align:right;">Left&nbsp;for&nbsp;future&nbsp;payments:&nbsp;&nbsp;<asp:label style="color:rgb(0,149,0);" runat="server" id="lblCreditRemaining"></asp:label></div>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <asp:dropdownlist runat="server" id="cboCreditors" style="display:none;"></asp:dropdownlist>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:TextBox runat="server" id="txtBounce" style="display:none;"></asp:TextBox>
    <asp:CheckBox runat="server" id="chkBounceCollectFee" style="display:none;"></asp:CheckBox>
    <asp:TextBox runat="server" id="txtVoid" style="display:none;"></asp:TextBox>
    <asp:TextBox runat="server" id="txtHold" style="display:none;"></asp:TextBox>
    <asp:TextBox runat="server" id="txtClear" style="display:none;"></asp:TextBox>

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkBounce"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkVoid"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkHold"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkClear"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>

</body>

</asp:Panel></asp:Content>