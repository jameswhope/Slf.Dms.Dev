<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb"
    Inherits="Clients_Enrollment_Default" Title="Client Intake Department - Overview" %>

<%@ Register Src="../../CustomTools/UserControls/SwitchUserGroup.ascx" TagName="SwitchUserGroup" TagPrefix="uc1" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <ajaxToolkit:ToolkitScriptManager ID="dsfdsf" runat="server"></ajaxToolkit:ToolkitScriptManager>
    <table id="tblRepToolbar" runat="server" cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img runat="server" width="8" height="1" src="~/images/spacer.gif" alt="" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a runat="server" class="menuButton" href="default.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_web_home.png" />Home</a>
            </td>
            <td id="tdMyIncentivesSep" runat="server" visible="false">|
            </td>
            <td id="tdMyIncentives" runat="server" nowrap="nowrap" visible="false">
                <a id="aIncentives" runat="server" class="menuButton" href="#">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_trust.png" alt="" />My Incentives</a>
            </td>
            <td id="tdNewApplicantSep" runat="server" visible="false">|
            </td>
            <td id="tdNewApplicant" runat="server" visible="false" nowrap="nowrap">
                <a id="A1" runat="server" class="menuButton" href="~/clients/enrollment/NewEnrollment3.aspx?id=0">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_person_add.png" />New Applicant</a>
            </td>
            <td id="tdLeadAnalysisSep" runat="server" visible="false">|
            </td>
            <td id="tdLeadAnalysis" runat="server" visible="false" nowrap="nowrap">
                <a id="A7" runat="server" class="menuButton" href="~/clients/enrollment/LeadAnalysis.aspx">
                    <img id="Img9" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_worksheet.png" />Lead Analysis</a>
            </td>
            <td id="tdPhoneListSep" runat="server" visible="false">|
            </td>
            <td id="tdPhoneList" runat="server" visible="false" nowrap="nowrap">
                <a id="A9" runat="server" class="menuButtonImage"
                    href="~/clients/enrollment/PhoneList.aspx">
                    <img id="Img11" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_phone.png" />Phone List</a>
            </td>
            <td id="tdSwithToGroupSep" runat="server" class="menuSeparator">|
            </td>
            <td id="tdSwithToGroup" runat="server" nowrap="nowrap">
                <asp:LinkButton ID="lnkSwitchToGroup" runat="server" CssClass="menuButton">
                    <img id="ImgSwitchToGroup" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_file_remove.png" />Switch To Group
                </asp:LinkButton>
                <obo:Flyout ID="Flyout1" runat="server" AttachTo="lnkSwitchToGroup" Align="LEFT" Position="BOTTOM_CENTER" OpenTime="100">
                    <div class="entry2" style="background-color: #D6E7F3;">
                        <table class="entry">
                            <tr>
                                <td>
                                    <div>
                                        <uc1:SwitchUserGroup ID="SwitchUserGroup1" runat="server" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </obo:Flyout>
            </td>
            <td visible="false">|
            </td>
            <td nowrap="nowrap" visible="false">
                <a class="menuButton" href="goals.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_goals.png" alt="" />Goals</a>
            </td>
            <td id="tdmnuReportsSep" runat="server" class="menuSeparator">|
            </td>
            <td nowrap="nowrap">
                <asp:Menu ID="mnuReports" runat="server" Orientation="Horizontal"
                    DynamicEnableDefaultPopOutImage="False" DynamicHorizontalOffset="2"
                    Font-Names="Tahoma" Font-Size="11px" ForeColor="#000000"
                    StaticSubMenuIndent="20px" StaticEnableDefaultPopOutImage="False">
                    <StaticSelectedStyle BackColor="#507CD1" />
                    <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
                    <DynamicHoverStyle BackColor="#E8F3FF" ForeColor="#000000" BorderStyle="Solid" BorderWidth="1px" BorderColor="#336699" />
                    <DynamicMenuStyle BackColor="#D6E7F3" HorizontalPadding="0px" BorderStyle="Solid" BorderWidth="1px" BorderColor="#336699" />
                    <DynamicSelectedStyle BackColor="#507CD1" />
                    <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="5px" />
                    <DataBindings>
                        <asp:MenuItemBinding TextField="name" DataMember="Reports" Depth="0" ImageUrl="~/images/16x16_report.png" Selectable="False" FormatString=" {0}" />
                        <asp:MenuItemBinding TextField="name" DataMember="reportItem" Depth="1" />
                    </DataBindings>
                    <StaticHoverStyle BackColor="#E8F3FF" BorderStyle="Solid" BorderWidth="1px" BorderColor="#336699" />
                </asp:Menu>
            </td>
            <td style="width: 100%;">&nbsp;
            </td>
        </tr>
    </table>
    <table id="tblAdminToolbar" runat="server" cellpadding="0" cellspacing="0" class="menuTable" visible="false">
        <tr>
            <td>
                <img id="Img14" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td nowrap="nowrap">
                <a id="A4" runat="server" class="menuButton" href="~/clients/enrollment/Reports.aspx">
                    <img id="Img5" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_report.png" />Reports</a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="A8" runat="server" class="menuButton" href="~/clients/enrollment/Incentives.aspx">
                    <img id="Img10" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_trust.png" />Incentives</a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="A10" runat="server" class="menuButton" href="~/clients/enrollment/products.aspx">
                    <img id="Img12" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_list.png" />Products </a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="A11" runat="server" class="menuButton" href="~/clients/enrollment/dashboardreport.aspx">
                    <img id="Img13" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_piechart.png" />Dashboard </a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="A5" runat="server" class="menuButton" href="~/clients/enrollment/LeadAssignment.aspx">
                    <img id="Img7" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_person.png" />Assign Leads</a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="A6" runat="server" class="menuButton" href="~/clients/enrollment/HydraReps.aspx">
                    <img id="Img8" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_user.png" />Assign Reps</a>
            </td>
            <td>|
            </td>
            <td nowrap="nowrap">
                <a id="lnkGlobalTransfer" runat="server" class="menuButton" href="~/GlobalTransfer.aspx">
                    <img id="Img1" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_people.png" />Global Transfer</a>
            </td>
            <td style="width: 100%;">&nbsp;
            </td>
        </tr>
    </table>

</asp:Content>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript">

        try {
            var windowname = '';
            try { windowname = window.top.parent.name.toLowerCase(); }
            catch (e1) {
                document.domain = "dmsi.local";
                windowname = window.top.parent.name.toLowerCase();
            }
        }
        catch (e) { }

        function calluser(imag) {
            var phonenumber = imag.getAttribute('Text');
            var leadid = imag.parentNode.parentNode.childNodes[0].innerText;
            window.top.parent.MakeLeadOutboundCall(leadid, phonenumber);
        }

        function OpenDialog(leadid) {
            var w;
            w = window.open('prompt.aspx?id=' + leadid + '&dialog=yes', 'Model', 'width=350,height=170,scrollbars=no,resizable=no,status=no,modal=yes,left=20,top=20');
            w.focus();
        }

    </script>

    <div style="padding: 0px 20px">
        <div style="margin: 25px 0px 0px 0px; width: 35%; float: left;">
            <h5 runat="server" style="background-color: #eee; padding: 2px 5px 2px 5px; margin: 0px;">Search</h5>

            <asp:TextBox ID="txtSearch" runat="server" CssClass="entry2" MaxLength="30" Width="200px"></asp:TextBox>
            <asp:ImageButton ID="lnkSearch" runat="server" ImageUrl="~/images/16x16_search.png" Style="margin: 5px 10px 0px 5px;" AlternateText="Search" />
            <asp:ImageButton ID="lnkClear" runat="server" ImageUrl="~/images/16x16_clear.png" Style="margin: 5px 0px 0px 0px;" AlternateText="Clear" /><br/>
            <asp:DropDownList runat="server" ID="ddlAssignTo" Width="100px"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlProduct" Width="100px"></asp:DropDownList>
            <asp:DropDownList runat="server" ID="ddlStatus" Width="100px"></asp:DropDownList>
        </div>

        <div style="margin: 25px 0px 0px 0px; width: 60%; float: right;">
            <h5 id="hNewLeads" runat="server" style="background-color: #eee; padding: 2px 5px 2px 5px; margin: 0px;">New Leads</h5>
            <div id="divUnassignedLeads" runat="server">

                <asp:GridView ID="gvUnassignedLeads" runat="server" AutoGenerateColumns="False" AllowPaging="True" OnPageIndexChanging="gvUnassignedLeads_PageIndexChanging" OnSorting="gvUnassignedLeads_Sorting"
                    AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="3" Width="100%" CssClass="entry2" DataKeyNames="LeadApplicantId">
                    <AlternatingRowStyle BackColor="#E6FCFF" />
                    <PagerSettings Mode="NumericFirstLast" Visible="true" />
                    <Columns>

                        <asp:BoundField DataField="LeadTransferInDate" HeaderText="Transferred" DataFormatString="{0:MMM d yyyy  hh:mm}" SortExpression="LeadTransferInDate">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="FullName" HeaderText="Applicant" SortExpression="FullName">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="HomePhone" HeaderText="Phone Number" NullDisplayText="No Phone Number" SortExpression="HomePhone">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />                   
                        </asp:BoundField>

                        <asp:BoundField DataField="TotalDebt" HeaderText="Total Debt" DataFormatString="{0:c}" SortExpression="TotalDebt">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Name" HeaderText="Source" SortExpression="Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                    </Columns>
                    <PagerStyle CssClass="pagerstyle" />
                </asp:GridView>

            </div>

        </div>

        <div style="margin: 25px 0px 10px 0px; width: 100%; clear: both;">
            <h5 id="hPipeline" runat="server" style="background-color: #eee; padding: 2px 5px 2px 5px; margin: 0px;">PipeLine</h5>
            <div id="div1" runat="server">

                <div style="width: 100%; height: 500px; overflow: scroll">
                    <asp:GridView ID="gvPipelineLeads" runat="server" AutoGenerateColumns="False" AllowPaging="True" OnPageIndexChanging="gvPipelineLeads_PageIndexChanging" OnSorting="gvPipelineLeads_Sorting"
                    AllowSorting="True" CellPadding="2" BorderWidth="0px" PageSize="100" Width="100%" CssClass="entry2" DataKeyNames="leadapplicantid">
                    <AlternatingRowStyle BackColor="#E6FCFF" />
                    <PagerSettings Mode="NumericFirstLast" Visible="true"/>
                    <Columns>

                        <asp:BoundField DataField="LeadTransferInDate" HeaderText="Transferred" DataFormatString="{0:MMM d yyyy  hh:mm}" SortExpression="LeadTransferInDate">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:ImageField DataImageUrlField="VerImg" HeaderText="3PV">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:ImageField>

                        <asp:ImageField DataImageUrlField="LSAImg" HeaderText="LSA">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:ImageField>

                        <asp:BoundField DataField="FullName" HeaderText="Applicant" SortExpression="FullName">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="HomePhone" HeaderText="Main Contact" SortExpression="HomePhone">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="TotalDebt" HeaderText="Total Debt" DataFormatString="{0:c}" SortExpression="TotalDebt">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Name" HeaderText="Source" SortExpression="Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="Description" HeaderText="Status" SortExpression="Description">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                        <asp:BoundField DataField="AssignedTo" HeaderText="Rep" SortExpression="AssignedTo">
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                        </asp:BoundField>

                    </Columns>
                    <PagerStyle CssClass="pagerstyle" />
                </asp:GridView>
                </div>
            </div>

        </div>

    </div>
    <asp:HiddenField id="hdnProducts" runat="server"/>
    <asp:HiddenField id="hdnStatuses" runat="server"/>
    <asp:HiddenField id="hdnReps" runat="server" />

    <script type="text/javascript">

        function setMouseOverColor(element, bgColor) {
            if (typeof bgColor != "undefined")
                element.style.backgroundColor = bgColor;
            else
                element.style.backgroundColor = "#e5e5e5";

            element.style.cursor = 'hand';
        }

        function setMouseOutColor(element, bgColor) {
            if (typeof bgColor != "undefined")
                element.style.backgroundColor = bgColor;
            else
                element.style.backgroundColor = "#ffffff";

            element.style.textDecoration = 'none';
        }

        function setAlternateMouseOutColor(element, bgColor) {
            if (typeof bgColor != "undefined")
                element.style.backgroundColor = bgColor;
            else
                element.style.backgroundColor = "#e6fcff";

            element.style.textDecoration = 'none';
        }
    </script>

</asp:Content>
