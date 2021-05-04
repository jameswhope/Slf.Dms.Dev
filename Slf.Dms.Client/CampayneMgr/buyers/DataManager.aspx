<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="DataManager.aspx.vb" Inherits="admin_DataManager" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .jqSaveButton
        {
        }
        .currRow
        {
            background-color: blue;
            cursor: pointer;
        }
        fieldset
        {
            border: solid 1px #f6a828;
        }
    </style>

    <script type="text/javascript">
        //utils
        function refresh() {
            <%=Page.ClientScript.GetPostBackEventReference(btnRefresh, Nothing) %>;
        }
    </script>

    <script type="text/javascript">
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);

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
                $(".jqSaveButton").button({
                    icons: {
                        primary: "ui-icon-disk"
                    },
                    text: true
                });
                $(".jqSaveButtonNoText").button({
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
                    width: 810,
                    close: function() {
                        refresh();
                    }
                });
                $("#dialog-contractpop").dialog({
                    autoOpen: false,
                    modal: true,
                    height: 630,
                    width: 900,
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

            $("#dialog-buyerpop").dialog("option", "title", buyername);
        
            $("#dialog-buyerpop").html('<iframe id="modalIframeId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open");
            $("#modalIframeId").attr("src", "../dialogs/buyerdialog.aspx?bid=" + buyerid);
            return false;
        }
        function showContractDialog(bxid, contractname) {
            if (bxid > 0)
                contractname = 'Contract ID#' + bxid + ' - ' + contractname;
            else
                contractname = 'New Contract';

            $("#dialog-contractpop").dialog("option", "title", contractname);
                                
            $("#dialog:ui-dialog").dialog("destroy");
            $("#dialog-contractpop").html(loadingImg + '<iframe id="modalIframeContractId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="no" />').dialog("open");
            $("#modalIframeContractId").hide();
            $("#modalIframeContractId").load(function () {
                $("#loadingDiv").hide();
                $("#modalIframeContractId").show();
            });

            $("#modalIframeContractId").attr("src", "../dialogs/contractdialog.aspx?bxid=" + bxid);

            return false;
        }
    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float:left">
                <h2>Buyer Contracts</h2>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlVertical1" runat="server" AppendDataBoundItems="true" Style="margin-right: 10px"
                                DataSourceID="dsVerticals" DataTextField="Name" DataValueField="VerticalID">
                                <asp:ListItem Text="All Verticals" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="dsVerticals" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="SELECT [VerticalID], c.Category + ' - ' + v.Name [Name] FROM [tblVertical] v join tblCategory c on c.CategoryID = v.CategoryID ORDER BY [Name]">
                            </asp:SqlDataSource>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCallCenter1" runat="server" Style="margin-right: 10px">
                                <asp:ListItem Text="All Contracts" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="Call Center Only" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Data Contracts Only" Value="0" Selected="True"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlActive" runat="server" Style="margin-right: 10px">
                                <asp:ListItem Text="Show All" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="Active Only" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqButton" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvBuyerContracts" runat="server" AutoGenerateColumns="False" DataSourceID="odsBuyerContracts"
                        DataKeyNames="BuyerID,BuyerOfferXrefID" Width="100%"
                        BorderStyle="None" BorderWidth="0px" CellPadding="0" CellSpacing="0" ForeColor="Black"
                        GridLines="None" AllowSorting="True" AllowPaging="true" PageSize="22" AlternatingRowStyle-CssClass="altrow">
                        <HeaderStyle ForeColor="White" />
                        <Columns>
                            <asp:BoundField DataField="BuyerOfferXrefID" HeaderText="ID" SortExpression="BuyerOfferXrefID">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Buyer" SortExpression="Buyer">
                                <ItemTemplate>
                                    <asp:Image ID="imgBuyerActive" runat="server" ImageUrl="" />
                                    <asp:Label ID="lblBuyer" runat="server" Text='<%# eval("Buyer") %>' Font-Underline="true"
                                        Style="cursor: pointer"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contract" SortExpression="ContractName">
                                <ItemTemplate>
                                    <asp:Image ID="imgContractActive" runat="server" ImageUrl="" />
                                    <asp:LinkButton ID="lnkShowContract" runat="server" Text='<%# eval("ContractName") %>'
                                        Font-Underline="true" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="ui-widget-header" HorizontalAlign="Left" />
                                <ItemStyle CssClass="griditem2" HorizontalAlign="Left" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Vertical" HeaderText="Vertical" SortExpression="Vertical">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Offer" HeaderText="Offer" SortExpression="Offer">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Weight" HeaderText="Weight" SortExpression="Weight">
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Center" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DailyCap" HeaderText="Daily Cap" SortExpression="DailyCap">
                                <HeaderStyle HorizontalAlign="Center" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="Center" CssClass="griditem2" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Created" HeaderText="Created" SortExpression="Created"
                                DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="ui-widget-header" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" />
                            </asp:BoundField>
                        </Columns>
                        <PagerTemplate>
                            <div id="pager" style="background-color: #DCDCDC">
                                <table style="width: 100%">
                                    <tr valign="bottom">
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
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </PagerTemplate>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="odsBuyerContracts" runat="server" SelectMethod="getBuyerContracts"
                        TypeName="BuyerHelper+BuyerContractObject" OldValuesParameterFormatString="original_{0}">
                        <SelectParameters>
                            <asp:Parameter Name="sortField" Direction="Input" Type="String" />
                            <asp:Parameter Name="sortOrder" Direction="Input" Type="String" />
                            <asp:Parameter Name="contractactive" Direction="Input" Type="Int16"  DefaultValue="1"  />
                            <asp:Parameter Name="showcallcenter" Direction="Input" Type="Int16"  DefaultValue="0"  />
                            <asp:Parameter Name="verticalid" Direction="Input" Type="Int16"  DefaultValue="-1"  />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
  
    <div id="dialog-contractpop" title="Contract" >
     <div id="loading"></div>
    </div>     
    <div id="dialog-buyerpop" title="Buyer" />     
     
</asp:Content>

