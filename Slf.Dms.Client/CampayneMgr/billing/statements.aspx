<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="statements.aspx.vb" Inherits="billing_statements" %>

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
    function loadDates(){
        $("#<%= txtStart.ClientID %>,#<%= txtEnd.ClientID %>").datepicker({
            onClose: function(dateText, inst) { 
                refresh();
            }
        });
    }
    function loadPortlets(){
     $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
    }
    function loadButtons(){
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
          function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtStart.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtEnd.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }
         function checkAll(chk_SelectAll) {
            var frm = document.forms[0];
            var chkState = chk_SelectAll.checked;

            for (i = 0; i < frm.length; i++) {
                var el = frm.elements[i];
                if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                    el.checked = chkState;
                }
            }
        }
        function PreviewStatement(invid){
            showToast(invid,'success',false);
            return false;
        }
        function EditDeliveryMethod(invid){
            showToast(invid,'success',false);
            return false;
        }
        function CreateSendStatements(){
            var createIDs =  Array();
            var gridClientID = document.getElementById('<%= gvStatements.ClientID %>');
            $('input:checkbox[id$=chk_select]:checked', gridClientID).each(function (item, index) { 
                 var id = $(this).next('input:hidden[id$=hdnID]').val(); 
                 createIDs.push(id);
            }); 

            var dArray = "{";
            dArray += "'ids': '" + createIDs + "'";
            dArray += "}";
            $.ajax({
                type: "POST",
                url: "statements.aspx/CreateSendStatements",
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <h2>
            Statements</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <div class="ui-widget">
                        <div class="ui-widget-header" style="height: 30px">
                            Statement Criteria</div>
                        <div class="ui-widget-content">
                            <table style="float: left; width: 150px;">
                                <tr class="ui-widget-header">
                                    <td rowspan="2" style="width: 75px;padding:0px 5px 0px 5px">
                                        Statement Period: &nbsp;
                                    </td>
                                    <td align="center">
                                        Select Period
                                    </td>
                                    <td align="center">
                                        Period Start
                                    </td>
                                    <td align="center">
                                        Period End
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="ddlPeriodType" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
                                            <asp:ListItem Text="" />
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtStart" runat="server" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEnd" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <br style="clear: both" />
                    <div class="ui-widget" style="padding: 10px;">
                        <asp:GridView ID="gvStatements" runat="server" DataSourceID="dsStatements" Width="100%"
                            AutoGenerateColumns="False" DataKeyNames="BillingInvoiceID">
                            <HeaderStyle Height="30" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);"  />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <input type="checkbox" runat="server" id="chk_select" />
                                        <asp:HiddenField ID="hdnID" runat="server" Value='<%#eval("BillingInvoiceID") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Width="25" />
                                    <ItemStyle HorizontalAlign="Center" Width="25" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customer">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCustomer" runat="server" Text='<%#eval("Customer") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <small>
                                            <asp:LinkButton ID="lnkPreview" runat="server" Text="Preview" CssClass="jqButton" />
                                        </small>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="center" Width="70" />
                                    <ItemStyle HorizontalAlign="center" Width="70" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Invoice Amt">
                                    <ItemTemplate>
                                        <asp:Label ID="lblInvoiceAmount" runat="server" Text='<%# eval("InvoiceAmount", "{0:c2}") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="right" Width="115" />
                                    <ItemStyle HorizontalAlign="right" Width="115" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Paid">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPaid" runat="server" Text='<%# eval("Paid", "{0:c2}") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="right" Width="100" />
                                    <ItemStyle HorizontalAlign="right" Width="100" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Balance Due">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDue" runat="server" Text='<%# eval("Due", "{0:c2}") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="right" Width="115" />
                                    <ItemStyle HorizontalAlign="right" Width="115" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkPrint" runat="server" Checked='<%#eval("PrintInvoice") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="center" Width="50" />
                                    <ItemStyle HorizontalAlign="center" Width="50" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Electronic Delivery Method">
                                    <ItemTemplate>
                                        <small>
                                            <asp:LinkButton ID="lnkEdit" runat="server" Text="Edit" CssClass="jqButton" />
                                        </small>
                                        <asp:Label ID="lblDelivery" runat="server" Text="None" />
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="ui-state-highlight ui-corner-all" style="padding: 10px; margin: 10px;">
                                    No Statements
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
                        <asp:SqlDataSource ID="dsStatements" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                            CancelSelectOnNullParameter="False" SelectCommand="stp_billing_getStatements"
                            SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:Parameter Name="start" Type="DateTime" />
                                <asp:Parameter Name="end" Type="DateTime" />
                                <asp:Parameter Name="amount" Type="Double" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div>
                    <asp:LinkButton CssClass="jqButton" style="float:left" ID="lnkViewStatementList" runat="server"  Text="Statement List" />
                    <asp:LinkButton CssClass="jqButton" style="float:right" ID="lnkCreateSend" runat="server"  Text="Create/Send Selected" OnClientClick="return CreateSendStatements();" />

                    <div>
                    </div>
                    
                    </div>
                    
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
