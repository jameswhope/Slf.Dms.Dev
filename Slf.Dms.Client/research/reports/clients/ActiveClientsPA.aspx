<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/clients/clients.master" AutoEventWireup="false" CodeFile="ActiveClientsPA.aspx.vb" Inherits="research_reports_clients_ActiveClientsPA" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <link href='<%= ResolveUrl("~/css/default.css") %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <link href='<%= ResolveUrl("~/jquery/css/jquery.multiselect.css") %>' rel="stylesheet" type="text/css" />
     <style>
      #rpttoolbar {
        padding: 4px;
        display: inline-block;
      }
      /* support: IE7 */
      *+html #rpttoolbar {
        display: inline;
      }
      .lnkView
      {
          white-space: nowrap;
      }
      .grdReport  
      {
          margin-left: 10px;
          margin-top: 10px; 
          }
       .grdReport th
      {
          padding: 6px 15px 6px 6px !important;
          background-color: #CCCCCC; 
          white-space: nowrap;
          }
          
       .grdReport th a
      {
          text-decoration: none;
          }
      .sorted
      {
          background-position: 95% center;
          background-repeat: no-repeat; 
          }    
      
      .sortedAsc
      {
          background-image: url('<%=ResolveUrl("~/images/sort-asc.png")%>');
          }
          
      .sortedDesc
      {
          background-image: url('<%=ResolveUrl("~/images/sort-desc.png")%>');
          }
      
      .grdReport th a:hover
      {
          text-decoration: underline;
          }
          
      .alternateRow
      {
          background-color: #F2F2F2;
          }
          
      .grdReport td
      {
          padding: 6px 6px 6px 6px !important;
          }
          
      .moneyCell
      {
          text-align: right;
          }
  </style>
    <script type="text/javascript">
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {

                $('#<%= ddlCompany.ClientId%>').multiselect({ selectedList: 3,
                    noneSelectedText: "Select Law Firm",
                    selectedText: "# firms selected"
                });

                $('#<%= ddlAgency.ClientId%>').multiselect({ selectedList: 3,
                    noneSelectedText: "Select Agency",
                    selectedText: "# agencies selected"
                });

                $('#<%= lnkView.ClientId%>').button();
                $('#<%= lnkExport.ClientId%>').button();

                if ($('#<%=hdnFirstLoad.ClientId %>').val() == "1") {
                    $('#<%= ddlCompany.ClientId%>').multiselect("checkAll");
                    $('#<%= ddlAgency.ClientId%>').multiselect("checkAll");
                }

                $('#<%= ud1.clientid%>').css("height", "100%");
            });
        }
        
    </script> 
    <asp:ScriptManager ID="sm1" runat="server">
    </asp:ScriptManager>  
     <div id="rpttoolbar" class="ui-widget-header ui-corner-all">
        <table>
            <tbody>
                <tr>
                    <td style="white-space:nowrap;" >
                        Law Firm: 
                    </td>
                    <td>
                        <select id="ddlCompany" runat="server" multiple="" >
                        </select>
                    </td>
                    <td>
                        Block:  
                    </td>
                    <td>
                        <select id="ddlAgency" runat="server" multiple="" >
                        </select>
                    </td>
                    <td style="width: 100%; text-align: right; ">
                        <asp:LinkButton ID="lnkView" runat="server" CssClass="lnkView">View Report</asp:LinkButton>
                        <asp:LinkButton ID="lnkExport" runat="server" CssClass="lnkView">Export</asp:LinkButton>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="ud1">
        <ProgressTemplate>
            <div class="AjaxProgressMessage">
                <img id="Img2" alt="" src="~/images/ajax-loader.gif" runat="server" style="vertical-align: middle;"/><asp:Label ID="ajaxLabel"
                    name="ajaxLabel" runat="server" Text="  Loading Report..." />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="ud1" runat="server" >
        <ContentTemplate>
            <asp:GridView ID="grdReport" runat="server" AutoGenerateColumns="False" AllowSorting="true" EmptyDataText="No data to display." CssClass="grdReport" AllowPaging="True" PageSize="200" PagerStyle-HorizontalAlign="center"   >
                <AlternatingRowStyle CssClass="alternateRow" />
                <PagerSettings Mode="NumericFirstLast" PageButtonCount="20" Position="TopAndBottom" FirstPageText="First" NextPageText="Next" LastPageText="Last" PreviousPageText="Prev"  FirstPageImageUrl="~/images/16x16_results_first.png" LastPageImageUrl="~/images/16x16_results_last.png"  NextPageImageUrl="~/images/16x16_results_next.png" PreviousPageImageUrl="~/images/16x16_results_previous.png"    />
                <Columns>
                    <asp:BoundField DataField="LawFirm" HeaderText= "Law Firm " SortExpression="LawFirm" />
                    <asp:BoundField DataField="Block" HeaderText= "Block " SortExpression="Block" />
                    <asp:BoundField DataField="Client" HeaderText= "File # " SortExpression="Client"/>
                    <asp:BoundField DataField="AccountNumber" HeaderText= "Cred. Account # " SortExpression="AccountNumber"/>
                    <asp:BoundField DataField="LastPaymentDate" HeaderText= "Last Pmt. " DataFormatString="{0:yyyy/MM/dd}" SortExpression="LastPaymentDate"/>
                    <asp:BoundField DataField="LastPmtAmount" HeaderText= "Last Pmt. Amount " DataFormatString="{0:c}" ItemStyle-CssClass="moneyCell" SortExpression="LastPmtAmount"/>
                    <asp:BoundField DataField="DepositAmount" HeaderText= "Monthly Deposit " DataFormatString="{0:c}" ItemStyle-CssClass="moneyCell" SortExpression="DepositAmount"/>
                    <asp:BoundField DataField="MonthlyFee" HeaderText= "Maint. Fee " DataFormatString="{0:c}"  ItemStyle-CssClass="moneyCell" SortExpression="MonthlyFee" />
                </Columns>
            </asp:GridView> 
            <asp:HiddenField ID="hdnFirstLoad" runat="server"/>
     </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click"></asp:AsyncPostBackTrigger>
            <asp:PostBackTrigger ControlID="lnkExport" ></asp:PostBackTrigger>
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

