<%@ Page Title="" Language="VB" MasterPageFile="~/admin/settlementtrackerimport/trackerimport.master"
    AutoEventWireup="false" CodeFile="rejected.aspx.vb" Inherits="admin_settlementtrackerimport_reports_rejected" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>    
<script type="text/javascript">
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
       function DayChanged(DaySelect) {
        var chosenoption = DaySelect.options[DaySelect.selectedIndex] //this refers to "selectmenu"
        if (chosenoption.value != "nothing") {
            var hdn = $get("<%=hdnDay.ClientID %>");
            hdn.value = chosenoption.value;
            <%= ClientScript.GetPostBackEventReference(lnkChangeDay, nothing) %>;
        }
       }
 function PopUpSettlementCalculations(id)
        {
             var url = '<%= ResolveUrl("~/processing/popups/RejectionDetails.aspx") %>?t=Settlement Info Popup&type='+ status +'&sid='+ id;
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Settlement Info Popup",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: true,
                       height: 600, width: 700,
                       onClose: function(){
                            if ($(this).modaldialog("returnValue") == -1) {
                                window.location =window.location.href.replace(/#/g,"");
                            } 
                        }});   
        }       
    </script>

    <table runat="server" id="tblBody" style="font-family: Arial; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settlementtrackerimport/">Settlement
                    Tracker Import</a>&nbsp;>&nbsp;Rejected Settlements
            </td>
        </tr>
        <tr>
            <td>
                <div class="entry" style="text-align: center; font-weight: bold; background-color: #3376AB;
                    color: white; padding: 5px; border-bottom: solid 1px white">
                    Rejected Settlement Details
                </div>
                <%--<div class="entry" style="text-align: right; font-weight: bold; background-color: #3376AB;
                    color: white; padding: 5px;">
                    <asp:Label ID="lblFilterByDay" runat="server" Text="Filter By Day : " />
                    <asp:DropDownList ID="ddlDayFilter" runat="server" AutoPostBack="True" />
                </div>--%>
                <asp:GridView ID="gvRejectionReport" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                    CssClass="entry" DataSourceID="dsRejections" AllowPaging="true" PageSize="10">
                    <Columns>
                        <asp:BoundField DataField="SettlementDueDate" HeaderText="Settlement&nbsp;Due&nbsp;Date"
                            DataFormatString="{0:MM/dd/yyyy}">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Firm" HeaderText="Firm">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:HyperLinkField HeaderText="Client" DataTextField="clientname" DataNavigateUrlFields="clientid"
                            DataNavigateUrlFormatString="~/clients/client/?id={0}">
                            <ControlStyle CssClass="lnk" />
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:HyperLinkField>
                        <asp:HyperLinkField HeaderText="Creditor" DataTextField="creditorname" DataNavigateUrlFields="clientid,AccountID"
                            DataNavigateUrlFormatString="~/clients/client/creditors/accounts/account.aspx?id={0}&aid={1}">
                            <ControlStyle CssClass="lnk" />
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:HyperLinkField>
                        <asp:BoundField DataField="SettlementAmount" HeaderText="Settlement&nbsp;Amount"
                            DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="AvailableSDABalance" HeaderText="Available&nbsp;SDA" DataFormatString="{0:c2}">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Right" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Reason" HeaderText="Reason">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ApprovalType" HeaderText="Mode&nbsp;Of&nbsp;Rejection">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Note" HeaderText="Note">
                            <HeaderStyle CssClass="headitem5" HorizontalAlign="Left" />
                            <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>
                                <input type="hidden" id="hdnRejectedSettlementID" runat="server" value='<%#DataBinder.Eval(Container.DataItem, "SettlementId")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                            <HeaderStyle HorizontalAlign="Left" CssClass="headItem5" />
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Data.
                        <asp:LinkButton ID="lnkClearFilter" runat="server" Text="Clear Filter" OnClick="lnkClearFilter_Click" />
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="dsRejections" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                    ProviderName="System.Data.SqlClient" SelectCommandType="StoredProcedure" SelectCommand="stp_GetRejectedSettlements">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="year" Type="Int32" />
                        <asp:Parameter DefaultValue="-1" Name="month" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnYear" runat="server" />
    <asp:HiddenField ID="hdnDay" runat="server" />
    <asp:LinkButton ID="lnkChangeMonth" runat="server" />
    <asp:LinkButton ID="lnkChangeYear" runat="server" />
    <asp:LinkButton ID="lnkChangeDay" runat="server" />
</asp:Content>
