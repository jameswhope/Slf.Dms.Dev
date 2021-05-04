<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Uploadmatterdocument.aspx.vb"
    Inherits="util_pop_Uploadmatterdocument" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload Matter Document</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/onlydigits.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>   
    <script type="text/javascript" language="javascript">
  
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
        
        var ddlDocType = null;
        var txtFileUpload = null;
        
        function UploadMatterDocument()
        {
           if (RequiredExist()) {
            <%= Page.ClientScript.GetPostBackEventReference(lnkDocUploaded, Nothing) %>;
            }
        }
        
        function CloseUpload()
        {
//            alert("Matter Document uploaded successfully");
//            window.close();  
            if (window.parent.currentModalDialog){
                window.parent.currentModalDialog.modaldialog("returnValue", -1);
            } else {
                window.returnValue ="-1";
            }
            window.close(); 
        }
        
        function RequiredExist() {
            ddlDocType = document.getElementById("<%= ddlDocType.ClientID %>");
            txtFileUpload = document.getElementById("<%= txtFileUpload.ClientID %>");
            //RemoveBorder(ddlDocType);
            //RemoveBorder(txtFileUpload);
            if (ddlDocType.value == "SELECT") {
                //alert("Please select the document type")
                //ddlDocType.focus();
                ShowMessage("Please select the document type");
                AddBorder(ddlDocType);
                return false;
            }
        
            if (txtFileUpload.value == null || txtFileUpload.value.length == 0) {
                //alert("Please select the file to be uploaded")
                ShowMessage("Please select the file to be uploaded");
                AddBorder(txtFileUpload);
                return false;
            }
            HideMessage()
            return true;
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
    
        function OnFileClick(name)
        {
            document.getElementById('<%=hdnDocument.ClientID %>').value = name;
            <%=Page.ClientScript.GetPostBackEventReference(lnkDocUploaded, Nothing) %>;
        }
        function OnLoad()
        {
            if (document.getElementById('<%=hdnDocument.ClientID %>').value.length > 0)
            {
                window.close();
                return;
            }
            
            if (document.body.offsetWidth < 594 || document.body.offsetHeight < 423)
            {
                if (!window.parent.currentModalDialog){
                    window.resizeTo(600, 500);
                }
            }
        }
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x; overflow: auto;">
    <form runat="server" action="">
    <table>
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
            <td colspan="2" align="center">
                <asp:Label CssClass="entry2" Text="" ForeColor="Red" ID="lblMsg" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <table style="font-family: tahoma; font-size: 11px; width: 100%;">
                    <tr>
                        <td align="right">
                            Document Type:
                        </td>
                        <td><asp:DropDownList ID="ddlDocType" Font-Names="Tahoma" Font-Size="11px"
                                runat="server" /></td>
                    </tr>
                    <tr>
                        <td valign="top" align="right">
                            Description:
                        </td>
                        <td><asp:TextBox ID="txtDescr" runat="server" 
                                TextMode="MultiLine" Rows="2" Width="100%" /></td>
                    </tr>
                    <tr>
                        <td align="right">
                            Select Document:
                        </td>
                        <td><input Class="entry2" id="txtFileUpload" type="file" size="20" name="txtFileUpload"
                                runat="server" style="width: 100%"></td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table style="height: 100%; font-family: tahoma; font-size: 11px; width: 100%;" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <a tabindex="3" style="color: black" class="lnk" href="javascript:window.close();">
                                <img id="Img2" style="margin-right: 6px;" runat="server" src="~/images/16x16_back.png"
                                    border="0" align="absmiddle" />Cancel and Close</a>
                        </td>
                        <td align="right">
                            <a tabindex="4" style="color: black" class="lnk" href="javascript:UploadMatterDocument();">
                                Upload Matter Document
                                <img id="Img3" style="margin-left: 6px;" runat="server" src="~/images/16x16_forward.png"
                                    border="0" align="absmiddle" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="height: 100%;">
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    <input id="hdnDocument" type="hidden" runat="server" />
    <asp:LinkButton ID="lnkDocUploaded" runat="server" />
    </form>
</body>
</html>
