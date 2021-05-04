<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="billing_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
                loadPortlets();
                loadButtons();

            });
        }
    
    </script>
    <script type="text/javascript">
    //utils
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
       

    </script>
    <script type="text/javascript">
        function InvoiceAction(invid, type) {
            switch (type) {
                case 'create':
                    window.location = 'invoice.aspx?t=add&invid=' + invid;
                    break;
                case 'view':
                    window.location = 'invoice.aspx?t=edit&invid=' + invid;
                    break;
                case 'payment':
                    window.location = 'payments.aspx?invid=' + invid;
                    break;
                case 'statements':
                    window.location = 'statements.aspx?invid=' + invid;
                    break;
                case 'print':
                    break;
                default:
                    break;
            }
            
            return false;
        }
          
    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float: left">
        <h2>
            Billing Dashboard</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gvInvoices" runat="server" AllowPaging="True" AllowSorting="True"
                        AutoGenerateColumns="False" DataKeyNames="BillingInvoiceID" DataSourceID="dsInvoices"
                        Width="100%" PageSize="20" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                        BorderWidth="1px" CellPadding="1" ForeColor="Black" GridLines="Vertical">
                        <RowStyle VerticalAlign="Top" />
                        <AlternatingRowStyle BackColor="#F7F7DE" />
                        <HeaderStyle Height="30" />
                         <FooterStyle  CssClass="footerRow" Height="30" BackColor="DarkGray" Font-Bold="true" />
                        <Columns>
                            <asp:BoundField DataField="BillingInvoiceID" HeaderText="Invoice #" InsertVisible="False"
                                ReadOnly="True" SortExpression="BillingInvoiceID" Visible="true">
                                <HeaderStyle HorizontalAlign="Center" Width="75px"/>
                                <ItemStyle HorizontalAlign="Center" Width="75px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created">
                                <HeaderStyle HorizontalAlign="Left" Width="150px" />
                                <ItemStyle HorizontalAlign="Left"  Width="150px"/>
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                <ItemTemplate>
                                    <span style="font-weight:bold; font-size:1em"><asp:Label ID="Label1" runat="server" Text='<%# Bind("Name") %>'>&nbsp;</asp:Label></span><br />
                                    <asp:Label ID="Label2" runat="server" Font-Italic="true" Font-Size="10px" Text='<%# Bind("Description") %>'></asp:Label>
                                </ItemTemplate>
                                
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>
                           
                            <asp:BoundField DataField="CreatedByName" HeaderText="Created By " ReadOnly="True"
                                SortExpression="CreatedByName">
                                <HeaderStyle HorizontalAlign="Left"  Width="175px"/>
                                <ItemStyle HorizontalAlign="Left"  Width="175px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="InvoiceAmount" HeaderText="Invoice Amount" ReadOnly="True"
                                SortExpression="InvoiceAmount" DataFormatString="{0:c2}">
                                <HeaderStyle HorizontalAlign="Right" Width="125px"/>
                                <ItemStyle HorizontalAlign="Right" Width="125px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="LastDeliveryDate" HeaderText="Last Delivery Date" SortExpression="LastDeliveryDate">
                                <HeaderStyle HorizontalAlign="Left" Width="150px" />
                                <ItemStyle HorizontalAlign="Left"  Width="150px"/>
                            </asp:BoundField>
                             <asp:BoundField DataField="DueDate" HeaderText="DueDate" SortExpression="DueDate">
                                <HeaderStyle HorizontalAlign="Left" Width="150px" />
                                <ItemStyle HorizontalAlign="Left"  Width="150px"/>
                            </asp:BoundField>
                             <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status">
                                <HeaderStyle HorizontalAlign="Center" Width="100px"/>
                                <ItemStyle HorizontalAlign="Center" Width="100px"/>
                            </asp:BoundField>
                             <asp:TemplateField HeaderText="Action" >
                                <ItemTemplate>
                                <asp:DropDownList ID="ddlActions" runat="server">
                                <asp:ListItem Text=""  Value=""/>
                                <asp:ListItem Text="Receive Payment"  Value="payment"/>
                                <asp:ListItem Text="Print" Value="print" />
                                <asp:ListItem Text="Send" Value="send" />
                                <asp:ListItem Text="View" Value="view" />
                                </asp:DropDownList>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" Width="75px"/>
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
                        SelectCommand="stp_billing_getinvoices" SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                        <SelectParameters>
                            <asp:Parameter Name="statusid" Type="Int32" ConvertEmptyStringToNull="true" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <div style="padding:15px">
                    <asp:LinkButton ID="lnkCreateInvoice" runat="server" Text="Create Invoice" CssClass="jqButton" 
                    OnClientClick="return InvoiceAction(-1,'create');" />
                    </div>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    
</asp:Content>
