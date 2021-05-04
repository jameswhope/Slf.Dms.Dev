<%@ Page Title="" Language="VB" MasterPageFile="~/research/reports/reports.master"
    AutoEventWireup="false" CodeFile="ActiveClientsData.aspx.vb" Inherits="research_reports_clients_ActiveClientsData" %>

<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .filterBox
        {
            padding: 10px;
            background-color: #DCDCDC;
            border: solid 1px #3376AB;
        }
        .gridSpace
        {
        font-family:tahoma;font-size:11px;width:100%;
        }
        .gridSpace th
        {
         padding-left:5px;
        }

        .rowStyle td
        {
         padding-left:5px;
        }
    </style>

    <script language="javascript">
        function Export()
        {
            <%= ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
        }
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="smReports" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="updReport" runat="server">
        <ContentTemplate>
            <table id="tblBody" runat="server" border="0" cellpadding="0" cellspacing="15" style="<igtblexp: UltraWebGridExcelExporter runat='server'></igtblexp:UltraWebGridExcelExporter>font-family: tahoma;
                font-size: 11px; width: 100%;">
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a
                            id="A2" runat="server" class="lnk" style="color: #666666;" href="~/research/reports">Reports</a>&nbsp;>&nbsp;<a
                                id="A3" runat="server" class="lnk" style="color: #666666;" href="~/research/reports/clients">Clients</a>&nbsp;>&nbsp;Active
                        Active Clients
                    </td>
                </tr>
                <tr>
                    <td>
                        <fieldset>
                            <legend>Filter</legend>
                            <table class="entry2" border="0">
                                <tr>
                                    <td>
                                        <asp:DropDownList ID="ddlCompanyFilter" runat="server" DataSourceID="dsCompany"
                                            AutoPostBack="true" DataTextField="Name" DataValueField="name" CssClass="entry2"
                                            Width="190px" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlStateFilter" runat="server" DataSourceID="dsState" DataTextField="Name"
                                            AutoPostBack="true" DataValueField="name" CssClass="entry2" Width="130px" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAgencyFilter" runat="server" DataSourceID="dsAgency" DataTextField="Name"
                                            AutoPostBack="true" DataValueField="name" CssClass="entry2" Width="278px" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                    </td>
                                    <td>
                                        
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <asp:Label ID="lblCurrentFilter" runat="server" Text="Filter: None" Font-Italic="true"
                            Font-Size="X-Small" /><asp:label ID="LinkButton1" runat="server" Text=" | " /><asp:LinkButton ID="lnkClear" runat="server" Text="Clear Filter" />
                        <asp:GridView ID="gvClients" runat="server" DataSourceID="ds_clients" AutoGenerateColumns="false"
                            AllowPaging="true" AllowSorting="true" CssClass="gridSpace">
                            <HeaderStyle Height="30" />
                            <RowStyle CssClass="rowStyle" />
                            <Columns>
                                <asp:BoundField DataField="Company" HeaderText="Company" SortExpression="Company"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false"  />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="State" HeaderText="State" SortExpression="State" HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false"  />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Agency" HeaderText="Agency" SortExpression="Agency" HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false"  />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Accountnumber" HeaderText="Account #" SortExpression="Accountnumber"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Clientname" HeaderText="Client Name" SortExpression="Clientname"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Address/Contact Info" SortExpression="address">
                                    <ItemTemplate>
                                        Address:
                                        <asp:Label ID="lblAddress" runat="server" Text='<%#eval("address") %>' /><br />
                                        <asp:Label ID="Label1" runat="server" Text='<%#eval("contactinfo") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="city" HeaderText="City" SortExpression="city" HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="zip" HeaderText="Zip" SortExpression="zip" HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <%--
                                <asp:TemplateField HeaderText="Company" SortExpression="Lawfirm" >
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lbl" runat="server" Text="Company" CommandName="Sort" CommandArgument="Lawfirm">
                                            <asp:Image ID="filter" runat="server" ImageUrl="~/images/16x16_filter.png" />
                                        </asp:LinkButton>
                                        <obo:Flyout ID="oboCompany" runat="server" AttachTo="filter" Position="BOTTOM_CENTER">
                                            <div class="filterBox">
                                                <asp:DropDownList ID="ddlCompanyFilter" runat="server" DataSourceID="dsCompanies"
                                                    DataTextField="Name" DataValueField="name" CssClass="entry2" AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                                <br />
                                            </div>
                                        </obo:Flyout>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lbl" runat="server" Text='<%#eval("LawFirm") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="State" SortExpression="State">
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lblState" runat="server" Text="State" CommandName="Sort" CommandArgument="State">
                                            <asp:Image ID="imgFState" runat="server" ImageUrl="~/images/16x16_filter.png" />
                                        </asp:LinkButton>
                                        <obo:Flyout ID="oboState" runat="server" AttachTo="imgFState" Position="BOTTOM_CENTER">
                                            <div class="filterBox">
                                                <asp:DropDownList ID="ddlStateFilter" runat="server" DataSourceID="dsStates" DataTextField="Name"
                                                    DataValueField="name" CssClass="entry2" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                            </div>
                                        </obo:Flyout>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lbl" runat="server" Text='<%#eval("State") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" Width="100px" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Agency" SortExpression="Agency">
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="lblHdrAgency" runat="server" Text="Agency" CommandName="Sort"
                                            CommandArgument="Agency">
                                            <asp:Image ID="imgFAgency" runat="server" ImageUrl="~/images/16x16_filter.png" />
                                        </asp:LinkButton>
                                        <obo:Flyout ID="oboAgency" runat="server" AttachTo="imgFAgency" Position="BOTTOM_CENTER">
                                            <div class="filterBox">
                                                <asp:DropDownList ID="ddlAgencyFilter" runat="server" DataSourceID="dsAgencies" DataTextField="Name"
                                                    DataValueField="name" CssClass="entry2" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged" />
                                            </div>
                                        </obo:Flyout>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblAgency" runat="server" Text='<%#eval("agency") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" Width="200px" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="address" HeaderText="Address" SortExpression="address"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="contact info" HeaderText="Contact Info" SortExpression="contact info"
                                    HtmlEncode="false">
                                    <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" Wrap="false" />
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                </asp:BoundField>
                         --%>
                            </Columns>
                            <PagerTemplate>
                                <div id="pager" class="entry" style="background-color: #DCDCDC; padding-left: 10px;">
                                    View
                                    <asp:TextBox CssClass="entry2" ID="txtPageSize" runat="server" Width="25px" EnableViewState="true"></asp:TextBox>
                                    results per page
                                    <asp:LinkButton CssClass="entry2" ID="lnkSavePageSize" runat="server"><strong>Save</strong></asp:LinkButton>
                                    | Page(s)
                                    <asp:DropDownList CssClass="entry2" ID="ddlPageSelector" runat="server" AutoPostBack="true">
                                    </asp:DropDownList>
                                    of
                                    <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                    |
                                    <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                        ID="btnFirst" />
                                    <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                        ID="btnPrevious" />
                                    -
                                    <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                        ID="btnNext" />
                                    <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                        ID="btnLast" />
                                </div>
                            </PagerTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="ds_Clients" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="stp_reports_getActiveClientData" SelectCommandType="StoredProcedure">
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="dsCompany" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="Select Distinct Name from tblcompany" SelectCommandType="Text">
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="dsState" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="select distinct [name] from tblstate order by [name]" SelectCommandType="Text">
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="dsAgency" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                            SelectCommand="select distinct [name] from tblagency order by [name]" SelectCommandType="Text">
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
            <div id="updateHardshipProgressDiv" style="display: none; height: 40px; width: 40px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/loading.gif" />
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="lnkExport" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
    <ajaxToolkit:UpdatePanelAnimationExtender ID="upaeCancel" BehaviorID="cancelAnimation"
        runat="server" TargetControlID="updReport">
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

    <script type="text/javascript">
        function onUpdating() {
            // get the update progress div
            var updateProgressDiv = $get('updateHardshipProgressDiv');
            // make it visible
            updateProgressDiv.style.display = '';

            //  get the gridview element
            var gridView = $get('<% =tblBody.ClientID %>');

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
            var updateProgressDiv = $get('updateHardshipProgressDiv');
            // make it invisible
            updateProgressDiv.style.display = 'none';

            //			var additionalDiv = document.getElementById('ctl00_ctl00_cphBody_cphBody_fvHardship_tabsItems_tabHardInfo_AdditionalInformationLabel_tw');
            //			var hiddenAdditionalInput = document.getElementById('ctl00_ctl00_cphBody_cphBody_fvHardship_tabsItems_tabHardInfo_AdditionalInformationLabel_t_a');

            //			additionalDiv.setAttribute('content', false);
            //			additionalDiv.setAttribute('contentEditable', true);
            //			additionalDiv.setAttribute('_oldE', true);
            //			
            //			 
            //			additionalDiv.setAttribute('innerText', hiddenAdditionalInput.value);
        }

    </script>

</asp:Content>
