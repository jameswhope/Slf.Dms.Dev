<%@ Page Language="VB" MasterPageFile="~/admin/users/usertype/usertype.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_users_usertype_default" title="DMP - Admin - Users" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">

<body id="bodMain" runat="server">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { height:23;width:100; }
    </style>
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var txtUserName = null;
    
    var Inputs = null;

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
    function Record_SaveAndClose()
    {
        if (Record_RequiredExist())
        {
            // postback to save and close
            <%= ClientScript.GetPostBackEventReference(lnkSaveAndClose, Nothing) %>;
        }
    }
	function Record_DeleteConfirm()
	{
        var url = '<%= ResolveUrl("~/delete.aspx?t=UserType&p=user type") %>';
         window.dialogArguments = window;
         currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                   title: "User Type",
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

            Inputs = new Array();

            if (txtUserName != null)
                Inputs[Inputs.length] = txtUserName;
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

    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">User Types</a>&nbsp;>&nbsp;<asp:Label id="lblUser" runat="server" style="color: #666666;"></asp:Label></td></tr>
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
                        <td valign="top">
                            <table style="margin:0 20 20 0;float:left;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">General Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Name:</td>
                                    <td><asp:textbox maxlength="50" validate="" caption="Name" required="true" TabIndex="2" cssclass="entry" runat="server" id="txtUserName"></asp:textbox></td>
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
                        </td>
                   </tr>
                </table>
            </td>
        </tr>
    </table>

    <asp:dropdownlist runat="server" id="cboPhoneType" style="display:none;"></asp:dropdownlist>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSaveAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>

</body>

</asp:PlaceHolder></asp:Content>