<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="AttorneyPendingQueue.aspx.vb" Inherits="Clients_Enrollment_AttorneyPendingQueue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
    <link href="<%= ResolveUrl("~/css/portal.css")%>" rel="stylesheet" type="text/css" />
    <link  href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet" type="text/css" />
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
     <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a id="A1" runat="server" class="menuButton" href="default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_back.png" />Reports</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" /> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
    <div style="margin: 10px 10px 10px 10px;" >
       <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <h2 id="hPending" runat="server">
            </h2>
            <div style="clear: both">
                <div class="pendinggrouphdr">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="width: 20px">
                                &nbsp;
                            </td>
                            <td style="width: 260px">
                                Name
                            </td>
                            <td style="width: 100px">
                                State
                            </td>
                            <td style="width: 100px; text-align: right">
                                Total Debt
                            </td>
                            <td style="width: 100px; text-align: center">
                                Creditors
                            </td>
                            <td style="width: 80px; text-align: right">
                                Deposit Total
                            </td>
                            <td style="width: 100px; text-align: center">
                                Days
                            </td>
                            <td style="width: 100px; text-align: center">
                                Law Firm
                            </td>
                            <td style="width: 80px;">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="overflow: auto; height: auto">
                    <ajaxtoolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="false"
                        FadeTransitions="true" TransitionDuration="100" FramesPerSecond="50" RequireOpenedPane="false"
                        HeaderCssClass="accordionHeader" HeaderSelectedCssClass="accordionSelectedHeader"
                        ContentCssClass="accordionContent">
                        <HeaderTemplate>
                            <div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="width: 20px">
                                            <img src="<%= ResolveUrl("~/images/16x16_user.png") %>" alt="" />
                                        </td>
                                        <td style="width: 260px">
                                            <%#Eval("name")%>
                                        </td>
                                        <td style="width: 100px">
                                            <%#Eval("state")%>
                                        </td>
                                        <td style="width: 100px; text-align: right">
                                            <%#Eval("totaldebt", "{0:c0}")%>
                                        </td>
                                        <td style="width: 100px; text-align: center">
                                            <%#Eval("nocreditors")%>
                                        </td>
                                        <td style="width: 80px; text-align: right">
                                            <%#Eval("deposittotal", "{0:c0}")%>
                                        </td>
                                        <td style="width: 100px; text-align: center">
                                            <%#Eval("daysinservice")%>
                                        </td>
                                        <td style="width: 100px; text-align: center">
                                            <%#Eval("lawfirm")%>
                                        </td>
                                        <td style="width: 80px" align="right">
                                            <asp:HiddenField ID="hdnLeadApplicantID" runat="server" Value="<%# Bind('leadapplicantid') %>" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </HeaderTemplate>
                        <ContentTemplate>
                            <div class="accordionContentDiv">
                                <table width="500px">
                                    <tr>
                                        <td valign="top" style="width: 65px">
                                            Creditors:
                                        </td>
                                        <td>
                                            <asp:GridView ID="gvCreditors" runat="server" AutoGenerateColumns="false" DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>'
                                                CellPadding="5" Width="100%" GridLines="None" ShowHeader="False" BorderStyle="None">
                                                <Columns>
                                                    <asp:TemplateField ItemStyle-Width="16px" ItemStyle-CssClass="gridviewItem">
                                                        <ItemTemplate>
                                                            <img src="<%= ResolveUrl("~/images/16x16_dataentry.png") %>" alt="" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="creditor" ItemStyle-CssClass="gridviewItem" />
                                                    <asp:BoundField DataField="currentamount" DataFormatString="{0:c}" ItemStyle-CssClass="gridviewItem"
                                                        ItemStyle-HorizontalAlign="Right" />
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            Hardship:
                                        </td>
                                        <td>
                                            <asp:GridView ID="gvHardship" runat="server" AutoGenerateColumns="false" DataSource='<%# Container.DataItem.CreateChildView("Hardship") %>'
                                                CellPadding="5" Width="100%" GridLines="None" ShowHeader="False" BorderStyle="None">
                                                <Columns>
                                                    <asp:BoundField DataField="hardship" ItemStyle-CssClass="gridviewItem" />
                                                </Columns>
                                                <EmptyDataRowStyle CssClass="gridviewItem" />
                                                <EmptyDataTemplate>
                                                    NA
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            Income:
                                        </td>
                                        <td>
                                            <asp:GridView ID="gvIncome" runat="server" AutoGenerateColumns="false" DataSource='<%# Container.DataItem.CreateChildView("Hardship") %>'
                                                CellPadding="5" Width="100%" GridLines="None" ShowHeader="False" BorderStyle="None">
                                                <Columns>
                                                    <asp:BoundField DataField="monthlyincome" ItemStyle-CssClass="gridviewItem" DataFormatString="{0:c}" />
                                                </Columns>
                                                <EmptyDataRowStyle CssClass="gridviewItem" />
                                                <EmptyDataTemplate>
                                                    NA
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:ShowClientInfo(<%#Eval("leadapplicantid")%>);">
                                                <img src="<%= ResolveUrl("~/images/16x16_doc.png")%>" style="vertical-align: middle" border="0" alt="">Client Info
                                                Sheet</a> &nbsp; <a href="javascript:ShowLSA('<%#GetLSADocPath(Eval("leadapplicantid"))%>');">
                                                    <img src="<%= ResolveUrl("~/images/16x16_pdf.png")%>" style="vertical-align: middle" border="0" alt="">
                                                    Legal Service Agreement</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </ajaxtoolkit:Accordion>

                    <script type="text/javascript" language="javascript">
                        var toggle = false;

                        function pageLoad() {
                            $(document).ready(function() {
                                if ($("#<%= hdnNoTab.ClientId%>").val() == "1") {
                                    $(".tabMainHolder").closest("tbody").prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                                    $(".menuTable").closest("td").css('height', '0px');
                                    $(".menuTable").closest("tr").css('height', '0px');
                                    $(".tabMainHolder, .tabTxtHolder").closest("tr").remove();
                                    $(".menuTable").remove();
                                }
                            });
                            var accId = '<%=Accordion1.ClientID %>';
                            var accX = accId + '_AccordionExtender';

                            $find(accX).add_selectedIndexChanging(onselectedIndexChanging);
                        }
                        function onselectedIndexChanging(obj, e) {
                            if (toggle)
                                e.set_cancel(true);
                            toggle = false;
                        }
                        function onchange() {
                            toggle = true;

                        }
                    </script>

                </div>
            </div>
            <asp:Panel ID="pnlClientInfoSheet" runat="server" CssClass="modalPopupTracker" Width="800px">
                <div style="float: right">
                    <a href="javascript:CloseClientInfo();">
                        <img align="absmiddle" src="<%= ResolveUrl("~/images/16x16_close.png")%>" alt="" border="0" />
                    </a>
                </div>
                <div style="padding: 17px 0 0 0">
                    <iframe id="iframe1" width="100%" height="480px"></iframe>
                </div>
            </asp:Panel>
            <asp:Button ID="dummyButton2" runat="server" Text="Button" Style="display: none" />
            <asp:Button ID="dummyClose" runat="server" Text="Button" Style="display: none" />
            <ajaxtoolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="dummyButton2"
                PopupControlID="pnlClientInfoSheet" CancelControlID="dummyClose" BackgroundCssClass="modalBackgroundTracker"
                RepositionMode="RepositionOnWindowResize" BehaviorID="ClientInfoBehavior">
            </ajaxtoolkit:ModalPopupExtender>

            <script language="javascript" type="text/javascript">
                function ShowClientInfo(id) {
                    document.getElementById('iframe1').src = 'reports/clientinfosheet.aspx?id=' + id;
                    $find('ClientInfoBehavior').show();
                }

                function ShowLSA(path) {
                    document.getElementById('iframe1').src = path;
                    $find('ClientInfoBehavior').show();
                }

                function CloseClientInfo() {
                    $find('ClientInfoBehavior').hide();
                }
            </script>

        </ContentTemplate>
        <Triggers>
            
        </Triggers>
    </asp:UpdatePanel>
    </div>
    <div style="float: right; height: 40px; text-align:right">
        <table>
            <tr>
                <td style="width:16px">
                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                        DisplayAfter="0">
                        <ProgressTemplate>
                            <div style="padding: 8px; background-color: #fff">
                                <img src="<%= ResolveUrl("~/images/loading.gif")%>" style="vertical-align: middle" alt="" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </td>
                <td>
                </td>
            </tr>
        </table>
    </div>         
</asp:Content>


