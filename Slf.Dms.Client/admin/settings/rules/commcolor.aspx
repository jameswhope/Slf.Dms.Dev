<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="commcolor.aspx.vb"  Inherits="admin_settings_negotiation_commcolor" title="DMP - Admin Settings - Rules" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="admin_settings_settings" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
<body runat="server" id="bdMain">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <style type="text/css">
        .entrycell {  }
        .entrytitlecell { width:85; }
    </style>
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var dvColor = null;
    var txtColor = null;
    var ddlUserTypes = null;
    var ddlUserGroups = null;
    var ddlUsers = null;
    var ddlEntityType = null;
    var ddlRelationType = null;
    
    function FixEntityType(ddl)
    {
        LoadControls();
        var ddlKeep;
        
        if (ddl.selectedIndex == 0)
            ddlKeep=ddlRelationTypes;
        if (ddl.selectedIndex == 1)
            ddlKeep=ddlUserTypes;
        else if (ddl.selectedIndex == 2)
            ddlKeep=ddlUserGroups;
        else if (ddl.selectedIndex == 3)
            ddlKeep=ddlUsers;
        
        ddlRelationTypes.style.display="none";    
        ddlUserTypes.style.display="none";
        ddlUserGroups.style.display="none";
        ddlUsers.style.display="none";
        ddlKeep.style.display="block";
    }
    
    var hex;
    function PickColor(txt)
    {
        hex = null;
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/colorpicker.aspx?v=hex")%>';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Color Picker",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 550, width: 350, scrollable: false,
                           onClose: function(){
                                if (hex != null)
                                    {
                                        txt.value = hex;
                                        txt.onkeyup();
                                    }
                            }
                           });
        
    }
    function FixColor(txt, destID)
    {
        if (txt.value.length == 0)
        {
            document.getElementById(destID).style.backgroundColor="white";
            document.getElementById(destID).innerHTML="default color";
        }
        else
        {
            try
            {
                document.getElementById(destID).style.backgroundColor=txt.value;
                document.getElementById(destID).innerHTML="&nbsp;";
            }
            catch(e)
            {
                document.getElementById(destID).style.backgroundColor="white";
                document.getElementById(destID).innerHTML="invalid color";
            }
        }
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    dvError.style.display = "inline";
	    tdError.innerHTML = Value;
	}
	function HideMessage()
	{
	    var dvError = document.getElementById("<%= dvError.ClientID %>");
	    var tdError = document.getElementById("<%= tdError.ClientID %>");

	    tdError.innerHTML = "";
	    dvError.style.display = "none";
	}
	function LoadControls()
	{
	    dvColor = document.getElementById("<%= dvColor.ClientID() %>");
	    txtColor = document.getElementById("<%= txtColor.ClientID() %>");
	    dvTextColor = document.getElementById("<%= dvTextColor.ClientID() %>");
	    txtTextColor = document.getElementById("<%= txtTextColor.ClientID() %>");
	    ddlRelationTypes = document.getElementById("<%= ddlRelationTypes.ClientID() %>");
	    ddlUserTypes = document.getElementById("<%= ddlUserTypes.ClientID() %>");
	    ddlUserGroups = document.getElementById("<%= ddlUserGroups.ClientID() %>");
	    ddlUsers = document.getElementById("<%= ddlUsers.ClientID() %>");
	    ddlEntityType = document.getElementById("<%= ddlEntityType.ClientID() %>");
	}
    function Record_RequiredExist()
    {
        LoadControls();

        if (dvColor.innerHTML == "invalid color")
        {
            ShowMessage("You entered an invalid color.");
            AddBorder(txtColor);
            AddBorder(dvColor);
            return false;
        }
        else
        {
            RemoveBorder(txtColor);
            RemoveBorder(dvColor);
        }
        
        if (dvTextColor.innerHTML == "invalid color")
        {
            ShowMessage("You entered an invalid color.");
            AddBorder(txtTextColor);
            AddBorder(dvTextColor);
            return false;
        }
        else
        {
            RemoveBorder(txtTextColor);
            RemoveBorder(dvTextColor);
        }
        
        if (
            (ddlEntityType.value == "User Type" && ddlUserTypes.value == "")
            || (ddlEntityType.value == "User Group" && ddlUserGroups.value == "")
            || (ddlEntityType.value == "User" && ddlUsers.value == "")
            )
        {
            ShowMessage("You must select an Entity.");
            try{AddBorder(ddlUserTypes);}catch(e){}
            try{AddBorder(ddlUserGroups);}catch(e){}
            try{AddBorder(ddlUsers);}catch(e){}
            return false;
        }
        else
        {
            RemoveBorder(ddlUserTypes);
            RemoveBorder(ddlUserGroups);
            RemoveBorder(ddlUsers);
        }
        
        if (txtColor.value.length == 0 && txtTextColor.value.length==0)
        {
            ShowMessage("At least one color specification is required.");
            return false;
        }
        
        HideMessage()
	    return true;
    }
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Rule&m=Are you sure you want to delete this Rule?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Rule",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400, scrollable: false});
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td><a id="A4" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A5" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a id="A6" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/rules/">Rules</a>&nbsp;>&nbsp;<a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/rules/commcolors.aspx">Communication Colors</a>&nbsp;>&nbsp;<asp:literal id="ltrNew" runat="server" visible="false">Add New&nbsp;</asp:literal>Communication Color</td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3">
                            <div runat="server" id="dvError" style="display:none;">
                                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                <tr>
						                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table style="margin:0 30 30 0;float:left;font-family:tahoma;font-size:11px;width:320;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">General Information</td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="table-layout:fixed;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td class="entrytitlecell">Entity Type:</td>
                                                <td>
                                                    <asp:dropdownlist runat="server" id="ddlEntityType" onchange="FixEntityType(this)" style="width:100%"></asp:dropdownlist>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Entity:</td>
                                                <td >
                                                    <asp:dropdownlist runat="server" id="ddlRelationTypes" style="width:100%"></asp:dropdownlist>
                                                    <asp:dropdownlist runat="server" id="ddlUserTypes" style="display:none;width:100%"></asp:dropdownlist>
                                                    <asp:dropdownlist runat="server" id="ddlUserGroups" style="display:none;width:100%"></asp:dropdownlist>
                                                    <asp:dropdownlist runat="server" id="ddlUsers" style="display:none;width:100%"></asp:dropdownlist>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" >Text Color:</td>
                                                <td>
                                                    <table style="font-family:tahoma;font-size:11px;" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <input id="txtTextColor" type="text" runat="server" style="width:100px" />
                                                            </td>
                                                            <td style="padding-left:5px">
                                                                <div style="width:85px;border: solid 1px gray;padding:3px 0px 3px 0px" align="center" id="dvTextColor" runat="server"> </div>
                                                            </td>
                                                            <td>
                                                                <a href="#" onclick="PickColor(this.parentElement.previousSibling.previousSibling.firstChild)">Pick</a>
                                                            </td>
                                                        </tr>
                                                        
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" >Back Color:</td>
                                                <td>
                                                    <table style="font-family:tahoma;font-size:11px;" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <input id="txtColor" type="text" runat="server" style="width:100px" />
                                                            </td>
                                                            <td style="padding-left:5px">
                                                                <div style="width:85px;border: solid 1px gray;padding:3px 0px 3px 0px" align="center" id="dvColor" runat="server"> </div>
                                                            </td>
                                                            <td>
                                                                <a href="#" onclick="PickColor(this.parentElement.previousSibling.previousSibling.firstChild)">Pick</a>
                                                            </td>
                                                        </tr>
                                                        
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>



    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    
</body>

</asp:Content>

