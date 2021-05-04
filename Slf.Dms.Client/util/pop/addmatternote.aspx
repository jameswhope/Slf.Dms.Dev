<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addmatternote.aspx.vb" Inherits="util_pop_addmatternote" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Matter Note</title>
    <base target="_self" />
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
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">
    
    if (window.parent.currentModalDialog) {
        window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
    }
    
     function SaveNote()
    {
    
        if(document.getElementById("<%=txtMessage.ClientID%>").value=='')
        {
            ShowMessage(" Matter note is a required field");
            AddBorder(document.getElementById("<%=txtMessage.ClientID%>"));
            return false;
        }  
            <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;        
       
    }
     
    function CloseMatterNote()
    {
        if (window.parent.currentModalDialog){
            window.parent.currentModalDialog.modaldialog("returnValue", -1);
        } else {
            window.returnValue ="-1";
        }
        window.close();  
    }
    
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


    function ShowMessage(Value) {
        dvError.style.display = "inline";
        tdError.innerHTML = Value;
    }
    function HideMessage() {
        tdError.innerHTML = "";
        dvError.style.display = "none";
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <table style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0"
        runat="server" id="tblBody">
        <tr>
            <td>
                <div runat="server" id="dvError" style="display: none;">
                    <table style="border-right: #969696 1px solid; border-top: #969696 1px solid; font-size: 11px;
                        border-left: #969696 1px solid; color: red; border-bottom: #969696 1px solid;
                        font-family: Tahoma; background-color: #ffffda" cellspacing="10" cellpadding="0"
                        width="100%" border="0">
                        <tr>
                            <td valign="top" width="20">
                                <img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0">
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
            <td valign="top" style="padding-left: 10; height: 100%;">
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="5"
                    cellspacing="0">
                    <tr>
                        <td style="background-color: #f1f1f1;" colspan="2">
                           Add New Note for a Matter
                        </td>
                    </tr>
                    <tr>
                        <td class="entrytitlecell">
                            Created by:
                        </td>
                        <td>
                            <asp:Label CssClass="entry2" runat="server" ID="txtCreatedBy"></asp:Label>
                            on
                            <asp:Label CssClass="entry2" runat="server" ID="txtCreatedDate"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="entrytitlecell">
                            Last modified by:
                        </td>
                        <td>
                            <asp:Label CssClass="entry2" runat="server" ID="txtLastModifiedBy"></asp:Label>
                            on
                            <asp:Label CssClass="entry2" runat="server" ID="txtLastModifiedDate"></asp:Label>
                        </td>
                    </tr>
                    <tr id="trMessage" runat="server">
                        <td class="entrytitlecell" colspan="2">
                            Message:<br />
                            <asp:TextBox TabIndex="3" CssClass="entry" runat="server" ID="txtMessage" Rows="10"
                                TextMode="MultiLine" MaxLength="5000" Columns="50" Style="width: 50em"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 40px; border-top: solid 2px rgb(149,180,234); padding-left: 10px;
                padding-right: 10px;">
                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a tabindex="3" style="color: black" class="lnk" href="javascript:window.close();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="absmiddle" />Cancel and Close</a>
                        </td>
                        <td align="right">
                            <a tabindex="4" style="color: black" class="lnk" href="#" onclick="javascript:return SaveNote();">
                                Save Note
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absmiddle" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>
    </form>
</body>
</html>
