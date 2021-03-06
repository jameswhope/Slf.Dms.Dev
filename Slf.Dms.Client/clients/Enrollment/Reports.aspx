<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Reports.aspx.vb"
	Inherits="Clients_Enrollment_Reports" Title="Client Intake Reports" EnableViewState="true" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebToolbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
	Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

	<script type="text/javascript">

		function SetDates(ddl) {
			var txtTransDate1 = document.getElementById("<%=txtStart.ClientId %>");
			var txtTransDate2 = document.getElementById("<%=txtEnd.ClientId %>");

			var str = ddl.value;
			if (str != "Custom") {
				var parts = str.split(",");
				txtTransDate1.value = parts[0];
				txtTransDate2.value = parts[1];
			}
		}
		function Setddls() {
			var ddlReports = document.getElementById("<%= ddlReports.ClientID %>");
			var ddlScreener = document.getElementById("<%= ddlScreener.ClientID %>");
			var ddlTelemarketer = document.getElementById("<%= ddlTelemarketer.ClientID %>");
			var ddlDNIS = document.getElementById("<%= ddlDNIS.ClientID %>");
			var tblDate = document.getElementById("<%= tblDates.ClientID %>");

			var tbl = document.getElementById("<%= tblClient.ClientID %>");
			var td1 = document.getElementById("<%= td1.ClientID %>");
			var td2 = document.getElementById("<%= tblDates.ClientID %>");
			var tdDNIS = document.getElementById("<%= tdDNIS.ClientID %>");

			if (ddlReports.value == "All Client Information Report" || ddlReports.value == "Select a Report") {
				tbl.style.display = 'none';
				td1.style.display = 'none';
				td2.style.display = 'none';
				tdDNIS.style.display = 'none';
			} else {
				tbl.style.display = 'block';
				td1.style.display = 'block';
				td2.style.display = 'block';
				tdDNIS.style.display = 'block';
			}

			if (ddlReports.value == "Rep. Commission Report") {
				tdDNIS.style.display = 'none';
				ddlScreener.disabled = false;
				ddlTelemarketer.disabled = true;
			}
			if (ddlReports.value == "Consultant Comm. Report") {
				tdDNIS.style.display = 'none';
				ddlScreener.disabled = true;
				ddlTelemarketer.disabled = false;
			}
			if (ddlReports.value == "Bounced/Canceled Report") {
				tdDNIS.style.display = 'none';
				ddlScreener.disabled = true;
				ddlTelemarketer.disabled = false;
			}
			if (ddlReports.value == "Pipe Line Report") {
				tdDNIS.style.display = 'none';
				ddlScreener.disabled = false;
				ddlTelemarketer.disabled = false;
			}
			if (ddlReports.value == "Cancellation Report") {
				tdDNIS.style.display = 'none';
				ddlScreener.disabled = true;
				ddlTelemarketer.disabled = false;
			}
			if (ddlReports.value == "KPI Report") {
				tdDNIS.style.display = 'none';
				tbl.style.display = 'none';
				td1.style.display = 'none';
				ddlScreener.disabled = true;
				ddlTelemarketer.disabled = true;
			}
			if (ddlReports.value == "Lead DNIS Report") {
				tdDNIS.style.display = 'block';
				tbl.style.display = 'none';
				td1.style.display = 'none';
				ddlScreener.disabled = true;
				ddlTelemarketer.disabled = true;
            }
            if (ddlReports.value == "KPI") {
                tdDNIS.style.display = 'none';
                tbl.style.display = 'none';
                td1.style.display = 'none';
                td2.style.display = 'none';
                ddlScreener.disabled = true;
                ddlTelemarketer.disabled = true;
            }
            if ((ddlReports.value == "Lead Deposit Analysis") || (ddlReports.value == "Deposits By Hire Date")) {
                tdDNIS.style.display = 'none';
                tbl.style.display = 'none';
                td1.style.display = 'none';
                td2.style.display = 'none';
                ddlScreener.disabled = true;
                ddlTelemarketer.disabled = true;
            }
            if (ddlReports.value == "Pending Clients") {
                tdDNIS.style.display = 'none';
                tbl.style.display = 'none';
                td1.style.display = 'none';
                td2.style.display = 'none';
                ddlScreener.disabled = true;
                ddlTelemarketer.disabled = true;
            }
            if (ddlReports.value == "Lead Dashboard (Agency Reps)") {
                tdDNIS.style.display = 'none';
                tbl.style.display = 'none';
                td1.style.display = 'none';
                td2.style.display = 'none';
                ddlScreener.disabled = true;
                ddlTelemarketer.disabled = true;
            }
		}
	</script>

	<style type="text/css">
		.paramHdr
		{
			background-color: #3376AB;
			color: white;
		}
	</style>
	<ajaxToolkit:ToolkitScriptManager ID="sm1" runat="server"  AsyncPostBackTimeOut="36000">
	</ajaxToolkit:ToolkitScriptManager>
<%--
	<asp:UpdatePanel ID="ud1" runat="server">
		<ContentTemplate>
--%>
	<asp:Panel runat="server" ID="pnlMenuDefault">
		<table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
			<tr>
				<td nowrap="nowrap" id="tdSave" runat="server">
					<igtbar:UltraWebToolbar ID="uwToolBar" runat="server" BackgroundImage="" ImageDirectory=""
						ItemWidthDefault="90px" Width="100%" Font-Names="Tahoma" Font-Size="11px">
						<HoverStyle Cursor="Hand">
						</HoverStyle>
						<DefaultStyle Cursor="Hand">
						</DefaultStyle>
						<ButtonStyle Cursor="Hand">
						</ButtonStyle>
						<LabelStyle Cursor="Hand" />
						<Items>
							<igtbar:TBarButton DisabledImage="" HoverImage="" Image="~/images/16x16_back.png"
								SelectedImage="" Text="Back" Tag="back" DefaultStyle-Width="50px">
								<Images>
									<DefaultImage Url="~/images/16x16_back.png" />
								</Images>
								<DefaultStyle Width="50px">
								</DefaultStyle>
							</igtbar:TBarButton>
						</Items>
					</igtbar:UltraWebToolbar>
				</td>
			</tr>
		</table>
	</asp:Panel>
	
	<div style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%;
		padding-top: 5px" style="font-size: 11px; font-family: Tahoma" id="holder">
		<div style="overflow: auto">
			<table style="table-layout: fixed; font-size: 11px; width: 100%; font-family: tahoma;
				height: 100%" cellspacing="0" cellpadding="0" border="0">
				<tbody>
					<tr>
						<td>
							<table class="entry">
								<tr valign="top">
									<td style="width: 15%;">
										<table class="entry" style="background-color: #F0E68C">
											<tr>
												<td class="paramHdr">
													Choose a Report:
												</td>
											</tr>
											<tr>
												<td>
													<asp:DropDownList ID="ddlReports" runat="server" Font-Names="Tahoma" Font-Size="11px"
														Width="150px" />
												</td>
											</tr>
											<tr>
												<td>
													<table id="tblClient" runat="server" class="entry">
														<tr>
															<td class="paramHdr">
																Law Firm Rep.:
															</td>
														</tr>
														<tr>
															<td>
																<asp:DropDownList ID="ddlScreener" Style="font-size: 11px; font-family: Tahoma" runat="server" />
															</td>
														</tr>
													</table>
													<table id="Td1" runat="server" class="entry">
														<tr>
															<td class="paramHdr">
																Consultant:
															</td>
														</tr>
														<tr>
															<td>
																<asp:DropDownList ID="ddlTelemarketer" Style="font-size: 11px; font-family: Tahoma"
																	runat="server" />
															</td>
														</tr>
													</table>
													<table id="tdDNIS" runat="server" class="entry">
														<tr>
															<td class="paramHdr">
																DNIS:
															</td>
														</tr>
														<tr>
															<td>
																<div style="overflow: auto; height: 200px;">
																	<asp:CheckBoxList ID="ddlDNIS" runat="server" class="entry2">
																	</asp:CheckBoxList>
																</div>
															</td>
														</tr>
													</table>
													<table id="tblDates" runat="server" class="entry">
														<tr>
															<td class="paramHdr">
																Date Range:
															</td>
														</tr>
														<tr>
															<td>
																<table style="font-size: 11px; font-family: Tahoma">
																	<tbody>
																		<tr style="font-size: 8pt">
																			<td style="white-space: nowrap;">
																				<asp:DropDownList Style="font-size: 11px; font-family: Tahoma" ID="ddlQuickPickDate"
																					runat="server" AutoPostBack="false" onchange="SetDates(this);" >
																				</asp:DropDownList>
																			</td>
																		</tr>
																		<tr>
																			<td>
																				<asp:Label ID="Label1" runat="server" Text="Start:"></asp:Label>
																			</td>
																			<td style="white-space: nowrap;">
																				<asp:TextBox ID="txtStart" runat="server" Font-Size="8pt" Width="50"></asp:TextBox>
																				<asp:ImageButton ID="Image1" runat="Server" AlternateText="Click to show calendar"
																					ImageUrl="~/images/Calendar_scheduleHS.png"></asp:ImageButton>
																				<ajaxToolkit:CalendarExtender ID="extStart" runat="server" CssClass="MyCalendar"
																					PopupButtonID="image1" TargetControlID="txtStart">
																				</ajaxToolkit:CalendarExtender>
																			</td>
																		</tr>
																		<tr>
																			<td style="white-space: nowrap;">
																				End:
																			</td>
																			<td style="white-space: nowrap;">
																				<asp:TextBox ID="txtEnd" runat="server" Font-Size="8pt" Width="50"></asp:TextBox>
																				<asp:ImageButton ID="ImageButton1" runat="Server" AlternateText="Click to show calendar"
																					ImageUrl="~/images/Calendar_scheduleHS.png"></asp:ImageButton>
																				<ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" CssClass="MyCalendar"
																					PopupButtonID="ImageButton1" TargetControlID="txtEnd">
																				</ajaxToolkit:CalendarExtender>
																			</td>
																		</tr>
																	</tbody>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td style="background-color: #D6E7F3">
													<asp:LinkButton Width="100%" ID="lnkView" runat="server" Font-Size="Medium" Style="text-align: center;"
														CssClass="gridButton">View</asp:LinkButton>
												</td>
											</tr>
										</table>
									</td>
									<td rowspan="2">
									    
										<div id="dvMsg" runat="server" style="display: none;">
										</div>
										<div style="overflow: auto; width: 100%; height: 600px">
											<rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Size="8pt" Width="100%"
												Height="100%" Font-Names="tahoma" ProcessingMode="Remote" >
												<ServerReport ReportServerUrl="" />
											</rsweb:ReportViewer>
										</div>
										
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
<%--	
	<div id="updateProcessingProgressDiv" style="display: none; height: 40px; width: 40px">
		<asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
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
				<EnableAction AnimationTarget="lnkView" Enabled="false" />
				<EnableAction AnimationTarget="tb1" Enabled="false" />
                
				<FadeOut minimumOpacity=".5" />
			 </Parallel>
		</OnUpdating>
		<OnUpdated>
			<Parallel duration="0">
				<FadeIn minimumOpacity=".5" />

				<EnableAction AnimationTarget="lnkView" Enabled="true" />
				<EnableAction AnimationTarget="tb1" Enabled="true" />

				<ScriptAction Script="onUpdated();" /> 
			</Parallel> 
		</OnUpdated>
	</Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
--%>
</asp:Content>
