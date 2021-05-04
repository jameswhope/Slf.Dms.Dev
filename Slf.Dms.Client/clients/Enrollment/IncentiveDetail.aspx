<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="IncentiveDetail.aspx.vb" Inherits="Clients_Enrollment_IncentiveDetail" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebChart" TagPrefix="igchart" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.UltraChart.Resources.Appearance" TagPrefix="igchartprop" %>
<%@ Register Assembly="Infragistics2.WebUI.UltraWebChart.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.UltraChart.Data" TagPrefix="igchartdata" %>
<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="obo" %>    
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a id="aBack" runat="server" class="menuButton" href="default.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_back.png" />Back</a>
            </td>
            <td style="width:100%">
                &nbsp;</td>
            <td style="white-space: nowrap">
                <img id="Img11" runat="server" align="absmiddle" alt="" border="0" class="menuButtonImage" src="~/images/16x16_chart_bar.png" />
                <asp:Label ID="lblChart" runat="server" CssClass="enrollmentMenuButton" Text="Current Incentive Chart"
                    onmouseover="this.className='enrollmentMenuButtonHover';this.style.cursor='hand';"
                    onmouseout="this.className='enrollmentMenuButton';"></asp:Label>
                <obo:Flyout ID="oboOptions" runat="server" AttachTo="lblChart" Align="RIGHT" Position="BOTTOM_CENTER"
                    OpenTime="100">
                    <div style="border:solid 1px #000">
                        <table cellpadding="0" cellspacing="10" style="background-color: #f1f1f1">
                            <tr>
                                <td valign="top" id="tdRepChart" runat="server">
                                    <div id="divIncentiveChart" runat="server" style="font-weight: bold; padding: 0px 0px 3px 0px;
                                        text-align: center">
                                        Current Incentive Chart</div>
                                    <asp:GridView ID="gvIncentiveChart" runat="server" DataSourceID="ds_IncChart" CellPadding="3"
                                        AutoGenerateColumns="true" GridLines="Both" BorderStyle="Solid" BorderWidth="1px"
                                        BorderColor="#cccccc" Width="100%" BackColor="#ffffff">
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="ds_IncChart" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommand="stp_IncentiveChart" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:QueryStringParameter QueryStringField="id" Name="repid" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" id="tdSupChart" runat="server">
                                    <div id="divTeamChart" runat="server" style="font-weight: bold; padding: 0px 0px 3px 0px;
                                        text-align: center">
                                        Current Team Chart</div>
                                    <asp:GridView ID="gvTeamChart" runat="server" DataSourceID="ds_TeamChart" CellPadding="3"
                                        AutoGenerateColumns="true" GridLines="Both" BorderStyle="Solid" BorderWidth="1px"
                                        BorderColor="#cccccc" Width="100%" BackColor="#ffffff">
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="ds_TeamChart" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommand="stp_TeamIncentiveChart" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                    </div>
                </obo:Flyout>
            </td>
            <td>
                &nbsp;&nbsp;&nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .rowItem
        {
            border-bottom: solid 1px #B5B5B5;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
        }
        .rowItemC
        {
            border-bottom: solid 1px #B5B5B5;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
        }
        .rowItem2
        {
            border-bottom: solid 1px #B5B5B5;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
            white-space: nowrap;
        }
        .bold
        {
            font-weight: bold;
            text-align: right;
        }
        .rowInitial
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #C1FFC1;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: right;
        }
        .rowInitialC
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #C1FFC1;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
        }
        .rowResidual
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #B4EEB4;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: right;
        }
        .rowResidualC
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #B4EEB4;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
        }
        .rowIndividualTotal
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #9BCD9B;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: right;
        }
        .rowTeam
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #BCD2EE;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: right;
        }
        .rowTeamC
        {
            border-bottom: solid 1px #B5B5B5;
            background-color: #BCD2EE;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
        }
        .headItem
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            white-space: nowrap;
        }
        .headItemC
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: center;
            white-space: nowrap;
            background-color: #dcdcdc;
        }
        .headItem2
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: bold;
            text-align: right;
            background-color: #d1d1d1;
        }
        .headItem3
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: center;
            background-color: #d1d1d1;
        }
        .headItem4
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            background-color: #d1d1d1;
        }
        .headTeam
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: right;
            background-color: #A2B5CD;
        }
        .headTeamC
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: center;
            background-color: #A2B5CD;
        }
        .headIndiv
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: right;
            background-color: #9BCD9B;
        }
        .headIndivC
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: center;
            background-color: #9BCD9B;
        }
        .chartItem
        {
            border-bottom: solid 1px #d3d3d3;
            white-space: nowrap;
            font-family: Tahoma;
            font-size: 11px;
            text-align: center;
        }
        .chartHead
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: center;
            background-color: #B9D3EE;
        }
    </style>
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />

    <script language="javascript" type="text/javascript">
        function approve(month,year) {
            document.getElementById('<%=hdnMonth.ClientID %>').value = month;
            document.getElementById('<%=hdnYear.ClientID %>').value = year;
            <%=Page.ClientScript.GetPostBackEventReference(lnkApprove, Nothing) %>;
        }
        
        function ShowDetail(month,year,monthyear,approved) {
            document.getElementById('<%=hdnMonth.ClientID %>').value = month;
            document.getElementById('<%=hdnYear.ClientID %>').value = year;
            document.getElementById('<%=hdnMonthYear.ClientID %>').value = monthyear;
            document.getElementById('<%=hdnApproved.ClientID %>').value = approved;
            <%=Page.ClientScript.GetPostBackEventReference(lnkLoadDetail, Nothing) %>;
        }
        
        function ShowConvDetail(month,year,monthyear) {
            document.getElementById('<%=hdnMonth.ClientID %>').value = month;
            document.getElementById('<%=hdnYear.ClientID %>').value = year;
            document.getElementById('<%=hdnMonthYear.ClientID %>').value = monthyear;
            <%=Page.ClientScript.GetPostBackEventReference(lnkLoadConvDetail, Nothing) %>;
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="background-color: #ededed; padding: 15px">
                <table id="tblBody" style="background-color: #ffffff; font-family: tahoma; font-size: 11px;"
                    border="0" cellpadding="0" cellspacing="15">
                    <tr>
                        <td colspan="2">
                            <h4 id="hName" runat="server" style="margin: 0; padding: 0">
                            </h4>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table cellpadding="5" cellspacing="0" border="0">
                                <tr>
                                    <td style="width: 16px">
                                    </td>
                                    <td style="width: 120px">
                                    </td>
                                    <td style="width: 340px; text-align: center; background-color: #C1FFC1">
                                        Individual
                                    </td>
                                    <td style="width: 160px; text-align: center; background-color: #BCD2EE">
                                        Team
                                    </td>
                                </tr>
                            </table>
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CellPadding="5"
                                GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true" OnRowDataBound="GridView1_RowDataBound">
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                            <img runat="server" src="~/images/16x16_check_grey.png" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <img id="imgApproved" runat="server" src="~/images/16x16_check.png" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="rowItem" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="120px">
                                        <HeaderTemplate>
                                            Month
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <a class="lnk" href="javascript:ShowDetail(<%#DataBinder.Eval(Container.DataItem, "month")%>,<%#DataBinder.Eval(Container.DataItem, "year")%>,'<%#DataBinder.Eval(Container.DataItem, "monthyear")%>','<%#DataBinder.Eval(Container.DataItem, "approved")%>');">
                                                <%#DataBinder.Eval(Container.DataItem, "monthyear")%></a>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Leads" DataField="initialcount" ItemStyle-CssClass="rowInitialC"
                                        HeaderStyle-CssClass="headIndivC" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Rate" DataField="initialpayment" ItemStyle-CssClass="rowInitial"
                                        HeaderStyle-CssClass="headIndiv" DataFormatString="{0:c}" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Initial" DataField="initialtotal" ItemStyle-CssClass="rowInitial"
                                        HeaderStyle-CssClass="headIndiv" DataFormatString="{0:c}" ItemStyle-Width="60px" />
                                    <asp:BoundField HeaderText="Leads" DataField="residualcount" ItemStyle-CssClass="rowResidualC"
                                        HeaderStyle-CssClass="headIndivC" ItemStyle-Width="35px" />
                                    <asp:BoundField HeaderText="Rate" DataField="residualpayment" ItemStyle-CssClass="rowResidual"
                                        HeaderStyle-CssClass="headIndiv" DataFormatString="{0:c}" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Residual" DataField="residualtotal" ItemStyle-CssClass="rowResidual"
                                        HeaderStyle-CssClass="headIndiv" DataFormatString="{0:c}" ItemStyle-Width="60px" />
                                    <asp:BoundField HeaderText="Leads" DataField="teamcount" ItemStyle-CssClass="rowTeamC"
                                        HeaderStyle-CssClass="headTeamC" ItemStyle-Width="35px" />
                                    <asp:BoundField HeaderText="Rate" DataField="teampayment" ItemStyle-CssClass="rowTeam"
                                        HeaderStyle-CssClass="headTeam" DataFormatString="{0:c}" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Team" DataField="teamtotal" ItemStyle-CssClass="rowTeam"
                                        HeaderStyle-CssClass="headTeam" DataFormatString="{0:c}" ItemStyle-Width="60px" />
                                    <asp:BoundField HeaderText="Total" DataField="indteamtotal" ItemStyle-CssClass="rowItem bold"
                                        HeaderStyle-CssClass="headItem2" DataFormatString="{0:c}" ItemStyle-Width="75px" />
                                </Columns>
                            </asp:GridView>
                            <div style="float:right; font-size:xx-small; padding:5px; margin-bottom:5px;">
                                * Includes non-deposit retention adjustment
                            </div>
                            <h5 id="hMonthYear" runat="server" style="margin: 0; padding: 5px; background-color: #B9D3EE; clear:both">
                            </h5>
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-top:15px; padding-bottom:15px">
                                        <div style="background-color: #f3f3f3; padding: 5px;">
                                            Team</div>
                                        <asp:GridView ID="gvTeam" runat="server" AutoGenerateColumns="false" CellPadding="5"
                                            GridLines="None" ShowHeader="true" BorderStyle="None" Visible="true" Width="100%">
                                            <Columns>
                                                <asp:TemplateField ItemStyle-Width="16px">
                                                    <HeaderTemplate>
                                                        <img id="Img5" runat="server" src="~/images/16x16_icon.png" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <img id="Img7" runat="server" src="~/images/16x16_person2.png" />
                                                    </ItemTemplate>
                                                    <HeaderStyle CssClass="headItem" />
                                                    <ItemStyle CssClass="rowItem" HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:BoundField HeaderText="Rep" DataField="rep" ItemStyle-CssClass="rowItem" HeaderStyle-CssClass="headItem" />
                                                <asp:BoundField HeaderText="Leads" DataField="initialcount" ItemStyle-CssClass="rowItemC"
                                                    HeaderStyle-CssClass="headItemC" ItemStyle-Width="50px" />
                                            </Columns>
                                            <EmptyDataTemplate>
                                                (Rep has no team members this month)
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="background-color: #f3f3f3; padding: 5px; width: 352px;">
                                            Initials (<asp:Label ID="lblInitialCnt" runat="server" ForeColor="Blue" CssClass="entry2"></asp:Label>)</div>
                                        <table cellpadding="5" cellspacing="0" border="0">
                                            <tr>
                                                <td style="width: 16px" class="headItem">
                                                    <img id="Img8" runat="server" src="~/images/16x16_icon.png" />
                                                </td>
                                                <td style="width: 60px" class="headItem">
                                                    Lead ID
                                                </td>
                                                <td style="width: 60px" class="headItem">
                                                    Acct#
                                                </td>
                                                <td style="width: 176px" class="headItem">
                                                    Client
                                                </td>
                                            </tr>
                                        </table>
                                        <div style="overflow: auto; width: 352px; height: 220px">
                                            <asp:GridView ID="gvInitial" runat="server" AutoGenerateColumns="false" CellPadding="5"
                                                GridLines="None" ShowHeader="false" BorderStyle="None" Visible="true">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="16px">
                                                        <HeaderTemplate>
                                                            <img id="Img9" runat="server" src="~/images/16x16_icon.png" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="Img10" runat="server" src="~/images/16x16_person.png" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ItemStyle-Width="60px">
                                                        <HeaderTemplate>
                                                            Lead ID
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a class="lnk" href="newenrollment2.aspx?id=<%#DataBinder.Eval(Container.DataItem, "leadapplicantid")%>"
                                                                title="View lead card" target="_blank">
                                                                <%#DataBinder.Eval(Container.DataItem, "leadapplicantid")%></a>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ItemStyle-Width="60px">
                                                        <HeaderTemplate>
                                                            Acct#
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a class="lnk" href="../client/finances/register/?id=<%#DataBinder.Eval(Container.DataItem, "clientid")%>"
                                                                title="View client record" target="_blank">
                                                                <%#DataBinder.Eval(Container.DataItem, "accountnumber")%></a>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Name" DataField="client" ItemStyle-CssClass="rowItem"
                                                        HeaderStyle-CssClass="headItem" ItemStyle-Width="160px" />
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    No initials this month
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </div>
                                    </td>
                                    <td style="padding-left:15px;">
                                        <div style="background-color: #f3f3f3; padding: 5px; width: 352px;">
                                            Residuals (<asp:Label ID="lblResidualCnt" runat="server" ForeColor="Blue" CssClass="entry2"></asp:Label>)</div>
                                        <table cellpadding="5" cellspacing="0" border="0">
                                            <tr>
                                                <td style="width: 16px" class="headItem">
                                                    <img id="Img2" runat="server" src="~/images/16x16_icon.png" />
                                                </td>
                                                <td style="width: 60px" class="headItem">
                                                    Lead ID
                                                </td>
                                                <td style="width: 60px" class="headItem">
                                                    Acct#
                                                </td>
                                                <td style="width: 176px" class="headItem">
                                                    Client
                                                </td>
                                            </tr>
                                        </table>
                                        <div style="overflow: auto; width: 352px; height: 220px">
                                            <asp:GridView ID="gvResiduals" runat="server" AutoGenerateColumns="false" CellPadding="5"
                                                GridLines="None" ShowHeader="false" BorderStyle="None" Visible="true">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="16px">
                                                        <HeaderTemplate>
                                                            <img id="Img3" runat="server" src="~/images/16x16_icon.png" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img id="Img4" runat="server" src="~/images/16x16_user.png" />
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ItemStyle-Width="60px">
                                                        <HeaderTemplate>
                                                            Lead ID
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a class="lnk" href="newenrollment2.aspx?id=<%#DataBinder.Eval(Container.DataItem, "leadapplicantid")%>"
                                                                title="View lead card" target="_blank">
                                                                <%#DataBinder.Eval(Container.DataItem, "leadapplicantid")%></a>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ItemStyle-Width="60px">
                                                        <HeaderTemplate>
                                                            Acct#
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <a class="lnk" href="../client/finances/register/?id=<%#DataBinder.Eval(Container.DataItem, "clientid")%>"
                                                                title="View client record" target="_blank">
                                                                <%#DataBinder.Eval(Container.DataItem, "accountnumber")%></a>
                                                        </ItemTemplate>
                                                        <HeaderStyle CssClass="headItem" />
                                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Name" DataField="client" ItemStyle-CssClass="rowItem"
                                                        HeaderStyle-CssClass="headItem" ItemStyle-Width="160px" />
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    No residuals this month
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" style="padding-left: 15px; border-left: dotted 1px #999999">
                            <table cellpadding="5" cellspacing="0" border="0">
                                <tr>
                                    <td style="width: 300px; text-align: center; background-color: #D1EEEE">
                                        Non-Deposit Retention
                                    </td>
                                </tr>
                            </table>
                            <asp:GridView ID="gvNonDepositRetention" runat="server" AutoGenerateColumns="false" CellPadding="5"
                                GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true">
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="80px" HeaderStyle-Height="27px" ItemStyle-Height="29px">
                                        <HeaderTemplate>
                                            Month
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <a class="lnk" href="javascript:ShowConvDetail(<%#DataBinder.Eval(Container.DataItem, "month")%>,<%#DataBinder.Eval(Container.DataItem, "year")%>,'<%#DataBinder.Eval(Container.DataItem, "monthyear")%>');">
                                                <%#DataBinder.Eval(Container.DataItem, "monthyear")%></a>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem4" />
                                        <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Clients" DataField="nondeposits" ItemStyle-CssClass="rowItem2"
                                        HeaderStyle-CssClass="headItem3" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Success" DataField="replacements" ItemStyle-CssClass="rowItem2"
                                        HeaderStyle-CssClass="headItem3" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Conv." DataField="conv" ItemStyle-CssClass="rowItem2" HeaderStyle-CssClass="headItem3"
                                        DataFormatString="{0:p1}" ItemStyle-Width="45px" />
                                    <asp:BoundField HeaderText="Adj." DataField="adjustment" ItemStyle-CssClass="rowItem2" HeaderStyle-CssClass="headItem3"
                                        DataFormatString="{0:p0}" ItemStyle-Width="45px" />
                                </Columns>
                            </asp:GridView>
                            <br />
                            <h5 id="hConvMonthYear" runat="server" style="margin: 0; padding: 5px; background-color: #B9D3EE">
                            </h5>
                            <div style="background-color: #f3f3f3; padding: 5px; width: 310px; margin-top:15px;">
                                Clients (<asp:Label ID="lblLeads" runat="server" ForeColor="Blue" CssClass="entry2"
                                    Text="0"></asp:Label>)</div>
                            <table cellpadding="5" cellspacing="0" border="0">
                                <tr>
                                    <td style="width: 16px" class="headItem">
                                        <img id="Img1" runat="server" src="~/images/16x16_icon.png" alt="" />
                                    </td>
                                    <td style="width: 50px" class="headItem">
                                        Acct#
                                    </td>
                                    <td style="width: 119px" class="headItem">
                                        Client
                                    </td>
                                    <td style="width: 85px" class="headItem">
                                        Deposit
                                    </td>
                                </tr>
                            </table>
                            <div style="overflow: auto; width: 310px; height: 260px">
                                <asp:GridView ID="gvConversionDetail" runat="server" AutoGenerateColumns="false"
                                    CellPadding="5" GridLines="None" ShowHeader="false" BorderStyle="None" Visible="true">
                                    <Columns>
                                        <asp:TemplateField ItemStyle-Width="16px">
                                            <ItemTemplate>
                                                <img id="Img6" runat="server" src="~/images/16x16_person2.png" alt="" />
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="headItem" />
                                            <ItemStyle CssClass="rowItem" HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:TemplateField ItemStyle-Width="60px">
                                            <ItemTemplate>
                                                <a class="lnk" href="../client/finances/register/?id=<%#DataBinder.Eval(Container.DataItem, "clientid")%>"
                                                    target="_blank">
                                                    <%#DataBinder.Eval(Container.DataItem, "accountnumber")%></a>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="rowItem" HorizontalAlign="left" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="client" ItemStyle-CssClass="rowItem" ItemStyle-Width="174px" ItemStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="depositdate" ItemStyle-CssClass="rowItem" ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Left" DataFormatString="{0:MMM d}" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        No non-deposits this month.
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divLoading" style="display: none; height: 48px; width: 48px; border: solid 1px #999999;
                background-color: #ffffff; padding: 20px">
                <asp:Image ID="imgLoading" runat="server" ImageUrl="~/images/ajax-loader.gif" />
            </div>
            <asp:LinkButton ID="lnkApprove" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkLoadDetail" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkLoadConvDetail" runat="server"></asp:LinkButton>
            <asp:HiddenField ID="hdnMonth" runat="server" Value="0" />
            <asp:HiddenField ID="hdnYear" runat="server" Value="0" />
            <asp:HiddenField ID="hdnMonthYear" runat="server" Value="" />
            <asp:HiddenField ID="hdnApproved" runat="server" Value="0" />
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <script type="text/javascript">
        function onUpdating() {
            var divLoading = $get('divLoading');
            divLoading.style.display = '';

            var div = $get('tblBody');

            var bounds = Sys.UI.DomElement.getBounds(div);
            var loadingBounds = Sys.UI.DomElement.getBounds(divLoading);

            var x = bounds.x + Math.round(bounds.width / 2) - Math.round(loadingBounds.width / 2);
            var y = 170;  //bounds.y + Math.round(bounds.height / 2) - Math.round(loadingBounds.height / 2);

            Sys.UI.DomElement.setLocation(divLoading, x, y);
        }

        function onUpdated() {
            var divLoading = $get('divLoading');
            divLoading.style.display = 'none';
        }
             
    </script>

    <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1">
        <Animations>
            <OnUpdating>
                <Parallel duration="0">
                    <ScriptAction Script="onUpdating();" />  
                    <EnableAction AnimationTarget="tblBody" Enabled="false" />
                 </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration="0">
                    <EnableAction AnimationTarget="tblBody" Enabled="true" />
                    <ScriptAction Script="onUpdated();" /> 
                </Parallel> 
            </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>
    
</asp:Content>
