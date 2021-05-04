<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="AddEdit.aspx.vb" Inherits="FormMgr_AddEdit" %>

<%@ Register Assembly="Infragistics2.WebUI.WebHtmlEditor.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebHtmlEditor" TagPrefix="ighedit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td nowrap="true">
                <a id="A1" runat="server" class="menuButton" href="Default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_form.png" />Forms</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="FormMgr.css" rel="stylesheet" type="text/css" />
    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td style="width: 175px; background-color: rgb(214,231,243); padding:20px;" valign="top">
                <div class="TaskBox">
                    <h6>
                        <span>Common Tasks</span></h6>
                    <div>
                        <img src="~/images/16x16_save.png" runat="server" alt="Save" />
                        <asp:LinkButton ID="lnkSave" runat="server" CssClass="lnk">Save content</asp:LinkButton>
                    </div>
                    <div class="last">
                        <img src="~/images/16x16_cancel.png" runat="server" border="0" alt="Cancel" />
                        <a id="aCancel" runat="server" href="FormContent.aspx" class="lnk">Cancel and close</a>
                    </div>
                </div>
            </td>
            <td valign="top">
                <div style="margin: 15px;">
                    <div class="grey">
                        <a class="greylnk" href="Default.aspx">Forms</a>&nbsp;>&nbsp;<a id="aFormName" runat="server" class="greylnk" href="#">[FormName]</a>&nbsp;>&nbsp;<asp:Label ID="lblAddEdit"
                            runat="server" CssClass="grey"></asp:Label>
                    </div>
                    <h2>
                        Add/Edit Form Content
                    </h2>
                    <div style="padding-bottom:10px;">
                        <table>
                            <tr>
                                <td class="entry2">
                                    Select Form Field (optional):
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlFormField" runat="server" CssClass="entry2">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        <ighedit:WebHtmlEditor ID="WebHtmlEditor1" runat="server" Width="600px" Height="450px"
                            FontFormattingList="Heading 1=&lt;h1&gt;&amp;Heading 2=&lt;h2&gt;&amp;Heading 3=&lt;h3&gt;&amp;Heading 4=&lt;h4&gt;&amp;Heading 5=&lt;h5&gt;&amp;Normal=&lt;p&gt;"
                            FontNameList="Arial,Verdana,Tahoma,Courier New,Georgia" FontSizeList="1,2,3,4,5,6,7"
                            FontStyleList="Blue Underline=color:blue;text-decoration:underline;&amp;Red Bold=color:red;font-weight:bold;&amp;ALL CAPS=text-transform:uppercase;&amp;all lowercase=text-transform:lowercase;&amp;Reset="
                            SpecialCharacterList="&amp;#937;,&amp;#931;,&amp;#916;,&amp;#934;,&amp;#915;,&amp;#936;,&amp;#928;,&amp;#920;,&amp;#926;,&amp;#923;,&amp;#958;,&amp;#956;,&amp;#951;,&amp;#966;,&amp;#969;,&amp;#949;,&amp;#952;,&amp;#948;,&amp;#950;,&amp;#968;,&amp;#946;,&amp;#960;,&amp;#963;,&amp;szlig;,&amp;thorn;,&amp;THORN;,&amp;#402,&amp;#1046;,&amp;#1064;,&amp;#1070;,&amp;#1071;,&amp;#1078;,&amp;#1092;,&amp;#1096;,&amp;#1102;,&amp;#1103;,&amp;#12362;,&amp;#12354;,&amp;#32117;,&amp;AElig;,&amp;Aring;,&amp;Ccedil;,&amp;ETH;,&amp;Ntilde;,&amp;Ouml;,&amp;aelig;,&amp;aring;,&amp;atilde;,&amp;ccedil;,&amp;eth;,&amp;euml;,&amp;ntilde;,&amp;cent;,&amp;pound;,&amp;curren;,&amp;yen;,&amp;#8470;,&amp;#153;,&amp;copy;,&amp;reg;,&amp;#151;,@,&amp;#149;,&amp;iexcl;,&amp;#14;,&amp;#8592;,&amp;#8593;,&amp;#8594;,&amp;#8595;,&amp;#8596;,&amp;#8597;,&amp;#8598;,&amp;#8599;,&amp;#8600;,&amp;#8601;,&amp;#18;,&amp;brvbar;,&amp;sect;,&amp;uml;,&amp;ordf;,&amp;not;,&amp;macr;,&amp;para;,&amp;deg;,&amp;plusmn;,&amp;laquo;,&amp;raquo;,&amp;middot;,&amp;cedil;,&amp;ordm;,&amp;sup1;,&amp;sup2;,&amp;sup3;,&amp;frac14;,&amp;frac12;,&amp;frac34;,&amp;iquest;,&amp;times;,&amp;divide;">
                            <DownlevelLabel Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                            <DropDownStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                            <ProgressBar Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                            <DownlevelTextArea Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                            <RightClickMenu Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False">
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Cut" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Copy" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="Paste" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="PasteHtml" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="CellProperties" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" InternalDialogType="CellProperties" />
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" InternalDialogType="ModifyTable" />
                                </ighedit:HtmlBoxMenuItem>
                                <ighedit:HtmlBoxMenuItem runat="server" Act="InsertImage" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                </ighedit:HtmlBoxMenuItem>
                            </RightClickMenu>
                            <TextWindow Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                            <Toolbar Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False">
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="DoubleSeparator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Bold" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Italic" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Underline" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Strikethrough" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Subscript" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Superscript" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Cut" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Copy" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Paste" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Undo" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Redo" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="JustifyLeft" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="JustifyCenter" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="JustifyRight" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="JustifyFull" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Indent" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Outdent" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="UnorderedList" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="OrderedList" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarDialogButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="InsertRule">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" InternalDialogType="InsertRule" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="RowSeparator" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="DoubleSeparator" />
                                <ighedit:ToolbarDialogButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="FontColor">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarDialogButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="FontHighlight">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarDialogButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="SpecialCharacter">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" InternalDialogType="SpecialCharacterPicker" Type="InternalWindow" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarMenuButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="InsertTable">
                                    <Menu Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False">
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                            <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                                Font-Underline="False" InternalDialogType="InsertTable" />
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertColumnRight" Font-Bold="False"
                                            Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertColumnLeft" Font-Bold="False"
                                            Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertRowAbove" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="InsertRowBelow" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DeleteRow" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DeleteColumn" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="IncreaseColspan" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DecreaseColspan" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="IncreaseRowspan" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="DecreaseRowspan" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="CellProperties" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                            <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                                Font-Underline="False" InternalDialogType="CellProperties" />
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="TableProperties" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                            <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                                Font-Underline="False" InternalDialogType="ModifyTable" />
                                        </ighedit:HtmlBoxMenuItem>
                                    </Menu>
                                </ighedit:ToolbarMenuButton>
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="ToggleBorders" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="InsertLink" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="RemoveLink" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Preview" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Separator" />
                                <ighedit:ToolbarDialogButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="FindReplace">
                                    <Dialog Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" InternalDialogType="FindReplace" />
                                </ighedit:ToolbarDialogButton>
                                <ighedit:ToolbarUploadButton runat="server" Font-Bold="False" Font-Italic="False"
                                    Font-Overline="False" Font-Strikeout="False" Font-Underline="False" Type="InsertImage">
                                    <Upload Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False" Height="420px" Width="500px" />
                                </ighedit:ToolbarUploadButton>
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="CleanWord" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="WordCount" />
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="PasteHtml" />
                                <ighedit:ToolbarMenuButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="Zoom">
                                    <Menu Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                        Font-Underline="False">
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom25" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom50" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom75" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom100" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom200" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom300" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom400" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom500" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                        <ighedit:HtmlBoxMenuItem runat="server" Act="Zoom600" Font-Bold="False" Font-Italic="False"
                                            Font-Overline="False" Font-Strikeout="False" Font-Underline="False">
                                        </ighedit:HtmlBoxMenuItem>
                                    </Menu>
                                </ighedit:ToolbarMenuButton>
                                <ighedit:ToolbarButton runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="TogglePositioning" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="RowSeparator" />
                                <ighedit:ToolbarImage runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="DoubleSeparator" />
                                <ighedit:ToolbarDropDown runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="FontName">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="FontSize">
                                </ighedit:ToolbarDropDown>
                                <ighedit:ToolbarDropDown runat="server" Font-Bold="False" Font-Italic="False" Font-Overline="False"
                                    Font-Strikeout="False" Font-Underline="False" Type="FontFormatting">
                                </ighedit:ToolbarDropDown>
                            </Toolbar>
                            <TabStrip Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                                Font-Underline="False" />
                        </ighedit:WebHtmlEditor>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnFormID" runat="server" />
</asp:Content>
