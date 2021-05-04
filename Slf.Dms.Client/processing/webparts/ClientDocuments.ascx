<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientDocuments.ascx.vb"
    Inherits="processing_webparts_ClientDocuments" %>

<script language="javascript">
    function ShowHide(img, id) {
        var tr = document.getElementById(id);

        if (tr.style.display == 'none') {
            tr.style.display = ''; // show
            img.src = '../images/minus.png';
        }
        else {
            tr.style.display = 'none'; // hide
            img.src = '../images/plus.png';
        }
    }

    function OpenDocument(path) {
        window.open(path);
    }
</script>

<asp:UpdatePanel ID="updDocuments" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:Panel ID="pnlDocuments" runat="server">
            <table border="0" cellpadding="0" cellspacing="0" style="height: 300px; vertical-align: top;">
                <tr style="width: 100%;">
                    <td style="height: 275px; vertical-align: top; width: 100%;">
                        <ajaxToolkit:Accordion ID="accDocuments" runat="server" ContentCssClass="listitem"
                            HeaderCssClass="spanHeader" HeaderSelectedCssClass="spanHeader" Height="275px"
                            RequireOpenedPane="false" TransitionDuration="50">
                        </ajaxToolkit:Accordion>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlNoDocuments" runat="server">
            <div style="text-align: center; color: #A1A1A1; padding: 5px 5px 5px 5px;">
                No Directory
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:HiddenField ID="hdnCurrentDoc" runat="server" />
