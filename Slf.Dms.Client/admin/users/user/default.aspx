<%@ Page Language="VB" MasterPageFile="~/admin/users/user/user.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_user_default" title="DMP - Admin - Users" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">
   
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script id="Common" type="text/javascript">
function Record_CancelAndClose()
{
    // postback to cancel and close
    <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
}
</script>
<asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>

<body id="bodMain" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { height:23;width:100; }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
    <script type="text/javascript">

    var txtUserName = null;
    var txtPassword = null;
    var txtFirstName = null;
    var txtLastName = null;
    var txtEmailAddress = null;

    var Inputs = null;

    
    function Record_Save()
    {
        if (Record_RequiredExist())
        {
            // postback to save
            <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
        }
    }
    function Record_SaveAndClose()
    {
        if (Record_RequiredExist())
        {
            // postback to save and close
            <%= ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
        }
    }
    function Record_RandomizePassword()
    {
        if (Record_RequiredExist())
        {
            // postback to randomize password
            <%= ClientScript.GetPostBackEventReference(lnkRandomizePassword, Nothing) %>;
        }
    }
	function Record_DeleteConfirm()
	{
         var url = '<%= ResolveUrl("~/delete.aspx?t=User&p=user") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "User",
                   dialogArguments: window,
                   resizable: false,
                   scrollable: false,
                   height: 350, width: 400});   
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
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
	    if (txtUserName == null)
	    {
	        txtUserName = document.getElementById("<%= txtUserName.ClientID() %>");
	        txtPassword = document.getElementById("<%= txtPassword.ClientID() %>");
	        txtFirstName = document.getElementById("<%= txtFirstName.ClientID() %>");
	        txtLastName = document.getElementById("<%= txtLastName.ClientID() %>");
	        txtEmailAddress = document.getElementById("<%= txtEmailAddress.ClientID() %>");

            Inputs = new Array();

            if (txtUserName != null)
                Inputs[Inputs.length] = txtUserName;

            if (txtPassword != null)
                Inputs[Inputs.length] = txtPassword;

            if (txtFirstName != null)
                Inputs[Inputs.length] = txtFirstName;

            if (txtLastName != null)
                Inputs[Inputs.length] = txtLastName;

            if (txtEmailAddress != null)
                Inputs[Inputs.length] = txtEmailAddress;
	    }
	}
    function Record_RequiredExist()
    {
        LoadControls();

        // remove all display residue
        for (i = 0; i < Inputs.length; i++)
        {
            RemoveBorder(Inputs[i]);
        }

        // validate inputs
        for (i = 0; i < Inputs.length; i++)
        {
            var Input = Inputs[i];

            var Caption = Input.getAttribute("caption");
            var Required = Input.getAttribute("required");
            var Validate = Input.getAttribute("validate");

            // check, if required, that content exists
            if (Required.toLowerCase() == "true")
            {
                if (Input.tagName.toLowerCase() == "select")
                {
                    // control is a dropdownlist
                    if (Input.selectedIndex == -1 || Input.options[Input.selectedIndex].value <= 0)
                    {
	                    ShowMessage("The " + Caption + " field is required.");
	                    AddBorder(Input);
                        return false;
                    }
                }
                else if (Input.tagName.toLowerCase() == "input")
                {
                    if (Input.type == "text") // textbox
                    {
                        if (Input.value.length == 0)
                        {
	                        ShowMessage("The " + Caption + " field is required.");
	                        AddBorder(Input);
                            return false;
                        }
                    }
                    else if (Input.type == "checkbox") // checkbox
                    {
                    }
                }
            }

            // check, if control is textbox and content exists, that it is valid
            if (Input.tagName.toLowerCase() == "input" && Input.value.length > 0 && Validate.length > 0)
            {
                if (!(eval(Validate)))
                {
                    ShowMessage("The value you entered for " + Caption + " is invalid.");
                    AddBorder(Input);
                    return false;
                }
            }
        }

        HideMessage()
	    return true;
	}
	
	function SelectCompanys()
	{
	    var hdn = document.getElementById('<%=hdnCompanyIDs.ClientID %>');

	    wnd=window.open("<%= ResolveUrl("~/util/pop/companypicker.aspx")%>?ids=" + hdn.value, '', 'width=350,height=250,scrollbars=no,resizable=no,status=no,left=20,top=20');
        wnd.focus();
    }
    
    function SelectCompanys_Back(names,ids)
    {
        var div = document.getElementById('<%=divCompanys.ClientID %>');
        var hdn = document.getElementById('<%=hdnCompanyIDs.ClientID %>');
        
        div.innerHTML = names;
        hdn.value = ids;
    }
    
	function SelectCommRecs()
	{
	    var hdn = document.getElementById('<%=hdnCommRecIDs.ClientID %>');

	    wnd=window.open("<%= ResolveUrl("~/util/pop/commrecpicker.aspx")%>?ids=" + hdn.value, '', 'width=350,height=250,scrollbars=no,resizable=no,status=no,left=20,top=20');
        wnd.focus();
    }
    
    function SelectCommRecs_Back(names,ids)
    {
        var div = document.getElementById('<%=divCommRecs.ClientID %>');
        var hdn = document.getElementById('<%=hdnCommRecIDs.ClientID %>');
        
        div.innerHTML = names;
        hdn.value = ids;
    }    
    
	function SelectAgency()
	{
	    var hdn = document.getElementById('<%=hdnAgencyIDs.ClientID %>');

	    wnd=window.open("<%= ResolveUrl("~/util/pop/agencypicker.aspx")%>?ids=" + hdn.value, '', 'width=350,height=250,scrollbars=no,resizable=no,status=no,left=20,top=20');
        wnd.focus();
    }
    
    function SelectAgency_Back(names,ids)
    {
        var div = document.getElementById('<%=divAgency.ClientID %>');
        var hdn = document.getElementById('<%=hdnAgencyIDs.ClientID %>');
        
        div.innerHTML = names;
        hdn.value = ids;
    }      
    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">Users</a>&nbsp;>&nbsp;<asp:Label id="lblUser" runat="server" style="color: #666666;"></asp:Label></td></tr>
        <tr>
            <td style="height:100%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
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
                        <td valign="top" id="tdEditable">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <div style="float: left">
                                        <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">General Information</td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">User Name:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="User Name" required="true" TabIndex="2" cssclass="entry" runat="server" id="txtUserName"></asp:textbox><asp:Label runat="server" id="lblUserName"></asp:Label></td>
                                            </tr>
                                            <tr runat="server" id="trPassword">
                                                <td class="entrytitlecell">Password:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Password" required="true" TabIndex="2" cssclass="entry" runat="server" id="txtPassword"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">First Name:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="First Name" required="true" TabIndex="2" cssclass="entry" runat="server" id="txtFirstName"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Last Name:</td>
                                                <td><asp:textbox maxlength="50" validate="" caption="Last Name" required="true" TabIndex="3" cssclass="entry" runat="server" id="txtLastName"></asp:textbox></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Email Address:</td>
                                                <td><asp:textbox maxlength="50" validate="IsValidTextEmailAddress(Input.value);" caption="Email Address" required="true" TabIndex="3" cssclass="entry" runat="server" id="txtEmailAddress"></asp:textbox></td>
                                            </tr>
                                            <tr id="trSetPassword" runat="server">
                                                <td class="entrytitlecell">
                                                    Set Password:</td>
                                                <td>
                                                    <asp:TextBox ID="txtNewPassword" runat="server" caption="Password" CssClass="entry"
                                                        TabIndex="6">
                                                    </asp:TextBox></td>
                                            </tr>                                        
                                            <tr>
                                                <td class="entrytitlecell">User Type:</td>
                                                <td><asp:dropdownlist caption="User Type" TabIndex="4" cssclass="entry" runat="server" id="ddlUserType" AutoPostBack="true"></asp:dropdownlist></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Group:</td>
                                                <td><asp:dropdownlist caption="Group" TabIndex="5" cssclass="entry" runat="server" id="ddlUserGroup" AutoPostBack="true"></asp:dropdownlist></td>
                                            </tr>
                                        </table>
                                        <table style="width: 300px; margin: 0 20 20 0; font-family: tahoma; font-size: 11px; border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td style="padding: 5 5 5 5; background-color: #f1f1f1;" colspan="2">
                                                    User Access
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-top: 5px; width:100px" valign="top">
                                                    <a id="lnkSelectCommRec" class="lnk" href="javascript:SelectCommRecs();">Payment Recip:</a>
                                                </td>
                                                <td style="padding-top: 5px" nowrap>
                                                    <div id="divCommRecs" runat="server">
                                                        None</div>
                                                    <input id="hdnCommRecIDs" runat="server" value="-1" type="hidden" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-top: 5px" valign="top">
                                                    <a id="lnkAgency" class="lnk" href="javascript:SelectAgency();">Agency:</a>
                                                </td>
                                                <td style="padding-top: 5px;" nowrap>
                                                    <div id="divAgency" runat="server">
                                                        None</div>
                                                    <input id="hdnAgencyIDs" runat="server" value="-1" type="hidden" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-top: 5px" valign="top" nowrap>
                                                    <a id="lnkSelect" class="lnk" href="javascript:SelectCompanys();">Settlement Atty:</a>
                                                </td>
                                                <td style="padding-top: 5px">
                                                    <div id="divCompanys" runat="server">
                                                        None</div>
                                                    <input id="hdnCompanyIDs" runat="server" value="-1" type="hidden" />
                                                </td>
                                            </tr>
                                        </table>
                                        <table style="width: 300px; margin: 0 20 20 0; font-family: tahoma; font-size: 11px;"
                                            border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td style="padding: 5 5 5 5; background-color: #f1f1f1;" colspan="2">
                                                    Client Access
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    From:
                                                </td>
                                                <td>
                                                    <asp:TextBox MaxLength="10" validate="" required="true" TabIndex="7"
                                                        CssClass="entry" runat="server" ID="txtClientCreatedFrom" Text="1/1/2000"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    To:
                                                </td>
                                                <td>
                                                    <asp:TextBox MaxLength="10" validate="" required="true" TabIndex="8" CssClass="entry"
                                                        runat="server" ID="txtClientCreatedTo" Text="12/31/2050"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">
                                                    Ext:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtExtension" runat="server" Text=""></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div style="float:left">
                                        <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                            <tr>
                                                <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Options</td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" style="padding-left:10;">
                                                    <asp:CheckBox width="250" CssClass="entry" runat="server" id="chkSuperUser" text="Super user across system"></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" style="padding-left:10;">
                                                    <asp:CheckBox width="250" CssClass="entry" runat="server" id="chkLocked" text="User account is locked"></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" style="padding-left:10;">
                                                    <asp:CheckBox width="250" CssClass="entry" runat="server" id="chkTemporary" text="Force password reset at next login"></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell" style="padding-left: 10;">
                                                    <asp:CheckBox ID="chkManager" runat="server" CssClass="entry" Text="Group Manager" Width="250" Enabled="false" />
                                                </td>
                                            </tr>
                                        </table>
                                        <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5" runat="server" id="tblAuditTrail">
                                            <tr>
                                                <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Audit Trail</td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Created:</td>
                                                <td><asp:Label CssClass="entry" runat="server" id="lblCreated"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Created By:</td>
                                                <td><asp:Label CssClass="entry" runat="server" id="lblCreatedByName"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Last Modified:</td>
                                                <td><asp:Label CssClass="entry" runat="server" id="lblLastModified"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td class="entrytitlecell">Last Modified By:</td>
                                                <td><asp:Label CssClass="entry" runat="server" id="lblLastModifiedByName"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>                                    
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <%--<asp:dropdownlist runat="server" id="cboPhoneType" style="display:none;"></asp:dropdownlist>--%>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkRandomizePassword"></asp:LinkButton>

</body>
<div id="bodReadOnly" runat="server">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { height:23;width:100; }
    </style>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">Users</a>&nbsp;>&nbsp;<asp:Label id="ro_lblUser" runat="server" style="color: #666666;"></asp:Label></td></tr>
        <tr>
            <td style="height:100%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top" id="ro_tdEditable">
                            <table style="margin:0 20 20 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">General Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">User Name:</td>
                                    <td><asp:Label runat="server" id="ro_lblUserName"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">First Name:</td>
                                    <td><asp:label maxlength="50" validate="" caption="First Name" required="true" TabIndex="2" cssclass="entry" runat="server" id="ro_txtFirstName"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Last Name:</td>
                                    <td><asp:label maxlength="50" validate="" caption="Last Name" required="true" TabIndex="3" cssclass="entry" runat="server" id="ro_txtLastName"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Email Address:</td>
                                    <td><asp:label maxlength="50" validate="IsValidTextEmailAddress(Input.value);" caption="Email Address" required="true" TabIndex="3" cssclass="entry" runat="server" id="ro_txtEmailAddress"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">User Type:</td>
                                    <td><asp:label caption="User Type" TabIndex="4" cssclass="entry" runat="server" id="ro_ddlUserType"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Group:</td>
                                    <td><asp:label caption="Group" TabIndex="5" cssclass="entry" runat="server" id="ro_ddlUserGroup"></asp:label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Commission Recip:</td>
                                    <td><asp:label caption="Commission Recipient" TabIndex="5" cssclass="entry" runat="server" id="ro_ddlCommRec"></asp:label></td>
                                </tr>
                            </table>
                            <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Options</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" style="padding-left:10;">
                                        <asp:CheckBox width="250" enabled="false" CssClass="entry" runat="server" id="ro_chkSuperUser" text="Super user across system"></asp:CheckBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" style="padding-left:10;">
                                        <asp:CheckBox width="250" enabled="false" CssClass="entry" runat="server" id="ro_chkLocked" text="User account is locked"></asp:CheckBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" style="padding-left:10;">
                                        <asp:CheckBox width="250" enabled="false" CssClass="entry" runat="server" id="ro_chkTemporary" text="Force password reset at next login"></asp:CheckBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell" style="padding-left: 10;">
                                        <asp:CheckBox ID="ro_chkManager" runat="server" CssClass="entry" Enabled="false" Text="Group Manager" Width="250" />
                                    </td>
                                </tr>
                                <tr><td class="entrytitlecell">&nbsp;</td></tr>
                            </table>
                            <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5" runat="server" id="ro_tblAuditTrail">
                                <tr>
                                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">Audit Trail</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Created:</td>
                                    <td><asp:Label CssClass="entry" runat="server" id="ro_lblCreated"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Created By:</td>
                                    <td><asp:Label CssClass="entry" runat="server" id="ro_lblCreatedByName"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Last Modified:</td>
                                    <td><asp:Label CssClass="entry" runat="server" id="ro_lblLastModified"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Last Modified By:</td>
                                    <td><asp:Label CssClass="entry" runat="server" id="ro_lblLastModifiedByName"></asp:Label></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

</asp:PlaceHolder></asp:Content>