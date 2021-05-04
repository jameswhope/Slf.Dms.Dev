<%@ Page Language="VB" AutoEventWireup="false" CodeFile="side_note.aspx.vb" Inherits="clients_client_communication_side_note" title="DMP - Note" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DMP - Notes</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/setfocus.js") %>"></script>

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
</head>
<body style="margin-top:0; margin-left:0; margin-right:0; margin-bottom:0;"  onload="SetFocus('<%= txtMessage.ClientID %>');" >
    <form id="form1" runat="server">       
    
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
        <script type="text/javascript">
        function RedirectTop(s)
        {
            self.top.location=s;
        }
        function Record_Save()
        {
            if (Record_RequiredExist())
            {
                // postback to save
                <%= Page.ClientScript.GetPostBackEventReference(lnkSave, Nothing) %>;        
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
	    function AddBorder(obj)
	    {
            obj.style.border = "solid 2px red";
            obj.focus();
	    }
	    function RemoveBorder(obj)
	    {
            obj.style.cssText = obj.style.cssText.replace(/BORDER-TOP: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-LEFT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-RIGHT: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid;/g, '');
            obj.style.cssText = obj.style.cssText.replace(/BORDER-BOTTOM: red 2px solid/g, '');
	    }
        function Record_RequiredExist()
        {
            var txtMessage = document.getElementById("<%= txtMessage.ClientID %>");
            
            if (txtMessage.value == null || txtMessage.value.length == 0)
            {
	            ShowMessage("You must enter a message.");
	            AddBorder(txtMessage);

                return false;        
            }

            return true;
        }
        </script>
        
        <script type="text/javascript" language="javascript">
        var attachWin;
        var scanWin;

        var intAttachWin;
        var intScanWin;
        
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == "IMG")
                obj = obj.parentElement;
                
            if (obj.tagName == "TD")
            {
                //remove hover from last tr
                if (tbl.getAttribute("lastTr") != null)
                {
                    var lastTr = tbl.getAttribute("lastTr");
                    if (lastTr.coldColor == null)
                        lastTr.coldColor = "#ffffff";
                    lastTr.style.backgroundColor = lastTr.coldColor;
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = "#f4f4f4";
                    tbl.setAttribute("lastTr", curTr);
                }
            }
        }
        function RowClick(tr, docRelID)
        {
            //unselect last row
            var tbl = tr.parentElement.parentElement;
            if (tbl.lastSelTr != null)
            {
                tbl.lastSelTr.coldColor = "#ffffff";
                tbl.lastSelTr.style.backgroundColor = "#ffffff";
            }
            
            //select this row
            tr.coldColor="#ededed";
            tr.style.backgroundColor = "#f0f0f0";
            
            document.getElementById('<%=hdnCurrentDoc.ClientID %>').value = docRelID;
            
            //set this as last
            tbl.lastSelTr = tr;
        }
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = <%=NoteID %>;
            var relType = <%=RelationTypeID %>;
            var addRelID = <%=RelationID %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempNoteID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=DataClientID %>&type=note&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
            intAttachWin = setInterval('WaitAttached()', 500);
        }
        function WaitAttached()
        {
            if (attachWin.closed)
            {
                clearInterval(intAttachWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
        function OpenScanning()
        {
            var relID = <%=NoteID %>;
            var relType = <%=RelationTypeID %>;
            var addRelID = <%=RelationID %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempNoteID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            try{
                self.top.frames[0].ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=DataClientID %>&context=<%=ContextSensitive %>&type=note&rel=' + relID);
            }
            catch(e){
                if(window.parent.parent != null)  
                    {
                       var val = window.parent.parent.ShowScanning('<%=ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.aspx") %>?id=<%=DataClientID %>&context=<%=ContextSensitive %>&type=note&rel=' + relID);
                    }
            }

        }
        function WaitScanned()
        {
            if (scanWin.closed)
            {
                clearInterval(intScanWin);
                <%=Page.ClientScript.GetPostBackEventReference(lnkShowDocs, Nothing) %>;
            }
        }
    </script>

        <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="background-color:rgb(244,242,232);" >
                    <table style="color:rgb(80,80,80);width:100%;font-size:11px;font-family:tahoma;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td><img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" /></td>
                            <td style="width:100%;">
                                <table class="grid" style="height:25;background-image:url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);background-repeat:repeat-x;background-position:left top;background-color:rgb(232,227,218);font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td nowrap="true">
                                             <asp:LinkButton ID="lnkSave" runat="server" class="gridButton">
                                                <img id="Img3" runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_save.png" />
                                                Save and Close
                                            </asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width:100%;height:25">&nbsp;</td>
                                        <td nowrap="true">
                                             <asp:LinkButton ID="lnkCancel" runat="server" class="gridButton">
                                                <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_cancel.png" />
                                                Cancel
                                            </asp:LinkButton>
                                        </td>
                                        <td nowrap="true" style="width:10;">&nbsp;</td>
                                     </tr>
                                </table>
                            </td>
                        </tr>
                        
                    </table>
                </td>
            </tr>
            <tr id="trInfoBox" runat="server" >
                <td style="padding:5px">
                    <div class="iboxDiv">
                        <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                            <tr>
                                <td valign="top" style="width:16;"><img id="Img2" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                                <td>
                                    <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="iboxHeaderCell"><asp:Literal id="ltrNew" runat="server"></asp:Literal>Note for <b><%=RelationTypeName %></b>&nbsp;<%=EntityName %></td>
                                        </tr>
                                        
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr >
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
                        <tr style="padding-left:5px;padding-right:5px">
                            <td style="width:100%;" valign="top">
                                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                    <tr>
                                        <td style="background-color:#f1f1f1;" colspan="2">Details</td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell">Created by:</td>
                                        <td><asp:label cssclass="entry2" runat="server" id="txtCreatedBy"></asp:label> on <asp:label cssclass="entry2" runat="server" id="txtCreatedDate"></asp:label></td>
                                    </tr>
                                    <tr>
                                        <td class="entrytitlecell">Last modified by:</td>
                                        <td><asp:label cssclass="entry2" runat="server" id="txtLastModifiedBy"></asp:label> on <asp:label cssclass="entry2" runat="server" id="txtLastModifiedDate"></asp:label></td>
                                    </tr>
                                    <tr id="trMessage" runat="server">
                                        <td class="entrytitlecell" colspan="2" style="width:100%">
                                            Message:<br />
                                            <div style="padding-top:5px">
                                                <asp:textbox TabIndex="3" cssclass="entry" runat="server" id="txtMessage" Rows="20" TextMode="MultiLine" MaxLength="5000" Columns="50"></asp:textbox>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="entrytitlecell" colspan="3" style="width:100%;padding-top:10px">
                    <table id="tblDocuments" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0" runat="server">
                        <tr>
                            <td style="background-color:#f1f1f1;">Document</td>
                            <td style="background-color:#f1f1f1;" align="right">
                                <a class="lnk" href="javascript:OpenScanning();">Scan Document</a>&nbsp;|&nbsp;<a class="lnk" href="javascript:AttachDocument();">Attach</a>&nbsp;|&nbsp;<a class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:DeleteDocument();">Delete</a>
                            </td>
                        </tr>
                        <tr id="tr2" runat="server">
                            <td colspan="2">
                                <table onmouseover="RowHover(this, true)" onmouseout="RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                                    <thead>
                                        <tr>
                                            <th style="width:20px;" align="center">
                                                <img id="Img8" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                            </th>
                                            <th style="width:11px;">&nbsp;</th>
                                            <th align="left" style="width:90%;">Document Name</th>
                                            <th align="right">Created</th>
                                            <th align="right" style="width:5px;">&nbsp;</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:repeater runat="server" id="rpDocuments">
                                            <itemtemplate>
                                                <a href="#" onclick="javascript:RowClick(this.childNodes(0), <%#CType(Container.DataItem.DocRelationID, Integer) %>);">
                                                    <tr>
                                                        <td style="width:20px;" align="center">
                                                            <img id="Img2" runat="server" src="~/images/16x16_file_new.png" border="0" align="absmiddle" />
                                                        </td>
                                                        <td style="width:11px;">&nbsp;</td>
                                                        <td align="left" style="width:90%;">
                                                            <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\") %>');">
                                                                <%#CType(Container.DataItem.DocumentType, String) %>&nbsp;
                                                            </a>
                                                        </td>
                                                        <td align="right">
                                                            <%#CType(Container.DataItem.Created, String) %>&nbsp;
                                                        </td>
                                                        <td align="right" style="width:5px;">
                                                            &nbsp;
                                                        </td>
                                                    </tr>
                                                </a>
                                            </itemtemplate>
                                        </asp:repeater>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height:100%;">
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
        <input id="hdnCurrentDoc" type="hidden" runat="server" />
        <input id="hdnTempNoteID" type="hidden" runat="server" />
        
        <asp:LinkButton ID="lnkShowDocs" runat="server" />
        <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    </form>
</body>
</html>