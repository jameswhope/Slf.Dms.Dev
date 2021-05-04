<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ScanningControl.ascx.vb" Inherits="CustomTools_UserControls_Scanning_ScanningControl" %>
<script type="text/javascript">
    function ReloadScanPage() {
        window.location.reload();
    }
   
    function OpenScanPopup() {
        var frmScan = document.getElementById('<%=frmScan.clientId() %>');
        frmScan.src = '<%=ScanUrl() %>';
        var modalPopupBehavior = $find('programmaticModalPopupBehavior2');
        modalPopupBehavior.show();        

    }
   
</script> 
<ajaxToolkit:ModalPopupExtender runat="server" ID="programmaticModalPopup" BehaviorID="programmaticModalPopupBehavior2"
    TargetControlID="lnkScan" PopupControlID="programmaticPopup" BackgroundCssClass="modalBackgroundNeg"
    DropShadow="false" PopupDragHandleControlID="programmaticPopupDragHandle" 
    OnCancelScript="ReloadScanPage();">
</ajaxToolkit:ModalPopupExtender>
<asp:Panel runat="server" CssClass="modalPopup" ID="programmaticPopup" Style="display: none;padding: 0px; width:95%;">
    <asp:Panel runat="Server" ID="programmaticPopupDragHandle" Style="cursor: move; background-color: #D6E7F3;
        border: solid 1px Gray; color: Black; text-align: center;" ToolTip="">
    <table width="100%" cellpadding="0" cellspacing="0" style="background-color:#3376AB;">
        <tr class="headerstyle">
            <td align="left" style="padding-left: 10px;">
                <asp:Label ID="lblHdr" runat="server" ForeColor="white" Font-Size="12pt" Text="Scan Documents" />
            </td>
            <td align="right" style="padding-right: 5px;">
                <asp:ImageButton ID="imgClose" runat="server" OnClientClick="ReloadScanPage();"
                    ImageUrl="~/images/16x16_close.png" onmouseover="this.style.cursor='pointer';" />
            </td>
        </tr>
    </table>
    </asp:Panel>
    <asp:Panel runat="Server" ID="pnlRpt">
        <div id="dvScan" runat="server" style="height: 400px; z-index: 51; visibility: visible; background-color: Transparent;">
            <iframe id="frmScan" runat="server" src="" style="width: 100%; height: 100%;" frameborder="0" />
        </div>
    </asp:Panel>
</asp:Panel>
<asp:LinkButton ID="lnkScan" runat="server"></asp:LinkButton> 
<asp:HiddenField ID="hdnScanObjectId" runat="server" />
<asp:HiddenField ID="hdnScanRelationId" runat="server" />
<asp:HiddenField ID="hdnScanType" runat="server" />
