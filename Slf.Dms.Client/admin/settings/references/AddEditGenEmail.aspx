<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" 
CodeFile="AddEditGenEmail.aspx.vb" Inherits="admin_settings_references_AddEditGenEmai" 
title="DMP - Add/Edit General Email Template" ValidateRequest="false"   %>
<%@ Register Assembly="Infragistics2.WebUI.WebHtmlEditor.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebHtmlEditor" TagPrefix="ighedit" %>
<%@ Register src="~/customtools/usercontrols/DocumentsControl.ascx" tagname="DocumentsControl" tagprefix="LexxControl" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
 <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server"></ajaxToolkit:ToolkitScriptManager>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

    <style type="text/css">
        .style2
        {
            width: 10%;
        }
        .box
        {
            border: 1px solid #CCCCCC;
        }
    </style>

    <script>
     function AttachDocument()
        {
            var w = 800;
            var h = 500;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            //var relID = + '&temp=1';
            
           // attachWin = window.open('<%=ResolveUrl("~/util/pop/browsedocuments.aspx") %>?id=<%=ClientID %>&type=matter&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            attachWin = window.open('<%=ResolveUrl("~/util/pop/browsedocuments.aspx") %>?id=<%=ClientID %>&type=matter&rel=<%=MatterID %>', 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
                       
            //intAttachWin = setInterval('WaitAttached()', 500);
        }
        
        function Record_CancelAndClose()
        {
            // postback to cancel and close
            <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
        }
        
        function SendMail() 
        {
            var txtToID  = document.getElementById("<%= txtToID.ClientID %>");
            var txtFromID = document.getElementById("<%= txtFromID.ClientID %>");
            var txtPurpose = document.getElementById("<%= txtPurpose.ClientID %>");
            var txtCCID = document.getElementById("<%= txtCCID.ClientID %>");
            var txtBCCID = document.getElementById("<%= txtBCCID.ClientID %>");
            var txtSubject = document.getElementById("<%= txtSubject.ClientID %>");
            var txtMailContent = document.getElementById("<%= txtMailContent.ClientID %>");
            var txtMailFooter = document.getElementById("<%= txtMailFooter.ClientID %>");
            var ddlMailType = document.getElementById("<%= ddlMailType.ClientID %>");
            var ddlLawFirm = document.getElementById("<%= ddlLawFirm.ClientID %>");

            RemoveBorder(txtToID);
            RemoveBorder(txtFromID);
            RemoveBorder(txtCCID);
            RemoveBorder(txtPurpose);
            RemoveBorder(txtBCCID);
            RemoveBorder(txtSubject);
            RemoveBorder(txtMailContent); 
            RemoveBorder(txtMailFooter);
            RemoveBorder(ddlMailType);
            RemoveBorder(ddlLawFirm);
            
            if (trim(document.getElementById("<%= ddlLawFirm.ClientID %>").value) == "0") {
                ShowMessage("Please select lawfirm");
                AddBorder(ddlLawFirm);
                return false;
            }
            
            if (trim(document.getElementById("<%= ddlMailType.ClientID %>").value) == "") {
                ShowMessage("Please select email type");
                AddBorder(ddlMailType);
                return false;
            }

//            if (trim(document.getElementById("<%= txtToID.ClientID %>").value) == "") {
//                ShowMessage("Please enter TO email address");
//                AddBorder(txtToID);
//                return false;
//            }
        
            if (document.getElementById("<%= txtToID.ClientID %>").value != "") {
                if (!RegexValidate(document.getElementById("<%= txtToID.ClientID %>").value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                    ShowMessage("Please enter a valid TO email address");
                    AddBorder(txtFromID);
                    return false;
                }
            } 
            
//            if (trim(document.getElementById("<%= txtFromID.ClientID %>").value) == "") {
//                ShowMessage("Please enter FROM email address");
//                AddBorder(txtFromID);
//                return false;
//            }
            
            if (document.getElementById("<%= txtFromID.ClientID %>").value != "") {
                if (!RegexValidate(document.getElementById("<%= txtFromID.ClientID %>").value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                    ShowMessage("Please enter a valid FROM email address");
                    AddBorder(txtFromID);
                    return false;
                }
            } 
            
            if (document.getElementById("<%= txtCCID.ClientID %>").value != "") {
                if (!RegexValidate(document.getElementById("<%= txtCCID.ClientID %>").value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                    ShowMessage("Please enter a valid CC email address");
                    AddBorder(txtCCID);
                    return false;
                }
            }
            
            if (document.getElementById("<%= txtBCCID.ClientID %>").value != "") {
                if (!RegexValidate(document.getElementById("<%= txtBCCID.ClientID %>").value, "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                    ShowMessage("Please enter a valid BCC email address");
                    AddBorder(txtBCCID);
                    return false;
                }
            }
            
            if (trim(document.getElementById("<%= txtSubject.ClientID %>").value) == "") {
                ShowMessage("Please enter subject");
                AddBorder(txtSubject);
                return false;
            }
            
            if (trim(document.getElementById("<%= txtPurpose.ClientID %>").value) == "") {
                ShowMessage("Please enter purpose");
                AddBorder(txtPurpose);
                return false;
            }

//            if (trim(document.getElementById("<%= txtMailContent.ClientID %>").innerText) == "") {
//                ShowMessage("Please enter message");
//                AddBorder(txtMailContent);
//                return false;
//            }

            if (trim(document.getElementById("<%= txtMailFooter.ClientID %>").value) == "") {
                ShowMessage("Please enter footer");
                AddBorder(txtMailFooter);
                return false;
            }
            
            <%= Page.ClientScript.GetPostBackEventReference(lnkSendMail, Nothing) %>;
        }

        //master script
        function AddBorder(obj) {
            obj.style.border = "solid 2px red";
            obj.focus();
        }
        function RemoveBorder(obj) {
            obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
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
        function RegexValidate(Value, Pattern) {
            //check to see if supposed to validate value
            if (Pattern != null && Pattern.length > 0) {
                var re = new RegExp(Pattern);

                return Value.match(re);
            }
            else {
                return false;
            }
        }

        function trim(stringToTrim) {
            return stringToTrim.replace(/^\s+|\s+$/g, "");
        }

    </script>
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <table cellpadding="0" cellspacing="10" style="font-family: tahoma; font-size: 11px; width: 100%;">
                <tr>
                    <td style="color: #666666;">
                        <a id="A1" runat="server" class="lnk" href="~/admin/default.aspx" style="color: #666666;">
                            Admin</a>&nbsp;>&nbsp; <a id="A2" runat="server" class="lnk" href="~/admin/settings/default.aspx"
                                style="color: #666666;">Settings</a>&nbsp;>&nbsp; <a id="A3" runat="server" class="lnk"
                                    href="~/admin/settings/references/default.aspx" style="color: #666666;">References</a>&nbsp;>&nbsp;
                        <a id="A4" runat="server" class="lnk" href="~/admin/settings/generalemails.aspx"
                            style="color: #666666;">General Email Templates</a>&nbsp;>&nbsp;
                        <asp:Label ID="lblTitle" runat="server" Style="color: #666666;"></asp:Label>
                    </td>
                </tr>
            </table>
       <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:auto;" border="0" cellpadding="0" cellspacing="10">
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="5" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
                            </td>
                            <td runat="server" id="tdError">
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td valign="top" style="padding-left: 0; height: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                    cellspacing="0">
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Label CssClass="entry2" Text="" ForeColor="Red" ID="lblMsg" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"  width="20%">
                            Lawfirm
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlLawFirm" runat="server" CssClass="entry2" Width="200px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"  width="20%">
                            Email Type
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlMailType" runat="server" CssClass="entry2" Width="200px">
                                <asp:ListItem Text="Select" Value="" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="General" Value="G"></asp:ListItem>
                                <asp:ListItem Text="Matter" Value="M"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    
                    <tr style="display:none">
                        <td align="right"  width="20%">
                            To
                        </td>
                        <td>
                             <asp:TextBox ID="txtToID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td align="right"  width="20%">
                            From
                        </td>
                        <td>
                            <asp:TextBox ID="txtFromID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td align="right">
                            CC
                        </td>
                        <td>
                            <asp:TextBox ID="txtCCID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td align="right">
                            BCC
                        </td>
                        <td>
                            <asp:TextBox ID="txtBCCID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Subject
                        </td>
                        <td>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Mail Purpose
                        </td>
                        <td>
                            <asp:TextBox ID="txtPurpose" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td align="right">
                            Attach Documents
                        </td>
                        <td>
                            <input id="txtAttachmentstext" runat="server" class="entry2" readonly="readonly" style="width: 400px" value=""  />&nbsp;<a
                                href="#"  onclick="javascript:return AttachDocument();" class="lnk">Browse Files</a>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td align="right">
                            Message
                        </td>
                        <td>
                        <ighedit:WebHtmlEditor  Height="300px" Width="100%" id="txtMailContent" runat="server" ImageDirectory="~/images/htmleditor" LocalizationFile="" >
                            <RightClickMenu>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Cut">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Copy">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Paste">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="PasteHtml">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="CellProperties">
                                    <Dialog InternalDialogType="CellProperties" />
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties">
                                    <Dialog InternalDialogType="ModifyTable" />
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="InsertImage">
                                </ighedit:HtmlBoxMenuItem>
                            </RightClickMenu>
                            <Toolbar>
                                <ighedit:ToolbarImage runat="server" Type="DoubleSeparator" />
                                <ighedit:ToolbarButton runat="server" Type="Bold" />
                                <ighedit:ToolbarButton runat="server" Type="Italic" />
                                <ighedit:ToolbarButton runat="server" Type="Underline" />
                                <ighedit:ToolbarButton runat="server" Type="Strikethrough" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="Subscript" />
                                <ighedit:ToolbarButton runat="server" Type="Superscript" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="Cut" />
                                <ighedit:ToolbarButton runat="server" Type="Copy" />
                                <ighedit:ToolbarButton runat="server" Type="Paste" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="Undo" />
                                <ighedit:ToolbarButton runat="server" Type="Redo" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="JustifyLeft" />
                                <ighedit:ToolbarButton runat="server" Type="JustifyCenter" />
                                <ighedit:ToolbarButton runat="server" Type="JustifyRight" />
                                <ighedit:ToolbarButton runat="server" Type="JustifyFull" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="Indent" />
                                <ighedit:ToolbarButton runat="server" Type="Outdent" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="UnorderedList" />
                                <ighedit:ToolbarButton runat="server" Type="OrderedList" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarDialogButton runat="server" Type="InsertRule">
                                    <Dialog InternalDialogType="InsertRule" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarImage runat="server" Type="RowSeparator" />
                                <ighedit:ToolbarImage runat="server" Type="DoubleSeparator" />
                                <ighedit:ToolbarDialogButton runat="server" Type="FontColor">
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarDialogButton runat="server" Type="FontHighlight">
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarDialogButton runat="server" Type="SpecialCharacter">
                                    <Dialog InternalDialogType="SpecialCharacterPicker" Type="InternalWindow" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarMenuButton runat="server" Type="InsertTable">
                                    <Menu>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties">
                                            <Dialog InternalDialogType="InsertTable" />
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertColumnRight">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertColumnLeft">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertRowAbove">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertRowBelow">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DeleteRow">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DeleteColumn">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="IncreaseColspan">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DecreaseColspan">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="IncreaseRowspan">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DecreaseRowspan">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="CellProperties">
                                            <Dialog InternalDialogType="CellProperties" />
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties">
                                            <Dialog InternalDialogType="ModifyTable" />
                                        </ighedit:HtmlBoxMenuItem>
                                    </Menu>
                                </ighedit:ToolbarMenuButton>
                                <ighedit:ToolbarButton runat="server" Type="ToggleBorders" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Type="InsertLink" />
                                <ighedit:ToolbarButton runat="server" Type="RemoveLink" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" RaisePostback="True" Type="Save" />
                                <ighedit:ToolbarUploadButton runat="server" Type="Open">
                                    <Upload UploadEnabled="false" Filter="*.htm,*.html,*.asp,*.aspx" Height="350px" Mode="File" Width="500px" />
                                </ighedit:ToolbarUploadButton>
                                <ighedit:ToolbarButton runat="server" Type="Preview" />
                                <ighedit:ToolbarImage runat="server" Type="Separator" />
                                <ighedit:ToolbarDialogButton runat="server" Type="FindReplace">
                                    <Dialog InternalDialogType="FindReplace" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarDialogButton runat="server" Type="InsertBookmark">
                                    <Dialog InternalDialogType="InsertBookmark" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarUploadButton runat="server" Type="InsertImage">
                                    <Upload UploadEnabled="false" Height="420px" Width="500px" />
                                </ighedit:ToolbarUploadButton>
                                <ighedit:ToolbarUploadButton runat="server" Type="InsertFlash">
                                    <Upload UploadEnabled="false" Filter="*.swf" Height="440px" Mode="Flash" Width="500px" />
                                </ighedit:ToolbarUploadButton>
                                <ighedit:ToolbarUploadButton runat="server" Type="InsertWindowsMedia">
                                    <Upload UploadEnabled="false" Filter="*.asf,*.wma,*.wmv,*.wm,*.avi,*.mpg,*.mpeg,*.m1v,*.mp2,*.mp3,*.mpa,*.mpe,*.mpv2,*.m3u,*.mid,*.midi,*.rmi,*.aif,*.aifc,*.aiff,*.au,*.snd,*.wav,*.cda,*.ivf"
                                        Height="400px" Mode="WindowsMedia" Width="500px" />
                                </ighedit:ToolbarUploadButton>
                                <ighedit:ToolbarDialogButton runat="server" Type="Help">
                                    <Dialog InternalDialogType="Text" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarButton runat="server" Type="CleanWord" />
                                <ighedit:ToolbarButton runat="server" Type="WordCount" />
                                <ighedit:ToolbarButton runat="server" Type="PasteHtml" />
                                <ighedit:ToolbarMenuButton runat="server" Type="Zoom">
                                    <Menu>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom25">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom50">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom75">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom100">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom200">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom300">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom400">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom500">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom600">
                                        </ighedit:HtmlBoxMenuItem>
                                    </Menu>
                                </ighedit:ToolbarMenuButton>
                                <ighedit:ToolbarButton runat="server" Type="TogglePositioning" />
                                <ighedit:ToolbarButton runat="server" Type="BringForward" />
                                <ighedit:ToolbarButton runat="server" Type="SendBackward" />
                                <ighedit:ToolbarImage runat="server" Type="RowSeparator" />
                                <ighedit:ToolbarImage runat="server" Type="DoubleSeparator" />
                                <ighedit:ToolbarDropDown runat="server" Type="FontName">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Type="FontSize">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Type="FontFormatting">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Type="FontStyle">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Type="Insert">
                                    <Items>
                                        <ighedit:ToolbarDropDownItem runat="server" Act="Greeting" />
                                        <ighedit:ToolbarDropDownItem runat="server" Act="Signature" />
                                    </Items>
                                </ighedit:ToolbarDropDown>
                            </Toolbar>
                        </ighedit:WebHtmlEditor>
                           <%-- <asp:TextBox ID="txtMailContent" runat="server" TextMode="MultiLine" Width="400px"
                                Height="200px" CssClass="entry2"></asp:TextBox>--%>
                        </td>
                    </tr>
                      <tr valign="top">
                        <td align="right">
                            Message Footer
                        </td>
                        <td>
                            <asp:TextBox ID="txtMailFooter" runat="server" TextMode="MultiLine" Width="100%"
                                Height="75px" CssClass="entry2"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton ID="lnkSendMail" runat="server"></asp:LinkButton>
    <input id="txtAttachments" runat="server" type="hidden" value=""  />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>