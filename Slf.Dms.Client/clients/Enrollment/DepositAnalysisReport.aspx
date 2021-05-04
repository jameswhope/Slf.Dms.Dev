﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="DepositAnalysisReport.aspx.vb" Inherits="Clients_Enrollment_DepositAnalysisReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<link type="text/css" href="<%= ResolveUrl("~/css/default.css")%>" rel="stylesheet" />
<link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet"  />
    <style type="text/css"  >
        .headitem5 {background-color: #C0C0C0 !Important; width: 60px; }
        .footitem  {background-color: #C0C0C0 !Important; font-weight: bold; width: 60px; padding: 7 0 7 0;}
        .sortasc {background-image:  url(../../images/sort-asc.png); background-position: 90%; background-repeat:no-repeat;}
        .sortdesc {background-image:  url(../../images/sort-desc.png); background-position: 90%; background-repeat:no-repeat;}
        .headitem5 a { font-weight: bold !Important;}
        .griditemalt { background-color: #DCDCDC; }
        .griditem2 {width: 60px;}
        .emptyrow td{
            text-align: center;
            font-size: 1.1em;
            font-weight: bold;
            padding: 20px 0 20px 0;
            background-color: #FFFFCC;
        }
        .dvFilter{ margin: 20px 0 3px 5px; font-size: 11px; font-weight: bold;}
    </style>
     <script type="text/javascript">
     
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);
        
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");
            var imgDate1 = document.getElementById("<%=imgDate1.ClientId %>");
            var imgDate2 = document.getElementById("<%=imgDate2.ClientId %>");
            var ddlMonthYear1 = document.getElementById("<%=ddlMonthYear1.ClientId %>");
            var ddlMonthYear2 = document.getElementById("<%=ddlMonthYear2.ClientId  %>");
            
            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
                     
            if (ddl.options[ddl.selectedIndex].text == "By Month") {
                txtDate1.style.display = "none";
                txtDate2.style.display = "none";
                imgDate1.style.display = "none";
                imgDate2.style.display = "none";
                ddlMonthYear1.style.display = "inline";
                ddlMonthYear2.style.display = "inline";
            }else{
                txtDate1.style.display = "inline";
                txtDate2.style.display = "inline";
                imgDate1.style.display = "inline";
                imgDate2.style.display = "inline";
                ddlMonthYear1.style.display = "none";
                ddlMonthYear2.style.display = "none";
            }
            
        }

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
                $(".jqFilterButton").button();
                $(".jqExportButton").button();
                $(".jqExportButton").click(function(){Export();});
                
                if ($("#<%= hdnNoTab.ClientId%>").val() == "1"){
                    $(".tabMainHolder").closest('tbody').prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest('td').css('height','0px');
                    $(".menuTable").closest('tr').css('height','0px');
                    $(".tabMainHolder, .tabTxtHolder").closest('tr').remove();
                    $(".menuTable").remove();
               }
            });
        } 
        
        function Export(){
            <%= Page.ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
            return false;
        }
        
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        </Scripts>
    </asp:ScriptManager>
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a id="A1" runat="server" class="menuButton" href="default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_back.png" />Reports</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" /> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
     <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: left; margin: 5 0 0 5; color: #808080;">
                <h4>Deposit Analysis</h4>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loading.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                        <td>
                            <asp:CheckBox ID="chkExcludeReferals" runat="server" Text="Exclude CID" AutoPostBack="True" /> 
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="white-space: nowrap">
                            <asp:TextBox ID="txtDate1" runat="server" Size="8" MaxLength="10" OnTextChanged="txtDate1_TextChanged" AutoPostBack="True"></asp:TextBox>
                            <asp:ImageButton runat="Server" ID="imgDate1" ImageUrl="~/images/16x16_calendar.png" AlternateText="" ImageAlign="AbsMiddle" />
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate1" PopupButtonID="imgDate1" />
                            <asp:DropDownList ID="ddlMonthYear1" runat="server" OnSelectedIndexChanged="ddlMonthYear1_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                          </td>
                        <td>-</td>
                        <td>  
                            <asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="8"  OnTextChanged="txtDate1_TextChanged" AutoPostBack="True"></asp:TextBox>
                            <asp:ImageButton runat="Server" ID="imgDate2" ImageUrl="~/images/16x16_calendar.png" AlternateText="" ImageAlign="AbsMiddle" />
                            <asp:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDate2" PopupButtonID="imgDate2" />
                            <asp:DropDownList ID="ddlMonthYear2" runat="server" OnSelectedIndexChanged="ddlMonthYear1_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCompany" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlProduct" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlRep" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                             <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqFilterButton" />
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
                    <asp:HiddenField ID="hdnSortColumn" runat="server" Value="" />  
                    <asp:HiddenField ID="hdnSortDirection" runat="server" Value="" />  
                <asp:ListView ID="lvLeads" runat="server"  >
                    <LayoutTemplate>
                    <div runat="server" ID="itemPlaceholder">
                    </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <div class="dvFilter">
                            <asp:Label ID="lblFilter" runat="server" Text='<%# Eval("FilterName") %>'  >
                            </asp:Label> 
                        </div>
                        <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="LeadApplicantId" Width="100%"
                        BorderStyle="None" BorderWidth="0px" CellPadding="3" CellSpacing="0" ForeColor="Black"
                        GridLines="None" AllowSorting="True" AlternatingRowStyle-CssClass="griditemalt" EmptyDataText="No Leads Found" EmptyDataRowStyle-CssClass="emptyrow" OnSorting="gvLeads_Sorting" ShowFooter="True">
                        <Columns>
                            <asp:TemplateField HeaderText="#" > 
                            <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="10px"/>
                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" Width="10px" />
                            <FooterStyle CssClass="footitem" /> 
                            <ItemTemplate> 
                                <%# Container.DataItemIndex + 1 %> 
                            </ItemTemplate> 
                            </asp:TemplateField>
                            <asp:BoundField DataField="ClientName" HeaderText="Lead<br/>Name" SortExpression="clientname" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="LawFirm" HeaderText="Law Firm" SortExpression="lawfirm" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="leadcreated" HeaderText="Date<br/>Created" SortExpression="leadcreated" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="clientcreated" HeaderText="Date<br/>Hired" SortExpression="clientcreated" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="productcode" HeaderText="Product" SortExpression="productcode" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="sourcecampaign" HeaderText="Source" SortExpression="sourcecampaign" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" Width="60px"/>
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="debtcount" HeaderText="# of<br/>Debts" SortExpression="debtcount" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2"  />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                            </asp:BoundField>
                            <asp:BoundField DataField="debtamount" HeaderText="Debt<br/>Amount" SortExpression="debtamount" DataFormatString="{0:c}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="initialdraftamount" HeaderText="Initial Draft<br/>Amount" SortExpression="initialdraftamount" DataFormatString="{0:c}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="depositamount" HeaderText="Deposit<br/>Amount" SortExpression="depositamount" DataFormatString="{0:c}" HtmlEncode="false"  >
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="FixedFeePercentage" HeaderText="Fixed<br/>Fee" SortExpression="FixedFeePercentage" DataFormatString="{0:0.###%}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="totalfixedfees" HeaderText="Total<br/>Fixed Fees" SortExpression="totalfixedfees" DataFormatString="{0:c}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                                <%--<ItemTemplate> 
                                    <%#String.Format("{0:c}", Eval("totalinitialfees") - Eval("paidinitialfees"))%> 
                                </ItemTemplate> --%>
                            </asp:BoundField>
                            <asp:BoundField DataField="firstdeposit" HeaderText="First<br/>Deposit" SortExpression="firstdeposit" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField> 
                            <asp:BoundField DataField="depositday" HeaderText="Deposit<br/>Day" SortExpression="depositday" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                             <asp:BoundField DataField="depositmethod" HeaderText="Deposit<br/>Method" SortExpression="depositmethod" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="gooddepositscount" HeaderText="Cleared<br/>Deposits" SortExpression="gooddepositscount" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle HorizontalAlign="right" CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="totalgooddeposits" HeaderText="Cleared<br/>Amount" SortExpression="totalgooddeposits" DataFormatString="{0:c}"  HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="bonceddepositscount" HeaderText="Bounced<br/>Deposits" SortExpression="bonceddepositscount" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="totalbounceddeposits" HeaderText="Bounced<br/>Amount" SortExpression="totalbounceddeposits" DataFormatString="{0:c}" HtmlEncode="false" >
                                <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="agent" HeaderText="Sales<br/>Rep." SortExpression="agent" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status">
                                <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                   </ItemTemplate> 
                </asp:ListView>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID ="lnkExport"/>
        </Triggers> 
    </asp:UpdatePanel>
     <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
    <asp:HiddenField id="hdnProducts" runat="server"/>
     <asp:HiddenField id="hdnCompanies" runat="server"/>
    <asp:HiddenField id="hdnReps" runat="server" />
</asp:Content>

