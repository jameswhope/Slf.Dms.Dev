<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="DepositAnalysisReport1.aspx.vb" Inherits="Clients_Enrollment_DepositAnalysisReport1" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css")%>"
        rel="stylesheet" />
    <link type="text/css" href="<%= ResolveUrl("~/css/default.css")%>" rel="stylesheet" />
    <link type="text/css" href="<%= ResolveUrl("~/css/portal.css")%>" rel="stylesheet" />
    <link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet" />
    <style type="text/css">
        .headitem5
        {
            background-color: #C0C0C0 !important;
            width: 60px;
            padding: 3px 3px 3px 3px !important;
            font-weight: bold !important;
        }
        .footitem
        {
            background-color: #C0C0C0 !important;
            font-weight: bold;
            width: 60px;
            padding: 7 0 7 0;
        }
        .sortasc
        {
            background-image: url(../../images/sort-asc.png);
            background-position: 90%;
            background-repeat: no-repeat;
        }
        .sortdesc
        {
            background-image: url(../../images/sort-desc.png);
            background-position: 90%;
            background-repeat: no-repeat;
        }
        .headitem5 a
        {
            font-weight: bold !important;
        }
        .griditemalt
        {
            background-color: #DCDCDC;
        }
        .griditem2
        {
            width: 60px;
        }
        .emptyrow td
        {
            text-align: center;
            font-size: 1.1em;
            font-weight: bold;
            padding: 20px 0 20px 0;
            background-color: #FFFFCC;
        }
        .dvFilter
        {
            margin: -10px 0 3px 0px;
            font-size: 11px;
            font-weight: bold;
            color: #000000;
            clear: both;
        }
        .report-content
        {
            clear: both;
            padding: 5px 10px 5px 5px;
            width: 100%;
            }
        .report-header
        {
            padding: 5px  1px 5px 1px !importan;
            border-bottom: solid 1px #d3d3d3;
            background-color: #c1c1c1;
            font-family:Tahoma;
            font-size:11px;
            font-weight:bold;
            margin-right: 5px; 
            }
         .report-numeric
         {
             padding-right: 25px;
             text-align: right;
             width: 100px;
             }
          .report-header th 
          {
             padding-right: 25px;
             text-align: right;
             width: 100px;
              }
        
    </style>

    <script type="text/javascript">
     
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);
        
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");
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
                $('.ui-datepicker-trigger').hide();
                ddlMonthYear1.style.display = "inline";
                ddlMonthYear2.style.display = "inline";
            }else{
                txtDate1.style.display = "inline";
                txtDate2.style.display = "inline";
                $('.ui-datepicker-trigger').show();
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
                $(".jqExportButton").click(function(){ExportExcel();});
                
                $("#dvAccordionMonth").accordion({collapsible: true, active: false, heightStyle: "content"});
                $(".jqsubaccordion").accordion({collapsible: true, active: false, heightStyle: "content"});
                $("#dvAccordionMonth").accordion("option", "icons", { 'header': 'ui-icon-circle-plus', 'headerSelected': 'ui-icon-circle-minus' }); 
                $(".jqsubaccordion").accordion("option", "icons", { 'header': 'ui-icon-circle-plus', 'headerSelected': 'ui-icon-circle-minus' });
                $("#dvAccordionMonth").show();
                
                $('#<%=txtDate1.ClientId %>, #<%=txtDate2.ClientId %>').datepicker({showOn: "button", 
                                                        buttonImage: '<%=ResolveUrl("~/images/16x16_calendar.png") %>',
                                                        buttonImageOnly: true,
                                                        dateFormat: "mm/dd/yy"});
                                                        
                 if ($('#<%=txtDate1.ClientId %>').is(':hidden')) {
                     $('.ui-datepicker-trigger').hide();
                 }
               
                if ($("#<%= hdnNoTab.ClientId%>").val() == "1"){
                    $(".tabMainHolder").closest('tbody').prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest('td').css('height','0px');
                    $(".menuTable").closest('tr').css('height','0px');
                    $(".tabMainHolder, .tabTxtHolder").closest('tr').remove();
                    $(".menuTable").remove();
               }
            });
        } 
        
        function popup(data) {
            var expurl = '<%=ResolveUrl("~/util/CsvExport.ashx?f=depositanalysisbyenrollment") %>';
            
            
            $("body").append('<form id="exportform" action="' + expurl + '" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }

        function ExportExcel() {
            try {
                /* get header */
                var csv_value = '' + $("#<%=lblFilter.ClientId %>").text() + '\r\n\r\n';
                $(".month-row").each(function(){
                    csv_value = csv_value + $(".report-header").table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n';
                    csv_value = csv_value + $(this).table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n\r\n';
                    $(this).closest("h3").next("div").find(".day-row").each(function(){
                        csv_value = csv_value + $(".report-header").table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n';
                        csv_value = csv_value + $(this).table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n\r\n';
                        csv_value = csv_value + $(this).closest("h3").next("div").find("*[id$='gvLeads']").table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n\r\n';
                    });
                });
                
                var regexp = new RegExp(/[“]/g);
                csv_value = csv_value.replace(regexp, "\"\"");
                csv_value = csv_value.replace(/&nbsp;/gi, " ");
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
        
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server">
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
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: left; margin: 5 0 0 5; color: #808080;">
                <h4>Deposit Analysis by Hire Date</h4>
                <div class="dvFilter">
                    <asp:Label ID="lblFilter" runat="server" >
                    </asp:Label> 
                </div>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px; margin-top: 15px;">
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
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="white-space: nowrap">
                            <asp:TextBox ID="txtDate1" runat="server" Size="8" MaxLength="10"></asp:TextBox>
                            <asp:DropDownList ID="ddlMonthYear1" runat="server">
                            </asp:DropDownList>
                            &nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="8"></asp:TextBox>
                            <asp:DropDownList ID="ddlMonthYear2" runat="server">
                            </asp:DropDownList>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqFilterButton" />
                                <asp:Button ID="btnExport" runat="server" Text="Export" Font-Size="8pt" CssClass="jqExportButton" />
                            </small>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">
                <div class="portlet-content">
                    <div>
                        <div class="report-content">
                            <table class="report-header" style="width: 100%; height:30px; table-layout: fixed;">
                                <tr>
                                    <th style="width: 225px; text-align: left; padding-left: 25px;">
                                        Date
                                    </th>
                                    <th style="width: 100px">
                                        Client Count
                                    </th>
                                    <th style="width: 100px">
                                        Avg. # of Debts
                                    </th>
                                    <th style="width: 100px">
                                        Avg. Debt Amount
                                    </th>
                                    <th style="width: 100px">
                                        Avg. Deposit Amount
                                    </th>
                                    <th style="width: 100px">
                                        Cleared Deposits
                                    </th>
                                    <th style="width: 100px">
                                        Initial Fees Left
                                    </th>
                                    <th style="width: 100px">
                                        Status
                                    </th>
                                    <th style="width: 99%">
                                        &nbsp;
                                    </th>
                                </tr>
                            </table>
                            <div id="dvAccordionMonth" style="display: none;">
                                <asp:Repeater ID="rptMain" runat="server">
                                    <ItemTemplate>
                                        <h3>
                                            <table style="width: 100%; table-layout: fixed;" class="month-row">
                                                <tr>
                                                    <td style="width: 200px">
                                                        <%#String.Format("{0:MMM yyyy}", CDate(Eval("yearmonth")))%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#Eval("clientcount")%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#Eval("AvgDebtCount")%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#String.Format("{0:c}", Eval("AvgDebtAmount"))%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#String.Format("{0:c}", Eval("AvgDepositAmount"))%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#String.Format("{0:p0}", Eval("PctClearDeposits"))%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#String.Format("{0:c}", Eval("TotalFeeOwedLeft"))%>
                                                    </td>
                                                    <td class="report-numeric">
                                                        <%#String.Format("{0:p0}", Eval("PctActive"))%>
                                                    </td>
                                                    <td style="width: 99%">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </h3>
                                        <div>
                                            <div id="dvAccordionDay" class="jqsubaccordion" runat="server">
                                                <asp:Repeater ID="rptSubMain" runat="server" DataSource='<%# CType(Container.DataItem, System.Data.DataRowView).Row.GetChildRows("monthtoday") %>'
                                                    OnItemDataBound="BindSecondRpt">
                                                    <ItemTemplate>
                                                            <h3>
                                                                <table style="width: 100%; table-layout: fixed;" class="day-row">
                                                                    <tr>
                                                                        <td style="width: 175px">
                                                                            <%#String.Format("{0:MM/dd/yyyy}", CDate(Container.DataItem.Item("ClientCreated")))%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#Container.DataItem.Item("ClientCount")%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#Container.DataItem.Item("AvgDebtCount")%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#String.Format("{0:c}", Container.DataItem.Item("AvgDebtAmount"))%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#String.Format("{0:c}", Container.DataItem.Item("AvgDepositAmount"))%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#String.Format("{0:p0}", Container.DataItem.Item("PctClearDeposits"))%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#String.Format("{0:c}", Container.DataItem.Item("TotalFeeOwedLeft"))%>
                                                                        </td>
                                                                        <td class="report-numeric">
                                                                            <%#String.Format("{0:p0}", Container.DataItem.Item("PctActive"))%>
                                                                        </td>
                                                                        <td style="width: 99%">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </h3>
                                                            <div>
                                                                <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="False" DataKeyNames="LeadApplicantId"
                                                                    Width="100%" BorderStyle="None" BorderWidth="0px" CellPadding="3" CellSpacing="0"
                                                                    ForeColor="Black" GridLines="None" AllowSorting="False" AlternatingRowStyle-CssClass="griditemalt"
                                                                    EmptyDataText="No Leads Found" EmptyDataRowStyle-CssClass="emptyrow"
                                                                    ShowFooter="False">
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="#">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="10px" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" Width="10px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex + 1 %>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="ClientName" HeaderText="Lead<br/>Name" SortExpression="clientname"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="LawFirm" HeaderText="Law Firm" SortExpression="lawfirm"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="leadcreated" HeaderText="Date<br/>Created" SortExpression="leadcreated"
                                                                            DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="clientcreated" HeaderText="Date<br/>Hired" SortExpression="clientcreated"
                                                                            DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headitem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="productcode" HeaderText="Product" SortExpression="productcode"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="100px" Wrap="false" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="sourcecampaign" HeaderText="Source" SortExpression="sourcecampaign"
                                                                            HtmlEncode="false" Visible="false" >
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" Width="60px" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="60px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="debtcount" HeaderText="# of<br/>Debts" SortExpression="debtcount"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" Width="30px"/>
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" Width="30px"/>
                                                                            <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="debtamount" HeaderText="Debt<br/>Amount" SortExpression="debtamount"
                                                                            DataFormatString="{0:c}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="depositamount" HeaderText="Deposit<br/>Amount" SortExpression="depositamount"
                                                                            DataFormatString="{0:c}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="firstdeposit" HeaderText="First<br/>Deposit" SortExpression="firstdeposit"
                                                                            DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="depositday" HeaderText="Deposit<br/>Day" SortExpression="depositday"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="depositmethod" HeaderText="Deposit<br/>Method" SortExpression="depositmethod"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="left" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="30px" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="gooddepositscount" HeaderText="Cleared<br/>Deposits" SortExpression="gooddepositscount"
                                                                            HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="totalgooddeposits" HeaderText="Cleared<br/>Amount" SortExpression="totalgooddeposits"
                                                                            DataFormatString="{0:c}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="bonceddepositscount" HeaderText="Bounced<br/>Deposits"
                                                                            SortExpression="bonceddepositscount" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="totalbounceddeposits" HeaderText="Bounced<br/>Amount"
                                                                            SortExpression="totalbounceddeposits" DataFormatString="{0:c}" HtmlEncode="false">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headItem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle CssClass="footitem" />
                                                                        </asp:BoundField>
                                                                        <asp:TemplateField HeaderText="Initial<br/>Fees Left" SortExpression="totalinitialfees">
                                                                            <HeaderStyle HorizontalAlign="right" CssClass="headitem5" />
                                                                            <ItemStyle HorizontalAlign="right" CssClass="griditem2" />
                                                                            <FooterStyle HorizontalAlign="right" CssClass="footitem" />
                                                                            <ItemTemplate>
                                                                                <%#String.Format("{0:c}", Eval("totalinitialfees") - Eval("paidinitialfees"))%>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="agent" HeaderText="Sales<br/>Rep." SortExpression="agent"
                                                                            HtmlEncode="false">
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
                                                            </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="lnkExport" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
</asp:Content>
