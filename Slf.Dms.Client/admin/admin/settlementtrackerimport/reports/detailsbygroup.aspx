<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="detailsbygroup.aspx.vb" Inherits="admin_settlementtrackerimport_reports_detailsbygroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">
    function ExportExcel() {
        try{
            var oExcel = new ActiveXObject("Excel.Application"); 
            var oBook = oExcel.Workbooks.Add; 
            var oSheet = oBook.Worksheets(1); 
            var detailsTable = document.getElementById('tblDetail');
            for (var y=0;y<detailsTable.rows.length;y++) { 
                for (var x=0;x<detailsTable.rows(y).cells.length;x++) { 
                    oSheet.Cells(y+1,x+1) = detailsTable.rows(y).cells(x).innerText; 
                } 
            } 
            oExcel.Visible = true; 
            oExcel.UserControl = true; 
        }
        catch(e){
            alert('There was a problem exporting to Excel, make sure you have Excel installed.');
        }
    }
    function ShowDetailData(detailData) {
        var ld = document.getElementById('divLoading');
        ld.style.display = 'block';

        var div = document.getElementById('<%=divDetailData.ClientID %>');
        div.style.display = 'none';

        //get accounts
        PageMethods.PM_getDetailData(detailData, OnRequestComplete, OnRequestError);
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

    function MonthChanged(monthSelect) {
        var chosenoption = monthSelect.options[monthSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnMonth.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeMonth, nothing) %>;
        }

    }
    function YearChanged(YearSelect) {
        var chosenoption = YearSelect.options[YearSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnYear.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeYear, nothing) %>;
        }
       }
  function GroupChanged(GroupSelect) {
        var chosenoption = GroupSelect.options[GroupSelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnGroup.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeGroup, nothing) %>;
        }
       }       
    
    </script>

    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/default.aspx">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/default.aspx">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;<asp:Label ID="lblGroupInfo" runat="server" Text="Details By Group" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:GridView ID="gvDetailGroups" runat="server" DataSourceID="dsDetailGroups" CssClass="entry"
                    AutoGenerateColumns="false" AllowSorting="true" ShowFooter="true">
                    <Columns>
                        <asp:BoundField DataField="TeamName" HeaderText="TeamName" SortExpression="TeamName"
                            HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" />
                        <asp:BoundField DataField="TotalFees" HeaderText="Total Fees" SortExpression="TotalFees"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="TotalBalance" HeaderText="Total Bal" SortExpression="TotalBalance"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="TotalSettAmt" HeaderText="Total Sett Amt" SortExpression="TotalSettAmt"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="TotalUnits" HeaderText="Total Units" SortExpression="TotalUnits"
                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" FooterStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalAvgPct" HeaderText="Total Avg %" SortExpression="TotalAvgPct"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:p2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PaidFees" HeaderText="Paid Fees" SortExpression="PaidFees"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PaidBalance" HeaderText="Paid Bal" SortExpression="PaidBalance"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PaidSettAmt" HeaderText="Paid Sett Amt" SortExpression="PaidSettAmt"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PaidUnits" HeaderText="Paid Units" SortExpression="PaidUnits"
                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" FooterStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="PaidAvgFee" HeaderText="Paid Avg Fee" SortExpression="PaidAvgFee"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:c2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PaidAvgPct" HeaderText="Paid Avg %" SortExpression="PaidAvgPct"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:p2}" FooterStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="PctPaid" HeaderText="% Paid" SortExpression="PctPaid"
                            HeaderStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="headitem5"
                            ItemStyle-CssClass="listItem" DataFormatString="{0:p2}" FooterStyle-HorizontalAlign="Right" />
                    </Columns>
                    <FooterStyle BackColor="Bisque" />
                    <EmptyDataTemplate>
                        No Data
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="dsDetailGroups" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" Type="Int32" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    
    <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender ID="mpeData" runat="server" TargetControlID="dummyButton"
        PopupControlID="pnlPopup" BackgroundCssClass="modalBackgroundTracker"
        BehaviorID="programmaticModalPopupBehavior" RepositionMode="RepositionOnWindowResizeAndScroll"
        PopupDragHandleControlID="programmaticPopupDragHandle" Y="50" >
    </ajaxToolkit:ModalPopupExtender>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupTracker" Style="display: none;
        border-collapse: collapse;width:100%">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #3D3D3D;border: solid 1px Gray; color: Black; text-align: center;width:100%;" ToolTip="Hold left mouse button to drag.">
                    <div id="dvCloseMenu" runat="server" onmouseover="this.style.cursor='hand';"
                        style="padding: 3px; width: 100%; background-color: #3D3D3D; z-index: 51; text-align: right;
                        vertical-align: middle; border-collapse: collapse;" ondblclick="return ClosePopup();">
                        <div style="float: left; color: White;">
                            Details For Group</div>
                        <asp:Image ID="imgClose" runat="server" ImageUrl="~/images/16x16_close.png" onclick="return ClosePopup();" />
                    </div>
                </asp:Panel>
                <table class="entry" style="height: 100%">
                    <tr valign="top">
                        <td style="height: 400px;">
                            <asp:Panel ID="pnlInfo" runat="server" CssClass="entry" Style="background-color: #66CCFF;">
                                <asp:Label ID="lblTerm" runat="server" Text="" Font-Size="12px" />
                            </asp:Panel>
                                                        
                            <div id="divLoading" style="display: block; text-align: center; padding-top: 100px;"
                                class="entry">
                                Loading...<br />
                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/loading.gif" />
                            </div>
                            <div id="divDetailData" runat="server" style="height: 400px; width:100%; overflow-y: scroll;overflow-x: hidden;display: none;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color: #DCDCDC">
                            <table class="entry" border="0">
                                <tr style="white-space: nowrap; font-size: 12px;">
                                    <td style="text-align:left; padding:3px;">
                                        <asp:LinkButton ID="lnkExportExcel" runat="server" Text="Export to Excel" CssClass="lnk" OnClientClick="ExportExcel();" />
                                    </td>
                                    <td style="text-align:right; padding:3px;">
                                        <asp:LinkButton ID="btnClose" runat="server" Text="Close" CssClass="lnk" OnClientClick="return ClosePopup();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:HiddenField ID="hdnGroup" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
    <asp:LinkButton ID="lnkChangeGroup" runat="server" />
</asp:Content>
