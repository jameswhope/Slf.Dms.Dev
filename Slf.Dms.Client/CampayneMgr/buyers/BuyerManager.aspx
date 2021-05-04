<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="BuyerManager.aspx.vb" Inherits="admin_BuyerManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    
    <script type="text/javascript">
    //utils

        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }

    </script>

    <script type="text/javascript">
        //initial jquery stuff
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
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
                $("#dialog:ui-dialog").dialog("destroy");
                $("#dialog-buyerpop").dialog({
                    autoOpen: false,
                    modal: true,
                    height: 680,
                    width: 810 ,
                    close: function() {
                        refresh();
                    }
                });
            });
        }
        function showBuyerDialog(buyerid, buyername) {
            if (buyerid > 0)
                buyername = 'Buyer #' + buyerid + ' - ' + buyername;
            else
                buyername = 'New Buyer';
            var loadingImg = '<img src="../images/ajax-loader.gif" alt="loading..." />';
            $('#dialog-buyerpop').html(loadingImg);
            $("#dialog-buyerpop").dialog("option", "title", buyername);
        
            $("#dialog-buyerpop").html('<iframe id="modalIframeId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open"); 
            $("#modalIframeId").attr("src", "../dialogs/buyerdialog.aspx?bid=" + buyerid); 
            return false; 
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div style="float:left">
        <h2>Buyers</h2>
    </div>
    <div style="clear: both">
    </div>
    <div class="portlet">
        <div class="portlet-content">
            <asp:UpdatePanel ID="upMain" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gvBuyers" runat="server" AllowPaging="True" AllowSorting="True"
                        ShowHeader="true" AutoGenerateColumns="False" DataSourceID="odsBuyers" AlternatingRowStyle-CssClass="altrow"
                        Width="100%" PageSize="22" BorderStyle="None"
                        CellPadding="0" CellSpacing="0" GridLines="None"
                        DataKeyNames="BuyerID">
                        <Columns>
                            <asp:BoundField DataField="BuyerID" HeaderText="ID" SortExpression="BuyerID">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Buyer" SortExpression="Buyer">
                                <ItemTemplate>
                                    <asp:Image ID="imgBuyerActive" runat="server" ImageUrl="" />
                                    <asp:LinkButton ID="lnkEdit" runat="server" Text='<%# eval("Buyer") %>' style="text-decoration:underline"
                                            CommandName="Select" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="AccountManager" HeaderText="Acct Mgr" SortExpression="AccountManager"
                                Visible="true">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" Width="200" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="200" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                Visible="true">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" Width="175" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="175" />
                            </asp:BoundField>
                        </Columns>
                        <EmptyDataTemplate>
                            No Buyers
                        </EmptyDataTemplate>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <PagerTemplate>
                            <div id="pager" style="background-color: #DCDCDC">
                                <table style="width: 100%">
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                ID="btnFirst" CssClass="jqFirstButton" />
                                            <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                ID="btnPrevious" CssClass="jqPrevButton" />
                                            Page
                                            <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" Enabled="false" />
                                            of
                                            <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                ID="btnNext" CssClass="jqNextButton" />
                                            <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                ID="btnLast" CssClass="jqLastButton" />
                                        </td>
                                        <td align="right">
                                            <button class="jqButton" style="float: right!important" onclick="return showBuyerDialog(-1,'');">
                                                Create Buyer</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="odsBuyers" runat="server" SelectMethod="getBuyers" TypeName="BuyerHelper">
                        <SelectParameters>
                            <asp:Parameter Name="sortField" Direction="Input" Type="String" />
                            <asp:Parameter Name="sortOrder" Direction="Input" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="gvBuyers" EventName="PageIndexChanging" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="dialog-buyerpop" title="Buyer" />
 
</asp:Content>
