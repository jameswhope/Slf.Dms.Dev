<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false"
    CodeFile="email.aspx.vb" Inherits="Clients_client_communication_email" Title="DMP - Attorney - Email"
    ValidateRequest="false" %>
<%@ MasterType TypeName="clients_client" %>
<%@ Register Assembly="Infragistics2.WebUI.WebHtmlEditor.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebHtmlEditor" TagPrefix="ighedit" %>
<%@ Register Src="~/customtools/usercontrols/DocumentsControl.ascx" TagName="DocumentsControl" TagPrefix="LexxControl" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" runat="Server">
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
        
        function SendMail() {

            var txtToID  = document.getElementById("<%= txtToID.ClientID %>");
            var txtFromID = document.getElementById("<%= txtFromID.ClientID %>");
            var txtCCID = document.getElementById("<%= txtCCID.ClientID %>");
            //var txtBCCID = document.getElementById("<%= txtBCCID.ClientID %>");
            var ddlSubject = document.getElementById("<%= ddlSubject.ClientID %>");
            var txtMailContent = document.getElementById("<%= txtMailContent.ClientID %>");

             if (trim(document.getElementById("<%= txtToID.ClientID %>").value) == "") {
                ShowMessage("TO email address is a required field");
                AddBorder(txtToID);
                return false;
            }
       
            if (document.getElementById("<%= txtToID.ClientID %>").value != "") 
            {
                var strToEmail = trim(document.getElementById("<%= txtToID.ClientID %>").value).replace(',',';').split(";");
                for(i=0;i<strToEmail.length;i++)
                {
                    if(strToEmail[i]!="")
                    {
                        if (!RegexValidate(trim(strToEmail[i]), "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                            ShowMessage("Please enter a valid TO email address");
                            AddBorder(txtToID);
                            return false;
                        }
                    }
                }
            } 
            
            if (trim(document.getElementById("<%= txtFromID.ClientID %>").value) == "") {
                ShowMessage("FROM email address is a required field");
                AddBorder(txtFromID);
                return false;
            }
            
            if (document.getElementById("<%= txtFromID.ClientID %>").value != "") 
            {
            
                var strFromEmail = trim(document.getElementById("<%= txtFromID.ClientID %>").value).replace(',',';').split(";");
                for(i=0;i<strFromEmail.length;i++)
                {
                    if(strFromEmail[i]!="")
                    {
                        if (!RegexValidate(trim(strFromEmail[i]), "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                            ShowMessage("Please enter a valid FROM email address");
                            AddBorder(txtFromID);
                            return false;
                        }
                    }
                }
                
            } 

            if (document.getElementById("<%= txtCCID.ClientID %>").value != "") 
            {
            
                var strCCEmail = trim(document.getElementById("<%= txtCCID.ClientID %>").value).replace(',',';').split(";");
                for(i=0;i<strCCEmail.length;i++)
                {
                    if(strCCEmail[i]!="")
                    {
                        if (!RegexValidate(trim(strCCEmail[i]), "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
                            ShowMessage("Please enter a valid CC email address");
                            AddBorder(txtCCID);
                            return false;
                        }
                    }
                }
                
            } 
            
//            if (document.getElementById("<%= txtBCCID.ClientID %>").value != "") 
//            {
//            
//                var strBCCEmail = trim(document.getElementById("<%= txtBCCID.ClientID %>").value).replace(',',';').split(";");
//                for(i=0;i<strBCCEmail.length;i++)
//                {
//                    if(strBCCEmail[i]!="")
//                    {
//                        if (!RegexValidate(trim(strBCCEmail[i]), "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")) {
//                            ShowMessage("Please enter a valid BCC email address");
//                            AddBorder(txtBCCID);
//                            return false;
//                        }
//                    }
//                }
//                
//            } 

            if (ddlSubject!=null)
            {
                if (trim(document.getElementById("<%= ddlSubject.ClientID %>").value) == "0") {
                    ShowMessage("Please select a template");
                    AddBorder(ddlSubject);
                    return false;
                }
           }
            
          /*  alert(document.getElementById("<%= txtMailContent.ClientID %>").innerText)
            if (trim(document.getElementById("<%= txtMailContent.ClientID %>").innerText) == "") {
                ShowMessage("Please enter message");
                AddBorder(txtMailContent);
                return false;
            }*/
            
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

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:auto;" border="0" cellpadding="0" cellspacing="10">
        <tr>
            <td style="color: #666666;height:25px">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkCommunications" runat="server" class="lnk" style="color: #666666;"></a><asp:label id="lblSendMail" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
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
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="3"
                    cellspacing="0">
                    <tr>
                        <td style="background-color:#f1f1f1;" colspan="2">Send Email</td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Label CssClass="entry2" Text="" ForeColor="Red" ID="lblMsg" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"  width="12%">
                            To
                        </td>
                        <td>
                             <asp:TextBox ID="txtToID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            From
                        </td>
                        <td>
                            <asp:TextBox ID="txtFromID" runat="server" CssClass="entry2" Width="400px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
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
                            Template
                        </td>
                        <td>
                        
                            <asp:dropdownlist caption="Email Template" cssclass="entry" Width="400px" runat="server" id="ddlSubject" OnSelectedIndexChanged="ddlSubject_SelectedIndexChanged" AutoPostBack="true"></asp:dropdownlist>
                            
                        
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Subject
                        </td>
                        <td>
                            
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="entry2" ReadOnly="true" Width="400px"></asp:TextBox>
                            
                        </td>
                    </tr>
                    <tr>
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
                        <ighedit:WebHtmlEditor Height="300px" Width="100%" id="txtMailContent" runat="server" ImageDirectory="~/images/htmleditor" LocalizationFile=""  >
                            
                           
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
                        </td>
                    </tr>
                      <tr valign="top">
                        <td align="right">
                            Message Footer
                        </td>
                        <td>
                            <asp:TextBox ID="txtMailFooter" runat="server" TextMode="MultiLine" Width="100%"
                                Height="75px" ReadOnly="true" CssClass="entry2"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton ID="lnkSendMail" runat="server"></asp:LinkButton>
    <input id="txtAttachments" runat="server" type="hidden" value=""  />
</asp:Content>
