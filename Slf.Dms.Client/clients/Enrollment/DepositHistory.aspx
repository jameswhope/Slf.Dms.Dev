<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="DepositHistory.aspx.vb" Inherits="Clients_Enrollment_DepositHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet" />
    <!--#include file="mgrtoolbar.inc"-->
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css")%>" rel="stylesheet" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/validation/IsValid.js" />
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">

        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function () {
                $("#progressbar").show();

                if ($("#<%= hdnNoTab.ClientId%>").val() == "1") {
                    $(".tabMainHolder").closest("tbody").prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest("td").css('height', '0px');
                    $(".menuTable").closest("tr").css('height', '0px');
                    $(".tabMainHolder, .tabTxtHolder").closest("tr").remove();
                    $(".menuTable").remove();
                }

                $("#progressbar").hide();

                $("#dvPopup").dialog({
                    autoOpen: false,
                    width: "95%", height: "800",
                    open: function (type, data) { $(this).parent().appendTo("form"); },
                    modal: true,
                    resizable: true
                });
            });
        }

        function showModalPopup(year, month, day, rep) {
            $("#<%=hdnDay.ClientID%>").val(day);
            $("#<%=hdnMonth.ClientID%>").val(month);
            $("#<%=hdnYear.ClientID%>").val(year);
            document.getElementById("<%=lnkLoadLeads.ClientID %>").click();
        }

        function ModalPopupCompleted() {
            $("#dvPopup").dialog("open");
            $("#progressbar").hide();
        }


    </script>
    <div style="padding: 0px 20px">

        <div style="margin: 25px 0px 10px 0px; width: 100%; clear: both;">
            <h5 id="hPipeline" runat="server" style="background-color: #eee; padding: 2px 5px 2px 5px; margin: 0px;">Deposit Commits Per Day</h5>
            <div id="div1" runat="server">

                <div style="width: 100%; height: 500px; overflow: scroll">
                    <asp:GridView ID="gvrecordeddeposits" runat="server" AutoGenerateColumns="False" CellPadding="2" BorderWidth="0px" Width="100%" CssClass="entry2" DataKeyNames="daterecorded">
                        <AlternatingRowStyle BackColor="#E6FCFF" />
                        <PagerSettings Mode="NumericFirstLast" Visible="true" />
                        <Columns>

                            <asp:BoundField DataField="Month" HeaderText="Month" >
                                <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="Year" HeaderText="Year">
                                <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="one" HeaderText="1st">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="two" HeaderText="2nd">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                           <asp:BoundField DataField="three" HeaderText="3rd">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="four" HeaderText="4th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="five" HeaderText="5th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="six" HeaderText="6th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="seven" HeaderText="7th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="eight" HeaderText="8th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="nine" HeaderText="9th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="ten" HeaderText="10th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="eleven" HeaderText="11th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twelve" HeaderText="12th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="thirteen" HeaderText="13th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="fourteen" HeaderText="14th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="fifteen" HeaderText="15th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="sixteen" HeaderText="16th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="seventeen" HeaderText="17th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="eighteen" HeaderText="18th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="nineteen" HeaderText="19th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty" HeaderText="20th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-one" HeaderText="21st">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-two" HeaderText="22nd">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-three" HeaderText="23th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-four" HeaderText="24th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-five" HeaderText="25th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-six" HeaderText="26th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-seven" HeaderText="27th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-eight" HeaderText="28th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="twenty-nine" HeaderText="29th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="thirty" HeaderText="30th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="thirty-one" HeaderText="31th">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                            <asp:BoundField DataField="total" HeaderText="total">
                                <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                            </asp:BoundField>

                        </Columns>
                        <PagerStyle CssClass="pagerstyle" />
                    </asp:GridView>
                </div>
            </div>
            <asp:HiddenField ID="hdnDay" runat="server" />
            <asp:HiddenField ID="hdnMonth" runat="server" />
            <asp:HiddenField ID="hdnYear" runat="server" />
        </div>

        <div id="dvPopup" >
            <div class="modalPopupTracker" >
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
            <ContentTemplate>
                
                <table width="100%">
                    <tr>
                        <td>
                            <asp:Label Id="lblPopupTitle" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField id="lblFilters" runat="server" />
                            <asp:LinkButton ID="lnkLoadLeads" runat="server"></asp:LinkButton>
                            <input id="hdnSortField" type="hidden" runat="server"/> 
                            <input id="hdnSortDirection" type="hidden" runat="server"/>
                            
                            <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="false" CellPadding="3"
                                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true">
                                <Columns>
                                    <asp:BoundField HeaderText="Row Count" DataField="row" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Account" DataField="acct" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="ClientId" DataField="cid" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Name" DataField="name" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Deposit Day" DataField="depositday" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Amt" DataField="amount" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" DataFormatString="${0:###,###,###}">
                                        <ItemStyle HorizontalAlign="Right" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Deposit Method" DataField="method" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Trust" DataField="trust" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Type of Deposit" DataField="type" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Center" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Created/Approved" DataField="created" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" dataformatstring="{0:MMMM d, yyyy}">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Initial Date" DataField="initial" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" dataformatstring="{0:MMMM d, yyyy}">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Monthly Start" DataField="monthly" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem" dataformatstring="{0:MMMM d, yyyy}">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Product" DataField="product" ItemStyle-CssClass="creditor-item" HeaderStyle-CssClass="headItem">
                                        <ItemStyle HorizontalAlign="Left" CssClass="listItem" />
                                        <HeaderStyle HorizontalAlign="Left" CssClass="headItem" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                
            </ContentTemplate>
<%--            <Triggers>
                <asp:PostBackTrigger ControlID ="lnkExport" />
            </Triggers> --%>
            </asp:UpdatePanel>
        </div>
        </div>

    </div>
</asp:Content>
