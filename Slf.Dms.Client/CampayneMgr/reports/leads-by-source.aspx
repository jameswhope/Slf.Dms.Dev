<%@ Page Title="" Language="VB" MasterPageFile="~/campayne.master" AutoEventWireup="false"
    CodeFile="leads-by-source.aspx.vb" Inherits="admin_leads_by_source" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .modalBackgroundTracker
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupTracker
        {
            background-color: #fff;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            width: 85%;
        }
        .headItem5
        {
            background-color: #DCDCDC;
            border-bottom: solid 1px #d3d3d3;
            font-weight: normal;
            color: Black;
            font-size: 11px;
            font-family: tahoma;
        }
        .headItem5 a
        {
            text-decoration: none;
            display: block;
            color: Black;
            font-weight: 200;
        }
        .listItem
        {
            cursor: pointer;
            border-bottom: solid 1px #d3d3d3;
        }
        .entry
        {
            font-family: tahoma;
            font-size: 11px;
            width: 100%;
        }
        .entry2
        {
            font-family: tahoma;
            font-size: 11px;
        }
        .tdHdr
        {
            text-align: right;
        }
        .tdCnt
        {
            text-align: left;
        }
        .ui-button .ui-button-text
        {
            line-height: 1.0;
        }
    </style>

    <script type="text/javascript">
        //initial jquery stuff
        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".jqButton").button();
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .prepend("<span class='ui-icon ui-icon-gear' title='hide/show filter options'></span>")
				        .end()
			        .find(".portlet-content");
                $(".portlet-header .ui-icon").click(function() {
                    $('.jqDateTbl').toggle();
                });			        
            });
        }

    </script>

    <script language="javascript" type="text/javascript">
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
       
    </script>

    <script type="text/javascript">
        function popup(data) {
            $("body").append('<form id="exportform" action="../Handlers/CsvExport.ashx?f=LeadBySourceDetail" method="post" target="_blank"><input type="hidden" id="exportdata" name="exportdata" /></form>');
            $("#exportdata").val(data);
            $("#exportform").submit().remove();
        }
        function ExportExcel() {
            try {
                var csv_value = $("*[id$='gvDetailData']").table2CSV({ delivery: 'value' });
                popup(csv_value);
            }
            catch (e) {
                alert('There was a problem exporting to Excel, make sure you have Excel installed.');
            }
        }
        function ShowDetailData(type, identifier) {
            //alert(type + ' ' + identifier);
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");

            var div = document.getElementById('<%=divDetailData.ClientID %>');
            div.style.display = 'none';

            var ld = document.getElementById('divLoading');
            ld.style.display = 'block';

            PageMethods.PM_getData(type, identifier, txtDate1.value, txtDate2.value, OnRequestComplete, OnRequestError);
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.show();
        }
        function ClosePopup() {
            var modalPopupBehavior = $find('programmaticModalPopupBehavior');
            modalPopupBehavior.hide();
            return false;
        }
        function OnRequestError(error, userContext, methodName) {
            if (error != null) {
                alert(error.get_message());
            }
        }
        function OnRequestComplete(result, userContext, methodName) {
            var ddObj = eval('(' + result + ')');

            var lbl = document.getElementById('<%= lblTerm.ClientID %>');
            lbl.innerHTML = ddObj.GridCaption;

            var div = document.getElementById('<%=divDetailData.ClientID %>');
            div.style.display = 'block';
            var ld = document.getElementById('divLoading');
            ld.style.display = 'none';
            div.innerHTML = ddObj.GridviewData;
        }    
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="portlet">
        <div class="portlet-header">
           Leads By Source
        </div>
        <div class="portlet-content">
            <div class="jqDateTbl" style="padding: 10px; float:right;">
           
                <asp:DropDownList ID="ddlQuickPickDate" runat="server" Font-Size="12pt">
                </asp:DropDownList>
                <asp:TextBox ID="txtDate1" runat="server" Size="8" MaxLength="10" Font-Size="12pt"></asp:TextBox>&nbsp;-&nbsp;<asp:TextBox
                    ID="txtDate2" runat="server" MaxLength="10" Size="8" Font-Size="12pt"></asp:TextBox>
                <small>
                    <asp:Button ID="btnApply" runat="server" Text="Refresh" CssClass="jqButton" Font-Size="8" style="float:none!important;"/></small>
          
            
            </div>
            <asp:GridView ID="gvLeadsBySource" runat="server" AutoGenerateColumns="false" GridLines="None"
                BorderStyle="None" AlternatingRowStyle-CssClass="altrow" Width="100%" DataSourceID="ds_LeadsBySource"
                ShowFooter="true" CellPadding="3">
                <Columns>
                    <asp:BoundField DataField="campaign" HeaderText="Campaign" HeaderStyle-HorizontalAlign="Left"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                    <asp:BoundField DataField="offer" HeaderText="Offer" HeaderStyle-HorizontalAlign="Left"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem" />
                    <asp:BoundField DataField="leads" HeaderText="Leads" HeaderStyle-HorizontalAlign="Right"
                        FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="leads_pct" HeaderText="Leads %" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                    <asp:BoundField DataField="dials" HeaderText="Dials" HeaderStyle-HorizontalAlign="Right"
                        FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="avgdials" HeaderText="Avg Dials" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:n1}" />
                    <asp:BoundField DataField="avgmin" HeaderText="Avg Min" HeaderStyle-HorizontalAlign="Right"
                        FooterStyle-CssClass="footeritem" HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="contacted" HeaderText="Contacted" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="contact_pct" HeaderText="Contact %" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                    <asp:BoundField DataField="leads_sold" HeaderText="Leads Sold" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="sold_pct" HeaderText="Leads Sold %" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" DataFormatString="{0:p1}" />
                    <asp:BoundField DataField="total_sold" HeaderText="Offers Sold" HeaderStyle-HorizontalAlign="Right"
                        HeaderStyle-CssClass="headitem" ItemStyle-CssClass="griditem" FooterStyle-CssClass="footeritem"
                        ItemStyle-HorizontalAlign="Right" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="ds_LeadsBySource" runat="server" ConnectionString="<%$ ConnectionStrings:IDENTIFYLEDB %>"
                SelectCommand="stp_LeadStatsBySource" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:Parameter Name="from" DbType="DateTime" />
                    <asp:Parameter Name="to" DbType="DateTime" />
                </SelectParameters>
            </asp:SqlDataSource>
            <p style="font-family: Tahoma; font-size: smaller; color:blue; padding-left:5px">
                Leads: Number of new leads only. DOES NOT include returning leads.<br />
                Leads Sold: Number of leads created and sold in the given date range.<br />
                Offers Sold: Total offers sold in the given date range.
            </p>
        </div>
    </div>
    <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
    <cc1:ModalPopupExtender ID="mpeData" runat="server" TargetControlID="dummyButton"
        PopupControlID="pnlPopup" BackgroundCssClass="modalBackgroundTracker" BehaviorID="programmaticModalPopupBehavior"
        RepositionMode="RepositionOnWindowResizeAndScroll" PopupDragHandleControlID="programmaticPopupDragHandle"
        Y="50">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupTracker" Style="display: none;
        border-collapse: collapse; width: 605px;">
        <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="height: 25px; cursor: move;
            background-color: #3D3D3D; border: solid 1px Gray; color: Black; text-align: center;
            padding-right: 1px;" ToolTip="Hold left mouse button to drag.">
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr class="headerstyle">
                    <td align="left" style="padding-left: 10px;">
                        <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Leads By Source Detail Data" />
                    </td>
                    <td align="right" style="padding-right: 5px;">
                        <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="return ClosePopup();"
                            ImageUrl="~/images/16x16_close.png" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <table class="entry" style="height: 100%; width: 100%;">
            <tr valign="top">
                <td style="height: 400px;">
                    <asp:Panel ID="pnlInfo" runat="server" CssClass="header">
                        <img src="~images/square-green.png" runat="server" align="absmiddle" alt="" /><asp:Label ID="lblTerm"
                            runat="server" Text="" Font-Size="12px" />
                    </asp:Panel>
                    <div id="divLoading" style="display: block; text-align: center; padding-top: 100px;"
                        class="entry">
                        Loading...<br />
                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/loading.gif" />
                    </div>
                    <div id="divDetailData" runat="server" style="height: 400px; display: none; width: 600px;
                        overflow: scroll;">
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right" style="background-color: #DCDCDC">
                    <table class="entry" border="0">
                        <tr>
                            <td align="right" style="background-color: #DCDCDC">
                                <table class="entry" border="0">
                                    <tr style="white-space: nowrap; font-size: 12px;">
                                        <td style="text-align: left; padding: 3px;">
                                            <asp:LinkButton ID="lnkExportExcel" runat="server" Text="Export to Excel" CssClass="lnk"
                                                OnClientClick="ExportExcel();" />
                                        </td>
                                        <td style="text-align: right; padding: 3px;">
                                            <asp:LinkButton ID="btnClose" runat="server" Text="Close" CssClass="lnk" OnClientClick="return ClosePopup();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>
