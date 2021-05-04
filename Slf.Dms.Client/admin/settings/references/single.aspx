<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="single.aspx.vb" Inherits="admin_settings_references_single" title="DMP - Admin Settings - References" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<body runat="server" id="bdMain">

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/IsValid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/Allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

    var Inputs = null;
    var txtSelected = null;

    function LoadControls()
    {
        if (Inputs == null)
        {
            var dvFields = document.getElementById("dvFields");

            var ClientIDs = dvFields.innerHTML.split(",");

            // find and array all fields
            Inputs = new Array();

            for (i = 0; i < ClientIDs.length; i++)
            {
                Inputs[Inputs.length] = document.getElementById(ClientIDs[i]);
            }

            txtSelected = document.getElementById("<%= txtSelected.ClientID %>");
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
            LoadControls();

            // grab field data for post back
            for (i = 0; i < Inputs.length; i++)
            {
                var Input = Inputs[i];

                var Type = Input.getAttribute("type");
                var FieldToSave = Input.getAttribute("fieldtosave");
                var FieldType = Input.getAttribute("fieldtype");

                var Value = "";

                if (Input.tagName.toLowerCase() == "select")
                {
                    if (Input.multiple == true){
                        for (j = 0; j < Input.length; j++){
                            if (Input.options[j].selected == true){
                                Value = Input.options[j].value;
                                
                                if (txtSelected.value.length > 0)
                                {
                                    txtSelected.value += "<--$-->" + FieldToSave + "|" + FieldType + "|" + Value;
                                }
                                else
                                {
                                    txtSelected.value = FieldToSave + "|" + FieldType + "|" + Value;
                                }
                            }
                        }
                    }
                    else{                    
                        if (Input.selectedIndex != -1) // dropdownlist
                        {
                            Value = Input.options[Input.selectedIndex].value;
                            
                            if (txtSelected.value.length > 0)
                            {
                                txtSelected.value += "<--$-->" + FieldToSave + "|" + FieldType + "|" + Value;
                            }
                            else
                            {
                                txtSelected.value = FieldToSave + "|" + FieldType + "|" + Value;
                            }
                        }
                    }
                }
                else if (Input.tagName.toLowerCase() == "input")
                {
                    if (Input.type == "text")
                    {
                        Value = Input.value;
                    }
                    else if (Input.type == "checkbox")
                    {
                        Value = Input.checked;
                    }
                    
                    if (txtSelected.value.length > 0)
                    {
                        txtSelected.value += "<--$-->" + FieldToSave + "|" + FieldType + "|" + Value;
                    }
                    else
                    {
                        txtSelected.value = FieldToSave + "|" + FieldType + "|" + Value;
                    }
                }                
            }

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
	function Record_DeleteConfirm(deletetitle, deletetext)
	{
         window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=' + deletetitle + '&m=' + deletetext;
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: deletetitle,
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400, scrollable: false});
	}
    function Record_Delete()
    {
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_Cancel()
    {
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }

    </script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<asp:label id="lblTitle" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <div runat="server" id="dvError" style="display:none;">
                                <table style="border-right:#969696 1px solid;border-top: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
					                <tr>
						                <td valign="top" style="width:20;"><img runat="server" src="~/images/message.png" align="absmiddle" border="0"></td>
						                <td runat="server" id="tdError"></td>
					                </tr>
				                </table>&nbsp;
				            </div>
                        </td>
                    </tr>
                    <tr><td><asp:Literal runat="server" id="ltrFields"></asp:Literal></td></tr>
                </table>
            </td>
        </tr>
    </table>

    <input type="hidden" runat="server" id="txtSelected" />

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>

</body>

</asp:Content>