<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ReportsControl.ascx.vb"
    Inherits="negotiation_webparts_ReportsControl" %>

<script type="text/javascript" language="javascript">
    function checkAll(chk_SelectAll) {
        var frm = document.forms[0];
        var chkState = chk_SelectAll.checked;
        for (i = 0; i < frm.length; i++) {
            var el = frm.elements[i];
            if (el.type == "checkbox" && el.name.indexOf('chk_select') != -1) {
                el.checked = chkState;
            }
        }
    }
    function closePopup() {
        var modalPopupBehavior = $find('programmaticModalPopupBehavior');
        modalPopupBehavior.hide();
        return false;
    }
</script>

<style type="text/css">
    .fixedHeader th
    {
        overflow: hidden;
        position: relative;
        top: expression(this.parentNode.parentNode.parentNode.parentNode.parentNode.scrollTop-1);
        text-align: LEFT;
        table-layout: fixed;
        background-color: #DCDCDC;
        border-bottom: solid 1px #d3d3d3;
        font-weight: normal;
        color: Black;
        font-size: 11px;
        font-family: tahoma;
    }
    .ErrorBox
    {
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 12px;
        text-align: left;
        background: #fff7d7;
        padding: 20px;
        border-width: thin;
        border-color: #FF0000;
        border-style: solid;
        width: 80%;
    }
    .listItem
    {
        cursor: pointer;
        border-bottom: solid 1px #d3d3d3;
    }
    .cpHeader
    {
        color: white;
        background-color: #CCE4F0;
        font: bold 11px auto "Trebuchet MS" , Verdana;
        font-size: 12px;
        cursor: pointer;
        width: 100%;
        height: 18px;
        padding: 4px;
    }
    .cpBody
    {
        border: 1px gray;
        width: 100%;
        padding: 4px;
        padding-top: 7px;
    }
</style>
<asp:ScriptManagerProxy ID="smReports" runat="server" />
<asp:UpdatePanel ID="upReports" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <div id="dlg" style="width: 100%">
            <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Size="14px" Style="padding-right: 15px;" />
            <asp:Panel ID="pHeader" runat="server" CssClass="cpHeader">
                <table class="entry">
                    <tr>
                        <td align="left">
                            <asp:Label ID="spnHdr" runat="server" class="reportheader" Font-Bold="True" Font-Size="14px" />
                        </td>
                        <td align="right">
                            <asp:Button ID="lnkView" runat="server" Text="View Reports" Font-Bold="true" Font-Size="14px"
                                CssClass="fakeButtonStyle" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pBody" runat="server" CssClass="cpBody">
                <asp:Panel Style="margin-left: 10px; margin-right: 10px; position: relative;" ID="pnlReports"
                    runat="server" Height="265" ScrollBars="Vertical">
                    <div>
                        <asp:GridView ID="gvReports" runat="server" EnableViewState="False" AutoGenerateColumns="False"
                            Width="98%" CellPadding="4" ForeColor="black" GridLines="None" CssClass="fixedHeader"
                            AllowSorting="True" ToolTip="Select report to view.">
                            <SelectedRowStyle CssClass="webpartgridselectedrowstyle" />
                            <AlternatingRowStyle CssClass="webpartgridaltrowstyle" />
                            <RowStyle CssClass="listitem" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <input type="checkbox" id="chk_selectAll" runat="server" onclick="checkAll(this);" />
                                    </HeaderTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <input type="checkbox" runat="server" id="chk_select" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="listItem" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="ReportType" HeaderText="Report Type" Visible="false" SortExpression="ReportType"
                                    ItemStyle-CssClass="listItem" />
                                <asp:BoundField DataField="ReportName" HeaderText="Report Name" ItemStyle-Wrap="true"
                                    SortExpression="ReportName">
                                    <ItemStyle Wrap="True" CssClass="listItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ReportTypeName" HeaderText="Report Type Name" SortExpression="ReportTypeName"
                                    ItemStyle-CssClass="listItem" />
                                <asp:BoundField DataField="ReportSentDate" HeaderText="Report Sent Date" ItemStyle-Wrap="false"
                                    SortExpression="ReportSentDate">
                                    <ItemStyle Wrap="False" CssClass="listItem" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ReportArguments" HeaderText="Report Arguments" ItemStyle-CssClass="listItem" />
                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="odsReports" runat="server" SelectMethod="BuildReportsDataTableSpecificReports"
                            TypeName="LexxiomLetterTemplates.LetterTemplates" DataObjectTypeName="negReports">
                            <SelectParameters>
                                <asp:Parameter Name="BuildReportsDataTableSpecificReports" Type="String" />
                                <asp:Parameter Name="sClientID" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </div>
                </asp:Panel>
            </asp:Panel>
            
            <asp:Button runat="server" ID="hiddenTargetControlForModalPopup" Style="display: none" />
            <ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior"
                TargetControlID="hiddenTargetControlForModalPopup" PopupControlID="programmaticPopup"
                BackgroundCssClass="modalBackgroundNeg" DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle"
                Y="50">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Panel runat="server" CssClass="modalPopupNeg" ID="programmaticPopup" Style="display: none;
                height: 400px;">
                <asp:Panel ID="programmaticPopupDragHandle" runat="server" Style="display: block;"
                    CssClass="PanelDragHeader">
                    <table class="entry" cellpadding="0" cellspacing="0">
                        <tr class="headerstyle">
                            <td align="left" style="padding-left: 10px;">
                                <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Creditor Reports" />
                            </td>
                            <td align="right" style="padding-right: 5px;">
                                <asp:ImageButton ID="imgClose" runat="server" OnClientClick="closePopup();return false;"
                                    ImageUrl="~/images/16x16_close.png" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel runat="Server" ID="pnlRpt">
                    <div id="dvReport" runat="server" style="height: 375px; z-index: 51; visibility: visible;
                        background-color: Transparent;">
                        <iframe id="frmReport" runat="server" src="../../Clients/client/reports/report.aspx"
                            style="width: 100%; height: 100%;" frameborder="0" />
                    </div>
                    <table class="entry" border="0" style="background-color: #DCDCDC; border-top: solid 1px #3D3D3D;">
                        <tr valign="middle">
                            <td>
                                <div class="entry" style="text-align: right; padding-right: 3px; height: 25px; vertical-align: middle;">
                                    <asp:Button ID="lnkCancel" runat="server" Text="Close" OnClientClick="return closePopup();"
                                        CssClass="fakeButtonStyle" Font-Size="12" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </asp:Panel>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="lnkView" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
<asp:HiddenField ID="sortDir" runat="server" />
