<%@ Control Language="VB" AutoEventWireup="false" CodeFile="harassment.ascx.vb" Inherits="Clients_Creditors_harassment" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDateChooser.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebSchedule" TagPrefix="igsch" %>
<%@ Register Assembly="Infragistics2.WebUI.WebDataInput.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<%@ Register Assembly="Infragistics2.WebUI.WebCombo.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.WebCombo" TagPrefix="igcmbo" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebListbar.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
	Namespace="Infragistics.WebUI.UltraWebListbar" TagPrefix="iglbar" %>
<asp:LinkButton ID="lnkShow" runat="server" Text="Create Harassment Form"></asp:LinkButton>
<asp:Panel ID="Panel1" runat="server" ScrollBars="None" CssClass="modalPopup" Style="display: none;">
	<asp:UpdateProgress ID="upHarass" runat="server" AssociatedUpdatePanelID="pnlUpdate">
		<ProgressTemplate>
			<div id="processMessage" style="position: absolute; top: 45%; left: 35%; width: 150px;
				height: 75px; color: Black; background-color: White; border: solid 1px black;">
				<div style="text-align: center; vertical-align: middle;">
					<br />
					Saving Form...
					<br />
					<asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/bigloading.gif" />
				</div>
			</div>
		</ProgressTemplate>
	</asp:UpdateProgress>
	<asp:UpdatePanel ID="pnlUpdate" runat="server">
		<ContentTemplate>
			<asp:Panel ID="pnlPopHdrHarass" runat="server" Style="display: block;">
				<table style="table-layout: fixed; width: 100%;" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td class="igdw_HeaderContent" style="overflow: hidden; white-space: nowrap" align="left">
								<span class="igdw_HeaderCaption">Client Debt Collection Abuse Intake Form</span>
							</td>
						</tr>
					</tbody>
				</table>
			</asp:Panel>
			<asp:Panel ID="Panel2" runat="server" Style="display: block; height: 650px; width: 100%;"
				ScrollBars="Auto">
				<igmisc:WebPanel ID="pnlInfo" runat="server" Width="99%" ExpandEffect="None" EnableAppStyling="True"
					StyleSetName="Nautilus">
					<Header Text="Client Info" TextAlignment="Left">
					</Header>
					<Template>
						<table width="100%" border="0">
							<tr>
								<td align="right">
									Client Account Number :
								</td>
								<td align="left">
									<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" runat="server"
										ID="txtAcctNum_8_String" CellSpacing="1" UseBrowserDefaults="False" Width="200px">
									</igtxt:WebTextEdit>
								</td>
							</tr>
							<tr>
								<td align="right">
									Card Holder's Name :
								</td>
								<td align="left">
									<asp:DropDownList ID="cboCardHolderName_9_string" runat="server" Width="75%" />
								</td>
							</tr>
							<tr>
								<td align="right">
									State :
								</td>
								<td align="left">
									<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtStateName_132_string"
										runat="server">
									</igtxt:WebTextEdit>
								</td>
							</tr>
							<tr>
								<td align="right">
									Contact Date :
								</td>
								<td align="left">
									<igsch:WebDateChooser ID="dteAbuse_133_string" runat="server" Width="200px" Value=""
										EnableAppStyling="True" StyleSetName="Nautilus">
										<CalendarLayout ChangeMonthToDateClicked="True">
										</CalendarLayout>
									</igsch:WebDateChooser>
								</td>
							</tr>
							<tr>
								<td align="right">
									Original Creditor :
								</td>
								<td align="left">
									<asp:DropDownList ID="cboOrigCreditor" runat="server" Width="75%" />
								</td>
							</tr>
							<tr>
								<td align="right">
									Have you been sued by this Creditor?
								</td>
								<td align="left">
									<asp:RadioButtonList ID="radSued" runat="server" RepeatDirection="Horizontal">
										<asp:ListItem>Yes</asp:ListItem>
										<asp:ListItem>No</asp:ListItem>
									</asp:RadioButtonList>
								</td>
							</tr>
							<tr>
								<td align="right">
									Debt Collector :
								</td>
								<td align="left">
									<asp:DropDownList ID="cboDebtCollector_137_string" runat="server" Width="75%" />
								</td>
							</tr>
							<tr>
								<td align="right">
									Individual Calling :
								</td>
								<td align="left">
									<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtSpokeIndividualCalling_135_String"
										runat="server" Width="200px">
									</igtxt:WebTextEdit>
								</td>
							</tr>
							<tr id="trIndividualCalling">
								<td>
								</td>
								<td align="left">
									<asp:CheckBoxList ID="cblSpokeCallingIndividual_16_array" runat="server">
										<asp:ListItem Text="Identified themselves as a bill collector" />
										<asp:ListItem Text="Claimed to be law enforcement or connected with federal, state or local government" />
										<asp:ListItem Text="Claimed to be an Attorney or with an Attorney's office" />
										<asp:ListItem Text="Claimed to be employed by a Credit Bureau" />
										<asp:ListItem Text="Other" />
									</asp:CheckBoxList>
									<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtSpokeCallingIndividualOther_17_string"
										runat="server" Width="200px">
									</igtxt:WebTextEdit>
								</td>
							</tr>
							<tr>
								<td align="right">
									Phone # of Caller :
								</td>
								<td align="left">
									<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtSpokeCallingIndividualPhone_136_string"
										runat="server" InputMask="(###) ###-####" Width="100px" PromptChar="#">
									</igtxt:WebMaskEdit>
								</td>
							</tr>
							<tr>
								<td align="right">
									Date of Abuse :
								</td>
								<td align="left">
									<igsch:WebDateChooser ID="dteSpokeCallingIndividualDateOfAbuse_19_string" runat="server"
										Editable="True" Width="100px" MaxDate="1/1/2099 12:00:00 AM" NullValueRepresentation="NotSet"
										EnableAppStyling="True" StyleSetName="Nautilus">
									</igsch:WebDateChooser>
								</td>
							</tr>
							<tr>
								<td align="right">
									Number of times called :
								</td>
								<td align="left">
									<igtxt:WebNumericEdit ID="txtSpokeCallingIndividualNumTimesCalled_20_string" runat="server"
										DataMode="Int" MaxValue="50" MinValue="0" UseBrowserDefaults="False" ValueText="0"
										Width="115px" EnableAppStyling="True" StyleSetName="Nautilus">
										<SpinButtons DefaultTriangleImages="ArrowSmall" Display="OnRight" Width="15px" />
									</igtxt:WebNumericEdit>
								</td>
							</tr>
							<tr>
								<td align="right">
									Time :
								</td>
								<td align="left">
									<igtxt:WebDateTimeEdit ID="iSpokeCallingIndividualTime_21_string" runat="server"
										CellSpacing="1" DisplayModeFormat="hh:mm tt" EditModeFormat="hh:mm tt" UseBrowserDefaults="False"
										Width="115px" DataMode="Text" Enabled="True" EnableAppStyling="True" StyleSetName="Nautilus">
										<SpinButtons DefaultTriangleImages="ArrowSmall" Display="OnRight" Width="15px" />
									</igtxt:WebDateTimeEdit>
								</td>
							</tr>
						</table>
					</Template>
				</igmisc:WebPanel>
				<igmisc:WebPanel ID="pnlReasons" runat="server" Width="99%" ExpandEffect="None" EnableAppStyling="True"
					StyleSetName="Nautilus">
					<Header Text="Harassment Info (Choose One)" TextAlignment="Left">
					</Header>
					<PanelStyle>
						<Padding Left="25px" />
					</PanelStyle>
					<Template>
						<div id="dvError" runat="server" style="display: none; background-color: #ffffda;
							border: solid 1px #969696; font-family: tahoma; font-size: 11px; width: 100%;
							color: red">
							No Reason Selected!!!
						</div>
						<iglbar:UltraWebListbar EnableAppStyling="True" StyleSetName="Nautilus" ID="lbreasons_27_string"
							runat="server" Width="100%" GroupExpandEffect="None" ViewType="ExplorerBar" HeaderClickAction="ExpandOnClick"
							KeepInView="No" ClientSideEvents-AfterGroupExpanded="lbreasons_AfterGroupExpanded">
							<AutoPostBack GroupClicked="False" GroupCollapsed="False" GroupExpanded="False" ItemClicked="False" />
							<ClientSideEvents AfterGroupExpanded="lbreasons_AfterGroupExpanded" />
							<Groups>
								<iglbar:Group Text="I spoke to the person who called" Expanded="true" Tag="spoke">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										No additional reasons needed.
									</Template>
								</iglbar:Group>
								<iglbar:Group Text="The person who called Left a Message" Expanded="false" Tag="msg">
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										No additional reasons needed.
									</Template>
									<Labels Collapsed="" Expanded="" Selected="" />
								</iglbar:Group>
								<iglbar:Group Text="Received Mail" Expanded="false" Tag="mail">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										<asp:CheckBoxList ID="cblMail_31_string" Font-Size="X-Small" runat="server">
											<asp:ListItem>By postcard</asp:ListItem>
											<asp:ListItem>Using words or symbols on the outside of the envelope they indicated they were trying to collect a debt.</asp:ListItem>
											<asp:ListItem>That looked like it was from a court or attorney but was not.</asp:ListItem>
										</asp:CheckBoxList>
									</Template>
								</iglbar:Group>
								<iglbar:Group Text="The person came to my door" Expanded="false" Tag="door">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										No additional reasons needed.
									</Template>
								</iglbar:Group>
							</Groups>
						</iglbar:UltraWebListbar>
						<asp:Label ID="label1" runat="server">
                            Describe in full detail contact with creditor :
						</asp:Label>
						<asp:TextBox ID="txtDoorContactInfo_32_string" runat="server" Height="100px" TextMode="MultiLine"
							Width="97%">
						</asp:TextBox>
					</Template>
				</igmisc:WebPanel>
				<igmisc:WebPanel ID="pnlAdditional" runat="server" Width="99%" ExpandEffect="None"
					EnableAppStyling="True" StyleSetName="Nautilus">
					<Header Text="THE COLLECTION ABUSE MAY FALL INTO ONE OR MORE OF THESE CATEGORIES.  PLEASE NOTE ALL APPLICABLE"
						TextAlignment="Center">
						<ExpandedAppearance>
							<Styles Font-Size="xX-Small" Height="30px">
							</Styles>
						</ExpandedAppearance>
					</Header>
					<PanelStyle>
						<Padding Left="25px" />
					</PanelStyle>
					<Template>
						<iglbar:UltraWebListbar EnableAppStyling="True" StyleSetName="Nautilus" ID="lbAdditional"
							runat="server" Width="100%" GroupExpandEffect="None" ViewType="ExplorerBar" HeaderClickAction="ExpandOnClick"
							KeepInView="No">
							<AutoPostBack GroupClicked="False" GroupCollapsed="False" GroupExpanded="False" ItemClicked="False" />
							<Groups>
								<iglbar:Group Key="36_array" Text="Collector is calling you at home (before 8am or after 9pm)"
									Expanded="false" Tag="home">
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										No additional reasons needed.
									</Template>
									<Labels Collapsed="" Expanded="" Selected="" />
								</iglbar:Group>
								<iglbar:Group Key="38_array" Text="Collector is calling you at work" Expanded="false"
									Tag="work">
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										No additional reasons needed.
									</Template>
									<Labels Collapsed="" Expanded="" Selected="" />
								</iglbar:Group>
								<iglbar:Group Key="40_array" Text="Collector is contacting third-parties with information regarding your debt(s)"
									Expanded="false" Tag="third">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										<iglbar:UltraWebListbar EnableAppStyling="True" StyleSetName="Nautilus" ID="lbThirdParties"
											runat="server" Width="100%" GroupExpandEffect="None" ViewType="ExplorerBar" HeaderClickAction="ExpandOnClick">
											<Groups>
												<iglbar:Group Key="43_array" Text="Employer" Expanded="false" Tag="employer">
													<Template>
														<table border="0" width="98%" style="font-size: x-small;">
															<tr>
																<td align="right">
																	Contacted Persons Name :
																</td>
																<td>
																	<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdEmployerContactName_44_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebTextEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	Contacted Persons Number :
																</td>
																<td>
																	<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdEmployerContactPhone_45_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		InputMask="(###) ###-####" PromptChar="#" UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebMaskEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	May we contact them :
																</td>
																<td align="left">
																	<asp:RadioButtonList Font-Size="X-Small" ID="rblThirdEmployerMayWeContact_48_string"
																		runat="server" RepeatDirection="Horizontal">
																		<asp:ListItem>Yes</asp:ListItem>
																		<asp:ListItem>No</asp:ListItem>
																	</asp:RadioButtonList>
																</td>
															</tr>
															<tr>
																<td align="right" valign="top">
																	What happened? :
																</td>
																<td>
																	<asp:CheckBoxList Font-Size="X-Small" ID="cblThirdEmployerWhatHappened_50_array"
																		runat="server">
																		<asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
																		<asp:ListItem>Stated that you owed them a debt</asp:ListItem>
																		<asp:ListItem>Contacted Employer more than once when they were not requested to do so even though the Employer had given correct information</asp:ListItem>
																		<asp:ListItem>Communicated by postcard</asp:ListItem>
																		<asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
																	</asp:CheckBoxList>
																</td>
															</tr>
														</table>
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
												<iglbar:Group Key="51_array" Text="Co-Workers" Expanded="false" Tag="coworker">
													<Template>
														<table border="0" width="98%" style="font-size: x-small;">
															<tr>
																<td align="right">
																	Contacted Persons Name :
																</td>
																<td>
																	<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdCoWorkerContactName_52_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebTextEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	Contacted Persons Number :
																</td>
																<td>
																	<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdCoWorkerContactPhone_53_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		InputMask="(###) ###-####" PromptChar="#" UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebMaskEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	May we contact them :
																</td>
																<td align="left">
																	<asp:RadioButtonList Font-Size="X-Small" ID="rblThirdCoWorkerMayWeContact_54_string"
																		runat="server" RepeatDirection="Horizontal">
																		<asp:ListItem>Yes</asp:ListItem>
																		<asp:ListItem>No</asp:ListItem>
																	</asp:RadioButtonList>
																</td>
															</tr>
															<tr>
																<td align="right" valign="top">
																	What happened? :
																</td>
																<td>
																	<asp:CheckBoxList Font-Size="X-Small" ID="cblThirdCoWorkerWhatHappened_55_array"
																		runat="server">
																		<asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
																		<asp:ListItem>Stated that you owed them a debt</asp:ListItem>
																		<asp:ListItem>Contacted Co-Worker more than once when they were not requested to do so even though the Co-Worker had given correct information</asp:ListItem>
																		<asp:ListItem>Communicated by post card</asp:ListItem>
																		<asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
																	</asp:CheckBoxList>
																</td>
															</tr>
														</table>
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
												<iglbar:Group Key="70_array" Text="Neighbors" Tag="Neighbors">
													<Template>
														<table border="0" width="98%" style="font-size: x-small;">
															<tr>
																<td align="right">
																	Contacted Persons Name :
																</td>
																<td>
																	<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdNeighborsContactName_64_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebTextEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	Contacted Persons Number :
																</td>
																<td>
																	<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdNeighborsContactPhone_65_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		InputMask="(###) ###-####" UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebMaskEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	May we contact them :
																</td>
																<td align="left">
																	<asp:RadioButtonList ID="rblThirdNeighborsMayWeContact_66_string" runat="server"
																		RepeatDirection="Horizontal">
																		<asp:ListItem>Yes</asp:ListItem>
																		<asp:ListItem>No</asp:ListItem>
																	</asp:RadioButtonList>
																</td>
															</tr>
															<tr>
																<td align="right" valign="top">
																	What happened? :
																</td>
																<td>
																	<asp:CheckBoxList ID="cblThirdNeighborsWhatHappened_67_array" runat="server">
																		<asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
																		<asp:ListItem>Stated that you owed them a debt</asp:ListItem>
																		<asp:ListItem>Contacted Neighbor more than once when they were not requested to do so even though the Neighbor had given correct information</asp:ListItem>
																		<asp:ListItem>Communicated by post card</asp:ListItem>
																		<asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
																	</asp:CheckBoxList>
																</td>
															</tr>
														</table>
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
												<iglbar:Group Key="78_array" Text="Friends" Expanded="false" Tag="Friends">
													<Template>
														<table border="0" width="98%" style="font-size: x-small;">
															<tr>
																<td align="right">
																	Contacted Persons Name :
																</td>
																<td>
																	<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdFriendsContactName_72_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebTextEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	Contacted Persons Number :
																</td>
																<td>
																	<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdFriendsContactPhone_73_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		InputMask="(###) ###-####" UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebMaskEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	May we contact them :
																</td>
																<td align="left">
																	<asp:RadioButtonList ID="rblThirdFriendsMayWeContact_74_string" runat="server" RepeatDirection="Horizontal">
																		<asp:ListItem>Yes</asp:ListItem>
																		<asp:ListItem>No</asp:ListItem>
																	</asp:RadioButtonList>
																</td>
															</tr>
															<tr>
																<td align="right" valign="top">
																	What happened? :
																</td>
																<td>
																	<asp:CheckBoxList ID="cblThirdFriendsWhatHappened_75_array" runat="server">
																		<asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
																		<asp:ListItem>Stated that you owed them a debt</asp:ListItem>
																		<asp:ListItem>Contacted Friend more than once when they were not requested to do so even though the Friend had given correct information</asp:ListItem>
																		<asp:ListItem>Communicated by post card</asp:ListItem>
																		<asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
																	</asp:CheckBoxList>
																</td>
															</tr>
														</table>
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
												<iglbar:Group Key="79_array" Text="Family Members" Expanded="false" Tag="Family">
													<Template>
														<table border="0" width="98%" style="font-size: x-small;">
															<tr>
																<td align="right">
																	Contacted Persons Name :
																</td>
																<td>
																	<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdFamilyContactName_80_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebTextEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	Contacted Persons Number :
																</td>
																<td>
																	<igtxt:WebMaskEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtThirdFamilyContactPhone_81_string"
																		runat="server" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1"
																		InputMask="(###) ###-####" UseBrowserDefaults="False" Width="200px">
																	</igtxt:WebMaskEdit>
																</td>
															</tr>
															<tr>
																<td align="right">
																	May we contact them :
																</td>
																<td align="left">
																	<asp:RadioButtonList ID="cblThirdFamilyMayWeContact_82_string" runat="server" RepeatDirection="Horizontal">
																		<asp:ListItem>Yes</asp:ListItem>
																		<asp:ListItem>No</asp:ListItem>
																	</asp:RadioButtonList>
																</td>
															</tr>
															<tr>
																<td align="right" valign="top">
																	What happened? :
																</td>
																<td>
																	<asp:CheckBoxList ID="cblThirdFamilyWhatHappened_83_array" runat="server">
																		<asp:ListItem>Gave their Collection Agency&#39;s name without being specifically asked</asp:ListItem>
																		<asp:ListItem>Stated that you owed them a debt</asp:ListItem>
																		<asp:ListItem>Contacted Family Member more than once when they were not requested to do so even though the Family Member had given correct information</asp:ListItem>
																		<asp:ListItem>Communicated by post card</asp:ListItem>
																		<asp:ListItem>Used words or symbols on the outside of the envelope that indicated they were trying to collect a debt</asp:ListItem>
																	</asp:CheckBoxList>
																</td>
															</tr>
														</table>
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
												<iglbar:Group Key="86_string" Text="Other" Expanded="false" Tag="Other">
													<Template>
														<asp:TextBox ID="txtThirdOther_86_string" runat="server" Width="75%" Height="100px"
															TextMode="MultiLine" />
													</Template>
													<Labels Collapsed="" Expanded="" Selected="" />
												</iglbar:Group>
											</Groups>
										</iglbar:UltraWebListbar>
									</Template>
								</iglbar:Group>
								<iglbar:Group Key="90_array" Text="Collector is using abusive language" Expanded="false"
									Tag="lang">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										<table style="font-size: x-small;">
											<tr>
												<td align="right" valign="top">
													What happened? :
												</td>
												<td>
													<asp:CheckBoxList ID="cblLangWhatHappened_97_array" runat="server">
														<asp:ListItem>Used obscene or profane language</asp:ListItem>
														<asp:ListItem>Other</asp:ListItem>
													</asp:CheckBoxList>
													Please Explain :
													<asp:TextBox ID="txtLangWhatHappenedExplain_98_string" runat="server" Width="98%"
														Height="100px" TextMode="MultiLine" />
												</td>
											</tr>
										</table>
									</Template>
								</iglbar:Group>
								<iglbar:Group Key="101_array" Text="Collector is threatening you" Expanded="false"
									Tag="threat">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										<table style="font-size: x-small;">
											<tr>
												<td align="right" valign="top">
													What happened? :
												</td>
												<td>
													<iglbar:UltraWebListbar EnableAppStyling="True" StyleSetName="Nautilus" ID="lbThreatWhatHappened_106_array"
														runat="server" Width="100%" GroupExpandEffect="None" ViewType="ExplorerBar" HeaderClickAction="ExpandOnClick">
														<DefaultGroupStyle Font-Size="X-Small">
														</DefaultGroupStyle>
														<Groups>
															<iglbar:Group Text="Used or threatened to use violence" Expanded="false" Tag="violence">
																<Labels Collapsed="" Expanded="" Selected="" />
															</iglbar:Group>
															<iglbar:Group Text="Harmed or threatened to harm you or another person (body, property or reputation)"
																Expanded="false" Tag="body">
																<Labels Collapsed="" Expanded="" Selected="" />
															</iglbar:Group>
															<iglbar:Group Text="Threatened to sell your debt to a third party" Expanded="false"
																Tag="sell">
																<Labels Collapsed="" Expanded="" Selected="" />
															</iglbar:Group>
															<iglbar:Group Text="Threatened criminal prosecution if you did not give them a post dated check"
																Expanded="false" Tag="criminal">
																<Labels Collapsed="" Expanded="" Selected="" />
															</iglbar:Group>
															<iglbar:Group Text="Threatened to take unlawful actions against you before judgement is taken"
																Expanded="false" Tag="unlawful">
																<Labels Collapsed="" Expanded="" Selected="" />
																<GroupStyle>
																	<Padding Left="25" />
																</GroupStyle>
																<Template>
																	<iglbar:UltraWebListbar EnableAppStyling="True" StyleSetName="Nautilus" ID="lbThreatWhatHappenedUnlawFul_115_array"
																		runat="server" Width="100%" GroupExpandEffect="None" ViewType="ExplorerBar" HeaderClickAction="ExpandOnClick"
																		Font-Size="X-Small">
																		<Groups>
																			<iglbar:Group Text="Arrest" Expanded="false">
																				<Labels Collapsed="" Expanded="" Selected="" />
																			</iglbar:Group>
																			<iglbar:Group Text="Seizure of Property" Expanded="false">
																				<Labels Collapsed="" Expanded="" Selected="" />
																			</iglbar:Group>
																			<iglbar:Group Text="Job Loss" Expanded="false">
																				<Labels Collapsed="" Expanded="" Selected="" />
																			</iglbar:Group>
																			<iglbar:Group Text="Garnishment" Expanded="false">
																				<Labels Collapsed="" Expanded="" Selected="" />
																			</iglbar:Group>
																			<iglbar:Group Text="Other" Expanded="false">
																				<Template>
																					<asp:TextBox ID="txtThreatWhatHappenedUnlawFulOther_116_string" runat="server" Width="98%"
																						Height="100px" TextMode="MultiLine" />
																				</Template>
																				<Labels Collapsed="" Expanded="" Selected="" />
																			</iglbar:Group>
																		</Groups>
																	</iglbar:UltraWebListbar>
																</Template>
															</iglbar:Group>
															<iglbar:Group Text="Other" Expanded="false" Tag="other">
																<Template>
																	<asp:TextBox ID="txtThreatWhatHappenedOther_104_string" runat="server" Width="98%"
																		TextMode="MultiLine" Height="100px" />
																</Template>
																<Labels Collapsed="" Expanded="" Selected="" />
															</iglbar:Group>
														</Groups>
													</iglbar:UltraWebListbar>
												</td>
											</tr>
										</table>
									</Template>
								</iglbar:Group>
								<iglbar:Group Key="108_array" Text="Collector is Harassing you in another manner"
									Expanded="false" Tag="another">
									<Labels Collapsed="" Expanded="" Selected="" />
									<GroupStyle>
										<Padding Left="25" />
									</GroupStyle>
									<Template>
										<table style="font-size: x-small;">
											<tr>
												<td align="right" valign="top">
													What happened? :
												</td>
												<td>
													<asp:CheckBoxList ID="cblAnotherWhatHappened_112_array" runat="server">
														<asp:ListItem>Said you committed a crime.</asp:ListItem>
														<asp:ListItem>Published your name as a person who does not pay bills.</asp:ListItem>
														<asp:ListItem>Listed your debt for sale to the public.</asp:ListItem>
														<asp:ListItem>Other</asp:ListItem>
													</asp:CheckBoxList>
													<asp:TextBox ID="txtAnotherWhatHappenedExplain_110_string" runat="server" Height="100px"
														Width="98%" TextMode="MultiLine" />
												</td>
											</tr>
										</table>
									</Template>
								</iglbar:Group>
							</Groups>
						</iglbar:UltraWebListbar>
					</Template>
				</igmisc:WebPanel>
				<table width="100%">
					<tr>
						<td align="center" style="height: 45px; background-color: silver">
							Please fill out information below if you know it, thank you.
						</td>
					</tr>
					<tr style="white-space: nowrap;">
						<td>
							<table width="98%" style="font-size: x-small;">
								<tr style="white-space: nowrap;">
									<td>
									</td>
									<td>
										Last Sent
									</td>
									<td style="width: 50px">
										Total Sent
									</td>
								</tr>
								<tr>
									<td>
										Original Notice of Representation by Legal Counsel Mailed :
									</td>
									<td>
										<igsch:WebDateChooser ID="dteNoticeOfRep" runat="server" Editable="False" EnableAppStyling="True"
											StyleSetName="Nautilus">
										</igsch:WebDateChooser>
									</td>
									<td>
										<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtRepTotal"
											ReadOnly="true" HorizontalAlign="Center" runat="server" Width="25px">
										</igtxt:WebTextEdit>
									</td>
								</tr>
								<tr>
									<td>
										Cease & Desist Notice Mailed :
									</td>
									<td>
										<igsch:WebDateChooser ID="dteCease" runat="server" Editable="False" EnableAppStyling="True"
											StyleSetName="Nautilus">
										</igsch:WebDateChooser>
									</td>
									<td>
										<igtxt:WebTextEdit EnableAppStyling="True" StyleSetName="Nautilus" ID="txtCeaseTotal"
											ReadOnly="true" HorizontalAlign="Center" runat="server" Width="25px">
										</igtxt:WebTextEdit>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<asp:CheckBox ID="chkInterest" runat="server" Text="Creditor added interest, fees or charges not authorized in the original agreement or by state law." />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr style="height: 50px; vertical-align: middle;">
						<td align="center">
						</td>
					</tr>
				</table>
			</asp:Panel>
		</ContentTemplate>
		<Triggers>
			<asp:AsyncPostBackTrigger ControlID="lnkSubmit" EventName="Click" />
			<asp:AsyncPostBackTrigger ControlID="lnkCancel" EventName="Click" />
		</Triggers>
	</asp:UpdatePanel>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr align="center" class="igdw_HeaderContent">
			<td style="width: 50%">
				<asp:LinkButton ID="lnkSubmit" CssClass="linkButton" runat="server" Text="Save Form" />
			</td>
			<td style="width: 50%">
				<asp:LinkButton ID="lnkCancel" CssClass="linkButton" runat="server" Text="Cancel" />
			</td>
		</tr>
	</table>
</asp:Panel>
<ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" Y="50" runat="server" PopupDragHandleControlID="pnlHdr"
	TargetControlID="lnkShow" PopupControlID="Panel1" BackgroundCssClass="modalBackground"
	DropShadow="false" CancelControlID="lnkCancel" />
<igmisc:WebPageStyler ID="WebPageStyler1" runat="server" StyleSetName="Nautilus"
	EnableAppStyling="true" />
<asp:SqlDataSource ConnectionString="<%$ AppSettings:connectionstring %>" ID="sdsCardHolderName"
	runat="server" SelectCommand="SELECT c.ClientID, c.AccountNumber,  s.Abbreviation, p.FirstName+ ' ' + p.LastName as [CardHolder],p.personid 
                         FROM tblClient c INNER JOIN tblPerson p ON p.ClientID = c.ClientID INNER JOIN tblState s ON s.StateID = p.StateID WHERE c.clientid = @clientID"
	ProviderName="System.Data.SqlClient">
	<SelectParameters>
		<asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
	</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsOrigCred" ConnectionString="<%$ AppSettings:connectionstring %>"
	runat="server" SelectCommand="
select accountid,[OriginalInfo],OrigCredID
from
(
	SELECT 
		a.accountid
		,OrigCr.[Name] + ' #' + right(OrigCi.AccountNumber,4) as [OriginalInfo]
		,OrigCr.creditorid as OrigCredID 
	FROM tblAccount as a 
		INNER JOIN tblCreditorInstance OrigCi ON OrigCi.CreditorInstanceID = a.originalCreditorInstanceID 
		INNER JOIN tblCreditor OrigCr ON OrigCr.CreditorID = OrigCi.CreditorID 
		INNER JOIN tblCreditor cr ON cr.CreditorID = OrigCr.CreditorID 
	WHERE 
		(a.clientid = @clientID) 
	
	union  

	select 
		'-1' as accountid 
		, 'Unknown' as OriginalInfo
		, '-1' as OrigCredID
) as OrigCredData
ORDER BY OriginalInfo
" ProviderName="System.Data.SqlClient">
	<SelectParameters>
		<asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
	</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsDebtCollector" ConnectionString="<%$ AppSettings:connectionstring %>"
	runat="server" SelectCommand="SELECT AccountID, CurrentInfo, CurrentCredID FROM (SELECT a.AccountID, cr.Name + ' #' + RIGHT (ci.AccountNumber, 4) AS CurrentInfo, cr.CreditorID AS CurrentCredID FROM tblAccount AS a INNER JOIN tblCreditorInstance AS OrigCi ON OrigCi.CreditorInstanceID = a.OriginalCreditorInstanceID INNER JOIN tblCreditorInstance AS ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN tblCreditor AS cr ON cr.CreditorID = ci.CreditorID WHERE (a.ClientID = @clientid) UNION SELECT '-1' AS accountid, 'Unknown' AS CurrentInfo, '-1' AS CurrentCredID) AS CurrCredData ORDER BY CurrentInfo"
	ProviderName="System.Data.SqlClient">
	<SelectParameters>
		<asp:QueryStringParameter QueryStringField="id" Name="clientid" DefaultValue="-1" />
	</SelectParameters>
</asp:SqlDataSource>
<style type="text/css">
	.modalPopup
	{
		z-index: 99999999;
		background-color: #6D7B8D;
		color: #fff;
		width: 75%;
		text-align: center;
		vertical-align: middle;
		position: absolute;
		bottom: 50%;
		left: 45%;
	}
	.modalBackground
	{
		z-index: 99999998;
		background-color: #6D7B8D;
		position: absolute;
		top: 0;
		left: 0;
		height: 100%;
		width: 100%;
		min-height: 100%;
		min-width: 100%;
		filter: alpha(opacity=50);
		opacity: 0.5;
		-moz-opacity: 0.5;
	}
	.ig_Header
	{
	}
	.igdw_HeaderArea
	{
		border-top-width: 0px;
		font-weight: bold;
		border-left-width: 0px;
		border-bottom-width: 0px;
		cursor: default;
		color: white;
		height: 24px;
		background-color: transparent;
		border-right-width: 0px;
	}
	.ig_Control
	{
		border-right: #abc1de 1px solid;
		border-top: #abc1de 1px solid;
		font-size: xx-small;
		border-left: #abc1de 1px solid;
		cursor: default;
		color: black;
		border-bottom: #abc1de 1px solid;
		font-family: verdana;
		background-color: white;
	}
	.igdw_Control
	{
		border-top-width: 0px;
		border-left-width: 0px;
		border-bottom-width: 0px;
		background-color: transparent;
		border-right-width: 0px;
	}
	BODY
	{
		cursor: default;
	}
	.igdw_HeaderCornerRight
	{
		background-position: right top;
		background-image: url(../../../../ig_res/Default/images/igdw_headercornerright.gif);
		width: 9px;
	}
	.igdw_HeaderButtonArea
	{
		vertical-align: middle;
		width: 120px;
	}
	.igdw_HeaderContent
	{
		background-image: url(../../../../ig_res/Default/images/igdw_headercontent.gif);
	}
	.igdw_HeaderCaption
	{
		margin-top: 16px;
		margin-left: 6px;
		color: white;
		padding-top: 10px;
	}
	.igdw_HeaderCornerLeft
	{
		background-position: left top;
		background-image: url(../../../../ig_res/Default/images/igdw_headercornerleft.gif);
		width: 9px;
		background-color: transparent;
	}
	.linkButton
	{
		font-size: 11pt;
		font-family: Tahoma;
		text-decoration: none;
	}
	.linkButton:hover
	{
		color: White;
	}
</style>

<script type="text/javascript">
	var prm = Sys.WebForms.PageRequestManager.getInstance();
	prm.add_initializeRequest(InitializeRequest);
	prm.add_endRequest(EndRequest);
	var postBackElement;
	function InitializeRequest(sender, args) {

		if (prm.get_isInAsyncPostBack())
			args.set_cancel(true);
		postBackElement = args.get_postBackElement();

		if (postBackElement.id == "<%= lnkSubmit.ClientID %>")
			$get("<%= upHarass.ClientID %>").style.display = 'block';
	}
	function EndRequest(sender, args) {
		if (postBackElement.id == "<%= lnkSubmit.ClientID  %>")
			$get("<%= upHarass.ClientID %>").style.display = 'none';
	}


	function lbreasons_AfterGroupExpanded(oListbar, oGroup, oEvent) {
		//Add code to handle your event here.
		for (var grp in oListbar.Groups) {
			if (oGroup.getText() != oListbar.Groups[grp].getText()) {
				//collapse all other panels
				oListbar.Groups[grp].setExpanded(false, false);
			}
		}
	}
</script>

