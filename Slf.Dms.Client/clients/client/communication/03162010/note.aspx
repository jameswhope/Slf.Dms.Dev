<%@ Page Language="VB" MasterPageFile="~/clients/client/client.master" AutoEventWireup="false" CodeFile="note.aspx.vb" Inherits="clients_client_applicants_applicant" title="DMP - Client - Note" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ MasterType TypeName="clients_client" %>
<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:placeholder id="phBody" runat="server">

<body onload="SetFocus('<%= txtMessage.ClientID %>');" style="background-image:url(<%= ResolveUrl("~/images/back.bmp") %>); background-position:left top; background-repeat:repeat-x;">

    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { width:100; }
    </style>
    
    <script type="text/javascript">
    function AddRelation()
    {
        showModalDialog("<%= ResolveUrl("~/util/pop/addrelation.aspx?to=note&toid=" & NoteID & "&client&dependencyid=" & ClientID) %>", window, "status:off;help:off;dialogWidth:450px;dialogHeight:350px;");
    }
    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= Page.ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
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
	function Record_DeleteConfirm()
	{
        showModalDialog("<%= ResolveUrl("~/deleteholder.aspx?t=Note&p=note") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
	}
    function Record_Delete()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_DeleteConfirmRelation()
	{
        showModalDialog("<%= ResolveUrl("~/util/pop/confirmholder.aspx?f=Record_DeleteRelation&t=Delete Relations&m=Are you sure you want to delete this selection of relations?") %>", window, "status:off;help:off;dialogWidth:400px;dialogHeight:300px;");
	}
    function Record_DeleteRelation()
    {
        // postback to delete
        <%= Page.ClientScript.GetPostBackEventReference(lnkDeleteRelation, Nothing) %>;
    }
    </script>
    
    <script type="text/javascript" language="javascript">
        var attachWin;
        var intAttachWin;
        
        var scanWin;
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
        function AttachDocument()
        {
            var w = 500;
            var h = 300;
            var l = (screen.width - w) / 2;
            var t = (screen.height - h) / 2;
            
            var relID = <%=NoteID %>;
            var addRelID = <%=AddRelation %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempNoteID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            attachWin = window.open('<%=ResolveUrl("~/util/pop/attachdocument.aspx") %>?id=<%=ClientID %>&type=note&rel=' + relID, 'AttachDocument', 'top=' + t + ',left=' + l + ',width=' + w + ',height=' + h + ',scrollbars=1');
            
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
        function DeleteDocument()
        {
            if (document.getElementById('<%=hdnCurrentDoc.ClientID %>').value.length > 0)
            {
                <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDocument, Nothing) %>;
            }
        }
        function OpenScanning()
        {
            var relID = <%=NoteID %>;
            var addRelID = <%=AddRelation %>;
            
            if (relID == 0)
            {
                relID = document.getElementById('<%=hdnTempNoteID.ClientID %>').value + '&temp=1';
            }
            
            if (addRelID != 0)
            {
                relID += '&addrel=<%=AddRelationType %>&addrelid=' + addRelID;
            }
            
            scanWin = window.open('<%=ResolveUrl("~/clients/client/scanning.aspx") %>?id=<%=ClientID %>&type=note&rel=' + relID, 'ScanDocument', 'left=0,top=0,width=' + screen.width + ',height=' + screen.height);
            
            intScanWin = setInterval('WaitScanned()', 500);
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
    
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;height:auto;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;height:25px">
                <a runat="server" class="lnk" style="color: #666666;" href="~/clients">Clients</a>&nbsp;>&nbsp;<a id="lnkClient" runat="server" class="lnk" style="color: #666666;"></a>&nbsp;>&nbsp;<a id="lnkCommunications" runat="server" class="lnk" style="color: #666666;">Communications</a>&nbsp;>&nbsp;<asp:label id="lblNote" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="50%">
                    <tr>
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
                    <tr>
                        <td style="width:50%;" valign="top">
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
                                    <td class="entrytitlecell" colspan="2">Message:<br /><asp:textbox TabIndex="3" cssclass="entry" runat="server" id="txtMessage" Rows="10" TextMode="MultiLine" MaxLength="1000" Columns="50" style="width:50em"></asp:textbox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="trRelations" runat="Server">
                        <td class="entrytitlecell" colspan="3" style="width:100%;padding-top:10px">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="5" cellspacing="0">
                                <tr>
                                    <td style="background-color:#f1f1f1;">Related To</td>
                                    <td style="background-color:#f1f1f1;" align="right">
                                        <a class="lnk" href="javascript:AddRelation();">Add Relation</a>&nbsp;|&nbsp;<a class="lnk" id="lnkDeleteConfirmRelation" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirmRelation(this);">Delete</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table onmouseover="Grid_RowHover(this, true)" onmouseout="Grid_RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                                            <colgroup>
                                                <col align="center" style="width:20px" />
                                                <col align="center"/>
                                                <col align="left" style="width:30%"/>
                                                <col align="left" style="width:70%"/>
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <td align="center" style="width:20;" class="headItem"><img id="Img1" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img5" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                                                    <th style="width: 25;" align="center">
                                                        <img id="Img2" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                                                    </th>
                                                    <th>Relation Type</th>
                                                    <th>Relation</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <asp:repeater runat="server" id="rpRelations">
                                                <itemtemplate>
                                                    <a href="<%#ResolveURL(ctype(DataBinder.Eval(Container.DataItem, "NavigateURL"),string).replace("$clientid$",ClientID).replace("$x$",DataBinder.Eval(Container.DataItem, "RelationID")))  %>"
                                                    <tr>
                                                        <td style="width:20;" align="center"><img id="Img6" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img7" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "noteRelationID") %>);" style="display:none;" type="checkbox" /></td>
                                                        <td ><img src="<%#ResolveURL(DataBinder.Eval(Container.DataItem, "IconURL"))%>" border="0"/></td>
                                                        <td>
                                                            <%#DataBinder.Eval(Container.DataItem, "RelationTypeName") %>
                                                        </td>
                                                        <td>
                                                            <%#DataBinder.Eval(Container.DataItem, "RelationName") %>
                                                        </td>
                                                    </tr>
                                                    </a>
                                                </itemtemplate>
                                            </asp:repeater>
                                            </tbody>
                                        </table><input type="hidden" runat="server" id="txtSelectedIDs"/><input type="hidden" value="<%= lnkDeleteConfirmRelation.ClientId%>"/>
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
                            <a class="lnk" href="javascript:AttachDocument();">Attach Document</a>&nbsp;|&nbsp;<a class="lnk" id="hypDeleteDoc" disabled="true" runat="server" href="#" onmouseup="javascript:DeleteDocument();">Delete</a>
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
                                        <th align="left" style="width:40%;">Document Name</th>
                                        <th align="left" style="width:100px;display:none;">Origin</th>
                                        <th align="left">Received</th>
                                        <th align="left">Created</th>
                                        <th align="left">Created By</th>
                                        <th style="width:20px;" align="right"></th>
                                        <th align="right" style="width:10px;">&nbsp;</th>
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
                                                    <td align="left" style="width:40%;">
                                                        <a href="#" class="lnk" onclick="javascript:window.open('<%#CType(Container.DataItem.DocumentPath, String).Replace("\", "\\") %>');">
                                                            <%#CType(Container.DataItem.DocumentType, String) %>&nbsp;
                                                        </a>
                                                    </td>
                                                    <td align="left" style="width:100px;display:none;">
                                                        <%#CType(Container.DataItem.Origin, String) %>&nbsp;
                                                    </td>
                                                    <td align="left">
                                                        <%#CType(Container.DataItem.Received, String) %>&nbsp;
                                                    </td>
                                                    <td align="left">
                                                        <%#CType(Container.DataItem.Created, String) %>&nbsp;
                                                    </td>
                                                    <td align="left">
                                                        <%#CType(Container.DataItem.CreatedBy, String) %>&nbsp;
                                                    </td>
                                                    <td style="width:20px;" align="right">
                                                        <%#IIf(Not CType(Container.DataItem.Existence, Boolean), "<img src=""" + ResolveUrl("~/images/16x16_no_file.png") + """ border=""0"" align=""absmiddle"" />", "&nbsp;") %>
                                                    </td>
                                                    <td align="right" style="width:10px;">
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
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose" />
    <asp:LinkButton runat="server" ID="lnkSave" />
    <asp:LinkButton runat="server" ID="lnkDelete" />
    <asp:linkbutton runat="server" id="lnkDeleteRelation" />
    <asp:LinkButton runat="server" ID="lnkSetAsPrimary" />
    
    <input id="hdnTempNoteID" type="hidden" runat="server" />
    <input id="hdnCurrentDoc" type="hidden" runat="server" />
    <asp:LinkButton ID="lnkDeleteDocument" runat="server" />
    <asp:LinkButton ID="lnkShowDocs" runat="server" />

</body>

</asp:placeholder></asp:Content>