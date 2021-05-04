<%@ Page Language="VB" MasterPageFile="~/admin/users/group/group.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_group_members_default" title="DMP - Admin - Groups" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder runat="server" ID="pnlBody">
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript">
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
</script>
<table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="15" cellpadding="0" border="0">
    <tr>
        <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">User Groups</a>&nbsp;>&nbsp;<a id="lnkUser" runat="server" style="color: #666666;" class="lnk"></a>&nbsp;>&nbsp;Members</td>
    </tr>
    <tr>
        <td>
			<asi:StandardGrid2 ID="grdMembers" runat="server" XmlSchemaFile="~/standardgrids.xml"></asi:StandardGrid2>
        </td>
    </tr>
</table>
<asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>