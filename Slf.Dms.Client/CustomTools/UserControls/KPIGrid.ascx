<%@ Control Language="VB" AutoEventWireup="false" CodeFile="KPIGrid.ascx.vb" Inherits="CustomTools_UserControls_KPIGrid" %>
<script type="text/javascript">
    function toggleDocument(docName, gridviewID) {
        var rowName = 'tr_' + docName
        var gv = document.getElementById(gridviewID);
        var rows = gv.getElementsByTagName('tr');
        for (var row in rows) {
            var rowID = rows[row].id
            if (rowID != undefined) {
                if (rowID.indexOf(rowName + '_child') != -1) {
                    rows[row].style.display = (rows[row].style.display != 'none' ? 'none' : '');
                } else if (rowID.indexOf(rowName + '_parent') != -1) {
                    var tree = rows[row].cells[0].children[0].src
                    rows[row].cells[0].children[0].src = (tree.indexOf('tree_plus') != -1 ? tree.replace('tree_plus', 'tree_minus') : tree.replace('tree_minus', 'tree_plus'));
                }
            }
        }
    }

</script>

	<asp:UpdatePanel ID="ud1" runat="server">
        <ContentTemplate>
            <div style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%;
                padding-top: 5px" style="font-size: 11px; font-family: Tahoma" id="holder">
                <asp:GridView ID="gvYear" runat="server" CssClass="entry2" AutoGenerateColumns="false" 
                 Caption="<div style='font-weight: bold;background-color:#3376AB;color:white;padding:3px;'>KPI Grid</div>">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <img id="imgTree" runat="server" src="~/images/tree_plus.bmp" />
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" CssClass="headItem5" />
                            <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="kpiyear" SortExpression="kpiyear" HeaderText="KPI Year"
                            HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem" />
                        <asp:BoundField DataField="TotalInboundCalls" SortExpression="TotalInboundCalls"
                            HeaderText="Total Inbound Calls" HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem"
                            HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalInternet" SortExpression="TotalInternet" HeaderText="Total Internet"
                            HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalLeads" SortExpression="TotalLeads" HeaderText="Total Leads"
                            HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalSystemCalls" SortExpression="TotalSystemCalls" HeaderText="Total System Calls"
                            HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalAppointments" SortExpression="TotalAppointments"
                            HeaderText="Total Appts" HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem"
                            HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalCallsAnswered" SortExpression="TotalCallsAnswered"
                            HeaderText="Total Calls Answered" HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem"
                            HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="NumCasesAgainstMarketingDollars" SortExpression="NumCasesAgainstMarketingDollars"
                            HeaderText="Cases Against Marketing Dollars" HeaderStyle-CssClass="headitem5"
                            ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="ConversionPercent" SortExpression="ConversionPercent"
                            HeaderText="Conversion %" HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem"
                            HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="MarketingBudgetSpentPerDay" SortExpression="MarketingBudgetSpentPerDay"
                            DataFormatString="{0:c}" HeaderText="Marketing Budget Spent Per Day" HeaderStyle-CssClass="headitem5"
                            ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="MarketingBudgetPerDay" SortExpression="MarketingBudgetPerDay"
                            DataFormatString="{0:c}" HeaderText="Marketing Budget Per Day" HeaderStyle-CssClass="headitem5"
                            ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="CostPerConversionDay" SortExpression="CostPerConversionDay"
                            HeaderText="Cost Per Conversion Day" HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem"
                            HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TotalNumCases" SortExpression="TotalNumCases" HeaderText="Total Cases"
                            HeaderStyle-CssClass="headitem5" ControlStyle-CssClass="listitem" HeaderStyle-HorizontalAlign="Center" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="dsKPI" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    SelectCommandType="StoredProcedure" SelectCommand="stp_SmartDebtor_KPI_Grouping"
                    ProviderName="System.Data.SqlClient" EnableCaching="True">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="1/18/2007 12:00:00 AM" Name="startDate" Type="DateTime" />
                        <asp:Parameter DefaultValue="" Name="endDate" Type="DateTime" />
                        <asp:Parameter DefaultValue="y" Name="kpiGroupType" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div id="updateProcessingProgressDiv" style="display: none; height: 40px; width: 40px">
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
                </div>
            </div>
        </ContentTemplate>
	<Triggers>
		<asp:AsyncPostBackTrigger ControlID="ddlQuickPickDate" EventName="SelectedIndexChanged">
		</asp:AsyncPostBackTrigger>
		<asp:AsyncPostBackTrigger ControlID="ddlTelemarketer" EventName="SelectedIndexChanged">
		</asp:AsyncPostBackTrigger>
		<asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click"></asp:AsyncPostBackTrigger>
	</Triggers>
</asp:UpdatePanel>

<script type="text/javascript">
	function onUpdating() {
		// get the update progress div
		var updateProgressDiv = $get('updateProcessingProgressDiv');
		// make it visible
		updateProgressDiv.style.display = '';

		//  get the gridview element
		var gridView = $get('holder');

		// get the bounds of both the gridview and the progress div
		var gridViewBounds = Sys.UI.DomElement.getBounds(gridView);
		var updateProgressDivBounds = Sys.UI.DomElement.getBounds(updateProgressDiv);

		//    do the math to figure out where to position the element (the center of the gridview)
		var x = gridViewBounds.x + Math.round(gridViewBounds.width / 2) - Math.round(updateProgressDivBounds.width / 2);
		var y = gridViewBounds.y + Math.round(gridViewBounds.height / 2) - Math.round(updateProgressDivBounds.height / 2);

		//    set the progress element to this position
		Sys.UI.DomElement.setLocation(updateProgressDiv, x, y);
	}

	function onUpdated() {
		// get the update progress div
		var updateProgressDiv = $get('updateProcessingProgressDiv');
		// make it invisible
		updateProgressDiv.style.display = 'none';
	}


</script>

<ajaxToolkit:UpdatePanelAnimationExtender ID="upaeprocessing" BehaviorID="processinganimation"
	runat="server" TargetControlID="ud1">
	<Animations>
		<OnUpdating>
			<Parallel duration="0">
				<ScriptAction Script="onUpdating();" />  
				<FadeOut minimumOpacity=".5" />
			 </Parallel>
		</OnUpdating>
		<OnUpdated>
			<Parallel duration="0">
				<FadeIn minimumOpacity=".5" />
				<ScriptAction Script="onUpdated();" /> 
			</Parallel> 
		</OnUpdated>
	</Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
