<%@ Page Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_default" title="DMP - Admin - Users" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<%@ Import Namespace="Drg.Util.DataHelpers" %>
<%@ MasterType TypeName="admin_admin" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript">

function fixGrid(tbl, txtSelected)
{
    var IDs = txtSelected.value.split(",");
         
    for (var i = 0; i < IDs.length; i++)
    {
        for (var x = 0; x < tbl.rows.length; x++)
        {
      
            var tr = tbl.rows[x];
            if (tr.KeyID == IDs[i])                                  
            {
                var img1=tr.firstChild.firstChild;
                var img2=img1.nextSibling;
                var chk=img2.nextSibling;
                img1.style.display="none";
                img2.style.display="block";
                chk.checked=true;
            }
        }
    }
    
}
function HandleCheck(chk)
{
	var chk_b = document.getElementById("<%=chkShowLocked_b.ClientID %>");
	chk_b.checked = !chk_b.checked;
	chk.checked=chk_b.checked;
	<%=ClientScript.GetPostBackEventReference(chkShowLocked_b, Nothing) %>;
}
function SetCheck()
{
	var chk = document.getElementById("chkShowLocked");
	var chk_b = document.getElementById("<%=chkShowLocked_b.ClientID %>");
	chk.checked=chk_b.checked;
}
</script>
<body>
<!--
The following div contents are to get around a limitation of the standard 
grid. Controls which are in phTitle cannot be accessed server-side.  This
should eventually be researched and fixed.
-->
<div style="display:none">
	<asp:checkbox id="chkShowLocked_b" runat="server" checked="false" text="Show Locked" onclick="HandleCheck(this)"></asp:checkbox>	
</div>
<table style="height:100%;width:100%;" cellspacing="20" cellpadding="0" border="0">
    <tr>
        <td valign="top">
            <table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="0" cellpadding="0" border="0">
                <tr><td><asi:tabstrip runat="server" id="tsUsers"></asi:tabstrip></td></tr>
                <tr>
                    <td style="padding-top:15;">
                        <div id="dvSearch0" runat="server" style="padding-top:10;">
                            <asp:panel runat="server" id="pnlUsers">
                                <div style="width:100%; text-align:right">
                                    Search:
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="entry2" MaxLength="30" Width="150"></asp:TextBox>
                                    <asp:LinkButton ID="lnkSearch" runat="server">
                                        <img id="Img6" runat="server" align="absmiddle" border="0" src="~/images/16x16_arrowright_clear.png"
                                            style="padding-left: 5;" title="Search" /></asp:LinkButton>
                                </div>
                                <asi:StandardGrid2 ID="grdUsers" runat="server" XmlSchemaFile="~/standardgrids.xml">
                                	<phTitle>
										<input type="checkbox" id="chkShowLocked" onclick="HandleCheck(this)" /><label for="chkShowLocked" >Show Locked</label>
										<script>SetCheck();</script>
									
									</phTitle>
                                </asi:StandardGrid2>
                                
                            </asp:panel>
                            <asp:panel runat="server" id="pnlNoUsers" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">There are no users in the database</asp:panel>
                        </div>
                        <div id="dvSearch1" runat="server" style="padding-top:10;display:none">
                            <asp:panel runat="server" id="pnlGroups">
                                <asi:StandardGrid2 ID="grdGroups" runat="server" XmlSchemaFile="~/standardgrids.xml">
                                </asi:StandardGrid2>
                            </asp:panel>
                            <asp:panel runat="server" id="pnlNoGroups" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">There are no groups in the database</asp:panel>
                        </div>
                        <div id="dvSearch2" runat="server" style="padding-top:10;display:none">
                            <asp:panel runat="server" id="pnlUserTypes">
                                <asi:StandardGrid2 ID="grdUserTypes" runat="server" XmlSchemaFile="~/standardgrids.xml">
                                </asi:StandardGrid2>
                            </asp:panel>
                            <asp:panel runat="server" id="pnlNoUserTypes" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">There are no user types in the database</asp:panel>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <asp:placeholder id="phActivities" runat="server">
        <td style="width:5;background-image:url(<%= ResolveUrl("~/images/dot.png") %>);background-repeat:repeat-y;background-position:center top;"><img id="Img1" width="1" height="1" runat="server" src="~/images/spacer.gif" border="0" /></td>
        <td valign="top" style="width:250;">
            <asp:panel runat="server" id="pnlActivities">
                <asi:StandardGrid2 ID="grdActivities" XmlSchemaFile="~/standardgrids.xml" runat="server">
                </asi:StandardGrid2>
                
            </asp:panel>
            
            <asp:panel runat="server" id="pnlNoActivities" style="text-align:center;color:#a1a1a1;padding: 5 5 5 5;">There is no user activity.</asp:panel>
        </td>
        </asp:placeholder>
    </tr>
</table>
</body>
</asp:Content>