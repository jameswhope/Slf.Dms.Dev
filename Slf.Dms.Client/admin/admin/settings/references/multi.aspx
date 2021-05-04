<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="multi.aspx.vb" Inherits="admin_settings_references_multi" title="DMP - Admin Settings - References" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>    
<script type="text/javascript">

    var ids = new Array();

    var txtSelected = null;
    var lnkDeleteConfirm = null;
    var _URLLocation = gup('id'); 
       
   function gup(name)
    {  
        name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");  
        var regexS = "[\\?&]"+name+"=([^&#]*)";  
        var regex = new RegExp( regexS );  
        var results = regex.exec( window.location.href );  
        if( results == null )    
             return "";  
        else    
             return results[1];
     }
  

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
                tbl.getAttribute("lastTr").style.backgroundColor = "#ffffff";
            }

            //if the mouse is over the table, set hover to current tr
            if (over)
            {
                var curTr = obj.parentElement;
                curTr.style.backgroundColor = "#e6e6e6";
                tbl.setAttribute("lastTr", curTr);
            }
        }
    }
    function RowClick(ID)
    {
         if(_URLLocation == 8)
        {  
           window.navigate("<%= ResolveUrl("~/admin/settings/references/agencys.aspx?id=") %>" + ID);
         }
        if(_URLLocation == 10)
        {  
           window.navigate("<%= ResolveUrl("~/admin/settings/references/settlementatty.aspx?id=") %>" + ID);
         }
//        else
//        {
//            window.navigate("<%= ResolveUrl("~/admin/settings/references/single.aspx?id=" & _referenceid & "&rid=") %>" + ID);
//        }
    }
   
    function Record_Add()
    {
         
        if(_URLLocation == 10)
        {  
            window.navigate("<%= ResolveUrl("~/admin/settings/references/settlementatty.aspx") %>");
         }
        else if (_URLLocation == 8)
        {  
            window.navigate("<%= ResolveUrl("~/admin/settings/references/Agencys.aspx?id=a") %>");
         } 
        else
       {
            window.navigate("<%= ResolveUrl("~/admin/settings/references/single.aspx?id=" & _referenceid & "&a=a") %>");
        } 
     }
    function Record_DeleteConfirm()
    {
        LoadControls();

        if (!lnkDeleteConfirm.disabled)
        {
             var url = '<%= ResolveUrl("~/delete.aspx?t=" & _deletetitle & "&p=" & _deletetext) %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "<%= _deletetitle%>",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 350, width: 450});      

        }
    }
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
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

        txtSelected.value = ids.join(",");

        /*if (txtSelected.value.length > 0)
        {
            lnkDeleteConfirm.disabled = false;
        }
        else
        {
            lnkDeleteConfirm.disabled = true;
        }*/
    }
    function LoadControls()
    {
        if (lnkDeleteConfirm == null)
        {
            lnkDeleteConfirm = document.getElementById("<%= lnkDeleteConfirm.ClientID %>");
        }

        if (txtSelected == null)
        {
            txtSelected = document.getElementById("<%= txtSelected.ClientID %>");
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
    function CheckAll(obj)
    {
        ClearArray();

	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (c = 1; c < table.rows.length; c++)
	    {
		    var off = table.rows[c].cells[0].childNodes(0);
		    var on = table.rows[c].cells[0].childNodes(1);
		    var chk = table.rows[c].cells[0].childNodes(2);

		    off.style.display = "none";
		    on.style.display = "inline";
		    chk.checked = true;
	    }
    }
    function UncheckAll(obj)
    {
	    var table = obj.parentNode.parentNode.parentNode.parentNode;

	    for (u = 1; u < table.rows.length; u++)
	    {
		    var off = table.rows[u].cells[0].childNodes(0);
		    var on = table.rows[u].cells[0].childNodes(1);
		    var chk = table.rows[u].cells[0].childNodes(2);

		    on.style.display = "none";
		    off.style.display = "inline";
		    chk.checked = false;
	    }
    }

    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a runat="server" class="lnk" style="color: #666666;" href="~/admin/default.aspx">Admin</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/default.aspx">Settings</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/references/default.aspx">References</a>&nbsp;>&nbsp;<asp:Label id="lblTitle" runat="server"></asp:Label></td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell"><asp:Label id="lblInfoBox" runat="server"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="background-color:#f3f3f3;padding: 5 5 5 5;">
                            <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="color:rgb(50,112,163);"><asp:Label id="lblTitle2" runat="server"></asp:Label></td>
                                    <td align="right"><asp:Panel runat="server" id="pnlDelete"><a class="lnk" id="lnkDeleteConfirm" disabled="disabled" runat="server" href="javascript:Record_DeleteConfirm();">Delete</a>&nbsp;&nbsp;|&nbsp;&nbsp;</asp:Panel><a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:Literal runat="server" id="ltrGrid"></asp:Literal>
                <asp:Label runat="server" id="lblNoRecords" style="color:#666666;width:100%;text-align:center;padding: 15 5 5 5;"></asp:Label>
                <input type="hidden" runat="server" id="txtSelected"/>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>

</asp:Content>