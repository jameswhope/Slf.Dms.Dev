<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/research/reports/reports.master"
    CodeFile="Default.aspx.vb" Inherits="research_reports_financial_accounting_Default"
    Title="DMP - Accounting" %>

<%--MasterPageFile="~/research/reports/reports.master"--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
    
.MyCalendar .ajax__calendar_header {height:20px;width:100%;background-color:lightsteelblue}
.MyCalendar .ajax__calendar_today {cursor:pointer;padding-top:3px; background-color:lightsteelblue}

    
    .MyCalendar .ajax__calendar_container 
    {
        border:1px solid #646464;
        background-color: white;
        color: black;
    }
    .MyCalendar .ajax__calendar_other .ajax__calendar_day,
    .MyCalendar .ajax__calendar_other .ajax__calendar_year 
        {
            color: gray;
        }
    .MyCalendar .ajax__calendar_hover .ajax__calendar_day,
    .MyCalendar .ajax__calendar_hover .ajax__calendar_month,
    .MyCalendar .ajax__calendar_hover .ajax__calendar_year 
        {
            color: black;
            
        }
    .MyCalendar .ajax__calendar_active .ajax__calendar_day,
    .MyCalendar .ajax__calendar_active .ajax__calendar_month,
    .MyCalendar .ajax__calendar_active .ajax__calendar_year 
        {
            color: black;
            font-weight:bold;
            background-color:lightsteelblue;
        }
</style>

    <script type="text/javascript">
	function SetDates(ddl)
	{
	    var txtTransDate1 = document.getElementById("<%=txtStart.ClientId %>");
	    var txtTransDate2 = document.getElementById("<%=txtEnd.ClientId %>");

	    var str = ddl.value;
	    if (str != "Custom")
	    {
	        var parts = str.split(",");
	        txtTransDate1.value=parts[0];
	        txtTransDate2.value=parts[1];
	    }
	}
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="sm1" runat="server" />
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="ud1">
        <ProgressTemplate>
            <div class="AjaxProgressMessage">
                <br />
                <img id="Img2" alt="" src="~/images/loading.gif" runat="server" /><asp:Label ID="ajaxLabel"
                    name="ajaxLabel" runat="server" Text="Loading Report..." />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="ud1" runat="server">
        <ContentTemplate>
            <div style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%;
                padding-top: 5px">
                <asp:Label ID="lblMsg" runat="server" Font-Size="14"></asp:Label>
                <div style="overflow: auto">
                    <table style="table-layout: fixed; font-size: 11px; width: 100%; font-family: tahoma;
                        height: 100%" cellspacing="0" cellpadding="0" border="0">
                        <tbody>
                            <tr>
                                <td valign="top">
                                    <div style="display: none" id="dvError" runat="server">
                                        <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                            border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                            font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                            width="100%" border="0">
                                            <tbody>
                                                <tr>
                                                    <td valign="top" width="20">
                                                        <img id="Img1" src="~/images/message.png" align="absMiddle" border="0" runat="server" /></td>
                                                    <td id="tdError" runat="server">
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 25px" valign="middle">
                                <td nowrap>
                                    <table style="font-size: 11px; width: 100%; font-family: tahoma; background-image: url(../../../../images/grid_top_back.bmp);"
                                        cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td nowrap>
                                                    <img id="Img3" src="~/images/grid_top_left.png" border="0" runat="server" />
                                                </td>
                                                <td style="width: 100%">
                                                    <table style="background-position: left top; font-size: 11px; background: url(~/images/grid_top_back.bmp);
                                                        width: 100%; background-repeat: repeat-x; font-family: tahoma; height: 25px"
                                                        cellspacing="0" cellpadding="0" border="0">
                                                        <tbody>
                                                            <tr>
                                                                <td id="tblFirm" runat="server" style="display: none">
                                                                    <table>
                                                                        <tbody>
                                                                            <tr style="font-size: 11px; font-family: Tahoma">
                                                                                <td style="white-space: nowrap;">
                                                                                    Firm:
                                                                                    <asp:DropDownList ID="ddlFirm" Style="font-size: 11px; font-family: Tahoma" runat="server"
                                                                                        DataTextField="display" DataValueField="commrecid" />
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td>
                                                                    <table style="display: none" id="tblDates" runat="server">
                                                                        <tbody>
                                                                            <tr style="font-size: 8pt">
                                                                                <td style="white-space: nowrap;">
                                                                                    <asp:DropDownList Style="font-size: 11px; font-family: Tahoma" ID="ddlQuickPickDate"
                                                                                        runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuickPickDate_SelectedIndexChanged">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:Label ID="Label1" runat="server" Text="Start Date:"></asp:Label>
                                                                                </td>
                                                                                <td style="white-space: nowrap;">
                                                                                    <asp:TextBox ID="txtStart" runat="server" Font-Size="8pt" Width="85"></asp:TextBox>
                                                                                    <asp:ImageButton ID="Image1" runat="Server" AlternateText="Click to show calendar"
                                                                                        ImageUrl="~/images/Calendar_scheduleHS.png"></asp:ImageButton>
                                                                                    <ajaxToolkit:CalendarExtender ID="extStart" runat="server" CssClass="MyCalendar"
                                                                                        PopupButtonID="image1" TargetControlID="txtStart">
                                                                                    </ajaxToolkit:CalendarExtender>
                                                                                </td>
                                                                                <td style="white-space: nowrap;">
                                                                                    End Date:</td>
                                                                                <td style="white-space: nowrap;">
                                                                                    <asp:TextBox ID="txtEnd" runat="server" Font-Size="8pt" Width="85"></asp:TextBox>
                                                                                    <asp:ImageButton ID="ImageButton1" runat="Server" AlternateText="Click to show calendar"
                                                                                        ImageUrl="~/images/Calendar_scheduleHS.png"></asp:ImageButton>
                                                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" CssClass="MyCalendar"
                                                                                        PopupButtonID="ImageButton1" TargetControlID="txtEnd">
                                                                                    </ajaxToolkit:CalendarExtender>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <table style="display: none" id="tblDays" runat="server">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td style="font-size: 8pt">
                                                                                    Days Since Last Deposit:
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox ID="txtDaysSince" runat="server" Font-Size="8pt" Width="85" Height="20"></asp:TextBox>
                                                                                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtDaysSInce"
                                                                                        Mask="99" DisplayMoney="None" MaskType="Number">
                                                                                    </ajaxToolkit:MaskedEditExtender>
                                                                                </td>
                                                                                <td id="nodeposits" style="font-size: 8pt; display: none; vertical-align: top; ">
                                                                                    &nbsp;-- Or-- With No Deposits Only: <asp:CheckBox ID="chkNodeposits" runat="server" Font-Size="8pt" />
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td style="white-space: nowrap;">
                                                                    <img style="margin: 0px 3px" id="Img8" src="~/images/grid_top_separator.bmp" runat="server" /></td>
                                                                <td style="white-space: nowrap;">
                                                                    <asp:LinkButton ID="lnkView" runat="server" CssClass="gridButton">View Report</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%; height: 100%" valign="top">
                                    <div style="overflow: auto; width: 100%; height: 600px">
                                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Size="8pt" Width="100%"
                                            Height="100%" Font-Names="tahoma">
                                            <LocalReport DisplayName="rpt"></LocalReport> 
                                        </rsweb:ReportViewer>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlQuickPickDate" EventName="SelectedIndexChanged">
            </asp:AsyncPostBackTrigger>
            <asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click"></asp:AsyncPostBackTrigger>
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
