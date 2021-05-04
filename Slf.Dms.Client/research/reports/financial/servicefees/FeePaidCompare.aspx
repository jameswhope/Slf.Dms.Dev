<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/financial/servicefees/servicefees.master" AutoEventWireup="false" CodeFile="FeePaidCompare.aspx.vb" Inherits="research_reports_financial_servicefees_FeePaidCompare" %>
<%@ Register Src="~/CustomTools/UserControls/RptFeesPaid.ascx" TagName="RptFeesPaid" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <link href='<%= ResolveUrl("~/css/default.css") %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl("~/jquery/css/jquery.multiselect.css") %>' rel="stylesheet" type="text/css" />

    <style type="text/css">
          #rpttoolbar {
            padding: 4px;
            display: inline-block;
          }

        .gridFooter 
        {
            font-weight: bold;
            }
       
        .grdFeesPaid 
        {
            border-color: black;
            }
        .grdFeesPaid td,.grdFeesPaid th
        {
            padding: 3px 3px 3px 3px;
            white-space: nowrap; 
            }
        .grdFeesPaid1
        {
            background-color: #E0F8F7;
            }
        .grdFeesPaid2
        {
            background-color: #F3E2A9;
            }
        .grdFeesPaidDiff
        {
            background-color: #F6CECE; 
            }
       .grdFeesPaid caption 
        {
             font-weight: bold;
             width: 100%;
             white-space: nowrap;
             background-color: inherit; 
             padding: 3px 3px 1px 3px;
            }
        .tdGrdFees 
        {
             vertical-align: top;
            }
        .filterHead
        {
            white-space: nowrap;
            text-align: left;
            vertical-align: middle;
            }
        .txtDate
        {
            width: 65px;
            color: #2e6e9e;
            }
        .tdDateRange
        {
             white-space: nowrap;
            }
        #rpttoolbar table
        {
            border-collapse: collapse;
            }
        #rpttoolbar td
        {
            padding: 3px;
            }
            
        .errorValidation 
        {
           border: solid 1px Red !important;
           background-color: #F6CECE !important;
           background-image: none !important;
            }
        .grdFeesPaidEmpty
         {
             text-align: center;
              }
    </style>
     <script type="text/javascript">
         function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {

                $("#trFilterTemplate").hide();

                if  (GetCurrentFilterCount() == 0) {
                    var elem = addFilter($("#trFilterTemplate"));
                    jqueryFilter(elem);
                }

                $('.lnkFilter').button();

                $('#<%=lnkView.ClientId%>').unbind("click").click(function(e) { e.preventDefault();return ViewReport(); });
                $('#<%=lnkExport.ClientId%>').unbind("click").click(function(e) { e.preventDefault();return ExportExcel(); });

                $('#btnAddFilter').button({ icons: { primary: "ui-icon-plusthick" }, text: false })
                                  .unbind("click")
                                  .click(function(e) {
                                       if ( GetCurrentFilterCount() >= 3){
                                            alertMsg("You have reached the maximum number of filters allowed which is 3.");
                                        } else {
                                          var elem = addFilter($("#trFilterTemplate"));
                                          jqueryFilter(elem);
                                      }
                                      e.preventDefault();
                                  });
                
                AdjustGridColumnsWidth();                   
                AdjustGridsWidth();                  
                                  
                $('.AjaxProgressMessage').hide();

            });
        }

        function AdjustGridColumnsWidth(){
            var grdclasses = [".grdFeesPaid1",".grdFeesPaid2",".grdFeesPaidDiff"]
            for (var i=0;i<grdclasses.length;i++)
            {
            var gridrows = $(grdclasses[i] + " tr:first-child");
            var ln = gridrows.map(function() { return parseInt($(this).children().length); }).get();
            var maxln = Math.max.apply(Math, ln);
            for(var j=0;j<maxln;j++){
                var gridcells = gridrows.find(":nth-child(" + (j+1) + ")");
                var wd = gridcells.map(function() { return parseInt($(this).css("width")); }).get();
                var maxwd = Math.max.apply(Math, wd);
                gridcells.css("width", maxwd + 'px');
                gridcells.attr("noWrap", "nowrap");
                }
            }
        }
        
         function AdjustGridsWidth(){
            var grdclasses = [".grdFeesPaid1",".grdFeesPaid2",".grdFeesPaidDiff"]
            for (var i=0;i<grdclasses.length;i++)
            {
            var grids = $(grdclasses[i]);
            var wd = grids.map(function() { return parseInt($(this).css("width")); }).get();
            var maxwd = Math.max.apply(Math, wd );
            grids.css("width", maxwd + 'px');
            }
        }

        function addFilter(elem) {
            
            var trs = $("[tr-index]").map(function() { return $(this).attr("tr-index"); }).get();
            var maxtrindex = Math.max.apply(Math, trs);
            var filterElem = elem.clone();
            if (!(maxtrindex)) 
                maxtrindex = 1;
            else
                maxtrindex++;
           
            filterElem.attr("tr-index", maxtrindex);
            filterElem.attr("id", "trFilter" + "_" + maxtrindex)
            filterElem.find("[id]").each(function() {
                $(this).attr("id", $(this).attr("id") + "_" + maxtrindex);
            });
            var btnRemove = $("<button>Remove</button>").button({ icons: { primary: "ui-icon-trash" }, text: false })
                                  .click(function(e) {
                                      if (GetCurrentFilterCount() < 2){
                                        alertMsg("Cannot remove the filter. At least one filter should be present.");
                                      } else {
                                        $(this).closest("tr").remove();
                                      }
                                      e.preventDefault();
                                  });

            filterElem.find(".tdFilterFirstColumn").append(btnRemove);
            filterElem.show();
            $("#trFilterTemplate").closest("table").append(filterElem);
            return filterElem;
        }

        function jqueryFilter(elem) {

            $(".txtDate", elem).datepicker();
        
            $('.ddlCompany', elem).multiselect({ selectedList: 3,
                noneSelectedText: "Select Law Firm",
                selectedText: "# firms selected"
            });

            $('.ddlAgency', elem).multiselect({ selectedList: 3,
                noneSelectedText: "Select Agency",
                selectedText: "# agencies selected"
            });

            $('.ddlCommRec', elem).multiselect({ selectedList: 3,
                noneSelectedText: "Select Payee",
                selectedText: "# payees selected"
            });
        }
        
        function ValidateFilters() {
             $(".errorValidation").removeClass("errorValidation");
             var filters = $("[id^='trFilter_']");
             if (filters.length==0){
                alertMsg("Error: No filters.");
                return false;
             }
             
             for(i=0;i<filters.length;i++)
             { 
                var filterIndex = parseInt(filters.eq(i).attr("id").replace(/trFilter_/gi, '')).toString();
                var filterNumber = (i+1).toString();
                //Range date 1
                //start date
                var elem;
                var d;
                
                elem = $("[id$='txtStartDate1_" + filterIndex + "']");
                d = elem.datepicker("getDate");
                if (!d || d.toString().replace(/ /gi, '').length == 0){
                    alertMsg("Filter #" + filterNumber + ": The start date for the First Date Range is required.", elem);
                    return false;
                }
                //end date
                elem = $("[id$='txtEndDate1_" + filterIndex + "']");
                d = elem.datepicker("getDate");
                if (!d || d.toString().replace(/ /gi, '').length == 0){
                    alertMsg("Filter #" + filterNumber + ": The end date for the First Date Range is required.", elem);
                    return false;
                }
                //Range date 2
                //start date
                elem = $("[id$='txtStartDate2_" + filterIndex + "']");
                d = elem.datepicker("getDate");
                if (!d || d.toString().replace(/ /gi, '').length == 0){
                    alertMsg("Filter #" + filterNumber + ": The start date for the Second Date Range is required.", elem);
                    return false;
                }
                //end date
                elem = $("[id$='txtEndDate2_" + filterIndex + "']");
                d=elem.datepicker("getDate");
                if (!d || d.toString().replace(/ /gi, '').length == 0){
                    alertMsg("Filter #" + filterNumber + ": The end date for the Second Date Range is required.", elem);
                    return false;
                }
                //company
                elem = $("[id$='ddlCompany_"+filterIndex+"']");
                if (!elem.val()) {
                    alertMsg("Filter #" + filterNumber + ": A Law Firm has to be selected.", elem);
                    return false;
                } 
                //agency
                elem = $("[id$='ddlAgency_"+filterIndex+"']");
                 if (!elem.val()) {
                    alertMsg("Filter #" + filterNumber + ": An Agency has to be selected.", elem);
                    return false;
                } 
                 //payee
                 elem = $("[id$='ddlCommRec_"+filterIndex+"']");
                 if (!elem.val()) {
                    alertMsg("Filter #" + filterNumber + ": A Payee has to be selected.", elem);
                    return false;
                } 
              }
              return true;
        }
        
        function ViewReport(){
            //Validate first
            try
            {   
                if (!ValidateFilters()){
                    return false;
                }
                $('.AjaxProgressMessage').show();
                var filterdata = [];
                $("[id^='trFilter_']").each(function(index, item) {
                    var filterIndex = parseInt($(this).attr("id").replace(/trFilter_/gi, '')).toString();
                    var filter = { daterange1: { startdate: $("[id$='txtStartDate1_" + filterIndex + "']").datepicker("getDate").format("yyyy/MM/dd"), enddate: $("[id$='txtEndDate1_" + filterIndex + "']").datepicker("getDate").format("yyyy/MM/dd") },
                    daterange2: { startdate: $("[id$='txtStartDate2_" + filterIndex + "']").datepicker("getDate").format("yyyy/MM/dd"), enddate: $("[id$='txtEndDate2_" + filterIndex + "']").datepicker("getDate").format("yyyy/MM/dd") },
                        companyids: $("[id$='ddlCompany_"+filterIndex+"']").val(),
                        agencyids: $("[id$='ddlAgency_"+filterIndex+"']").val(),
                        commrecids: $("[id$='ddlCommRec_"+filterIndex+"']").val(),
                        combineinifees: $("[id$='chkCombine_"+filterIndex+"']").prop("checked")
                    };
                    filterdata.push(filter);
                });
                
                if (filterdata.length > 0){ 
                    $("#<%= hdnFilter.ClientId %>").val(JSON.stringify(filterdata));
                    <%= Page.ClientScript.GetPostBackEventReference(lnkView, nothing) %>;
                } 
            }
            catch (e){
                 $('.AjaxProgressMessage').hide();
                alertMsg('There was a problem running this report.');
            }
           
            return false;
        
        }
        
        function ExportExcel(){
            $(".errorValidation").removeClass("errorValidation");
            try {
                $('.AjaxProgressMessage').show();
                var csv_value = '';
                
                $("#<%=ud1.clientid %>").find("tr:has(td[class='tdGrdFees'])").each(function(index,item){
                    var tables = $(this).find(".tdGrdFees");
                    var rowcount = tables.eq(2).find("tr").length;
                    var tb = $("<table></table>");
                    var tr;
                    var tdcaption;
                    var row;
                    var tmprow;
                    for(i=0;i<rowcount;i++){
                            tdcaption = [];
                            row = [];
                            
                            for(k=0;k<3;k++){   
                                                   
                                tmprow = tables.eq(k).find("tr").eq(i).find("td,th").clone();
                                if (tmprow.length == 0) {
                                    $.merge(row,$("<td></td>"));}
                                else {
                                    $.merge(row, tmprow);
                                }
                                
                                if (i == 0){
                                    caption = tables.eq(k).find("caption");
                                    $.merge(tdcaption, $("<td></td>").html(caption.html()));
                                    tmprow.each(function(){  
                                                    $.merge(tdcaption, $("<td></td>")); 
                                                });
                                }
                                
                                $.merge(row,$("<td></td>"));
                            } 
                            
                            if (i == 0){
                                tr = $("<tr></tr>");
                                tr.append(tdcaption);
                                tb.append(tr);
                            }
                            
                            tr = $("<tr></tr>");
                            tr.append(row);
                            tb.append(tr);
                    }
                    
                    tb.find("th").each(function(index, item){
                                        $(item).replaceWith('<td>' + item.innerHTML + '</td>');
                                        });
                    
                    csv_value = csv_value + tb.table2CSV({ delivery: 'value', ignoreHidden: true }) + '\r\n\r\n';
                });
                
                var regexp = new RegExp(/[“]/g);
                csv_value = csv_value.replace(regexp, "\"\"");
                csv_value = csv_value.replace(/&nbsp;/gi, " ");
                popup(csv_value);
                $('.AjaxProgressMessage').hide();
            }
            catch (e) { 
                $('.AjaxProgressMessage').hide();
                alertMsg('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
           
            return false;
        }
      
        
        function popup(data) {
            var expurl = '<%=ResolveUrl("~/util/CsvExport.ashx?f=feecomparisonreport") %>';
            
            
            $("body").append('<form id="exportform" action="' + expurl + '" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }
        
        function GetCurrentFilterCount(){
            return $("[tr-index]").length - 1;
        }
        
        function alertMsg(msg, elem){
            AlertModal({message: msg, title: "Error", type: "error" ,width: 300, height: 30});
            if (elem){
                switch(elem.get(0).type){
                    case "select-multiple":
                        elem.siblings("button").addClass("errorValidation");
                        break;
                    default:
                        elem.addClass("errorValidation");
                }
            }
        }
        
    </script> 
    <asp:ScriptManager ID="sm1" runat="server">
    </asp:ScriptManager>  
     
    <div>
     <div id="rpttoolbar" class="ui-widget-header ui-corner-all" >
        <table>
            <thead>
                <tr>
                    <th class="filterHead"><button id="btnAddFilter">Add</button></th>
                    <th class="filterHead">First Date Range:</th>
                    <th class="filterHead">Second Date Range:</th>
                    <th class="filterHead">Law Firm:</th>
                    <th class="filterHead">Agency:</th>
                    <th class="filterHead">Payee:</th>
                    <th class="filterHead"></th>
                    <th class="filterHead" style="width: 100%; text-align: left; ">                        
                        <asp:LinkButton ID="lnkView" runat="server" CssClass="lnkFilter">View Report</asp:LinkButton>
                        <asp:LinkButton ID="lnkExport" runat="server" CssClass="lnkFilter">Export</asp:LinkButton>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr id="trFilterTemplate" tr-index="0">
                    <td class="tdFilterFirstColumn" style="vertical-align: top;"></td>
                    <td class="tdDateRange">
                        <asp:TextBox ID="txtStartDate1" runat="server" CssClass="txtDate"></asp:TextBox> - <asp:TextBox ID="txtEndDate1" runat="server" CssClass="txtDate"></asp:TextBox>     
                    </td>
                    <td class="tdDateRange">
                        <asp:TextBox ID="txtStartDate2" runat="server" CssClass="txtDate"></asp:TextBox> - <asp:TextBox ID="txtEndDate2" runat="server" CssClass="txtDate"></asp:TextBox>     
                    </td>
                    <td>
                        <select id="ddlCompany" runat="server" multiple="" class="ddlCompany"  >
                        </select>
                    </td>
                    <td>
                        <select id="ddlAgency" runat="server" multiple="" class="ddlAgency"  >
                        </select>
                    </td>
                    <td>
                        <select id="ddlCommRec" runat="server" multiple="" class="ddlCommRec" >
                        </select>
                    </td>
                    <td style="white-space: nowrap;">
                        <asp:CheckBox ID="chkCombine" runat="server" Text="Combine Initial Fees" />
                    </td>
                    <td style="width: 100%; text-align: right; ">
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
    </div>
     <div class="AjaxProgressMessage">
        <img id="Img2" alt="" src="~/images/ajax-loader.gif" runat="server" style="vertical-align: middle;"/><asp:Label ID="ajaxLabel"
            name="ajaxLabel" runat="server" Text="  Loading Report..." />
    </div>
     <asp:UpdatePanel ID="ud1" runat="server" >
        <ContentTemplate>
            <asp:Repeater ID="repeatFees" runat="server">
                <ItemTemplate>
                     <uc1:RptFeesPaid ID="rptFeesCtrl" runat="server" /> 
                </ItemTemplate>
            </asp:Repeater>
            <asp:HiddenField ID="hdnFilter" runat="server"/>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click"></asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="lnkExport" EventName="Click"></asp:AsyncPostBackTrigger>
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

