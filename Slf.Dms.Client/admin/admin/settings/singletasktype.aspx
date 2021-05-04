<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="singletasktype.aspx.vb" Inherits="admin_settings_singletasktype" Title="DMP - Admin Settings - References" %>

<%@ Register Assembly="Infragistics2.WebUI.WebHtmlEditor.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" Namespace="Infragistics.WebUI.WebHtmlEditor" TagPrefix="ighedit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>

    <script type="text/javascript">
	function ShowMessage(Value)
	{
	    var dvError = document.getElementById('<%=dvError.ClientID %>');
	    var tdError = document.getElementById('<%=tdError.ClientID %>');

	    dvError.style.display = 'inline';
	    tdError.innerHTML = Value;
	}
	
	function HideMessage()
	{
	    var dvError = document.getElementById('<%=dvError.ClientID %>');
	    var tdError = document.getElementById('<%=tdError.ClientID %>');

	    tdError.innerHTML = '';
	    dvError.style.display = 'none';
	}
	
	function UpdateString(obj)
	{
	    if (obj.checked)
	    {
	        AddString(GetDocID(obj.id));
	    }
	    else
	    {
	        RemoveString(GetDocID(obj.id));
	    }
	}
	
	function RemoveString(str)
	{
	    var associations = document.getElementById('<%=hdnAssociations.ClientID %>');
	    var arr = associations.value.split(',');
	    var i = InArray(arr, str);
	    
	    if (i > 0)
	    {
	        if (i == arr.length - 1)
	        {
	            associations.value = arr.slice(0, i).join(',');
	        }
	        else
	        {
	            associations.value = arr.slice(0, i).concat(arr.slice(i + 1)).join(',');
	        }
	    }
	    else if (i == 0)
	    {
	        associations.value = arr.slice(1).join(',');
	    }
	}
	
	function AddString(str)
	{
	    var associations = document.getElementById('<%=hdnAssociations.ClientID %>');
	    var arr = associations.value.split(',');
	    
	    if (InArray(arr, str) < 0)
	    {
	        if (associations.value.length > 0)
	        {
	            associations.value += ',' + str;
	        }
	        else
	        {
	            associations.value = str;
	        }
	    }
	}
	
	function GetDocID(name)
	{
	    return name.substring(name.indexOf('_') + 1, name.length);
	}
	
	function InArray(arr, value)
	{
	    var tempIdx;
	    
	    for (var i = 0; i < arr.length; i ++)
	    {
	        tempIdx = arr[i].indexOf('|');
	        
	        if (tempIdx < 0)
	        {
	            tempIdx = arr[i].length;
	        }
	        
	        if (arr[i].substring(0, tempIdx) == value)
	        {
	            return i;
	        }
	    }
	    
	    return -1;
	}
	
	function Save()
    {
        var tasktype = document.getElementById('<%=txtTaskType.ClientID %>');
        var description = document.getElementById('<%=txtDescription.ClientID %>');
        var category = document.getElementById('<%=ddlCategory.ClientID %>');
        var strDoc = '<%=TaskTypeIDs %>';
        var strName = '<%=TaskTypes %>';
        var docIDs = strDoc.split(',');
        var docNames = strName.split(',');
        var action = '<%=Action %>';
        
        var docNameIdx = InArray(docNames, tasktype.value);
        
        if (docNameIdx >= 0 && action == 'a')
        {
            var docID = docNames[docNameIdx].substring(docNames[docNameIdx].indexOf('|') + 1);
            
            ShowMessage('Task Type already exists, please choose another one.');
            AddBorder(tasktype);
            return;
        }
        else if (InArray(docIDs, tasktype.value) >= 0)
        {
            ShowMessage('Task Type already exists, please choose another one.');
            AddBorder(tasktype);
            return;
        }
       
        else if (tasktype.value.length <= 0)
        {
            ShowMessage('Please enter a task type.');
             AddBorder(tasktype);
            return;
        }
        if (description.value.length <= 0)
        {
            ShowMessage('Please enter a default description.');
             AddBorder(description);
            return;
        }
        if (category.value=="-1")
        {
            ShowMessage('Please select task type category.');
            AddBorder(category);
            return;
        }
        else
        {
            HideMessage();
        }
        
        <%= ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;
    }
	
	function CancelAndClose()
    {
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
    
    function Delete()
    {
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    
    function Cancel()
    {
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
  
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a
                        runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<a
                            id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/tasktypes.aspx">Task
                            Types</a>&nbsp;>&nbsp;<asp:Label ID="lblTitle" runat="server" Style="color: #666666;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td valign="top" width="100%">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td colspan="2" width="100%">
                            <div runat="server" id="dvError" style="display: none;">
                                <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                                    border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                                    font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                                    width="100%" border="0">
                                    <tr>
                                        <td valign="top" style="width: 20;">
                                            <img runat="server" src="~/images/message.png" align="absmiddle" border="0">
                                        </td>
                                        <td runat="server" id="tdError">
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="60%" valign="top">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td style="background-color: #f3f3f3; font-family: tahoma; font-size: 11px; width: 100%;"
                                        colspan="2" height="25">
                                        General Information
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry" width="30%">
                                        Task Type ID:
                                    </td>
                                    <td width="70%">
                                        <asp:Label ID="lblID" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Task Type:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTaskType" Width="300px" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Default Description:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDescription" Width="300px" TextMode="MultiLine" Rows="3" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Task Type Category:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCategory" Width="300px" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="40%" valign="top">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td style="background-color: #f3f3f3; font-family: tahoma; font-size: 11px; width: 100%;"
                                        colspan="2" height="25">
                                        Audit Trail
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry" width="30%">
                                        Created:
                                    </td>
                                    <td width="70%">
                                        <asp:Label ID="lblCreated" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Created By:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCreatedBy" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Last Modified:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLastModified" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Last Modified By:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLastModifiedBy" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="height: 15px;">
                        <td colspan="2" width="100%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr valign="top">
                        <td colspan="2" width="100%">
                            <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                <td align="right" valign="top" class="srefEntry">
                                    Task Instruction:
                                </td>
                                <td>
                                    <ighedit:WebHtmlEditor Height="300px" Width="100%" id="txtTaskInstruction" runat="server"
                                        ImageDirectory="~/images/htmleditor" LocalizationFile="">
                                        <rightclickmenu>
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
                            </rightclickmenu>
                                        <toolbar>
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
                            </toolbar>
                                    </ighedit:WebHtmlEditor>
                                </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnAssociations" runat="server" />
    <asp:HiddenField ID="hdnInitialAssociations" runat="server" />
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
</asp:Content>
