<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="debtanalysis.aspx.vb" Inherits="reports_debtanalysis" EnableEventValidation="false"  %>

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

        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
        }

        function ValidateFilter(){
            if ($("select[id$='ddlAdvertisers']").val() == -1) {
                alert('Please select an advertiser.');
                return false;
            }
            if ($("select[id$='ddlAffiliates']").val() == -1) {
                alert('Please select an affiliate.');
                return false;
            }
            return true;
        }

        function Export(){
            <%= Page.ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
            return false;
        }

    </script>

    <script type="text/javascript">
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);

        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function () {
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
                $(".jqFilterButton").button();
                $(".jqFilterButton").click(function () {
                    return ValidateFilter();
                });
                $(".jqExportButton").button();
                $(".jqExportButton").click(function () {
                    if (!ValidateFilter()) return false;
                    Export();
                });
            });
        }
        
        
    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: left; margin: 10 10 0 0">
                <h2>Debt Analysis</h2>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <br/>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loader2.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td style="white-space: nowrap;">
                            <asp:Label ID="lblAdvertiser" runat="server" Text="Advertiser:"/><br/>
                            <asp:DropDownList ID="ddlAdvertisers" runat="server" AppendDataBoundItems="true" Style="margin-right: 10px; width: 300px;"
                                DataSourceID="dsAdvertisers" DataTextField="Advertiser" DataValueField="AdvertiserID" 
                                AutoPostBack="True">
                                <asp:ListItem Text="Select Advertiser..." Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="dsAdvertisers" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                                SelectCommand="stp_reports_debtanalysis_getadvertisers" SelectCommandType="StoredProcedure">
                            </asp:SqlDataSource>
                        </td>
                        <td style="white-space: nowrap;">
                            <asp:Label ID="lblAffiliate" runat="server" Text="Affiliate:"/><br/>
                            <asp:DropDownList ID="ddlAffiliates" runat="server" AppendDataBoundItems="true"  Style="margin-right: 10px; width: 300px;"
                                  DataTextField="Affiliate" DataValueField="AffiliateID" Enabled="False">
                                <asp:ListItem Text="Select Affiliate..." Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>   
                        <td>
                            <br/>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="white-space: nowrap">
                            <br/>
                            <asp:TextBox ID="txtDate1" runat="server" Size="7" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" PopupButtonID="imgDate1" />&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="7"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/24x24_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" PopupButtonID="imgDate2" />&nbsp;&nbsp;
                        </td>
                        <td><br/>
                            <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqFilterButton" />
                            </small>
                        </td>
                        <td><br/>
                            <small>
                               <asp:Button ID="btnExport" runat="server" Text="Export" Font-Size="8pt" CssClass="jqExportButton"  />
                            </small>
                        </td>
                        
                    </tr>
                </table> 
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="LeadId" Width="100%"
                        BorderStyle="None" BorderWidth="0px" CellPadding="3" CellSpacing="0" ForeColor="Black"
                        GridLines="None" AllowSorting="True" AllowPaging="true" PageSize="50" AlternatingRowStyle-CssClass="altrow" EmptyDataText="No Leads Found"
                        OnPageIndexChanging="gvLeads_PageIndexChanging" OnSorting="gvLeads_Sorting">
                        <Columns>
                            <asp:BoundField DataField="Campaign" HeaderText="Campaign" SortExpression="Campaign">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                           <asp:BoundField DataField="Phone" HeaderText="Phone">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Email" HeaderText="Email Address">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                             <asp:BoundField DataField="SubId" HeaderText="Sub-Id">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="40px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VisitDate" HeaderText="Last Visit" SortExpression="VisitDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LeadStatus" HeaderText="Lead Status" SortExpression="LeadStatus">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LastDialerStatus" HeaderText="Last Call Status" SortExpression="LastDialerStatus">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CIDSaleDate" HeaderText="Sale Date" SortExpression="CIDSaleDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CIDStatus" HeaderText="CID Status" SortExpression="CIDStatus">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SoldToCID" HeaderText="Sold To CID" SortExpression="SoldToCID">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ClientConversionDate" HeaderText="Converted Date" SortExpression="ClientConversionDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FirstScheduledDepositDate" HeaderText="1st Expected Deposit" SortExpression="FirstScheduledDepositDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FirstDepositDate" HeaderText="1st Deposit" SortExpression="FirstDepositDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FirstDepositStatus" HeaderText="1st Deposit Status" SortExpression="FirstDepositStatus">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="30px" />
                            </asp:BoundField>
                             <asp:BoundField DataField="FirstGoodDepositDate" HeaderText="1st Good Deposit" SortExpression="FirstGoodDepositDate" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem2" Width="20px" />
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
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" />
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID ="lnkExport"/>
        </Triggers> 
    </asp:UpdatePanel>
     <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
</asp:Content>

