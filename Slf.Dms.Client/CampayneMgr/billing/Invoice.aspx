<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="Invoice.aspx.vb" Inherits="billing_Invoice" %>

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
            });
        }
    
    </script>
    <script type="text/javascript">
    //utils
     function refresh() { 
            <%= Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %> ;
        }
    function loadDates(){
      $("#<%= txtInvoiceDate.ClientID %>,#<%= txtDueDate.ClientID %>").datepicker();
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

        function CalcLineTotal(elem, boolRecalcInvoice){
            updateRowTotal(elem.parentElement.parentElement);
            if (boolRecalcInvoice ==true){
                CalcInvoiceTotal();
            }
            return false;
        }
        function updateRowTotal(brow){
            var qty = brow.childNodes[3].firstChild.value;
            var price = brow.childNodes[4].childNodes[1].value;
            var tot = brow.childNodes[5].firstChild;
            var rowtot = qty*price;
            tot.innerHTML = '$' + rowtot.toFixed(2);
        }

        function CalcInvoiceTotal(){
            var invTotal = 0;
            var fRow = null;

            $('#<%=gvInvoices.ClientID%>')
                .find('tr')
                .each(function(row) {
                    if (this.className !='ui-state-highlight ui-corner-all'){
                        var tot = this.cells[5].innerText;//this.cells[5].innerHTML;
                        tot = tot.replace('$','');
                        if (tot>0){
                            invTotal += parseFloat(tot);
                        }
                    }else{
                        fRow = this;
                    }
                }); 
             
             fRow.cells[1].innerText ='$' +  invTotal.toFixed(2);

        }
    function updateRowData(id,rowData){
        var bRow = rowData.parentElement.parentElement;
        var campaignid = bRow.previousSibling.previousSibling.previousSibling.previousSibling.previousSibling.previousSibling.children[0].value;
        var description = bRow.previousSibling.previousSibling.previousSibling.previousSibling.previousSibling.children[0].value;
        var notes = bRow.previousSibling.previousSibling.previousSibling.previousSibling.children[0].value;
        var quantity = bRow.previousSibling.previousSibling.previousSibling.children[0].value;
        var price =  bRow.previousSibling.previousSibling.children[0].value;
        var total = bRow.previousSibling.children[0].innerHTML;

        var dArray = "{";
        dArray += "'invoiceid': '" + <%= InvoiceID %> + "',";
        dArray += "'billinginvoicelineid': '" + id + "',";
        dArray += "'campaignid': '" + campaignid + "',";
        dArray += "'description': '" + description + "',";
        dArray += "'notes': '" + notes + "',";
        dArray += "'quantity': '" + quantity + "',";
        dArray += "'price': '" + price + "',";
        dArray += "'total': '" + total + "'";
        dArray += "}";

        if (campaignid==''){
            showToast('You must select a product first!','error', true)
            return false;
        }

         $.ajax({
            type: "POST",
            url: "invoice.aspx/InsertUpdateInvoiceLine",
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
    function DeleteRowData(id){
        var dArray = "{";
        dArray += "'lineid': '" + id + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "invoice.aspx/DeleteLineItem",
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
    function getCampaignPrice(elem){
        var cid = elem.value;
        var bRow = elem.parentElement.parentElement;
        var priceBox = bRow.children[4].children[0];

        var dArray = "{";
        dArray += "'campaignid': '" + cid + "'";
        dArray += "}";
        $.ajax({
            type: "POST",
            url: "invoice.aspx/GetCampaignPrice",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                 priceBox.value = response.d;
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    function SaveInvoice(){

        var invoiceid = '<%=InvoiceID %>';
        var name = escape($('#<%=txtInvName.ClientID%>').val());
        var descr = escape($('#<%=txtInvDescr.ClientID%>').val());
        var customerid = $('#<%=ddlCustomers.ClientID%>').val();
        var statusid = $('#<%=ddlStatus.ClientID%>').val();
        var invdate = $('#<%=txtInvoiceDate.ClientID%>').val();
        var duedate = $('#<%=txtDueDate.ClientID%>').val();
        var msg = escape($('#<%=txtCustomerMsg.ClientID%>').val());
        var memo = escape($('#<%=txtMemo.ClientID%>').val());
        var printinvoice = $('#<%=chkToBePrinted.ClientID%>').is(':checked');
        var sendinvoice = $('#<%=chkToBeSent.ClientID%>').is(':checked'); 

        var dArray = "{";
        dArray += "'invoiceid': '" + invoiceid + "',";
        dArray += "'name': '" + name + "',";
        dArray += "'descr': '" + descr + "',";
        dArray += "'customerid': '" + customerid + "',";
        dArray += "'statusid': '" + statusid + "',";
        dArray += "'invdate': '" + invdate + "',";
        dArray += "'duedate': '" + duedate + "',";
        dArray += "'msg': '" + msg + "',";
        dArray += "'memo': '" + memo + "',";
        dArray += "'printinvoice': '" + printinvoice + "',";
        dArray += "'sendinvoice': '" + sendinvoice + "'";
        dArray += "}";

        $.ajax({
            type: "POST",
            url: "invoice.aspx/SaveInvoice",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                 showToast(response.d,'success',false);
                 refresh
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    function PrintInvoice(){

        var invoiceid = '<%=InvoiceID %>';
        var boolpreview = 'false';

        var dArray = "{";
        dArray += "'invoiceid': '" + invoiceid + "',";
        dArray += "'boolpreview': '" + boolpreview + "'";
        dArray += "}";

        $.ajax({
            type: "POST",
            url: "invoice.aspx/PrintInvoice",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                 showToast(response.d,'success',false);
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    function SendInvoice(){

        var invoiceid = '<%=InvoiceID %>';
        var customerid = '-1';

        var dArray = "{";
        dArray += "'invoiceid': '" + invoiceid + "',";
        dArray += "'customerid': '" + customerid + "'";
        dArray += "}";

        $.ajax({
            type: "POST",
            url: "invoice.aspx/SendInvoice",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                 showToast(response.d,'success', false);
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    function PreviewInvoice(){

        var invoiceid = '<%=InvoiceID %>';
        var boolpreview = 'true';

        var dArray = "{";
        dArray += "'invoiceid': '" + invoiceid + "',";
        dArray += "'boolpreview': '" + boolpreview + "'";
        dArray += "}";

        $.ajax({
            type: "POST",
            url: "invoice.aspx/PrintInvoice",
            data: dArray,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            success: function(response) {
                 showToast(response.d,'success',false);
            },
            error: function(response) {
                showStickyToast(response.responseText, 'showErrorToast');
            }
        });

        return false;
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <h2>
            Create/Edit Invoice</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <div>
                        <div class="portlet">
                            <table style="width: 100%" border="0">
                            
                                <tr>
                                    <td class="ui-widget-header">
                                    
                                        Customer:&nbsp;
                                        <asp:DropDownList ID="ddlCustomers" runat="server" AppendDataBoundItems="True" DataSourceID="dsCustomers"
                                            DataTextField="Customer" DataValueField="CustomerID" AutoPostBack="true">
                                            <asp:ListItem Text="-Select Customer-" Value="" />
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="dsCustomers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                            SelectCommand="stp_billing_getCustomers" SelectCommandType="StoredProcedure" />
                                     
                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="float: left; width: 350px;" class="ui-widget">
                                            <div class="ui-widget-header">
                                                Bill To</div>
                                            <div class="ui-widget-content">
                                                <asp:TextBox ID="txtBilling" runat="server" TextMode="MultiLine" Rows="6" Width="98%" /></div>
                                        </div>
                                        <div style="float: right; width: 250px" class="ui-widget">
                                        <div class="ui-widget-content">
                                            <table border="0" style="width: 100%">
                                                <tr>
                                                    <td align="left" class="ui-widget-header">
                                                        Invoice Name
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtInvName" runat="server" Width="98%" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" class="ui-widget-header">
                                                        Invoice Description
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtInvDescr" runat="server" Width="98%" Rows="2" TextMode="MultiLine" />
                                                    </td>
                                                </tr>
                                            </table>
                                            </div>
                                        </div>

                                        <div style="float: right; width: 250px; margin-right:25px;" class="ui-widget">
                                            <div class="ui-widget-content">
                                                <table border="0" style="width: 100%">
                                                    <tr >
                                                        <td align="left" class="ui-widget-header">
                                                            Status
                                                        </td>
                                                        <td align="left" class="ui-widget-header">
                                                            Invoice Date
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        
                                                        <td align="left">
                                                            <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="false" DataTextField="Status"
                                                                DataValueField="InvoiceStatusID" DataSourceID="dsStatus" AppendDataBoundItems="true"
                                                                Width="100%">
                                                                <asp:ListItem Text="" />
                                                            </asp:DropDownList>
                                                            <asp:SqlDataSource ID="dsStatus" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                                SelectCommand="select InvoiceStatusID, Status from tblBilling_InvoiceStatus" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtInvoiceDate" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        
                                                        <td align="left" class="ui-widget-header">
                                                            Terms
                                                        </td>
                                                        <td align="left" class="ui-widget-header">
                                                            Due Date
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        
                                                        <td>
                                                            <asp:DropDownList ID="ddlTerms" runat="server" AutoPostBack="true">
                                                                <asp:ListItem Text="Net15" Value="15" />
                                                                <asp:ListItem Text="Net30" Value="30" />
                                                                <asp:ListItem Text="Upon Receipt" Value="0" />
                                                                <asp:ListItem Text="Custom" Value="-1" />
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtDueDate" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>



                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ui-widget-header">
                                        New Charges:
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvInvoices" runat="server" AllowPaging="True" AllowSorting="True"
                                            AutoGenerateColumns="False" DataSourceID="dsInvoices" Width="100%" PageSize="20"
                                            BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                            CellPadding="1" ForeColor="Black" GridLines="Vertical" ShowFooter="True">
                                            <AlternatingRowStyle BackColor="#F7F7DE" />
                                            <HeaderStyle Height="30" />
                                            <FooterStyle CssClass="footerRow" Height="30" BackColor="DarkGray" Font-Bold="true"/>
                                            <Columns>
                                                <asp:BoundField DataField="BillingInvoiceLineID" HeaderText="BillingInvoiceLineID"
                                                    ReadOnly="True" SortExpression="BillingInvoiceLineID" Visible="False" />
                                                <asp:BoundField DataField="BillingInvoiceID" HeaderText="BillingInvoiceID" ReadOnly="True"
                                                    SortExpression="BillingInvoiceID" Visible="False" />
                                                <asp:BoundField DataField="CampaignID" HeaderText="CampaignID" ReadOnly="True" SortExpression="CampaignID"
                                                    Visible="False" />
                                                <asp:TemplateField HeaderText="Product" SortExpression="Campaign">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlCampaigns" runat="server" AppendDataBoundItems="true" DataSourceID="dsCampaigns"
                                                            SelectedValue='<%# Bind("CampaignID") %>' DataTextField="Campaign" DataValueField="CampaignID"
                                                            Width="99%"  Height="22" >
                                                            <asp:ListItem Text="" Value="-1" />
                                                        </asp:DropDownList>
                                                        
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:DropDownList ID="ddlCampaigns" runat="server" AppendDataBoundItems="true" DataSourceID="dsCampaigns"
                                                            SelectedValue='<%# Bind("CampaignID") %>' DataTextField="Campaign" DataValueField="CampaignID"
                                                            Width="99%"  Height="22" >
                                                            <asp:ListItem Text="" Value="-1" />
                                                        </asp:DropDownList>
                                                        
                                                    </FooterTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" Width="300" />
                                                    <ItemStyle HorizontalAlign="Left" Width="300" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDescr" runat="server" Width="97%" Height="15"  Text='<%# Bind("Description") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:TextBox ID="txtDescr" runat="server" Width="97%" Height="15"  Text='<%# Bind("Description") %>'></asp:TextBox>
                                                    </FooterTemplate>
                                                    <HeaderStyle HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Notes" SortExpression="Notes">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtNotes" runat="server" Width="97%" Height="15"  Text='<%# Bind("Notes") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:TextBox ID="txtNotes" runat="server" Width="97%" Height="15"  Text='<%# Bind("Notes") %>'></asp:TextBox>
                                                    </FooterTemplate>
                                                     <HeaderStyle HorizontalAlign="Left" Width="200" />
                                                    <ItemStyle HorizontalAlign="Left" Width="200" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtQuantity" runat="server" Height="15" Width="45" Text='<%# Bind("Quantity") %>' 
                                                        style='text-align:center'/>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:TextBox ID="txtQuantity" runat="server" Height="15" Width="45" Text='<%# Bind("Quantity") %>' 
                                                        style='text-align:Center'/>
                                                    </FooterTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" Width="75" />
                                                    <ItemStyle HorizontalAlign="Center" Width="75" />
                                                    <FooterStyle HorizontalAlign="Center" Width="75" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Price" SortExpression="ItemPrice">
                                                    <FooterTemplate>
                                                        $<asp:TextBox ID="txtPrice" runat="server" Text="0.00" Width="55" Height="15" style='text-align:right'></asp:TextBox>
                                                    </FooterTemplate>
                                                    <ItemTemplate>
                                                        $<asp:TextBox ID="txtPrice" runat="server" Text='<%# Bind("ItemPrice", "{0:n2}") %>' Width="55" 
                                                        Height="15" style='text-align:right'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Right" Width="75px" />
                                                    <ItemStyle HorizontalAlign="Right" Width="75px" />
                                                    <FooterStyle HorizontalAlign="Right" Width="75px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total" SortExpression="Total">
                                                    <FooterTemplate>
                                                        <asp:Label ID="lblTotal" runat="server" Text="0.00"></asp:Label>
                                                    </FooterTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Total", "{0:c2}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Right" Width="125px" />
                                                    <ItemStyle HorizontalAlign="Right" Width="125px" />
                                                    <FooterStyle HorizontalAlign="Right" Width="125px" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Created" HeaderText="Created" ReadOnly="True" SortExpression="Created"
                                                    Visible="False" />
                                                <asp:BoundField DataField="CreatedBy" HeaderText="CreatedBy" ReadOnly="True" SortExpression="CreatedBy"
                                                    Visible="False" />
                                                <asp:BoundField DataField="CreatedByName" HeaderText="CreatedByName" ReadOnly="True"
                                                    SortExpression="CreatedByName" Visible="False" />
                                                <asp:BoundField DataField="LastModified" HeaderText="LastModified" ReadOnly="True"
                                                    SortExpression="LastModified" Visible="False" />
                                                <asp:BoundField DataField="LastModifiedBy" HeaderText="LastModifiedBy" ReadOnly="True"
                                                    SortExpression="LastModifiedBy" Visible="False" />
                                                <asp:BoundField DataField="LastModifiedByName" HeaderText="LastModifiedByName" ReadOnly="True"
                                                    SortExpression="LastModifiedByName" Visible="False" />
                                                <asp:BoundField DataField="Deleted" HeaderText="Deleted" ReadOnly="True" SortExpression="Deleted"
                                                    Visible="False" />
                                                <asp:BoundField DataField="DeletedBy" HeaderText="DeletedBy" ReadOnly="True" SortExpression="DeletedBy"
                                                    Visible="False" />
                                                <asp:BoundField DataField="DeletedByName" HeaderText="DeletedByName" ReadOnly="True"
                                                    SortExpression="DeletedByName" Visible="False" />
                                                <asp:TemplateField HeaderText="" SortExpression="">
                                                    <ItemTemplate>
                                                        <small>
                                                            <asp:LinkButton ID="btnSave" runat="server" CssClass="jqSaveButton" 
                                                            Text="Save" ToolTip="Save Changes to Current Item." />
                                                            <asp:LinkButton ID="btnDelete" runat="server" CssClass="jqDeleteButton"
                                                             Text="Delete" ToolTip="Delete Current Line Item" />
                                                            <div id="divLoading" />
                                                        </small>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        <small>
                                                            <asp:LinkButton ID="btnSave" runat="server" CssClass="jqAddButton" Text="Save" 
                                                             ToolTip="Add New Line Item."/>
                                                            <div id="divLoading" />
                                                        </small>
                                                    </FooterTemplate>
                                                    <HeaderStyle HorizontalAlign="Center" Width="75" />
                                                    <ItemStyle HorizontalAlign="Center" Width="75" />
                                                    <FooterStyle HorizontalAlign="Center" Width="75" />
                                                </asp:TemplateField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                                    No Invoices
                                                </div>
                                            </EmptyDataTemplate>
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <PagerTemplate>
                                                <div id="pager" style="background-color: #DCDCDC">
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td style="padding-left: 10px; text-align: center">
                                                                <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                                    ID="btnFirst" CssClass="jqFirstButton" />
                                                                <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                                    ID="btnPrevious" CssClass="jqPrevButton" />
                                                                Page
                                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="true" />
                                                                of
                                                                <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                                                <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                                    ID="btnNext" CssClass="jqNextButton" />
                                                                <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                                    ID="btnLast" CssClass="jqLastButton" />
                                                            </td>
                                                            <td align="right">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </PagerTemplate>
                                        </asp:GridView>
                                       
                                        <asp:SqlDataSource ID="dsInvoices" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                            SelectCommand="stp_billing_getInvoiceLines" SelectCommandType="StoredProcedure"
                                            CancelSelectOnNullParameter="false">
                                            <SelectParameters>
                                                <asp:Parameter Name="invoiceid" Type="Int32" DefaultValue="-1" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" >
                                        <div class="ui-widget" style="float: left; width: 30%">
                                            <div style="padding: 0px 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
                                                <p>
                                                    <span style="margin-right: 0.3em; float: left;" class="ui-icon ui-icon-info"></span>
                                                    <strong>Customer Message</strong>
                                                </p>
                                                <p>
                                                    <asp:TextBox ID="txtCustomerMsg" runat="server" TextMode="MultiLine" Rows="4" Width="98%" /></p>
                                            </div>
                                        </div>
                                        <div style="float: left; width: 25px">
                                        </div>
                                        <div class="ui-widget" style="float: left; width: 30%">
                                            <div style="padding: 0px 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
                                                <p>
                                                    <span style="margin-right: 0.3em; float: left;" class="ui-icon ui-icon-info"></span>
                                                    <strong>Memo:&nbsp;</strong>
                                                    </p>
                                                    <p><asp:TextBox ID="txtMemo" runat="server" TextMode="SingleLine" Width="97%" /></p>
                                                <p>
                                                    Type a summary of this transaction to appear on the customer's next statement.</p>
                                            </div>
                                        </div>
                                        <div class="ui-widget" style="float: right; width: 175px">
                                            <div style="padding: 0px 0.7em; margin-top: 20px;" class="ui-state-active ui-corner-all">
                                                <p>
                                                    <span style="margin-right: 0.3em; float: left;" class="ui-icon ui-icon-info"></span>
                                                    <strong> Delivery Information</strong>
                                                    </p>
                                                <p>
                                                    <asp:CheckBox ID="chkToBePrinted" runat="server" Text="To be printed" /></p>
                                                <p>
                                                    <asp:CheckBox ID="chkToBeSent" runat="server" Text="To be sent" /></p>
                                            </div>
                                        </div>
                                        
                                    </td>
                                </tr>
                                
                            </table>
                            <br />
                            <div class="btnBar">
                                <asp:LinkButton ID="lnkSave" runat="server" CssClass="jqButton" Text="Save" OnClientClick="return SaveInvoice();" />
                                <asp:LinkButton ID="lmkPrint" runat="server" CssClass="jqButton" Text="Print" OnClientClick="return PrintInvoice();"/>
                                <asp:LinkButton ID="lnkSend" runat="server" CssClass="jqButton" Text="Send" OnClientClick="return SendInvoice();"/>
                                <asp:LinkButton ID="lnkPreview" runat="server" CssClass="jqButton" Text="Preview" OnClientClick="return PreviewInvoice();"/>
                                <asp:LinkButton ID="lnkRecurring" runat="server" CssClass="jqButton" Text="Make Recurring" OnClientClick="alert('Not Implemented Yet!');return false;"/>
                                <a href="Default.aspx" class="jqButton">Cancel</a>
                            </div>
                        </div>
                    </div>
                    
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <asp:SqlDataSource ID="dsCampaigns" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                                            SelectCommand="select CampaignID,Campaign from vw_Campaigns  where Cost > 0 order by Campaign" />
</asp:Content>
