<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="singledocument.aspx.vb" Inherits="admin_settings_singledocument" title="DMP - Admin Settings - References" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
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
	
	function ValidateAssociations()
	{
	    var docid = document.getElementById('<%=ddlDocFolder.ClientID %>').value;
	    var elements = document.getElementsByTagName('input');
	    var ids = new Array();
	    var tempDocTypeID;
	    
	    for (var i = 0; i < elements.length; i++)
	    {
	        if (elements[i].id.indexOf('chkAssociation') >= 0)
	        {
	            ids = elements[i].value.split(',');
	            
                if (InArray(ids, docid) < 0)
                {
                    elements[i].checked = false;
                    elements[i].disabled = true;
                }
                else
                {
                    elements[i].disabled = false;
                }
                
                UpdateString(elements[i]);
	        }
	    }
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
        var typeID = document.getElementById('<%=txtTypeID.ClientID %>');
        var docName = document.getElementById('<%=txtName.ClientID %>');
        var strDoc = '<%=DocIDs %>';
        var strName = '<%=DocNames %>';
        var docIDs = strDoc.split(',');
        var docNames = strName.split(',');
        var action = '<%=Action %>';
        
        var docNameIdx = InArray(docNames, docName.value);
        
        if (docNameIdx >= 0 && action == 'a')
        {
            var docID = docNames[docNameIdx].substring(docNames[docNameIdx].indexOf('|') + 1);
            
            ShowMessage('That <a class="lnk" href="~/admin/settings/singledocument.aspx?a=e&id=' + docID + '" runat="server">Document Name</a> already exists, please choose another one.');
            return;
        }
        else if (InArray(docIDs, typeID.value) >= 0)
        {
            ShowMessage('Document Type ID already exists, please choose another one.');
            return;
        }
        else if (docName.value.length <= 0)
        {
            ShowMessage('Please choose a document name.');
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
    
    window.onload = function ()
    {
        ValidateAssociations();
    }
    </script>
    
    <table id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<asp:label id="lblTitle" runat="server" style="color: #666666;"></asp:label></td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
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
                    <tr>
                        <td>
                            <table class="srefTable" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td class="srefHeaderCell" colspan="2">
                                        General Information
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        ID:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblID" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Type ID:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTypeID" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Name:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtName" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Folder
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlDocFolder" CssClass="srefEntry" onchange="javascript:ValidateAssociations();" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table class="srefTable" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td class="srefHeaderCell" colspan="2">
                                        Audit Trail
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Created:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCreated" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Created By:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblCreatedBy" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Last Modified:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLastModified" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntryTitleCell">
                                        Last Modified By:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLastModifiedBy" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="height:25px;">
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="srefTable" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td class="srefHeaderCell" colspan="2">
                                        Associations
                                    </td>
                                </tr>
                                <asp:Repeater ID="rptAssociations" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td colspan="2">
                                                <input type="checkbox" id="chkAssociation_<%#DataBinder.Eval(Container.DataItem, "ScanRelationTypeID") %>" value="<%#DataBinder.Eval(Container.DataItem, "DocFolderIDs") %>" <%#DataBinder.Eval(Container.DataItem, "Checked") %> onclick="javascript:UpdateString(this);"><label for="chkAssociation_<%#DataBinder.Eval(Container.DataItem, "ScanRelationTypeID") %>">&nbsp;&nbsp;<%#DataBinder.Eval(Container.DataItem, "DisplayName") %></label>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <asp:HiddenField ID="hdnAssociations" runat="server" />
    
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
</asp:Content>