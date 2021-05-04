<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="singlemattertype.aspx.vb" Inherits="admin_settings_singlemattertype"
    Title="DMP - Admin Settings - References" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <link href="<%= ResolveUrl("~/css/grid.css") %>" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\isvalid.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\allow.js") %>"></script>

    <script type="text/javascript" src="<%= ResolveUrl("~\jscript\validation\display.js") %>"></script>
    <script type="text/javascript">
    function show(id,i)
    {
    if(i==0)
    {
        document.getElementById('idp'+id).style.display="none"; 
        document.getElementById('idm'+id).style.display="inline";
        document.getElementById('dv'+id).style.display="inline";
    }
    else
     if(i==1)
    {
        document.getElementById('idp'+id).style.display="inline"; 
        document.getElementById('idm'+id).style.display="none";
         document.getElementById('dv'+id).style.display="none";
    }
    }
    
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
	    var docid = document.getElementById('<%=hdnInitialAssociations.ClientID %>').value; 
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
                    //elements[i].checked = false;
                    //elements[i].disabled = true;
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
        
        var docNameIdx = InArray(docNames, typeID.value);
        
        if (docNameIdx >= 0 && action == 'a')
        {
            var docID = docNames[docNameIdx].substring(docNames[docNameIdx].indexOf('|') + 1);
            
            ShowMessage('Matter Type already exists, please choose another one.');
            AddBorder(typeID);
            return;
        }
        else if (InArray(docIDs, typeID.value) >= 0)
        {
            ShowMessage('Matter Type already exists, please choose another one.');
            AddBorder(typeID);
            return;
        }
        else if (typeID.value.length <= 0)
        {
            ShowMessage('Please enter a matter type.');
            AddBorder(typeID);
            return;
        }
        if (docName.value.length <= 0)
        {
            ShowMessage('Please enter a matter type description.');
            AddBorder(docName);
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
        // ValidateAssociations();
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a
                        runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<a id="A1"
                        runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/mattertypes.aspx">Matter Types</a>&nbsp;>&nbsp;<asp:Label
                            ID="lblTitle" runat="server" Style="color: #666666;"></asp:Label>
            </td>
        </tr>
        <tr>
            <td valign="top" width="100%">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" >
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
                                        Matter Type ID:
                                    </td>
                                    <td width="70%">
                                        <asp:Label ID="lblID" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Matter Type:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTypeID" Width="300px" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Matter Type Descr:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtName" Width="300px" TextMode="MultiLine" Rows="3" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Is Active
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" runat="server" />
                                        <asp:DropDownList Visible="false" ID="ddlDocFolder" CssClass="srefEntry" onchange="javascript:ValidateAssociations();"
                                            runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Matter Type:
                                    </td>
                                    <td>
                                        <asp:DropDownList Width="300px" ID="ddlMatterGroup" CssClass="srefEntry" runat="server" />
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
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" width="100%">
                            <table class="srefEntry" border="0" cellpadding="0" cellspacing="3" width="100%" >
                                <tr>
                                    <td class="srefHeaderCell" colspan="2">
                                        Task Types
                                    </td>
                                </tr>
                                <asp:Repeater ID="rptAssociations" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td colspan="2" width="100%">
                                                <img id='idp<%#DataBinder.Eval(Container.DataItem, "TaskTypeCategoryID")%>' src='<%= ResolveUrl("~/images/plus.gif") %>'
                                                    onclick='javascript:show(<%#DataBinder.Eval(Container.DataItem, "TaskTypeCategoryID")%>,0)' />
                                                <img id='idm<%#DataBinder.Eval(Container.DataItem, "TaskTypeCategoryID")%>' src='<%= ResolveUrl("~/images/minus.gif") %>'
                                                    onclick='javascript:show(<%#DataBinder.Eval(Container.DataItem, "TaskTypeCategoryID")%>,1)'
                                                    style="display: none" />
                                                <b><%#DataBinder.Eval(Container.DataItem, "Name")%></b>
                                               
                                                <div id='dv<%#DataBinder.Eval(Container.DataItem, "TaskTypeCategoryID")%>' style="display: none;
                                                    padding-right: 200px;width:100%;">
                                                    <table class="srefTable" width="100%" cellpadding="0" cellspacing="0" >
                                                        <asp:Repeater ID="rptTaskType" runat="server" >
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td width="70%">
                                                                        <input type="checkbox" runat="server"  id="chkTaskType" checked ='<%#DataBinder.Eval(Container.DataItem, "Checked") %>'/>
                                                                        &nbsp;&nbsp;<%#DataBinder.Eval(Container.DataItem, "Name")%>
                                                                    </td>
                                                                    <td width="30%"><input type="hidden"  runat="server"  id="hdnTaskTypeId" value ='<%#DataBinder.Eval(Container.DataItem, "TaskTypeID") %>' />
                                                                        <input type="checkbox" runat="server"  id="chkTaskTypeAuto"  checked ='<%#DataBinder.Eval(Container.DataItem, "isauto") %>' /><label>Is Auto</label>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                </div>
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
    <asp:HiddenField ID="hdnInitialAssociations" runat="server" />
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
</asp:Content>
