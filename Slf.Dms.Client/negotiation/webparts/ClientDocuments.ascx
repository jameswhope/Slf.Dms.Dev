<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientDocuments.ascx.vb" Inherits="negotiation_webparts_ClientDocuments" %>

<script type="text/javascript" language="javascript">
    function OpenDocument(path)
    {
        window.open(path);
    }
    
    function SelectDocument(obj, path)
    {
        var hdnCurrentDoc = document.getElementById('<%=hdnCurrentDoc.ClientID %>');
        
        if (obj.checked)
        {
            hdnCurrentDoc.value += path + '|';
        }
        else
        {
            hdnCurrentDoc.value = hdnCurrentDoc.value.replace(path + '|', '');
        }
    }
</script>

<style>
    .documentContent
    {
        margin-top: 5px;
    }
    
    .documentHeader
    {
        border-bottom: 1px solid #BEDCE6;
        cursor: hand;
        font-weight: normal;
        margin-top: 5px;
    }
    
    .documentHeaderSelected
    {
        border-bottom: 1px solid #006699;
        cursor: hand;
        font-weight: bold;
        margin-top: 5px;
    }
</style>

<asp:UpdatePanel ID="updDocuments" runat="server">
    <ContentTemplate>
        <asp:Panel ID="pnlDocuments" runat="server">
            <table style="vertical-align:top;width:100%;" border="0" cellpadding="0" cellspacing="0">
                <tr id="trDelete" style="height:25px;" runat="server">
                    <td>
                        <asp:LinkButton ID="lnkDeleteDocument" runat="server"><img src="<%=ResolveUrl("~/negotiation/images/delete_off.png") %>" style="border:none;cursor:hand;float:right;" onmouseout="this.src='<%=ResolveUrl("~/negotiation/images/delete_off.png") %>';" onmouseover="this.src='<%=ResolveUrl("~/negotiation/images/delete_on.png") %>';" alt="Delete" /></asp:LinkButton>
                    </td>
                </tr>
                <tr style="width:100%;">
                    <td style="width:100%;">
                        <ajaxToolkit:Accordion ID="accDocuments" AutoSize="Limit" ContentCssClass="documentContent" Height="300px" HeaderCssClass="documentHeader" HeaderSelectedCssClass="documentHeaderSelected" RequireOpenedPane="true" TransitionDuration="250" Width="100%" runat="server" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlNoDocuments" runat="server">
            <div style="text-align:center;color:#A1A1A1;padding:5px 5px 5px 5px;">No Directory</div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>

<asp:HiddenField ID="hdnCurrentDoc" runat="server" />