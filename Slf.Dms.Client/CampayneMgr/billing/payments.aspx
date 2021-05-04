<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="payments.aspx.vb" Inherits="billing_payments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                loadPortlets();
                loadButtons();
                loadDates();
                loadDialogs();
            });
        }
    
        //utils
        function loadDates(){
          $("#<%= txtDate.ClientID %>").datepicker();
        }
        function loadPortlets(){
         $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			            .find(".portlet-header")
				            .addClass("ui-widget-header ui-corner-all")
				            .end()
			            .find(".portlet-content");
        }
        function loadButtons(){
            $(".btnBar").buttonset();
            $(".jqButton").button();
            $(".jqAddButton").button({
                icons: {
                    primary: "ui-icon-plusthick"
                },
                text: false
            });
            $(".jqDeleteButton").button({
                icons: {
                    primary: "ui-icon-trash"
                },
                text: false
            });
            $(".jqEditButton").button({
                icons: {
                    primary: "ui-icon-pencil"
                },
                text: false
            });
            $(".jqSaveButton").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: false
            });
            $(".jqSaveButtonWithText").button({
                icons: {
                    primary: "ui-icon-disk"
                },
                text: true
            });
            $(".jqFirstButton").button({
                icons: {
                    primary: "ui-icon-seek-first"
                },
                text: false
            });
            $(".jqPrevButton").button({
                icons: {
                    primary: "ui-icon-seek-prev"
                },
                text: false
            });
            $(".jqNextButton").button({
                icons: {
                    primary: "ui-icon-seek-next"
                },
                text: false
            });
            $(".jqLastButton").button({
                icons: {
                    primary: "ui-icon-seek-end"
                },
                text: false
            });
    }
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }
    function loadDialogs(){
        $("#dialog:ui-dialog").dialog("destroy");
        $("#dialog-select").dialog({
            autoOpen: false,
            modal: true,
            stack: true,
            height: 125,
            width:  230
        });
    }
    function SavePayment(){
        var invid = $('#<%=txtInvoiceNum.ClientID%>').val();
        var custid = $('#<%=ddlCustomers.ClientID%>').val();
        var date = $('#<%=txtDate.ClientID%>').val();
        var amt = $('#<%=txtAmount.ClientID%>').val();
        var pmid = $('#<%=ddlPaymentMethod.ClientID%>').val();
        var refnum = escape($('#<%=txtRefNum.ClientID%>').val());
        var memo = escape($('#<%=txtMemo.ClientID%>').val());
        var errmsg = '';

        if (custid ==''){
             errmsg = 'Customer Missing!<br/>';
        }
        if (amt ==''){
             errmsg += 'Amount Missing!<br/>';
        }
        if (pmid ==''){
             errmsg += 'Payment Method Missing!<br/>';
        }

        if (errmsg != ''){
             showToast('<strong>Please correct the following errors:</strong><br/>' + errmsg,'error',true);
             return;
        }

        var dArray = "{";
        dArray += "'invoiceid': '" + invid + "',";
        dArray += "'customerid': '" + custid + "',";
        dArray += "'paymentdate': '" + date + "',";
        dArray += "'paymentamount': '" + amt + "',";
        dArray += "'paymentmethodid': '" + pmid + "',";
        dArray += "'refnum': '" + refnum + "',";
        dArray += "'memo': '" + memo + "'";
        dArray += "}";
                
        $.ajax({
            type: "POST",
            url: "payments.aspx/SavePayment",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                showToast(response.d,'success',false);
                refresh();
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    function ShowSelect(){
        $('#<%=txtInvoiceNum.ClientID%>').val('');
        $("#dialog-select").dialog("open");
        return false;
    }
    function SelectInvoice(){
        var invid = $('#<%=txtInvoiceNum.ClientID%>').val();
        var dArray = "{";
        dArray += "'invoiceid': '" + invid + "'";
        dArray += "}";
                
        $.ajax({
            type: "POST",
            url: "payments.aspx/FindCustomer",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                var cust = eval('(' + response.d + ')');
                var custid = cust[0];
                var amt = cust[1];

                if (isNaN(custid)) {
                    showToast(custid,'warning',false);
                }else{
                    $('#<%=ddlCustomers.ClientID%>').val(custid);
                    $('#<%=txtAmount.ClientID%>').val(amt);

                }
                


            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });
        $("#dialog-select").dialog("close");
        return false;
    }
    </script>
    <style type="text/css">
        .style1
        {
            width: 70px;
        }
        .style2
        {
        }
        .style3
        {
            width: 114px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <h2>
            Payments</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <div id="dMsg" runat="server">
                    </div>
                    <div style="padding: 50px 150px 50px 150px">
                        <div class="ui-widget" style="width: 100%">
                            <div style="padding: 0px 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
                                <br />
                                <table style="width: 100%;">
                                    <tr>
                                        <td class="style1" align="right">
                                            <strong>Payment</strong>
                                        </td>
                                        <td class="style2">
                                        </td>
                                        <td align="right" class="style3">
                                            <strong>Date:</strong>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDate" runat="server" Enabled="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1" align="right">
                                            Customer:
                                        </td>
                                        <td class="style2">
                                            <asp:DropDownList ID="ddlCustomers" runat="server" AppendDataBoundItems="True" DataSourceID="dsCustomers"
                                                DataTextField="Customer" DataValueField="CustomerID" AutoPostBack="true">
                                                <asp:ListItem Text="-Select Customer-" Value="" />
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="dsCustomers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="stp_billing_getCustomers" SelectCommandType="StoredProcedure" />
                                        </td>
                                        <td align="right" class="style3">
                                            Amount:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtAmount" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1" align="right">
                                        </td>
                                        <td class="style2">
                                            <asp:LinkButton ID="btnSelectByInvoice" runat="server" Text="Select By Invoice #"
                                                CssClass="jqButton" OnClientClick="return ShowSelect();" />
                                        </td>
                                        <td align="right" class="style3">
                                            Payment Method:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlPaymentMethod" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="dsPaymentMethod" DataTextField="Method" DataValueField="PaymentMethodID"
                                                AutoPostBack="true">
                                                <asp:ListItem Text="" Value="" />
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="dsPaymentMethod" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                SelectCommand="SELECT PaymentMethodID, Method FROM tblPaymentMethods" SelectCommandType="Text" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1" align="right">
                                            &nbsp;
                                        </td>
                                        <td class="style2">
                                            &nbsp;
                                        </td>
                                        <td align="right" class="style3">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1" align="right">
                                            &nbsp;
                                        </td>
                                        <td class="style2">
                                            &nbsp;
                                        </td>
                                        <td align="right" class="style3">
                                            Ref#
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtRefNum" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="style1">
                                            &nbsp;
                                        </td>
                                        <td class="style2">
                                            &nbsp;
                                        </td>
                                        <td align="right" class="style3">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td align="right" class="style1">
                                            Memo:
                                        </td>
                                        <td class="style2" colspan="3">
                                            <asp:TextBox ID="txtMemo" runat="server" Width="90%" />
                                            <p>
                                                Type a summary of this transaction to appear on the customers next statement</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="style1">
                                            &nbsp;
                                        </td>
                                        <td class="style2">
                                            &nbsp;
                                        </td>
                                        <td align="right" class="style3">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div class="btnBar" style="float: right">
                            <asp:LinkButton ID="lnkSave" runat="server" CssClass="jqButton" Text="Save" OnClientClick="return SavePayment();" />
                            <a href="Default.aspx" class="jqButton">Cancel</a>
                        </div>
                    </div>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="dialog-select" title="Enter Invoice #">
        <asp:TextBox ID="txtInvoiceNum" runat="server" />
        <asp:LinkButton ID="lnkSelect" runat="server" CssClass="jqButton" Text="Select" OnClientClick="return SelectInvoice();" />
    </div>
</asp:Content>
