<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false"
    CodeFile="AddEditPhoneNote.aspx.vb" Inherits="admin_settings_AddEditPhoneNote"
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
            
            ShowMessage('Matter phone note already exists, please choose another one.');
            AddBorder(typeID);
            return;
        }
        else if (InArray(docIDs, typeID.value) >= 0)
        {
            ShowMessage('Matter phone note already exists, please choose another one.');
            AddBorder(typeID);
            return;
        }
        else if (typeID.value.length <= 0)
        {
            ShowMessage('Please enter a matter phone note.');
            AddBorder(typeID);
            return;
        }
        if (docName.value.length <= 0)
        {
            ShowMessage('Please enter a matter phone note description.');
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
        
    }
    </script>

    <table id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;" border="0"
        cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a
                    runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a
                        runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references">References</a>&nbsp;>&nbsp;<a id="A1"
                        runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/MatterPhoneNotes.aspx">Matter Phone Notes</a>&nbsp;>&nbsp;<asp:Label
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
                                        Matter Phone Entry ID:
                                    </td>
                                    <td width="70%">
                                        <asp:Label ID="lblID" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Phone Entry:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTypeID" Width="300px" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Phone Entry Desc:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtName" Width="300px" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry" valign="top">
                                        Phone Entry Body:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBody" Width="300px" TextMode="MultiLine" Rows="7" CssClass="srefEntry" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="srefEntry">
                                        Is Active
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" runat="server" />
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
                </table>
            </td>
        </tr>
    </table>
    <asp:LinkButton ID="lnkCancelAndClose" runat="server" />
    <asp:LinkButton ID="lnkSave" runat="server" />
    <asp:LinkButton ID="lnkDelete" runat="server" />
</asp:Content>
