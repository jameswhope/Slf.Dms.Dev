﻿<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="MatterPhoneNotes.aspx.vb" Inherits="admin_settings_matterPhoneNotes" title="DMP - MatterPhoneNotes Templates" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server">
    <script type="text/javascript" language="javascript">
        var ids = new Array();
        
        var txtSelected = null;
        var lnkDeleteConfirm = null;
        
        function RowHover(tbl, over)
        {
            var obj = event.srcElement;
            
            if (obj.tagName == 'IMG')
                obj = obj.parentElement;
                
            if (obj.tagName == 'TD')
            {
                //remove hover from last tr
                if (tbl.getAttribute('lastTr') != null)
                {
                    tbl.getAttribute('lastTr').style.backgroundColor = '#ffffff';
                }

                //if the mouse is over the table, set hover to current tr
                if (over)
                {
                    var curTr = obj.parentElement;
                    curTr.style.backgroundColor = '#f3f3f3';
                    tbl.setAttribute('lastTr', curTr);
                }
            }
        }
        
        function RowClick(id)
        {
            window.location.href = '<%=ResolveUrl("~/admin/settings/AddEditPhoneNote.aspx") %>?a=e&id=' + id;
        }
        
        function AddTemplate()
        {
            window.location.href = '<%=ResolveUrl("~/admin/settings/AddEditPhoneNote.aspx") %>?a=a';
        }
        
        function AddOrDrop(obj, id)
        {
	        if (obj.checked)
	        {
		        AddString(id, ids);
	        }
	        else
	        {
		        RemoveString(id, ids);
	        }

            UpdateSelected();
        }
        
        function AddString(string, array)
        {
	        array[array.length] = string;
        }
        
        function RemoveString(string, array)
        {
	        var index = StringExists(string, array);

	        if (index >= 0 && index < array.length)
	        {
		        array.splice(index, 1);
	        }

	        return array;
        }
        
        function UpdateSelected()
        {
            LoadControls();

            txtSelected.value = ids.join(',');

            if (txtSelected.value.length > 0)
            {
                lnkDeleteConfirm.disabled = false;
            }
            else
            {
                lnkDeleteConfirm.disabled = true;
            }
        }
        
        function LoadControls()
        {
            if (lnkDeleteConfirm == null)
            {
                lnkDeleteConfirm = document.getElementById('<%=lnkDelete.ClientID %>');
            }

            if (txtSelected == null)
            {
                txtSelected = document.getElementById('<%=txtSelected.ClientID %>');
            }
        }
        
        function StringExists(string, array)
        {
	        for (i = 0; i < array.length; i++)
	        {
		        if (array[i] == string)
			        return i;
	        }

	        return -1;
        }
        
        function ClearArray()
        {
	        ids = null;
	        ids = new Array();
        }
        
        function DeleteDoc()
        {
            <%=Page.ClientScript.GetPostBackEventReference(lnkDeleteDoc, Nothing) %>;
        }
        
        function Sort(obj)
        {
            document.getElementById('<%=txtSortField.ClientId %>').value = obj.id.substring(obj.id.lastIndexOf('_') + 1);
            <%=Page.ClientScript.GetPostBackEventReference(lnkResort, Nothing) %>;
        }
        
        window.onload = function ()
        {
            var elements = document.getElementsByTagName('img');
            var sortimg = '<%=SortImage %>';
            var sortimgpath = '<%=SortImagePath %>';
            
            for (var i = 0; i < elements.length; i++)
            {
                if (elements[i].id.indexOf('imgSort_') == 0)
                {
                    if (elements[i].id == sortimg)
                    {
                        elements[i].src = sortimgpath;
                        elements[i].style.display = 'inline';
                    }
                    else
                    {
                        elements[i].style.display = 'none';
                    }
                }
            }
        }
    </script>
    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
            <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<asp:Label id="lblTitle" runat="server"></asp:Label></td>
        </tr>
        <tr>
            <td>
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color:#f3f3f3;padding: 5 5 5 5;">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="color:rgb(50,112,163);">Matter Phone Notes Templates</td>
                                    <td align="right"><asp:Panel ID="pnlDelete" Enabled="false" runat="server"><a class="lnk" id="lnkDelete" runat="server" href="#">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id="A4" runat="server" href="javascript:window.print();"><img id="Img3" runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></asp:Panel></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
   
            
            <!-- Start Matter Phone Note Template List-->
            <table class="trefTable" onmouseover="RowHover(this,true)" onmouseout="RowHover(this,false)" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td align="center" style="width:10px;" class="trefHeaderCell">&nbsp;</td>
                        <td class="trefHeaderCell" style="width:22px;" align="center"><img id="Img1" src="~/images/16x16_icon.png" border="0" align="absmiddle" runat="server" /></td>
                        <td id="tdHeader_PhoneEntry" class="trefHeaderCell" style="width:125px;cursor:pointer;" align="left" onclick="Sort(this);">Phone Entry<img id="imgSort_PhoneEntry" border="0" style="margin-left:5px;" align="absmiddle" alt="" /></td>
                        <td id="tdHeader_PhoneEntryDesc" class="trefHeaderCell" style="width:250px;cursor:pointer;" align="left" onclick="Sort(this);">Description<img id="imgSort_PhoneEntryDesc" border="0" style="margin-left:5px;" align="absmiddle" alt="" /></td>
                        <td id="tdHeader_PhoneEntryBody" class="trefHeaderCell" style="width:400px;cursor:pointer;" align="left" onclick="Sort(this);">Body<img id="imgSort_PhoneEntryBody" border="0" style="margin-left:5px;" align="absmiddle" alt="" /></td>
                        <td id="tdHeader_IsActive" class="trefHeaderCell" style="width:10px;cursor:pointer;" align="left" onclick="Sort(this);">isActive<img id="imgSort_IsActive" border="0" style="margin-left:5px;" align="absmiddle" alt="" /></td>
                        <td class="trefHeaderCell" style="width:10px;">&nbsp;</td>
                    </tr>
                </table>
            
            <!-- Starts Repeaters List -->
            <table class="list" onmouseover="RowHover(this, true)" onmouseout="RowHover(this, false)" onselectstart="return false;" cellspacing="0" cellpadding="3" style="border-right:1px solid #F0F0F0;width:100%;vertical-align:top;">
                    <tbody>
                        <asp:repeater id="rptMatterPhoneNotes" runat="server">
                            <itemtemplate>
                                    <tr>
                                        <td style="width:10px;" class="trefBodyCell" align="center">
                                            <img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;window.event.cancelBubble=true;return false;" src="<%=ResolveUrl("~/images/13x13_check_cold.png") %>" border="0" align="absmiddle" /><img onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;window.event.cancelBubble=true;return false;" style="display:none;" src="<%=ResolveUrl("~/images/13x13_check_hot.png") %>" border="0" align="absmiddle" /><input onpropertychange="AddOrDrop(this, <%#CType(Container.DataItem, MatterPhoneNoteTemplate).MatterPhoneEntryID %>);" style="display:none;" type="checkbox" />
                                        </td>
                                        <a href="#" onclick="RowClick(<%#CType(Container.DataItem, MatterPhoneNoteTemplate).MatterPhoneEntryId %>);">
                                            <td nowrap align="center" style="width:22px;">
                                                <img id="Img2" src="~/images/16x16_file_new.png" border="0" align="absmiddle" runat="server" />
                                            </td>
                                            <td nowrap align="left" style="width:125px;">
                                                <%#CType(Container.DataItem, MatterPhoneNoteTemplate).PhoneEntry%>
                                            </td>
                                            <td nowrap align="left" style="width:250px;">
                                                <%#CType(Container.DataItem, MatterPhoneNoteTemplate).PhoneEntryDesc%>
                                            </td>
                                            <td nowrap align="left" style="width:400px;">
                                                <%#CType(Container.DataItem, MatterPhoneNoteTemplate).PhoneEntryBody%>
                                            </td>
                                            <td nowrap align="left"style="width:10px;">
                                                <%#CType(Container.DataItem, MatterPhoneNoteTemplate).IsActive%>
                                            </td>
                                            <td nowrap style="width:10px;">
                                                &nbsp;
                                            </td>
                                        </a>
                                    </tr>
                            </itemtemplate>
                        </asp:repeater>
                    </tbody>
                </table>
            
            <!-- End Matter Phone Note Template List -->
            </td>
            
        </tr>
    </table>
    
    <asp:HiddenField ID="txtSelected" runat="server" />
    <asp:HiddenField ID="txtSortField" runat="server" />
    <asp:LinkButton ID="lnkDeleteDoc" runat="server" />
    <asp:LinkButton ID="lnkResort" runat="server" />
</asp:Content>