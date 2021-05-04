<%@ Page Language="VB" MasterPageFile="~/admin/users/user/user.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_user_talents_default" title="DMP - Admin - User Talents" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder runat="Server" ID="pnlBody">

<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/xptabstrip.js") %>"></script>
<script type="text/javascript">

function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
function Record_Save()
{
    // postback to save
    <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
}
function Record_SaveAndClose()
{
    // postback to save and close
    <%= ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
}
function lboAdd_Click(obj)
{
	var tr = obj.parentElement.parentElement;
	
	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	var Index = lboAvailable.selectedIndex;

	if (Index == -1)
	{
		if (lboAvailable.options.length > 0)
		{
			Index = 0;
		}
	}

	if (Index != -1)
	{
		var Option = document.createElement("OPTION");

		lboCurrent.options.add(Option);

		Option.innerText = lboAvailable.options(Index).innerText;
		Option.value = lboAvailable.options(Index).value;

		Selected_Add(txtSelected, Option.value);

		lboAvailable.options.remove(Index);
		
		if (Index < lboAvailable.options.length)
		{
			lboAvailable.selectedIndex = Index;
		}
		else
		{
			lboAvailable.selectedIndex = (lboAvailable.options.length - 1);
		}
	}
}
function lboRemove_Click(obj)
{
	var tr = obj.parentElement.parentElement;

	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	var Index = lboCurrent.selectedIndex;

	if (Index == -1)
	{
		if (lboCurrent.options.length > 0)
		{
			Index = 0;
		}
	}

	if (Index != -1)
	{
		var Option = document.createElement("OPTION");

		lboAvailable.options.add(Option);

		Option.innerText = lboCurrent.options(Index).innerText;
		Option.value = lboCurrent.options(Index).value;

		Selected_Remove(txtSelected, Option.value);

		lboCurrent.options.remove(Index);
		
		if (Index < lboCurrent.options.length)
		{
			lboCurrent.selectedIndex = Index;
		}
		else
		{
			lboCurrent.selectedIndex = (lboCurrent.options.length - 1);
		}
	}
}
function cmdAdd_Click(obj)
{
	var tr = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;

	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	var Index = lboAvailable.selectedIndex;

	if (Index == -1)
	{
		if (lboAvailable.options.length > 0)
		{
			Index = 0;
		}
	}

	if (Index != -1)
	{
		var Option = document.createElement("OPTION");

		lboCurrent.options.add(Option);

		Option.innerText = lboAvailable.options(Index).innerText;
		Option.value = lboAvailable.options(Index).value;

		Selected_Add(txtSelected, Option.value);

		lboAvailable.options.remove(Index);
		
		if (Index < lboAvailable.options.length)
		{
			lboAvailable.selectedIndex = Index;
		}
		else
		{
			lboAvailable.selectedIndex = (lboAvailable.options.length - 1);
		}
	}
}
function cmdRemove_Click(obj)
{
	var tr = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;

	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	var Index = lboCurrent.selectedIndex;

	if (Index == -1)
	{
		if (lboCurrent.options.length > 0)
		{
			Index = 0;
		}
	}

	if (Index != -1)
	{
		var Option = document.createElement("OPTION");

		lboAvailable.options.add(Option);

		Option.innerText = lboCurrent.options(Index).innerText;
		Option.value = lboCurrent.options(Index).value;

		Selected_Remove(txtSelected, Option.value);

		lboCurrent.options.remove(Index);
		
		if (Index < lboCurrent.options.length)
		{
			lboCurrent.selectedIndex = Index;
		}
		else
		{
			lboCurrent.selectedIndex = (lboCurrent.options.length - 1);
		}
	}
}
function cmdAddAll_Click(obj)
{
	var tr = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;

	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	while (lboAvailable.options.length > 0)
	{
		var Option = document.createElement("OPTION");

		lboCurrent.options.add(Option);

		Option.innerText = lboAvailable.options(0).innerText;
		Option.value = lboAvailable.options(0).value;

		Selected_Add(txtSelected, Option.value);

		lboAvailable.options.remove(0);
	}
}
function cmdRemoveAll_Click(obj)
{
	var tr = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;

	var lboAvailable = tr.cells[0].childNodes[0];
	var lboCurrent = tr.cells[2].childNodes[0];
	var txtSelected = tr.cells[3].childNodes[0];

	while (lboCurrent.options.length > 0)
	{
		var Option = document.createElement("OPTION");

		lboAvailable.options.add(Option);

		Option.innerText = lboCurrent.options(0).innerText;
		Option.value = lboCurrent.options(0).value;

		lboCurrent.options.remove(0);
	}

	txtSelected.value = "";
}
function Selected_Remove(txt, ProgramID)
{
	var values = txt.value.split(",");

	txt.value = "";

	for (i = 0; i < values.length; i++)
	{
		if (values[i] != ProgramID)
		{
			if (txt.value.length > 0)
			{
				txt.value += "," + values[i];
			}
			else
			{
				txt.value = values[i];
			}
		}
	}
}
function Selected_Add(txt, ProgramID)
{
	if (txt.value.length > 0)
	{
		txt.value += "," + ProgramID;
	}
	else
	{
		txt.value = ProgramID;
	}
}

</script>

<table style="width:100%;font-family:tahoma;font-size:11px;" cellspacing="15" cellpadding="0" border="0">
    <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">Users</a>&nbsp;>&nbsp;<asp:Label id="lblUser" runat="server" style="color: #666666;"></asp:Label>&nbsp;>&nbsp;Talents</td></tr>
    <tr><td><asi:tabstrip runat="server" id="tsTalents"></asi:tabstrip></td></tr>
    <tr>
        <td>
            <table id="dvTalent0" runat="server" style="width:100%;">
                <tr id="trInfoBoxPositions" runat="server">
                    <td style="padding-bottom:10;">
                        <div class="iboxDiv">
                            <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                    <td>
                                        <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="iboxHeaderCell">INFORMATION:</td>
                                                <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformationPositions"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="iboxMessageCell">
                                                    The positions below reflect different talents that a specific user can be carry in the system. These
                                                    positions are what help the system determine what workflow entities should be assigned to a user or 
                                                    transitioned between multiple users.
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <table style="font-size:11px;font-family:tahoma;" cellspacing="7" cellpadding="0" border="0">
                            <tr>
                                <td><strong>Available Positions:</strong></td>
                                <td>&nbsp;</td>
                                <td><strong>Current Positions:</strong></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="width:160;">
                                    <asp:listbox id="lboAvailablePositions" runat="server" cssclass="entry" selectionmode="Multiple" rows="12"></asp:listbox>
                                </td>
                                <td style="width:75;">
                                    <table class="entry" cellspacing="7" cellpadding="0" border="0">
                                        <tr>
                                            <td>
                                                <input class="entry" id="cmdAddPosition" onclick="cmdAdd_Click(this);" type="button" size="1" value=">">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="entry"  id="cmdAddAllPositions" onclick="cmdAddAll_Click(this);" type="button" size="1" value=">>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="entry"  id="cmdRemovePositions" onclick="cmdRemove_Click(this);" type="button" size="1" value="<">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top"><input class="entry" id="cmdRemoveAllPositions" onclick="cmdRemoveAll_Click(this);" type="button" size="1" value="<<"></td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width:160;">
                                    <asp:listbox CssClass="entry" id="lboCurrentPositions" runat="server" selectionmode="Multiple" rows="12"></asp:listbox>
                                </td>
                                <td><input id="txtSelectedPositions" type="hidden" name="txtSelectedPositions" runat="server"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table id="dvTalent1" runat="server" style="padding-top:10;">
                <tr id="trInfoBoxLanguages" runat="server">
                    <td style="padding-bottom:10;">
                        <div class="iboxDiv">
                            <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                                <tr>
                                    <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                    <td>
                                        <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="iboxHeaderCell">INFORMATION:</td>
                                                <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformationLanguages"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="iboxMessageCell">
                                                    It is necessary to gauge the languages below per user so that each client can be assigned to their
                                                    best possible representative throughout the negotiation lifecycle.  You can add additional languages to the 
                                                    system through the References area under the Settings menu
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <table style="font-size:11px;font-family:tahoma;" cellspacing="7" cellpadding="0" border="0">
                            <tr>
                                <td><strong>Available Languages:</strong></td>
                                <td>&nbsp;</td>
                                <td><strong>Current Languages:</strong></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="width:160;">
                                    <asp:listbox id="lboAvailableLanguages" runat="server" cssclass="entry" selectionmode="Multiple" rows="12"></asp:listbox>
                                </td>
                                <td style="width:75;">
                                    <table class="entry" cellspacing="7" cellpadding="0" border="0">
                                        <tr>
                                            <td>
                                                <input class="entry" id="Button1" onclick="cmdAdd_Click(this);" type="button" size="1" value=">">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="entry"  id="Button2" onclick="cmdAddAll_Click(this);" type="button" size="1" value=">>">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="entry"  id="Button3" onclick="cmdRemove_Click(this);" type="button" size="1" value="<">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top"><input class="entry" id="Button4" onclick="cmdRemoveAll_Click(this);" type="button" size="1" value="<<"></td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width:160;">
                                    <asp:listbox CssClass="entry" id="lboCurrentLanguages" runat="server" selectionmode="Multiple" rows="12"></asp:listbox>
                                </td>
                                <td><input id="txtSelectedLanguages" type="hidden" name="txtSelectedLanguages" runat="server"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveAndClose"></asp:LinkButton>

</asp:PlaceHolder></asp:Content>