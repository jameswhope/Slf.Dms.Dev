<%@ Page Language="VB" MasterPageFile="~/admin/admin.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_default" title="DMP - Administration" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">

<body>

<script type="text/javascript">

function Hover(tbl, on)
{
    var tblInner = tbl.rows[0].cells[1].childNodes[0];
    var tdHeader = tblInner.rows[0].cells[0];
    var tdBody = tblInner.rows[1].cells[0];

    if (on)
    {
        tdHeader.style.color = "rgb(173,0,0)";
        tdHeader.style.borderBottomColor = "rgb(66,0,0)";
        tdBody.style.color = "rgb(66,0,0)";
    }
    else
    {
        tdHeader.style.color = "rgb(66,97,148)";
        tdHeader.style.borderBottomColor = "#e3e3e3";
        tdBody.style.color = "";
    }
}

</script>

<div style="height:100%;padding:10;">

    <a id="aSettings" runat="server" href="~/admin/settings"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);" style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img runat="server" src="~/images/48x48_settings.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Settings</td>
                    </tr>
                    <tr>
                        <td>Control organization and system properties, references and rules.  This
                        area provides integrity to the rest of the system by restricting input to
                        administrator-approved records.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
    <a id="aUsers" runat="server" href="~/admin/users"><table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);" onmouseout="Hover(this,false);" style="height:115;cursor:pointer;float:left;width:325;" cellpadding="0" cellspacing="15" border="0">
        <tr>
            <td valign="top" style="width:48"><img runat="server" src="~/images/48x48_users.png" border="0"/></td>
            <td valign="top" style="width:100%;">
                <table style="font-size:11px;font-family:tahoma;width:100%;" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td style="padding-bottom:3;border-bottom:solid 1px #e3e3e3;color:rgb(66,97,148);height:100%;font-weight:bold;font-size:13px;">Users</td>
                    </tr>
                    <tr>
                        <td>Add and manage users, including associated groups, permissions, and talents.
                        View system activity, audit trails and record history or force password changes.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table></a>
<a id="a3" runat="server" href="~/admin/settlementtrackerimport/">
				<table onclick="window.navigate(this.parentElement.href);" onmouseover="Hover(this,true);"
					onmouseout="Hover(this,false);" style="height: 115; cursor: pointer; float: left;
					width: 325;" cellpadding="0" cellspacing="15" border="0">
					<tr>
						<td valign="top" style="width: 48">
							<img id="Img3" runat="server" src="~/images/48x48_import.png" border="0" />
						</td>
						<td valign="top" style="width: 100%;">
							<table style="font-size: 11px; font-family: tahoma; width: 100%;" cellpadding="0"
								cellspacing="0" border="0">
								<tr>
									<td style="padding-bottom: 3; border-bottom: solid 1px #e3e3e3; color: rgb(66,97,148);
										height: 100%; font-weight: bold; font-size: 13px;">
										Settlement Tracker Import
									</td>
								</tr>
								<tr>
									<td>
										Import Settlement Tracker Data from Creditor Services Teams.  Manage Tracker data
										for Processing Team.  View statistical settlement data.
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</a>
</div>

</body>

</asp:Content>