<%@ Page Title="" Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false"
    CodeFile="dialercalls.aspx.vb" Inherits="research_reports_dialer_calls_dialercalls" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        fieldset
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #fff;
            text-align: left;
            height: 100%;
            padding: 3px;
        }
        fieldset legend
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #fff;
            padding: 5px;
            text-align: left;
        }
        .filter
        {
            background-color: #6CA6CD;
        }
        .filter th, .results
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #fff;
            text-align: left;
        }
    </style>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script language="javascript" type="text/javascript">
        function SetDates(ddl) {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            }
        }
        function SetDatesGeneric(ddl, txtStart, txtEnd) {
            var txtTransDate1 = document.getElementById(txtStart);
            var txtTransDate2 = document.getElementById(txtEnd);
            var str = ddl.value;
            if (str != "Custom" && str != "-1") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            } else {
                txtTransDate1.value = "";
                txtTransDate2.value = "";
            }

        }

        function CheckForAll() {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            if (!IsValidDateTime(txtTransDate1.value)) {
                alert("You entered an invalid start date value.");
                return false;
            } else if (!IsValidDateTime(txtTransDate2.value)) {
                alert("You entered an invalid end date value.");
                return false;
            } else
                return true;
        }
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </ajaxToolkit:ToolkitScriptManager>
    <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td class="filter">
                <table class="entry" border="0">
                    <tr valign="top">
                        <td valign="top" style="width: 300px; height: 40px;">
                            <asp:UpdatePanel ID="updFilters" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <fieldset>
                                        <legend>Dialer Filters:</legend>
                                        <table border="0" cellpadding="0" cellspacing="0" class="entry" style="color: White;">
                                            <tr style="white-space: nowrap;">
                                                <td align="right">
                                                    &nbsp;Group:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlDialerGroup" runat="server" CssClass="entry2" DataSourceID="ds_DialerGroup"
                                                        DataTextField="DialerGroupName" DataValueField="DialergroupId" AutoPostBack="True">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="ds_DialerGroup" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        SelectCommand="select dg.DialergroupId, dg.DialerGroupName from tbldialergroup dg order by DialerGroupId"
                                                        SelectCommandType="Text"></asp:SqlDataSource>
                                                </td>
                                                <td align="right" id="tdQueue" runat="server">
                                                    &nbsp;Queue:
                                                </td>
                                                <td id="tdQueue1" runat="server">
                                                    <asp:DropDownList ID="ddlQueue" runat="server" CssClass="entry2" DataSourceID="ds_DialerQueue"
                                                        DataTextField="QueueName" DataValueField="QueueId">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="ds_DialerQueue" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        SelectCommand="select q.QueueId, q.QueueName from tbldialerworkgroupqueue q Where q.DialerGroupId=@GroupId order by q.QueueId"
                                                        SelectCommandType="Text">
                                                        <SelectParameters>
                                                            <asp:ControlParameter Name="GroupId" ControlID="ddlDialerGroup" PropertyName="SelectedValue"
                                                                DbType="Int32" />
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </td>
                                                <td id="tdCallReason" runat="server" align="right" sytle="white-space: nowrap;">
                                                    &nbsp;Queue:
                                                </td>
                                                <td id="tdCallReason1" runat="server">
                                                    <asp:DropDownList ID="ddlDialerReason" runat="server" CssClass="entry2" DataSourceID="ds_DialerReason"
                                                        DataTextField="Description" DataValueField="ReasonId">
                                                    </asp:DropDownList>
                                                    <asp:SqlDataSource ID="ds_DialerReason" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                                        SelectCommand="select r.ReasonId, r.Description from tbldialercallreasontype r order by r.ReasonId"
                                                        SelectCommandType="Text"></asp:SqlDataSource>
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                        <td valign="top" style="width: 125px;">
                            <fieldset style="height: 100%;">
                                <legend>Date Filters:</legend>
                                <table border="0" cellpadding="0" cellspacing="0" class="entry" style="color: White;">
                                    <tr style="white-space: nowrap;">
                                        <td align="right">
                                            &nbsp;Created:
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlQuickPickDate" runat="server" CssClass="entry2">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 20px; text-align: center;">
                                            &nbsp;From:
                                        </td>
                                        <td>
                                            <cc1:InputMask class="entry" runat="server" ID="txtTransDate1" Mask="nn/nn/nnnn"></cc1:InputMask>
                                        </td>
                                        <td style="width: 20px; text-align: center;">
                                            &nbsp;To:
                                        </td>
                                        <td>
                                            <cc1:InputMask class="entry" runat="server" ID="txtTransDate2" Mask="nn/nn/nnnn"></cc1:InputMask>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                        <td>
                            <fieldset style="text-align: center; width: 100px;">
                                <legend>Actions</legend>
                                <table border="0" cellpadding="0" cellspacing="0" class="entry">
                                    <tr>
                                        <td align="center">
                                            <asp:Button Width="200px" ID="btnRefresh" runat="server" Text="View" CssClass="entry2"
                                                OnClientClick="return CheckForAll();" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 20px; text-align: left; padding-left: 5px;  font-size: 12px;" >
                <asp:Label ID="lblFilter" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="600px" Width="1430px">
                    <Bands>
                        <igtbl:UltraGridBand>
                            <AddNewRow View="NotSet" Visible="NotSet">
                            </AddNewRow>
                        </igtbl:UltraGridBand>
                    </Bands>
                    <DisplayLayout AllowSortingDefault="No" AllowColSizingDefault="NotSet"  AllowColumnMovingDefault="None"
                        AllowDeleteDefault="No" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                        HeaderClickActionDefault="Select" Name="UltraWebGrid1" RowHeightDefault="20px"
                        RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                        StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy"
                        IndentationDefault="22" ColWidthDefault="90px" LoadOnDemand="NotSet" NoDataMessage="" >
                        <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                            BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="1430px">
                        </FrameStyle>
                        <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Left">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </HeaderStyleDefault>
                        <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                            Font-Names="Tahoma" Font-Size="11px">
                            <Padding Left="3px" />
                            <BorderDetails ColorLeft="Window" ColorTop="Window" />
                        </RowStyleDefault>
                        <ActivationObject BorderColor="" BorderWidth="">
                        </ActivationObject>
                    </DisplayLayout>
                </igtbl:UltraWebGrid>
            </td>
        </tr>
    </table>
</asp:Content>
